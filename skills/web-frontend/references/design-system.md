# Design systems & "make it not look AI-generated"

Merged from `web-development/design-system` (tokens, typography, FOUT),
`web-development/radix-ui-design-system` (headless primitives), `frontend/design-it`
(palettes + 60-30-10), `web-development/styleseed-design-review` (100-pt rubric),
`web-development/ui-motion` (motion seeds), and `front-end/ui-ux-pro-max` (taste).

## Token architecture

```
tokens
  colors:  brand, surface, text-strong/-muted, border, focus, danger, success
  type:    font-family (≤2), size scale (clamp), weight, leading
  spacing: 4px scale (--spacing-1 … --spacing-12+)
  radius:  1 radius scale (e.g. --radius-sm/md/lg) — pick ONE family
  motion:  durations (fast/med/slow) + easings (see motion-3d.md)
  shadows: 1 subtle + 1 overlay; no giant drops
```

- **One radius scale, one spacing scale, one accent** (plus neutrals). Multi-radius /
  multi-accent designs are the #1 "AI-generated" tell.
- Semantic over product names; theme via variables only. Implement with Tailwind v4
  `@theme` (`tailwind-css.md`).

## Typography

- ≤2 font families (display + body); pick weights by role (regular, semibold, bold) not
  by magic numbers.
- Set a **fluid type scale** with `clamp()`; tighten line-height for headings, loosen for
  body copy. `text-wrap: balance` for headings, `pretty` for paragraphs.
- **FOUT prevention**: self-host WOFF2, `font-display: swap` + preload critical faces,
  gate non-critical render behind a `fonts-pending` class removed on `document.fonts.ready`,
  reserve fallback metrics to avoid CLS.

## Color palettes (use sparingly)

Pick one: keep the 60-30-10 rule — 60% neutral surface, 30% supporting, 10% accent.
Verified neutral-heavy palettes (from design-it) work better than saturated pastels.
If reviewing an existing design: audit that every color has a role; remove decorative-only
colors.

## Radix / headless UI primitives

- Build on **headless primitives** (Radix UI, Ark, React Aria, Angular CDK, Svelte
  shadcn-style): accessibility, keyboard nav, focus traps, ARIA come free.
- Wrap them in your design system's styling (tokens + `cva`/`clsx` variants) — keep the
  primitive's contract (`asChild`, slots) so consumers can compose.
- Avoid building your own dropdown/dialog/complex form controls — bugs live there.

## The StyleSeed review rubric (audit any UI, 0–100)

| Category | Weight |
|---|---|
| Typography hierarchy & scale | 15 |
| Color & contrast (functional, not decorative) | 15 |
| Spacing & rhythm (consistent scale) | 15 |
| Layout composition & alignment | 15 |
| Visual hierarchy (focal point) | 15 |
| Interaction & micro-states (hover/press/loading) | 10 |
| Iconography & imagery (consistent set) | 15 |

- **The #1 killer: coherence.** Inconsistent radii, colors, shadows, or icon sets anywhere
  sinks the whole score. Fix by enforcing tokens globally.
- Review checklist: one accent color, one icon set, one radius family, consistent 8/4px
  spacing, clear focal point per section, no pure `#000` text on colored surfaces, real
  (not lorem) copy, buttons clearly clickable (affordance), mobile-checked.

## UI/UX heuristics (top ones that matter)

- **Visibility of state**: every action shows loading/error/empty/success (`state-management.md`).
- **Feedback loops**: hover, focus, press states; buttons look and feel pressable.
- **Consistency**: same element = same look everywhere; same action = same label.
- **Hierarchy**: exactly one primary action per view; secondary actions de-emphasized.
- **Reduce choices**: fewer, clearer options; progressive disclosure for power features.
- **Touch targets ≥ 44×44px**; text contrast ≥ 4.5:1 (large text 3:1).
- **Empty & first-run states** designed, not default.

## Motion seeds (from ui-motion)

| Vibe | Seed | Use for |
|---|---|---|
| Responsive, snappy | **Spring** — fast ease-out, overshoot allowed | Buttons, dropdowns, confirm |
| Smooth, calm | **Silk** — long ease-in-out, no overshoot | Onboarding, page transitions |
| Precise, crisp | **Snap** — sharp curve, minimal easing | Tabs, segment controls |
| Friendly, playful | **Float** — gentle up-and-down | Empty states, mascots |
| Alert, urgent | **Pulse** — repeating opacity/size | Alerts, live indicators |

Map the desired feel → seed → concrete keyframes + durations; don't invent per-component.

## Common pitfalls

| Pitfall | Fix |
|---|---|
| 6 different radius/box-shadow values | Token scales |
| Hardcoded hex colors | Tokens |
| Custom dropdown built by hand | Headless primitive |
| FOUT / reflow | Self-host + preload + `fonts-pending` |
| Inconsistent icons | One set, one weight |
| Too many fonts | ≤2 families |
