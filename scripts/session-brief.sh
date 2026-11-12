#!/usr/bin/env bash
# Session briefing (SessionStart hook). Prints the few facts an assistant
# cannot guess and people otherwise repeat every session: today's date in the
# local time zone, the active GitHub account, the git identity of this repo,
# unfinished work, and how full the disk and memory are. Budget: about 1s.
set -uo pipefail

[ "${TEAM_KIT_SESSION_BRIEF:-on}" = "off" ] && exit 0

L=()
L+=("date: $(date '+%a, %d %b %Y %H:%M %Z')")

if [ -r "$HOME/.config/gh/hosts.yml" ]; then
  GH=$(awk '/^[[:space:]]+user:[[:space:]]+/{print $2; exit}' "$HOME/.config/gh/hosts.yml" 2>/dev/null)
  [ -n "${GH:-}" ] && L+=("gh active account: $GH")
fi

if ROOT=$(git rev-parse --show-toplevel 2>/dev/null); then
  BR=$(git -C "$ROOT" branch --show-current 2>/dev/null)
  EMAIL=$(git -C "$ROOT" config user.email 2>/dev/null)
  L+=("repo: $(basename "$ROOT") on '${BR:-detached}', commits as ${EMAIL:-<no email set>}")
  N=$(git -C "$ROOT" status --porcelain --untracked-files=no 2>/dev/null | wc -l | tr -d ' ')
  [ "${N:-0}" -gt 0 ] && L+=("uncommitted tracked changes: $N file(s)")
  U=$(git -C "$ROOT" rev-list --count '@{u}..HEAD' 2>/dev/null || echo 0)
  [ "${U:-0}" -gt 0 ] && L+=("unpushed commits: $U")
fi

# Disk: warn when the home volume is nearly full.
USED=$(df -P "$HOME" 2>/dev/null | awk 'NR==2{gsub("%","",$5); print $5}')
if [ -n "${USED:-}" ] && [ "$USED" -ge "${TEAM_KIT_DISK_WARN_PCT:-85}" ] 2>/dev/null; then
  FREE=$(df -Ph "$HOME" 2>/dev/null | awk 'NR==2{print $4}')
  L+=("WARNING disk is ${USED}% full (${FREE} free). Run the team-kit:disk-cleanup skill before builds or Docker work.")
fi

# Memory (macOS): warn when swap is heavily used.
if command -v sysctl >/dev/null 2>&1 && sysctl -n vm.swapusage >/dev/null 2>&1; then
  SWAP_MB=$(sysctl -n vm.swapusage | awk '{v=$6; if (v ~ /G$/) {sub("G","",v); v=v*1024} else {sub("M","",v)} printf "%d", v}')
  if [ "${SWAP_MB:-0}" -ge "${TEAM_KIT_SWAP_WARN_MB:-4096}" ] 2>/dev/null; then
    L+=("WARNING swap in use is ${SWAP_MB} MB. See the team-kit:machine-guard skill before starting tests, builds or more agents.")
  fi
fi

for l in "${L[@]}"; do echo "[team-kit] $l"; done
exit 0
