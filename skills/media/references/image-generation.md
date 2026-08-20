# AI image generation & editing

Two primary engines plus a routing matrix. Route the request by *what kind of output* the user wants, not by
familiarity with one model.

## Table of Contents

- [Routing matrix](#routing-matrix)
- [Gemini Nano Banana Pro (Google)](#gemini-nano-banana-pro-google)
- [Stability AI (SD3.5 / Ultra / Core)](#stability-ai-sd35--ultra--core)
- [Prompt recipes](#prompt-recipes)
- [Error handling & limits](#error-handling--limits)

## Routing matrix

```
User request
  ├─ realistic photo of a person / influencer / lifestyle / headshot  → Gemini Nano Banana Pro
  ├─ art / illustration / concept art / poster / game asset           → Stability AI (generate|ultra|core)
  ├─ edit an existing image (inpaint/erase/search-replace/img2img)    → Stability AI
  ├─ upscale / remove background / resize                             → Stability AI
  └─ ambiguous UI placeholder / doc / logo / any simple generation    → Gemini (fast, free, accurate text)
```

Fallback & redundancy:
- Gemini fails (daily limit, API error) → retry with Stability `ultra` and an art-adapted prompt; tell the user.
- Stability fails (credits) → retry with Gemini and a photographic prompt.
- Both fail → hand the user a detailed prompt usable in DALL-E/Midjourney/Leonardo.

## Gemini Nano Banana Pro (Google)

Model `gemini-3-pro-image-preview`, key from `GEMINI_API_KEY` (Google AI Studio). Recognized for
photorealistic human photos, in-image text rendering, multi-image composition, and multi-turn editing.

Capabilities: text-to-image; add/remove elements; inpainting with semantic masking; style transfer; multi-image
composition (up to 14 reference images); Google Search grounding; aspect ratios 1:1, 2:3, 3:2, 3:4, 4:3, 4:5,
5:4, 9:16, 16:9, 21:9; sizes 1K/2K/4K.

### Important mechanics

- **Always send images file-based** — base64 in a JSON request file, never as CLI arguments (argument-list-too-long).

```bash
export GEMINI_API_KEY=...
MIME_TYPE=$([[ "$IMG" == *.png ]] && echo image/png || echo image/jpeg)
IMG_BASE64=$(base64 -i "$IMG" 2>/dev/null || base64 -w0 "$IMG")
cat > /tmp/req.json <<JSONEOF
{"contents":[{"parts":[
  {"text":"$PROMPT"},
  {"inline_data":{"mime_type":"$MIME_TYPE","data":"$IMG_BASE64"}}
]}],"generationConfig":{"responseModalities":["TEXT","IMAGE"]}}
JSONEOF
curl -s -X POST \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-pro-image-preview:generateContent" \
  -H "x-goog-api-key: $GEMINI_API_KEY" -H "Content-Type: application/json" \
  -d @/tmp/req.json > /tmp/resp.json
# extract: python3 -c "import json,base64;d=json.load(open('/tmp/resp.json'));[open(f'out.{p["inlineData"]["mimeType"].split("/")[1]}','wb').write(base64.b64decode(p['inlineData']['data'])) for p in d['candidates'][0]['content']['parts'] if 'inlineData' in p]"
```

- Python SDK: `pip install google-genai pillow`

```python
from google import genai
from google.genai import types
client = genai.Client()
resp = client.models.generate_content(
    model="gemini-3-pro-image-preview",
    contents=["A fluffy orange cat wearing a knitted wizard hat, soft window light"],
    config=types.GenerateContentConfig(response_modalities=['TEXT','IMAGE'],
        image_config=types.ImageConfig(aspect_ratio="16:9", image_size="2K")))
for p in resp.parts:
    if p.inline_data: p.as_image().save("out.png")
```

Editing passes image(s) too: `contents=[prompt, input_image]`. Add `tools=[{"google_search": {}}]` to ground
generation in real-time data. `responseModalities` MUST include `'IMAGE'` or no image is returned.

Notes: outputs carry a SynthID watermark; the model "thinks" on complex prompts; for perfect in-image text,
generate the text first then request the image containing it; the API doesn't store images — save them locally.

## Stability AI (SD3.5 / Ultra / Core)

Model family `sd3` (default), `ultra` (premium), `core` (fast). Key from `STABILITY_API_KEY`
(platform.stability.ai, free Community license: ~150 req/10s, 100 images/day default).

### Modes & endpoints

| Mode | What it does | Endpoint |
|---|---|---|
| `generate` | text→image (SD3.5) | `/generate/sd3` |
| `ultra` | text→image premium | `/generate/ultra` |
| `core` | text→image fast | `/generate/core` |
| `img2img` | image + prompt → new image | `/generate/sd3` |
| `upscale` | resolution boost (conservative) | `/upscale/conservative` |
| `upscale-creative` | upscale with added detail | `/upscale/creative` |
| `remove-bg` | transparent-background PNG | `/edit/remove-background` |
| `inpaint` | edit masked region | `/edit/inpaint` |
| `search-replace` | swap object described by `search` | `/edit/search-and-replace` |
| `erase` | remove region under mask | `/edit/erase` |

Common params: `aspect_ratio` (see aliases below), `output_format`/`format`, `seed` (for reproducibility),
`prompt`, `image` (file), `mask` (file), `search` (for search-replace), `strength` (img2img/inpaint).

### Aspect ratios

| Name | Ratio | Aliases |
|---|---|---|
| square | 1:1 | ig, instagram, quadrado |
| portrait | 2:3 | retrato, pinterest |
| landscape | 3:2 | paisagem, horizontal |
| photo | 4:5 | ig-feed |
| wide | 16:9 | widescreen, youtube, cinema, wallpaper |
| ultrawide | 21:9 | — |
| stories | 9:16 | vertical, tiktok, ig-stories |
| phone | 9:21 | — |

### Style presets (15)

`photorealistic, anime, digital-art, oil-painting, watercolor, pixel-art, 3d-render, concept-art, comic,
minimalist, fantasy, sci-fi, sketch, pop-art, noir`. Each appends prompt qualifiers automatically.

### Prompt structure

Photography-leaning: `[subject] + [pose/action] + [environment] + [lighting] + [camera terms] + [mood]`.
Art-leaning: `[subject] + [action] + [artistic style] + [cinematic lighting] + [quality words] + [reference
artist] + [colors]`.

Universal negative prompts: `blurry, low quality, watermark, text, ugly, deformed, extra fingers, bad anatomy,
worst quality`. Facial negatives: `asymmetric eyes, deformed hands, bad teeth`.

Advanced techniques: word weighting (`(keyword:1.3)`), prompt mixing of styles, progressive description,
mood words. See the source skill's `prompt-engineering.md` for the full recipes.

## Prompt recipes

- **Logo**: name + font descriptor ("clean, bold, sans-serif") + placement ("put in a circle") + palette.
- **Product photo**: three-point softbox lighting, clean studio background, elevated 45° camera angle, focus cues.
- **Style transfer**: "Transform this photo into {$artist/style}. Preserve the composition but render with ...".
- **Photorealistic subject structure** (Gemini): "young woman, 25, smiling naturally, sitting in a modern cafe,
  natural window light, casual chic clothes, slightly messy hair, soft background focus", plus
  "keep everything else unchanged" when editing.
- **Aspect ratio/resolution reference (Gemini)**: 1:1 → 1024/2048/4096; 16:9 → 1376×768 / 2752×1536 /
  5504×3072; 9:16 → 768×1376 / 1536×2752 / 3072×5504; 3:2 → 1264×848; 2:3 → 848×1264.

## Error handling & limits

- No image returned → check `responseModalities` includes IMAGE.
- Safety filter blocked → rephrase the prompt.
- 429 rate limit → exponential backoff retry (Stability has automatic retry + API-key fallback chain).
- 401 → check key; 402 → billing; 400 → malformed prompt/params.
- Stability safety cap `SAFETY_MAX_IMAGES_PER_DAY`.
- For 4K outputs allow generous API timeouts.