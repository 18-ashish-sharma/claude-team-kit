---
name: team-kit-guide
description: Use when someone asks what the team kit contains, which skill, agent or tool to use for a job, how to set up or update the kit, or why a commit, push or session start printed a team-kit message.
---

# Team kit guide

The kit has two layers:

1. **team-kit** (this plugin): the team's working rules as skills, three agents, and two hooks.
2. **Upstream tool sets**, installed by `setup.sh` from their own repositories: ECC, gstack, superpowers and the official Claude plugins, plus optional motion sets. They are not copied here; see `CREDITS.md`.

## Which one for the job

| Job | Use |
|---|---|
| Understand code, a flow or a repository in simple words | `team-kit:explain-code-simply` |
| Write an update, summary or a message to send | `team-kit:plain-updates` |
| Check a reply, release note or PR text before sending | `team-kit:prove-before-posting` |
| Is my change really tested? | `team-kit:scenario-matrix` |
| A PR is open: take it to ready | `team-kit:pr-loop` |
| Review teammates' PRs | `team-kit:reviewing-prs` |
| An endpoint changed | `team-kit:docs-spec-collection` |
| About to run tests, migrations or seeds | `team-kit:safe-db-targets` |
| Keys, tokens, `.env` files, a leak | `team-kit:handling-secrets` |
| Disk is filling up | `team-kit:disk-cleanup` |
| Laptop is slow, or before a heavy run | `team-kit:machine-guard` |
| A user guide or handout as PDF | `team-kit:guide-pdf` |
| Change a document's format | `team-kit:convert-docs` |
| Find an open-source option before building | agent `oss-scout` |
| Are these tests any good? | agent `test-suite-auditor` |
| Is this fit to release? | agent `release-readiness-reviewer` |

With the upstream sets installed:

| Job | Use |
|---|---|
| Plan before building; debug step by step | superpowers: `brainstorming`, `writing-plans`, `systematic-debugging` |
| Language and framework reviewers, silent-failure and type-design review | ECC agents (`ecc:*-reviewer`, `ecc:silent-failure-hunter`, `ecc:type-design-analyzer`) |
| Drive a real browser, QA a site, ship a PR | gstack: `/browse`, `/qa`, `/ship` |
| Markdown to print-quality PDF; diagrams | gstack: `/make-pdf`, `/diagram` |
| Word, PDF, PowerPoint and Excel files | Claude's document skills: `docx`, `pdf`, `pptx`, `xlsx` |
| Current library documentation | `context7` |

Where an upstream skill and a team-kit rule disagree, the team rule wins: for example, a shipping skill may open a PR but does not merge it.

## The two hooks

- **Session start** prints the date, the active GitHub account, the repository's commit email, unfinished work, and a warning when the disk or swap is high. Switch off: `TEAM_KIT_SESSION_BRIEF=off`.
- **Secret guard** runs before every `git commit` and `git push` the assistant makes, and stops it if the change holds a secret-looking value or a file such as `.env` or a private key. Switch off for one command, after a person has looked: `TEAM_KIT_SECRET_GUARD=off`.

The secret guard only sees commands the assistant runs. To cover commits made by hand as well, install it as git hooks: `scripts/install-git-guard.sh /path/to/repo`.

## Set up, update, remove

```bash
git clone https://github.com/18-ashish-sharma/claude-team-kit.git
cd claude-team-kit && ./setup.sh          # asks about each upstream set
./setup.sh --status                       # what is installed
claude plugin marketplace update claude-team-kit     # update
claude plugin uninstall team-kit@claude-team-kit     # remove
```

## Your own rules

`templates/CLAUDE.md` is a starting rules file: git authorship, merging, time zones, messages to copy, memory and disk habits. Copy it, then edit it to say how your team works. Keep names, hosts and customer details in your private copy, never in a public repository.

## Adding a skill to the kit

One folder under `skills/` with a `SKILL.md`. The `description` says **when** to use it, in the words someone would actually type. Keep it general: no customer names, people, hostnames or internal project names. Run `scripts/scan-private.sh` before pushing.
