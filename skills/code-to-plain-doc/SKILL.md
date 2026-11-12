---
name: code-to-plain-doc
description: Use when asked to turn code into a document people outside the dev team can read - "write this up for non-technical people", "explain this service for DevOps", "make a plain-language doc of this repo or module", "what does this code do, as a document", a handover, an operations runbook, or a business-rules write-up taken from the code. Produces a written document from the real code, in one of three reader views.
---

# Code to a plain-language document

This turns code into a document for a reader who will not open the code. It is a conversion, not a summary from memory: every statement in the document comes from something you read, and the document says where.

For a quick spoken-style answer in chat, use `explain-code-simply`. Use this skill when the result is a document someone keeps.

## 1. Pick the reader view

Ask if it is not clear. One document per view; do not blend them.

| View | Reader | They want to know | Template |
|---|---|---|---|
| **Business** | product, client, manager, tester, support | what it does for people, the rules it applies, what can go wrong for a user | `templates/business-view.md` |
| **Operations** | DevOps, SRE, whoever runs and deploys it | how to run it, what it needs, how to tell it is healthy, what to do when it is not | `templates/operations-view.md` |
| **Newcomer** | a developer new to the code | the map: parts, responsibilities, how a request travels, where to change things | `templates/newcomer-view.md` |

## 2. Read the code, in this order

1. **Entry points**: routes, controllers, screens, command-line commands, scheduled jobs, queue consumers. These are the list of "things it does".
2. **For each one, follow it** to the data it reads and writes, the other services it calls, and the messages or emails it sends.
3. **The rules**: validations, permission checks, status changes, calculations, limits, time windows. Collect each as a sentence with its condition.
4. **For the operations view**: start-up code, configuration and environment variable names (names only, never values), Dockerfile and compose files, deploy manifests, CI and release workflows, migrations, health endpoints, logging and metrics, timeouts and retries.
5. **Tests and docs** are hints about intent. Where they disagree with the code, the code is what happens; note the mismatch.

Keep a running list of **source notes**: each fact with its `path:line`. They go in the appendix.

## 3. Write it

- **Translate, do not transliterate.** `if (!user.isActive) throw new ForbiddenError()` becomes "A deactivated account cannot do this; the person sees 'Access denied'." Not "it checks the isActive flag".
- **Use the words on the screen**, not the variable names. Give the code name once in brackets only where a reader will need it to talk to a developer.
- **Rules as plain sentences with their condition**: "A request can be cancelled until it is approved. After approval, only a manager can cancel it."
- **Real examples with real-looking values** for every rule that involves dates, amounts or limits.
- **Numbers from the code, with their unit**: "retries 3 times, 5 seconds apart", "files up to 10 MB".
- **Pictures for flows.** A numbered sequence or a simple box-and-arrow diagram whenever more than two parties or five steps are involved. Mermaid blocks render in most viewers.
- **Short sentences, everyday words.** Explain a technical term the first time, or leave it out. No "simply", "just", "obviously".
- **Tables for look-up content**: statuses and what each means, roles and what each may do, settings and what each changes.

## 4. Be honest about what the code says

Each document ends with these three short sections:

- **Things that may surprise you**: where the code does something a reasonable person would not expect, or differs from its own comments, docs or screen text.
- **Not covered**: what you did not read (another service, the mobile app, infrastructure outside this repository).
- **Where this comes from**: the source notes, grouped by section, with the branch and commit and the date.

Never fill a gap with what the code "probably" does. Write "not found in this repository" instead.

## 5. Never include

- Secret values, tokens, passwords, connection strings. Setting **names** only.
- Personal data copied from fixtures, logs or databases.
- Internal hostnames or addresses in a document meant for outside readers; say "the staging site".

## 6. Check before handing over

- Give the document a cold read as the intended reader: is there a sentence they could not follow, or a word they would need to look up?
- Pick five statements at random and re-check each against its source note.
- For the operations view, run the read-only commands you wrote (the health check, the "is it running" command) locally where possible, and mark any you could not run.
- State the branch, commit and date at the top. A plain document goes stale the same way code comments do.

## Output

Markdown by default, in the place the person names, or `docs/plain/<name>-<view>.md`. To deliver as Word or PDF, convert it with the `convert-docs` skill, or `guide-pdf` for a designed PDF.

For a large repository, write one overview document plus one document per major part, rather than one long file. Offer the list of parts first and agree the order.
