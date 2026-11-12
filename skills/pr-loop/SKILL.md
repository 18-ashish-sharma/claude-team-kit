---
name: pr-loop
description: Use once a pull request is open and before it is called ready to merge - runs the fixed per-PR loop of fresh review, specialist reviewers, running the change for real, fixing confirmed findings, updating docs, API spec and API collection, and local verification. Also use when asked "is this PR ready?".
---

# The per-PR loop

Once a PR is open, it goes through these steps in order. None is optional and none runs out of order.

## 1. Re-review

**Fresh eyes.** Dispatch a review agent against the PR diff with no memory of having written it.

**Specialists, in parallel, only where the diff touches their subject.** Running one outside its subject wastes tokens and invites invented findings.

| Reviewer | When |
|---|---|
| silent failures (swallowed errors, empty catches, risky fallbacks) | always |
| type design | the diff adds or changes types, DTOs or API models |
| comments | the diff adds or edits comments or docstrings |
| database | the diff touches SQL, migrations or schema |
| one language reviewer matching the diff | always |

With ECC installed these are `ecc:silent-failure-hunter`, `ecc:type-design-analyzer`, `ecc:comment-analyzer`, `ecc:database-reviewer` and the matching `ecc:*-reviewer`. Without it, brief general agents with the same focus.

**A finding is a hypothesis, not a verdict.** An agent saying "I found X" is a claim. Confirm each one against the code yourself. Unconfirmed findings are dropped, not deferred. Review agents are read-only: they never edit, commit or push.

**Reading the diff is not enough.** Before the PR is called ready, prove each of these:

- a. **Merged with today's base.** Fetch, merge the base branch into the PR branch, resolve conflicts, and run the checks below on that result. The PR must report as mergeable. If a related PR landed meanwhile, re-test what it touched.
- b. **Every CI step, locally.** Read the CI workflow file and run each step the job runs, not only the type check and tests. A red step early in a job hides every step after it. After a push, confirm the checks are green.
- c. **Migration names and timestamps are unique across all open PRs**, not only the base branch.
- d. **Run it like a user, through the API or UI, on a local database**, including the awkward cases. Use the `scenario-matrix` skill.
- e. **Follow the change downstream.** If it retires, deactivates or reprices something, try the flows that depend on it.
- f. **Every entry point.** List every path on today's base that creates the same data and cover each, or write down that it is out of scope.
- g. **Screen text matches behaviour.** Help text, dialog copy and every translation.
- h. **The PR description matches the diff.** Title, what and why, linked PRs, test steps, migration names.
- i. **Docs claims are checked against the running system**, not against the code.

## 2. Fix

Apply every confirmed finding on the same branch. No triage gate, no PR comment first. Then re-review the fix commits: fixes break the same path.

## 3. Docs

Update the reference and the flow description for anything that changed. See the `docs-spec-collection` skill.

## 4. API spec and API collection

Regenerate the spec from code (never hand-edit it) and update the matching requests in the API collection.

## 5. Test the collection, locally only

Run it against the local server and local database. Never against a shared, staging or production environment: collections are write-heavy. See the `safe-db-targets` skill.

## 6. Hand over

Report the PR as ready, with what was run and what was not. **The assistant does not merge and does not force-push** unless the person says so for a named set of PRs in that conversation. That approval covers that set only, and never the release branch.

## 7. After release

Smoke-test the released change. Throwaway data is allowed, through the API only. Replay the reported case and quote before and after.

## 8. No test ever targets a real database

If a change cannot be verified without writing to a shared database, stop and say so.

## Reporting

Say plainly what passed, what failed with the output, and what was skipped. "Ready" means steps 1 to 5 were done, not that the diff looks fine.
