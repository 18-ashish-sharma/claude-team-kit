---
name: prove-before-posting
description: Use before posting anything a customer, stakeholder or teammate will rely on - a ticket comment, release note, "it's fixed" reply, PR description, help text or user-facing docs. Treats every sentence as a claim and checks each one against the code or a real run before it is sent.
---

# Prove before posting

Every sentence posted to someone who will act on it is a claim. Reviews check the diff against the design; nobody checks the posted words against the code. That gap is where "fixed" replies turn out wrong.

## Before posting

1. **List every claim** in the text: "a real failure still says it failed", "click Export again", "all rules are in one place", the help text under a form field. One line each.
2. **Point each claim at its proof**: the code line, or the run that showed it. A claim with no proof is removed or reworded to what is known.
3. **Do exactly what the text tells the reader to do.** If it says "try again in a few minutes", try again after the timeout and again after the job has finished.
4. **Break it the way the ticket is about**, then look at what the user sees: a killed worker, a failed job, a lost connection. Not only that the system recovers, but what the screen says meanwhile.
5. **When logic moved** ("rules now come from the table"), search for every caller and every copy of the old logic, in every repository, and list which still use the old one.
6. **Words in one place about behaviour in another** (screen text about what the server does, docs about an API) are checked against the other side's code and against the running system, not against memory.
7. **The description matches the change.** Title, what and why, linked work, test steps, names of migrations and files. Text copied from another change is a defect.
8. **Get a cold read.** A fresh reviewer with no memory of writing it reads the text and the code together, before it is posted, not after.

## Wording

- Say what was checked and what was not. "Tested on staging with last month's file" is better than "tested".
- Do not turn "should" into "does".
- Times are given in the reader's time zone, with the zone named.
- Plain words. See the `plain-updates` skill.

## If something already posted turns out wrong

Correct it in the same place, saying what was wrong and what is true. Do not quietly edit it.
