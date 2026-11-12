#!/usr/bin/env bash
# One-step setup. Installs this kit and, if you want them, the upstream tool
# sets it is designed to sit beside. Upstream projects are installed from
# their own repositories, never copied here, so they keep receiving updates.
#
#   ./setup.sh            install team-kit, then ask about each upstream set
#   ./setup.sh --all      install everything without asking
#   ./setup.sh --kit      install team-kit only
#   ./setup.sh --status   show what is installed; changes nothing
set -uo pipefail

KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE="${1:-ask}"

CLAUDE=$(command -v claude 2>/dev/null || true)
[ -x "$HOME/.local/bin/claude" ] && CLAUDE="$HOME/.local/bin/claude"
if [ -z "$CLAUDE" ]; then
  echo "Claude Code is not installed. Get it first: https://docs.claude.com/en/docs/claude-code" >&2
  exit 1
fi

say()  { printf '\n\033[1m%s\033[0m\n' "$*"; }
FAILED=""
want() {
  case "$MODE" in
    --all) say "$1"; return 0 ;;
    --kit) return 1 ;;
  esac
  printf '\n%s [y/N] ' "$1"; read -r a; [ "$a" = y ] || [ "$a" = Y ]
}
# Run a plugin command, show its last line, and remember any failure.
run() { # run <label> <claude plugin args...>
  local label="$1" out rc; shift
  out=$("$CLAUDE" plugin "$@" 2>&1); rc=$?
  if [ $rc -eq 0 ] || printf '%s' "$out" | grep -qi 'already'; then
    printf '  ok      %s\n' "$label"
  else
    printf '  FAILED  %s\n%s\n' "$label" "$(printf '%s\n' "$out" | tail -3 | sed 's/^/          /')"
    FAILED="${FAILED}  - ${label}
"
  fi
}
market() { run "marketplace $1" marketplace add "$1"; }
plugin() { run "plugin $1" install "$1"; }

if [ "$MODE" = "--status" ]; then
  say "Marketplaces";  "$CLAUDE" plugin marketplace list 2>&1
  say "Plugins";       "$CLAUDE" plugin list 2>&1
  say "gstack";        [ -d "$HOME/.claude/skills/gstack" ] && echo "installed at ~/.claude/skills/gstack" || echo "not installed"
  say "Helpers"
  for t in git gh gitleaks pandoc bun node docker; do
    command -v "$t" >/dev/null 2>&1 && echo "  ok       $t" || echo "  missing  $t"
  done
  exit 0
fi

say "1. team-kit"
# Prefer the published repository, so `claude plugin marketplace update` keeps working
# after this folder is moved or deleted. Fall back to this folder when offline.
if "$CLAUDE" plugin marketplace add "18-ashish-sharma/claude-team-kit" >/dev/null 2>&1 \
   || "$CLAUDE" plugin marketplace list 2>/dev/null | grep -q 'claude-team-kit'; then
  printf '  ok      marketplace claude-team-kit\n'
else
  market "$KIT"
fi
plugin "team-kit@claude-team-kit"

if want "2. Install ECC (agents, reviewers and workflow skills, MIT, github.com/affaan-m/ECC)?"; then
  market "https://github.com/affaan-m/ECC.git"; plugin "ecc@ecc"
fi

if want "3. Install superpowers, context7, frontend-design and code-simplifier (official Claude plugins)?"; then
  market "anthropics/claude-plugins-official"
  for p in superpowers context7 frontend-design code-simplifier; do plugin "$p@claude-plugins-official"; done
fi

if want "4. Install gstack (browse, QA, ship, make-pdf, diagram; MIT, github.com/garrytan/gstack; needs Bun)?"; then
  if [ -d "$HOME/.claude/skills/gstack" ]; then
    echo "gstack is already installed. Update it from inside Claude Code with /gstack-upgrade."
  elif ! command -v bun >/dev/null 2>&1; then
    echo "Bun is missing. Install it (https://bun.sh), then run this step again."
  else
    git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git "$HOME/.claude/skills/gstack" \
      && (cd "$HOME/.claude/skills/gstack" && ./setup)
  fi
fi

if want "5. Install the motion and animation sets (genjutsu, gsap-skills; both MIT)?"; then
  market "AThevon/genjutsu";        plugin "genjutsu@genjutsu"
  market "greensock/gsap-skills";   plugin "gsap-skills@gsap-skills"
fi

if want "6. Install Claude's document skills (Word, PDF, PowerPoint, Excel; from github.com/anthropics/skills)?"; then
  market "anthropics/skills"; plugin "document-skills@anthropic-agent-skills"
fi

if want "7. Install the 53 extra community skills (senior engineer roles, cloud and DevOps, UI design, three.js, Playwright; each fetched from its author's repository)?"; then
  "$KIT/scripts/install-extra-skills.sh" | grep -v -e '^installed ' -e '^present ' \
    || FAILED="${FAILED}  - some community skills (run scripts/install-extra-skills.sh to see which)
"
  echo "See the full list any time: scripts/install-extra-skills.sh --list"
fi

say "8. Helper tools"
for t in gitleaks pandoc; do
  if command -v "$t" >/dev/null 2>&1; then echo "  ok       $t"
  else echo "  missing  $t   (brew install $t)"; fi
done

if [ -n "$FAILED" ]; then
  say "Finished with problems"
  printf 'These steps did not complete:\n%s\nEverything else was installed. Fix the cause and run ./setup.sh again; it is safe to re-run.\n' "$FAILED"
else
  say "Done"
fi
cat <<EOF
Restart Claude Code, then try:
  /team-kit:team-kit-guide       what is in the kit and which skill to use when
  /team-kit:disk-cleanup         see what is filling the disk
  /team-kit:code-to-plain-doc    turn code into a document non-developers can read

To protect a repository for everyone who commits to it (not only AI sessions):
  $KIT/scripts/install-git-guard.sh /path/to/repo

To start your own rules file from the template:
  cp -n $KIT/templates/CLAUDE.md ~/.claude/CLAUDE.md     (-n keeps an existing file untouched)
EOF
[ -z "$FAILED" ]
