# UI/UX Review & Research

How to validate a design before calling it done: rigorous visual verification, research-backed UI review, reference-grounded research workflows, and interface guideline checks.

## Contents

1. [Visual validation process](#visual-validation-process)
2. [Validation checklist](#validation-checklist)
3. [UI research workflow (UIZZE)](#ui-research-workflow-uizze)
4. [Design contracts & finish gates](#design-contracts--finish-gates)
5. [Web interface guidelines](#web-interface-guidelines)
6. [Automated visual testing tools](#automated-visual-testing-tools)

---

## Visual validation process

Default stance: **the change has NOT been achieved until proven visually.** Never infer results from code you wrote; judge only from visual evidence (screenshots, renders, running app).

Method (from `ui-visual-validator`):

1. **Describe objectively first** — "From the visual evidence, I observe…" with measurements, before any judgment.
2. **Compare to stated goal** — element by element against the declared modification goals.
3. **Measure** position, rotation, size, and alignment visually; don't trust intent.
4. **Reverse-validate** — actively look for evidence the change *failed*, not just succeeded.
5. **Question "different = correct"** — a visible change is not necessarily the intended one.
6. **Assess accessibility** — contrast, focus indicators, keyboard visuals, text scaling.
7. **Cross-platform** — verify breakpoints, dark mode, motion, print.
8. **Edge cases** — loading, empty, error, transition states, boundary conditions.

Output rules: state achieved / partially achieved / not achieved; quantify metrics; give specific remediation; explicitly say when you are uncertain.

## Validation checklist

- Did I describe actual visuals, not hypothesize from code?
- For rotations: aspect-ratio change confirmed? Positioning: coordinate delta? Sizing: dimension delta?
- Contrast ≥ 4.5:1 normal (3:1 large; 7:1 AAA) on every pairing; focus indicators visible and ≥ 3:1 against adjacent.
- Keyboard order logical; no traps; Enter/Space activate; Esc closes dialogs.
- Screen reader: landmarks, heading outline (no skipped levels), labels, alt text, `aria-live` on dynamic updates.
- Responsive: content reflows at 320px; text scales to 200% without clipping; no horizontal overflow.
- States: loading → content, empty, error, success, permission all present and styled.
- CLS low; images sized; fonts load without FOIT flash.
- Design tokens used (colors/radii/spacing/type from the system, not ad-hoc).

## UI research workflow (UIZZE)

Ground AI-generated UI in real product patterns instead of a generic styling prompt. Free public catalog at uizze.com; optional MCP adds reference search and the `check_ui_slop` preview.

1. **Scope + access.** Identify screen job, user, primary action, existing design system, real content, required states. Use the free catalog manually by default; only use MCP tools that are authorized.
2. **Retrieve the smallest useful set** of matching screens/components. Focus on transferable patterns: hierarchy, navigation, interaction states, spacing, density, responsiveness. Label evidence source (manual/preview/MCP).
3. **Write a short design contract** (see below) — never treat a reference as a template to clone.
4. **Implement** with the project's own components and tokens; preserve platform conventions; product-specific content only.
5. **Finish gate** — block completion if any of: hierarchy doesn't surface the primary action; a visible control is inert/ambiguous; required states absent; drift from project tokens/conventions; filler grids/metrics/generic copy replaced real decisions. Name the issue, fix, rerun gate + normal tests.
6. Optional free `check_ui_slop` preview: only with explicit user approval and after a sensitive-data check; single bounded diagnostic — it does not replace access review.

**Security:** never commit/transmit MCP credentials or tokens; don't send proprietary markup/styles to external services without approval; treat references as research context, not reusable assets.

## Design contracts & finish gates

A design contract is ~5 lines you agree before building:

```
Screen job: <what the user accomplishes>
Hierarchy: <ordered list of most→least important content>
Primary action: <the one expected next step>
Allowed: <project components + tokens only>
Required states: <loading/empty/error/success/permission>
Forbidden: <interchangeable card grids, filler metrics, decorative gradients, generic copy>
Verify: <the specific checks that gate release>
```

Adopt patterns to the project system; validation findings are implementation feedback, not permission to copy an interface.

## Web interface guidelines

For a compliance review of existing files, fetch the current ruleset and check every rule against the files:

1. Fetch fresh guidelines: `https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md`
2. Read the target file(s) (ask the user if none given).
3. Check each rule; output findings in terse `file:line` format per the fetched spec.

## Automated visual testing tools

- **Chromatic** (Storybook visual regression), **Percy** (cross-browser screenshots), **Applitools** (AI diffing), **BackstopJS** (regression framework), **Playwright/Cypress** visual comparisons, **Jest image snapshot** (component level).
- Run in CI on PRs; gate merges on pixel diffs; include accessibility scans and multiple viewports in the matrix.
- Auto-verify design-token compliance (colors/radii match the token set) so drift is caught early.

## Notes

- Review is the last gate before "done"; it is stronger when the reviewer does not have the implementation in context.
- Pair with `references/design-principles.md` (principle checklist) and `references/accessibility.md` (WCAG detail).