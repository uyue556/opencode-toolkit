# PowerPoint (PPTX) — create, edit, analyze

A `.pptx` is a ZIP of XML + media. Choose the workflow by task: plain text → markitdown; raw XML features
(notes/comments/layouts/animations) → unpack + edit OOXML; new deck from scratch → html2pptx; fill a template →
inventory + replace workflow.

## Table of Contents

- [Reading & analyzing](#reading--analyzing)
- [Design principles (apply before creating)](#design-principles)
- [Create from scratch (html2pptx)](#create-from-scratch-html2pptx)
- [Template-based create (inventory + replace)](#template-based-create)
- [Edit an existing deck (OOXML)](#edit-an-existing-deck-ooxml)
- [Visual validation & thumbnails](#visual-validation--thumbnails)
- [Dependencies](#dependencies)

## Reading & analyzing

```bash
python -m markitdown path-to-file.pptx          # plain text of the deck
```

For comments, speaker notes, slide layouts, animations, and complex formatting you need raw XML:

1. Unpack: `python <unpack.py> <office_file> <output_dir>` (locate with `find . -name unpack.py` if not at path).
2. Read key files:
   - `ppt/presentation.xml` — presentation metadata + slide references
   - `ppt/slides/slide{N}.xml` — each slide's content
   - `ppt/notesSlides/notesSlide{N}.xml` — speaker notes
   - `ppt/comments/modernComment_*.xml` — comments
   - `ppt/slideLayouts/`, `ppt/slideMasters/` — layouts/masters
   - `ppt/theme/theme1.xml` — colors (`<a:clrScheme>`) and fonts (`<a:fontScheme>`)
   - `ppt/media/` — images and other media
3. To emulate a design, extract typography/colors first: theme colors/fonts, then sample `<a:rPr>` in slide1,
   then grep for `<a:solidFill>`/`<a:srgbClr>` across the XML.

## Design principles

Before writing any code, analyze the subject matter and **state your content-informed design approach**:
industry/mood/audience/branding → 3-5 color palette → hierarchy → consistency.

- **Palettes** (adapt, don't autopilot): Classic Blue, Teal & Coral, Warm Blush, Burgundy Luxury,
  Deep Purple & Emerald, Cream & Forest Green, Black & Gold, Sage & Terracotta, Retro Rainbow, etc. —
  choose colors that genuinely match the topic.
- **Web-safe fonts only**: Arial, Helvetica, Times New Roman, Georgia, Courier New, Verdana, Tahoma,
  Trebuchet MS, Impact.
- **Visual detail options** — geometric patterns (diagonal section dividers, asymmetric columns 30/70,
  rotated headers, circular frames), borders (thick one-side borders, corner brackets, underline accents),
  typography (extreme size contrast 72pt vs 11pt, wide letter-spacing caps, monospace for data), chart styling
  (monochrome + single accent, horizontal bars, dot plots, labels on elements, oversized numbers),
  layouts (full-bleed images, sidebars 20-30%, modular grids, Z/F-pattern flow), backgrounds (40-60% color
  blocks, vertical/diagonal gradients, split backgrounds).
- **Charts/tables layout**: two-column (header full-width, text in one column, feature content in the other;
  flexbox with unequal widths ~40/60) or full-slide. **Never vertically stack content below a chart.**

## Create from scratch (html2pptx)

Read the full `html2pptx.md` from the source skill before starting (critical formatting rules).

1. Write one HTML file per slide at proper dimensions (720×405pt for 16:9). Use `<p>/<h1-h6>/<ul>/<ol>` for all
   text; `class="placeholder"` marks regions for charts/tables (gray background for visibility).
   **Rasterize gradients and icons to PNG first with Sharp**, then reference them in HTML.
2. Convert with the bundled `scripts/html2pptx.js` (a `html2pptx()` function per file + PptxGenJS to add
   charts/tables into placeholders, `pptx.writeFile()` to save).
3. **Visual validation** (see below). Fix HTML margins/spacing/colors and regenerate until clean.

PptxGenJS notes: add images with `pptx.addImage({data:...})`; text via `addText` options
(`fontFace`, `fontSize`, `color`, `bold`, `align`, `breakLine`); shapes via `addShape`; charts via
`addChart(pptx.charts.BAR/SCATTER/LINE/PIE, data, opts)` — multiple data series = arrays of row values.

## Template-based create

1. **Extract template text + thumbnails**: `python -m markitdown template.pptx > template-content.md`
   (read it fully) and `python <thumbnail.py> template.pptx` → thumbnail grid.
2. **Write `template-inventory.md`**: list EVERY slide by 0-based index with its layout/purpose (read from the
   thumbnails and markitdown text).
3. **Write `outline.md`** mapping outline slides → template indices. Match layout structure to actual content:
   single-column for one topic; 2-column only for exactly 2 items; 3-column only for exactly 3; image+text only
   with real images; quotes only for real attributed quotes. Never use layouts with more placeholders than you
   have content.
4. **Reorder/duplicate**: `python <rearrange.py> template.pptx working.pptx 0,34,34,50,52`
   (0-based; repeat an index to duplicate).
5. **Extract inventory**: `python <inventory.py> working.pptx text-inventory.json`. Structure is per-slide/
   per-shape: `placeholder_type` (TITLE/CENTER_TITLE/SUBTITLE/BODY/OBJECT/null), position/size in inches,
   `paragraphs[]` with `bullet`/`level`/`alignment`/`space_before`/`space_after`/`line_spacing`/`font_name`/
   `font_size`/`bold`/`italic`/`underline`/`color`/`theme_color`. Only non-default values appear.
6. **Write replacements** to `replacement-text.json`:
   - `"paragraphs"` field (NOT `replacement_paragraphs`) — proper paragraph objects, not bare strings.
   - **All shapes without a `paragraphs` field are auto-cleared** — only list shapes you want to fill.
   - Bullets: `{"bullet": true, "level": 0}` — never include •/-/* characters (added automatically), and don't
     set `alignment` when `bullet: true`.
   - Preserve original paragraph props; headers/bold, center-aligned titles keep `"alignment": "CENTER"`;
     colors via `"color":"FF0000"` or `"theme_color":"DARK_1"`.
   - Overlapping shapes: prefer the shape with larger `default_font_size` or a more specific placeholder type.
   - The script validates every referenced shape/slide before applying (all errors shown at once).
7. **Apply**: `python <replace.py> working.pptx replacement-text.json output.pptx`. Watch for
   "overflow worsened" errors and shorten text where flagged.

## Edit an existing deck (OOXML)

Read the full `ooxml.md` from the source skill first.

1. Unpack (`unpack.py`), edit `ppt/slides/slide{N}.xml` (+ related files).
2. **Validate immediately after every edit**: `python <validate.py> <dir> --original <file>` — fix errors before
   continuing.
3. Repack: `python <pack.py> <input_directory> <office_file>`.

Slide XML essentials: `<p:sld>` root with `<p:cSld><p:spTree>`; text = `<p:sp><p:txBody><a:p><a:r><a:rPr>/<a:t>`;
formatting on `<a:rPr>` (bold `b="1"`, size `sz` in hundredths of pt, color `<a:solidFill><a:srgbClr val="FF0000"/>`);
lists = `<a:pPr marL=... indent=...><a:buChar char="•"/>`; points in EMU (914400/inch). Add/duplicate/reorder/
delete slides by editing `p:sldIdLst` + the slide files + `[Content_Types].xml`.
Before packing: verify every image has a correct `ppt/media/` entry + content-type; check part names; keep rels
(`_rels/slideN.xml.rels`) consistent after adding shapes/images.

## Visual validation & thumbnails

```bash
python <thumbnail.py> template.pptx            # generates thumbnails.jpg grids (default 5 cols, ≤30 slides)
python <thumbnail.py> deck.pptx grid --cols 4  # custom prefix + columns (3-6)
soffice --headless --convert-to pdf deck.pptx  # then:
pdftoppm -jpeg -r 150 -f 2 -l 5 deck.pdf slide  # per-page JPEGs (150 DPI; -f/-l for a range)
```

Inspect for: text cutoff by bars/shapes/edges; text overlap; content too close to boundaries; contrast failures.
Iterate until every slide is visually correct.

## Dependencies

`pip install "markitdown[pptx]" defusedxml`; `npm install -g pptxgenjs playwright react-icons react react-dom sharp`;
LibreOffice + `poppler-utils` (soffice, pdftoppm). Scripts referenced as `<*.py>`
(unpack/validate/pack/thumbnail/rearrange/inventory/replace) ship with the official pptx skill; locate with
`find . -name '<name>.py'` if not present.