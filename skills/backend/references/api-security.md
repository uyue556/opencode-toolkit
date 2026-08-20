# API Security

Security is not a one-time task. Audit APIs regularly, keep dependencies
updated, and design auth/validation/rate-limiting into the API from the start.

## Authentication

Choose the method by context:

| Context | Method |
| ------- | ------ |
| User-facing apps / SPA | JWT bearer token (access + refresh) |
| Server-to-server | API key in header (`X-API-Key`) |
| Social / enterprise login | OAuth 2.0 + OIDC |
| Service-to-service (microservices) | mTLS or signed requests |

### JWT best practices

- Use strong secrets (256-bit minimum, from env/config, never in code).
- Short access token expiry (~1h); refresh tokens long-lived but **stored in DB**
  so they can be revoked and rotated.
- Validate issuer and audience on verify.
- Don't store sensitive data in the JWT payload — JWTs are signed, not encrypted.
- Implement token blacklisting/revocation for logout.
- Verify the `Authorization: Bearer <token>` header format.

### OAuth 2.0 essentials

- Use PKCE for public clients (SPA/mobile).
- Validate scopes; never trust client-provided scopes.
- Prefer short-lived access tokens + refresh token rotation.

## Authorization (not just authentication)

- **RBAC**: role → permissions. `ADMIN`, `MODERATOR`, `USER`.
- **Object-level**: always check the resource owner. A user must not delete a
  post they don't own (`post.userId !== req.user.userId && role !== 'admin'`).
- **Field-level** (GraphQL): protect private fields per resolver.
- 401 = not authenticated; 403 = authenticated but not allowed.

## Input validation & injection prevention

- Validate **all** external input: request bodies, query params, path params,
  webhook payloads. Use a schema validator (Zod/Pydantic/class-validator).
- Use parameterized queries or an ORM — never string-concatenate SQL.
- Validate data types, ranges, lengths; allowlist allowed values.
- Sanitize HTML/HTML-ish content (e.g. comment bodies) to prevent XSS.
- Validate file uploads (type, size, content).
- **SSRF**: validate and allowlist outbound URLs; block internal addresses.
- Don't trust third-party API responses — validate their shape too.

## Rate limiting & DDoS

- Per-user/IP rate limits with `windowMs` + `max`; stricter on auth endpoints
  (e.g. 5 login attempts / 15 min) and expensive operations.
- Use a distributed store (Redis) for multi-instance deployments.
- Return rate-limit headers: `X-RateLimit-Limit`, `X-RateLimit-Remaining`,
  `X-RateLimit-Reset`, and `Retry-After` on 429.
- Tiered limits by user plan (free/pro/enterprise) when applicable.

## Headers, cookies, transport

- HTTPS/TLS everywhere; HSTS preload.
- Security headers (Helmet/secureHeaders): CSP, `X-Content-Type-Options`,
  `X-Frame-Options`, hide `X-Powered-By`.
- Cookies: `HttpOnly`, `Secure`, `SameSite`; CSRF tokens for cookie-based auth;
  validate `Origin`/`Referer` on state-changing requests.
- Configure CORS strictly — allow only trusted origins, handle credentials
  explicitly. Don't disable CORS entirely.
- Don't log sensitive data (passwords, tokens, card numbers); sanitize logs.

## Error handling

- Never leak stack traces or internal DB details in responses.
- Map known errors to status codes; return a generic message for 500s.
- Log full error server-side with a correlation/request ID.
- Fail closed: deny access when auth state is ambiguous.

## OWASP API Security Top 10 (2023)

1. Broken Object Level Authorization — verify user can access the object.
2. Broken Authentication — strong auth, token expiry, session invalidation.
3. Broken Object Property Level Authorization — limit which properties a user
   can set/read.
4. Unrestricted Resource Consumption — rate limits, quotas, payload caps.
5. Broken Function Level Authorization — check role per function.
6. Unrestricted Access to Sensitive Business Flows — protect critical flows.
7. Server-Side Request Forgery (SSRF) — validate/allowlist outbound URLs.
8. Security Misconfiguration — headers, defaults, verbose errors.
9. Improper Inventory Management — document and secure all endpoints.
10. Unsafe Consumption of APIs — validate data from third-party APIs.

## Security testing & API fuzzing (bug bounty mindset)

- **Recon**: look for `/swagger`, `/openapi.json`, `/docs`, old paths, hidden
  params; enumerate resources and their CRUD endpoints.
- **Auth testing**: try alternate login paths, test rate limiting on auth
  endpoints, compare web vs mobile API surfaces (different controls).
- **IDOR**: swap IDs (numeric for email-based, `/me/orders` vs `/user/654321/orders`),
  array-wrapping, duplicate keys, wildcards, parameter pollution.
- **Injection**: SQL/NoSQL/command injection into params and headers.
- **Method testing**: switch GET↔POST↔PATCH, try DELETE/PUT on unexpected
  resources, look for missing method restrictions.
- **GraphQL-specific**: introspection disclosure, IDOR through nested queries,
  batch requests to bypass rate limits, deep nested queries for DoS, XSS via
  field names.
- **Endpoints bypass**: try alternate hosts, `X-Forwarded-For` spoofing,
  unauthenticated variants of protected endpoints.
- Report only verified findings with severity matching impact; don't manufacture
  issues to appear thorough.

## Sources

- `api-security-best-practices`, `backend-security-coder`,
  `api-fuzzing-bug-bounty`, `api-patterns` (auth & rate-limiting sections),
  `api-and-interface-design`.