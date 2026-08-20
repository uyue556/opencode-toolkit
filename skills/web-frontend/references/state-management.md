# State management

Merged from `frontend/zustand-store-ts`, `web-development/react-state-management`,
`web-development/react-ui-patterns`, and the Angular state guidance (`angular.md`).
Framework-agnostic rule first: **server state ≠ UI state** (`architecture.md`).

## Choosing the right tool

| Situation | Tool |
|---|---|
| Server/cache data (fetch, stale, invalidate) | TanStack Query / SWR / RSC data |
| URL state (filters, tabs, pagination) | Router (useSearchParams etc.) |
| Form state | Local state + Zod / react-hook-form / useActionState |
| Small app shared UI state | Zustand / Jotai / Svelte stores / Angular signals |
| Complex global app state | Redux Toolkit (devtools, serializability) |
| React 19 forms/optimistic | `useActionState`, `useOptimistic`, `useFormStatus` |

Don't reach for a global store until two sibling branches need the same state.

## Zustand (recommended TS pattern)

```ts
interface CounterState {
  count: number;
  increment: () => void;
}
export const useCounter = create<CounterState>()((set) => ({
  count: 0,
  increment: () => set((s) => ({ count: s.count + 1 })),
}));
```

- **Select narrowly**: `const count = useStore((s) => s.count)` — return primitives or
  single fields, never the whole store, or you re-render on every change.
- Multiple fields: `useShallow((s) => ({ a: s.a, b: s.b }))`.
- Callback selectors: `useStore((s) => useCallback(() => s.act(), []))` or subscribe once
  with `subscribeWithSelector` + `useSyncExternalStore` for imperative subscribers.
- Actions can live in the store (colocated) or be plain functions calling `useStore.getState()`.
- Use `middleware(create(...))` (`devtools`, `persist` for localStorage-backed slices).
- **Never** store fetched data in Zustand — that's a query layer's job.

## Redux Toolkit

- Slice per feature: `createSlice({ name, initialState, reducers })`, `createAsyncThunk`
  for async (or do async in a query layer instead). Prefer
  `createEntityAdapter` for lists (IDs + byId map). Selectors via `createSelector` (memoized).
- Avoid: `any` in actions, non-serializable payloads, whole-state subscriptions.

## Server cache with React Query / SWR

- Keys are an array: `queryKey: ['posts', filter]`; keep a **key factory** (`posts.all()`,
  `posts.detail(id)`) so invalidation targets exactly the right cache.
- `staleTime` > `gcTime` mindset: default `staleTime: 0` refetches often; bump for
  infrequent data. Invalidate on mutation success; optimistic updates with `onMutate`
  + rollback.
- Cancellation: pass `signal` from `useQuery`/hooks to your fetcher; abort on unmount.

## UI states (the "4 states" golden rule)

Every data surface needs four states — from `react-ui-patterns` + `ux-feedback`:

| State | What to show |
|---|---|
| Loading (no data yet) | Skeleton / spinner **only when nothing is cached** |
| Error | Message + retry + "what happened" + back/undo |
| Empty | Helpful empty state: icon/illustration + why + primary CTA |
| Success | The content (plus optional subtle confirmation) |

- **Golden rule**: `if (loading && !data)` — never flash a spinner when a refetch is in
  flight and stale data is on screen.
- Errors belong **next to the failing action** (inline), not only in a toast.
- Disable the action button while its async operation runs; avoid double submits.

## Optimistic UI

- Apply the expected result immediately, roll back on failure, surface the error.
- React: `useOptimistic`; React Query: `onMutate`/`onError`; Zustand: action applies +
  rollback in catch. Always reconcile with server response afterwards.

## Persistence

- localStorage for preferences/theme (write on change, read once, guard SSR).
- URL for shareable state; sessionStorage for tab-scoped. Never store auth tokens in
  localStorage if you can avoid it (XSS — see `security-xss.md`).

## Common pitfalls

| Pitfall | Fix |
|---|---|
| Whole-store selectors | Narrow selectors / `useShallow` |
| Server data in the store | Query layer |
| Spinner on refetch | `if (loading && !data)` |
| Silent failures | Inline errors + retry |
| Double submit | Disable while pending |
