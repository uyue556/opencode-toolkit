# Frontend architecture

Merged from `web-development/frontend-architecture`, `web-development/senior-frontend`,
`front-end/frontend-dev-guidelines`, and the state-splitting rules from
`web-development/react-state-management` + `frontend/zustand-store-ts`.

## Layer model

```
UI components  →  feature logic/state  →  server state/cache  →  API client  →  backend
```

Keep layers thin and one-directional: components never `fetch` directly; features own
their state; server state lives in a cache layer.

## Server state vs UI state (the core split)

- **Server state**: data owned by the backend (users, posts, cart totals). It has async
  fetching, staleness, invalidation. Manage it in a **query/cache layer** (React Query,
  SWR, Angular HttpClient + signals) or pass it down from Server Components.
- **UI state**: ephemeral view state (open/closed, active tab, search input). Lives in
  local state or a lightweight store (Zustand/Redux/Jotai, Svelte stores, signals).
- **Rule**: never mirror server responses into the client store. A store copies are a
  cache, and a cache needs invalidation you won't build. Query layer fetches for you;
  store only holds what's genuinely client-side.
- URL is state too: filters, pagination, tabs belong in the URL (`useSearchParams`,
  Angular Router query params, SvelteKit `$page.url`). Deep-linkable, back-button safe.

## Feature modules / directories

- Organize by **feature**, not by layer: a feature owns its components, hooks, types, and
  its slice of the store. Cross-cutting UI lives in `components/ui`.
- Page/route components stay thin: compose features, wire data, no business logic.
- **Barrel files are for the public API only.** Internal imports reference the file
  directly — barrels in the middle of the tree cause cycles and bundle bloat.

## Component promotion path

1. Inline in a page.
2. Extracted to the feature when reused twice within the feature.
3. Promoted to `components/ui` when used by ≥2 features (and becomes API-stable, polished,
   a11y-correct).
Never prematurely promote; keep domain logic out of `ui` components.

## File & naming conventions

- Components: PascalCase files (`Button.tsx`), tests colocated (`Button.test.tsx`).
- Hooks: `useXxx.ts`. Utilities: camelCase. Constants: UPPER_CASE or `kebab-case` files.
- Feature dirs: `features/{name}/{components,hooks,types,api}.ts` or colocated files.
- Types colocated with their feature; shared contracts in `lib/types` or `src/contracts`.

## State architecture (choosing tools)

| Need | Choice |
|---|---|
| Server/cache data | React Query / SWR / fetch + zod (not a store) |
| Small local UI state | `useState` / signals / Svelte store |
| Shared global UI state | Zustand / Jotai (or Redux Toolkit for complex, deterministic) |
| Complex flows + devtools + time-travel | Redux Toolkit |
| URL-driven state | Router params |

Zustand selector rule: **select only what the component renders** (`const x = useStore(s => s.x)`) —
selecting a whole object re-renders on any change. Use `useShallow` when picking several
fields. Prefer derived selectors to reduce re-renders (`state-management.md`).

## Design review & consistency (internal "taste" bar)

- Enforce tokens everywhere (no raw hex/spacing); one radius scale, one spacing scale.
- Reuse the design system; when extending it, extend tokens first, components second.
- A page is "good" when: a clear focal point, one accent color, consistent type scale,
  generous whitespace, no more than 2 font families. See `design-system.md` for the
  full "looks less AI-generated" rubric.

## Common pitfalls

| Pitfall | Fix |
|---|---|
| Components fetching data directly | Route data via page/feature layer |
| Server data in Zustand | Query layer owns cache |
| Barrels everywhere | Direct imports; barrels only at feature edge |
| Monolithic page components | Compose features, thin pages |
| Store keyed by index / whole-object selectors | Stable IDs + narrow selectors |
