# Android — Kotlin & Jetpack Compose

Production-grade native Android development: stack options, architecture, Compose UI rules,
state management, navigation, testing, build/release, performance, debugging, and OEM issues.
Sources: android-dev (+ native-android/java-android references), android-jetpack-compose-expert.

## Table of contents
- [Stack options (native)](#stack-options-native)
- [Architecture](#architecture)
- [Jetpack Compose UI rules](#jetpack-compose-ui-rules)
- [State management (MVVM/MVI)](#state-management-mvvm-mvi)
- [Type-safe navigation](#type-safe-navigation)
- [Language standards](#language-standards)
- [Build & release](#build--release)
- [Testing](#testing)
- [Performance & memory](#performance--memory)
- [Debugging common bugs](#debugging-common-bugs)
- [OEM-specific issues](#oem-specific-issues)
- [Development roadmap (phases)](#development-roadmap-phases)

## Stack options (native)

- **Kotlin + Jetpack Compose** — default for new Android-only apps. Key libs: Room,
  Retrofit/Ktor, Hilt, WorkManager, DataStore, Navigation Compose.
- **Java + XML Views** — for existing Java codebases / legacy maintenance / incremental
  migration. Key libs: Room, Retrofit, Hilt, WorkManager, LiveData, ViewModel. Java + Kotlin
  coexist in one project; migrate incrementally.

Cross-platform alternatives (Flutter/RN/KMM/hybrid) are covered in `framework-selection.md`.

## Architecture

Separate UI, business logic, and data into testable layers:

```
app/
├── ui/              # Composables / Activities / Fragments / screen states
├── presentation/    # ViewModels, UI State, UI Events
├── domain/          # Use cases, domain models, repository interfaces
├── data/            # Repository impl, remote (API), local (DB), mappers
└── di/              # Dependency injection modules
```

Unidirectional data flow:

```
User Action → ViewModel → Use Case → Repository → Data Source
                    ↓
             UI State (sealed class / StateFlow)
                    ↓
             Composable renders state
```

- `StateFlow`/`SharedFlow` for reactive state; `sealed class UiState` + `sealed class UiEvent`.
- Hilt for DI; coroutines + Flow for async; repository pattern wrapping Room + Retrofit.
- Large apps: multi-module (`:app`, `:core:ui`, `:core:network`, `:core:database`,
  `:feature:*`).

## Jetpack Compose UI rules

- Use `MaterialTheme` tokens; never hardcode colors/dimensions. `CompositionLocal` for theme,
  locale, haptics.
- `remember`/`rememberSaveable` correctly — `rememberSaveable` for UI state that must survive
  rotation. Mark UI-state data classes `@Immutable`/`@Stable` (especially with `List`/unstable
  types) to enable smart recomposition skipping.
- Extract large composables into sub-composables (each function ≤ ~80 lines); hoist state to
  the lowest common ancestor.
- Use `LazyColumn`/`LazyVerticalGrid` for lists; never `Column` + `forEach` for large data.
- Side effects only in `LaunchedEffect`, `DisposableEffect`, `SideEffect`.
- `derivedStateOf` to avoid unnecessary recomputation; `remember` expensive derived work.
- Don't pass ViewModels down — pass state + callbacks (events).
- **Infinite recomposition loop?** Check for new object instances (`List`, `Modifier`) created
  inside composition without `remember`, or state updates during composition. Debug with Layout
  Inspector recomposition counts.
- Accessibility: `contentDescription`/`semantics {}`, min touch target 48×48dp, TalkBack
  tested before release, `sp` for text, contrast ≥ 4.5:1.
- Responsive/adaptive: support phones, foldables, tablets (`WindowSizeClass`); test at
  320/360/411/600+/840+ dp; foldable hinge via `WindowInfoTracker`; edge-to-edge + `WindowInsets`
  for Android 15+.

## State management (MVVM/MVI)

```kotlin
data class UserUiState(
    val isLoading: Boolean = false,
    val user: User? = null,
    val error: String? = null
)

class UserViewModel @Inject constructor(
    private val userRepository: UserRepository
) : ViewModel() {
    private val _uiState = MutableStateFlow(UserUiState())
    val uiState: StateFlow<UserUiState> = _uiState.asStateFlow()   // expose only read-only

    fun loadUser() {
        viewModelScope.launch {
            _uiState.update { it.copy(isLoading = true) }
            runCatching { userRepository.getUser() }
                .onSuccess { _uiState.update { it.copy(user = it, isLoading = false) } }
                .onFailure { _uiState.update { it.copy(error = it.message, isLoading = false) } }
        }
    }
}
```

Consume with `collectAsStateWithLifecycle()`. Split stateful `Screen` (owns ViewModel) from
stateless `Content` (receives state + lambdas).

## Type-safe navigation

```kotlin
@Serializable object Home
@Serializable data class Profile(val userId: String)

NavHost(navController, startDestination = Home) {
    composable<Home> { HomeScreen(onNavigateToProfile = { id -> navController.navigate(Profile(userId = id)) }) }
    composable<Profile> { backStackEntry ->
        val profile: Profile = backStackEntry.toRoute()
        ProfileScreen(userId = profile.userId)
    }
}
```

- Register deep-link handling for every externally-openable screen; manage the back stack
  deliberately (`popUpTo`, `launchSingleTop`).

## Language standards

**Kotlin:** prefer `data class`/`sealed class`/`object`/`enum class`; no `!!` — use `?.let`,
`?: return`, or `requireNotNull(message)`; always specify `CoroutineScope` + `Dispatcher`
explicitly (never `GlobalScope`); `@Stable`/`@Immutable` on Compose state classes.

**Java:** `@NonNull`/`@Nullable` on all params/returns; null-check explicitly or
`Objects.requireNonNull`; null the `binding` reference in `onDestroyView()`; use
`ExecutorService` (not deprecated `AsyncTask`); `ListAdapter` + `DiffUtil` (not
`notifyDataSetChanged()`); `ViewBinding` (never `findViewById`).

## Build & release

- Gradle: `build.gradle.kts` only; version catalog (`libs.versions.toml`); `buildConfig` for
  env constants; Baseline Profiles for startup; R8 full mode in release with proguard rules in
  version control.
- Build variants: `debug` (dev API, logs, debuggable) / `staging` (staging API, minified, not
  debuggable) / `release` (prod API, logs off, minified, signed).
- CI: PR → lint + unit + debug APK (<5 min); merge → unit+integration + staging build +
  Firebase App Distribution; release tag → full suite + E2E on device farm → release AAB →
  Play Console internal track → closed → open → production.
- **Staged rollouts:** 5% → 20% → 50% → 100% with 24-48h monitoring of Crashlytics + ANR
  before expanding. Never skip for significant changes.
- Signing: upload key in CI secrets, never committed; use Google Play App Signing; document
  key recovery in the team runbook.

## Testing

Pyramid: ~70% unit / ~20% integration / ~10% UI-E2E.

- Unit: JUnit5 + MockK + Turbine (Flow) + Kotest; coverage ≥80% on domain + presentation.
- Integration: Room in-memory DB tests; Retrofit/Ktor with `MockWebServer`; repository tests
  verifying cache+remote coordination; contract tests against staging.
- UI/E2E: Espresso for critical journeys; **Maestro** for cross-platform flows (also works for
  Flutter/RN); real-device farm (Firebase Test Lab / BrowserStack) before release; smoke suite
  on every PR, full suite nightly.
- Test data: factories/builders, hermetic tests (no shared mutable state), fakes over mocks
  for complex deps.

## Performance & memory

- Startup: cold < 1s, warm < 500ms; App Startup library for lazy init; Baseline Profiles
  committed to repo; heavy init off main thread.
- UI: 60fps / zero jank; measure with Android Studio Profiler + `FrameMetrics`; avoid
  allocation in `draw()`/`onMeasure()`/composition; `derivedStateOf` to avoid recompositions;
  image loading via Coil/Glide — never full-res in thumbnails.
- Memory: no `Activity`/`Context` in ViewModels/singletons; weak refs for long-lived listeners;
  bitmap recycling; **LeakCanary** in debug builds always.
- Network: HTTP caching respected; image CDN + WebP; Gzip/Brotli; request batching; connection
  pooling.
- Battery: background work only via **WorkManager** with constraints; location at needed
  accuracy only, stop when backgrounded; wakelocks sparingly with explicit release.

## Debugging common bugs

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| ANR | Main-thread I/O / long computation | Move to coroutine/`Dispatcher.IO` |
| Memory leak | Context stored in singleton | `applicationContext`; weak ref |
| Crash on rotation | State not saved | `rememberSaveable` / ViewModel |
| UI lag | Recomposition loop | `derivedStateOf`, stable params |
| Blank screen after API call | Error swallowed | Propagate error state |
| Deep link broken | Intent filter missing | Test `adb shell am start` |
| Silent push | Background restrictions | Test across OEMs |

Logging: production = Crashlytics/Sentry only (no `Log.d` in release); debug/staging =
Timber. Levels: ERROR/WARN/INFO/DEBUG. Never log PII. Crash-free session target ≥ 99.5%; ANR
rate < 0.47%.

Debug process: reproduce reliably → isolate (UI/logic/network/persistence?) → instrument
targeted (not shotgun) logs → form 1-3 hypotheses → fix root cause (not symptom) → write a
regression test → document why.

## OEM-specific issues

- Test Samsung, Xiaomi/MIUI, OnePlus/OxygenOS, Huawei (no GMS) for critical flows.
- Background restrictions vary wildly by OEM — verify push, alarms, background sync.
- Keep a physical or cloud device farm with top market-share devices.

## Development roadmap (phases)

0. **Foundation (wk 1-2):** stack decision documented; module structure; design tokens; CI
   (lint+unit+build); crash reporting; analytics; API contract/mock server; DI; nav skeleton;
   flavors. 1. **Core (wk 3-8):** auth; screen shells; network layer; DB; repository wiring;
   ViewModels + UI states; unit tests; feature flags. 2. **Polish (wk 9-12):** design QA;
   accessibility audit; dark mode; localization/RTL; loading/empty/error states; deep links;
   widgets/notifications; offline verification. 3. **Hardening (wk 12-14):** performance
   profiling; E2E on device farm; security review; R8 rules; crash-free ≥99.5% on staging;
   store listing. 4. **Release:** signed AAB to internal track; staged rollout plan;
   monitoring dashboard; rollback plan; on-call. 5. **Post-launch:** crash-free daily; ANR
   <0.47%; ratings triaged weekly; dependency updates monthly; OS beta testing.
