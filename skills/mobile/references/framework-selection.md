# Framework & Stack Selection

Decide the mobile stack from requirements, not preference. Route here before starting any
new mobile project or when the user is evaluating options. Sources: android-dev, mobile-developer,
mobile-design, flutter-expert.

## Decision tree (canonical)

```
Need OTA updates + web/web team  → React Native + Expo
High-perf custom UI, one codebase → Flutter
iOS only                          → SwiftUI (Swift)
Android only                      → Kotlin + Jetpack Compose
Share business logic across all platforms, keep native UI → Kotlin Multiplatform (KMM)
Web-first team, simple/PWA-like apps → Hybrid (Capacitor/Ionic) — avoid for heavy animation,
  native sensors, or high-performance games
```

No debate without justification. If the user says "cross-platform", default to RN+Expo or
Flutter and justify the choice.

## Options at a glance

| Stack | Language | UI | Key libraries |
|-------|----------|----|---------------|
| Native Android (new) | Kotlin | Jetpack Compose | Room, Retrofit/Ktor, Hilt, WorkManager, DataStore, Navigation Compose |
| Native Android (existing Java) | Java (still fully supported) | XML Views (ConstraintLayout, RecyclerView, ViewBinding) | Room, Retrofit, Hilt, LiveData, ViewModel |
| Flutter | Dart | Widget tree (Material 3 / Cupertino) | Riverpod/Bloc, Dio, Drift/Isar, go_router, flutter_local_notifications |
| React Native | TypeScript (preferred) | RN core + NativeWind/Paper | React Navigation, Zustand/Redux Toolkit, React Query, MMKV |
| KMM | Kotlin everywhere | Native Compose on Android; Compose Multiplatform for shared UI | Ktor, SQLDelight, Koin, kotlinx.serialization |
| Hybrid | TypeScript + HTML/CSS | Ionic | Capacitor |

## Decision matrix

| Requirement | Native Kotlin | Native Java | Flutter | RN | KMM | Hybrid |
|---|---|---|---|---|---|---|
| Android-only (new) | ✅ Best | ✅ | ✅ | ✅ | ✅ | ✅ |
| Android-only (existing Java) | ⚠️ migrate | ✅ Best | ❌ | ❌ | ⚠️ | ❌ |
| Android + Web | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ Best |
| Android + Desktop | ❌ | ❌ | ✅ | ⚠️ | ✅ | ⚠️ |
| Shared business logic only | N/A | N/A | N/A | N/A | ✅ Best | N/A |
| Native performance | ✅ | ✅ | ✅ | ⚠️ | ✅ | ❌ |
| JS/TS team | ❌ | ❌ | ❌ | ✅ Best | ❌ | ✅ |
| Custom pixel-perfect UI | ✅ | ⚠️ | ✅ Best | ⚠️ | ✅ | ❌ |

## Notes on each

- **Native Android (Kotlin + Compose):** best for Android-only apps, hardware-intensive
  features, best-in-class UX. Java and Kotlin coexist seamlessly in one project — migrate
  incrementally.
- **React Native + Expo:** fastest path to iOS+Android+web; Expo handles native tooling.
  Prefer Expo's managed workflow; only leave it for specific native needs. See `expo.md`.
- **Flutter:** pixel-perfect custom UI and smooth 60fps out of the box; single codebase for
  mobile + web + desktop + embedded. Impeller rendering engine (replaces Skia) is the modern
  target.
- **KMM:** shares domain/data layers while keeping native UI. Use `expect/actual` for
  platform-specific implementations.
- **Hybrid (Capacitor):** fine for content-style apps from a web team; not for games,
  heavy animations, or deep sensor/hardware access.

## Java vs Kotlin decision (existing Android codebases)

- Kotlin is the modern default for new native Android code; Java is *not* deprecated and is the
  right call for legacy teams and incremental migration.
- Migration path: keep both languages in one project; convert files incrementally with View
  Binding and Kotlin extensions; run the same lint/test gates.

## When to say no

- Don't choose cross-platform when the app is iOS-only and the team knows Swift/SwiftUI.
- Don't choose Hybrid for performance-critical or sensor-heavy apps.
- Don't pick KMM just for "sharing"; its complexity pays off only for non-trivial shared logic.
