#!/usr/bin/env bash
# Installs the third-party skills listed in catalog/extra-skills.tsv.
# Each skill is fetched from its author's own repository, at install time,
# into your skills folder. Nothing third-party is stored in this kit.
#
#   install-extra-skills.sh --list                 show the catalogue
#   install-extra-skills.sh                        install every skill with a clear licence
#   install-extra-skills.sh --group design         one group: engineering, design, threejs, testing, data, workflow
#   install-extra-skills.sh --only senior-qa,d3-viz
#   install-extra-skills.sh --include-unlicensed   also fetch skills whose repository states no licence
#   install-extra-skills.sh --force                replace skills that are already installed
#   install-extra-skills.sh --dir <folder>         install somewhere other than ~/.claude/skills
set -uo pipefail

KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CATALOG="$KIT/catalog/extra-skills.tsv"
TARGET="$HOME/.claude/skills"
GROUP=""; ONLY=""; FORCE=0; UNLICENSED=0; LIST=0

while [ $# -gt 0 ]; do
  case "$1" in
    --list) LIST=1 ;;
    --group) GROUP="$2"; shift ;;
    --only) ONLY=",$2,"; shift ;;
    --dir) TARGET="$2"; shift ;;
    --force) FORCE=1 ;;
    --include-unlicensed) UNLICENSED=1 ;;
    -h|--help) sed -n 2,13p "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 1 ;;
  esac
  shift
done

rows() { grep -v '^#' "$CATALOG" | grep -v '^[[:space:]]*$'; }

if [ $LIST -eq 1 ]; then
  rows | awk -F'\t' '{printf "%-28s %-12s %-11s %s\n    %s\n", $1, $2, $6, "github.com/" $3, $7}'
  echo; echo "$(rows | wc -l | tr -d ' ') skills. Licences were read from each repository; check the source for current terms."
  exit 0
fi

command -v git >/dev/null 2>&1 || { echo "git is required" >&2; exit 1; }
mkdir -p "$TARGET"
WORK=$(mktemp -d); trap 'rm -rf "$WORK"' EXIT
OK=0; SKIP=0; BAD=0

selected() { # $1 skill, $2 group, $3 licence
  [ -n "$ONLY" ] && { case "$ONLY" in *",$1,"*) ;; *) return 1 ;; esac; }
  [ -n "$GROUP" ] && [ "$2" != "$GROUP" ] && return 1
  return 0
}

# One shallow clone per repository and ref, then copy each skill folder out.
rows | awk -F'\t' '{print $3 "\t" $4}' | sort -u | while IFS=$'\t' read -r REPO REF; do
  WANT=$(rows | awk -F'\t' -v r="$REPO" -v f="$REF" '$3==r && $4==f')
  NEED=""
  while IFS=$'\t' read -r SKILL GRP _ _ SUB LIC _; do
    selected "$SKILL" "$GRP" "$LIC" || continue
    if [ "$LIC" = "none found" ] && [ $UNLICENSED -eq 0 ]; then
      echo "skip     $SKILL  (github.com/$REPO states no licence; add --include-unlicensed to fetch it anyway)"; continue
    fi
    if [ -e "$TARGET/$SKILL" ] && [ $FORCE -eq 0 ]; then
      echo "present  $SKILL"; continue
    fi
    NEED="${NEED}${SKILL}	${SUB}
"
  done <<EOF
$WANT
EOF
  [ -z "$NEED" ] && continue

  CLONE="$WORK/$(echo "$REPO-$REF" | tr '/' '_')"
  if [ "$REF" = "-" ]; then
    git clone --quiet --depth 1 "https://github.com/$REPO.git" "$CLONE" 2>/dev/null
  else
    git clone --quiet --depth 1 --branch "$REF" "https://github.com/$REPO.git" "$CLONE" 2>/dev/null
  fi
  if [ ! -d "$CLONE" ]; then
    printf '%s' "$NEED" | while IFS=$'\t' read -r SKILL _; do echo "FAILED   $SKILL  (could not fetch github.com/$REPO${REF:+ at $REF})"; done
    continue
  fi

  printf '%s' "$NEED" | while IFS=$'\t' read -r SKILL SUB; do
    SRC="$CLONE/$SUB"
    if [ ! -f "$SRC/SKILL.md" ]; then
      echo "FAILED   $SKILL  (no SKILL.md at $SUB in github.com/$REPO; the repository may have moved it)"; continue
    fi
    rm -rf "$TARGET/$SKILL.tmp.$$"
    mkdir -p "$TARGET/$SKILL.tmp.$$"
    # Copy the skill folder without git metadata; keep the upstream licence beside it.
    (cd "$SRC" && tar --exclude=.git --exclude=.github -cf - .) | (cd "$TARGET/$SKILL.tmp.$$" && tar -xf -)
    for L in LICENSE LICENSE.md LICENSE.txt; do
      [ -f "$CLONE/$L" ] && [ ! -f "$TARGET/$SKILL.tmp.$$/$L" ] && cp "$CLONE/$L" "$TARGET/$SKILL.tmp.$$/UPSTREAM-$L"
    done
    printf 'source: https://github.com/%s\nref: %s\npath: %s\ncommit: %s\nfetched: %s\n' \
      "$REPO" "$REF" "$SUB" "$(git -C "$CLONE" rev-parse --short HEAD)" "$(date +%Y-%m-%d)" > "$TARGET/$SKILL.tmp.$$/.source"
    rm -rf "$TARGET/$SKILL"
    mv "$TARGET/$SKILL.tmp.$$" "$TARGET/$SKILL"
    echo "installed $SKILL  (github.com/$REPO)"
  done
done | tee "$WORK/log"

echo
echo "installed: $(grep -c '^installed' "$WORK/log")   already present: $(grep -c '^present' "$WORK/log")   skipped: $(grep -c '^skip' "$WORK/log")   failed: $(grep -c '^FAILED' "$WORK/log")"
echo "into: $TARGET"
grep -q '^FAILED' "$WORK/log" && exit 1
exit 0
