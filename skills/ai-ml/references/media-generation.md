# Media Generation (Image / Video / Audio)

Merged from: `fal-generate`, `fal-image-edit`, `fal-platform`, `fal-upscale`,
`fal-workflow`, `ai-studio-image`, `claude-d3js-skill` (visualization overlap),
`media`-adjacent generative bits in the library.

## 1. When to use
Generating or editing images/video/audio via hosted model APIs (fal.ai),
Google AI Studio / Gemini image, or local diffusion stacks. Also covers
creative visualization (D3 charts) contexts.

## 2. fal.ai platform
- **fal-generate**: image/video generation. Standard flow: pick a model
  (`flux`, `sdxl`, `kling`, `veo/hailuo`-class video models), pass prompt +
  params, get a result URL (hosted) and/or download.
  - Prompt craft: subject, composition, style, lighting, aspect ratio,
    negative prompt. ~1–2 sentences of concrete instruction beats a paragraph.
  - Params: width/height, steps, guidance/CFG, seed (seed = reproducibility),
    num_images. Start from provider defaults, tweak one at a time.
- **fal-image-edit**: style transfer, inpaint/outpaint, object removal. Provide
  source (URL/base64) + mask region + prompt.
- **fal-upscale**: upscale/resolution enhance; chain after generation.
- **fal-workflow**: create workflow JSON to chain models (segment +
  inpaint + upscale + composite). Define each node, inputs/outputs, connections;
  validate before submit.
- **fal-platform**: model repo management, pricing/usage APIs, usage tracking.
  Use the platform API to enumerate available models and programmatically check
  prices; prefer listing models at runtime instead of hardcoding.

## 3. Google AI Studio / Gemini images
- Yes-capable multimodal generation API; prompt for image edits/generation with
  image inputs. Use for quick creative tooling; keep parity in mind (limited
  resolution/history) — batch with rate limits.

## 4. Business & ops rules
- **Cost + rate limits apply even to "creative" runs**: estimate token/pixel
  cost and set a budget before a multi-image grid or a video batch.
- Retry with backoff on rate limits / 429 / 5xx; request idempotency by fixing
  the seed and params bundle.
- Store outputs: persist to object storage; keep the prompt/params/seed/mode
  alongside the artifact for regeneration and an audit trail.
- Validation: after generation, verify output is non-empty, dimensions correct,
  and (for edits) that the result actually conforms to the edit intent —
  cheap heuristic checks (file size, aspect, hash) before shipping to users.

## 5. Diffusion local (ComfyUI-style) notes
- If using local ComfyUI: workflows are JSON — build nodes for
  load → denoise (sampler) → VAE decode → upscale → save; cache ControlNet/LoRA
  to disk, use fast mode for previews. Same chunked/queued workflow JSON pattern
  as fal-workflow.

## Anti-patterns
- Hardcoding model names when the platform exposes a model list API.
- Firing a 20-image grid without a cost estimate or seed pinning.
- Not persisting prompt+seed → can't repro an "accidental good" generation.
- Passing user input directly into prompts without sanitization (prompt
  injection into image model).

## Quick recipe
1. Choose model (via platform list), pin params + seed.
2. Write a concrete 1–2 sentence prompt (subject, style, aspect).
3. Generate → validate output → persist artifact + metadata.
4. If edit/upscale needed, chain via workflow JSON; retry w/ backoff.
5. Log cost/usage; watch rate limits.