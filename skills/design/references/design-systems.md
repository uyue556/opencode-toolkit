# Design Systems

How to capture and enforce a product's design language so every screen stays consistent: semantic DESIGN.md synthesis, tokens, and Figma component workflows.

## Contents

1. [Semantic design systems (DESIGN.md)](#semantic-design-systems-designmd)
2. [DESIGN.md output template](#designmd-output-template)
3. [Design tokens in practice](#design-tokens-in-practice)
4. [Figma component workflows (Rayden)](#figma-component-workflows-rayden)
5. [Token extraction & conversion tools](#token-extraction--conversion-tools)

---

## Semantic design systems (DESIGN.md)

Purpose: turn existing designed screens into a **source-of-truth document** so new screens can be generated in the same language. The document uses *visual descriptions* backed by exact values — designers/generators understand "deep muted teal-navy (#294056)" better than a Tailwind class list.

Method (from `design-md`):

1. List project + screen (e.g., StitchMCP `list_projects` / `get_screen`); download the screen's code + screenshot.
2. Capture the **atmosphere** — 2–3 evocative adjectives for the mood (airy, dense, utilitarian, minimal).
3. Map the **color palette** — every color gets: descriptive name + hex + functional role (e.g., "Deep Muted Teal-Navy `#294056` — primary actions").
4. **Translate geometry** — technical values into physical words (`rounded-full` → pill-shaped; `rounded-lg` → subtly rounded; `rounded-none` → sharp, squared-off).
5. Describe **depth & elevation** — flat, whisper-soft diffused shadows, or heavy high-contrast drop shadows.

Practices: descriptive over generic ("Ocean-deep Cerulean #0077B6", not "blue"); always explain *what each element is for*; consistent terms; exact values in parentheses; document hierarchy (how visual weight communicates importance).
Pitfalls: jargon without translation ("rounded-xl"), colors without roles, vague atmosphere, missed subtle details (shadows/spacing).

## DESIGN.md output template

```markdown
# Design System: [Project Title]
**Project ID:** [...]

## 1. Visual Theme & Atmosphere
(Mood, density, aesthetic philosophy.)

## 2. Color Palette & Roles
(Descriptive Name + Hex + Functional Role, one line each.)

## 3. Typography Rules
(Family; weight use for headers vs body; letter-spacing character.)

## 4. Component Stylings
* **Buttons:** shape, color, behavior.
* **Cards/Containers:** roundness, background, shadow depth.
* **Inputs/Forms:** stroke style, background.

## 5. Layout Principles
(Whitespace strategy, margins, grid alignment.)
```

## Design tokens in practice

- **Name semantically** by role (surface / elevated / primary-text / cta / focus-ring), not by color.
- **Expose as variables**: web = CSS custom properties; iOS = `Asset`/`Color` extensions; Android = `MaterialTheme` colorScheme; Flutter = `ThemeData`.
- Keep 60-30-10 proportions at the system level (60% backgrounds, 30% text/accents, 10% CTA).
- Define a spacing scale (say 4/8/16/24/48/120 pace), a radius scale, a type scale, and shadow/elevation scale once.
- Audit drift: colors/radii/spacing must trace back to the token set — tokens are the contract between design and code.
- Draw from `color-typography-layout.md` palettes when the system is being born.

## Figma component workflows (Rayden)

Building/maintaining components and screens in Figma via Figma MCP with token enforcement (source `rayden-use`), generalizable to any token-driven Figma library:

1. **Verify environment** — `whoami` on the Figma MCP; confirm write access (Dev/Full seat).
2. **Load component data** — component specs, anatomy, resolved token values from the design-system package/MCP.
3. **Identify task** — build component, compose screen, audit, add variants.
4. **Apply style mode** — conservative (dense admin UIs), balanced (default), expressive (marketing/impact).
5. **Build with helpers** — generate Figma Plugin API code using shared helpers (`hexToRgb`, `loadFonts`, `applyShadow`, `applyBorder`); every frame uses auto layout.
6. **Validate after each build stage** — screenshot + acceptance criteria (alignment, spacing, color accuracy, hierarchy, radius, shadow, count of primary actions).

Pitfalls: fall back to Roboto when Inter not loaded; variants require the same parent frame before `combineAsVariants`; use resolved token hexes (not approximations); check Figma seat permission.

## Token extraction & conversion tools

- **Extract tokens from a file** — colors/typography/spacing (Figma MCP `EXTRACT_DESIGN_TOKENS`).
- **Convert to Tailwind config** — pass the *full* extracted token object (includes `total_tokens`, `sources`); do not strip fields before conversion.
- **CI token checks** — auto-verify implementation colors/radii match the token set on PRs.
- For full Figma/Canva/Webflow automation workflows see `tools-automation.md`.

## Notes

- A design system is living: update DESIGN.md/tokens whenever a new token or component enters, so generation and review always have one source of truth.
- "Tokens + DESIGN.md + visual gate" is the closed loop: tokens define, DESIGN.md explains, the visual gate (references/ui-ux.md) enforces.