# Motion, scroll & 3D

Merged from `front-end/scroll-experience` (GSAP ScrollTrigger/Framer Motion/Lenis/View
Transitions), `front-end/fixing-motion-performance`, `frontend/emil-design-eng`
(animation decision framework + easing/timing), `web-development/ui-motion` (seeds),
`web-development/vercel-react-view-transitions` (page transitions), the three.js bundle
(two-three-fiber, shaders, loaders, postprocessing, etc.), and `motion-3d` premium-3D
patterns.

## The animation decision framework (emil-design-eng)

Ask in order:

1. **Should it animate at all?** Frequency decides:
   - 100+/day (command palette, shortcuts) → **no animation. Ever.** (see Raycast)
   - Tens/day (hovers, list nav) → remove or drastically reduce
   - Occasional (modals, toasts, drawers) → standard animation
   - Rare/first-time (onboarding, celebrations) → delight is fine
   - **Never animate keyboard-initiated actions** — they feel slow and disconnected.
2. **Why does it animate?** Valid purposes: spatial consistency (enter/exit same direction),
   state indication (morphing feedback button), explanation, feedback (press scale),
   preventing jarring changes. "Looks cool" for frequent actions = reject.
3. **Which easing?** Entering → `ease-out`; moving/morphing on screen → `ease-in-out`;
   hover/color → `ease`; constant motion (marquee/progress) → `linear`. **Never `ease-in`
   for UI** — starts slow, feels unresponsive.
   - Custom curves (built-ins are too weak):
     ```css
     --ease-out: cubic-bezier(0.23, 1, 0.32, 1);      /* UI interactions */
     --ease-in-out: cubic-bezier(0.77, 0, 0.175, 1);  /* on-screen movement */
     --ease-drawer: cubic-bezier(0.32, 0.72, 0, 1);   /* iOS-like drawer */
     ```
   - Tune with easing.dev / easings.co; don't invent curves from scratch.
4. **How fast?** Match duration to distance/size: small UI (press, hover) 120–200ms;
   modals/drawers 200–350ms; page/route transitions 300–500ms. Overlong = sluggish;
   underlong = jittery. Slightly longer + gentler curves feel premium; fast + linear feels cheap.

## Motion performance rules

- Animate **only `transform` and `opacity`** (compositor-friendly). Never width/height/top.
- Use `requestAnimationFrame` for JS-driven motion; `passive` scroll listeners.
- `prefers-reduced-motion: reduce` → disable/condense (see `accessibility.md`).
- `will-change` only for long-lived intended animations; then remove when idle.
- Keep animation layers in `contain: layout` where possible; avoid painting large areas.

## Scroll experience stack (GSAP / Framer Motion)

- **Lenis** (smooth scroll) → `transform`-based, respects `prefers-reduced-motion`.
- **GSAP + ScrollTrigger**: pin sections, scrub animations, parallax (translate, not
  background-position), stagger reveals. Scrub cost grows with pins — keep the pinned
  stage cheap (fixed-position inner element).
- **Framer Motion**: `whileInView`, `useScroll`, `useTransform`, `useSpring`, layout
  animations. Keep transforms small; avoid animating layout properties.
- Native **CSS scroll-timeline** (`animation-timeline: view()`) for simple scroll-linked
  effects without JS.
- Don't animate `scrollTop` directly per frame (jank) — use native smooth scroll or Lenis.

## View transitions (SPA page changes)

- Wrap route changes in `document.startViewTransition(async () => { /* swap */ })`.
- Style `::view-transition-old()`/`::view-transition-new()` for fade/slide/morph;
  hoist `view-transition-name` on shared elements (logo, hero image) for cross-page morphs.
- Names must be unique per page instance; add a default cross-fade, then per-element names.
- Fallback: when unsupported, run the swap synchronously (graceful).

## Three.js / WebGL / 3D

Use only when the goal genuinely benefits (product visualization, immersive portfolio,
interactive data). Keep it a progressive enhancement with a 2D/static fallback.

- **Setup**: `@react-three/fiber` + `@react-three/drei` for React (scene as components,
  hooks for camera/controls); plain three.js for vanilla.
- **Loaders**: `useGLTF`/`GLTFLoader` (DRACO/KTX2 compressed), `useTexture` with correct
  color-space settings, `useEnvironment`. Always provide loading + error states and a
  `<Suspense>` boundary (drei helpers).
- **Shaders**: custom `ShaderMaterial` with uniforms; keep fragment cost low on mobile
  (no expensive loops/overdraw); test low-end GPUs.
- **Performance**: `frameloop="demand"` unless animating continuously; cap DPR (≤2),
  reduce geometry, use `useMemo` for matrices; keep draw calls low; `frustumCulled` on.
- **Postprocessing** (drei `EffectComposer`): bloom/SSAO cost real GPU — enable sparingly
  and lower quality on mobile.
- **Interactivity**: raycast hit-tests; hover/press states; `useFrame` throttled updates.
- **Accessibility**: provide `alt`/description for 3D content; never gate content behind
  WebGL (fallback images).

## The motion review checklist

- [ ] Each animation passes the frequency test; keyboard-initiated ones removed.
- [ ] Every animation has a purpose (spatial/state/explanation/feedback).
- [ ] Easing set per rule; `ease-in` absent; custom curves, not built-ins.
- [ ] Durations 120–500ms by size; reduced-motion honored.
- [ ] Only transform/opacity animated; no layout/jank; LCP/CLS unaffected.
- [ ] View transitions degrade gracefully; 3D has loading/error/fallback.