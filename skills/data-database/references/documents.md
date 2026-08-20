# Document Processing — PDF & DOCX

Synthesized from: `pdf-official` (+ forms/reference), `docx-official` (+ docx-js/ooxml),
`doc-coauthoring`.

## ToC

1. [PDF processing](#pdf-processing)
2. [DOCX workflows](#docx-workflows)
3. [Tracked changes / redlining](#tracked-changes--redlining)
4. [Document co-authoring workflow](#document-co-authoring-workflow)

## PDF processing

Tools: **pypdf** (merge/split/rotate/metadata/watermark/encrypt), **pdfplumber** (text + table
extraction with layout), **reportlab** (create PDFs: Canvas or Platypus flowables), CLI tools
**pdftotext/qpdf/pdftk/pdfimages** (poppler).

- Extract text: `pypdf` `page.extract_text()` or pdfplumber (better layout); tables:
  `page.extract_tables()` → pandas `pd.DataFrame` → Excel/CSV.
- Create: reportlab Canvas (`drawString`) for simple; `SimpleDocTemplate` + Paragraph/Spacer/PageBreak
  for multi-page reports.
- CLI: merge `qpdf --empty --pages a.pdf b.pdf -- merged.pdf`; split `qpdf in.pdf --pages . 1-5 -- out.pdf`;
  text `pdftotext -layout in.pdf out.txt`; images `pdfimages -j in.pdf prefix`.
- Scanned PDFs → OCR: `pdf2image` + `pytesseract` (convert pages to images, then OCR per page).
- Forms: fill via `pdf-lib` (JS) or pypdf; password: `writer.encrypt(user, owner)`; decrypt `qpdf --decrypt`.
- Quick map: merge/split → pypdf; extract text/tables → pdfplumber; create → reportlab; bulk CLI →
  qpdf/poppler; OCR → pytesseract.

## DOCX workflows

A `.docx` is a ZIP of XML. Choose by task:

- **Read/analyze**: `pandoc file.docx -o out.md` (structure + tracked changes via
  `--track-changes=accept|reject|all`). For comments/formatting/media/metadata, unpack and read raw XML:
  `word/document.xml` (body), `word/comments.xml`, `word/media/`; tracked changes use `<w:ins>`/`<w:del>`.
- **Create new**: use **docx-js** (JS/TS: `Document`, `Paragraph`, `TextRun`, `Packer.toBuffer()`).
- **Edit existing**: Python Document library (OOXML manipulation) — unpack → script edits → pack.
  (Docs: `ooxml.md` API + DOM patterns.)
- **Convert to images** for visual analysis: `soffice --headless --convert-to pdf file.docx` then
  `pdftoppm -jpeg -r 150 file.pdf page` (`-f N -l M` for a page range).

## Tracked changes / redlining

Default for editing someone else's document; required for legal/academic/business/gov docs.

- Principle: **minimal, precise edits** — mark only what changed. Break a replacement into
  [unchanged + `<w:del>` + `<w:ins>` + unchanged]; reuse the original `<w:r>` (preserve its `w:rsidR`)
  for unchanged text so reviewers see a clean diff, not a full-sentence rewrite.
- Workflow: markdown with tracked changes → identify changes (locate by section/heading/unique text,
  NOT markdown line numbers) → group into batches of 3–10 → unpack, grep `word/document.xml` to map
  text to `<w:r>` runs → implement each batch with the Document library → pack → final verification
  (`pandoc --track-changes=all` + grep that old text is gone and new text present).
- Dependencies: pandoc, docx (npm), LibreOffice, poppler-utils, defusedxml (secure XML parsing).

## Document co-authoring workflow

Structured collaborative drafting:

1. **Context gathering**: ask about audience, purpose, tone, constraints; collect info in stages.
2. **Refinement & structure**: clarifying questions → brainstorm → curate → gap check → draft →
   iterative refinement (quality checks, near-completion review).
3. **Reader testing**: predict reader questions, test with a sub-agent/simulated reader, run checks,
   report and fix; iterate.
4. **Final review**: consistency, tone, completeness; exit when reader testing passes.
