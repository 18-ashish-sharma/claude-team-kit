#!/usr/bin/env bash
# Installs the secret guard as pre-commit and pre-push hooks in a repository.
# Usage: install-git-guard.sh [path-to-repo]   (default: current directory)
# It works for everyone who commits there, with or without an AI assistant.
set -euo pipefail

KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO="${1:-$PWD}"
HOOKS=$(git -C "$REPO" rev-parse --git-path hooks)
case "$HOOKS" in /*) ;; *) HOOKS="$REPO/$HOOKS" ;; esac
mkdir -p "$HOOKS"

for h in pre-commit pre-push; do
  mode=${h#pre-}
  target="$HOOKS/$h"
  if [ -e "$target" ] && ! grep -q 'team-kit secret guard' "$target" 2>/dev/null; then
    echo "skip $h: a different hook is already there ($target). Add this line to it by hand:"
    echo "  \"$KIT/scripts/secret-guard.sh\" $mode || exit 1"
    continue
  fi
  cat > "$target" <<EOF
#!/usr/bin/env bash
# team-kit secret guard
exec "$KIT/scripts/secret-guard.sh" $mode
EOF
  chmod +x "$target"
  echo "installed $h in $HOOKS"
done
