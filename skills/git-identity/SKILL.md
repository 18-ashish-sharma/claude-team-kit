---
name: git-identity
description: Use before the first commit or push in a repository, when a machine has more than one GitHub account or git email, when a push or `gh` call fails with 403 or 404 on a repository that exists, or when commits show up under the wrong name or without a profile link.
---

# Git and GitHub identity

Two separate things decide "who did this", and they go wrong separately:

- **The commit author**: `user.name` and `user.email` in git config. This is what appears on the commit.
- **The account that pushes and calls the API**: the active `gh` account or the SSH key.

## Before the first commit in a repository

```bash
git config user.name; git config user.email      # what this repo will use
git config --show-origin user.email              # where that value comes from
```

If it is not the identity this repository should have, set it for this repository only:

```bash
git config --local user.name  "Your Name"
git config --local user.email "you@example.com"
```

For public repositories, prefer the provider's no-reply address (`ID+username@users.noreply.github.com`), so a personal email is not published in every commit.

A new clone or worktree can pick up a different global or conditional identity. Check each one.

## More than one GitHub account

```bash
gh auth status          # which accounts, which is active
gh auth switch -u <account>
```

- A **404 on a repository that exists** is usually the wrong active account, not a missing repository. A 403 on push is the same story.
- The active account can change between shell calls when another session or tool switches it. Put the switch in the same command as the call that needs it.
- With SSH, the key decides the account: check `ssh -T git@github.com` and the host aliases in `~/.ssh/config`.

## Commit and PR text

- Only people who did the work appear as authors. Follow the team's rule on assistant attribution lines; many teams want none.
- Do not put secrets, customer names or internal hostnames in commit messages. They are as public as the code.

## Fixing a wrong identity

- **Not pushed yet**: `git commit --amend --reset-author` for the last commit, or an interactive rebase for a few.
- **Already pushed**: rewriting needs a force-push, which rewrites history for everyone. Leave it unless the owner asks for it. Fix the config so the next commit is right.

## Remotes that only track one branch

A clone made with `--single-branch` fetches only that branch, so other branches look missing or stale. Check `git config --get-all remote.origin.fetch`; it should be `+refs/heads/*:refs/remotes/origin/*` to see everything.
