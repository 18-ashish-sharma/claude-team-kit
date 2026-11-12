#!/usr/bin/env bash
# Checks THIS repository before anything is published:
#   1. gitleaks over the files and the full git history;
#   2. a private word list, if you keep one. Put client names, people, internal
#      hosts and project names in `.private-denylist` (one per line). That file
#      is git-ignored, so the list itself never becomes public.
# Exit 1 on any hit.
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
FAIL=0

if command -v gitleaks >/dev/null 2>&1; then
  gitleaks dir . --no-banner --redact || FAIL=1
  if git rev-parse --verify HEAD >/dev/null 2>&1; then
    gitleaks git . --no-banner --redact || FAIL=1
  fi
else
  echo "gitleaks is not installed (brew install gitleaks): secret scan skipped." >&2
  FAIL=1
fi

if [ -f .private-denylist ]; then
  WORDS=$(grep -Ev '^[[:space:]]*(#|$)' .private-denylist)
  if [ -n "$WORDS" ]; then
    HITS=$(git ls-files -co --exclude-standard -z | xargs -0 grep -nIiF -f <(printf '%s\n' "$WORDS") 2>/dev/null || true)
    if [ -n "$HITS" ]; then
      echo "Private words found in files:"; printf '%s\n' "$HITS" | cut -c1-160; FAIL=1
    fi
    if git rev-parse --verify HEAD >/dev/null 2>&1; then
      LOGHITS=$(git log --all --format='%h %an <%ae> %s%n%b' | grep -niF -f <(printf '%s\n' "$WORDS") || true)
      if [ -n "$LOGHITS" ]; then
        echo "Private words found in commit messages or authors:"; printf '%s\n' "$LOGHITS" | cut -c1-160; FAIL=1
      fi
    fi
  fi
else
  echo "note: no .private-denylist here, so only the secret scan ran."
fi

# Absolute home paths give away a username.
PATHS=$(git ls-files -co --exclude-standard -z | xargs -0 grep -nIE '/(Users|home)/[a-z][a-z0-9._-]+/' 2>/dev/null | grep -Ev '/(Users|home)/(you|me|name|user|username|example)/' || true)
if [ -n "$PATHS" ]; then
  echo "Absolute home paths found:"; printf '%s\n' "$PATHS" | cut -c1-160; FAIL=1
fi

[ $FAIL -eq 0 ] && echo "scan-private: clean"
exit $FAIL
