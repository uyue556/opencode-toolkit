# CI/CD Pipelines (GitHub Actions + Pipeline Design)

Source: `github-actions-advanced` (devops), `deployment-pipeline-design` (devops),
`github-actions-debugger` (devops), `mise-configurator` (devops).

## When to use
Designing, debugging, or hardening CI/CD pipelines: GitHub Actions workflows, reusable
workflows, matrix builds, self-hosted runners, OIDC auth, caching, environments/secrets,
release automation, or GitLab/Azure equivalents.

## Workflow skeleton — always include these

```yaml
name: Workflow Name
on:
  push:
    branches: [main]
    paths-ignore: ['**.md', 'docs/**']   # skip docs-only changes

permissions:                 # always declare — least privilege
  contents: read

concurrency:                 # prevent duplicate runs
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  job-id:
    runs-on: ubuntu-24.04    # pin OS version; avoid -latest in prod
    timeout-minutes: 15      # always set
    environment: production  # env-scoped secrets + approval gates
    steps:
      - uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683  # pinned SHA
      - run: echo "hello"
```

## Triggers

- `push` / `pull_request` with `paths-ignore` and branch filters.
- `workflow_dispatch` with typed `inputs` for manual runs.
- `schedule` with cron (see `cron-scheduling.md`; remember GitHub Actions uses UTC).
- `workflow_call` for reusable workflows (prefix files with `_`).
- `pull_request_target`: **runs with repo secrets** — gate on a maintainer-applied label AND
  `author_association` check; never check out untrusted fork code without sandboxing.

## Reusable workflows & composite actions

- Reusable workflows: store in `.github/workflows/_build.yml`, call with `uses:
  ./.github/workflows/_build.yml` (same repo) or `org/repo/...@main`; pass `inputs`, `secrets:
  inherit` (or explicit), and `outputs`.
- Composite actions: `.github/actions/<name>/action.yml` with `runs.using: composite`. Secrets
  cannot be passed as `inputs` to composite actions — pass them via `env:`.

## Matrix builds

```yaml
strategy:
  fail-fast: false           # don't cancel siblings while debugging
  max-parallel: 4
  matrix:
    os: [ubuntu-24.04, windows-2022, macos-14]
    node: ['18', '20', '22']
    exclude:
      - os: windows-2022
        node: '18'
```

For a dynamic matrix, generate JSON in a `generate-matrix` job with `printf 'matrix=...' >>
$GITHUB_OUTPUT`, then `matrix: ${{ fromJson(needs.generate-matrix.outputs.matrix) }}`.

## Caching

- Preferred: `actions/setup-*` with `cache:` (npm/yarn/pnpm/pip/maven/gradle/go) — no extra step.
- Manual: `actions/cache` with `key` from `hashFiles(...)` plus `restore-keys` fallbacks.
- Docker: `cache-from: type=gha` / `cache-to: type=gha,mode=max`; registry-backed cache
  (`type=registry,ref=ghcr.io/org/img:buildcache`) works across branches.

## OIDC (keyless cloud auth)

Never store long-lived cloud credentials as secrets. Add `id-token: write` to `permissions`.

- AWS: `aws-actions/configure-aws-credentials` with `role-to-assume`; IAM trust policy must
  reference the `token.actions.githubusercontent.com` OIDC provider and restrict
  `sub`/`repo` conditions to your repo + branch.
- GCP: `google-github-actions/auth` with `workload_identity_provider` + `service_account`.
- Azure: `azure/login` with client/tenant/subscription IDs only (no client secret).

## Secrets & environments

- Hierarchy: environment secret > repo secret > org secret.
- Mask dynamic values before use: `echo "::add-mask::$TOKEN"`.
- Environments give you required reviewers, wait timers, branch/tag restrictions, and
  env-scoped secrets. Configure `environment:` on deploy jobs.
- GITHUB_TOKEN is auto-provided; use `actions/github-script` for API calls.

## Self-hosted runners

- Use ephemeral runners (Actions Runner Controller on Kubernetes) for fresh runners per job.
- Never share prod runners with fork PR workflows; use runner groups + custom labels
  (`gpu`, `high-memory`); set `ACTIONS_RUNNER_HOOK_JOB_COMPLETED` cleanup hooks.

## Security hardening checklist

- [ ] Third-party actions pinned to full commit SHA (`npx pin-github-action .github/workflows/*.yml`
  or `pip install ratchet && ratchet pin .github/workflows/`).
- [ ] `permissions:` declared at workflow and job level.
- [ ] No `${{ }}` inside `run:` — pass values through `env:` and quote.
- [ ] OIDC for cloud credentials; secrets never echoed/logged.
- [ ] `pull_request_target` gated (label + author_association).
- [ ] step-security/harden-runner with egress-policy `audit` → `block` after allowlisting.
- [ ] `timeout-minutes` on every job; `concurrency` set; artifact retention bounded.

## Debugging

- Repo secrets `ACTIONS_RUNNER_DEBUG=true`, `ACTIONS_STEP_DEBUG=true`.
- Dump contexts: `echo "$GITHUB_CONTEXT" | jq .` (guard with `if: runner.debug == '1'`).
- SSH into a failing runner: `mxschmitt/action-tmate` gated on `failure()`.
- Remember: fork PRs get a restricted GITHUB_TOKEN; don't expect repo secrets in that context.

## Pipeline architecture (multi-stage)

Standard flow: **Source → Build → Test (unit/integration/security) → Staging deploy →
integration/E2E → Approval gate → Production deploy → Verification → Rollback**.

- Fail fast (cheap tests first), run independent jobs in parallel, cache dependencies.
- Approval gate patterns: manual (GitHub environments), time-based (GitLab `when: delayed`),
  multi-approver (Azure ManualValidation).
- Track DORA metrics: deployment frequency, lead time, change failure rate, MTTR, pipeline
  success rate and duration.

## Reference pipeline: Build → Test → Push → Deploy

```yaml
on:
  push: { branches: [main] }
  pull_request: { branches: [main] }
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: ${{ github.ref != 'refs/heads/main' }}
permissions: { contents: read }

jobs:
  build-test:
    runs-on: ubuntu-24.04
    steps:
      - uses: actions/checkout@<sha>
      - uses: actions/setup-node@<sha>  # node-version + cache
      - run: npm ci && npm run lint && npm run test -- --coverage && npm run build
      - uses: actions/upload-artifact@<sha>  # dist/, retention-days: 7

  push-image:
    needs: build-test
    if: github.ref == 'refs/heads/main'
    permissions: { contents: read, packages: write, id-token: write }
    steps:
      - uses: docker/setup-buildx-action@<sha>
      - uses: docker/login-action@<sha>  # ghcr.io, github.actor, secrets.GITHUB_TOKEN
      - uses: docker/metadata-action@<sha>  # type=sha,format=long; latest
      - uses: docker/build-push-action@<sha>  # cache-from/to type=gha; provenance + sbom

  deploy-staging:
    needs: push-image
    environment: { name: staging, url: https://staging.example.com }
    steps: [run: ./scripts/deploy.sh staging "$IMAGE_DIGEST"]

  deploy-production:
    needs: deploy-staging
    environment: { name: production, url: https://example.com }  # requires approval
    steps: [run: ./scripts/deploy.sh production "$IMAGE_DIGEST"]
```

## Security scanning pipeline

- CodeQL (`github/codeql-action` init/autobuild/analyze) + Trivy container scan
  (`aquasecurity/trivy-action`, SARIF output, severity CRITICAL,HIGH), uploaded via
  `codeql-action/upload-sarif`. Permissions: `security-events: write`.

## Toolchain standardization (mise)

For reproducible local + CI toolchains, generate a `mise.toml` (pin runtime versions via
`[tools]`), add `mise install`/`mise trust` bootstrap, and mirror the same pinned versions in CI
so local == CI. Use a single source of truth for runtime versions; never let CI resolve "latest".

## Mise-en-place (mise-configurator essentials)

- Detect the project stack, pin exact versions (`nodejs 22.4.0`), commit `.mise.toml` +
  `.mise.toml.local` (ignored) for machine-specific overrides.
- Add a `[tasks]` table for common commands (`check`, `lint`, `deploy`) so agents and humans run
  the same steps.
- In CI, install mise then `mise install` — same `mise.toml` means parity with local.

## Troubleshooting quick reference

| Problem | Fix |
|---|---|
| Workflow doesn't trigger on fork PR | Use `pull_request`, not `pull_request_target`, for untrusted flows |
| Secret shows as `***` but leaks | `echo "::add-mask::$VALUE"` before first use |
| Cache never hits | Add `restore-keys` without branch/hash segment |
| Matrix job fails silently | `fail-fast: false` during debugging |
| Job hangs | Set `timeout-minutes` |
| `set-output` deprecated | `echo "key=value" >> $GITHUB_OUTPUT` |
| OIDC token request fails | Add `id-token: write` permission |
| Reusable workflow can't read secrets | `secrets: inherit` or pass explicitly |

## Common pitfalls

- Pinning with tags (`@v4`) instead of SHAs — mutable and hijackable.
- Putting untrusted expressions directly in `run:` — script injection.
- No `timeout-minutes` → runaway jobs burn runner minutes and money.
