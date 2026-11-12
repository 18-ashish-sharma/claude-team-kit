#!/usr/bin/env bash
# Tests scripts/secret-guard.sh in a throwaway repo. Fake values only.
G="$(cd "$(dirname "$0")/.." && pwd)/scripts/secret-guard.sh"
S="$(mktemp -d)/guardtest"
rm -rf "$S"; mkdir -p "$S"; cd "$S" || exit 1
git init -q; git config user.email t@example.com; git config user.name t

PASS=0; FAIL=0
expect() { # expect <code> <label> ; reads exit code from $RC
  if [ "$RC" = "$1" ]; then PASS=$((PASS+1)); echo "ok    $2 (exit $RC)"; else FAIL=$((FAIL+1)); echo "FAIL  $2 (exit $RC, wanted $1)"; fi
}
hook() { printf '{"cwd":"%s","tool_input":{"command":"%s"}}' "$S" "$1" | bash "$G" >/dev/null 2>"$S/../guard.err"; RC=$?; }

FAKE="AKIA""Q7ZT4MX2PLW9RB3K"   # made-up, not a real key

echo hello > a.txt; git add a.txt
hook "git commit -m first";            expect 0 "clean commit passes"
git commit -qm first
hook "ls -la";                         expect 0 "non-git command ignored"
hook "echo git commit";                expect 0 "'echo git commit' ignored"

echo "aws_access_key_id=$FAKE" > cfg.txt; git add cfg.txt
hook "git commit -m add";              expect 2 "staged key blocks commit (gitleaks)"
grep -c "$FAKE" "$S/../guard.err" | sed 's/^/      raw value printed in message: /; s/: 0$/: no/'
hook "git -C . commit -m add";         expect 2 "git -C . commit also caught"
hook "cd x && git commit -m add";      expect 2 "chained command caught"

NOGL=$(echo "$PATH" | tr ':' '\n' | grep -v -e homebrew | paste -sd: -)
printf '{"cwd":"%s","tool_input":{"command":"git commit -m x"}}' "$S" | PATH="$NOGL" bash "$G" >/dev/null 2>"$S/../guard.err"; RC=$?
expect 2 "blocks without gitleaks (built-in list)"
git reset -q cfg.txt; rm cfg.txt

echo "X=1" > .env; git add -f .env
hook "git commit -m env";              expect 2 ".env file blocks commit"
git reset -q .env; rm .env

echo "X=" > .env.example; git add .env.example
hook "git commit -m example";          expect 0 ".env.example allowed"
git commit -qm example

echo "edit $FAKE" >> a.txt
hook "git commit -am sneaky";          expect 2 "unstaged tracked edit caught (commit -a)"
git checkout -q a.txt

echo "k=$FAKE" > z.txt; git add z.txt
TEAM_KIT_SECRET_GUARD=off; export TEAM_KIT_SECRET_GUARD
hook "git commit -m x";                expect 0 "switch-off variable respected"
unset TEAM_KIT_SECRET_GUARD
bash "$G" commit >/dev/null 2>&1; RC=$?; expect 2 "git-hook mode: commit blocked"
git reset -q z.txt; rm z.txt

hook "git push origin main";           expect 0 "push with clean history passes"
echo "k=$FAKE" > z.txt; git add z.txt; git commit -qm leak
hook "git push origin main";           expect 2 "push with key in unpushed commit blocked"
echo "------ message shown to the user ------"; cat "$S/../guard.err"; echo "---------------------------------------"
git reset -q --hard HEAD~1
printf 'DB=postgres://app:devpass123@localhost:5433/app\n' > .env.example; git add .env.example
hook "git commit -m localdb";          expect 0 "local dev database URL in .env.example allowed"
printf 'DB=postgres://app:%s@db.internal.example.com:5432/app\n' "Hk29d""Lmq7Zx" > conf.txt; git add conf.txt
hook "git commit -m remotedb";         expect 2 "remote database URL with password blocked"
git commit -qm leak2
bash "$G" push >/dev/null 2>&1; RC=$?; expect 2 "git-hook mode: push blocked"

echo "bad json" | bash "$G" >/dev/null 2>&1; RC=$?; expect 0 "malformed hook input does not break the session"

echo; echo "passed $PASS, failed $FAIL"
cd ..; rm -rf "$S" guard.err; [ "$FAIL" -eq 0 ]
