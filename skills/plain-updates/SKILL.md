---
name: plain-updates
description: Use when writing anything a person will read or send - a status update, a summary of findings, a handover, a message for a client, manager or teammate (chat, email, ticket), or an end-of-task report. Keeps it in plain words, leads with what matters, and formats messages so they can be copied and pasted as they are.
---

# Plain updates and messages to copy

## Status updates and reports

- **Lead with what the reader most needs**: the answer, the result, or the decision you need from them. Not the story of how you got there.
- **Plain words, no jargon.** Write for someone who was not in the room. If a technical name is needed, say what it is the first time.
- **Short points** when there are several separate things; sentences when the reasoning matters.
- **Be exact about state.** "Merged to the development branch, not yet released" is different from "done". Say which environment, which branch, which version.
- **Say what was not done**: what was skipped, what failed (with the output), what is still waiting on someone.
- **Numbers carry their unit and their source.** "42 of 247 rows, counted from the export of 12 March."
- **Times in the reader's time zone**, with the zone named. Convert server and log times (usually UTC) before writing them down; give the original in brackets when it matters.
- **Do not overstate.** "Should work" and "works, tested on X" are different sentences. Use the true one.

## Messages for someone to send

When asked for a message to send (chat, email, ticket comment):

- Give it as **plain text on its own lines** after a short label. Not inside a quote block and not inside a table: those add a bar or borders that get copied with the text.
- Blank lines between paragraphs, so it pastes cleanly.
- Write it in the sender's voice, ready to send, with no placeholders left unless a fact is truly unknown; then name the gap outside the message.
- Match the channel: a chat message is short and has no headings; an email has a subject line and a greeting; a ticket comment states what changed, where, and how to check it.
- Every factual sentence in it is a claim. Check it first. See the `prove-before-posting` skill.

## Checking a draft

Read it once as the receiver:

- Could they act on this if it were the only message they read today?
- Is the most important thing in the first two lines?
- Is there a word they would have to look up?
- Is anything stated more firmly than the evidence supports?
