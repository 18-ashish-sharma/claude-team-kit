---
name: handling-secrets
description: Use when work touches API keys, tokens, passwords, connection strings, .env files, kubeconfigs, certificates or signing keys - before reading, printing, committing, pasting into a PR, issue, chat or log, or sending any of them to an outside service. Also use when a secret may have leaked and needs cleaning up.
---

# Handling secrets

A secret is anything that lets someone act as you or read private data: API keys, tokens, passwords, connection strings with a password, private keys, session cookies, signing keystores, kubeconfigs.

## The rules

1. **Use it, never show it.** Refer to a secret by its name (`$STRIPE_KEY`), not its value. Do not `cat .env`, `echo $TOKEN`, `printenv`, or print a config object that contains one. To check that one is set: `[ -n "$TOKEN" ] && echo set`. To compare two: compare lengths or a hash prefix, not the values.
2. **Secrets live outside git.** In an untracked `.env` (with a committed `.env.example` holding names and fake values), the OS keychain, or the team's secret manager. Never in source, tests, fixtures, docs, commit messages, PR text, issue comments, screenshots or chat.
3. **Never on a command line that gets logged.** `curl -H "Authorization: Bearer abc..."` ends up in shell history and CI logs. Read from the environment or a file: `-H "Authorization: Bearer $TOKEN"`, `--password-stdin`, `--data @file`.
4. **Nothing private goes to an outside service** unless the person asked for exactly that. This covers pastebins, online formatters, diagram renderers, search queries and third-party APIs.
5. **Least reach.** Use the narrowest key that does the job (read-only, one project, short-lived). Do not reuse a production key locally.
6. **Samples are fake and look fake.** `sk_test_EXAMPLE`, `postgres://user:password@localhost/db`. Never a real value with a few characters changed.

## Before a commit or a push

- `git status` and `git diff --cached --name-only`: no `.env`, `*.pem`, `*.keystore`, `kubeconfig`, `credentials.json`.
- Scan what is leaving: `git diff --cached | gitleaks stdin --redact`. This kit's hook does this on every `git commit` and `git push` and stops the command on a hit.
- To protect a repository for every person who commits there, install the same check as git hooks: `scripts/install-git-guard.sh /path/to/repo`.
- A guard that stops you is telling you something. Read what it found. Do not bypass it to get unblocked; a bypass is the person's call, after they have looked.

## Making a repository public

History matters, not only the current files. Before the switch:

1. `gitleaks git . --redact` over the full history and `gitleaks dir .` over the files.
2. Search for names that are private but not secret: clients, people, internal hostnames, project codenames, absolute home paths. Keep the word list in an untracked file so the list itself is never published.
3. Check commit authors and emails: `git log --format='%an <%ae>' | sort -u`.
4. If history holds anything private, publish a fresh repository with clean history. Rewriting and force-pushing an existing one leaves copies in forks and caches.

## If a secret leaked

Deleting it is not the fix. Anything that reached a remote, a log, a chat or a screenshot is compromised.

1. **Say so at once**, naming what leaked and where, without repeating the value.
2. **Rotate it at the source** (the provider's console). This is the only step that makes it safe. It is the owner's action; ask them, do not guess at access.
3. **Check for use**: the provider's access logs since the leak time.
4. **Then clean up**: remove it from the code, and from history if the repository is or will be shared.
5. **Stop the repeat**: add the file to `.gitignore`, install the git guard, add the pattern to the scan.

## What this skill does not do

It does not decide who may see a secret, and it does not rotate keys by itself. When a task seems to need a secret you do not have, stop and ask for it to be provided through the environment, never pasted into the conversation.
