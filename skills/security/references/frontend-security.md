# Frontend Security & Developer Onboarding Reference

> Consolidated guidance for securing frontend/client-side code and building secure developer onboarding flows (signup, OAuth, API key UX).
> Sources: frontend-security-coder, developer-signup-flow.

## Table of Contents

- [Client-Side Security Rules](#client-side-security-rules)
- [Auth & Session in the Browser](#auth--session-in-the-browser)
- [API Key UX for Developers](#api-key-ux-for-developers)
- [Signup & OAuth Flow](#signup--oauth-flow)
- [Onboarding Hygiene](#onboarding-hygiene)

---

## Client-Side Security Rules

- Everything client-side is attacker-controlled: never enforce authorization, secrets, or business rules in the browser.
- Store no secrets in JS bundles (API keys, tokens); use short-lived, scoped tokens fetched server-side.
- Output-encode and sanitize any user-generated or third-party content rendered client-side (see `web-appsec.md` XSS section).
- Validate schema at the API boundary, not only in the frontend; treat client validation as UX only.
- Audit third-party frontend dependencies for tampering/typosquatting; pin and SRI-subresource integrity where possible.
- Restrict external resource loading via CSP; avoid `eval`/`innerHTML` on untrusted data.

## Auth & Session in the Browser

- Use OAuth 2.0 Authorization Code + PKCE for SPAs; never implicit flow or tokens in `localStorage` when cookies can be used.
- Prefer `HttpOnly`+`Secure`+`SameSite` cookies over localStorage tokens to blunt XSS token theft.
- Handle redirects safely: validate `redirect_uri` against an allowlist; never accept arbitrary return URLs (open redirect).
- Logout must invalidate server-side sessions and clear client storage.

## API Key UX for Developers

- Generate API keys server-side; show the full key **exactly once**, then store only a fingerprint/hash server-side.
- Allow easy regeneration and revocation; display last-used and scopes; make rotation self-service.
- Do not auto-generate keys that are more privileged than needed; default to minimal scopes.
- Keys shown in dashboards must be truncated (masked) with a "reveal/regenerate" pattern.
- Consider key prefixes for identification and per-key rate limits.

## Signup & OAuth Flow

- Use proven OAuth providers where possible; implement Google/GitHub OAuth with state + PKCE, nonce validation, and verified email.
- **OAuth options that work**: Google, GitHub, GitLab, Auth0 — verify provider SDK matches OAuth spec; validate `state` to prevent CSRF login.
- Keep form fields minimal (fewer fields = higher conversion); collect more via progressive profiling later.
- Verify email ownership before issuing credentials where security matters.
- Rate limit signup and login; block disposable-email abuse; guard against account enumeration.

## Onboarding Hygiene

- Progressive profiling: gather extra info only when needed; store only what is necessary (data minimization, see `compliance-audit.md`).
- Personalize onboarding from declared intent, not covert tracking.
- Measure signup conversion but keep analytics minimal and privacy-respecting.
- Ensure the "delete account"/"export data" path exists and works (GDPR right to erasure/portability).
