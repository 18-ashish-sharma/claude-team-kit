#!/usr/bin/env bash
# Secret guard. Two ways to run it:
#
#   1. As a Claude Code PreToolUse hook (no arguments): reads the hook JSON on
#      stdin and, when the Bash command is a `git commit` or `git push`, scans
#      what is about to leave the machine. Exit 2 blocks the command.
#   2. As a git hook: `secret-guard.sh commit` or `secret-guard.sh push`,
#      run from inside the repository.
#
# Uses gitleaks when it is installed, and a small built-in pattern list when
# it is not. Set TEAM_KIT_SECRET_GUARD=off to switch it off.
set -uo pipefail

[ "${TEAM_KIT_SECRET_GUARD:-on}" = "off" ] && exit 0

MODE="${1:-hook}"
DIR="$PWD"

if [ "$MODE" = "hook" ]; then
  INPUT=$(cat)
  command -v python3 >/dev/null 2>&1 || exit 0
  PARSED=$(printf '%s' "$INPUT" | python3 -c '
import json, sys
try:
    d = json.load(sys.stdin)
except Exception:
    sys.exit(0)
print(d.get("cwd") or "")
print((d.get("tool_input") or {}).get("command") or "")
' 2>/dev/null) || exit 0
  DIR=$(printf '%s\n' "$PARSED" | sed -n 1p)
  CMD=$(printf '%s\n' "$PARSED" | sed 1d)
  [ -n "$DIR" ] || DIR="$PWD"
  if printf '%s' "$CMD" | grep -Eq '(^|[;&|[:space:]])git([[:space:]]+-[^[:space:]]+([[:space:]]+[^-][^[:space:]]*)?)*[[:space:]]+commit([[:space:]]|$)'; then
    MODE=commit
  elif printf '%s' "$CMD" | grep -Eq '(^|[;&|[:space:]])git([[:space:]]+-[^[:space:]]+([[:space:]]+[^-][^[:space:]]*)?)*[[:space:]]+push([[:space:]]|$)'; then
    MODE=push
  else
    exit 0
  fi
fi

cd "$DIR" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

# What is about to leave: file names and added lines.
if [ "$MODE" = "commit" ]; then
  # Staged changes plus tracked edits (covers `git commit -a`).
  if git rev-parse --verify HEAD >/dev/null 2>&1; then
    FILES=$(git diff HEAD --name-only --diff-filter=ACMR 2>/dev/null)
    PATCH=$(git diff HEAD --unified=0 --no-color 2>/dev/null)
  else
    FILES=$(git diff --cached --name-only --diff-filter=ACMR 2>/dev/null)
    PATCH=$(git diff --cached --unified=0 --no-color 2>/dev/null)
  fi
else
  if git rev-parse --verify '@{u}' >/dev/null 2>&1; then
    RANGE='@{u}..HEAD'
    FILES=$(git diff --name-only --diff-filter=ACMR "$RANGE" 2>/dev/null)
    PATCH=$(git log -p --unified=0 --no-color "$RANGE" 2>/dev/null)
  else
    # No upstream yet: everything not already on a remote.
    FILES=$(git log --name-only --pretty=format: HEAD --not --remotes 2>/dev/null | sort -u)
    PATCH=$(git log -p --unified=0 --no-color HEAD --not --remotes 2>/dev/null)
  fi
fi

ADDED=$(printf '%s\n' "$PATCH" | grep -E '^\+' | grep -Ev '^\+\+\+ ' || true)
PROBLEMS=""

# 1. Files that should never be committed.
BAD_FILES=$(printf '%s\n' "$FILES" | grep -Ei '(^|/)(\.env(\.[^/]*)?|id_(rsa|dsa|ecdsa|ed25519)|[^/]*\.(pem|p12|pfx|jks|keystore|mobileprovision)|kubeconfig[^/]*|credentials\.json|service-account[^/]*\.json|\.npmrc|\.netrc)$' \
  | grep -Eiv '(^|/)\.env\.(example|sample|template|dist)$' || true)
if [ -n "$BAD_FILES" ]; then
  PROBLEMS="${PROBLEMS}Files that usually hold secrets:
$(printf '%s\n' "$BAD_FILES" | sed 's/^/  - /')
"
fi

# 2. Secret-looking content in the added lines.
if [ -n "$ADDED" ]; then
  # Built-in list: always runs. Reports the kind of value, never the value.
  KINDS=""
  kind() { printf '%s\n' "$ADDED" | grep -Eq -e "$2" && KINDS="${KINDS}  - $1
"; }
  kind "AWS access key id"            'AKIA[0-9A-Z]{16}'
  kind "private key block"            '-----BEGIN [A-Z ]*PRIVATE KEY-----'
  kind "GitHub token"                 'gh[pousr]_[A-Za-z0-9]{36,}|github_pat_[A-Za-z0-9_]{40,}'
  kind "Anthropic or OpenAI API key"  'sk-ant-[A-Za-z0-9_-]{20,}|sk-(proj-)?[A-Za-z0-9_-]{32,}'
  kind "Slack token"                  'xox[baprs]-[A-Za-z0-9-]{10,}'
  kind "Google API key"               'AIza[0-9A-Za-z_-]{35}'
  kind "JSON web token"               'eyJ[A-Za-z0-9_-]{15,}\.eyJ[A-Za-z0-9_-]{15,}\.[A-Za-z0-9_-]{10,}'
  kind "database or queue URL with a password" '(postgres(ql)?|mysql|mongodb(\+srv)?|redis|amqps?)://[^:/[:space:]]+:[^@[:space:]]{6,}@[^[:space:]]*[a-z0-9]\.[a-z]{2,}'
  if [ -n "$KINDS" ]; then
    PROBLEMS="${PROBLEMS}Secret-looking values in the added lines:
${KINDS}"
  fi

  # gitleaks: a much larger rule set, when it is installed.
  if command -v gitleaks >/dev/null 2>&1; then
    REPORT=$(printf '%s\n' "$ADDED" | gitleaks stdin --no-banner --no-color --redact -v --exit-code 9 2>&1)
    if [ $? -eq 9 ]; then
      PROBLEMS="${PROBLEMS}gitleaks findings (values redacted):
$(printf '%s\n' "$REPORT" | grep -E '^(RuleID|Finding|Line):' | head -30 | sed 's/^/  /')
"
    fi
  elif [ -z "$KINDS" ]; then
    : # nothing found by the built-in list, and no gitleaks to look further
  fi
fi

[ -z "$PROBLEMS" ] && exit 0

{
  echo "team-kit secret guard: this git $MODE was stopped."
  echo
  printf '%s' "$PROBLEMS"
  echo
  echo "What to do: take the value out of the change, keep it in an untracked .env or a secret manager,"
  echo "and if it was ever pushed or shared, rotate it. A false alarm can be let through for one command"
  echo "with TEAM_KIT_SECRET_GUARD=off, after a person has looked at it."
} >&2
exit 2
