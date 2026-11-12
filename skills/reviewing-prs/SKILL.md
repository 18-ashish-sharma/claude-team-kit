---
name: reviewing-prs
description: Use when asked to review, approve or comment on one or more teammates' pull requests - a PR link or number, a pasted "PR is up for review" note, paired backend and frontend PRs, or a batch from one author. One fresh agent per PR finds problems, each finding is checked against the code, and only confirmed ones are posted.
---

# Reviewing teammates' PRs

One fresh review agent per PR. The agents find the problems; you check each one against the code, then post. **An agent saying "I found X" is only a claim until you have checked it yourself.** Nothing reaches the PR until it is confirmed against the PR's head commit.

## Before dispatching

1. **Resolve the targets.** A `pull/new/<branch>` link is not a PR yet; check whether one exists: `gh pr list --head <branch> --state all`. Paired PRs (backend and frontend) are one unit, reviewed by separate agents.
2. **Collect metadata** for every PR in one call: author, state, head and base, size, review decision, existing reviews.
3. **Check the author.** You cannot approve your own PR. Post a comment review.
4. **Check the active `gh` account** in the same shell call as the `gh` command, if the machine has more than one account.
5. **Read the existing human reviews first.** Fold in what they found. Do not post a duplicate as if it were new.
6. **A batch from one author on the same files: check the PRs against each other.** Each may merge cleanly alone while every pair conflicts. `git merge-tree --write-tree --name-only <a> <b>` for each pair, and give a one-at-a-time merge order in every review.
7. **Re-reviewing after the base moved: diff against the merge base**, not the current base, or the base's new lines look like deletions: `git diff $(git merge-base origin/<base> <pr>) <pr>`.
8. **Small docs-only or clean-up PRs (under about 50 lines, no code): review them yourself.** One agent per PR is for code.

## Dispatch

Send every agent call in one message so they run in parallel. Build each brief from `agent-prompt.md` in this folder. Each brief includes the author's claims listed as things to **verify**, the review focus for the PR's domain (table below), at most three specialist reviewers, the hard rules, and the return format.

## Verify, then post

For each finding marked blocker or major:

1. **Re-read the cited code yourself** at the PR head: `git fetch origin pull/N/head:tmp-review && git show tmp-review:path`, then delete the temporary branch.
2. **Fix the line numbers.** Agents often cite the wrong line. An inline comment must point at a line of the head version that is inside the diff.
3. **If the finding makes a factual claim** (number rounding, a library's behaviour), run the check.

Post one review per PR with `gh api -X POST repos/<owner>/<repo>/pulls/N/reviews --input review.json`. The JSON holds `commit_id` (the head sha), `event`, `body` (what was verified, then blockers, then minors, then follow-ups, then merge order) and `comments[]` with `{path, line, side: "RIGHT", body}`. Write the JSON to a scratch file with a file-writing tool, not an unquoted heredoc: review text often contains `$` and backticks.

| Verdict | When |
|---|---|
| Request changes | a confirmed correctness, data or security bug |
| Comment | only minor issues or test gaps; or the PR is your own |
| Approve | no blocker left, and the minors are nits |

## After posting

- Give a table: PR, verdict, main point, review link.
- Say plainly what was **not** run: skipped tests, specialists that did not run, linked PRs nobody opened.
- If asked for a message to send, write one paste-ready block per PR as plain text.

## Review focus by domain

| Domain | Always check |
|---|---|
| Status or enum filters | every value in the database constraint and migrations; the list filter and the counts query use the same condition |
| Money | exact decimal types end to end; no float parsing or float sums; row fan-out on joins; nulls |
| Tabs, segments, counts | segments never overlap and together add up to "All"; nulls land somewhere |
| Dates and times | time zone at day boundaries; inclusive vs exclusive ends; "today" on the server vs for the user |
| Access control | every new endpoint checks the caller's scope; IDs in the body are checked against the caller's tenant; no self-approval |
| Migrations | reversible; safe on a table with data; unique names; no long lock on a large table |
| Lists and exports | paging; ordering is stable; the export matches the screen's filter |
| Background jobs | safe to run twice; a failure is recorded and visible; retries do not duplicate |
| Mobile and offline | behaviour on a bad network; duplicate submit; permissions denied |
| Screen text | matches what the server does; every translation updated |
