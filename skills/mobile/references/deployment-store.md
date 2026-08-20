# Deployment & App Store

Ship to production: EAS builds and submission, App Store / Play Store, TestFlight, store
metadata & ASO, versioning, App Clip targets, and release strategy. Sources: expo-deployment
(+ ios-app-store / play-store / app-store-metadata references), add-app-clip, expo-dev-client.

## Table of contents
- [EAS build & submit](#eas-build--submit)
- [iOS App Store & TestFlight](#ios-app-store--testflight)
- [Google Play Store](#google-play-store)
- [Store metadata & ASO](#store-metadata--aso)
- [Version management](#version-management)
- [App Clip (iOS)](#app-clip-ios)
- [Release strategy](#release-strategy)

## EAS build & submit

```bash
npm install -g eas-cli && eas login
npx eas-cli@latest init          # creates eas.json

# production builds
npx eas-cli@latest build -p ios --profile production --submit
npx eas-cli@latest build -p android --profile production --submit

# quick iOS TestFlight
npx testflight
```

`eas.json` key fields: `build.production` with `autoIncrement: true`, `resourceClass`
(e.g. `m-medium`); `build.development` with `developmentClient: true`; `submit.production.ios`
(`appleId`, `ascAppId`, or an App Store Connect API key) and `submit.production.android`
(`serviceAccountKeyPath`, `track`). Use App Store Connect **API keys** (`.p8`) for CI to avoid
2FA prompts: configure `ascApiKeyPath`, `ascApiKeyIssuerId`, `ascApiKeyId` (App Manager role
minimum). Web: `npx expo export -p web && npx eas deploy --prod`; API routes ship with the web
bundle.

## iOS App Store & TestFlight

- Prereqs: Apple Developer account, an App Store Connect app record (bundle ID must match
  `app.json`), Apple credentials via `eas credentials -p ios` (distribution cert, provisioning
  profile, ASC API key).
- TestFlight: internal testers (up to 100, immediate) / external (up to 10,000, needs beta
  review); builds expire after 90 days. Submit early and often.
- App Review: verify functionality, HIG compliance, content, privacy declarations, legal.
  Common rejections: crashes, incomplete metadata, placeholder content, missing demo login,
  no privacy policy URL, minimum-functionality (4.2). Expedited review for critical bugs /
  security / time-sensitive events.
- Export compliance: if not using non-exempt encryption, set
  `ios.config.usesNonExemptEncryption: false` to avoid the compliance prompt.
- Troubleshooting: "no suitable application records" → create the app record first; "bundle
  version must be higher" → increment build number (`autoIncrement` handles it); "invalid
  provisioning profile" → `eas credentials -p ios --sync`; stuck "Processing" → can take 5-30
  min.

## Google Play Store

- Set up a Google Play Console service account: create one in Google Cloud, link it to Play
  Console, and configure `submit.production.android.serviceAccountKeyPath` (or base64 env var).
- Tracks: **internal → closed → open → production**; release statuses: draft / inProgress /
  completed / halted.
- Staged rollout: 5% → 20% → 50% → 100% with 24-48h monitoring; **never skip** for significant
  changes.
- Signing: prefer **Google Play App Signing** (upload key + Play-managed signing key); verify
  signing status in Play Console. Version codes must increment per build.

## Store metadata & ASO

Manage App Store presence from code with **EAS Metadata** (`store.config.json`):
`eas metadata:pull` to fetch current config, edit, then `eas metadata:push` (must submit a
binary first for new apps). Apple App Store only (preview).

ASO essentials:
- **Title** (30 chars) — brand first + 1-2 strongest keywords; ~10% ranking boost.
- **Subtitle** (30 chars) — don't duplicate title keywords; highlight the differentiator.
- **Keywords** (100 chars, comma-separated, no spaces) — use all characters; no dupes from
  title/subtitle; singular forms (Apple handles plurals); synonyms; competitor names carefully;
  digits not words; skip articles.
- **Description** (max 4000) — not indexed, but converts; front-load the first 3 lines (visible
  before "more"); bullet features; social proof; CTA; privacy note; update each release.
- **Release notes** target existing users deciding to update. **Promo text** (170 chars, above
  description, updateable without a binary).
- **Localize metadata per market** — research keywords per locale; direct translations miss
  regional search terms. Supported locales include `zh-Hans`, `zh-Hant`.
- Age rating (advisory) descriptors honestly; kids age bands if applicable.
- Release control: `automaticRelease: true|false|timestamp`, `phasedRelease: true` (7-day
  1→100% rollout). Provide review contact + demo credentials.
- Metrics to watch: impressions, product-page views, conversion rate, keyword rankings,
  category ranking. Update metadata every 4-6 weeks.

## Version management

iOS: `version` (`CFBundleShortVersionString`, user-facing) + `buildNumber`
(`CFBundleVersion`, must increment per upload). Android: `versionCode`. With
`appVersionSource: "remote"` and `autoIncrement: true`, EAS manages numbers:
`eas build:version:get` / `eas build:version:set`.

## App Clip (iOS)

Add an iOS App Clip target to an Expo app (lightweight clip launched from a URL on your domain):

1. Set `ios.bundleIdentifier` (`com.<username>.<app-name>`) and `ios.appleTeamId` in app.json.
2. `bun create target clip` — installs `@bacons/apple-targets`, writes `targets/clip/`.
3. Wire associated domains in app.json: `applinks:<domain>` (parent) and `appclips:<domain>`
   (clip), plus the clip's entitlement in `targets/clip/expo-target.config.js`
   (`com.apple.developer.associated-domains: ["appclips:<domain>"]`) — or prebuild warns.
4. `bunx setup-safari` registers bundle IDs, creates the App Store entry, prints the starter
   AASA JSON + Smart App Banner meta tag.
5. Host `https://<domain>/.well-known/apple-app-site-association` (no extension) including an
   `appclips` block with the clip's full app ID `<TeamID>.<ClipBundleID>`; optional
   `webcredentials`/`activitycontinuation`. AASA must be live before iOS trusts it — verify
   with `curl https://<domain>/.well-known/apple-app-site-association`.
6. Add `<meta name="apple-itunes-app" content="app-id=..., app-clip-bundle-id=...,
   app-clip-display=card">` in the HTML shell (`src/app/+html.tsx`).
7. Mirror parent permissions into the clip's Info.plist; set `deploymentTarget: "17.6"`;
   optional `NSAppClip` permission keys.
8. Build + submit both targets with `bunx testflight`; configure clip metadata
   (`apple.appClip` in `store.config.json` — up to 3 invocation URLs, 1800x1200 header PNG),
   then `eas metadata:push`.

## Release strategy

- Always release internal → closed/open testing before production (Android) / TestFlight →
  App Review (iOS).
- Use staged/phased rollouts and monitor crash-free rate, ANR rate, and ratings before
  expanding.
- Keep a documented rollback plan and on-call; monitor Play Console vitals / App Store Connect
  after launch.
- CI/CD: automate with EAS workflows (`references/expo.md`) — e.g. build on tag, submit on
  success, then `eas metadata:push`.
