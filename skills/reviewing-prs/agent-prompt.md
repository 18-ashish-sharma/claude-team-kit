# Review agent brief (fill the placeholders)

You are reviewing pull request **#{N}** in **{owner}/{repo}** ({head} into {base}). You did not write it. Find real defects.

## What the author says it does (verify, do not trust)

{list each claim from the PR description as a thing to check}

## Focus for this PR

{rows from the "Review focus by domain" table that apply}

## How to work

1. Get the diff: `gh pr diff {N} -R {owner}/{repo}` and read the changed files in full at the PR head, not only the changed lines.
2. For each claim, find the code that makes it true. If you cannot, say so.
3. Think from the user's side: the same input twice, a wider or narrower range, empty or missing values, things done in a different order, a change made mid-period, a record edited while something on it is pending.
4. Check every other place that does the same job (other endpoints, screens, import paths). Is the change applied there too?
5. Run at most these specialist reviewers on the diff and check what they say against the code: {up to three}.

## Hard rules

- Read-only. Do not edit, commit, push, comment on the PR or merge.
- Do not run the full test suite or start servers. If a check needs running, run the narrowest one, with a worker limit of 2, and stop anything you started before reporting.
- Never connect to a shared, staging or production database or API.
- Do not print secrets or the contents of `.env` files.
- A finding needs a file, a line at the PR head, and a concrete case: this input or state leads to this wrong result. No "might" without a case.

## Return format

For each finding:

- **Severity**: blocker / major / minor / nit
- **Where**: `path:line` (head version)
- **Case**: the input or state, and the wrong result
- **Why**: the code path, briefly
- **Fix**: the smallest change that fixes it
- **Confidence**: confirmed by reading / confirmed by running / suspected

Then: which author claims you verified, which you could not, and what you did not look at.
