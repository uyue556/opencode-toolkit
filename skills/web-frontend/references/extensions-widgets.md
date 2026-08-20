# Browser extensions & in-page widgets

Merged from `web-development/browser-extension-builder` (Manifest V3), the
`front-end/chrome-extension-developer` guidance, and the in-page widget/chat patterns
from `front-end/chat-widget` and `frontend/markstream-*` install snippets.

## Manifest V3 (MV3) essentials

- `manifest.json` fields: `manifest_version: 3`, `name`, `version`,
  `permissions` (least-privilege: `storage`, `activeTab`, host permissions scoped),
  `action` (browser toolbar), `background` → **service worker** (`"background": {
  "service_worker": "background.js" }`), `content_scripts` (matches + `js` + `run_at`),
  `web_accessible_resources` (files you expose to pages), `icons`.
- **Background = event-driven service worker** (MV3): no persistent page; everything
  short-lived, restartable. Persist state in `chrome.storage` (session/local), not globals.
- No remote code: extension content must be bundled; external scripts blocked. Use the
  `declarativeNetRequest` API instead of intercepting requests with `webRequest` blocking.
- Messaging: `chrome.runtime.sendMessage` (popup/background/content), `chrome.tabs.sendMessage`
  (background→tab), ports for long-lived. Validate message shapes; `chrome.runtime.onMessage`
  responses optional.
- Content scripts share a page's DOM but not its JS; use isolated world — wrap globals,
  add `content_script` styles namespaced to avoid clobbering host styles.
- Popup: standard HTML/CSS/JS; keep it small; devMode reload for SW.

## Chrome-specific developer setup

- Manifest + service worker + content script + popup (or side panel); `commands` for
  shortcuts; `contextMenus`; Options page. Ship as unpacked via `chrome://extensions`
  developer mode; test both Chrome and Edge; test permission-gated flows.
- Protect against extension-store "unpublish" churn: prefer your own install page +
  CRX for internal distribution; keep auto-update working (no changing `update_url`).

## In-page chat widget

- Floating launcher button (bottom-right or bottom-left, respects RTL); opens a panel
  (dialog pattern — focus trap + Escape + aria, see `accessibility.md`).
- States: idle → typing → thinking (AI) → answer streaming; error + retry; empty welcome.
- Streaming responses via SSE/WebSocket; cancel on close.
- Config via a global init: `window.MyWidget.init({ apiKey, brand, position })` — namespaced,
  no globals pollution; load script `defer`, initialize on `DOMContentLoaded`/after 3s
  (don't block LCP); guard against double init.
- **Security**: never embed API keys in the client — proxy calls server-side;
  rate-limit; sanitize rendered user content (`security-xss.md`); CSP-friendly.

## Common pitfalls

| Pitfall | Fix |
|---|---|
| Persistent background (MV2 habit) | Event-driven service worker + storage |
| Remote code in extension | Bundle everything, declarativeNetRequest |
| Content script clobbers host | Namespaced ids/classes, isolated world |
| Message shape drift | Shared types + validation |
| Widget blocks page load | defer + async init |
| API key in client widget | Server-side proxy |
