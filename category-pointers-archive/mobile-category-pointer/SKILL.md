---
name: mobile-category-pointer
description: "Pointer to a library of 30 specialized Mobile skills. Use when working on mobile-related tasks."
risk: none
---

# Mobile Capability Library 🎯

This is a **pointer skill**. The 30 specialized Mobile skills are stored in a hidden vault to keep your startup context minimal.

## Available skills in this category

- **add-app-clip** — Add an iOS App Clip target to an Expo app. Use when the user mentions App Clip, AASA, apple-app-site-association, appclips, smart app banner, or wants to ship a lightweight iOS Clip invoked from a URL alongside their parent app.
- **android-dev** — Production-grade Android app development guide covering native (Kotlin/Java), cross-platform (Flutter, RN, KMM), and hybrid architectures.
- **android-jetpack-compose-expert** — Expert guidance for building modern Android UIs with Jetpack Compose, covering state management, navigation, performance, and Material Design 3.
- **appium-skill** — Generates production-grade Appium mobile automation scripts for Android and iOS in Java, Python, or JavaScript. Supports real device and emulator testing locally and on TestMu AI cloud with 100+ real devices. Use when the user asks to automate mobile apps, test on Android/iOS, write...
- **building-native-ui** — Complete guide for building beautiful apps with Expo Router. Covers fundamentals, styling, components, navigation, animations, patterns, and native tabs.
- **expo-api-routes** — Guidelines for creating API routes in Expo Router with EAS Hosting
- **expo-brownfield** — Integrate Expo and React Native into an existing native iOS or Android app. Use when the user mentions brownfield, embedding React Native in a native app, AAR/XCFramework, or adding Expo to an existing Kotlin/Swift project. Covers both the isolated approach and the integrated approach.
- **expo-cicd-workflows** — Helps understand and write EAS workflow YAML files for Expo projects. Use this skill when the user asks about CI/CD or workflows in an Expo or EAS context, mentions .eas/workflows/, or wants help with EAS build pipelines or deployment automation.
- **expo-deployment** — Deploy Expo apps to production with EAS — build and submit to the iOS App Store, Google Play Store, and TestFlight, configure eas.json build and submit profiles, manage app versions and build numbers, publish App Store metadata and ASO, and deploy web bundles and API routes via EAS...
- **expo-dev-client** — Build Expo app for development
- **expo-examples** — Expo's official example projects — the expo/examples repo of ~70 `with-*` integrations (Stripe, Clerk, Supabase, OpenAI, maps, Reanimated, SQLite, Skia, NativeWind, and more). Use when integrating a third-party library or service into an existing Expo app and you want the canonical,...
- **expo-module** — Guide for creating and writing Expo native modules and views using the Expo Modules API (Swift, Kotlin, TypeScript). Covers module definition DSL, native views, shared objects, config plugins, lifecycle hooks, autolinking, and type system. Use when building or modifying native modules...
- **expo-observe** — Use for anything related to EAS Observe — adding `expo-observe` to an Expo project (AppMetricsRoot/ObserveRoot HOC, markInteractive, the useObserve hook, and the Expo Router / React Navigation integrations for per-route metrics), querying via the EAS CLI (`eas observe:metrics-summary`,...
- **expo-tailwind-setup** — Set up Tailwind CSS v4 in Expo with react-native-css and NativeWind v5 for universal styling
- **expo-ui** — Build native UI with the @expo/ui package: real SwiftUI on iOS and Jetpack Compose on Android rendered from React in an Expo or React Native app. Covers universal cross-platform components (Host, Column, Row, Button, Text, List, and more imported from @expo/ui), drop-in replacements...
- **expo-ui-jetpack-compose** — expo-ui-jetpack-compose
- **expo-ui-swift-ui** — expo-ui-swift-ui
- **flutter-expert** — Master Flutter development with Dart 3, advanced widgets, and multi-platform deployment.
- **ios-debugger-agent** — Debug the current iOS project on a booted simulator with XcodeBuildMCP.
- **ios-developer** — Develop native iOS applications with Swift/SwiftUI. Masters iOS 18, SwiftUI, UIKit integration, Core Data, networking, and App Store optimization.
- **mobile-design** — (Mobile-First · Touch-First · Platform-Respectful)
- **mobile-developer** — Develop React Native, Flutter, or native mobile apps with modern architecture patterns. Masters cross-platform development, native integrations, offline sync, and app store optimization.
- **mobile-security-coder** — Expert in secure mobile coding practices specializing in input validation, WebView security, and mobile-specific security patterns.
- **swiftui-expert-skill** — Use when writing, reviewing, or refactoring SwiftUI code for iOS or macOS, including state management and `@Observable` data flow, view composition and invalidation/performance, lists and `ForEach` identity, environment usage, localization, animations, Liquid Glass adoption, migrating...
- **swiftui-liquid-glass** — Implement or review SwiftUI Liquid Glass APIs with correct fallbacks and modifier order.
- **swiftui-performance-audit** — Audit SwiftUI performance issues from code review and profiling evidence.
- **swiftui-ui-patterns** — Apply proven SwiftUI UI patterns for navigation, sheets, async state, and reusable screens.
- **swiftui-view-refactor** — Refactor SwiftUI views into smaller components with stable, explicit data flow.
- **update-swiftui-apis** — Scan Apple's SwiftUI documentation for deprecated APIs and update the SwiftUI Expert Skill with modern replacements. Use when asked to "update latest APIs", "refresh deprecated SwiftUI APIs", "check for new SwiftUI deprecations", "scan for API changes", or after a new iOS/Xcode...
- **upgrading-expo** — Guidelines for upgrading Expo SDK versions and fixing dependency issues

## How to load a skill

1. Identify the skill name above matching your task.
2. Use `view_file` to read its `SKILL.md` from the vault:
   `/home/administrator/.config/opencode/skill-libraries/mobile/<skill-name>/SKILL.md`
3. Follow those instructions to complete the request.

**Vault path:** `/home/administrator/.config/opencode/skill-libraries/mobile`

> Do not guess best practices — always read from the vault first.

> ⚠️ **Anti-loop guard**: Do NOT invoke skills recursively or check for applicable skills before every response. Each skill should be loaded at most once per user request. If you have already identified and loaded the relevant skill for this task, proceed with execution — do not re-scan for skills.
