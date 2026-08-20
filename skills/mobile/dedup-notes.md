# Deduplication Notes — mobile consolidation

Source library: `/home/administrator/.config/opencode/skill-libraries/mobile/` (30 SKILL.md
files, plus references/ and scripts/). Output: `mobile/` consolidated skill.

## Structure decision

Organized by mobile sub-topic and routed from `SKILL.md` via a reference table:

- `framework-selection.md` — stack decisions
- `ios-swiftui.md` — native iOS/SwiftUI (state, composition, perf, latest APIs, Liquid Glass,
  refactor, simulator debugging)
- `android-compose.md` — native Android (Compose, architecture, build, testing, OEM)
- `cross-platform.md` — RN + Flutter patterns
- `expo.md` — Expo ecosystem (router/UI, dev client, upgrades, modules, brownfield, API
  routes, EAS workflows, Tailwind, @expo/ui, Observe, examples)
- `deployment-store.md` — EAS/store/ASO/App Clip/release strategy
- `mobile-performance.md`, `offline-sync.md`, `testing.md`, `mobile-security.md`,
  `design-ux.md`

## Notable duplicates merged

- **`mobile-developer` / `ios-developer` / `flutter-expert` / `android-dev` overview sections**
  are near-identical capability-list boilerplate (the same "Capabilities / Behavioral Traits /
  Knowledge Base / Response Approach / Limitations" template). Their genuinely different
  signals were distilled into: `framework-selection.md` (stack matrix), `cross-platform.md`
  (RN/Flutter specifics), `android-compose.md` (Android lifecycle/roadmap), `ios-swiftui.md`
  (iOS capabilities), and shared rules in `SKILL.md`.
- **Performance guidance appears in 6 places** (`mobile-design` anti-pattern tables, `android-dev`
  §8, `swiftui-expert-skill/performance-patterns.md`, `swiftui-performance-audit`,
  `mobile-developer`, `building-native-ui`). Merged into one `mobile-performance.md` + per-stack
  performance sections in `ios-swiftui.md` / `android-compose.md` / `cross-platform.md`. The
  "performance sins" tables from `mobile-design` and `mobile-developer` were deduped into a
  single table.
- **Design-system / touch-target / accessibility guidance** appeared in `mobile-design`,
  `android-dev` §3, `mobile-developer`, and `ios-developer` — consolidated into `design-ux.md`.
- **Expo "try Expo Go first / when custom builds are required"** appears in both
  `building-native-ui` and `expo-dev-client` — merged once in `expo.md` (golden rules) and the
  dev-client section.
- **Deprecated package swap table** (`expo-av`, `expo-permissions`, `@expo/vector-icons`,
  etc.) appears in `upgrading-expo` and is echoed by `building-native-ui`'s library
  preferences — merged into `expo.md` and cross-referenced.
- **Security storage advice** (tokens in Keychain/Keystore, never AsyncStorage/UserDefaults)
  appears in `mobile-design`, `mobile-security-coder`, `mobile-developer`, `flutter-expert`,
  `android-dev`, `ios-developer` — merged once in `mobile-security.md`.
- **`expo-ui-jetpack-compose` and `expo-ui-swift-ui`** duplicate the platform-specific halves
  of `expo-ui`; merged into one `@expo/ui` section in `expo.md` (universal → platform-specific
  → drop-in replacements), with `Host` wrapping, `.ios.tsx`/`.android.tsx` isolation, and the
  LazyColumn/RNHostView notes preserved.

## Notable skills dropped / folded (and why)

- **`update-swiftui-apis`** — a maintenance workflow for refreshing `latest-apis.md` via a
  scan manifest + Sosumi MCP + PR. The *content* (deprecated→modern table) is what matters to
  consumers and is fully incorporated into `ios-swiftui.md`; the PR/maintenance choreography is
  project-specific maintenance tooling, not reusable guidance.
- **`mobile-security-coder` vs a "security-auditor" role** — the whole "when to use vs
  security-auditor" preamble is about a different skill that isn't in this library; dropped,
  kept one sentence pointing to formal audits.
- **`add-app-clip`** is kept almost whole but routed under `deployment-store.md` (it is a
  store/shipping feature), with its `references/native-module.md` (JS App Clip detection +
  SKOverlay prompt) summarized in the section rather than copied verbatim.
- **`expo-brownfield` and `expo-api-routes`** folded into `expo.md` sections; the deep
  `brownfield-isolated.md` / `brownfield-integrated.md` step-by-step AAR/XCFramework and
  Podfile procedures were summarized to the decision rules + versioning constraint that matter
  most (full original remains available in the source library).
- **Marketing/fluff** from every skill ("You are an expert mobile developer specializing in…",
  repeated Limitations blocks, `Do not use this skill when` boilerplate) was dropped per the
  dedup rules.

## Scripts carried over

- `scripts/fetch.js` + `scripts/validate.js` + `scripts/package.json` (from
  `expo-cicd-workflows/scripts/`) — ETag-cached schema fetch and AJV validation of EAS workflow
  YAML against the live schema. Genuinely deterministic and reusable.
- `scripts/expo-ui-list-components.js` (from `expo-ui/scripts/list-components.js`, renamed to
  disambiguate) — lists installed `@expo/ui` components/modifiers; small, self-contained
  (requires the `sanitize-filename` npm package; `ajv`/`ajv-formats`/`js-yaml` for the
  validator, via the copied `package.json`).

## Gaps / doubts

- **`mobile-design` references missing files:** it points to `mobile-design-thinking.md`,
  `touch-psychology.md`, `mobile-backend.md`, `platform-ios.md`, etc., which do not exist in
  the source directory. I captured its inline content (MFRI, Fitts' law, unify/diverge matrix,
  hard-ban tables) but could not extract the missing reference files' detail.
- **SwiftUI references read selectively:** `swiftui-expert-skill` has ~25 reference files
  (state-management, latest-apis, performance-patterns read in depth; charts, macOS-specific,
  focus/scroll/text patterns only skimmed by headings). The most widely-applicable content
  (state, API modernization, performance, Liquid Glass) is incorporated; macOS-specific and
  Charts detail is out of scope for a mobile skill and was not carried.
- **Version sensitivity:** much Expo/Apple guidance (SDK 55/56, iOS 26, EAS) is version-pinned;
  SKILL.md and references flag verifying against current docs, per the source skills' own
  limitations.
- **`expo-observe` and `expo-examples`** are thin launcher skills pointing at live docs/CLI;
  their routing and key commands were preserved in `expo.md` rather than reproducing volatile
  command inventories.
