# Frontend security (XSS & injection)

Merged from `web-development/frontend-mobile-security-xss-scan` (scan patterns for
injection surfaces) plus security rules across the React/Vue/Svelte/Angular refs.

## Threat model (client-side)

Most client-side risk is **XSS** (stored/reflected/DOM-based) and **data exposure**
(tokens, keys, PII in bundles/logs). OWASP guidance applies; below is the frontend slice.

## XSS rules by framework

- **Never inject unescaped HTML from user/API data.**
  - React: avoid `dangerouslySetInnerHTML`; if unavoidable, sanitize first
    (DOMPurify) and never pass user-controlled data into it.
  - Vue/Svelte: avoid `v-html` / `{@html ...}`; sanitize if required.
  - Angular: `innerHTML` bypass via `DomSanitizer`; prefer interpolation (auto-escaped).
- Escape at the boundary: URL values in `href`, attribute values, event handlers,
  `style` from user input. Framework escaping (React/Vue/Angular text interpolation)
  handles text nodes — but attribute/URL contexts need care.
- `javascript:` URLs: block/validate (`new URL(href).protocol === 'http:'`) for links
  built from user input.
- JSON in `<script>`: escape `<`, `>` and `&` (or use `</script>`-safe serialization) to
  prevent script-tag breakout.
- `postMessage` handlers: validate `event.origin` against your allowlist; never trust data.

## Scan & audit patterns

Audit the codebase for injection surfaces:

- `dangerouslySetInnerHTML`, `v-html`, `innerHTML`, `outerHTML`, `insertAdjacentHTML`,
  `document.write`, `eval`/`new Function`, `javascript:` in hrefs.
- Dynamic component lookup from strings (`<component :is="userInput">`, dynamic `import()`
  of user-controlled paths) — blocklist the sources.
- `location.href`/`location.assign` with unvalidated input (open redirect + XSS).
- Persisted user content rendered anywhere (comments, names, rich text) — sanitize on
  render AND on write; prefer rendering as text.

## Secrets & data exposure

- **Never** hardcode API keys/tokens in client code or commit `.env`. Env vars used in the
  client are visible in the bundle — move sensitive calls server-side (proxy).
- No tokens in URLs (query/hash) or logs; short-lived, scoped tokens; rotate on leak.
- Careful with client-side storage: `localStorage`/`sessionStorage` are readable by any
  script (XSS risk) — prefer httpOnly cookies for auth; don't store PII in plaintext.
- Strip PII before sending to analytics; redact errors before reporting.
- CSP: set a strict `Content-Script-Src` (`'self'`), `default-src 'self'`, no unsafe-inline
  for scripts where feasible; report violations to your monitoring.

## Dependency & supply chain

- Pin dependencies + run `npm audit`/`pnpm audit` in CI; fail on high/critical.
- Avoid outdated frameworks/browser APIs (no `document.write`); keep lockfile current.
- Audit third-party scripts in the page — each one can read the DOM (see `performance.md`).

## Checklist

- [ ] No user input reaches HTML-injection sinks unsanitized.
- [ ] No secrets in client bundle or commits; `.env` gitignored.
- [ ] `javascript:` URLs blocked; postMessage origins validated.
- [ ] CSP present (or plan documented); no `unsafe-inline` script.
- [ ] `npm audit` clean for high/critical.
- [ ] Sanitizers (DOMPurify) used at every HTML-rendering boundary.
