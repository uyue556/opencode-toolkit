# Progressive Web Apps

Merged from `front-end/progressive-web-app` (manifest + service worker + HTTPS pillars,
Workbox) and the PWA checks in `front-end/web-performance-optimization`.

## The three pillars

1. **HTTPS** — required for service workers on production. Local dev (`localhost`) is fine.
2. **Web App Manifest** — installable experience.
3. **Service worker** — offline, caching, background sync, push.

If any pillar is missing, the PWA isn't installable/offline-capable.

## Manifest

```json
{
  "name": "App",
  "short_name": "App",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#5b21b6",
  "description": "...",
  "icons": [
    { "src": "/icons/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/icons/icon-512.png", "sizes": "512x512", "type": "image/png" }
  ]
}
```
Link it in the head: `<link rel="manifest" href="/manifest.webmanifest">`. Provide
192px + 512px icons (maskable variant for Android). `screenshots` for richer install
prompt on some platforms. Keep `theme_color` in sync with your `<meta name="theme-color">`.

## Service worker (Workbox recommended)

```js
// sw.js (Workbox 7)
import { precacheAndRoute, cleanupOutdatedCaches } from "workbox-precaching";
import { registerRoute } from "workbox-routing";
import { CacheFirst, NetworkFirst, StaleWhileRevalidate } from "workbox-strategies";
import { ExpirationPlugin } from "workbox-expiration";
import { CacheableResponsePlugin } from "workbox-cacheable-response";

cleanupOutdatedCaches();
precacheAndRoute(self.__WB_MANIFEST); // injected list of hashed assets

registerRoute(
  ({ request }) => request.destination === "image",
  new CacheFirst({ cacheName: "images", plugins: [
    new ExpirationPlugin({ maxEntries: 60, maxAgeSeconds: 30 * 24 * 3600 }),
    new CacheableResponsePlugin({ statuses: [0, 200] }),
  ]})
);
registerRoute(
  ({ request }) => request.destination === "style" || request.destination === "script" || request.destination === "font",
  new StaleWhileRevalidate() // always fast, refresh in background
);
registerRoute(
  ({ request }) => request.mode === "navigate",
  new NetworkFirst({ cacheName: "pages", networkTimeoutSeconds: 3 }) // fallback to cached or index
);
```

### Strategy cheat sheet

| Resource | Strategy |
|---|---|
| App shell / routes | Precached (hashed) |
| HTML navigations | NetworkFirst (fallback cached/index for offline) |
| Images | CacheFirst + expiration |
| CSS/JS/fonts | StaleWhileRevalidate or CacheFirst |
| API data | NetworkFirst with stale fallback, or SWR |

- **Cache-busting is critical**: hash asset URLs; precache only hashed files; purge old
  caches on `activate` (`cleanupOutdatedCaches`). Force `skipWaiting`+claim carefully —
  better to let the update take effect on next load to avoid the double-tab bug.
- Version constant (`CACHE_VERSION`) for your own caches; bump on releases.
- Register in the app entry: `if ("serviceWorker" in navigator) navigator.serviceWorker.register("/sw.js")`.

## Offline UX

- Offline fallback page/route (cached "app offline" HTML + CTA: retry, go home).
- Tell the user they're offline (online/offline event listeners) and mark cached content.
- Pending mutations: queue in IndexedDB / `navigator.onLine` + retry on reconnect; or
  Background Sync API. Show "queued" state; never silently drop.

## Installability

- Criteria: HTTPS, manifest (name, icons, start_url, display), registered SW with a
  fetch handler. Test in DevTools → Application → Manifest / Service Workers.
- `beforeinstallprompt` (Chromium): capture, defer, show a custom prompt; respect
  `appinstalled`. iOS: skip Safari install affordance notes.

## Push

- Web push: browser push + service worker push event → showNotification. Requires a push
  service (VAPID keys); do it server-side. Test notifications on a real device.

## Testing checklist

- [ ] Works fully offline (DevTools → offline / airplane mode) — shell + navigation fallback.
- [ ] No missing assets / 404s in SW console; caches cleaned on install of new version.
- [ ] Install prompt appears (Chromium criteria met); icons correct (maskable).
- [ ] Update flow: new version publishes, tab updates cleanly without double-tab.
- [ ] Analytics/sends still work offline (queued).
- [ ] Lighthouse PWA/link checks green (installable, service worker, HTTPS).