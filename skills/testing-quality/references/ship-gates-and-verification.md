# Ship Gates & Verification

Gates that run before/after a production deploy and discipline for accepting an
agent's "done / shipped / fixed" claim. Merged from: `pre-ship-gate`,
`dos-verify-done-claims`.

## The core idea

"Deploy command exited 0" and "the new version is serving traffic" are two different
facts — agents routinely confuse them. Most bad deploys fail silently: the pipeline
goes green, the CLI prints "deployed", and the old or broken version is still what
users hit. Gate the deploy, then verify the *live* system.

## When to use

- Before any command that pushes to a production or staging environment.
- When an agent is about to report "shipped", "deployed", or "live".
- When a deploy reported success but users still see old behavior.
- When a release involves DB migrations, feature flags, or staged rollout.
- When an agent claims a task/phase/feature is "done"/"fixed" and you want it
  confirmed from evidence before building on it.

## Pre-ship gate — three phases

### Phase 1: Pre-flight (before the deploy)

Walk the silent-failure catalog. Confirm or flag each; never assume.

- **Migrations:** are schema migrations part of the release, and will they run
  against the target BEFORE new code serves traffic? Code expecting a column that
  doesn't exist yet fails silently for users.
- **Feature flags:** is the gating flag actually enabled in the target env, not
  just dev? Shipped code behind an off flag looks like a no-op deploy.
- **Build cache / stale assets:** could a cached build/CDN serve the previous
  bundle? Confirm the artifact hash or asset fingerprint changed.
- **Release pointer:** does the deploy update the symlink/active revision/traffic
  pointer, or only upload the new build? Uploading is not releasing.
- **Staged rollout / canary:** is traffic stuck at 0% or waiting on a manual
  promote? A canary that never promotes is not a deploy.
- **Env & secrets:** are the env vars/secrets the new code needs present in the
  target? Missing config surfaces as runtime errors, not deploy errors.

### Phase 2: Run the deploy

The human or deploy tooling runs the actual command. The gate does not execute the
deploy itself — it gates and verifies around it.

### Phase 3: Verify live (before saying "shipped")

Confirm the running system, not the deploy log.

- Fetch the live version/revision from the running service and compare to the
  intended one.
- Hit a health/status endpoint and confirm it returns the expected version, not
  just HTTP 200.
- Tail production logs for the first errors after cutover.
- Only when the live revision matches the intended one may you report "shipped".
  Otherwise report the mismatch.

```bash
INTENDED="$(git rev-parse --short HEAD)"
LIVE="$(curl -fsS https://your-service.example.com/health | jq -r '.revision')"
if [ "$INTENDED" = "$LIVE" ]; then
  echo "Live revision $LIVE matches intended $INTENDED: verified shipped."
else
  echo "MISMATCH: intended $INTENDED but live is $LIVE. Do not report shipped."
fi
```

### Verdict format

```
PRE-SHIP GATE, verdict: HOLD
- Migrations: 1 pending (add_users_status_col): NOT yet applied to prod. BLOCK.
- Feature flags: new_checkout flag is OFF in prod.
- Build assets: new bundle hash confirmed (a1b2c3 != previous 9f8e7d). OK.
- Release pointer: deploy updates active symlink. OK.
- Rollout: canary at 10%, manual promote required. NOTE.
- Env/secrets: STRIPE_KEY present in prod. OK.
Reason for HOLD: run migration before cutover, or new code will 500 on /orders.
```

Emit an explicit verdict (SHIP / HOLD) naming the failing item — not a vague
"looks good". Name the specific silent-failure mode you're worried about so a human
can override with context.

## Verifying "done / shipped / fixed" claims (ground truth, not narration)

An agent's "done" is a claim, not a fact — and a claim the agent checks by re-reading
its own work is consistency, not grounding. Verify against git: the commit's message
is forgeable (the agent wrote it); the files it touched are not (git did).

Workflow (using the DOS kernel CLI):

1. **Audit the latest commit's claim vs its diff:**

   ```bash
   dos commit-audit --workspace . HEAD --json | jq -r '.[0].verdict'
   # OK                → diff backs the claim's kind; now run the tests
   # CLAIM_UNWITNESSED → commit doesn't do what it says; reject
   ```

2. **Verify a named phase actually shipped:**

   ```bash
   dos verify --workspace . PLAN PHASE --json --no-ci
   # shipped: true, source: registry|grep-artifact → non-forgeable; safe to close
   # shipped: true, source: grep-subject|grep     → forgeable (subject/body text);
   #   treat as "shipped-per-the-subject" only — corroborate before closing
   # shipped: false, source: none → no evidence; keep the ticket open
   ```

3. **Fold only confirmed effects.** If the verdict is unwitnessed or not shipped,
   the work is not done regardless of how confidently it was narrated — send it back.

Best practices:
- Audit the commit immediately after every agent commit.
- Treat `source: none` / `CLAIM_UNWITNESSED` as "not done", not as a tool failure.
- Close a claim only on a non-forgeable source.
- Keep the test suite as the separate correctness gate — this checks shipping, not
  correctness.

### Security notes

- `dos commit-audit` is read-only (git history + working tree, no network).
- `dos verify` is git-only unless a CI oracle is wired; pass `--no-ci` to force the
  git-only path and guarantee no network.
- The PyPI package is `dos-kernel`, not `dos`; install into an isolated venv, pin a
  reviewed version.
- `curl -fsS` health checks are illustrative — replace host and version field with
  your real endpoint; never paste secrets into health-check URLs.

## Common pitfalls

- **Health check returns 200 but users still see the old version.** You're hitting
  a cached edge or the old pod. Verify the revision field, not just the status code.
- **Migration runs after new code already serves traffic.** Sequence migrations
  before cutover, or gate the code path behind a flag.
- **Deploy "succeeds" but the canary is stuck at 0%.** Confirm the traffic
  pointer/promotion step, not just the upload step.
- **`dos verify` returns `source: none` and looks like a failure.** That is the
  honest "no evidence" verdict — re-stamp the real commit or keep the task open.
- **Trusting deploy output alone.** Report mismatch, not success, when live revision
  ≠ intended revision.
