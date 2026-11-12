#!/usr/bin/env bash
# Disk report: READ-ONLY. Shows where the space went; deletes nothing.
# Usage: disk-report.sh [project-root ...]   (default: current directory)
set -uo pipefail

ROOTS=("$@"); [ ${#ROOTS[@]} -eq 0 ] && ROOTS=("$PWD")
STALE_DAYS="${STALE_DAYS:-14}"

size() { [ -e "$1" ] && du -sh "$1/" 2>/dev/null | awk '{print $1}'; }
row()  { s=$(size "$2"); [ -n "${s:-}" ] && printf '  %-8s %-34s %s\n' "$s" "$1" "$2"; }

echo "== Disk =="
df -Ph "$HOME" | awk 'NR==2{printf "  %s used of %s, %s free (%s)\n",$3,$2,$4,$5}'

echo
echo "== Caches that rebuild themselves (safe to clear) =="
row "npm cache"            "$HOME/.npm/_cacache"
row "yarn cache"           "$HOME/Library/Caches/Yarn"
row "yarn berry cache"     "$HOME/.yarn/berry/cache"
row "pnpm store"           "$HOME/Library/pnpm/store"
row "bun cache"            "$HOME/.bun/install/cache"
row "pip cache"            "$HOME/Library/Caches/pip"
row "pip cache (linux)"    "$HOME/.cache/pip"
row "uv cache"             "$HOME/.cache/uv"
row "Homebrew downloads"   "$HOME/Library/Caches/Homebrew"
row "Gradle caches"        "$HOME/.gradle/caches"
row "Gradle daemon logs"   "$HOME/.gradle/daemon"
row "Maven repository"     "$HOME/.m2/repository"
row "CocoaPods cache"      "$HOME/Library/Caches/CocoaPods"
row "Xcode DerivedData"    "$HOME/Library/Developer/Xcode/DerivedData"
row "Xcode archives"       "$HOME/Library/Developer/Xcode/Archives"
row "iOS device support"   "$HOME/Library/Developer/Xcode/iOS DeviceSupport"
row "iOS simulators"       "$HOME/Library/Developer/CoreSimulator/Devices"
row "Android emulators"    "$HOME/.android/avd"
row "Playwright browsers"  "$HOME/Library/Caches/ms-playwright"
row "Cypress binaries"     "$HOME/Library/Caches/Cypress"
row "Go build cache"       "$HOME/Library/Caches/go-build"
row "Cargo registry"       "$HOME/.cargo/registry"
row "Hugging Face models"  "$HOME/.cache/huggingface"
row "Trash"                "$HOME/.Trash"

echo
echo "== Assistant and tool data (look before clearing) =="
row "Claude session logs"  "$HOME/.claude/projects"
row "Claude plugin cache"  "$HOME/.claude/plugins/cache"
row "Temp: claude"         "/private/tmp/claude-$(id -u)"
row "System temp"          "${TMPDIR:-/tmp}"

if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  echo
  echo "== Docker (running) =="
  docker system df 2>/dev/null | sed 's/^/  /'
else
  echo
  echo "== Docker =="
  echo "  not running; its disk image still takes space:"
  row "Docker Desktop data" "$HOME/Library/Containers/com.docker.docker/Data"
fi

for ROOT in "${ROOTS[@]}"; do
  [ -d "$ROOT" ] || continue
  echo
  echo "== Project folders under $ROOT =="
  echo "  -- build output and dependencies not touched for ${STALE_DAYS}+ days (largest first) --"
  find "$ROOT" -maxdepth 6 -type d \
    \( -name node_modules -o -name .next -o -name dist -o -name build -o -name .turbo -o -name .expo \
       -o -name Pods -o -name .gradle -o -name target -o -name .venv -o -name venv -o -name __pycache__ \
       -o -name coverage -o -name .pytest_cache -o -name .mypy_cache -o -name .parcel-cache \) \
    -prune -mtime +"$STALE_DAYS" -print0 2>/dev/null \
    | xargs -0 du -sk 2>/dev/null | sort -rn | head -25 \
    | awk '{k=$1; $1=""; printf "  %7.1f MB %s\n", k/1024, $0}'

  echo "  -- git worktrees (a worktree with changes or unpushed commits is NOT safe to remove) --"
  find "$ROOT" -maxdepth 3 -name .git -type d -prune -print0 2>/dev/null | while IFS= read -r -d '' g; do
    repo=$(dirname "$g")
    git -C "$repo" worktree list --porcelain 2>/dev/null | awk '/^worktree /{print substr($0,10)}' | sed 1d | while IFS= read -r wt; do
      [ -d "$wt" ] || { echo "  missing   $wt  (stale entry: git worktree prune)"; continue; }
      dirty=$(git -C "$wt" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
      ahead=$(git -C "$wt" rev-list --count '@{u}..HEAD' 2>/dev/null || echo "no-upstream")
      printf '  %-8s %s  [changed files: %s, unpushed: %s]\n' "$(size "$wt")" "$wt" "$dirty" "$ahead"
    done
  done

  echo "  -- large files (over 200 MB) --"
  find "$ROOT" -maxdepth 6 -type f -size +200M -not -path '*/.git/*' -print0 2>/dev/null \
    | xargs -0 du -sh 2>/dev/null | sort -rh | head -15 | sed 's/^/  /'
done

echo
echo "Nothing was deleted. This is a report only."
