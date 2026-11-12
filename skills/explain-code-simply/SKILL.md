---
name: explain-code-simply
description: Use when someone asks what a piece of code, a feature, a flow, an error or a whole repository does and wants it in simple language - "explain this", "how does X work", "walk me through", "what happens when the user clicks...", or when the reader is new to the codebase, a tester, a product person or a client.
---

# Explain code in simple language

The reader wants to understand what happens, not to read the code again in English. Explain the behaviour first, in their words, and bring in code names only where they help the reader find things.

## Before writing

1. **Read the real code.** Follow the path from where it starts (the button, the endpoint, the scheduled job) to where it ends (the database row, the email, the screen). Do not explain from file names or from memory.
2. **Know the reader.** A new developer needs the map and the file names. A tester needs the rules and the edge cases. A product person or client needs what the user sees and why. If you do not know, write for a smart person who has never seen this code.
3. **Find the one-sentence answer.** If you cannot say what it does in one sentence, keep reading.

## Shape of the answer

1. **One sentence: what it does**, in terms of what a person sees or gets.
2. **The story, step by step**, in the order things happen. One short step per line. Say who or what acts in each step ("the app sends...", "the server checks...").
3. **The rules it follows**, as a short list: the conditions, the limits, what is refused and what message the user gets.
4. **A worked example with real values.** "A leave request for 3 to 5 March, made on 1 March, goes to the manager first, because..."
5. **What can go wrong**, and what the user sees when it does.
6. **Where it lives**: the few files and functions that matter, as `path:line`, for readers who want to look. This comes last, not first.

A picture helps when the flow has more than about five steps or more than two actors. A simple box-and-arrow diagram or a numbered sequence is enough.

## Wording

- Short sentences. Everyday words. One idea per sentence.
- Say what a thing does before giving its name: "the part that checks the user's permissions (`AuthGuard`)".
- Explain a technical word the first time it appears, in a few words, or do not use it.
- No "simply", "just", "obviously". If it were obvious they would not be asking.
- Use the product's own words for things, the ones on the screen, not the variable names.
- Analogies only when they are accurate. A wrong picture is worse than none.

## Honesty

- Separate what the code does from what it was probably meant to do. If they differ, say so plainly; that is often the most useful part.
- Say what you did not read. "I followed the web path; I did not check the mobile app."
- If a comment or a doc says one thing and the code does another, the code is what happens. Mention the mismatch.

## For a whole repository

Give the map before the detail: what the system is for, the main parts and what each is responsible for, how a typical request travels through them, where the data lives, and how to run it. Then offer to go deeper on one part. Do not walk the folder tree file by file.
