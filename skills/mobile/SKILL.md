---
name: mobile
description: "End-to-end mobile app development — native iOS/SwiftUI, native Android/Kotlin+Compose, cross-platform (React Native/Expo, Flutter), and every supporting practice: app-store deployment, performance, offline sync, testing (incl. Appium), security, and touch-first design. Use whenever the user works on a mobile app, screens, or SDKs. Triggers: iOS, SwiftUI, Swift, UIKit, Android, Kotlin, Jetpack Compose, React Native, Expo, expo-router, EAS, Flutter, Dart, app store, Play Store, TestFlight, App Clip, Appium, mobile UI, push notifications, deep links, offline-first, 移动开发, 安卓, iOS开发, SwiftUI, React Native, Flutter, 跨平台, 上架, 应用商店, 性能优化, 离线, 推送通知, 移动端测试."
---

# Mobile App Development (iOS · Android · Cross-platform)

Consolidated guidance for building production-grade mobile apps. It replaces a library of
~30 mobile skills covering native SwiftUI/iOS and Kotlin/Android development, React Native +
Expo (routing, modules, deployment, upgrades, UI), Flutter, Appium automation, mobile
design, performance, security, and store distribution. This file is the router; the deep
detail lives in `references/`.

## When to use this skill

Use it for any task that touches a mobile app: writing UI or screens, choosing a stack,
setting up a project, wiring navigation, handling state, optimizing performance, debugging on
a device/simulator, automating tests, deploying to a store, or securing the app. If the task
is pure web frontend or backend with no mobile surface, don't use it.

## Core workflow

1. **Establish context first.** Mobile design is not a scaled-down desktop. Before writing any
   code, clarify (and if ambiguous, ask): target platform(s) (iOS / Android / both), framework
   (native, React Native/Expo, Flutter), navigation model, offline requirements, and target
   devices. See `references/design-ux.md` for the mandatory checkpoint.
2. **Pick the framework** with the decision matrix in `references/framework-selection.md`.
   Don't default to a favorite stack; let requirements (team, targets, performance needs)
   decide.
3. **Route to the right reference** (table below) and read it *before* coding — the "why"
   matters more than the snippet.
4. **Verify version-sensitive facts** (SDK numbers, store policies, API signatures, library
   versions) against current official docs before shipping. Every source skill flagged this.

## Reference routing table

| Task / topic                                   | Reference file                    |
|------------------------------------------------|-----------------------------------|
| Picking a stack / framework decision matrix    | `references/framework-selection.md` |
| Native iOS — SwiftUI, state, latest APIs, perf | `references/ios-swiftui.md`       |
| Native Android — Kotlin, Compose, architecture | `references/android-compose.md`   |
| React Native + Flutter cross-platform patterns | `references/cross-platform.md`    |
| Expo ecosystem — router, modules, CI/CD, brownfield, upgrades, Tailwind | `references/expo.md` |
| EAS builds, App Store / Play Store, ASO, App Clip | `references/deployment-store.md` |
| Performance doctrine (startup, lists, memory)  | `references/mobile-performance.md` |
| Offline-first data & sync                      | `references/offline-sync.md`      |
| Testing strategy + Appium automation           | `references/testing.md`           |
| Mobile security (storage, WebView, auth)       | `references/mobile-security.md`   |
| Touch-first design, UX psychology, a11y        | `references/design-ux.md`         |

## Cross-cutting rules (apply everywhere)

- **Lists must be virtualized.** `FlatList`/`FlashList`/`List.builder`/`LazyColumn`/`LazyVStack`
  — never `ScrollView`+`map` or `Column`+`forEach` for large data. Stable keys/ids, never the
  array index.
- **Never block the main/UI thread.** Network, DB, JSON parsing, image decode happen off-thread
  (coroutines, isolates, `.task`, WorkManager). Strip `console.log`/`Log.d` from release builds.
- **Design system first.** Centralize colors, type scale, spacing, and shapes; never hardcode
  hex values or pixel dimensions per screen. Adapt to light/dark mode and accessibility
  settings.
- **Touch targets ≥ 44pt (iOS) / 48dp (Android).** Never rely on hover; primary CTAs live in
  the thumb zone. See `references/design-ux.md`.
- **Accessibility is non-negotiable:** labels/`contentDescription`/semantics, dynamic type,
  contrast ≥ 4.5:1, TalkBack/VoiceOver tested before release.
- **Secure by default:** tokens in Keychain/Keystore (never AsyncStorage/UserDefaults), HTTPS
  with pinning, no secrets in client code, no PII in logs. See `references/mobile-security.md`.
- **Store-sensitive platform norms:** back gesture, typography, icons, sheets differ between
  iOS and Android. See the unify/divergence matrix in `references/design-ux.md`.
- **Cache-first for offline resilience:** show stale data, refresh in background. See
  `references/offline-sync.md`.

## Best practices

- **Architecture:** separate UI / presentation / domain / data layers (Clean-ish). Unidirectional
  data flow: event → state holder → rendered state. Prefer the simplest state tool that fits
  (local `@State`/Compose `remember` first; a state store only when sharing grows).
- **State management:** expose immutable UI state (sealed/`data class`/`UiState`); keep
  `MutableStateFlow`/internal mutable state private; pass data + callbacks down, never the
  ViewModel/store.
- **Error handling:** never let an exception surface as a crash or silent blank screen.
  Classify errors (network retry w/ backoff, auth refresh→logout, validation inline, parse →
  cached fallback, unexpected → top-level catch + report). Show loading / empty / error states
  on every screen.
- **Testing:** follow the pyramid — ~70% unit (state holders, use cases, mappers), ~20%
  integration (DB, API contract), ~10% E2E (Espresso/Maestro/Appium/XCUITest). Target ≥80%
  coverage on domain+presentation. Smoke tests on every PR, full suite nightly, real-device
  farm before release. See `references/testing.md`.
- **Release discipline:** internal → closed → staged rollout to production; monitor crash rate
  and ANR before expanding. Keep signing keys in CI secrets, never in the repo. See
  `references/deployment-store.md`.

## Do & Don't

- **Do** read the relevant reference before writing code; each contains hard-won failure modes.
- **Do** try the fastest path first: Expo Go before a custom build, simulator before a device.
- **Do** gate version-specific APIs (`#available`, `Platform.select`, SDK guards) with fallbacks.
- **Don't** use deprecated modules (RN `AsyncStorage`/`SafeAreaView`/`Picker`, `expo-av`,
  `expo-permissions`, `@expo/vector-icons` for SF Symbols) — see `references/expo.md`.
- **Don't** copy pinned dependency versions from examples into an older project; use the
  SDK's installer (`npx expo install`) to resolve compatible versions.
- **Don't** hand-roll a workflow schema; fetch and validate against the live EAS schema
  (see `references/expo.md` and `scripts/`).
- **Don't** write UI without a loading/error/empty state, and never swallow errors silently.

## Common pitfalls

- **Recomposition / re-render storms:** new objects created in `body`/composition, broad
  observation of a whole model, `onChange` without a guard. Narrow dependencies, `remember`,
  `derivedStateOf`, Equatable/Observation-aware setters.
- **Memory leaks:** storing `Activity`/`Context`/view in singletons; keeping closures in
  environment keys; missed stream/task cancellation. Use `applicationContext`, weak refs,
  `.task` auto-cancel.
- **Rotation/process death state loss:** forgetting `rememberSaveable`/`ViewModel`/
  `@State`-owned models.
- **OEM fragmentation (Android):** push, background sync, and alarms behave differently on
  Samsung/Xiaomi/Huawei — test across the top market-share devices.
- **Store rejection:** placeholder content, missing privacy policy / demo account, incomplete
  metadata, claims the app can't back up. Prepare review info up front.
- **App Clip / associated-domain mistakes:** AASA file must be live *before* trusting the
  association; clip bundle ID is `<parent>.clip`; entitlements must exist or prebuild warns.

## Examples (routing in practice)

- "Build a cross-platform shopping app with offline support" → read
  `framework-selection.md` (RN+Expo vs Flutter), then `offline-sync.md`, `mobile-performance.md`.
- "My SwiftUI list is janky when scrolling" → `ios-swiftui.md` (perf + latest APIs), then
  `mobile-performance.md`.
- "Add push notifications to our Android app" → `android-compose.md` (WorkManager,
  backgrounding) + `mobile-security.md` (token storage).
- "Ship the Expo app to the Play Store" → `expo.md` (upgrade + CI) then
  `deployment-store.md`.
- "Write a test that runs the login flow on a real device" → `testing.md` (Appium).

## Limitations

- Guidance is architecture-agnostic on purpose: don't impose MVVM/VIPER; keep business logic
  testable without mandating a pattern.
- SDK versions, store policies, and recommended libraries change; always verify release-critical
  details against current Apple, Google, and library documentation.
- This skill does not replace device QA, accessibility review, security review, or store
  compliance checks before a production release.
- Code snippets are patterns to adapt, not complete applications; adapt package names,
  permissions, and signing to the actual project.
