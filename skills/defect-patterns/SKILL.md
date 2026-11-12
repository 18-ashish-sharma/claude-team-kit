---
name: defect-patterns
description: Use when reviewing a diff, hunting a bug that tests did not catch, or checking your own change before calling it ready - a checklist of defect shapes that keep coming back in web, API and database code (rows lost in paging, failures that look like empty lists, flags that hide a status, comparisons that differ between the app and the database, tests that cannot fail).
---

# Defect patterns that keep coming back

Each of these passed review and green tests at least once before a user found it. Check a change against the ones its subject touches.

## Data and queries

- **Paged list sorted on a column with ties.** `ORDER BY created_at LIMIT/OFFSET` with equal timestamps returns some rows twice and loses others between pages. Add a unique tie-break (`, id`).
- **The list and its count use different conditions.** The tab says 12, the list shows 10. Both must come from one condition, written once.
- **Segments that do not add up.** Tabs or buckets overlap, or a null lands in none of them. Together they must equal "All".
- **Join fan-out.** A sum over a join counts a row once per matching child. Totals are right in tests with one child and wrong with two.
- **Money as floats.** Parsing to a float or summing in application code loses paise and cents. Exact decimals end to end.
- **Comparing IDs in code vs in the database.** The database compares UUIDs case-insensitively; `===` on strings does not. Same for trailing spaces and Unicode forms in names and emails.
- **A unique rule that is not the one you think.** A unique *constraint* and a unique *index* differ in what "on conflict" can target and how nulls behave. Check which one the migration created.
- **A migration tested only on empty tables.** It fails on real data: duplicates, nulls, a long lock, pending triggers. Test it on a table with awkward rows.
- **Dates at the day boundary.** "Today" on the server is not "today" for the user. An end date stored as midnight excludes the whole last day.

## State and status

- **A derived flag that replaces a status.** Showing "late" instead of "present" deletes the fact that the person was present. Add information; do not overwrite it.
- **A status that lies one level up.** The row was fixed, but the summary, badge or parent record still computes the old way.
- **Unknown treated as "no".** `Boolean(value)` or `value ?? false` turns "the fetch failed" into "the user has none". Keep three states: yes, no, not known.
- **An exhaustive check that checks nothing.** A `default` branch or a cast that swallows new enum values, so adding a status compiles and silently falls through.
- **Grouping by a text prefix.** Bucketing by `type.startsWith(...)` breaks the day a new type shares the prefix.

## Failures that hide

- **A failure that looks like an empty state.** A 403, 404 or 500 is caught and rendered as "No results". The single most common shape. Every empty state needs a separate, visible error state.
- **The API silently drops unknown fields.** A misspelt or unsupported field returns 200 and is ignored. The client thinks it saved.
- **A generator that exits 0 while skipping a broken file.** Check the output contains what you changed.
- **Two places raise the same message.** The error text points at one cause; the other raise site is the one that fired. Give each its own message.
- **A relabelled error.** A lower layer's specific failure is caught and re-raised as a generic one, hiding the reason.
- **A stale request that outlives its input.** The search box is cleared, the old query's result arrives late and filters the list.

## Negation and allow-lists

- **A negated rule admits what you did not think of.** "Everything except X" lets in the next thing nobody listed. Prefer naming what is allowed.
- **A guard at one entry point.** The rule is enforced on the main screen and missing on import, the API, the mobile app, or the bulk action.

## Interface

- **The browser's own validation blocks the form library.** A native `required` stops submit before your messages run.
- **Layout that collapses only in a real browser.** A flex child with hidden overflow becomes zero wide. Unit tests with a fake DOM cannot see layout; look at it.
- **Server and client render different things.** The first paint is blank or wrong, then corrects itself; crawlers and slow phones see the wrong one.
- **Text that describes behaviour the server does not have.** Help text, dialogs and translations drift from the code.

## Comments and docs

- **The comment was the defect.** A confident comment described behaviour the code never had, and reviewers believed the comment.
- **A doc comment is not the implementation.** "Idempotent", "atomic", "validated" in a docstring prove nothing.

## Tests

- **Asserting against the constant under test.** The test imports the same value the code uses, so both are wrong together.
- **A green suite for work nobody wrote.** No test fails because no test exists for the missing behaviour.
- **Per-branch green is not merged green.** Two PRs pass alone and break together. Test the merge result.
- **Many tests failing at one line.** It is one cause, usually setup or environment. Find it before fixing tests one by one.
- **The test ran different code.** An editable install, a stale build, or the wrong worktree means the suite tested another copy.
- **A benchmark whose input is not the real workload** measures something else.

## Probes

- **Control an absence probe first.** Before believing "it is not there", run the same search for something you know is there. An empty result from a wrong path, wrong account or wrong branch looks identical.
- **Check you are on the fresh base** before building or diagnosing. Half of "it is broken" is "my branch is old".
