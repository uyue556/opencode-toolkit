# Cross-platform — React Native & Flutter

Patterns for React Native (TypeScript) and Flutter (Dart) beyond what the Expo and framework
selection references cover: language standards, state management, architecture, performance,
and platform integration. Sources: mobile-developer, flutter-expert, mobile-design,
android-dev (RN/Flutter references).

## Table of contents
- [React Native](#react-native)
- [Flutter](#flutter)
- [Shared performance doctrine](#shared-performance-doctrine)

## React Native

### Language standards
- `strict: true` in tsconfig always; no `any` — use `unknown` and narrow.
- Zod or io-ts for runtime validation of API responses.
- Pin dependency versions; audit monthly; keep dependency count minimal.

### Architecture
- New Architecture (Fabric renderer, TurboModules, JSI) is the modern target; Hermes JS engine
  enabled; Metro bundler tuned (code splitting, bundle size).
- State: Redux Toolkit or Zustand. RTK Query / React Query for server state; Zustand slices
  for client state; custom hooks encapsulate per-feature business logic.
- Navigation: React Navigation v7 with typed `NavigationProp`.
- Storage: MMKV for high-performance local storage.

### Library preferences (modern replacements)
- **Never** use modules removed from RN: `Picker`, `WebView`, `SafeAreaView`, `AsyncStorage`.
- `react-native-safe-area-context` instead of RN `SafeAreaView`.
- Prefer `FlashList`/`FlatList` over `ScrollView` for lists; `useCallback` + `React.memo` on
  `renderItem`; stable `keyExtractor` (never index); `getItemLayout` when rows are fixed-height.
- Use `useWindowDimensions` over `Dimensions.get()`; flexbox over Dimensions API.
- No JS-thread animations — use the native/UI driver (Reanimated); strip `console.log` in prod.

### Native integrations
- Native modules with Swift/Kotlin (see `expo.md` for the Expo Modules API path).
- Brownfield adoption (embedding RN into an existing native app): see `expo.md`.

## Flutter

### Language & state
- Dart 3 null safety required; no `!` without an explicit null check above it.
- Immutable state objects with `copyWith`; `const` constructors on all stateless widgets;
  keys used strategically for widget identity.
- State management: **Riverpod 2.x** (compile-time safe) or **Bloc/Cubit** for business-logic
  isolation; Provider for simple sharing; get it done — don't over-engineer. Repositories as
  abstract classes with injected impls.
- Architecture: Clean Architecture layers; feature-driven modules; DI with GetIt/Injectable.

### Performance
- **Impeller** rendering engine (replaces Skia) is the modern target.
- Minimize widget rebuilds: `const` constructors, targeted rebuilds only.
- Lists: `Slivers`/`ListView.builder` for large data; never build everything eagerly.
- `Isolate` for CPU-intensive/background work.
- Profile with Flutter DevTools on real devices; frame budget 60/120fps.

### Platform integration
- Platform channels (method/event/basic message); Kotlin/Swift native plugins; FFI for C/C++.
- Cupertino widgets for iOS, Material 3 for Android; adaptive/responsive via `LayoutBuilder`
  + `MediaQuery`.
- Local storage: Drift (type-safe), Hive, ObjectBox; `flutter_secure_storage` for secrets.
- Notifications: `flutter_local_notifications`; deep links via `go_router` with named routes
  and guards; `local_auth` for biometrics.
- CI/CD: Codemagic, GitHub Actions, Bitrise; flavors/env-specific config; OTA updates.

## Shared performance doctrine

See `mobile-performance.md` for the full cross-framework doctrine. Essentials:

- Lists are virtualized with stable keys; renderItem/widget builders are memoized.
- No JS/UI-thread blocking work; no logging in production.
- `const`/memo everywhere possible; narrow re-renders.
- Images: downsampled, cached, never full-res in thumbnails.
- Startup budget: cold < 1s; lazy-init heavy dependencies.
