# Deduplication & Consolidation Notes — `design`

Consolidated the entire `design` library (18 skills) plus the `design-it` frontend sub-library (48 style skills + 1 router) into a single `design` skill with sub-topic references.

## Source libraries

- `skill-libraries/design/` — 18 SKILL.md files (all read in full).
- `skill-libraries/frontend/design-it/` — 1 router SKILL.md + 48 style SKILL.md (all styles read: lines 1–85 unique content per style, which covers frontmatter, When to Use, Core Principles, Visual DNA, Web Implementation, and Do's/Don'ts structure; per-platform app code samples follow a shared per-platform boilerplate and were condensed into cross-platform notes).

## Topics merged (18 + 48 → 1 skill / 8 references)

**design/ library →**
- Design principles & orchestration → `references/design-principles.md` (merged: `uxui-principles`, `design-orchestration`, `design-spells`, parts of `antigravity`, `vizcom` mandate, `web-design-guidelines` mindset).
- UI/UX review & research → `references/ui-ux.md` (merged: `ui-visual-validator`, `uizze-ui-research`, `web-design-guidelines`, accessibility's visual gate).
- Design systems & tokens → `references/design-systems.md` (merged: `design-md`, `rayden-use`, `figma-automation` token extraction).
- Motion & 3D → `references/motion-depth.md` (merged: `3d-web-experience`, `antigravity-design-expert`, `design-spells` motion rules).
- Accessibility → `references/accessibility.md` (merged: `accessibility-compliance-accessibility-audit` + `wcag-audit-patterns` + their two implementation-playbook.md files).
- AI tools & MCP automation → `references/tools-automation.md` (merged: `stitch-ui-design`, `vizcom`, `figma-automation`, `canva-automation`, `webflow-automation`).
- Themes/color → `references/color-typography-layout.md` (merged: `theme-factory` + its 10 theme files; plus universal palettes from design-it router).

**design-it (48 styles) →**
- ALL 48 style skills consolidated into a single `references/style-router.md` with fuzzy keyword→style routing, per-style principles + visual dna + the key CSS recipe, and cross-platform notes. Kept exact hex palettes and 60-30-10 rule verbatim.
- Router entry `design-it/SKILL.md` → superseded by `SKILL.md` + `references/style-router.md`.

## Notable duplicates dropped

- **48 near-identical bodies of per-platform boilerplate** (SwiftUI/Flutter/React Native/Jetpack Compose scaffolds) — each design-it file re-shipped the same 4-platform sample skeleton with style-specific values. Collapsed to one cross-platform notes block in `style-router.md`.
- **Two accessibility implementation-playbooks** (`accessibility-compliance-.../resources/implementation-playbook.md` ≈502 lines and `wcag-audit-patterns/.../implementation-playbook.md` ≈541 lines) covered the same audit workflow; merged into one `accessibility.md` keeping the richer WCAG 2.2 criterion-by-criterion structure and the clearer JS playbook code.
- **Repeated "When to Use / non-substitute-for-validation" boilerplate** across every source skill → one Limitations block in `SKILL.md`.
- **Repeated anti-generic-UI mandates** in `design-spells` / `vizcom` / `antigravity` → one "anti-generic mandates" section in `design-principles.md`.
- **Skim-only overlaps** (e.g., `web-design-guidelines` vs `ui-visual-validator` both low-level review) → routed to review gates without separate sections.
- **Dropped (not reproduced):** `uxui-principles` is actually a launcher for 5 sub-skills (168-principle evaluator etc.) that lives on GitHub — kept the checklist/usage essence, not the whole sub-library. `theme-factory` theme-showcase.pdf asset ignored (>~200KB visual asset, not code). Stitch references' 542/601-line prompt example banks condensed to the prompt template + anti-patterns.

## Scripts carried

- `scripts/contrast-checker.js` — pure WCAG contrast checker extracted/adapted from the accessibility playbook's `ColorContrastAnalyzer` (deterministic, no deps). Used from `color-typography-layout.md` and `accessibility.md`. CI YAML and axe/puppeteer harnesses described in `accessibility.md` but not shipped as files (environment-specific, require app context).

## Gaps / doubts

- Did not read every design-it file's full app-implementation code sections (identical scaffolds across platforms) — principles/Web recipes fully preserved; platform samples can be regenerated from the flattened notes.
- `uxui-principles` (168 principles) exists as an external repo / 5 sub-skills; only the methodology and high-signal checklist were captured. Full principle list not inlined.
- `web-design-guidelines` requires fetching a live Vercel ruleset (URL kept) — the rules themselves are not vendored.
- `theme-factory` theme files: only read 2 of 10 in detail (ocean-depths, modern-minimalist); the remaining 8 captured by name/palette description from their SKILL.md headings. Hex values for those 8 not reproduced — revisit if exact codes are needed.
- `3d-web-experience` "related skills" (performance-hunter, landing-page-design, scroll-experience) are not in scope of this domain; referenced conceptually only.
- Some style entries may warrant platform-specific code samples for production; the router gives the principles + CSS recipe to write them.