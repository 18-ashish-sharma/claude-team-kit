# claude-team-kit

One clone that sets a whole team up with the same Claude Code skills, agents and guard rails.

It has two parts:

1. **team-kit**, a Claude Code plugin with working rules written as skills: how to review, how to
   test a change the way a user will, how to handle secrets, how to keep a laptop's disk and
   memory under control, how to explain code in simple language, and how to produce guides,
   PDFs and converted documents.
2. **An installer** that also sets up the well-known tool sets this kit is meant to sit beside:
   ECC, gstack, superpowers and the official Claude plugins. They are installed from their own
   repositories, not copied here. See [CREDITS.md](CREDITS.md).

## Install

Everything, with a question before each upstream set:

```bash
git clone https://github.com/18-ashish-sharma/claude-team-kit.git
cd claude-team-kit
./setup.sh
```

Only the team-kit plugin, from inside Claude Code:

```
/plugin marketplace add 18-ashish-sharma/claude-team-kit
/plugin install team-kit@claude-team-kit
```

Then restart Claude Code and run `/team-kit:team-kit-guide`.

`./setup.sh --all` installs everything without asking, `--kit` installs only this plugin, and
`--status` shows what is installed and changes nothing.

## What is inside

### Skills

| Skill | Use it when |
|---|---|
| `explain-code-simply` | you want code, a flow or a repository explained in simple language |
| `plain-updates` | writing a status update, a summary, or a message someone will send |
| `prove-before-posting` | about to post a reply, release note or PR text people will rely on |
| `scenario-matrix` | about to call a change tested or done |
| `pr-loop` | a PR is open and needs to get to ready |
| `reviewing-prs` | reviewing teammates' pull requests |
| `docs-spec-collection` | an API endpoint changed |
| `safe-db-targets` | about to run tests, migrations, seeds or one-off SQL |
| `handling-secrets` | anything touches keys, tokens, `.env` files, or a secret leaked |
| `disk-cleanup` | the disk is filling up |
| `machine-guard` | before a heavy run, when the laptop is slow, and at the end of a session |
| `guide-pdf` | a user guide or handout is needed as a PDF |
| `convert-docs` | a document has to change format |
| `team-kit-guide` | you want to know what is here and which tool fits a job |

### Agents

| Agent | What it does |
|---|---|
| `oss-scout` | finds and compares open-source options before you build something |
| `test-suite-auditor` | checks whether the tests would actually catch a broken product |
| `release-readiness-reviewer` | a release gate: what breaks for real users |

### Hooks

- **Session start**: prints the date, active GitHub account, the repository's commit email,
  unfinished work, and a warning when the disk or swap is high.
- **Secret guard**: before every `git commit` and `git push` the assistant runs, scans the
  change and stops it if it holds a secret-looking value or a file like `.env` or a private key.
  Uses [gitleaks](https://github.com/gitleaks/gitleaks) when installed, a small built-in list
  otherwise.

Both can be switched off with an environment variable: `TEAM_KIT_SESSION_BRIEF=off`,
`TEAM_KIT_SECRET_GUARD=off`.

### Scripts

| Script | What it does |
|---|---|
| `scripts/disk-report.sh [folder]` | read-only report of what is using the disk |
| `scripts/install-git-guard.sh [repo]` | installs the secret guard as git hooks, so commits made by hand are covered too |
| `scripts/scan-private.sh` | checks this repository for secrets and private words before publishing |

### Template

`templates/CLAUDE.md` is a starting rules file for a person or a team. Copy it and fill in
your own branches, time zone and tools.

## Disk clean-up in one minute

```bash
scripts/disk-report.sh ~/code        # shows where the space went; deletes nothing
```

Then in Claude Code: "clean up my disk". The `disk-cleanup` skill shows a list with sizes,
waits for a yes, and clears only things that rebuild themselves. It never removes a worktree
with uncommitted or unpushed work, and never prunes Docker volumes without naming them.

## What is deliberately not here

- No secrets, tokens, hostnames, customer names or personal settings.
- No copies of other people's skills. Upstream sets are installed from their source.
- No personal `settings.json`. Hooks ship with the plugin and can be switched off.

## Requirements

Claude Code, git, bash and python3 (for the secret guard hook). Optional: `gitleaks` for a
fuller secret scan, `pandoc` for document conversion, Bun for gstack.

macOS is the main target. The hooks and the secret guard also run on Linux; the disk report
lists macOS cache locations and skips any that do not exist.

## Contributing

Add a folder under `skills/` with a `SKILL.md`. Write the `description` as *when* to use it.
Keep it general, and run `scripts/scan-private.sh` before pushing. See [SECURITY.md](SECURITY.md).

## Licence

MIT. See [LICENSE](LICENSE). Third-party projects installed by `setup.sh` keep their own
licences; see [CREDITS.md](CREDITS.md).
