# Deduplication notes

This file records how 112 source skills were consolidated into the `web-frontend` skill.
It exists so future readers know what was merged, what was deliberately dropped, and why.

## Source libraries (skill counts)

| Library | Count | Contribution |
|---|---|---|
| `frontend/` | 31 | React/Next/Tailwind/Svelte/Astro/Zustand patterns, design-it, emil-design-eng |
| `front-end/` | 14 | Perf, PWA, a11y fixes, metadata, landing pages, scroll, UI/UX, widgets |
| `web-development/` | 64 | React/Vue/Angular best practices, state mgmt, architecture, SEO, design system, motion, 3D, extensions |
| `app-builder/` | 3 | TS scaffold, component scaffolding (JS/TS) |

Consolidation ratio: ~112 source skills → 1 SKILL.md + 18 references.

## Mapping: what merged where

| Output reference | Merged from |
|---|---|
| `react.md` | react-patterns, react-best-practices (Vercel), react-component-performance, react-ui-patterns (UI states), zustand-store-ts (selectors), senior-frontend, TS scaffold |
| `nextjs.md` | nextjs-best-practices, senior-frontend (Next), react-best-practices Vercel rules, vercel-react-view-transitions |
| `svelte-astro.md` | sveltekit, astro, markstream framework-agnostic authoring |
| `angular.md` | angular, angular-best-practices, angular-state-management, angular-ui-patterns, angular-migration |
| `tailwind-css.md` | tailwind-patterns (v4), design-system (tokens), fixing-motion-performance (CSS) |
| `typescript-tooling.md` | typescript-scaffold, senior-frontend, api-integration-patterns |
| `architecture.md` | frontend-architecture, senior-frontend, frontend-dev-guidelines, react-state-management, zustand-store-ts |
| `state-management.md` | zustand-store-ts, react-state-management, react-ui-patterns, ux-feedback |
| `api-integration.md` | frontend-api-integration-patterns, react-ui-patterns, ux-feedback, angular interceptors |
| `design-system.md` | design-system, radix-ui-design-system, design-it, styleseed-design-review, ui-motion, ui-ux-pro-max |
| `landing-pages.md` | landing-page-generator + its 4 reference files, interactive-portfolio |
| `performance.md` | web-performance-optimization, frontend-lighthouse, react-component-performance, fixing-motion-performance, applicationinsights-web-ts |
| `pwa.md` | progressive-web-app, web-performance-optimization (PWA section) |
| `accessibility.md` | fixing-accessibility, accesslint-audit, ui-ux-pro-max (a11y/touch) |
| `seo-metadata.md` | frontend-seo, seo-technical (AI crawlers), fixing-metadata |
| `motion-3d.md` | emil-design-eng, scroll-experience, fixing-motion-performance, ui-motion, vercel-react-view-transitions, three.js bundle (11 skills), premium-3D motion |
| `extensions-widgets.md` | browser-extension-builder, chrome-extension-developer, chat-widget |
| `security-xss.md` | frontend-mobile-security-xss-scan, security rules from all framework refs |

## Notable duplicates collapsed

- **React advice appeared 6×** (react-patterns / react-best-practices / react-ui-patterns /
  frontend-dev-guidelines / senior-frontend / react-component-performance). Kept one set of
  rules; the Vercel-45 prefix rules (`async-*`, `bundle-*`, `rerender-*`) and the
  "profile → fix → re-measure" workflow were preserved.
- **State management appeared in 5 skills** (zustand-store-ts, react-state-management,
  frontend-architecture, senior-frontend, ux-feedback). Preserved: the server-vs-UI-state
  split, narrow-selector rule, and the 4-states golden rule (`if (loading && !data)`).
- **Angular: 5 skills** (angular + best-practices + state-management + ui-patterns +
  migration) → one `angular.md`. Focused on v20+ signals/standalone/zoneless/hydration +
  a migration path.
- **Motion/scroll/3D: ~15 skills** (emil-design-eng, scroll-experience,
  fixing-motion-performance, ui-motion, view-transitions, three.js × ~11, premium-3D).
  Kept the animation decision framework (frequency/purpose/easing/timing), the seeds,
  and one three.js quick-start section.
- **markstream-* (12 skills)**: the framework install variants collapsed to a single
  "framework-agnostic component authoring" section in `svelte-astro.md`; the actual
  markstream product install content is product-specific and out of scope.
- **Tailwind**: v4 CSS-first model (tailwind-patterns) subsumed the older config-based
  guidance and the design-system tokens.
- **A11y**: fixing-accessibility (process) + accesslint-audit (contrast math) + ui-ux-pro-max
  (touch/contrast rules) → one prioritized checklist.

## Deliberately dropped / out of scope

| Skill | Reason |
|---|---|
| `bun-development`, `discord-bot-architect`, `transformers-js` | Not web frontend |
| `selenium-skill`, WDIO/e2e browser automation | Test automation, separate concern |
| `frontend-mobile-*` react-native/expo PWA bridge | Mobile, separate concern |
| `applicationinsights-web-ts` full RUM setup | Kept condensed into performance.md |
| markstream product install/versioning docs | Product-specific |
| three.js per-subject splits | Collapsed to one section |
| `frontend-slides`, slide-deck specific skills | Presentation generation, out of scope |
| Vite-specific scaffold duplication | Folded into typescript-tooling.md |
| angular/cra/webpack config minutiae | Covered by framework defaults in refs |

## Scripts

No standalone scripts existed in the source libraries (`scripts/` dirs in the four target
libraries were empty or absent; `senior-frontend` referenced a `frontend_scaffolder.py`
that does not exist in its source). Reusable *config/templates* are embedded in the
references instead: `.lighthouserc.cjs` CI gate in `performance.md`, Workbox service
worker in `pwa.md`, Zustand store template in `state-management.md`, API client + retry
helpers in `api-integration.md`. The empty `scripts/` directory was therefore removed.

## Known gaps / follow-ups

- No RUM dashboards or analytics config carried beyond the Application Insights notes.
- `senior-frontend`'s scaffolder script is referenced but missing from source — scaffolding
  is documented inline in `typescript-tooling.md` instead.
- Three.js depth is a quick-start, not per-subject deep dives (shader/loader/post fx) —
  keep the per-topic libraries handy for advanced 3D work.
