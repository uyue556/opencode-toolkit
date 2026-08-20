# Next.js (App Router)

Production practices for App Router applications, merged from `frontend/nextjs-best-practices`
and the Next.js guidance in `web-development/senior-frontend`, `web-development/react-best-practices`
(Vercel rules), and `web-development/vercel-react-view-transitions`.

## Mental model

- **Server Components by default.** `'use client'` is the exception, only where state,
  effects, or event handlers are needed. Every `'use client'` component ships to the browser.
- Colocate server-only logic (DB, filesystem, secrets) inside Server Components or
  `server-only` modules. Never import client-only code in server files and vice versa.
- Keep the client/server **boundary thin**: pass serializable primitives, not functions or
  class instances, across the boundary.

## Routing & file conventions (App Router)

- `page.tsx`, `layout.tsx` (persistent UI + `children`), `loading.tsx` (Suspense fallback),
  `error.tsx` (error boundary, must be a Client Component), `not-found.tsx`.
- `route.ts` for API endpoints (use the Web `Request`/`Response` API).
- Route groups `(marketing)` to organize without URL changes; dynamic segments `[slug]`.
- `generateStaticParams` + `export const dynamic = 'force-static'` for SSG; `revalidate`
  (time-based ISR) or `on-demand revalidation` for updated content.

## Data fetching & caching

- Fetch in Server Components; Next dedupes `fetch` by URL by default. Pass options through
  to control caching:
  - `cache: 'no-store'` — always fresh (live data).
  - `next: { revalidate: 60 }` — ISR, revalidate at most every 60s.
  - `next: { tags: ['posts'] }` + `revalidateTag('posts')` — on-demand invalidation.
- Use a **query layer** (React Query / TanStack Query) for client-fetching apps; prefer
  Server Components + a serialized-to-client prefill for SSR.
- **Prevent waterfalls**: fetch independent data with `Promise.all` (or `better-all`);
  pass data down as props; stream with `<Suspense>` boundaries per section.
- `React.cache()` to dedupe server calls not using `fetch`.

## Server Actions & mutations

- Server Actions for mutations (`'use server'`); `useActionState` + `useFormStatus` for
  pending UI; optimistic updates with `useOptimistic`.
- Validate all inputs with Zod on the server; never trust client-side validation.
- Redirect after successful mutations; return error objects (not thrown exceptions) to
  display form errors inline.

## Images, fonts, metadata

- `next/image`: set `width`/`height`/`sizes`; use `priority` for the LCP image;
  WebP/AVIF auto. Never animate the `layout` of `next/image`.
- `next/font` self-hosts WOFF2 with zero layout shift; subset what you need.
- `generateMetadata` (async, can `fetch`) for per-route SEO; template functions for
  repeated patterns; export default metadata as a fallback (`seo-metadata.md`).

## Performance (Vercel rule summary)

- `async-*`: route handlers and server components can be async; pass resolved data down.
- `bundle-*`: minimize client bundles (direct imports, `dynamic()`, no unnecessary client
  components in a shared tree).
- `edge-*`: use edge where appropriate (middleware for auth/geolocation) — or Node runtime
  with long-lived connections; know which runtime your API uses.
- `inline-*`: inline small critical CSS/JS; preload the LCP image and above-fold fonts.
- `platform-*`: prefer framework primitives (`Image`, `Font`, `Suspense`) over hand-rolled.
- `prerender-*`: statically prerender by default; only render dynamically when needed.
- `stale-*`: understand revalidate/tags rather than disabling caching wholesale.
- `stream-*`: Suspense streaming so above-fold content renders before slow data arrives.
- `hydrate-*`: reduce hydration cost — keep client components small and focused.
- `avoid-*`: don't fetch in render, don't use index keys, don't animate layout properties,
  don't force `"use client"` on the whole page.

## View Transitions (cross-fade page navigation)

- Wrap route transitions: `next/link` with View Transitions via the
  `next-view-transitions` pattern — attach `document.startViewTransition` around navigation,
  use `::view-transition-old`/`::view-transition-new` for fade/zoom, `view-transition-name`
  per element for shared-element morphs. Prefer `page-transition` over `router`/`layout`
  boundaries for simple cross-fades; hoist per-element names so they're unique per page.

## Common pitfalls

| Pitfall | Fix |
|---|---|
| Whole tree client-side | Move `'use client'` to the leaf components |
| `fetch` not cached as expected | Pass explicit `next: { revalidate }` |
| Layout shift on LCP | `priority` + fixed dimensions |
| Everything dynamic | `generateStaticParams` + `revalidate` |
| Route handler returns `undefined` | Always return a `Response`/JSON |
