---
name: qa-like-a-user
description: Use when verifying a change in a real browser or on a real device - after a deploy, before saying "tested", or when asked to QA a feature or flow. Drives the whole business flow to its real end, tries the negative paths, and watches network and console, instead of confirming that one screen loads.
---

# QA like a senior tester, not a smoke test

"The screen rendered, so it works" is the failure this skill exists to stop. A loaded page proves almost nothing about whether a person can finish the job.

## Finish the flow

Follow the business process to where it truly ends, across every role it passes through. For a hiring flow that is not "the candidate list opens"; it is application, screening, test sent and taken, score visible, interview booked, invites received, feedback recorded, offer, joining, account created, first login. Stop only when the flow genuinely ends or is genuinely blocked, and say which.

Write the steps down before starting, so a skipped step is visible.

## Try what users actually do

- Leave a required thing out; submit twice; press back; reload half-way; open the same record in two tabs.
- Come in as the wrong person: a read-only role, someone from another team, someone not on the list.
- Use awkward data: a very long name, another script, an empty file, a date at the month's end, an amount with decimals.
- Do things out of order, and edit something while its approval is still pending.
- Use the size and device the real users have: a small phone, a slow connection.

The `scenario-matrix` skill has the full list.

## Watch the wire, not only the pixels

Keep network requests and the console open the whole time.

- A 403, 404 or 500 that the page turns into an empty list or a spinner is a finding, even if the screen looks calm.
- Check what was actually sent and saved, not only the "Saved" message. Reload and look again.
- A console error on a page that "works" is a finding.

## Check the right place

- Confirm the environment actually has the change: version, commit or build number on the page or the API. Testing an environment that never received the code gives a confident wrong answer.
- Use test accounts and throwaway data, created through the product, and named so they can be found and removed.
- Never use real people's accounts or data, and never write to a shared database by hand. See the `safe-db-targets` skill.

## Report findings as findings

For each one: the steps, what was expected, what happened, and the evidence (request and response, console line, screenshot). Mark severity by what the user loses. Then fix them in the same session where that is the task, and re-run the flow from the start after the fix.

End with what was covered, what was not, and why. "Tested the approval flow as a manager on the staging site; did not test mobile" is a real result. "Looks good" is not.

## Tools

Use the browser tool the team has chosen. With gstack installed, `/browse` drives a real browser and `/qa` runs a structured pass; ECC has `browser-qa` and `e2e-testing`. This skill is about what to check; those are how to drive.
