---
name: web-frontend
description: >
  Consolidated production-grade frontend/web development skill covering React, Next.js,
  Vue, Svelte/SvelteKit, Astro, Angular, Tailwind CSS v4, TypeScript, state management,
  API integration, performance / Core Web Vitals, PWA, accessibility (WCAG), SEO/metadata,
  design systems, landing pages, motion & 3D, browser extensions, and frontend security.
  Use whenever the user works on the frontend/web: 前端, 前端开发, UI, 页面, 网页, 组件, 组件库,
  landing page, 落地页, 官网, dashboard, 界面, 界面设计, responsive, 响应式, React, Next.js,
  Vue, Svelte, Astro, Angular, Tailwind, TypeScript, 样式, 动画, 性能优化, 加载速度, Core Web Vitals,
  PWA, 离线, service worker, 无障碍, accessibility, SEO, 元数据, state, 状态管理, 数据请求, API 集成,
  design system, 设计系统, 浏览器扩展, extension, or any HTML/CSS/JS/TS work.
---

# Web Frontend (consolidated)

One skill for building production-grade web frontends. Consolidates 112 source skills across
React/Next.js/Vue/Svelte/Astro/Angular, CSS/Tailwind, TypeScript, performance, PWA,
accessibility, SEO, design, motion/3D, extensions, and security.

Read this file to decide **which reference to open**. Each reference is self-contained with
code, rules, and pitfalls. Deduplication history is in `dedup-notes.md`.

## When to use

Use this skill for any of these tasks:

- Building or modifying **UI components, pages, or layouts** (any framework or vanilla).
- Setting up a **new frontend project** (scaffolding, tooling, TS config, build pipeline).
- **Fetching/mutating data** in a client (race conditions, caching, error/loading states).
- **Performance work**: Core Web Vitals, bundle size, images, caching, Lighthouse CI gates.
- **PWA / offline / installable apps**, **accessibility / WCAG** fixes, **SEO / metadata**.
- **Design**: design tokens, design systems, landing pages, motion, and "make it look
  less AI-generated" reviews.
- **Browser extensions** (Manifest V3) and in-page widgets.

If the task is backend-only (API servers, databases), test automation (Selenium/WDIO),
React Native/Expo, or ML-in-the-browser (Transformers.js), route elsewhere — those were
explicitly dropped (see `dedup-notes.md`).

## Selection routing

| If the task is about… | Open |
|---|---|
| React components, hooks, composition, React 19, component perf | `references/react.md` |
| Next.js App Router, Server Components, data fetching, caching, Server Actions, metadata | `references/nextjs.md` |
| SvelteKit or Astro (content sites, islands, forms, SSR/SSG) | `references/svelte-astro.md` |
| Angular (v20+): signals, standalone, zoneless, SSR, state, migration | `references/angular.md` |
| Tailwind v4, CSS-first config, container queries, design tokens, CSS patterns | `references/tailwind-css.md` |
| TypeScript discipline, project scaffolding (Vite/Next/pnpm), Bun, build tooling | `references/typescript-tooling.md` |
| Project structure: feature modules, server vs UI state split, naming, promotion | `references/architecture.md` |
| Zustand, Redux Toolkit, Jotai, React Query, optimistic updates, choosing a store | `references/state-management.md` |
| API layer, AbortController, retry/backoff, debounce, dedup, loading/error/empty states | `references/api-integration.md` |
| Design tokens, typography, FOUT prevention, color palettes, "looks AI-generated" review, motion seeds | `references/design-system.md` |
| Landing pages / marketing pages / portfolio: copy frameworks, sections, conversion | `references/landing-pages.md` |
| Core Web Vitals, bundle size, images, caching, Lighthouse CI gate, RUM | `references/performance.md` |
| PWA: manifest, service worker, caching strategies, install, Workbox | `references/pwa.md` |
| Accessibility audit + fixes (WCAG 2.2), keyboard, focus, ARIA, forms | `references/accessibility.md` |
| Metadata, canonical, Open Graph, structured data, sitemap/robots, technical SEO | `references/seo-metadata.md` |
| Scroll/motion/animation, view transitions, Three.js/3D, Spline, animation review | `references/motion-3d.md` |
| Chrome/browser extensions (MV3), content scripts, chat widgets | `references/extensions-widgets.md` |
| XSS, injection surfaces, `dangerouslySetInnerHTML`/`v-html`/`innerHTML` security | `references/security-xss.md` |

## Core workflow

1. **Understand the task** — pick the reference(s) above; identify framework, stack, and
   constraints (design system, a11y bar, perf budget, browser support).
2. **Measure first when optimizing** — baseline with Lighthouse/DevTools before changing
   anything; never optimize blindly (see `performance.md`).
3. **Scaffold / structure** — follow `architecture.md` (feature modules, page directories)
   and `typescript-tooling.md`; keep the routing layer thin.
4. **Implement with defaults that are safe**:
   - React/Next: Server Components by default; client only where interactivity is needed.
   - TypeScript strict, no `any`, explicit types, `import type`.
   - Design tokens over hardcoded values; co-located styles; no inline style literals.
   - Every data surface gets **loading, error, empty, and success** states.
   - Buttons disabled during async ops; errors surfaced, never swallowed.
5. **Verify** — typecheck, lint, test (if present), run the Lighthouse gate on the
   production build, re-review design with the StyleSeed rubric if it "looks off".

## Cross-cutting best practices

- **Performance is a feature.** Budgets: LCP ≤ 2.5s, INP ≤ 200ms (lab proxy TBT), CLS ≤ 0.1.
  Gate these in CI with median-of-N Lighthouse runs (`performance.md`).
- **Accessibility is default, not a phase.** Names → keyboard → focus → semantics →
  forms/errors → contrast (see `accessibility.md`).
- **State by origin.** Server data lives in a query/cache layer; UI state in a store; never
  mirror server responses into the client store (`architecture.md`, `state-management.md`).
- **Async correctness.** Abort in-flight requests, retry only 5xx, debounce input, dedup
  identical requests, guard stale responses (`api-integration.md`).
- **Never ship secrets** to the client; sanitize/escape anything rendered from user input
  (`security-xss.md`).
- **Motion earns its place.** Animate only transform/opacity, honor `prefers-reduced-motion`,
  and never animate keyboard-initiated or high-frequency actions (`motion-3d.md`).

## Do

- Start with the framework's performant default (RSC, static HTML, `loading="lazy"`).
- Specify image `width`/`height`/`aspect-ratio` to prevent CLS; use WebP/AVIF.
- Write small, single-responsibility components; compose over inherit.
- Extract a custom hook or component only when a second consumer appears.
- Give every route a canonical URL, title, and description; set defaults once.
- Keep `prefers-reduced-motion` handling on any custom animation.
- Validate input (Zod) on every mutation boundary (route handlers, Server Actions, forms).

## Don't

- Don't put `'use client'` on everything (Next) or hydrate everything (Astro islands).
- Don't animate layout properties (`width`, `top`, `height`) or scroll events.
- Don't retry 4xx, swallow errors, or show a spinner when cached data already exists.
- Don't use index as a React key for orderable lists.
- Don't use emoji as UI icons, pure `#000` text, or more than one accent color.
- Don't copy server responses into Zustand/Redux; don't `fetch()` inside components.
- Don't ship without checking the state of loading/error/empty for every data surface.

## Common pitfalls

| Pitfall | Fix |
|---|---|
| Layout shift on image load | Always set `width`/`height` or `aspect-ratio`. |
| Spinner flash on refetch | `if (loading && !data)` — not `if (loading)`. |
| Duplicate API calls | Request deduplication map / React Query key factory. |
| State updates after unmount | `AbortController` cleanup in effects. |
| Font FOUT / reflow | Self-host WOFF2, preload critical faces, gate with a `fonts-pending` class. |
| "AI-generated" look | One radius, one accent, one icon set; semantic tokens; real UX copy. |
| Waterfalls | `Promise.all` independent fetches; stream with Suspense boundaries. |
| `setInterval` re-rendering a big tree | Isolate ticking state into a leaf component. |

## Validation checklist (before finishing)

- [ ] Typecheck + lint pass (run the project's configured commands).
- [ ] Loading / error / empty / success states on every data surface.
- [ ] All interactive elements keyboard-accessible with visible focus.
- [ ] Image dimensions set; above-the-fold hero preloaded; below-the-fold lazy.
- [ ] No `any`, no inline `style={{...}}`, no hardcoded hex where a token exists.
- [ ] Metadata + canonical on every route; structured data valid.
- [ ] If app: manifest + service worker + offline fallback tested offline.
- [ ] Production build passes the Lighthouse budget (or a recorded reason to defer).
