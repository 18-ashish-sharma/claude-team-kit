---
name: scenario-matrix
description: Use before calling any change reviewed, ready or done - a feature, a bug fix, or a fix to a fix. Builds the list of situations a real user will hit (same input again, wider, narrower, overlapping, empty, out of order, mid-period) and runs the change against each one, instead of only the case it was designed for.
---

# Scenario matrix

A change is not reviewed until it has been **run** against the situations a real user will hit. Reading the diff, green unit tests and agent reviews can all pass while the first person to use it finds two defects in an afternoon. Those defects come from testing the scenario you designed instead of the ones the user will try.

## 1. Write the matrix first, from the user's side

For every input the change reads (dates, ranges, files, statuses, amounts, IDs), list and test:

- the **same input again** (is a re-run safe?), then a **wider**, a **narrower**, an **overlapping**, an **adjacent** and a **boundary-equal** version;
- **empty, missing, null, malformed, duplicate**, and two copies of the same thing;
- the **order people really work in**: re-run after a fix, A then B, B then A, a retry of a retry, edit the source and run again;
- **one vs several**: one account and many, one customer with two of the same thing, a disabled or deleted record;
- the **awkward calendar cases**: a setting changed mid-month, mid-period or today; an effective date that cannot be back-dated; a record edited while its approval is still pending.

Put the matrix in the PR description. Every row is either a test that ran, or "out of scope, because ...".

## 2. Ask what the user will try first

Then do exactly that before they do. It is usually changing the input (other dates, a different file, a bigger range), not re-running the happy path.

## 3. Every outcome label must be true

"Skipped", "already done", "no change", "success" are claims. Prove each one: same file? same period? really loaded? A refusal from a guard further down is not proof that the data is already there.

## 4. Check every surface the user reads

The screen, the email, the ticket, the export, the log. If a run deletes, replaces or skips something, each surface the user sees must name it, including on rows that otherwise succeeded. A list filtered to "failures only" hides destructive successes.

## 5. Destructive paths get a stricter matrix

For anything that deletes or replaces, prove that it touches only what it should (other account, other period, other customer untouched), that a failure half-way is reported loudly, and that it is safe to run again.

## 6. Follow the change downstream

If the change retires, deactivates or reprices something, try the flows that depend on it afterwards: corrections on past dates, pending approvals, reports and calculations that read it. A green happy path proves nothing about those.

## 7. Cover every entry point

If the feature adds data on path A, list every other path that creates the same thing (other screens, import, API, mobile) and cover them, or write down that they are out of scope.

## 8. Check the tests can fail

Break the fix in each guard: the suite must go red. Prove each new test fails without the fix. A test that passes either way proves nothing.

## 9. Re-review your own fix commits

With the same matrix. Fixes break the same path they repair.

## 10. After release

Replay the exact case the person reported, on the released environment, before replying that it is fixed. Quote the before and after in the reply.
