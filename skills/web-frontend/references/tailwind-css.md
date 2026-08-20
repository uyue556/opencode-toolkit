# Tailwind CSS v4 & CSS patterns

Merged from `frontend/tailwind-patterns` (Tailwind v4 CSS-first), plus design-token/CSS
patterns from `web-development/design-system` and `front-end/fixing-motion-performance`.

## Tailwind v4 model

- v4 is **CSS-first**: configure in CSS, not `tailwind.config.js`.
  ```css
  @import "tailwindcss";

  @theme {
    --color-brand-500: #6d28d9;
    --font-display: "Inter", sans-serif;
  }
  ```
  Every `--*` in `@theme` becomes a utility: `bg-brand-500`, `font-display`.
- `@import "tailwindcss";` replaces `@tailwind base/components/utilities;`.
- Variants: `@variant` for custom pseudo-classes; `@custom-variant dark (&:where(.dark, .dark *));`
  for class-based dark mode. `hover:`, `group-*`, `data-*` work as before.
- **Container queries** built in: `@container`, `@sm:`, `@lg:` variants; no plugin needed.
- `@utility` to define one-off custom utilities; `@apply` still works.
- The default config moved to CSS variables (`--color-*`, `--spacing-*`, `--breakpoint-*`).

## CSS organization rules

- **Use design tokens** (`@theme` variables) instead of hardcoded hex/px everywhere. Never
  paste a raw hex into a component.
- Use semantic names (`brand`, `surface`, `text-strong`, `border-subtle`) over product names
  so theme changes don't cascade through code.
- Co-locate component styles; scope with `@layer` and CSS modules where needed.
- **Don't** use inline `style={...}` for layout; prefer utilities/tokens.
- `clamp()` for fluid type: `font-size: clamp(1.5rem, 2.5vw + 1rem, 3rem);`.
- `:where()` for low-specificity resets; `:is()` for grouped selectors.

## Anti-CLS / image & layout stability

- Reserve aspect ratios: `aspect-[4/3]` or explicit `width`/`height` on images and media.
- Use `overflow-anchor` to prevent scroll jumps; set `min-height` on lazy-loaded sections.
- Preload above-the-fold images with `rel="preload"` + `imagesrcset`.

## Dark mode

- Class-based: `@custom-variant dark (&:where(.dark, .dark *));` then `dark:bg-...`.
  Toggle `.dark` on `<html>`; persist in localStorage with `prefers-color-scheme` default;
  avoid hydration flash by setting it before first paint (inline script).
- Ensure contrast in both modes; don't invert entire pages (use tokens).

## Responsive

- Mobile-first: build base, then `sm: md: lg:`.
- Breakpoints: content-based `@container` queries beat viewport-only for cards/dashboards.
- Test real devices + DevTools emulation; validate with axe for mobile tap targets.

## Common pitfalls

| Pitfall | Fix |
|---|---|
| v3 config not applying | Move to `@theme` in CSS |
| Dynamic class names (`bg-${color}`) | Full class names only (build-time extraction) |
| Hardcoded hex in components | Token from `@theme` |
| Layout shift from ads/images | `aspect-ratio` + reserved space |
| Huge CSS output | v4 content scanning is automatic; keep `@theme` lean |

## CSS performance

- Animate only `transform`/`opacity` (`motion-3d.md`); `will-change` only for long-lived,
  intended animations.
- Use `content-visibility: auto` for far-below-fold sections to skip rendering work.
- Minimize layout thrash: batch reads/writes, avoid forcing layout in loops.
