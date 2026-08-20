# Svelte & Astro

The lean/full-stack and content-first frameworks, merged from `frontend/sveltekit`,
`frontend/astro`, and the markstream framework-package guidance (framework-agnostic
component authoring).

## SvelteKit

### Core concepts

- **Filesystem routing** with `+page.svelte`, `+layout.svelte`, `+server.js`, `+page.js`,
  `+page.server.js`, `+error.svelte`. Load functions (`load`) run in Node (`.server`) or
  the browser (`.js`).
- **Load functions**: return data for pages; `export const load = async ({ params, fetch,
  depends }) => ({ post: await getPost(params.slug) })`. Use `depends`/`invalidate` for
  targeted invalidation; `export const prerender = true` for static output.
- **Form actions** (`+page.server.js`): `export const actions = { default: async (event) =>
  ... }`; access with `use:enhance` on the form for progressive enhancement, `form` prop
  holds returned data, `ActionResult` for redirects/errors. All mutations run on the server.
- **Streaming**: return a promise from `load` for deferred rendering; SvelteKit awaits it.
- **SSR + hydration by default**; `adapter-static` for fully static sites, `adapter-node`
  for server deployment.

### State & reactivity

- Fine-grained **stores** for shared state: `writable`, `readable`, `derived`; auto-unsub
  via `$store` syntax in components.
- **Runes** (`$state`, `$derived`, `$effect`, `$props`) are the modern replacement — plain
  reactive variables without stores. Prefer runes for component-local reactivity.
- Svelte reactivity is compile-time: mutate arrays with `.push`/reassign; `$:` reactive
  statements for derived values.

### Performance & a11y

- Since everything renders on the server by default, main risks are: over-fetching (trim
  load payloads), re-render on updates (`$derived` instead of `$effect`), and hydration
  cost for huge pages.
- Keyed `{#each list as item (item.id)}` — never index keys.
- A11y warnings are compile errors by default (`svelte/a11y-*`) — keep them on.

## Astro

### Core concepts

- **Islands architecture**: pages are static HTML by default (zero JS shipped); interactive
  components are opt-in "islands". Add interactivity with `client:*` directives.
- **Directives**: `client:load` (hydrate immediately), `client:idle`, `client:visible`,
  `client:interaction`, `client:media`, `client:only` (framework-only, no SSR). Choose the
  smallest that satisfies the interaction.
- **Content collections** (`src/content`): schema-validated markdown/MDX via `defineCollection`
  + `getCollection`; `astro:content` for typed content queries; glob loaders for docs/blogs.
- **Data fetching**: fetch in frontmatter for SSR/SSG; use `getStaticPaths` for dynamic
  routes; `headers()`/`cookies()` in Astro 5 for server APIs.
- **View Transitions** built-in: `<ViewTransitions />` + `client:view-transition` for
  framework islands; `transition:animate`/`transition:persist` attributes on elements.

### Patterns

- **Rendering**: mark `.astro` components static by default; `---` frontmatter for imports/
  data. Use `Astro.slots` for children, `Astro.props` typed with `interface Props`.
- **Component styles are scoped by default** (`<style>`), with CSS Modules-like
  `class:list` for conditional classes.
- **Islands must share data via props** (single source of truth in the page) — never
  duplicate state between islands.
- Server-side integration: use `Astro Actions` (Astro 5) with Zod validation for mutations.

### Common pitfalls

| Pitfall | Fix |
|---|---|
| Too many `client:load` islands | Downgrade to `client:visible`/`client:idle` |
| Islands fetching their own data | Pass data as props from the page |
| Hydration mismatch | Use `client:only` only for browser-only libs |
| Slow builds | Enable caching, split content collections, use `import.meta.glob` |
| Props untyped | `interface Props` + `Astro.props` |

## Component authoring (framework-agnostic, markstream-style)

When a component will be consumed across Vue/React/Svelte or multiple apps: keep the
markup/style/framework-agnostic, expose a minimal typed API surface, and package with a
`package.json` exports map (main + types). Ship the compiled artifact and `.d.ts`, not
raw SFCs. Use the host framework's headless primitives instead of importing the library's
vanilla instance directly (see `design-system.md` for Radix/aria patterns).
