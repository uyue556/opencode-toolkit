# Generative art & canvas design

Two sister workflows for philosophy-driven visual work. Both follow the same shape:

**philosophy (markdown) → code (artwork).**

1. **Algorithmic art** — a computational aesthetic movement expressed as a *living p5.js algorithm*
   (interactive HTML artifact).
2. **Canvas/print design** — a visual aesthetic movement expressed as a *static composition*
   (single PDF/PNG).

Use when the user asks for generative/algorithmic art, an interactive artwork, a poster, cover, or a design-
forward single-page composition, especially when some subtle concept should be woven into the piece.

## Table of Contents

- [The philosophy (shared first step)](#the-philosophy)
- [Deduce the conceptual seed](#deduce-the-conceptual-seed)
- [Algorithmic art — p5.js viewer](#algorithmic-art--p5js-viewer)
- [Canvas / print design](#canvas--print-design)

## The philosophy

Write a 4-6 paragraph manifesto that:

- Names the movement (1-2 words): "Organic Turbulence", "Quantum Harmonics", "Chromatic Language", "Geometric
  Silence".
- Articulates how it manifests through computation/form — noise and randomness, particles and fields,
  parametric variation and emergence; space, form, color, scale, rhythm, composition.
- **Repeats craftsmanship framing several times** — the final artifact must look like the product of countless
  hours by someone at the absolute top of their field ("meticulously crafted", "expert-level execution",
  "painstaking calibration").
- Avoids redundancy (each aesthetic aspect mentioned once) yet leaves creative room for the implementer.

The philosophy guides expression — never a static illustration with random sprinkles, but ideas living in the
process/visual language. Save it as a `.md` file.

## Deduce the conceptual seed

Before implementing, identify the *subtle, niche reference* threaded through the request. It must be embedded
so richly that only someone familiar with the subject notices it — while everyone else simply experiences a
masterful composition. The philosophy is the language; the seed is the soul. Think "jazz musician quoting
another song through harmony."

## Algorithmic art — p5.js viewer

Express the philosophy with a generative algorithm. Requirements:

- **Seeded randomness (Art Blocks pattern)** — always reproducible:

```javascript
randomSeed(seed);
noiseSeed(seed);
let params = { seed: 12345, ... };   // quantities, scales, probabilities, ratios, angles, thresholds
```

- **The algorithm flows from the philosophy, not a menu.** "Organic emergence" → accumulation, constrained
  random growth, feedback loops. "Mathematical beauty" → geometric relations, trig/harmonics. "Controlled
  chaos" → bifurcation, phase transitions, order from disorder.
- **Single self-contained HTML artifact.** p5.js from CDN, all CSS/JS inline, works in any browser with no
  setup. Standard canvas `setup()`/`draw()` (static with `noLoop()` or animated).
- **Consistent UX chrome** (keep the fixed viewer chrome in every artifact):
  - *Seed* section: seed display, Previous/Next/Random buttons, "jump to seed" input + Go. Generate 100
    variations when asked (seeds 1-100).
  - *Parameters*: one slider per tunable parameter (`<input type="range">` + live value display,
    `oninput` → immediate redraw). Base control ranges on the system, not pattern types.
  - *Colors*: include color pickers only if the piece needs adjustable color; omit for monochrome.
  - *Actions*: Regenerate, Reset, Download PNG.
- Craftsmanship: balance complexity vs noise, coherent palettes (no random RGB), deliberate composition,
  smooth performance, identical output for identical seed.
- Variations: seed nav covers exploration; optionally add preset seed buttons or a gallery-mode grid.

## Canvas / print design

Express the philosophy as one premium single page (PDF or PNG; more pages only when asked).

- **Text is sparse and visual-first** — only essential words integrated into the composition (thin fonts most
  of the time; bold type only when context demands, e.g. a punk poster). Use distinctive fonts (search a local
  `./canvas-fonts` dir), never generic system faces; treat typography as part of the art.
- Ideas communicate through space, form, color, composition, and hierarchy — never paragraphs.
- Lean into systematic/repetitive visual language (dense marks, repeated elements, layered patterns, sparse
  clinical typography, reference markers) so the piece reads like a diagram from an imaginary discipline.
  Limited, intentional palette.
- **Non-negotiables:** nothing overlaps; nothing falls off the page; every element has breathing room and
  proper margins. Double-check before finishing.
- The result must look museum/master-crafted — like countless hours of painstaking care, never cartoony or
  amateur.
- **Second pass / refinement:** the user will demand it be pristine. Do NOT add more graphics — refine what
  exists: crisper alignment, more cohesive palette, better spacing. Ask "how can I make what's here more of a
  piece of art?" before touching the code.
- Multi-page: additional pages are unique twists that echo the original philosophy and tell a tasteful story
  — one page in a coffee-table book, not variations of page one.