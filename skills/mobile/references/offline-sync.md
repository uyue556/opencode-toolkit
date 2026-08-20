# Offline-First Data & Sync

Patterns for offline-capable mobile apps: cache-first reads, local persistence, background
sync, conflict resolution, and error resilience. Sources: android-dev, mobile-developer,
mobile-security-coder, mobile-design.

## Core principle

Cache-first: show stale data immediately, fetch fresh in the background, and reconcile.
Mobile users are on unreliable networks with limited battery — degrade gracefully, never hard-fail
on a transient network error.

## Architecture

- Local store is the **single source of truth**: Room (Android), SwiftData/Core Data (iOS),
  Drift/Hive (Flutter), MMKV/SQLite/expo-sqlite (RN/Expo).
- Repository pattern: repositories coordinate remote + local and expose a unified API to
  state holders.
- Read path: try local → render → refresh in background → update local → re-render. Write
  path: write local first (optimistic UI), enqueue for sync, reconcile.

## Storage selection

| Need | Option |
|------|--------|
| Relational, typed, reactive | Room, SwiftData/Core Data, Drift, SQLite |
| Simple key-value | DataStore (Android), UserDefaults (iOS), MMKV, expo-sqlite/localStorage |
| Secure secrets | Android Keystore / EncryptedSharedPreferences, iOS Keychain, flutter_secure_storage, expo-secure-store — never AsyncStorage/plain UserDefaults |
| Large blobs / documents | Filesystem + metadata index |

## Sync strategies

- **Delta sync:** track a cursor/watermark (e.g. `updated_at` > last sync); fetch only changes.
- **Background sync:** Android → WorkManager with constraints (network, charging, not low
  battery); iOS → BGAppRefreshTask/background URLSession; RN → react-native-background-fetch /
  EAS background; Flutter → workmanager package.
- Expose connectivity state (`ConnectivityManager`, `NWPathMonitor`, reachability libs) and
  reflect it in the UI (banner, queued-changes indicator, retry affordances).
- Retry with exponential backoff; never an unbounded retry loop that drains battery.

## Conflict resolution

- Last-write-wins with timestamps is the pragmatic default; only add richer strategies when
  needed:
  - **Field-level merge:** keep newer value per field.
  - **Operational transforms (OT) / CRDTs** for collaborative, concurrent editing (chat,
    rich docs).
  - **Server-authoritative + client replay:** server resolves conflicts; client re-applies.
- Store sync metadata (dirty flags, base version, tombstone records) alongside data.
- Torn-device / multi-device: CloudKit, Firebase, or your backend as the coordination hub.

## Error resilience

- Classify errors: network → retry UI + backoff; auth (401/403) → refresh token → re-request →
  logout; validation → inline field errors; parse → cached/default state; unexpected →
  top-level catch + report.
- Never let an exception surface as a crash or silent blank screen. Show loading / empty /
  error states on every screen.
- Queue writes offline; surface "pending sync" state so the user isn't surprised.
- Cache expiry: stale data is fine, but mark freshness (e.g. "last updated 2m ago").

## Security note

Offline caches of sensitive data need the same protection as network data: encrypt at rest
where appropriate, exclude sensitive files from backups when required, and never persist tokens
outside secure storage (see `mobile-security.md`).
