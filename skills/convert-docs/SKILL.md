---
name: convert-docs
description: Use when a document has to change format or be read from an awkward one - Markdown to PDF or Word, Word or PowerPoint to PDF, PDF to text, HTML to PDF, spreadsheet to CSV and back, scanned pages or images to text, or merging, splitting and compressing PDFs. Picks the tool, runs it locally, and checks the result opens and looks right.
---

# Converting documents

## Rules

- **Convert locally.** Do not upload a document to an online converter: that publishes it. If only an online tool can do the job, ask first.
- **Never overwrite the original.** Write the result beside it with a new name.
- **Treat incoming files as untrusted.** Put a downloaded file in its own empty folder, keep your scripts elsewhere, and do not open macros.
- **Check the result by opening it**, not by the command's exit code.

## Which tool

| From | To | Use |
|---|---|---|
| Markdown | PDF | `pandoc in.md -o out.pdf --pdf-engine=xelatex` (or `weasyprint`, `typst`); gstack's `/make-pdf` for print quality |
| Markdown | Word | `pandoc in.md -o out.docx` (add `--reference-doc=template.docx` for house style) |
| Markdown | HTML | `pandoc in.md -s -o out.html` |
| Word, PowerPoint, Excel | PDF | `soffice --headless --convert-to pdf --outdir out in.docx` (LibreOffice) |
| Word | Markdown | `pandoc in.docx -t gfm --extract-media=media -o out.md` |
| HTML | PDF | a headless browser's print-to-PDF: `chromium --headless --print-to-pdf=out.pdf in.html` |
| PDF | text | `pdftotext -layout in.pdf out.txt` (poppler) |
| PDF | images | `pdftoppm -png -r 150 in.pdf page` |
| Scanned PDF or image | text | `ocrmypdf in.pdf out.pdf` (adds a text layer), or `tesseract page.png out -l eng` |
| PDF | merge, split, rotate | `qpdf --empty --pages a.pdf b.pdf -- out.pdf`; `qpdf in.pdf --pages . 1-5 -- out.pdf` |
| PDF | smaller PDF | `gs -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -dNOPAUSE -dBATCH -sOutputFile=out.pdf in.pdf` |
| Excel | CSV | LibreOffice `--convert-to csv`, or Python `openpyxl` / `pandas` for a chosen sheet |
| CSV | Excel | Python `pandas` or `openpyxl`; set column types on purpose |
| Images | PDF | `img2pdf *.png -o out.pdf` |

Missing tools on macOS: `brew install pandoc poppler qpdf ghostscript ocrmypdf` and `brew install --cask libreoffice`.

When Claude's own document skills are available (`docx`, `pdf`, `pptx`, `xlsx`), use them for creating and editing those formats; they handle styles, tracked changes and formulas better than a plain converter.

## What goes wrong, and the check for each

- **Fonts and non-Latin text.** Boxes or question marks mean the font lacks those letters. Pick a font that covers the script and name it in the command. Look at a page that has that text.
- **Tables and wide content** run off the page. Look at the widest table; switch to landscape or a smaller font for that section.
- **Images** go missing when paths are relative to somewhere else. Run the converter from the document's folder, or use `--resource-path`.
- **Page count.** Compare with the original. A 12-page Word file that becomes 9 pages has lost something.
- **Spreadsheets.** Dates turn into numbers, long IDs lose digits or leading zeros, formulas become their last cached values, and only the first sheet is exported. Compare row counts and spot-check the first, last and a middle row.
- **Scans.** Recognised text has errors, worst in numbers and names. Never use it for amounts or IDs without checking against the image.
- **PDF to Word** is lossy. Say so before the person starts editing the result.
- **Hidden content travels too**: tracked changes, comments, speaker notes, hidden sheets, document properties with the author's name. Check and remove them before a file goes to someone outside.

## Reporting

Say which tool and options were used, where the result is, the page or row count compared with the original, and anything that did not come through cleanly.
