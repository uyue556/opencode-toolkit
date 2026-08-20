# GCP: Cloud Run & Firebase

Merges `gcp-cloud-run` (containerized + event-driven serverless) and `firebase` (BaaS:
auth, Firestore, functions, storage, hosting).

## Cloud Run

### Principles

- **Cloud Run** for containers (any runtime, multi-endpoint services); **Cloud Run
  Functions** (gen2, formerly Cloud Functions) for simple event handlers.
- Containers must start fast and be stateless; listen on `PORT` (Cloud Run injects it);
  handle `SIGTERM` for graceful shutdown; run as non-root (`USER node`).
- Concurrency default 80 — good for I/O-bound. CPU-bound → lower (1-4). Memory-heavy →
  lower (10) with more RAM. `concurrency = memory_limit / per_request_memory`.
- **Memory includes `/tmp`** — an in-memory filesystem. A 512 MB container downloading a
  200 MB file to `/tmp` leaves ~300 MB for the app. Stream, or use GCS for large files.
- **CPU is throttled to near-zero between requests** unless `--cpu-throttling=false`.
  Background threads, connection-pool maintenance, scheduled jobs and metrics emission all
  break under default throttling → move that work to Cloud Tasks / Pub/Sub / Cloud Scheduler,
  or disable throttling (`--min-instances 1` to avoid idle cost).
- Use a VPC connector only when you must; it adds latency and has a **10-minute idle
  timeout** on connections → `pool_recycle`, `pool_pre_ping` (SQLAlchemy), TCP keep-alive,
  or the Cloud SQL Python connector.

### Deploy

```bash
gcloud run deploy my-service --source . --region us-central1 --allow-unauthenticated \
  --memory 512Mi --cpu 1 --min-instances 1 --max-instances 100 --concurrency 80 --cpu-boost
```

- `--cpu-boost` / `--startup-cpu-boost`: up to ~50% faster cold starts (boost only during
  init).
- `--min-instances 1`: eliminates cold starts for traffic spikes (costs while idle).
- Container must listen within **4 minutes (240 s)** or the revision is killed → lazy-init
  models, start listening immediately + background init with a `/ready` that 503s until
  done, multi-stage builds, and run DB migrations as a separate step (Cloud Run job).
- Distroless base image: smaller pull + attack surface. Multi-stage builds.
- Timeouts must align: request timeout (default 300 s, max 3600 s HTTP / 60 m gRPC), client
  timeout, load balancer timeout. Use webhooks / Cloud Tasks for genuinely long work.
- Gen2 execution environment (gVisor): more syscalls, full `/proc`, **no automatic HTTP→
  HTTPS redirect** (handle `X-Forwarded-Proto`), GPU support (`--gpu=1 --gpu-type=nvidia-l4`).

### Pub/Sub integration

- Push subscription → Cloud Run endpoint: return **200 to ack, 500 to retry**; verify
  `req.body.message` shape; decode base64 data; add a DLQ (`--dead-letter-topic ... --max-
  delivery-attempts 5`).
- Publishing: `topic.publishMessage({data, attributes})`.

### Cloud SQL & secrets

- Connect via Unix socket `/cloudsql/<INSTANCE_CONNECTION_NAME>` with a small pool
  (`max: 5`, `idleTimeoutMillis: 30000`); `--add-cloudsql-instances PROJECT:REGION:INSTANCE`.
- Secrets: `--update-secrets=API_KEY=my-secret:latest` (env var) or
  `--update-secrets=/secrets/api-key=my-secret:latest` (file volume); never hardcode or
  commit service-account JSON. Use Secret Manager API when not mounted.

### Sharp edges

- `/tmp` OOM (see above) · concurrency=1 scaling storms (100 requests → 100 instances) ·
  CPU throttling · VPC connector idle timeout · 4-min startup timeout · gen1/gen2 behavior
  differences · timeout mismatch (504s).
- Validation checks: no hardcoded GCP creds/API keys/credentials JSON in repo; `USER`
  directive; `PORT` env var; no large `/tmp` writes; no sync file ops; beware global
  mutable state / thread-unsafe singletons with concurrency > 1.

## Firebase

Backend-as-a-service: Authentication, Firestore, Realtime DB, Cloud Functions v2, Storage,
Hosting. Key insight: **Firestore is optimized for read-heavy, denormalized data — design
for your query patterns, not relationships.** Reads are cheap until a bad listener makes
them not.

### Tooling

- Client: `firebase` **modular SDK v9+** (tree-shakeable imports — no compat v8).
- Server/Cloud Functions: `firebase-admin` (full access, bypasses security rules) +
  `firebase-functions` **v2**.
- Testing: `@firebase/rules-unit-testing` (rules bugs are security bugs) + `firebase-tools`
  emulator suite.
- Framework bindings: reactfire / vuefire / angularfire.

### Firestore data modeling

- No joins → denormalize aggressively: subcollections (`users/{uid}/posts`), embedded
  author data, arrays for `array-contains` (max 30 for `in`), maps for compound queries,
  booleans for filtering, `serverTimestamp()` fields. Accept that updates cascade (update
  author name → update their posts).

### Security rules (mandatory, last line of defense)

```text
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isSignedIn() { return request.auth != null; }
    function isOwner(uid)  { return request.auth.uid == uid; }
    function isAdmin()     { return request.auth.token.admin == true; }

    match /posts/{postId} {
      allow read:   if resource.data.published == true || isOwner(resource.data.authorId);
      allow create: if isSignedIn() && request.resource.data.authorId == request.auth.uid;
      allow update, delete: if isOwner(resource.data.authorId);
    }
    match /admin/{document=**} { allow read, write: if isAdmin(); }
  }
}
```

### Cloud Functions v2

- `onRequest` (HTTP) — verify bearer ID token before trusting a request.
- `onDocumentCreated('users/{userId}', …)` for side effects (welcome emails, related docs).
- `onSchedule({schedule, timeZone})` for cron cleanup — batch deletes (max 500 ops per
  batch).
- Use **batches** for multi-write atomicity (no reads) and **transactions** for read-then-
  write (counters, like/unlike).

### Auth patterns

- Social login: `signInWithPopup` (desktop/SPA) vs `signInWithRedirect` (mobile/iOS always
  works; fallback on `auth/popup-blocked`). Apple required for iOS.
- Account linking on `auth/account-exists-with-different-credential`:
  `fetchSignInMethodsForEmail` → sign in with existing provider → `linkWithCredential`.
- Persistence: `browserLocalPersistence` (survives close) vs `browserSessionPersistence`.
- Email flow: `sendEmailVerification`, `sendPasswordResetEmail`,
  `reauthenticateWithCredential` before password change.
- Backend calls: `getIdToken` (auto-refresh; force refresh on 401), sync to `__session`
  cookie for SSR via `onIdTokenChanged`, check custom claims (`claims.admin`).
- **Real-time listeners**: `onSnapshot` keeps a persistent connection — always unsubscribe
  on unmount to prevent leaks and runaway read costs.

### When NOT to use Firebase

Relational data → PostgreSQL; full-text search → Algolia/Elastic; complex OAuth →
dedicated auth; email delivery → SendGrid/Resend; heavy containers → Kubernetes/Cloud Run.

## Source

`gcp-cloud-run` (vibeship-spawner-skills), `firebase` (vibeship-spawner-skills).
