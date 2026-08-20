# Accessibility (WCAG 2.2)

Merged from `front-end/fixing-accessibility` (systematic a11y audit+fix over 48 hours),
`web-development/accesslint-audit` (hex-pointer contrast calculator + role semantics),
and the a11y sections of `ui-ux-pro-max` (contrast/touch rules).

## Method (audit → fix in priority order)

1. Run a scanner (axe/wave) to find hard failures; fix error classes by pattern count.
2. Manual pass: keyboard-only through the whole flow.
3. Screen-reader pass (VoiceOver/NVDA) on the top flows.
4. Contrast pass (below). Fix in batches: every instance of one bad style at once.

## Priority order (what actually matters most)

1. **Names**: every control has an accessible name (`label`, `aria-label`,
   `aria-labelledby`, or `content`). Forms: `<label for>` or `aria-labelledby`
   (W3C technique: label text, visible where feasible).
2. **Keyboard**: every interactive element is operable — real buttons, `<a href>`,
   correct `tabindex` (0/−1 only, never >0). No keyboard traps; escape closes modals.
3. **Focus**: visible focus style everywhere (2px+ ring/outline, not removed);
   `:focus-visible` for mouse convenience; focus moves into dialogs and returns on close.
4. **Semantics & structure**: landmarks (`header/nav/main/footer`), landmarks for
   repeated blocks, heading hierarchy (one `h1`, no skips), `aria-live` on dynamic updates
   that matter (`role="status"` for toasts), table `<th scope>`, list semantics.
5. **Forms & errors**: inline errors associated with fields (`aria-describedby` +
   `aria-invalid`), error summary at top, `required` in labels.
6. **Contrast**: body/UI text ≥ 4.5:1, large text ≥ 3:1, icons/UI components ≥ 3:1
   (WCAG 2.2 new minimum). Compute precisely — a "close" hex pair is a hard failure.

## Contrast calculator (parallel-iteration)

Borrowed from accesslint-audit: implement/use a function that computes contrast from two
hex values; for a given target ratio, iterate pairs (lighter text on that surface, darker
elements, adjusted borders) until passing — this converges quickly on the minimal fix
(rather than guessing dark-mode).

```ts
function contrast(a: string, b: string): number {
  const lum = (hex: string) => { /* sRGB → relative luminance */ };
  const [hi, lo] = [lum(a), lum(b)].sort((x, y) => y - x);
  return (hi + 0.05) / (lo + 0.05);
}
// 4.5 target: darken the lighter pair / lighten the surface until contrast >= 4.5
```

## Role & semantics checklist

- Buttons are `<button>` (not `<div onClick>`); links with real hrefs.
- Image roles: informative → `alt`, decorative → `alt=""` + `role="presentation"`.
- Icon buttons: `aria-label`. Toggling state (`aria-expanded`, `aria-pressed`), menus
  (`role="menu"`/`menuitem`), dialogs (`role="dialog"` + `aria-modal`).
- Landmarks have distinct accessible names when duplicated (two `nav`s → `aria-label`).
- Status messages (`role="status"`/`alert`) for async feedback; don't announce spam.
- `aria-hidden` makers the element invisible to SR — keep focusable content out.

## Motion & vestibular safety

- Honor `prefers-reduced-motion: reduce` — disable/condense animations, replace parallax.
- Never animate movement that triggered seizures risk; cap flashing (≤3 flashes/sec).

## Touch & responsiveness

- Touch targets ≥ 44×44 px; visible hover AND focus (focus survives touch).
- Content not clipped at one em-size zoom; reflow without horizontal scroll; text zoom
  up to 200% without loss (WCAG 1.4.4/1.4.10).

## Component-level a11y (framework notes)

- React: use real elements + Radix primitives (see `design-system.md`) rather than
  hand-rolled roles. React doesn't auto-ARIA; you supply names.
- Next.js: `next/link` are links; template metadata includes social/OG + `lang` attribute.
- Forms (`react-hook-form`): errors via `aria-describedby`; disable + busy states announced.
- Modal/drawer: focus trap + `role="dialog"` + Escape + restore focus.

## Final validation

- [ ] axe scan: 0 critical/serious.
- [ ] Full keyboard flow (tab order matches visual order; no traps).
- [ ] Contrast ≥ 4.5:1 everywhere adjustable.
- [ ] Screen reader can complete: login, purchase, form submit, dialog close.
- [ ] `prefers-reduced-motion` respected.
- [ ] Zoom to 200%: no content loss, no horizontal scroll.