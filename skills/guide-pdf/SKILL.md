---
name: guide-pdf
description: Use when asked for a user guide, how-to, training handout, release walkthrough or any step-by-step document delivered as a PDF - for end users, testers or clients, in one language or two. Diagram-first, real screenshots, little text, and a short sample approved before the full guide is built.
---

# Guides as PDF

A guide is for someone doing the task with the product open beside them. They look more than they read. Build it around pictures of the real product and the order of the steps.

## Before building

1. **Who reads it, and on what?** Staff on a phone, an admin at a desk, a client on paper. That decides page size, text size and which screens to show.
2. **Which version of the product?** Document what users actually have (the released build), not the branch that happens to run locally.
3. **Which languages?** For two languages, decide the layout once: side by side, or one language per section.
4. **Whose look?** Use the owner's brand: logo, colours, fonts. If none is given, use a clean neutral style and say so.
5. **Make a three-page sample first** (cover, one flow page, one screenshot page) and get a yes before building the rest. Layout changes are cheap at three pages and costly at thirty.

## Shape of the guide

- **Cover**: product, what the guide covers, version and date.
- **One page "the whole flow at a glance"**: a single diagram of the steps and who does each.
- **One section per task**: a title that names the task in the user's words, a numbered flow, and screenshots with the place to tap or click marked.
- **"If something goes wrong"**: the real messages users see, and what to do for each.
- **Who to contact**.

## Rules for the content

- **Diagram-first.** If a flow can be drawn, draw it. Text explains only what the picture cannot.
- **Real screenshots**, taken from the real product on a test account, at the size users see. Never mock-ups passed off as the product.
- **No private data in screenshots.** Use a demo account and demo records. Check each image for names, phone numbers, emails, tokens in the address bar, and other browser tabs.
- **One action per step.** Start with the verb: "Tap **Check in**."
- **Use the words on the screen**, exactly, in bold. If the button says "Submit request", do not write "Send".
- **Every step was actually done** while writing, in order, on the version being documented. A guide is a set of claims; see the `prove-before-posting` skill.
- **Translations are written, not machine-pasted**: short, natural sentences, and the on-screen words kept exactly as the product shows them in that language.

## Building the PDF

Write the content as Markdown or HTML first, so it can be reviewed and changed, then render.

- With gstack installed, `/make-pdf` turns Markdown into a print-quality PDF and `/diagram` draws the flows.
- Otherwise: `pandoc guide.md -o guide.pdf` with a PDF engine, or print an HTML page to PDF with a headless browser. See the `convert-docs` skill.
- Fonts must cover every language used; check that non-Latin text renders as letters, not boxes.

## Before handing over

- Open the PDF and look at **every page**: no cut-off images, no empty pages, no boxes in place of letters, page numbers right.
- Follow the guide from page one on a clean account, doing only what it says.
- File size is sensible for sending (compress images if it is tens of megabytes).
- Deliver the PDF and the source together, so the next change does not start from scratch.
