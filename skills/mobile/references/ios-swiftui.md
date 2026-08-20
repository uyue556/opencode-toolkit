# iOS — Swift & SwiftUI

Native iOS development: SwiftUI state and data flow, view composition, performance, current
APIs (avoid deprecated), Liquid Glass (iOS 26+), refactoring, and debugging on the simulator.
Sources: swiftui-expert-skill (+ its references), swiftui-view-refactor, swiftui-ui-patterns,
swiftui-performance-audit, swiftui-liquid-glass, ios-developer, ios-debugger-agent.

## Table of contents
- [Operating rules](#operating-rules)
- [State management & data flow](#state-management--data-flow)
- [View composition & structure](#view-composition--structure)
- [Performance](#performance)
- [Lists & ForEach identity](#lists--foreach-identity)
- [Current APIs / deprecated-to-modern](#current-apis--deprecated-to-modern)
- [Liquid Glass (iOS 26+)](#liquid-glass-ios-26)
- [Navigation & sheets](#navigation--sheets)
- [Localization & accessibility](#localization--accessibility)
- [Debugging on the simulator](#debugging-on-the-simulator)

## Operating rules

- Prefer native SwiftUI over UIKit/AppKit bridging unless bridging is necessary.
- Don't enforce an architecture (MVVM, VIPER, etc.); keep business logic out of views and
  testable, but let the project choose how.
- Gate version-specific APIs with `#available` and a sensible fallback.
- Only adopt Liquid Glass when explicitly requested.
- Present performance optimizations as suggestions, not mandates.

## State management & data flow

### Property wrapper selection (iOS 17+, modern default)

| Wrapper | Use when | Notes |
|---------|----------|-------|
| `@State` | Internal view-owned state | Must be `private` |
| `@Binding` | Child modifies parent state | Not for read-only — use `let` |
| `@Bindable` | View receives an `@Observable` object and needs bindings | For injected observables |
| `let` / `var` | Read-only value passed from parent | `var` if the child observes via `.onChange` |
| `@Environment(Type.self)` | Shared app service/config | Explicit init injection for feature-local deps |

Legacy (pre-iOS 17 / iOS 16 targets): `@StateObject` at the owner, `@ObservedObject` when
injected, `@EnvironmentObject` only for genuinely app-wide state.

### @Observable rules

- Prefer `@Observable` over `ObservableObject`. Mark `@Observable` classes `@MainActor`.
- When a view *owns* an `@Observable` object, store it with `@State` (not `let`) so SwiftUI
  preserves the instance across redraws; `@State` also gives bindings (no `@Bindable` needed).
- Property wrappers inside `@Observable` classes (`@AppStorage`, `@SceneStorage`, `@Query`)
  conflict with the macro — annotate them `@ObservationIgnored` (they still notify via their
  own mechanisms). Never remove the annotation.
- Make `@Observable` property types `Equatable` so the generated setter skips redundant
  invalidations (big win for polling/streams/timers). Collections only short-circuit when the
  element type is Equatable.
- Observation tracks property-level reads: a computed property re-reading a stored property,
  a struct-typed property, or an array read each drag in the whole object. Cache derived
  values as stored properties kept in sync via `didSet`, or split per-element models.
- Don't pass values as `@State`/`@StateObject` — the initial value is ignored on re-init.

### Bindings

- Use KeyPath/subscript bindings (`$model[scoreFor: player]` via `@Bindable`) instead of
  hand-written `Binding(get:set:)` closures (heap allocation each body pass, breaks comparison).
  Add a labeled subscript if none exists.

## View composition & structure

- Enforce member ordering in a view file: environment → `let` properties → `@State`/stored →
  computed non-view vars → `init` → `body` → computed view builders → helper/async funcs.
- Default to **MV, not MVVM**: favor `@State`, `@Environment`, `.task`, `.onChange` before
  reaching for a view model. Don't introduce a view model to mirror local state or wrap
  environment dependencies. Split large screens into subviews first.
- Prefer **dedicated subview types over computed `some View` helpers**. Extract non-trivial
  sections (state, async work, branching, needs its own preview) into private `struct View`s.
  Pass small explicit inputs (data, bindings, callbacks), not the whole parent state.
- Extract actions and side effects out of `body`: button actions call small private methods;
  real business logic lives in services/models. `body` should read like UI, not a view
  controller. Don't bury logic inside `.task`/`.onAppear`/`.onChange`/`.refreshable`.
- **Keep a stable view tree.** Avoid top-level `if/else` swapping of root branches — identity
  churn and broad invalidation. Use conditions inside sections/modifiers
  (`.toolbar`, `.overlay`, `.disabled`, `.opacity`).
- Keep `body` cheap and `init` cheap; move heavy work into derived state, precomputation, or
  background preprocessing. `@State` is for view-owned state, not an ad-hoc cache.
- When a view file exceeds ~300 lines, split aggressively into real subview types (not many
  computed properties); move reusable subviews to their own file.
- If a view model genuinely exists: make it non-optional, inject deps via `init`, create it in
  the view's `init` (`_viewModel = State(initialValue:)`). Avoid `bootstrapIfNeeded` patterns.

## Performance

- **Narrow observation:** pass only the values a view needs; avoid passing a whole
  "config/context" object. Guard state writes: `if newValue != currentValue { currentValue = newValue }`
  in hot paths (scroll, gestures) instead of writing unconditionally.
- **POD views** (plain value types, no property wrappers) diff fastest (memcmp). Wrap an
  expensive non-POD view in a thin POD parent to contain re-diffing.
- **Equatable views:** for expensive bodies, conform to `Equatable` and use `.equatable()`;
  keep the `==` in sync when adding properties.
- **Lazy loading:** `LazyVStack`/`LazyHStack`/`List` over eager stacks for large collections.
- **Cancellation:** `.task` auto-cancels when the view disappears.
- **Debug view updates:** `let _ = Self._logChanges()` (DEBUG) to see why a view re-renders.
- **Instruments:** record a trace (SwiftUI template on real devices; Time Profiler on the iOS
  Simulator — the SwiftUI lane is empty there). Key diagnostic: `main_running_coverage_pct`
  — <25% means blocked, ≥75% CPU-bound. High-edge-count invalidation sources
  (e.g. `UserDefaultObserver.send()`, wide `EnvironmentWriter`s) are structural bugs; fix the
  source, then downstream hot views collapse.
- Code-first audit order: invalidation storms → unstable `ForEach` identity → heavy work in
  `body` → layout thrash (deep hierarchy, `GeometryReader`, preference chains) → image decode
  on main thread → overly broad animations. Prioritize by impact, not explainability.

## Lists & ForEach identity

- `ForEach` needs **stable identity**: never `.indices` or `\.offset`; the id must outlive the
  view and not be derived from mutable content.
- One view per element; `List` rows are unary. Constant number of views per `ForEach` element.
- Use `NavigationStack` + value-based `NavigationLink(value:)` + `.navigationDestination(for:)`.

## Current APIs / deprecated-to-modern

**Always use (iOS 15+):** `navigationTitle` (not `navigationBarTitle`), `toolbar { ToolbarItem }`
(not `navigationBarItems`), `toolbarVisibility(.hidden, for: .navigationBar)`,
`ignoresSafeArea(_:edges:)`, `preferredColorScheme(_:)`, `foregroundStyle(_:)` (not
`foregroundColor`), `clipShape(.rect(cornerRadius:))`, `animation(_:value:)` (always with
`value`), `confirmationDialog` (not `actionSheet`), `alert(_:isPresented:actions:message:)`,
`onSubmit(of:)` + `focused(_:equals:)` (not `onEditingChanged`/`onCommit`), dedicated
accessibility modifiers, `@Entry` macro (not manual `EnvironmentKey`), `Button` over
`onTapGesture` unless you need location/count.

**iOS 16+:** `NavigationStack`/`NavigationSplitView` (not `NavigationView`), `tint(_:)`,
`autocorrectionDisabled(_:)`, `PasteButton` (avoids paste prompts).

**iOS 17+:** `@Observable`, `onChange(of:) { }` or `{ old, new in }` (not single-param
`perform:`), `sensoryFeedback(_:trigger:)` (not UIKit generators), `MagnifyGesture`/`RotateGesture`,
`containerRelativeFrame()`/`visualEffect`/`onGeometryChange` as `GeometryReader` alternatives.

**iOS 18+:** `Tab(...)` API instead of `tabItem(_:)` (don't mix with `.tabItem()`), `@Previewable`
in previews.

**iOS 26+:** `scrollEdgeEffectStyle(_:for:)`, `backgroundExtensionEffect()`,
`tabBarMinimizeBehavior(_:)`, `tabViewBottomAccessory`, `Tab(role: .search)`, `ToolbarSpacer`,
`sharedBackgroundVisibility(.hidden)`, `badge(_:)`, `searchToolbarBehavior(.minimizable)`,
`@Animatable` macro (not manual `animatableData`), `navigationZoomTransition` +
`navigationTransitionSource/Destination`, `controlSize(.extraLarge)`, `TextEditor` with
`AttributedString`, `WebView`/`WebPage`, `dragContainer`.

## Liquid Glass (iOS 26+)

- Prefer native Liquid Glass APIs over custom blur hacks. Only adopt when explicitly requested.
- Wrap multiple glass elements in `GlassEffectContainer`; apply `.glassEffect(...)` *after*
  layout/appearance modifiers; use `.interactive()` only for tappable/focusable elements;
  use `.buttonStyle(.glass)` / `.glassProminent` for actions; `glassEffectID` + `@Namespace`
  for morphing transitions.
- Gate with `#available(iOS 26, *)` and provide a non-glass fallback (e.g. `ultraThinMaterial`
  background).

```swift
if #available(iOS 26, *) {
    Text("Hello").padding().glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
} else {
    Text("Hello").padding().background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
}
```

## Navigation & sheets

- Prefer `.sheet(item:)` over `.sheet(isPresented:)` when state represents a selected model.
- Sheets should own their actions and call `dismiss()` internally instead of forwarding
  `onCancel`/`onConfirm` closures.
- Enumerate routes/sheets rather than juggling multiple boolean flags; centralize modal
  presentation. Route external links into destinations via a URL/deeplink handler.
- Scroll-driven reveals: derive a normalized progress value from the scroll offset as the
  single source of truth; avoid parallel gesture state machines.

## Localization & accessibility

- Use String Catalogs; `LocalizedStringResource` for dynamic strings; locale-aware formatting;
  RTL layout; translator comments. Mark dynamic strings explicitly so they don't silently
  become keys.
- VoiceOver: semantic groups, traits, labels; Dynamic Type (never fixed sizes for text);
  high contrast and reduced motion. Test with the Accessibility Inspector.
- Previews use self-contained mock data — no live services/network; `@Previewable` (iOS 18+)
  for dynamic properties.

## Debugging on the simulator

- Use XcodeBuildMCP (if available) or xcodebuild/xcrun: `list_sims` → pick `Booted` →
  `session-set-defaults` (project/workspace path, scheme, simulatorId) → `build_run_sim`.
- After build, confirm the app launched (`describe_ui`/`screenshot`) before UI interaction.
  Prefer `id`/`label` over coordinates; use `gesture` for scrolls/swipes.
- Capture logs with the simulator log capture, then summarize the important lines.
- If a build fails, retry with `preferXcodebuild: true` before escalating.

## Cross-cutting iOS references

- Capability overview, UIKit integration, Core Data/SwiftData, URLSession, Keychain,
  StoreKit/payments, widgets/Live Activities: see `ios-developer` capabilities (App Store
  topics route to `deployment-store.md`; security to `mobile-security.md`).
- Appium/XCUITest automation: `testing.md`.
