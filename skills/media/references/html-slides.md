# HTML presentations (frontend slides)

Zero-dependency, animation-rich HTML presentations that run entirely in the browser. Use when creating a deck
from scratch, converting a PPT/PPTX into a web presentation, or enhancing an existing HTML deck.

## Table of Contents

- [Core principles](#core-principles)
- [Viewport fitting rules](#viewport-fitting-rules)
- [Content density limits](#content-density-limits)
- [Modes & workflow](#modes--workflow)
- [Design guidance (avoid AI slop)](#design-guidance)
- [Supporting assets](#supporting-assets)

## Core principles

1. **Zero dependencies** — single HTML files, inline CSS/JS. No npm, no build step.
2. **Show, don't tell** — generate visual previews rather than asking users to describe a style in words.
3. **Distinctive design** — every presentation must feel custom: unique typography, cohesive themes via CSS
   variables, purposeful motion. Never generic "AI slop".
4. **Viewport fitting is non-negotiable** — every slide fits exactly 100vh. No scrolling inside slides, ever.

## Viewport fitting rules

Apply to EVERY slide in every deck:

- `.slide { height: 100vh; height: 100dvh; overflow: hidden; }` (include `references/viewport-base.css` in full).
- All font sizes/spacing in `clamp(min, preferred, max)` — never fixed px/rem.
- Content containers get `max-height` constraints; images `max-height: min(50vh, 400px)`.
- Breakpoints for heights: 700px, 600px, 500px.
- Support `prefers-reduced-motion`.
- Never negate CSS functions directly: `-clamp(...)`/`-min(...)` are silently ignored — use
  `calc(-1 * clamp(...))`.
- Content overflow → split into multiple slides. Never cram, never scroll.

## Content density limits

| Slide type | Maximum content |
|---|---|
| Title slide | 1 heading + 1 subtitle + optional tagline |
| Content slide | 1 heading + 4-6 bullets, OR 1 heading + 2 paragraphs |
| Feature grid | 1 heading + 6 cards (2×3 or 3×2) |
| Code slide | 1 heading + 8-10 lines |
| Quote slide | 1 quote (≤3 lines) + attribution |
| Image slide | 1 heading + 1 image (≤60vh) |

Exceeds limits? Split. When enhancing an existing deck, count existing elements against these limits **before**
adding content; after any change re-verify `.slide` overflow, `clamp()` usage, and image max-heights at 1280×720.

## Modes & workflow

**Mode A — new presentation.** One `AskUserQuestion` call for purpose, length, content readiness, and inline
editing (in-browser editable text, localStorage auto-save, export). If images are provided, view and evaluate
each (USABLE/NOT USABLE + concept + dominant colors) and co-design the outline around both text and images.
Embed an identified logo (base64) into the style previews.

**Mode B — PPT conversion.** `python scripts/extract-pptx.py <input.pptx> <output_dir>`
(`pip install python-pptx`); confirm extracted titles/summaries/image counts with the user; run style discovery;
generate HTML preserving text, images (`assets/`), slide order, and speaker notes (as HTML comments).

**Mode C — enhancement.** Read the existing deck, then modify under the density/overflow rules above. If changes
would overflow, proactively split content and tell the user.

**Style discovery (show, don't tell):** ask show-me-vs-direct; if direct, show the presets. Otherwise gather the
mood (Impressed/Confident, Excited/Energized, Calm/Focused, Inspired/Moved — max 2) and generate **3 distinct
style previews** (~50-100 self-contained lines each) into `.claude-design/slide-previews/`, auto-open them, then
let the user pick or mix.

**Generation:** single self-contained HTML file; include the full `viewport-base.css`; fonts from Fontshare or
Google Fonts (never system fonts); detailed comments; `/* === SECTION NAME === */` markers. CSS-only animations
preferred (`@keyframes`), staggered reveals (`animation-delay`), scroll-snap navigation, keyboard/Swipe
navigation, nav dots. Add inline editing only if the user chose it.

**Delivery:** delete `.claude-design/slide-previews/`, `open <file>.html`, and summarize file location, style,
slide count, navigation, and how to customize (`:root` CSS variables, font link, `.reveal` class, edit mode:
hover top-left / press E, Ctrl+S save).

## Design guidance

- Avoid overused fonts (Inter, Roboto, Arial, Space Grotesk), purple-gradient-on-white schemes, and predictable
  layouts. Draw from IDE themes and cultural aesthetics.
- Commit to a cohesive aesthetic with dominant colors + sharp accents (CSS variables).
- Backgrounds over defaults: layered gradients, geometric patterns, contextual effects.
- Motion is for high-impact moments: one well-orchestrated load beats scattered micro-interactions.

The full 12 preset themes (colors, fonts, signature elements) live in the source skill's `STYLE_PRESETS.md`;
effect-to-feeling animation snippets in `animation-patterns.md`; full HTML/JS template structure in
`html-template.md`.

## Supporting assets

- `references/viewport-base.css` — mandatory CSS base; copy in full into every deck.