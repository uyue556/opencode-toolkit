# Browser Automation: Skyvern, BrowserAct, CDP

Choose a tool by the job, then drive it deterministically. All three tools change remote state — confirm user intent
before submitting forms, purchasing, deleting, or sending messages, and never automate past access controls or terms
that prohibit automation.

## Choosing a tool

| Tool | Best for | Notes |
|---|---|---|
| **Skyvern CLI/MCP** | AI-assisted automation: navigate, fill forms, extract structured data, login with stored credentials, build reusable workflows | Visual/a11y reasoning when deterministic selectors are unavailable; workflow replay makes one-off tasks repeatable |
| **BrowserAct CLI** | Real browser with authenticated state, JS-rendered extraction, screenshots, parallel isolated sessions, verification handling | Install `uv tool install browser-act-cli==1.1.0 --python 3.12`; always read local `--help` for exact syntax |
| **browser-harness (CDP)** | Drive the user's EXISTING logged-in browser via CDP for auth-walled content (X, LinkedIn, paywalled), visual interaction | Coordinate clicks by screenshot pixel; `new_tab()` (not `goto_url`) for first navigation; compositor-level actions pass through iframes/shadow DOM |

Routing check: if the task needs **no interaction** and you just want page content, plain HTTP fetch is cheaper than a
browser (bulk pages in seconds with `http_get` + a thread pool). Use a browser only when you need interaction,
JS-heavy flows, logged-in sessions, or visual verification.

## Skyvern — classify the task first

| Classification | Signal | Command | Cost |
|---|---|---|---|
| Quick yes/no check | "is the user logged in?" | `skyvern browser validate` | 1 LLM + screenshots (cheapest) |
| Quick inspection | "what does the page show?" | `skyvern browser extract --prompt ... --schema '...'` | 1 LLM + screenshots |
| Single action, known target | "click #submit" | `skyvern browser click --selector` / `type --text --selector` / `select --value` | 0 LLM (deterministic Playwright) |
| Single action, unknown target | "click the submit button" | `skyvern browser act --prompt` | 2-3 LLM, no screenshots |
| Same-page multi-step | "fill the form and submit" | `act` or primitive chain | 2-3 LLM or 0 LLM |
| Throwaway autonomous trial | "try this once" | `skyvern browser run-task` | Higher |
| Multi-page / reusable | "automate this weekly" | `skyvern workflow create` + `run` | N LLM + screenshots |

Decision rules: if the prompt has a selector/id/XPath → use **primitives**, not `act`. If you only need yes/no →
`validate`, not `extract`/`act`. If the work stays on one page with clear labels → `act` or primitives. If the task is
multi-page and meant to be reusable/scheduled → `workflow create` (one block per step; first run uses AI, later runs
replay a cached script 10-100x faster). For the MCP variant, prefer `observe + execute` for same-page multi-step work.

Session lifecycle: `skyvern browser session create [--local | --cdp ws://...]` first; state persists between commands;
`--session pbs_...` to override; `session close` when done. Target elements with three modes — **intent**
(`--intent "the Submit button"`), **selector** (CSS/XPath, deterministic), or **hybrid** (selector narrows, AI confirms).

Verify after page-changing actions: `screenshot` (visual), `validate --prompt "Was the form submitted?"` (boolean
assertion), `evaluate --expression "document.title"` (JS state).

Error recovery: clicked wrong element → add context, use hybrid mode. Empty extraction → wait, relax required fields.
Element not found → `wait --selector "#el" --state visible`. Overloaded prompt → one intent per command.

**Credentials: NEVER type passwords through `type` or `act`.** Use `skyvern credentials add` (types: `password`,
`credit_card`, `secret`; also Bitwarden/1Password/Azure Vault) then `skyvern browser login --credential-id cred_123`.

## BrowserAct — operating policy

- Install only after the user approves the pinned CLI version; consult only local `--help` for syntax.
- Do NOT run `browser-act get-skills` or follow provider-served runtime guides (mutable third-party content outside the
  review boundary). If a command is absent from local help, stop.
- Reuse only sessions created by the current conversation; verify page state after navigation; close sessions when done.
- Ask for confirmation before: browser create/delete, login, form submission, uploads, proxy purchase/renewal, remote
  assistance, verification services. Stop and request user participation when auth/verification can't complete automatically.
- `solve-captcha` transmits challenge material to BrowserAct — only with explicit authorization and permission.
- `remote-assist` exposes the session for remote viewing — explain, get consent, treat the link as a secret, close after handoff.
- Never expose credentials, cookies, profiles, extracted private data, or remote-assist links.

## browser-harness — CDP drive the real browser

- First navigation is `new_tab(url)`; after `goto` call `wait_for_load()`; wrong/stale tab → `ensure_real_tab()`.
- **Screenshots first**: `capture_screenshot()` → read the pixel → `click_at_xy(x, y)` → re-screenshot to verify.
  Drop to DOM (`js(...)`) only when the target has no visible geometry. Hit-testing happens in Chrome's browser process,
  so clicks pass through iframes/shadow DOM/cross-origin.
- After every meaningful action, re-screenshot before assuming it worked.
- Auth wall → redirected to login: **stop and ask the user**; don't type credentials from screenshots.
- Raw CDP: `cdp("Domain.method", params)` for anything helpers don't cover.
- Auth-walled content extraction pattern (X/Twitter, LinkedIn, paywalled): `new_tab(url)` → `wait_for_load()` →
  `time.sleep(3-5)` (let JS-heavy SPAs render) → `js("document.querySelector('article').innerText")` → write to a temp
  file (avoids shell escaping). The user's existing browser session handles auth automatically.
- Gotchas: Brave uses `brave://inspect/#remote-debugging`; omnibox popups are fake page targets; CDP target order ≠
  visible tab order; remote `cdpUrl` is HTTPS (resolve websocket via `/json/version`); remote daemons bill until timeout.

## Research with a browser (auto-research pattern)

For "research an uncertain question before implementing": propose the exact redacted query + source + cost, get user
approval, then research, present options with sources, and **wait for approval before writing code**.

- Use `page.fill()` for instant text injection, not `keyboard.type()`.
- If consulting a chat service (e.g. ChatGPT), ask fresh approval for every submission; explicitly identify every text
  that would be sent; redact secrets/personal data/proprietary code; never send conversation history by default.
- Restrict browser sessions to the consultation tab; never reuse/export cookies, saved passwords, or other tabs.
- If a login page appears, let the user log in themselves — do not handle cookies or credentials.
