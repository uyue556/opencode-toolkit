# Authentication & Authorization Patterns Reference

> Consolidated implementation guidance for authentication, authorization, secrets management, and mutual TLS.
> Sources: auth-implementation-patterns, mtls-configuration, secrets-management, broken-authentication.

## Table of Contents

- [Authentication Patterns](#authentication-patterns)
- [Authorization (RBAC/ABAC) Patterns](#authorization-rbacabac-patterns)
- [Password & Credential Storage](#password--credential-storage)
- [Session & Token Management](#session--token-management)
- [mTLS Configuration](#mtls-configuration)
- [Secrets Management](#secrets-management)
- [Anti-Patterns Checklist](#anti-patterns-checklist)

---

## Authentication Patterns

- Identify the correct authN layer for the context:
  - **Web app with browser users**: session cookies + OAuth/OIDC for SSO; consider WebAuthn/passkeys for high-value accounts.
  - **API/service-to-service**: API keys (low trust), OAuth 2.0 client credentials, or mTLS (high trust).
  - **SPA/mobile**: OAuth 2.0 Authorization Code + PKCE; never implicit flow.
- Enforce multi-factor authentication for privileged accounts and sensitive operations.
- Implement centralized login: rate limit, account lockout (with CAPTCHA), and unified logging.
- Always verify identity server-side; never trust client-supplied identity claims.

## Authorization (RBAC/ABAC) Patterns

- Apply authorization after authentication on every request, per-object and per-action.
- Prefer **attribute-based** checks where context matters (ownership, tenant, scope, time), not just a role field.
- Centralize the check: a single `authorize(user, action, resource)` helper avoids per-route drift.
- Default deny; fail closed (deny on error).
- Tenant isolation: always filter queries by tenant ID server-side; never rely on client-side filtering.
- Watch for: mass assignment adding `role=admin`; IDOR; missing checks on nested resources; cache poisoning across tenants.

## Password & Credential Storage

- Hash with Argon2id (preferred) or bcrypt (cost ≥ 12) / scrypt; use per-user salt.
- Never store plaintext, reversible encryption, or MD5/SHA1-only hashes.
- Disallow common/leaked passwords (check against breach dictionaries).
- On password change or suspicious activity, revoke active sessions/tokens.

## Session & Token Management

- Server-side sessions: high-entropy random IDs, `Secure`+`HttpOnly` cookies, `SameSite=Lax/Strict`.
- Rotate session ID on login (prevent fixation); invalidate on logout, timeout, and privilege change.
- JWTs: validate `alg` allowlist, `exp`, `nbf`, `aud`, `iss`; short expiry with refresh-token rotation; revoke on logout.
- Never place tokens in URLs; avoid token leakage in logs, referrers, or error messages.
- Set strict idle/absolute session timeouts; re-authenticate for sensitive actions.

## mTLS Configuration

- Use mTLS when identity of both peers matters and is cryptographically bound (service mesh, device auth, APIs).
- Server side:
  - Require a client certificate; verify chain to a private/internal CA (not public CAs).
  - Validate certificate `ExtendedKeyUsage` (clientAuth) and expiry; check revocation (OCSP/CRL) where practical.
  - Pin to exact CN/SPIFFE identity, not just "any cert from CA".
- Client side:
  - Keep private keys in hardware/HSM/secure enclave or with tight file permissions; never in repo/env.
  - Rotate certs before expiry; automate issuance (ACME/SPIFFE) and short-lived certs.
- TLS config: TLS 1.2+ only, disable TLS 1.0/1.1, strong cipher suites, no renegotiation vulns.
- Enforce mTLS at the ingress/proxy layer so app code cannot accidentally skip it.

## Secrets Management

- Never commit secrets to git; use a secrets manager (Vault, cloud KMS, 1Password, Doppler) not `.env` files in repos.
- Rotate secrets on a schedule and immediately on suspected leak/team changes.
- Least privilege for secret access; scope tokens (short-lived, scoped) rather than long-lived master keys.
- Encryption keys: separate key types (data, signing, KEK), store envelope-encrypted, audit usage.
- Detect leaked secrets: scan repos/commits/history and public exposure (e.g., shodan/github dorking).
- For containerized apps, inject secrets via volume/mount or sidecar, not image env/args.

## Anti-Patterns Checklist

- [ ] No plaintext or reversible password storage.
- [ ] No `alg: none` or mixed-algorithm JWT acceptance.
- [ ] No client-supplied identity/authorization decisions.
- [ ] No secrets in code, config files in repos, or image layers.
- [ ] No missing expiry/rotation on tokens, keys, or certs.
- [ ] No shared static credentials across environments (dev==prod).
- [ ] mTLS configured at proxy/ingress and verified end-to-end.
