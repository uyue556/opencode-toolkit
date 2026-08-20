# Mobile Design & UX

Touch-first, platform-respectful design: feasibility, UX psychology, platform conventions,
anti-patterns, and accessibility. Sources: mobile-design, mobile-developer, ios-developer,
android-dev.

## Table of contents
- [Core law](#core-law)
- [Ask before assuming (required)](#ask-before-assuming-required)
- [Mobile feasibility & risk index (MFRI)](#mobile-feasibility--risk-index-mfri)
- [Touch & UX psychology](#touch--ux-psychology)
- [Platform unify vs diverge](#platform-unify-vs-diverge)
- [AI mobile anti-patterns (hard bans)](#ai-mobile-anti-patterns-hard-bans)
- [Accessibility](#accessibility)
- [Release readiness checklist](#release-readiness-checklist)

## Core law

**Mobile is NOT a small desktop.** Users are distracted, interrupted, and impatient — often one
hand, on a bad network, with low battery. Think constraints first, aesthetics second. Design
for that reality or the app fails quietly.

## Ask before assuming (required)

If any of these are not explicitly stated, ask before proceeding:

| Aspect | Question | Why |
|--------|----------|-----|
| Platform | iOS, Android, or both? | Navigation, gestures, typography differ |
| Framework | RN, Flutter, native? | Performance and patterns |
| Navigation | Tabs, stack, drawer? | Core UX architecture |
| Offline | Must it work offline? | Data & sync strategy |
| Devices | Phone only or tablet too? | Layout & density |
| Audience | Consumer, enterprise, accessibility needs? | Touch & readability |

Never default to a favorite stack or pattern without justification
(see `framework-selection.md`).

## Mobile feasibility & risk index (MFRI)

Before any screen/feature, score 1-5 on five dimensions:
- Platform clarity, Accessibility readiness (additive)
- Interaction complexity, Performance risk, Offline dependence (subtractive)

```
MFRI = (Platform Clarity + Accessibility Readiness) − (Interaction Complexity + Performance Risk + Offline Dependence)
```

Range −10..+10. ≥6 proceed; 3-5 add performance+UX validation; 0-2 simplify; <0 redesign before
implementing. Gate: don't ship below MFRI ≥ 3.

## Touch & UX psychology

- Fitts' law: finger ≠ cursor; accuracy is low; reach matters more than precision.
- Primary CTAs in the **thumb zone**; destructive actions pushed away; **no hover assumptions**.
- Min touch targets: 44pt (iOS), 48dp (Android).
- Provide explicit feedback: loading states, error recovery (retry + message), and success
  confirmation on every action.
- Don't make gestures the only path — always a button/fallback for discoverability.
- Respect platform muscle memory: iOS ≠ Android (back behavior, sheets, pickers).

## Platform unify vs diverge

**UNIFY** (keep identical): business logic, data models, API contracts, validation, error
semantics.
**DIVERGE** (platform-specific): navigation behavior, gestures, icons, typography, pickers,
dialogs, sheet presentation.

| Element | iOS | Android |
|---------|-----|---------|
| Font | SF Pro | Roboto |
| Min touch | 44pt | 48dp |
| Back | Edge swipe | System back |
| Sheets | Bottom sheet | Dialog / sheet |
| Icons | SF Symbols | Material Icons |

## AI mobile anti-patterns (hard bans)

**Performance:** ScrollView for long lists; inline renderItem; index-as-key; JS-thread
animations; console.log in prod; no memoization. (Full table in `mobile-performance.md`.)

**Touch/UX:** touch < 44-48px; gesture-only actions; no loading state; no error recovery;
ignoring platform norms.

**Security:** tokens in AsyncStorage; hardcoded secrets; no SSL pinning; logging sensitive data
(full table in `mobile-security.md`).

## Accessibility

- Every interactive element needs a label: `contentDescription`/`semantics` (Android),
  accessibility label/traits (iOS), semantic annotations (Flutter/RN).
- Dynamic text size (sp / Dynamic Type) — never fixed px text.
- Contrast ≥ 4.5:1 (WCAG AA); reduced-motion support; test TalkBack/VoiceOver per release.
- Keyboard navigation / Switch Control compatibility where applicable.

## Release readiness checklist

- [ ] Touch targets ≥ 44-48px
- [ ] Offline handled (cache-first, retry UI)
- [ ] Secure storage used for tokens
- [ ] Lists virtualized
- [ ] Logs stripped from release
- [ ] Tested on low-end devices
- [ ] Accessibility labels present
- [ ] MFRI ≥ 3
- [ ] Loading/empty/error states on every screen
- [ ] Dark mode + light/dark color adaptation
