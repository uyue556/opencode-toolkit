# Dedup notes — `media` consolidation

Consolidates 18 source skills from 5 libraries into one `media` skill
(SKILL.md + 8 reference files + `scripts/html2pptx.js` + `references/viewport-base.css`).

## Sources scanned (18 SKILL.md)

- **media/** (6): image-generator, remotion, remotion-best-practices, stability-ai, videodb, videodb-skills
- **media-processing/** (1): video-content-extractor
- **video/** (1): youtube-notetaker
- **graphics-processing/** (5): algorithmic-art, canvas-design, image-studio, imagen
  (4 skills — library claimed 5, only 4 SKILL.md present)
- **presentation-processing/** (5): frontend-slides, google-slides-automation, nanobanana-ppt-skills,
  pptx-official

## Topics merged

- **Video & audio pipelines** — videodb + videodb-skills (same SDK marketing + API; merged, best detail kept)
  → `references/videodb.md`.
- **Local video processing** — video-content-extractor (ffmpeg+Tesseract OCR) + youtube-notetaker (yt-dlp
  study library) → `references/video-local-processing.md`.
- **Remotion programmatic video** — remotion (walkthrough workflow) + remotion-best-practices (rule catalog)
  → `references/remotion.md`.
- **Image generation & editing** — image-generator (Gemini Nano Banana) + imagen (Gemini, thin wrapper — fully
  folded into Nano Banana) + stability-ai (Stability modes/styles/prompts) + image-studio (routing matrix) →
  `references/image-generation.md`.
- **Generative art & canvas design** — algorithmic-art (p5.js) + canvas-design (print/canvas) →
  `references/generative-art.md`.
- **Presentations / slides** — pptx-official (html2pptx + OOXML + template workflow + design guidance) +
  html2pptx.md + ooxml.md → `references/pptx.md`; frontend-slides → `references/html-slides.md`;
  google-slides-automation → `references/google-slides.md`.

## Duplicates dropped

- **videodb-skills** and **videodb** describe the same SDK; the second is a superset (richer shared SKILL.md +
  10 reference files). videodb-skills' capabilities table and setup were merged; the file dropped.
- **imagen** is a thin re-skin of image-generator (calls the same `gemini-3-pro-image-preview` model); its
  cross-platform Python wrapper, `.env.example`, and use-cases were absorbed into image-generation.md.
- **image-studio** is a router over ai-studio-image + stability-ai; only the routing decision matrix and
  fallback logic were kept (its referenced scripts/ai-studio-image live outside this collection).
- **nanobanana-ppt-skills** is an empty stub (28 lines, points to a GitHub repo, no content). Dropped as a
  distinct skill; noted in SKILL.md routing as "AI-powered PPT generation" covered by pptx.md/html-slides.md.
- Frontmatter boilerplate, "When to Use"/"Limitations" filler paragraphs, marketing preambles, and
  self-congratulatory framing repeated across all source skills were stripped.

## Scripts carried

- `scripts/html2pptx.js` (39 KB) — from presentation-processing/pptx-official/scripts/. The one genuinely
  reusable deterministic library in the collection (HTML→PPTX converter). Kept byte-for-byte.
- `references/viewport-base.css` (4 KB) — from presentation-processing/frontend-slides/. Mandatory CSS base for
  HTML slides; kept as a reference asset since SKILL.md instructs copying it in full.

## Dropped assets (deliberately)

- `algorithmic-art/templates/viewer.html` (21 KB) and `generator_template.js` (7.8 KB) — heavy Anthropic-branded
  HTML template tied to one provider's artifact chrome; content reproduced as guidance (fixed UI chrome, seed
  nav, parameter/action structure) in references/generative-art.md. Not general-purpose.
- `youtube-notetaker/scripts/*` and `reference/artifact.html` (20 KB) — the source library ships only the
  artifact; the scripts it references (setup/download/detect_slides/contact_sheet/extract_slides/
  vtt_to_transcript/write_library_item/serve/verify) are NOT present in the collection, so the pipeline was
  documented in references/video-local-processing.md instead of copied.
- `pptx-official` OOXML/helper Python scripts (unpack/validate/pack/thumbnail/rearrange/inventory/replace) are
  referenced but absent from the provided libraries; documented with `find . -name` fallback notes.
- `videodb/*` reference files and remotion-best-practices `rules/*` were heavily condensed, on the assumption
  the full SDK/skill repos remain available online (links kept).

## Gaps / doubts

- Could not read in full: the 28 remotion `rules/*.md`, the 10 VideoDB `reference/*.md`, and the remaining
  Stability reference docs (api-reference/prompt-engineering/setup-guide) — captured via heading skims plus the
  main SKILL.md contents, which themselves are thorough.
- graphics-processing claimed 5 skills but only 4 subdirectories exist; nothing surfaced for the 5th.
- Scripts referenced by pptx-official, youtube-notetaker, google-slides-automation (auth.py/slides.py) and
  stability-ai (generate.py) are absent from this collection; the consolidated skill documents their expected
  CLI signatures but cannot run them without the original repos.
- Image-model names are volatile (Gemini "Nano Banana Pro", Stability SD3.5); treat model IDs as current-as-of
  consolidation and re-check provider docs if calls fail.