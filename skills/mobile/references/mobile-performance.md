# Mobile Performance Doctrine

Cross-framework performance guidance: startup, rendering, lists, memory, network, and battery.
Applies to native iOS/Android, React Native, and Flutter. Sources: mobile-design,
mobile-developer, android-dev, swiftui-performance-audit, swiftui-expert-skill.

## Table of contents
- [Performance sins (never)](#performance-sins-never)
- [Startup](#startup)
- [Lists](#lists)
- [Rendering & frames](#rendering--frames)
- [Memory](#memory)
- [Network & images](#network--images)
- [Battery & background](#battery--background)
- [Profiling](#profiling)

## Performance sins (never)

| Never | Why | Always |
|-------|-----|--------|
| `ScrollView` for long lists | Memory explosion | `FlatList`/`FlashList`/`ListView.builder`/`LazyColumn`/`LazyVStack` |
| Inline `renderItem`/row builder | Re-renders all rows | memoized builder (`useCallback` + `React.memo`; `const` widgets) |
| Array index as key | Reorder bugs, wrong identity | Stable ID |
| JS/UI-thread animations | Jank | Native/UI driver (Reanimated, Compose, SwiftUI) |
| `console.log`/`Log.d` in prod | Blocks the thread | Strip logs in release |
| Unconditional state writes in hot paths | Re-render storms | Guard: only write when the value changed |
| Heavy work in `body`/composition | Blocked main thread | Derive/precompute; `remember`/`derivedStateOf` |

## Startup

- Targets: cold start < 1s, warm < 500ms (native). Frame budget 60fps (90/120 on capable
  devices), zero jank.
- Lazy-init heavy libraries (Android App Startup library); move init off the main/UI thread;
  commit Baseline Profiles (Android) for precompiled hot paths.
- For SwiftUI/Compose, keep view `init`/composition cheap — don't construct objects or do I/O
  there.
- EAS Observe (`references/expo.md`) measures startup/TTI from production Expo apps; use the
  `frameRate.*` params to distinguish slow-but-smooth from main-thread contention.

## Lists

- Virtualize: only render visible rows. `FlatList`/`FlashList` (RN), `LazyColumn` (Compose),
  `LazyVStack`/`List` (SwiftUI), `ListView.builder`/`Slivers` (Flutter).
- Stable, unique keys/ids — never the index. `keyExtractor`/`id:` must not derive from mutable
  content.
- Fixed-height rows: use `getItemLayout` (RN) so the list can skip measurement.
- Memoize row components and their inputs; pass only the data each row needs.

## Rendering & frames

- Avoid allocations in `draw()`/`onMeasure()`/`draw(_:)`/composition.
- Compose: `derivedStateOf`, `@Stable`/`@Immutable` state classes, `remember` — avoid
  recomposition loops (see `android-compose.md`).
- SwiftUI: narrow observation, Equatable/POD views, `_logChanges()` to debug updates
  (see `ios-swiftui.md`).
- RN/Flutter: no JS/Dart-thread animation work; use native drivers and the rendering engine
  (Reanimated, Impeller). `const` constructors everywhere possible (Flutter).
- Downsample images before rendering; never decode full-res for thumbnails (coil/glide,
  `AsyncImage`/downsampling, image caching).

## Memory

- No `Activity`/`Context`/view references in singletons, ViewModels, or stores; use
  `applicationContext`; weak refs for long-lived listeners.
- Cancel coroutines/streams/tasks when work is done or the view disappears
  (`viewModelScope`, `.task`, `DisposableEffect`).
- Null the Fragment `binding` in `onDestroyView` (Java). Bitmap recycling + memory-cache sizing.
- Run LeakCanary (Android) / Instruments memory + leaks (iOS) in debug builds.
- SwiftUI: property wrappers inside `@Observable` classes must be `@ObservationIgnored`; keep
  `@State` private; don't pass whole models when a value suffices (see `ios-swiftui.md`).

## Network & images

- Respect HTTP caching headers; image CDN + WebP; Gzip/Brotli; request batching; connection
  pooling.
- Wrap all network calls with timeouts + retry (exponential backoff); expose network state in
  the UI (see `offline-sync.md`).
- Cache-first: show stale data, refresh in background; local store (Room/Drift/MMKV/SQLite) as
  source of truth.

## Battery & background

- Background work only through the platform scheduler: **WorkManager** (Android) with
  constraints; background URLSession / BGTask (iOS); isolates (Flutter).
- Location: request only the needed accuracy; stop when backgrounded. Wakelocks used sparingly
  with explicit release.
- Android OEM background restrictions vary — test push, alarms, sync on Samsung/Xiaomi/Huawei.

## Profiling

- Measure, don't guess: Android Studio Profiler + `FrameMetrics`; Instruments (SwiftUI template
  on real devices, Time Profiler on the Simulator); Flutter DevTools; React DevTools/Profiler;
  EAS Observe for production Expo metrics.
- For Instruments traces: `main_running_coverage_pct` <25% = blocked (waiting), ≥75% =
  CPU-bound; high-edge-count invalidation sources (`UserDefaultObserver.send()`, wide
  `EnvironmentWriter`s) are structural bugs.
- Code-first audit before profiling: invalidation storms → identity churn → heavy work in
  `body`/composition → layout thrash (deep hierarchies, `GeometryReader`, preference chains) →
  main-thread image decode → overly broad animations. Prioritize by impact.
- Always re-run the same capture after a fix and compare before/after metrics.
