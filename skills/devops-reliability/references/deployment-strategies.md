# Deployment Strategies, Release Readiness & Configuration Validation

Source: `deployment-procedures` (devops), `shipping-and-launch` (devops),
`pre-release-review` (operations), `deployment-validation-config-validate` (devops),
`deployment-engineer` (devops), `devops-deploy` (devops), `deploy-to-vercel` (devops),
`server-management` (reliability).

## When to use
Preparing a production launch, choosing a deployment strategy, writing a rollback plan,
running a release-readiness audit, or validating configuration consistency/security.

## Deployment principles — learn to think, not memorize scripts

Every deployment is unique. Before any release: **prepare → backup → deploy → verify →
confirm or rollback**. Never deploy untested code; can't roll back without a backup; watch the
deploy happen; trust but verify; have the rollback trigger ready.

### Platform selection

- Static site / JAMstack → Vercel, Netlify, Cloudflare Pages.
- Simple web app → managed (Railway/Render/Fly.io) or VPS + PM2/Docker for control.
- Microservices → container orchestration.
- Serverless → edge functions / Lambda.

Rollback method per platform: Vercel/Netlify = redeploy previous commit; Railway/Render =
dashboard rollback; VPS+PM2 = restore backup + restart; Docker = previous image tag;
K8s = `kubectl rollout undo`.

## Deployment strategies

### Rolling (default for most apps)
Gradual rollout, zero downtime, easy rollback. K8s:
```yaml
strategy:
  type: RollingUpdate
  rollingUpdate: { maxSurge: 2, maxUnavailable: 1 }
```

### Blue-green
Full second environment; switch a label to flip traffic; rollback = flip back. Doubles
infrastructure cost temporarily. Good for high-risk deployments.
```bash
kubectl apply -f blue-deployment.yaml && kubectl label service my-app version=blue
kubectl apply -f green-deployment.yaml
kubectl label service my-app version=green   # switch; rollback = label back to blue
```

### Canary
Gradual traffic shift with real-user validation. Needs Argo Rollouts / Flagger / service mesh.
```yaml
strategy:
  canary:
    steps:
      - setWeight: 10
      - pause: { duration: 5m }
      - setWeight: 25
      - pause: { duration: 5m }
      - setWeight: 50
      - pause: { duration: 5m }
      - setWeight: 100
```

### Feature flags
Deploy without releasing; kill switch; A/B testing; instant rollback. Rules: every flag has an
owner and an expiration date; clean up within ~2 weeks of full rollout; don't nest flags; test
both on/off states in CI.

**Lifecycle:** DEPLOY (flag OFF) → ENABLE for team/beta → GRADUAL 5%→25%→50%→100% → MONITOR at
each stage → CLEAN UP.

## Staged rollout sequence

1. Deploy to staging; full test suite + manual smoke of critical flows.
2. Deploy to prod (flag OFF); verify health check + no new errors.
3. Enable for internal team; 24h monitoring window.
4. Canary at 5%; 24–48h window; compare vs baseline.
5. 25% → 50% → 100% with the same monitoring gates.
6. Full rollout; monitor 1 week; clean up flag.

### Rollout decision thresholds

| Metric | Advance | Hold & investigate | Roll back |
|---|---|---|---|
| Error rate | within 10% of baseline | 10–100% above | > 2x baseline |
| P95 latency | within 20% | 20–50% above | > 50% above |
| Client JS errors | no new types | <0.1% of sessions | >0.1% |
| Business metrics | neutral/positive | decline <5% | decline >5% |

Roll back immediately on: error rate >2x baseline, P95 >50%, user-reported spike, data
integrity issues, or security vulnerability.

## Rollback plan (write before deploy)

- Trigger conditions (quantified): error rate > 2x baseline, P95 > [X]ms, [specific issue].
- Steps: disable flag OR `git revert` + push; verify rollback; communicate.
- DB considerations: does migration have a rollback? What happens to data inserted by the new
  feature?
- Time to rollback: flag < 1 min; redeploy < 5 min; DB < 15 min.
- Principles: speed over perfection; one rollback, not multiple compounding changes; postmortem
  after stable.

## Pre-launch checklist (condensed)

- **Code quality:** all tests pass, build clean, lint/type pass, reviewed, no TODO/log spam.
- **Security:** no secrets in repo, `npm audit` clean, input validation, authn/authz, security
  headers, rate limiting on auth endpoints, CORS to specific origins.
- **Performance:** Core Web Vitals good, no N+1 queries, optimized images/bundle, DB indexes,
  caching configured.
- **Accessibility:** keyboard nav, screen-reader structure, WCAG AA contrast, focus management.
- **Infrastructure:** env vars set, migrations ready, DNS/SSL, CDN, logging + error reporting,
  health check endpoint.
- **Documentation:** README, API docs, ADRs, changelog, user docs.

Post-launch first hour: health endpoint 200, no new error types, latency stable, manual smoke of
critical flow, logs flowing, rollback mechanism verified.

## Red flags / anti-patterns

- Deploying without a rollback plan; no monitoring in prod; big-bang releases; flags with no
  expiry/owner; no one watching the first hour; prod config by memory not code; "It's Friday
  afternoon, let's ship it". Deploy early in the week, one change at a time.

## Pre-release review (read-only)

Run a read-only release-readiness audit before tagging/deploying. **Non-negotiable:** do not
modify code/configs/secrets, run migrations, clear caches, trigger CI/CD, or deploy anything.
Produce a prioritized report (P0 > P1 > P2) with findings that each cite evidence (file:line,
commit, diff relationship) and an inferred owner.

Workflow:
1. Confirm repo root, branch, dirty state, and comparison range (PR → `gh pr diff`; explicit
   `base..head`; else previous release tag → HEAD; no tag → latest 5 commits with a warning).
2. Collect changed files, diff stats, commit summaries, touched services.
3. Inspect diffs (not filenames): schema changes → migrations/backfills; config reads → env
   examples/secrets/flags; cache key/TTL → invalidation/prewarm; queue producers/consumers →
   topic setup/DLQ/idempotency/deploy order; asset references → CDN/object storage; contract
   changes → deploy sequence + rollback risk.
4. Classify findings; conclusion is exactly `BLOCKED` | `NEEDS_CONFIRMATION` |
   `NO_BLOCKER_FOUND`.
5. Never reveal full secrets — only path, line, variable name, type, and a redacted hint.

## Configuration validation

Validate configs across environments to prevent "works in dev, breaks in prod" and secret leaks.

### Analysis
- Enumerate config files (`*.json/yaml/yml/toml/ini/.env*`), detect environment, scan for
  secret-shaped patterns (`api_key`, `secret`, `password`, `token`, `aws_access`).
- Flag real secrets (not just key names) as high severity.

### Schema validation (JSON Schema / Ajv)
- Validate with `allErrors`, coerce types, add custom formats (`url-https`, `port`,
  `duration`). Require the fields each environment needs (e.g., DB config requires host/port/
  database/user/password with `minLength` on password).

### Environment-specific rules
- dev: debug allowed, HTTPS optional; prod: debug forbidden, HTTPS required, `min_password_length
  ≥ 16`, encryption required. Report violations with severity (critical/high/...).

### Runtime validation & migration
- Validate on load; on change, re-validate and emit `config:changed` events; fail hard outside
  dev on invalid config.
- Version configs and migrate with explicit up/down steps (semver), never silent rewrite.

### Security
- Encrypt secret values (e.g., AES-256-GCM with a derived key); decrypt on load; never log
  decrypted values. Keep secrets in env vars / secret managers, not files.

## Production QA for fullstack apps (13-phase pattern)

When shipping a web app, run phases: code integrity → build verification → API session/auth →
route regression → SEO (tags/images/favicon/slugs) → API route behavior → git hygiene →
post-deploy smoke → page speed/lazy load/bundles → cleanup + vulnerability scan → UI/UX
(cards, animation, error boundaries) → database & data layer → secure data rendering.
Use a consolidated runner (script or GH Action) so the checklist is executable, not a doc.

## Server process management (ops essentials)

- Tool selection: Node → PM2 (clustering/reload); anything → systemd; containers → Docker/
  Podman; orchestration → K8s/Swarm.
- Goals: restart on crash, zero-downtime reload, use all cores, survive reboot.
- Health checks: HTTP 200 + DB connected + dependencies reachable + resources not exhausted;
  deep checks where the load balancer needs them.
- Logs: rotate, structured (JSON), correct levels, no sensitive data.
