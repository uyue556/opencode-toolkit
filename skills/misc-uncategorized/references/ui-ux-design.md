# UI / UX Design

Consolidates: baseline-ui, design-philosophy, design-thinking, design-spatial,
deterministic-design, ui-skills-root, ui-setup, ui-tokens, ui-pattern, ui-page, ui-score,
ui-review, ui-lint, ui-update, ux-audit, ux-copy, ux-flow, favicon, lookdev, lookdev-auto.

## 0. Routing (ui-skills-root)

If the task is UI-related, select the smallest useful context: prefer 1 skill; 2 only when two
angles are needed; 3 max for broad review/redesign. Route by topic → stack → specificity. For
quick cleanup prefer the most specific craft/visual/layout skill.

## 1. Baseline UI (anti-slop constraints)

Enforces an opinionated UI baseline to prevent AI-generated interface slop. Use `/baseline-ui
<file>` to review a file against all constraints, outputting violations (exact line), why it
matters, and a concrete fix.
- **Stack**: Tailwind defaults unless custom values exist/requested; `motion/react` for JS
  animation; `tw-animate-css` for entrance micro-animations; `cn` utility for class logic.
- **Components**: accessible primitives (Base UI, React Aria, Radix) for any keyboard/focus
  behavior; never mix primitive systems; `aria-label` on icon-only buttons; never hand-build
  keyboard/focus.
- **Interaction**: AlertDialog for destructive/irreversible actions; structural skeletons for
  loading; never `h-screen` (use `h-dvh`); respect `safe-area-inset`; errors next to the action;
  never block paste.
- **Animation**: no animation unless requested; animate only compositor props (`transform`,
  `opacity`); never animate layout props; `ease-out` on entrance; ≤200ms feedback; pause loops
  off-screen; respect `prefers-reduced-motion`.
- **Typography**: `text-balance` headings, `text-pretty` body; `tabular-nums` for data; never
  touch `letter-spacing` unless asked.
- **Layout/performance/design**: fixed z-index scale; `size-*` for squares; never animate large
  `blur()`/`backdrop-filter`; no `will-change` outside active animation; no `useEffect` for
  render-logic; no gradients unless asked; no purple/multicolor gradients; no glow as primary
  affordance; empty states get one clear next action; one accent color per view.

## 2. Design Philosophy & Thinking

- **design-philosophy**: for high-concept/art work — deduce the subtle reference the user is
  pointing at; treat the brief's allusions as the design language, don't default to trend.
- **design-thinking**: define purpose/tone/domain/color world and a review bar BEFORE coding.
  Reserve impact/punctuation for effect (sparingly). Use cross-domain lenses (cinema,
  architecture, marketing, UX, automotive, industrial design) to escape the generic.

## 3. Design Spatial (deterministic layout)

The model cannot trust its own UI output. Core laws:
1. **It can't see what it made** — render it (any static server + Playwright screenshot at
   several widths) and critique the image, not the code. Critique with fresh eyes (a subagent that
   did NOT write the page) told to hunt for what's wrong: collisions, edge tangents, ragged
   alignment, lopsided weight, no focal point, breaks at some width.
2. **Its first idea is the average** — treat first instinct as the mean (generic-AI mean: Inter,
   purple gradients, centered column, three equal cards; or designer-trend mean: oversized
   condensed caps, dark + grain, mono microtext). Deviate deliberately toward this product's
   world, not toward another trend.
3. **Don't prescribe a style** — prescribe the process (look + push off the average), not fixed
   rules (grids, 8-pt scales become the next mean).
4. **NEVER ship horizontal overflow** — THE mandatory gate. `document.documentElement.scrollWidth
   - clientWidth` must equal 0 at dev width AND narrow (≤1024px and ~390px). Re-measure after ANY
   addition to a horizontal row (rows grow past their last check). Default defenses: nav/toolbar
   rows `flex-wrap: wrap` (never nowrap); `body { overflow-x: clip }` backstop (clip not hidden).
   Root causes: `100vw` (includes scrollbar ~15px → use 100%), edge-anchored nowrap labels
   (`position:absolute; left:100%` → anchor inward), flex/grid children without `min-width:0`,
   long unbreakable strings (`overflow-wrap:anywhere`).
5. **Lay out in TASK order** — walk the user's step sequence, arrange elements in the same view
   order (orient → work → confirm). Confirm buttons where the work ENDS (duplicate action bar at
   bottom or sticky toolbar). Heuristic: save the user transit time (Fitts for the whole page).
6. **Balance is measurable** — target centroid x=0.50, y≈0.46 (optical, not geometric). Visual
   weight = area × ink-density (DENS table: h1:0.82, body:0.16, img:0.5…). Fix imbalance by
   moment (weight × distance): grow opposing weight first, add weight, pull element inward, shrink
   last. Acceptance: |cx−0.50|<0.03, |cy−0.46|<0.04. Validate with a pixel oracle (render,
   centroid of non-background pixels) — pixels beat the box model.
7. **The layout audit mediates the eye** — run `scripts/layout-audit.js` via Playwright
   `browser_evaluate`, then screenshot the annotated overlay and reason over it. GATES =
   correctness (overflow, contrast <4.5, tap <44×44) — block on these. SIGNALS = convention
   (balance, alignment, spacing rhythm) — never "fix" toward symmetry; deviation is often the
   better design; the interesting choice wins over the metric. Never accept a metric you haven't
   looked at.
8. **Optical craft** — nudge ±1-2px where geometry measures centered but the eye reads off
   (play-triangles in buttons, vertically centered text sits low); balance icon/text lockups by
   visual weight, not equal pixels.

## 4. Deterministic Design

Thesis: determinism beats AI randomness — render and measure instead of trusting the model's eye.
Two sub-skills: design-spatial (layout audit, above) + design-ux (usability audit scoring the
rendered UI against Nielsen's 10 via a separate fresh-eyes judge → prioritized fix list).
Compose with any taste-based design skill before reporting "done".

## 5. StyleSeed System (ui-* family)

A design-system skill family; legacy names `ui-*`/`ux-*` (see below for current usage):
- **ui-setup**: interactive wizard — app type → brand color → design concept → font → app name &
  first page → summary, producing a DESIGN-LANGUAGE.md + theme.
- **ui-tokens**: view/add/update design tokens in DESIGN-LANGUAGE.md.
- **ui-pattern**: generate a composed UI pattern (card, list, form section, grid, etc.) from
  design-system primitives. Pattern types: layout, data display, interactive.
- **ui-page**: scaffold a new mobile page/screen using the layout patterns.
- **ui-score**: score a UI file's design quality 0-100 against the design language, per category
  (worst offenders first). Use in **gate mode** as the quality gate before showing UI.
- **ui-review**: checklist review — token compliance, component conventions, accessibility,
  mobile best practices, performance, typography, spacing consistency, coherence ("one choice per
  axis").
- **ui-lint**: fast automated lint — hardcoded colors, raw pixel values in Tailwind, old
  width/height syntax, LTR-only physical properties, forbidden colors, missing data-slot, font-size
  CSS variables (Tailwind v4 conflict), className without `cn()`.
- **ui-update**: detect current StyleSeed setup, check version, report what's outdated, update
  safely.
- **ui-skills-root**: routing layer (see §0).

## 6. UX Audit (Nielsen's Heuristics)

Score the rendered UI against Nielsen's 10: (1) visibility of system status, (2) match between
system and real world, (3) user control and freedom, (4) consistency and standards, (5) error
prevention, (6) recognition rather than recall, (7) flexibility and efficiency, (8) aesthetic and
minimalist design, (9) help users recover from errors, (10) help & documentation. Use a separate
fresh-eyes judge; output a prioritized fix list.

## 7. UX Copy (microcopy)

Casual-but-polite voice. Patterns by context: buttons (verb-first, specific outcome), empty states
(what happened + one clear next action), errors (what went wrong + how to fix), toasts (short,
confirming action), form labels & helpers (short, no jargon), confirmation dialogs (state the
consequence + reversible). Never blame the user.

## 8. UX Flow

Design user flows and navigation: information architecture, navigation patterns, screen-flow rules
(one goal per screen, logical transitions, avoid dead ends), page composition per DESIGN-LANGUAGE.

## 9. Favicon

Validate source image (square, high-res). Detect project type and static assets dir, determine
app name, generate favicon.ico (16/32/48), favicon-96x96.png, apple-touch-icon.png (180x180),
manifest icons (192/512), favicon.svg (only if source is SVG); create/update site.webmanifest.

## 10. Lookdev (human-in-the-loop studio)

When the user says "lookdev"/tune/dial-in/compare variations/let me edit, build an **interactive
in-browser studio the user directly manipulates** — not a static grid, not a Q&A about numbers.
Two shapes: visual-parameter lookdev (sliders/pickers/drag handles for color, type, layout, image
treatment, animation, 3D) and text/media lookdev (direct inline edit + highlight + anchored
comments + media annotation — a blog/doc review IS this mode). Controls must stay reachable from
every scroll position. Round-trip is mandatory: serialize the final settings back (same rule as
settings JSON). Coherent control ranges: bounds must propagate; paired controls must not cross.
3D lookdev: orientation gizmo mandatory when the camera orbits.

## 11. Lookdev Auto (visual eval loop)

Let a vision/video model rate rendered variants in a loop: render N labeled variants → judge
scores them → keep/iterate on the winner. Token/quality/step reductions: small render sizes, cap
iterations, stop when scores plateau. Use when "only an eye can judge"; do NOT use when the
criterion is numeric/measurable. Caveat: judge drift between rounds; include the brief in the
judge prompt.

## 12. Tools

- **Photopea embed**: see `notes-macos-tools.md` (full photopea.js + PSD scripting reference).
- **layout-audit.js**: bundled in `scripts/` — run via Playwright `browser_evaluate`; see §3.7.
