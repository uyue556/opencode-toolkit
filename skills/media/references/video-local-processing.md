# Local video processing — frame extraction + OCR and YouTube note-taking

Two local (no-cloud) pipelines: turning any video file into a timestamped OCR transcript, and turning a
YouTube talk into a portable markdown study library. Both require tools on PATH: `ffmpeg`, `ffprobe`,
`tesseract` (first), and `yt-dlp` (second).

## Table of Contents

- [Frame extraction + OCR (video-content-extractor)](#frame-extraction--ocr)
- [YouTube → markdown study library (youtube-notetaker)](#youtube--markdown-study-library)

## Frame extraction + OCR

Goal: "read what is on screen" — key frames at a fixed interval + Tesseract OCR → structured Markdown report
(duration, resolution, codecs, plus frame-by-frame timestamped transcripts).

Workflow:
1. `ffprobe` for metadata (duration, resolution, fps, codecs, size).
2. `ffmpeg` capture a frame every `interval` seconds (default 30) as timestamped JPEGs.
3. `tesseract` OCR each frame; if default PSM yields no meaningful text, fall back to automatic page
   segmentation.
4. Assemble a Markdown report with all frames + transcripts + timestamps.

Example calls (script shape):

```bash
python scripts/extract_video.py recording.mp4 ./output 60 eng          # every 60s, English OCR
python scripts/extract_video.py lecture.mp4 . 15 chi_sim+eng           # Chinese + English OCR
```

Best practices:
- Short intervals (10-15s) for fast-paced content with frequent text changes; longer (30-60s) for slides or
  slow lectures to avoid near-duplicate frames.
- For Chinese content ensure the Tesseract Chinese pack is installed (`chi_sim`); verify with
  `tesseract --list-langs`.
- Frame extraction is time-based, not scene-change-based — expect duplicates on static content.

Limitations: no audio/SST extraction; accuracy depends on video quality and font clarity; short intervals on
long videos consume a lot of disk. Fully local — nothing leaves the machine, source file is never modified.

## YouTube → markdown study library

Each video becomes one plain markdown file (frontmatter metadata + `slides` array + a `[HH:MM:SS] text`
transcript body); slide images live in `_media/` namespaced `<youtube_id>-slide-NN.jpg`. A small stdlib+PyYAML
server renders the library as an interactive deep-dive in the browser. No database, no cloud.

Architecture:
- **Library dir** — set by `VIDEO_LIBRARY_DIR` (default `~/video-deepdives/`). One `.md` per video; filename
  slug = YouTube id. **Markdown is the single source of truth** — never hardcode video data into HTML.
- **Server** — `python3 scripts/serve.py --dir ~/video-deepdives --port 8000`. API:
  `GET /api/video-deepdives` (list), `GET /api/video-deepdives/<id>` (item), `.../_media/<file>` (image),
  `PATCH /api/video-deepdives/<id>` with `{fields:{slides:[...]}}` (note write-back). New videos are picked up
  the moment a `.md` file exists.
- **Artifact** — `reference/artifact.html` served at `/`; only rewrite for UI changes.

Pipeline (all helper scripts in the source skill's `scripts/`):
1. `setup.sh "<url_or_id>"` — resolves the 11-char id, prints scratch dir + target path, and whether YouTube
   **embedding is allowed** (oembed 200) or blocked (401; the viewer then degrades to "open at this moment on
   YouTube" links — proceed normally).
2. `download.sh <YTID> <scratch>` — yt-dlp grabs the video (≤720p is plenty for slide frames) + best subtitles
   (manual, else auto-captions) as `.vtt`.
3. `detect_slides.sh video.mp4 <scratch>` — ffmpeg scene detection `select='gt(scene,0.3)'` → `scene_times.txt`.
   Lower to 0.2 for subtle decks, raise to 0.4 for busy video.
4. `contact_sheet.py` — build a labeled contact sheet. **This is the human-judgment step**: keep real content
   slides, drop talking heads/transitions/duplicates/blurry frames. Save kept timestamps to `keep.txt` (a talk
   usually yields 15-25 slides).
5. `extract_slides.py <YTID> video.mp4 keep.txt > slides.json` — extract at 1280px wide JPEG, copy into
   `_media/`, print a clean `slides.json` scaffold (redirect stdout!). Fill in `title` and `note` for each.
   Re-anchor each slide's `t` to where it is actually discussed in the transcript.
6. `vtt_to_transcript.py *.vtt transcript.txt` — parse + de-duplicate the VTT (YouTube auto-captions repeat
   rolling text) into clean `[HH:MM:SS] text` lines.
7. `write_library_item.py --id YTID --title "..." --speaker "..." --tags a,b,c --slides slides.json
   --transcript transcript.txt` — writes the final `.md` (notes must be grounded in the transcript; don't
   invent claims).
8. `serve.py --dir "$VIDEO_LIBRARY_DIR" --port 8000 &` then `verify.sh <YTID>` (curls collection, item, first
   slide image, artifact; asserts HTTP 200). Open `http://127.0.0.1:8000/#/<YTID>` to confirm rendering.

Markdown shape:

```markdown
---
id: RtywqDFBYnQ
title: Memory and dreaming for self-learning agents
youtube_id: RtywqDFBYnQ
speaker: Mahesh, Product Manager, Platform team at Anthropic
source_url: https://www.youtube.com/watch?v=RtywqDFBYnQ
slide_count: 19
created: '2026-05-25'
tags: [anthropic, memory, agents]
slides:
- idx: 1
  t: 55.7                 # seconds (float ok), used for seeking
  mmss: "00:55"           # display label
  title: Agent primitives have evolved
  note: One to three sentences grounded in the transcript at this timestamp.
  img: /api/video-deepdives/_media/RtywqDFBYnQ-slide-01.jpg
---
## Transcript
[00:00:08] Hello, everyone...
```

Notes: `idx` may be sparse — the artifact sorts by `t`. `img` is always the `/api/...` URL, never base64.
The user edits `note` in the UI; PATCH writes the whole `slides` array back.

Gotchas:
- Embedding disabled (oembed 401) → inline player blocked; the viewer shows a "open at this moment" link instead.
- **Never** reuse bare `slide-NN.jpg` across videos — always namespace `YTID-slide-NN.jpg`.
- Don't dump raw VTT into the body; always run it through the provided parser.
- Don't touch existing videos when adding a new one — each video is an independent file.
- Server not picking up a video → confirm the `.md` is directly inside `--dir` (not a subfolder) and named
  `<YTID>.md`.
- Avoid em dashes (—) and arrows (→) in notes/titles.

Requirements: `pip install yt-dlp pillow pyyaml`; `ffmpeg` via package manager.
