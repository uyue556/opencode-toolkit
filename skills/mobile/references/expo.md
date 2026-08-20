# Expo Ecosystem (React Native)

Everything around Expo: router/native UI, dev clients, upgrading SDKs, native modules,
brownfield integration, API routes, EAS workflows/CI, styling with Tailwind, examples, and
EAS Observe. Sources: building-native-ui, expo-api-routes, expo-brownfield, expo-cicd-workflows,
expo-deployment, expo-dev-client, expo-examples, expo-module, expo-observe, expo-tailwind-setup,
expo-ui (+jetpack-compose/swift-ui), upgrading-expo, add-app-clip (routed to
`deployment-store.md` for store parts).

## Table of contents
- [Golden rules](#golden-rules)
- [Expo Go vs development client](#expo-go-vs-development-client)
- [Expo Router & native UI](#expo-router--native-ui)
- [Upgrading the SDK](#upgrading-the-sdk)
- [Expo Modules API (native code)](#expo-modules-api-native-code)
- [Brownfield (embed in an existing native app)](#brownfield-embed-in-an-existing-native-app)
- [API routes (+api.ts)](#api-routes-api-ts)
- [EAS workflows / CI](#eas-workflows--ci)
- [Tailwind CSS (v4) setup](#tailwind-css-v4-setup)
- [Native UI with @expo/ui](#native-ui-with-expo-ui)
- [EAS Observe (performance metrics)](#eas-observe-performance-metrics)
- [Using official examples](#using-official-examples)

## Golden rules

- **Try Expo Go first** before any custom build. `npx expo start` + scan QR. Custom builds
  (`npx expo run:ios/android`, `eas build`) are needed only for: local Expo modules, Apple
  targets (widgets/app clips/extensions), third-party native modules not in Expo Go, or custom
  native config not expressible in `app.json`.
- **Library preferences:** `expo-audio`/`expo-video` (not `expo-av`); `expo-image` with
  `source="sf:name"` for SF Symbols (not `expo-symbols`/`@expo/vector-icons`);
  `expo-glass-effect` for liquid-glass backdrops; `Color` from `expo-router` for native
  semantic colors (not raw `PlatformColor`); `process.env.EXPO_OS` (not `Platform.OS`);
  `React.use` (not `React.useContext`); never import `@react-navigation/*` directly on SDK
  56+ — use `expo-router/react-navigation`.
- **Responsiveness:** root component in a ScrollView with
  `contentInsetAdjustmentBehavior="automatic"` instead of `SafeAreaView`; apply to
  FlatList/SectionList too; flexbox not Dimensions; `useWindowDimensions` not `Dimensions.get()`.
- **Styling:** CSS/Tailwind not supported in inline RN styles — use inline styles; prefer flex
  `gap` over margins; `{ borderCurve: 'continuous' }` for rounded corners; CSS `boxShadow`
  (never legacy shadow/elevation); `contentContainerStyle` padding on ScrollViews (not padding
  on the ScrollView).
- Never co-locate components/types/utilities in the `app/` router directory.

## Expo Go vs development client

Dev clients are the recommended setup for any real/production app (Expo Go is a playground).
You need a dev client for local modules, Apple targets, third-party native modules, config
plugins, and testing remote push / App & Universal Links. Configure `eas.json` with
`"development": { "developmentClient": true, "autoIncrement": true }` and build via
`eas build -p ios --profile development [--submit]`. Install: `xcrun simctl install booted
./path/App.app` (iOS sim) / `adb install build.apk` (Android) / `ideviceinstaller -i build.ipa`
(device).

## Expo Router & native UI

- Routes live in `app/`; always have a route matching `/` (may be inside a group).
- Use `_layout.tsx` for stacks; `Stack` from `expo-router/stack`; set page titles in
  `Stack.Screen options`. `NativeTabs` from `expo-router/unstable-native-tabs`.
- Navigation: `<Link href="/path">`; `asChild` to wrap custom components; add `Link.Preview`
  and context menus (`Link.Trigger`/`Link.Menu`) frequently per iOS conventions.
- Modals: `presentation: "modal"`; sheets: `presentation: "formSheet"` with
  `sheetAllowedDetents`, `sheetGrabberVisible`, and transparent `contentStyle` (liquid glass on
  iOS 26+).
- Colors: `Color` API from `expo-router` — `Color.ios.*`, `Color.android.material.*` /
  `Color.android.dynamic.*`; wrap in `Platform.select` with a web hex fallback; centralize in
  `theme/colors.ts`; call `useColorScheme()` in components that render Android colors so they
  update on theme flips. Don't pass `Color`/`PlatformColor` into Reanimated styles.
- Text: add `selectable` to `<Text>` showing important data/errors; `fontVariant:
  'tabular-nums'` for counters; always use a navigation stack title rather than a custom text
  header.

## Upgrading the SDK

1. `npx expo install expo@latest` then `npx expo install --fix`; run `npx expo-doctor`.
2. Clear caches: `npx expo export -p ios --clear`; `rm -rf node_modules .expo`.
3. If native changes are needed and the project is CNG (no `ios/`/`android/` dirs), skip
   prebuild; otherwise `npx expo prebuild --clean` and clear caches for the bare workflow.
4. Housekeeping: review release notes (`expo.dev/changelog`); SDK 54+ needs
   `react-native-worklets` for reanimated; enable React Compiler via
   `"experiments": { "reactCompiler": true }`; delete `sdkVersion` from app.json; remove
   implicit packages (`@babel/core`, `babel-preset-expo`, `expo-constants`); delete default-only
   `babel.config.js`/`metro.config.js`; remove unneeded patches and `expo.install.exclude`
   workarounds.
5. Deprecated package swaps: `expo-av` → `expo-audio`/`expo-video`; `expo-permissions` →
   per-package APIs; `@expo/vector-icons` → `expo-symbols`; `AsyncStorage` →
   `expo-sqlite/localStorage/install`; `expo-app-loading` → `expo-splash-screen`;
   `expo-linear-gradient` → `experimental_backgroundImage` + CSS gradients (New Arch only).
6. New Architecture is default (no `newArchEnabled` needed); Expo Go supports New Arch only as
   of SDK 53. Metro: `unstable_enablePackageExports` default in 53, `experimentalImportSupport`
   default in 54, `EXPO_USE_FAST_RESOLVER` removed in 54; webpack is deprecated → Expo Router
   + Metro web. PostCSS: use `postcss.config.mjs`; remove `autoprefixer`.
7. Beta releases use the `.preview` suffix (`npx expo install expo@next --fix`); check
   https://exp.host/--/api/v2/versions for `-preview`.

## Expo Modules API (native code)

- Prefer `npx create-expo-module` scaffolding over hand-rolled files. Local module (one app,
   lives in `modules/` or `expo.autolinking.nativeModulesDir`) vs standalone module (reuse,
   monorepos, publishing). Add a platform later with `create-expo-module add-platform-support`,
   not manual copying.
- Features (opt-in): `Constant`, `Function`, `AsyncFunction`, `Event`, `View`, `ViewEvent`
  (implies `View`), `SharedObject`.
- DSL is the same shape in Swift and Kotlin:

```swift
public class MyModule: Module {
  public func definition() -> ModuleDefinition {
    Name("MyModule")
    Function("hello") { (name: String) -> String in "Hello \(name)!" }
  }
}
```

- TS side: `requireNativeModule("MyModule")`. `expo-module.config.json` maps platforms to
  classes: iOS uses the bare class name; Android the fully-qualified name.
- Also covers native views, config plugins (Info.plist / AndroidManifest.xml mutation), and
  lifecycle hooks (module, AppDelegate, Activity/Application listeners).

## Brownfield (embed in an existing native app)

Two approaches (Expo SDK 55+ is the minimum for brownfield):

- **Isolated:** ship RN as a prebuilt AAR (Android) / XCFramework or Swift Package (iOS);
  consuming native app needs no Node/RN tooling; good for separate repos/cadences.
- **Integrated:** add RN + Expo sources to the existing Gradle/CocoaPods build; one team owns
  everything; hot reload + source maps inside the native build. Requires CocoaPods on iOS.

Shared: Node LTS + Yarn in the build environment; pin the same Expo SDK across the RN project
and embedded deps (`npx create-expo-app@latest my-project --template default@sdk-55`).

## API routes (+api.ts)

- API routes live in `app/` with a `+api.ts` suffix; export named handlers per HTTP method
  (`GET`/`POST`/`PUT`/`DELETE`); dynamic routes via `[id]`; read query/headers/JSON body from
  the standard `Request`.
- Use them for server-side secrets, DB ops, third-party API proxies, server-side validation,
  webhooks, rate limiting, heavy computation. **Don't** use them for public data, simple CRUD,
  real-time (use WebSockets), file uploads (direct-to-storage), or auth-only (use Clerk/Auth0).
- Secrets via `process.env`; `eas env:create` for production. Test locally with
  `npx expo serve`, deploy with `eas deploy` (Cloudflare Workers runtime).
- EAS Hosting runtime limits: no Node `fs`/native modules, 30s CPU limit, no persistent
  connections — use Web APIs (`crypto.subtle`, `fetch`) and cloud DBs (D1, Turso, Supabase,
  Neon, PlanetScale).
- Always validate/sanitize input, use proper status codes, log server-side, never expose keys.

## EAS workflows / CI

- Workflows live in `.eas/workflows/*.yml` with top-level `name`, `on`, `jobs`, `defaults`,
  `concurrency`. Expressions use `${{ }}` with `github.*`, `inputs.*`, `needs.*`, `jobs.*`,
  `steps.*`, `workflow.*` contexts.
- **Always fetch the live JSON schema** (`https://api.expo.dev/v2/workflows/schema`) plus the
  syntax and pre-packaged-jobs docs before writing or validating workflow files — don't rely on
  memory. See `scripts/fetch.js` and `scripts/validate.js` in this skill.
- Standard pipeline: PR → lint + unit + build (<5 min); merge → staging build + submit;
  release tag → full tests + E2E + production build + submit to internal track.
- Deployment via EAS: `eas build` (production profile), `eas submit`, `npx testflight`,
  `eas deploy` for web + API routes. Version management with `appVersionSource: "remote"`.
  See `deployment-store.md`.

## Tailwind CSS (v4) setup

- Install: `npx expo install tailwindcss@^4 nativewind@5.0.0-preview.2 react-native-css
  @tailwindcss/postcss tailwind-merge clsx`; add a `lightningcss` resolution in package.json
  (`1.30.1`). No babel.config.js needed (v4/NativeWind v5 is CSS-first).
- Config: `metro.config.js` with `withNativewind(config, { inlineVariables: false,
  globalClassNamePolyfill: false })`; `postcss.config.mjs` with `@tailwindcss/postcss`;
  `src/global.css` importing `tailwindcss/theme.css`/`preflight.css`/`utilities.css`.
- Wrap components with `useCssElement` for `className` support (`src/tw/index.tsx` for View/
  Text/ScrollView/Pressable/TextInput/Link/Image/Animated); platform fonts and Apple semantic
  colors via `@media ios`/`@media android` blocks with `platformColor()` + `light-dark()`
  fallbacks; `@theme` for custom tokens; `useCSSVariable` hook to read CSS vars in JS.

## Native UI with @expo/ui

`@expo/ui` renders real SwiftUI (iOS) and Jetpack Compose (Android) from React.

- **Universal layer (start here, SDK 56+):** import from `@expo/ui` root — one tree for
  iOS/Android/web. Wrap every tree in `Host`.
- **Platform-specific:** `@expo/ui/swift-ui` (iOS only) and `@expo/ui/jetpack-compose`
  (Android only) — use only when the universal layer lacks a component/modifier. Importing one
  on the other platform crashes at runtime; isolate in `.ios.tsx`/`.android.tsx` under
  `components/` (never in `app/` — router doesn't support platform extensions). `Host` always
  comes from `@expo/ui`.
- The API mirrors SwiftUI / Compose, so apply native knowledge to pick components/modifiers;
  check component docs per SDK version. `RNHostView` embeds RN components inside a SwiftUI tree;
  use `LazyColumn` (wrapped in `<Host style={{ flex: 1 }}>`) instead of RN ScrollView/FlatList;
  `<Icon source={require('./icon.xml')} />` with Material Symbols XML drawables.
- **Drop-in replacements:** `@expo/ui/community/<name>` swaps popular RN community UI libs
  (bottom-sheet, datetimepicker, …). Use `scripts/list-components.js` to enumerate installed
  components/modifiers.

## EAS Observe (performance metrics)

- Tracks startup, navigation, and custom-event performance from production Expo apps.
  Canonical docs: https://docs.expo.dev/eas/observe/.
- Add: install `expo-observe`; wrap the root layout (`AppMetricsRoot` on SDK 55, `ObserveRoot`
  on SDK 56+); call `markInteractive()` (global on SDK 55, via the `useObserve()` hook on
  SDK 56+); optional per-route metrics via the Expo Router / React Navigation integrations.
- Query via EAS CLI: `eas observe:metrics-summary`, `metrics`, `routes`, `events`, `versions`.

## Using official examples

- `expo/examples` (~70 `with-*` integrations: Stripe, Clerk, Supabase, OpenAI, maps, Reanimated,
  SQLite, Skia, NativeWind…). They are managed, single-screen ~100-200 line projects — mine the
  *pattern* (deps, config plugins, minimal wiring), not the architecture.
- **Adapt non-destructively:** add only missing deps with `npx expo install <pkg>` (don't copy
  pinned versions), merge config plugins/permissions rather than replacing, port integration
  code, recreate env-var *shapes* (never working secrets).
- Live list via `gh api repos/expo/examples/contents`; `meta.json` is the source of truth for
  aliases/deprecated examples. Default branch is `master`. Scaffold with
  `npx create-expo --example with-stripe`.
