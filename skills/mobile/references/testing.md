# Mobile Testing & Appium Automation

Testing strategy across the pyramid plus production-grade Appium automation for Android and
iOS (Java/Python/JS, local or real-device cloud). Sources: android-dev, mobile-developer,
appium-skill, ios-developer, flutter-expert.

## Table of contents
- [Testing pyramid](#testing-pyramid)
- [Per-stack tooling](#per-stack-tooling)
- [UI / E2E & device farms](#ui--e2e--device-farms)
- [Appium automation](#appium-automation)

## Testing pyramid

```
        /\   ~10% E2E (Espresso, Maestro, Appium, XCUITest)
       /--\  ~20% Integration (DB, API contract, repository)
      /----\ ~70% Unit (state holders, use cases, mappers)
```

- **Unit (70%):** every ViewModel/state holder, use case, repository, and mapper tested;
  coverage ≥80% on domain + presentation.
- **Integration (20%):** in-memory DB tests (Room), API mocking with `MockWebServer`, repository
  tests verifying cache + remote coordination, API contract tests against staging.
- **UI/E2E (10%):** critical journeys only (login, checkout, core action). Smoke suite on every
  PR; full suite nightly; run on real-device farms before release.
- Test data: factories/builders (never copy-paste objects); hermetic tests (no shared mutable
  state); fakes over mocks for complex dependencies.
- Accessibility testing: TalkBack/VoiceOver labels, dynamic type, contrast — automated where
  possible, manual audit per release.

## Per-stack tooling

| Stack | Unit | UI/E2E |
|-------|------|--------|
| Android | JUnit5 + MockK + Turbine + Kotest | Espresso, Maestro |
| iOS | XCTest + mocks/DI | XCUITest, snapshot tests |
| React Native | Jest + @testing-library/react-native + msw | Detox, Maestro |
| Flutter | `flutter_test` + mocktail | `testWidgets`/golden files, Patrol |

**Maestro** is a pragmatic cross-platform E2E choice that also works for Flutter and RN flows.
Device farms: Firebase Test Lab, BrowserStack, LambdaTest/TestMu. Performance & benchmarking
tests on real devices, not just simulators.

## Appium automation

Appium drives real apps through platform-native automation: `UiAutomator2` (Android),
`XCUITest` (iOS).

### Routing the task

- "cloud" / "TestMu" / "LambdaTest" / "real device farm" → TestMu AI cloud (100+ real devices);
  "emulator"/"simulator"/"local" → local Appium server; specific devices (Pixel 8, iPhone 16)
  → cloud for real coverage; ambiguous → default local emulator, mention cloud.
- Android signals (APK, Play Store, Pixel, Samsung) → `UiAutomator2`; iOS (IPA, App Store,
  iPhone, Swift) → `XCUITest`. Both → separate capability sets per platform.
- Language: default Java (`io.appium:java-client`); Python (`Appium-Python-Client` + pytest);
  JavaScript (WebdriverIO).

### Desired capabilities

```java
UiAutomator2Options options = new UiAutomator2Options()
    .setDeviceName("Pixel 7").setPlatformVersion("13")
    .setApp("/path/to/app.apk").setAutomationName("UiAutomator2")
    .setAppPackage("com.example.app").setAppActivity("com.example.app.MainActivity")
    .setNoReset(true);
AndroidDriver driver = new AndroidDriver(new URL("http://localhost:4723"), options);
```

iOS: `XCUITestOptions` with `setDeviceName`, `setPlatformVersion`, `setApp` (`.ipa`),
`setAutomationName("XCUITest")`, `setBundleId`, `setNoReset(true)`.

### Locator strategy (priority order)

1. `AccessibilityId` — best, cross-platform
2. `ID` (Android `resource-id`)
3. Name/Label (iOS accessibility label) / iOS predicate (`label == 'Login'`) / Android UiAutomator
4. Class name
5. **XPath — last resort: slow, fragile, absolute XPath banned**

### Waits, gestures, structure

- Use explicit `WebDriverWait` (15s+; 30s+ for real devices). **Zero `Thread.sleep()`**.
- Gestures via the W3C `PointerInput`/Actions API (not deprecated `TouchAction`): tap, long
  press, swipe, pinch/zoom.
- `noReset: true` + targeted cleanup instead of `resetApp()` between tests.
- Structure: per-platform `BaseTest` (thread-safe driver via `ThreadLocal`), cross-platform
  page objects (`@AndroidFindBy`/`@iOSXCUITFindBy`), JUnit 5 / TestNG parallel execution.
- WebView/hybrid apps: switch contexts (`driver.context("WEBVIEW_...")`).
- Cloud quick setup: upload the app → get `lt://` URL → set `LT:Options` capabilities
  (`w3c: true`, `isRealMobile: true`, `video`, `network`) → hub URL from `LT_USERNAME`/
  `LT_ACCESS_KEY`. Report pass/fail via `lambda-status` execute script.

### Anti-patterns

`Thread.sleep` → explicit waits; XPath-everything → `AccessibilityId` first; hardcoded
coordinates → element-based actions; same caps for both platforms → separate capability sets;
`driver.resetApp()` between tests → `noReset` + targeted cleanup.

### Validation checklist

1. Correct `automationName` (UiAutomator2/XCUITest). 2. Locators: AccessibilityId first, no
  absolute XPath. 3. Waits: explicit, zero `Thread.sleep`. 4. Gestures via W3C Actions.
  5. `lt://` URL for cloud, local path for emulator. 6. 30s+ timeouts on real devices.
