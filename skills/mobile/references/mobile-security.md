# Mobile Security

Secure mobile coding: input validation, storage, WebView security, authentication, network
protection, and code hardening. Sources: mobile-security-coder, mobile-design, mobile-developer,
ios-developer, flutter-expert, android-dev.

## Table of contents
- [Storage & secrets](#storage--secrets)
- [WebView security](#webview-security)
- [Network & HTTPS](#network--https)
- [Authentication & session](#authentication--session)
- [Platform-specific hardening](#platform-specific-hardening)
- [Deep links & data leakage](#deep-links--data-leakage)
- [Privacy & compliance](#privacy--compliance)

## Storage & secrets

- Tokens, keys, and credentials go in platform secure storage only: iOS **Keychain** /
  expo-secure-store, Android **Keystore** / EncryptedSharedPreferences, Flutter
  `flutter_secure_storage`. **Never** AsyncStorage, UserDefaults/SharedPreferences, or plain
  files.
- Don't hardcode secrets in source — env/CI secrets + secure storage at runtime.
- Sensitive caches: encrypt where appropriate, exclude from backups (iOS excludes file flags,
  Android backup rules), clean temporary files.
- Memory: don't hold secrets longer than needed; avoid logging or mirroring secrets into
  debug state.

## WebView security

- **Disable JavaScript by default**; enable only for trusted, allowlisted domains with a CSP
  (`script-src`, no `unsafe-inline`).
- Enforce HTTPS + URL allowlisting; restrict local file access and asset loading; sandbox.
- Manage cookies and sessions carefully; clear WebView cache/cookies and temp files on
  logout/cleanup.
- Avoid exposing a JS bridge to untrusted content (universal XSS); validate every message
  crossing the bridge.

## Network & HTTPS

- HTTPS-only (enforce with ATS exceptions only when necessary, and document them; Android
  Network Security Config).
- **Certificate pinning** for critical APIs; validate the full chain, reject self-signed in
  production.
- HSTS and no-downgrade; secure network error messages (don't leak internals to users).
- Guard against MITM/proxy tampering; detect and react to untrusted environments.

## Authentication & session

- Biometrics: Touch ID / Face ID / fingerprint via platform APIs (LocalAuthentication,
  BiometricPrompt, `local_auth`) with secure fallback mechanisms (PIN/password) — never a
  security-only biometric path that can't fall back.
- OAuth mobile flows: use **PKCE**; handle deep-link callbacks securely (validate state/params).
- JWT: secure token storage, refresh flow, and validation (expiry, signature).
- Session lifecycle: lock/timeout on background; clear in-memory state on logout; device
  binding / root & jailbreak detection where appropriate — degrade gracefully, don't brick
  legitimate users.

## Platform-specific hardening

- **iOS:** Keychain, ATS, data protection classes, App Transport Security, privacy manifests,
  App Tracking Transparency. `PasteButton` over programmatic clipboard (avoids paste prompts).
- **Android:** Android Keystore, Network Security Config, runtime permission hygiene (only
  what you need, at the time you need it), ProGuard/R8 obfuscation + resource shrinking,
  debuggable=false in release.
- **Cross-platform:** secure the RN bridge / Flutter platform channels (validate message
  shapes/types); validate native-module input; keep native code memory-safe.
- Code protection: R8/ProGuard (Android), symbol stripping (iOS); RASP/integrity checks and
  debugger detection only where the threat model justifies them; strip debug artifacts from
  release builds.

## Deep links & data leakage

- Deep links / intent filters / URL schemes: validate scheme, host, and parameters; sanitize
  input before use; never treat a deep-link payload as trusted.
- Logs: mask emails, phones, tokens; no PII; no sensitive payloads (crash reports included).
- Screen capture/recording prevention only when required by the threat model (banking);
  keyboard suggestions off for sensitive fields.

## Privacy & compliance

- Data minimization + consent management (GDPR/CCPA); location at needed precision; PII
  protection with access logging and deletion support.
- Third-party SDKs: assess what they collect and share; provide analytics opt-out;
  privacy-preserving analytics (anonymization).
- Store compliance: privacy nutrition labels / data disclosures must match actual behavior —
  reviewers check this (see `deployment-store.md`).

## Approach

Assess the threat model first (what data, who attacks, platform constraints). Then: validate
all inputs → configure WebView/network → secure storage → authentication → harden → verify with
SAST/dependency scans + penetration testing where the app's sensitivity warrants it. Secure
coding here is hands-on; for a formal audit or compliance assessment, treat this as input, not
the audit itself.
