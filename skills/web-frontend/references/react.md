# React

Modern React patterns and principles (hooks, composition, performance, TypeScript) merged
from `frontend/react-patterns`, `web-development/react-best-practices` (Vercel),
`web-development/react-component-performance`, `frontend/zustand-store-ts` (see
`state-management.md`), `frontend/nextjs-best-practices` (see `nextjs.md`), and the React
parts of `web-development/senior-frontend` and `app-builder/*-component-scaffold`.

## Component design

| Type | Use | State |
|---|---|---|
| Server | Data fetching, static content | None |
| Client | Interactivity | `useState`, effects |
| Presentational | UI display | Props only |
| Container | Logic/state | Heavy state |

Rules: one responsibility per component; props down / events up; composition over
inheritance; prefer small focused components. Component structure order: Types → Hooks →
Derived (`useMemo`) → Handlers (`useCallback`) → Render → default export.

## Hooks

- Hooks only at the top level, same order every render, custom hooks prefixed `use`,
  clean up effects on unmount.
- Extract a hook when the same logic is needed twice (debounce, local-storage, fetch, form).
- React 19: `useActionState` for form submission state, `useOptimistic` for optimistic UI,
  `use` for reading resources in render; the compiler reduces the need for manual
  `useMemo`/`useCallback` — write pure components instead.
- React 19: `preload()` / `prefetch()` for resources; `useFormStatus` inside form children.

## Composition

- Compound components: parent provides context, children consume it (Tabs, Accordion,
  Dropdown). Render-props for render flexibility; custom hooks for reusable logic.
- Polymorphism via `asChild`-style patterns (see Radix in `design-system.md`).

## Performance (diagnose, then fix)

1. Profile first (React DevTools Profiler: components rendering > ~16 ms are candidates).
2. Identify the trigger (state updates, props churn, effects).
3. Apply targeted fixes and re-measure against the baseline.

Patterns that matter most:

- **Isolate ticking state** — move timers/animations into a leaf component so the parent
  tree never re-renders each tick.
- **Stabilize callbacks** — `useCallback` for handlers passed to `memo` rows; a new function
  reference every render busts memoization.
- **Derived data outside render** — `useMemo` for expensive derivations; compute once.
- **Avoid waterfalls** — `Promise.all` independent fetches; use `better-all` for partial
  dependencies; start promises early, await late; use Suspense to stream.
- **Bundle** — import directly (avoid barrels), `lazy()`/`next/dynamic` heavy components,
  defer analytics until after hydration, preload on hover/focus.
- **Server-side** — `React.cache()` for per-request dedup, LRU for cross-request caching,
  minimize data serialized to client components, `after()` for non-blocking work.
- **Re-renders** — don't subscribe to state used only in callbacks; subscribe to derived
  booleans; use functional `setState`; pass initializer functions to `useState` for
  expensive values; use `startTransition` for non-urgent updates.
- **Lists** — virtualize long lists, stable unique keys (never index), `content-visibility`
  for large static lists, extract rows into `memo` components with narrow props.
- **JS micro-opt** — `Set`/`Map` for O(1) lookups, cache object property access in loops,
  hoist RegExp out of loops, return early, batch DOM/CSS writes.

Do NOT prematurely optimize. Optimize only when a signal says it's slow.

## TypeScript patterns

- `interface` for component props; `type` for unions/complex types; generics for reusable
  components. Children → `ReactNode`; handlers → `MouseEventHandler<T>`; refs → `RefObject`.
- Strict mode, no implicit `any`, explicit return types, `import type` for types.
- Types colocated with the feature; public interfaces get JSDoc.

## Error handling

- Error boundaries: app-wide at root, feature-level at route boundaries, component-level
  around risky components. Fallback UI + log + retry, preserve user data.
- Never swallow errors; always surface (see `api-integration.md`).

## Anti-patterns

| Don't | Do |
|---|---|
| Prop-drill deep | Context |
| Giant components | Split small |
| `useEffect` for everything | Server components / derived values |
| Premature optimization | Profile first |
| Index as key | Stable unique ID |
| `fetch` inside components | Data hooks / query layer |
| Mutating state directly | Immutable updates |

## Component scaffolding (TypeScript + tests + stories)

Generate a component with an explicit props interface, a test, and a Storybook story when
the project uses them. Default to a `"use client"` component unless it's an async server
component. Use `cn()` (clsx + tailwind-merge) for conditional classes and `cva` for
variants (`design-system.md`).

## Testing

- Unit: pure functions, hooks. Integration: component behavior (Testing Library).
  E2E: user flows.
- Priorities: user-visible behavior, edge cases, error states, accessibility.
