# Security

## What this kit runs on your machine

- `scripts/session-brief.sh` at session start: reads the date, `~/.config/gh/hosts.yml` (the
  account name only), git status of the current repository, disk and swap use. It sends
  nothing anywhere.
- `scripts/secret-guard.sh` before `git commit` and `git push` commands run by the assistant:
  reads the change that is about to leave and scans it locally. It sends nothing anywhere.
- `scripts/disk-report.sh` only when you ask: read-only sizes. It deletes nothing.

`setup.sh` installs third-party plugins from their own repositories. Read what you install;
they run their own hooks and code.

## Reporting a problem

If you find a secret, personal detail or private name anywhere in this repository or its
history, or a way the hooks could be misused, please open a private security advisory on
GitHub (Security tab, "Report a vulnerability") rather than a public issue.

## Contributing safely

- Nothing private in skills, agents, examples or commit messages: no customer or person
  names, internal hostnames, project codenames, real tokens or absolute home paths.
- Run `scripts/scan-private.sh` before pushing. Keep your own private word list in
  `.private-denylist` (git-ignored).
- CI runs gitleaks on every push and pull request.
