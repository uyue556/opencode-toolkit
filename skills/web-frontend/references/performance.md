# Performance & Core Web Vitals

Merged from `front-end/web-performance-optimization`, `frontend/frontend-lighthouse`
(Lighthouse CI gate), `web-development/react-component-performance`, `front-end/fixing-motion-performance`,
`web-development/applicationinsights-web-ts` (RUM), and the Vercel rules in `react.md`/`nextjs.md`.

## Golden process

1. **Measure first.** Run Lighthouse (lab), then real-user monitoring (RUM) if available.
   Baseline the production build, not dev.
2. Fix the biggest metric gap. One change → re-measure → repeat.
3. Set a **CI gate** so regressions fail builds.

## Core Web Vitals budgets

| Metric | Good | Fix focus |
|---|---|---|
| LCP | ≤ 2.5s | Server response, images, TTFB, render-blocking |
| INP (lab proxy: TBT) | ≤ 200ms (TBT ≤ 200ms) | Long tasks, input handlers, layout thrash |
| CLS | ≤ 0.1 | Reserved space, async insertion, font metrics |
| TTFB | ≤ 800ms (good) | Server render, CDN, caching, edge |

Lighthouse scores: 90+ perf on production median. Use **mobile** as the default test.

## Lighthouse CI gate

`.lighthouserc.cjs` — assert on medians of **5 runs** (lab noise), never a single run:

```js
module.exports = {
  ci: {
    collect: { url: ["https://staging.example.com"], numberOfRuns: 5 },
    assert: {
      assertions: {
        "categories:performance": ["error", { minScore: 0.9 }],
        "categories:accessibility": ["error", { minScore: 0.95 }],
        "categories:best-practices": ["error", { minScore: 0.95 }],
        "categories:seo": ["error", { minScore: 0.95 }],
        "largest-contentful-paint": ["error", { maxNumericValue: 2500 }],
        "cumulative-layout-shift": ["error", { maxNumericValue: 0.1 }],
        "total-blocking-time": ["error", { maxNumericValue: 200 }],
        "unused-javascript": ["warn", { maxLength: 0 }],
        "third-party-summary": ["warn", { maxLength: 0 }],
        "uses-text-compression": ["error", { maxLength: 0 }],
        "uses-optimized-images": ["error", { maxLength: 0 }],
      },
    },
    upload: { target: "temporary-public-storage" },
  },
};
```
Run `lighthouse-ci autorun`. Block merges on failure; warn (not fail) on "unused-javascript"
early in a project so it doesn't prevent shipping while debt is paid down.

## Image optimization (biggest, easiest wins)

- WebP/AVIF via framework Image components (Next `next/image`, Astro `astro:assets`,
  or `srcset`/`sizes` by hand).
- **Always set width/height or aspect-ratio** (kills CLS). Serve `sizes` matching layout.
- `loading="lazy"` below the fold; `priority`/`preload` for LCP image.
- Correct format per image (photos: WebP/AVIF; logos/icons: SVG); no giant PNG screenshots.
- Don't animate image size/layout; decode async off-main-thread (`fetchpriority`).

## Rendering & hydration

- Reduce client bundle: Server Components (Next), islands (Astro), streaming via Suspense,
  lazy-loaded routes/components, code-split heavy third parties.
- **Avoid long tasks** (>50ms) on the main thread: chunk work, yield with
  `setTimeout`/`requestIdleCallback`, `content-visibility: auto` for off-screen sections.
- Debounce/throttle scroll/resize listeners; prefer `IntersectionObserver`/`ResizeObserver`.
- Defer third-party scripts (`defer`, load after interaction/idle); remove unused libs.

## Caching

- Static assets: immutable, cache-busting hashed filenames (`Cache-Control: public, max-age=31536000, immutable`).
- HTML: `no-cache` (revalidate) or short TTL with CDN edge caching; never serve stale forever.
- Use CDN/edge (Vercel/Cloudflare) for static + streaming; `stale-while-revalidate` for dynamic.
- Service worker for offline/app caching (`pwa.md`).

## Fonts & CSS

- Self-host WOFF2, `font-display: swap`, preload critical fonts, subset.
- `@font-face` size-adjust / `font-synthesis` to prevent layout shift.
- Critical CSS inline; defer the rest; avoid render-blocking CSS/JS above the fold.
- Avoid CSS-in-JS runtime cost in hot paths (Tailwind v4 utilities are static).

## Third parties (ads/analytics/widgets)

- Load after interaction (no immediate network cost), `defer`, `lazy`, or on route change.
- Self-host or proxy; `dns-prefetch`/`preconnect` only where actually needed.
- Watch third-party CPU/network in Lighthouse `third-party-summary`; budget them.

## RUM (real-user monitoring)

- Application Insights web SDK (or Web Vitals JS): collect `LCP/INP/CLS/TTFB`, page
  name, device, browser, country. Alert on regression vs 7-day baseline.
- Sample rate tuned (<1% default) to avoid your own perf tax; track Web Vitals not just
  load time.

## Common pitfalls

| Pitfall | Fix |
|---|---|
| Optimizing without baseline | Measure first |
| Single Lighthouse run in CI | Median of 5 |
| Hero image not preloaded | `priority` / `preload` |
| Animating layout props | transform/opacity only |
| Heavy JS above fold | Lazy + stream |
| No image dimensions | CLS guaranteed |
