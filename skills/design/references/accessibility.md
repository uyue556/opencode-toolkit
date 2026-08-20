# Accessibility in Design

Audit web content against WCAG 2.2 and fix violations — integrated into every design, not a post-mortem. Coverage: POUR model, audit workflow, automated + manual checks, remediation patterns, CI.

## Contents

1. [Conformance levels](#conformance-levels)
2. [Audit workflow](#audit-workflow)
3. [POUR break-down with top violations](#pour-break-down-with-top-violations)
4. [Automated testing](#automated-testing)
5. [Manual checks](#manual-checks)
6. [Remediation patterns](#remediation-patterns)
7. [CI/CD integration](#cicd-integration)
8. [Design-time accessibility](#design-time-accessibility)

---

## Conformance levels

- **A** — must (baseline barriers: alt text, keyboard, no traps).
- **AA** — should (target for most products): contrast 4.5:1, captions, focus visible, labels.
- **AAA** — gold standard: contrast 7:1, 4.5:1 large, extended time limits. High-contrast style in `style-router.md` targets AAA.

Legal note: never claim compliance without expert review; keep evidence (test steps + results) for audit trails (ADA/Section 508/VPAT relevance).

## Audit workflow

1. **Scope:** platforms, WCAG level, target pages, key journeys.
2. **Automated scan** (axe, Lighthouse, WAVE) — collect baseline violations + coverage gaps.
3. **Manual verification** — keyboard, screen reader, focus order, contrast, zoom.
4. **Map each issue** to criterion + severity + user impact.
5. **Remediate**, then **re-test**; document residual risk and compliance status.

## POUR break-down with top violations

### 1. Perceivable

- **1.1 Non-text content**: every image has `alt` (empty `alt=""` for decorative). - **1.2 Time-based media**: captions, audio description, no auto-play without control.
- **1.3 Adaptable**: info/relationships conveyed beyond presentation (use real headings/lists/table headers); meaningful reading order; don't say "click the green button" (color alone).
- **1.4 Distinguishable**: don't use color as the only signal (pair with icon/text); contrast ≥4.5:1 (3:1 large); text resizes 200% without loss; content reflows at 320px; non-text contrast ≥3:1 (icons, UI components, focus); spacing — line-height ≥1.5, letter-spacing ≥0.12em, word-spacing ≥0.16em, no clipping.

### 2. Operable

- **2.1 Keyboard**: everything operable by keyboard; no keyboard traps.
- **2.2 Enough time**: adjustable timing; pause/stop/hide motion and auto-updating content.
- **2.3 Seizures**: nothing flashes more than 3×/second.
- **2.4 Navigable**: skip link to main content; descriptive page titles; logical focus order; link purpose from text; correct heading hierarchy; **focus visible**; **focus not obscured** (WCAG 2.2 — sticky header offset).

### 3. Understandable

- **3.1 Readable**: page and parts have declared `lang`.
- **3.2 Predictable**: no surprises on focus or input; consistent navigation/identification across the product.
- **3.3 Input assistance**: errors identified with text + suggestions; labels/instructions; error prevention for destructive/legal/financial actions.

### 4. Robust

- **4.1 Declared or best-practice**: correct name/role/value on all custom widgets (ARIA where needed); status messages announced via `role="status"`/`aria-live`.

## Automated testing

- **axe-core** (`@axe-core/puppeteer`, jest-axe, axe DevTools) — run with tags `wcag2a`, `wcag2aa`, `wcag21a`, `wcag21aa`; score by impact weights (critical 10 / serious 5 / moderate 2 / minor 1) out of 100.
- **Lighthouse** accessibility audit for a second opinion; **WAVE** for visual inspection.
- Good coverage for: missing alt, missing labels, contrast in plain colors, aria misuse, heading structure.

## Manual checks

- **Keyboard:** Tab reaches everything; buttons activate with Enter/Space; Esc closes modals; focus indicator always visible; no traps; logical order.
- **Screen reader:** descriptive title; headings outline (one h1, no skipped levels, no empty headings); images have alt; form fields labeled; errors announced; dynamic updates announced (`aria-live`).
- **Visual:** 200% zoom no loss; color not sole signal; focus contrast; reflow at 320px; animations pausable.
- **Cognitive:** clear simple instructions; helpful error text; no arbitrary time limits; consistent nav; reversible actions.

## Remediation patterns

- **Missing alt text**: decorative → `alt=""`; otherwise descriptive text or `img.title`.
- **Missing labels**: give inputs `id` + `<label for>`; use `aria-label` when no visible label fits; for `placeholder`-only inputs at least `aria-label` the placeholder — but prefer real labels.
- **Unlabeled/clickable divs**: add `role="button"`, `tabindex="0"`, and Enter/Space key handler.
- **Modal**: `role="dialog"` + `aria-modal="true"` + `aria-labelledby`; focus moves in/out; Esc closes.
- **Tabs**: `role="tablist"` + `role="tab"` with `aria-selected`/`aria-controls` + matching `tabpanel`.
- **Live updates**: `<div role="status" aria-live="polite" aria-atomic="true">` for announcements.
- **High contrast mode**: honor `@media (prefers-contrast: high)` — force B/W tokens, underline links, 2px control borders.

## CI/CD integration

```yaml
# .github/workflows/accessibility.yml — run axe on every push/PR
on: [push, pull_request]
jobs:
  a11y-tests:
    runs-on: ubuntu-latest
    steps:
      - run: npx pbjs build && npx pa11y <url> || true   # example scaffold — wire your actual runner (axe/lighthouse)
```

Practical CI: run axe + jest-axe in component tests; Lighthouse in the preview job; pixel-gates from `ui-ux.md` reference catch layout/contrast regressions. Gate merges on new critical/serious violations; track residual risk in the report.

## Design-time accessibility

- Choose palettes that already pass 4.5:1 (universal palettes in `color-typography-layout.md` are starter-safe; verify each accent pairing).
- Tinted shadows and pastel-on-white are the classic silent failures — test those pairings specifically (`scripts/contrast-checker.js`).
- "Accessibility is design quality": state required states, focus rings, and touch targets (≥44px) in the design contract before building.
- Dark mode: elevated surfaces by lightness, not shadows (see `style-router.md` → dark-mode).

## Notes

- Tools cannot verify everything; keyboard + screen-reader passes on real devices remain the strongest signal.
- For a full WCAG criterion list and sample scripts, the source `wcag-audit-patterns` and `accessibility-compliance` playbooks were merged here; keep this as the working reference.