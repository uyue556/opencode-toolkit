# Angular

Modern Angular (v16+ through v20+) practices, merged from `web-development/angular`,
`web-development/angular-best-practices`, `web-development/angular-state-management`,
`web-development/angular-ui-patterns`, and `web-development/angular-migration`.

## Modern Angular defaults

- **Signals** (`signal()`, `computed()`, `effect()`) replace Zone.js-dependent change
  detection where possible. Prefer signals for reactive state; read signals in templates;
  use `input()`, `output()`, `model()`, `viewChild()` for component APIs.
- **Standalone components** are the default — no `NgModule` unless required by legacy deps.
- **`zoneless`**: `provideZonelessChangeDetection()` for zero-Zone apps; rely on signals
  + `markForCheck` via signals. Angular 20 supports zoneless applications stably.
- **SSR / hydration**: `provideServerRendering` + hydration; **incremental hydration** with
  `@defer (hydrate on hover|idle|interaction|viewport)` blocks.
- **Change detection**: `ChangeDetectionStrategy.OnPush` everywhere; use signals to avoid
  manual `ChangeDetectorRef.markForCheck()`. `trackBy` on `*ngFor` for list identity
  (or the modern `for (item of items; track item.id)`).

## Component patterns

- Components: small, single responsibility, `@Input()` (prefer `input()`) for data,
  `@Output()` (prefer `output()`) for events, self-contained styles with strict scoping.
- **Reusable UI components**: `ControlValueAccessor` for form controls; accept
  `ValueAccessor` and DOM attributes; avoid `@Output()` for value changes when it's a
  form field.
- Prefer template-driven forms for simple cases, reactive forms for complex/validated ones.
  Validate with Angular validators or Zod on the model.

## State management

| Store | When |
|---|---|
| Component-local signals | Single-component UI state |
| Service + signals (`@Injectable` + `signal`) | Shared app state without heavy tooling |
| Angular Signals Store (ngrx-signals) | App-scale state with feature slices |
| NgRx | Large teams needing unidirectional Redux-style flow |

Keep server/cache state in a separate data layer (HttpClient + Signals or a query library),
not in the global store — same rule as `architecture.md`.

## Data fetching

- `HttpClient` with interceptors for auth headers, error normalization, retry-with-backoff
  on 5xx/network errors (see `api-integration.md`).
- Cancellation: `takeUntilDestroyed(this)` or an AbortSignal; clean up in `DestroyRef`.
- Guard against stale responses; cache responses keyed by request; dedupe in-flight.

## Performance

- Track every `*ngIf`/`*ngFor`/template bindings that change too often; prefer signals.
- `@defer` blocks with trigger conditions for non-critical sections; `incremental
  hydration` for above-the-fold SSR.
- Bundle: lazy-load feature routes (`loadChildren`), remove unused RxJS imports (use
  `rxjs` tree-shaken imports), analyze with source-map-explorer.
- OnPush + immutable updates + trackBy are the classic triple; signals remove most of the
  risk.

## Migration (legacy → modern)

1. Convert `NgModule` → Standalone (component-by-component, bottom-up).
2. Replace `@Input`/`@Output`/`@ViewChild` decorators with signal-based APIs.
3. Replace Observable-heavy state with signals; remove `ChangeDetectionStrategy.Default`.
4. Add `provideZonelessChangeDetection` last, once signals dominate templates.
5. Keep tests passing per commit; use `ng update` for framework majors first.

## Common pitfalls

| Pitfall | Fix |
|---|---|
| Zone-triggered change detection bloat | Signals + OnPush |
| `trackBy` forgotten | Track by ID in `for`/`*ngFor` |
| Huge feature modules | Standalone + lazy routes |
| Subscriptions never closed | `takeUntilDestroyed` |
| Blocking SSR render | `@defer` non-critical sections |
