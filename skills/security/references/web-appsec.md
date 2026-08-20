# Web Application Security Reference

> Consolidated testing and defense guidance for common web vulnerabilities.
> Covers: SQL injection, XSS/HTML injection, IDOR, path traversal, file uploads, broken authentication, and constant-time/timing issues.
> Use during code review, pentest, and audit tasks on web applications.

## Table of Contents

- [SQL Injection](#sql-injection)
- [Cross-Site Scripting (XSS) & HTML Injection](#cross-site-scripting-xss--html-injection)
- [Insecure Direct Object Reference (IDOR)](#insecure-direct-object-reference-idor)
- [Path Traversal / File Disclosure](#path-traversal--file-disclosure)
- [File Upload](#file-upload)
- [Broken Authentication & Session Management](#broken-authentication--session-management)
- [Timing / Constant-Time Analysis](#timing--constant-time-analysis)
- [Testing Checklist](#testing-checklist)

---

## SQL Injection

### What to Look For
- String concatenation into SQL queries (SQLi).
- String concatenation into other query languages (NoSQL, LDAP, XPath, command execution).
- ORM query-builder misuse: raw queries, `whereRaw`, dynamic `where`, interpolated params.

### Testing Approach
1. Identify all data entry points (params, headers, cookies, JSON bodies) that reach queries.
2. Insert benign probes first: `'`, `"`, `%27`, backtick. Observe error output or behavioral change.
3. Determine injectable parameter type:
   - **Error-based**: DB error message reveals syntax break (`You have an error in your SQL syntax`).
   - **Boolean-based**: `AND 1=1` vs `AND 1=2` changes response.
   - **Time-based**: `;WAITFOR DELAY '0:0:5'--` (MSSQL), `SLEEP(5)` (MySQL), `pg_sleep(5)` (Postgres).
   - **UNION-based**: determine column count with `ORDER BY n` increments, then `UNION SELECT NULL,...`.
4. Confirm and document the exact impact: data exfiltration, auth bypass (`' OR '1'='1`), or file read/write.

### Common Bypass Payloads
- Whitespace/comment obfuscation: `/**/`, tab/newline, `%09`, `--+`, `#`.
- Case mixing: `SeLeCt`.
- No-comment termination: `' OR '1'='1`.
- Second-order injection: stored payload executed at a later sink.

### Defenses
- **Always use parameterized queries / prepared statements.** Never interpolate user input.
- ORM: use bound parameters or the ORM's parameter API; do not pass raw user strings to `whereRaw`/`Query` without parameter binding.
- Use least-privilege DB accounts; never connect as `sa`/`root`/owner.
- Validate/whitelist input type at the edge; escaping alone is insufficient and framework-specific.
- Test: any new query path must include a SQLi regression check.

---

## Cross-Site Scripting (XSS) & HTML Injection

### Types
- **Reflected**: input echoed in response without sanitization (query params, search).
- **Stored**: input persisted and rendered later to other users (comments, profile fields, uploads).
- **DOM-based**: sinks like `innerHTML`, `document.write`, `eval`, `location` (XSS via JS, not server response).

### Testing Approach
1. Inject neutral markers: `"><svg/onload=alert(1)>`, `<img src=x onerror=alert(1)>`, `'"><script>alert(1)</script>`.
2. Determine output context:
   - **HTML body**: encode `<>&"'`.
   - **HTML attribute**: encode quotes; watch for `href="javascript:..."`.
   - **JS context**: escape `</script>`, backticks, `${}`.
   - **URL context**: block `javascript:`, `data:` (except images), `vbscript:`.
3. Try encoding bypasses: `&#x3c;`, `%3C`, double-encoding, Unicode, HTML entities in attributes.
4. For DOM XSS, trace untrusted data to sinks in client-side JS (check bundles/minified code).

### Defenses
- Context-aware output encoding at the point of rendering (framework autoescaping + explicit filters for non-HTML contexts).
- Use a strict **Content-Security-Policy** (`default-src 'self'`, no unsafe-inline/unsafe-eval) as defense-in-depth.
- Sanitize rich text with an allowlist library (DOMPurify) server- and client-side.
- Set `X-Content-Type-Options: nosniff` and correct `Content-Type` on responses.
- For uploads served back to users, serve with `Content-Disposition: attachment` or from an isolated domain.

---

## Insecure Direct Object Reference (IDOR)

### What to Look For
- Endpoints using user-supplied object IDs without ownership/authorization checks.
- Predictable IDs (sequential integers, uuidsv1) that reveal other users' resources.
- Horizontal access (other users) and vertical access (higher privilege) both count.

### Testing Approach
1. Map every object-referencing endpoint (users, orders, files, messages, settings).
2. Create two accounts A and B. Use A's token to access B's objects (swap IDs, GUIDs, list endpoints).
3. Try mass enumeration: `GET /api/orders?userId=other`, `POST /api/upload` to another user's folder.
4. Check nested objects: even if parent is authorized, child resources may not be.

### Defenses
- **Never trust client-supplied IDs for authorization.** Load the object, then verify `object.ownerId == session.userId` (or role) server-side.
- Use signed/opaque identifiers (tokens) instead of sequential IDs where possible.
- Enforce authorization centrally (e.g., a single `canAccess(user, resource)` check) to avoid per-route drift.

---

## Path Traversal / File Disclosure

### Testing Approach
- Probes: `../../../../etc/passwd`, URL-encoded `..%2f`, double-encoded `%252e%252e`, Windows `..\..\`, absolute `/etc/passwd`, `....//` (filter bypass).
- Target any file-read feature: downloads, static file serving, archive extraction, log viewers, template includes.
- If traversal works, test for write paths (upload + overwrite) and RCE via writable files.

### Defenses
- Never join user input directly into filesystem paths.
- Resolve then validate: `realpath()`/`resolve()` and confirm result is inside a configured allowlisted root.
- Serve files via a dedicated handler with a whitelist of permitted names/hashes, not user-supplied filenames.
- Prevent `zip-slip` in archive extraction by rejecting entries with `..` or absolute paths.

---

## File Upload

### Vulnerabilities
- Malicious content stored and served as HTML/JS (stored XSS via upload).
- Executable files (`.php`, `.jsp`, `.asp`) executed on the server (RCE).
- Upload-overwrite of existing files.
- MIME/magic-bytes mismatch bypassing extension filters.
- Filename traversal (`../../shell.php`), null bytes, double extensions (`shell.php.jpg`).

### Testing Approach
1. Test extension allow/deny list bypasses: `.php5`, `.pht`, `.PhP`, double ext, trailing dots/spaces, null byte `%00`.
2. Test MIME mismatch: file renamed with safe extension but malicious content sniffed by downstream.
3. Upload a polyglot (e.g., valid image with appended JS) and check rendering context.
4. Check where files are stored/served: same origin, web root, CDN, object storage.

### Defenses
- **Never execute uploaded content.** Store outside web root or in object storage; serve through a handler with fixed MIME types.
- Validate extension against an **allowlist** (case-insensitive), validate magic bytes, enforce max size.
- Generate random filenames; do not honor client filenames for storage paths.
- Serve user content with `Content-Disposition: attachment` unless it is a safe media type; consider a separate upload domain to avoid same-origin cookie leakage.
- Scan uploads for known malware signatures where feasible.

---

## Broken Authentication & Session Management

### Vulnerabilities
- No/weak password policy; credential stuffing exposed by lack of rate limiting.
- Predictable session tokens; session not invalidated on logout/password change.
- Session fixation (app accepts arbitrary session IDs).
- Password reset flows: tokens in URLs, long-lived tokens, no expiry, account enumeration.
- Weak MFA (no rate limit on OTP, resend bypass, response confusion).
- Token in URL/logs/referrer; JWT without expiry or with weak secret.

### Testing Approach
1. Check session token entropy and lifecycle: logout, idle timeout, concurrent sessions, password-change invalidation.
2. Test reset flow end-to-end: token generation, delivery, expiry, reuse, enumeration of valid accounts.
3. Verify MFA: brute-force OTP, reuse OTP, bypass by resending to attacker-controlled channel.
4. Check JWT: algorithm confusion (`alg=none`, HS256/RS256 mix), weak secret cracking, no `exp`/`aud`.

### Defenses
- Server-side sessions with high-entropy random IDs; rotate on privilege change; invalidate on logout/timeout.
- Enforce rate limiting and lockout (with CAPTCHA) on login, OTP, and reset endpoints.
- Password reset: short-lived single-use tokens delivered out-of-band, never in URL; require re-auth for sensitive actions.
- JWT: use strong asymmetric signing, validate `alg` allowlist, `exp`/`iat`/`aud`/`iss`, keep tokens short-lived with refresh rotation.
- Store passwords with Argon2id (or bcrypt/scrypt); never reversible hashes.

---

## Timing / Constant-Time Analysis

### What to Look For
- Secrets compared with non-constant-time functions (`==`, `equals`) enabling timing side-channels.
- HMAC/signature verification not using `crypto.timingSafeEqual`/`MessageDigest.isEqual`.
- Token/PIN comparison in plain loop with early exit.
- Timing differences revealing user existence, password length, or valid entries.

### Defenses
- Compare secrets/HMACs with constant-time comparison primitives of the platform.
- Rate-limit verification attempts so timing cannot be exploited practically.
- Consider hashing the compared value (e.g., compare hashes of tokens) to blunt per-character timing signal.

---

## Testing Checklist

- [ ] All entry points mapped (params, headers, cookies, JSON, file uploads).
- [ ] Parameterized queries used for every DB/query sink; no raw interpolation.
- [ ] Output encoding matches each rendering context (HTML/attr/JS/URL).
- [ ] CSP set; no `unsafe-inline`/`unsafe-eval` without justification.
- [ ] IDOR/authorization checks on every object endpoint (horizontal and vertical).
- [ ] File reads resolve inside allowlisted roots; uploads never executed or served as active content.
- [ ] Sessions invalidated properly; reset/MFA flows rate-limited and non-enumerable.
- [ ] Secrets compared in constant time.
