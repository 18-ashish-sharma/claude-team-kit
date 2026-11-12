# Working rules (template)

Copy this to `~/.claude/CLAUDE.md` (for you) or to a repository's `CLAUDE.md` (for a team),
then edit it. Replace every `<...>`. Keep names, hosts and customer details in a private
copy; never commit those to a public repository.

## Git

- Commits and PRs carry only the human author. No assistant co-author trailer and no
  "generated with" line in commits, PR descriptions or comments.
- Commit as `<name>` `<email>`. Check `git config user.email` before the first commit in a
  repository.
- The assistant may commit, push and **open** a PR. It never merges and never force-pushes,
  unless told to for a named set of PRs in that conversation. That approval covers only that
  set, and never the release branch `<main>`.
- Work goes to `<dev branch>` through a PR. `<main>` is the release branch.

## Databases and environments

- Tests, migrations, seeds and API collection runs target a local database only:
  `<local connection string with dev-only credentials>`.
- Shared environments are read-only for the assistant. Any write needs explicit approval,
  each time. Skill: `team-kit:safe-db-targets`.

## A change is not done until

- it has been run against the situations a real user will hit (`team-kit:scenario-matrix`);
- for an endpoint change: docs, then generated spec, then API collection
  (`team-kit:docs-spec-collection`);
- an open PR has been through the loop (`team-kit:pr-loop`);
- anything posted to a customer has had each sentence checked (`team-kit:prove-before-posting`).

## Secrets

Never print, commit or paste secret values. Skill: `team-kit:handling-secrets`.

## Writing

- Plain words, most important thing first (`team-kit:plain-updates`).
- A message meant to be sent is given as plain text on its own lines, never in a quote
  block or table.
- All times in `<time zone>`; convert UTC from logs and cloud consoles before writing it down.

## This machine

- `<RAM>` GB. One heavy run at a time, test runners capped at 2 workers
  (`team-kit:machine-guard`).
- Close every server, watcher and container the session started before it ends.
- Keep the disk under 85% (`team-kit:disk-cleanup`). Remove a worktree when its branch merges.

## Tools

- Web browsing: `<which browser skill or tool>`.
- Container runtime: `<Docker Desktop / other>`; start it only when needed.
