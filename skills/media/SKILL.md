---
name: media
description: >
  End-to-end media production skill covering video/audio editing and pipelines (VideoDB SDK ingest/search/edit/
  transcode/reframe/subtitles/generative/streaming, ffmpeg + Tesseract frame extraction & OCR, yt-dlp note-taking,
  Remotion programmatic video), AI image generation & editing (Gemini Nano Banana Pro, Stability AI SD3.5 with
  model-routing decision matrix), generative art & canvas design (p5.js interactive artwork, printed-canvas
  compositions), and presentations (PPTX create/edit/analyze via html2pptx + OOXML, animation-rich HTML slides,
  Google Slides automation). Use whenever the user asks to generate or edit images/photos (生成图片/编辑图片/照片),
  make art or logos, create/transcode/trim videos, transcribe, subtitle, or search inside video (视频/字幕/转码/
  剪辑), render walkthrough or programmatic videos, extract frames or OCR screen content from video, build slide
  decks or convert PPT (PPT/幻灯片/演示文稿/pitch/slides), or make posters/generative artwork.
---

# Media

Media production: video & audio pipelines, image generation & editing, generative art, and presentations.

## When to use

Use this skill when the task involves any of these media domains:

- **Video / audio** — ingest, transcode, trim, combine, subtitle, transcribe, search inside by speech or scene,
  reframe for social platforms, generate background music/voiceovers, live-stream monitoring, desktop/screen
  capture, extract key frames + OCR, YouTube-to-notes, or programmatic video rendering.
- **Images** — text-to-image, image editing/inpainting/erase, upscale, remove background, style transfer,
  logos/mockups/infographics, or picking the right image model.
- **Generative art / design** — algorithmic or visual "philosophy"-driven artwork (p5.js, canvas PDF/PNG),
  posters, and design-forward artifacts.
- **Presentations** — create a .pptx from scratch or a template, edit/analyze an existing .pptx (including raw
  XML, notes, comments), convert PPT → HTML slides, or build/automate slide decks.

## Core workflow

1. **Classify the media type** — video/audio, image, generative art, or presentation.
2. **Pick the tool path** using the routing below (server-side AI APIs over local tools where possible).
3. **Configure credentials** — each provider needs an env var: `GEMINI_API_KEY`, `STABILITY_API_KEY`,
   `VIDEO_DB_API_KEY`, Google OAuth for Slides. Never read/handle secrets yourself; have the user set them.
4. **Do the work, then validate visually** — thumbnails/contact sheets/preview Studio. Iterate until layouts and
   framing are correct.

## Selection routing

| Task | Tool / reference |
|---|---|
| Video & audio ingest, search, edit, transcribe, subtitle, reframe, AI media, streaming, live streams, desktop capture | `references/videodb.md` |
| Extract key frames + OCR from local video (ffmpeg + Tesseract) | `references/video-local-processing.md` |
| Turn a YouTube talk into a local study-note library | `references/video-local-processing.md` |
| Programmatic / walkthrough / React-rendered videos | `references/remotion.md` |
| Realistic photos of people / lifestyle / influencer | Gemini Nano Banana — `references/image-generation.md` |
| Art, illustration, concept art, inpainting, upscale, remove-bg | Stability AI — `references/image-generation.md` |
| Generate or edit any image (UI placeholders, logos, docs) | `references/image-generation.md` |
| Generative p5.js interactive artwork (algorithmic philosophy) | `references/generative-art.md` |
| Design-forward canvas / poster / print artifact | `references/generative-art.md` |
| Create/edit/analyze .pptx (html2pptx, OOXML, template fill) | `references/pptx.md` |
| Animation-rich HTML presentation or PPT→HTML conversion | `references/html-slides.md` |
| Automate Google Slides via API (no MCP) | `references/google-slides.md` |

## Video & audio pipelines

**Prefer the cloud SDK when it covers the operation.** VideoDB handles server-side: trimming, combining clips,
subtitles, text/image/audio overlays, transcoding, resolution & aspect-ratio changes, transcription, and AI media
generation. Only fall back to local tools (ffmpeg/moviepy) for transitions, speed changes, crop/zoom, colour
grading, and volume mixing.

- **VideoDB** (`pip install "videodb[capture]" python-dotenv`, `VIDEO_DB_API_KEY`): upload file/URL/YouTube, build
  spoken-word & scene indexes, search with timestamps and compile results to clips, edit on a `Timeline`
  (`VideoAsset`, `TextAsset`, `AudioAsset`, `ImageAsset`, `CaptionAsset`), transcode/`reframe()`, generate
  images/voice/music/SFX, stream HLS links, RTSP live monitoring, and macOS desktop capture. Validate timestamps
  (`start >= 0`, `start < end`, `end <= length`) and always `index_spoken_words(force=True)` to stay idempotent.
  Full detail: `references/videodb.md`.
- **Local frame + OCR** (ffmpeg + Tesseract): extract key frames at a fixed interval, run OCR, and emit a
  timestamped Markdown transcript. Great for "read what is on screen" from lectures/screencasts. Pick interval by
  pace: 10-15s for fast-changing content, 30-60s for slide-based talks. `chi_sim+eng` for bilingual Chinese OCR.
- **YouTube → study notes**: yt-dlp + ffmpeg scene detection → curated contact sheet → clean VTT transcript →
  one markdown file per video in a plain folder served by a tiny stdlib server. Markdown files are the source of
  truth; never hardcode video data into the HTML viewer.
- **Remotion**: React components render video programmatically — screens sequenced with `<Sequence>`, transitions
  from `@remotion/transitions` (fade/slide/zoom via `spring()`), text overlays and hotspots, audio with `<Audio>`.
  Build walkthrough videos from app screens (e.g. Stitch) using a `screens.json` manifest; preview in Remotion
  Studio, then `npx remotion render <Composition> output.mp4`.

## Image generation & editing

**Route the request, don't default to one model:**

1. **Realistic human photo / lifestyle / influencer shot** → Gemini Nano Banana Pro (Gemini 3 Pro image).
2. **Art, illustration, concept art, or any image *editing*** (inpaint, erase, remove-bg, upscale, search-replace)
   → Stability AI (SD3.5 / Ultra / Core).
3. Fall back across models when one fails (rate limit / credits): adapt the prompt and tell the user.

- **Gemini Nano Banana Pro** (`gemini-3-pro-image-preview`, `GEMINI_API_KEY`): text-to-image, multi-image
  composition (up to 14 refs), inpainting with semantic masking, style transfer, aspect ratios 1:1…21:9, 1K/2K/4K,
  accurate in-image text rendering. Always send image payloads **file-based** (base64 in a JSON file — never on the
  command line) to avoid "argument list too long". Prompt descriptively: subject + environment + lighting + style
  + mood; say exactly what to change and what to preserve when editing.
- **Stability AI** (`STABILITY_API_KEY`, Community license ~150 req/10s, 100 img/day): modes are
  `generate|ultra|core|img2img|upscale|upscale-creative|remove-bg|inpaint|search-replace|erase`. 15 style presets
  (photorealistic, anime, digital-art, oil-painting, watercolor, pixel-art, 3d-render, concept-art, comic,
  minimalist, fantasy, sci-fi, sketch, pop-art, noir). Prompt structure: `subject + action + artistic style +
  cinematic lighting + quality + reference artist + colors`, plus universal negative prompts.
  Aspect-ratio aliases: `square(1:1) portrait(2:3) landscape(3:2) photo(4:5) wide(16:9) ultrawide(21:9)
  stories(9:16) phone(9:21)`.
- Full API calls, prompting best practices, and error handling: `references/image-generation.md`.

## Generative art & canvas design

Both workflows follow the same two-step pattern: **write a philosophy first, then express it in code**.
The philosophy names a movement, articulates it in 4-6 paragraphs, stresses master-level craftsmanship
repeatedly, and leaves the implementation room for creative interpretation. The final artifact must feel like the
work of a top practitioner — controlled, balanced, and reproducible.

- **Algorithmic art (p5.js)** — beauty lives in process: flow fields, particles, noise, L-systems, Voronoi. Always
  seed randomness (`randomSeed(seed); noiseSeed(seed);`) so the same seed reproduces the same output. Output a
  single self-contained HTML artifact with a parameter sidebar (seed nav, sliders, color pickers, regenerate/reset/
  download) and p5.js from CDN. Parameters come from the *philosophy* (what should be tunable?), not from a menu of
  pattern types.
- **Canvas / print design** — ideas communicate through space, form, color, composition; text is sparse and only
  an accent. Output a single PDF/PNG (multi-page only when asked). Every element must fit inside the canvas with
  margins — nothing overlaps, nothing falls off the page. Use distinctive fonts, not system defaults.
- Detail: `references/generative-art.md`.

## Presentations

- **PPTX analysis/reading** — `python -m markitdown file.pptx` for plain text; unpack the ZIP for comments, notes,
  layouts, themes (`python <unpack.py> <file> <dir>`; key files `ppt/presentation.xml`, `ppt/slides/slide{N}.xml`,
  `ppt/notesSlides/`, `ppt/slideLayouts/`, `ppt/slideMasters/`, `ppt/theme/theme1.xml`, `ppt/media/`).
- **PPTX creation (from scratch)** — write one HTML file per slide (e.g. 720×405pt for 16:9), rasterize gradients/
  icons to PNG with Sharp first, then convert with the bundled `scripts/html2pptx.js` (PptxGenJS), fill chart/table
  placeholders, and **visually validate** via a thumbnail grid (soffice → PDF → `pdftoppm -jpeg -r 150`) checking
  for text cutoff/overlap/contrast.
- **PPTX editing (raw OOXML)** — unpack, edit slide XML, validate after every edit, repack. For template-based
  decks, drive the whole fill workflow: extract text + thumbnails, write a template inventory, plan an outline,
  `rearrange.py` to reorder/duplicate slides, `inventory.py` → JSON, write replacements (paragraph objects, not
  bare strings; bullets get `"bullet": true, "level": 0` with no bullet characters), `replace.py` to apply.
  Match layout structure to actual content (2 items → 2-column, never a 3-column force-fit).
- **Design principles (all decks)** — state your content-informed design approach *before* building; pick a
  3-5 color palette that genuinely fits the subject; use web-safe fonts; build clear visual hierarchy; use
  two-column or full-slide layouts for charts/tables — never stack them below text.
- **HTML slides** — single self-contained HTML file, every slide `height: 100vh/100dvh; overflow: hidden`,
  all type via `clamp()`, include `references/viewport-base.css` in full, respect per-slide content density limits
  (split rather than scroll), support `prefers-reduced-motion`. Discovery is "show, don't tell": generate 3 style
  previews from the user's mood before building. PPT→HTML conversion preserves text, images, order, and speaker
  notes (as HTML comments).
- **Google Slides** — OAuth-based CLI scripts (`auth.py`, `slides.py`) for get-text/find/create/add-slide/
  replace-text/delete-slide/batch-update; tokens in the OS keyring. Requires a Workspace account.
- Detail: `references/pptx.md`, `references/html-slides.md`, `references/google-slides.md`.

## Best practices

- Configure credentials up front; fail loudly if `*_API_KEY` is missing.
- Prefer server-side/API pipelines over hand-rolling ffmpeg when the API covers the operation.
- Validate media results visually (thumbnails, contact sheets, Remotion Studio, browser) — layout bugs are
  invisible to text-only checks.
- Keep everything deterministic where it matters: seed images/generative art for reproducibility.
- Reuse existing libraries/patterns (PptxGenJS, `@remotion/transitions`, python-pptx) instead of reimplementing.
- Match output format to the destination platform (aspect ratio, resolution, codec).

## Do & don't

- **Do** say which model/tool you chose and why before generating.
- **Do** keep prompts specific: subject, environment, lighting, style, mood, and preservation instructions.
- **Do** namespace media files per source (e.g. `<youtube-id>-slide-NN.jpg`) to avoid collisions.
- **Do** catch "no results found" and "already indexed" errors and degrade gracefully (empty list / reuse index).
- **Don't** pass base64 image data as CLI arguments — always write a request JSON file.
- **Don't** cram a slide or a viewport; split content instead of scrolling.
- **Don't** clear/overwrite a shape's text unintentionally — the PPTX replace workflow clears any shape without a
  `paragraphs` field.

## Common pitfalls

| Symptom | Fix |
|---|---|
| Timeline stream breaks / looks wrong | Validate `start >= 0`, `start < end`, `end <= video.length` |
| `InvalidRequestError: No results found` | Catch and treat as empty, don't crash |
| "Spoken word index already exists" | `index_spoken_words(force=True)` |
| Long `reframe()` hangs | Reframe a short segment or use `callback_url` async |
| `argument list too long` | Use file-based API requests, not inline base64 |
| Tesseract garbage output | Install correct language pack (`chi_sim`); check `tesseract --list-langs` |
| HTML slide overflows viewport | Enforce `overflow:hidden`, `clamp()`, density limits; split the slide |
| Rendered video blurry | Keep full-res source images; PNG for UI, JPG for photos |

## References

- `references/videodb.md` — VideoDB SDK: setup, upload, indexing, search, timeline editing, transcode/reframe,
  generative media, streaming, RTSP, desktop capture, error handling.
- `references/video-local-processing.md` — ffmpeg+Tesseract frame extraction & OCR; YouTube → markdown study library.
- `references/remotion.md` — Remotion composition architecture, transitions, overlays, rendering, best-practice rules.
- `references/image-generation.md` — Gemini Nano Banana Pro + Stability AI: API usage, prompt recipes, routing matrix.
- `references/generative-art.md` — algorithmic p5.js art + canvas/print design philosophy workflow.
- `references/pptx.md` — PPTX create/edit/analyze: html2pptx, OOXML, template workflow, design guidance.
- `references/html-slides.md` — HTML presentations: viewport fitting, density limits, style discovery, animation.
- `references/google-slides.md` — Google Slides OAuth CLI automation.
- `references/viewport-base.css` — mandatory CSS base for HTML slides (copy in full).
- `scripts/html2pptx.js` — HTML-slide → PPTX converter library (PptxGenJS + playwright).

## Limitations

- Providers require their own accounts/API keys; report plan/rate limits to the user instead of guessing.
- Local pipelines need ffmpeg/Tesseract/LibreOffice/Poppler on PATH.
- Desktop capture (VideoDB) is macOS-only.
- Validate generated artifacts against the user's real sources before treating them as final.
