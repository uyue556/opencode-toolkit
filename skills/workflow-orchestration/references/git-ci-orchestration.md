# CI/CD Pipelines & Git/PR Orchestration

Automation playbooks for GitHub Actions, GitLab CI, and the guarded
change-to-merge delivery workflow. Read `../SKILL.md` first.

## GitHub Actions patterns

### Test workflow

```yaml
name: Test
on:
  push: { branches: [main, develop] }
  pull_request: { branches: [main] }
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix: { node-version: [18.x, 20.x] }
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: ${{ matrix.node-version }}, cache: 'npm' }
      - run: npm ci
      - run: npm run lint
      - run: npm test
      - uses: codecov/codecov-action@v3
        with: { files: ./coverage/lcov.info }
```

### Build & push Docker image

```yaml
env: { REGISTRY: ghcr.io, IMAGE_NAME: ${{ github.repository }} }
jobs:
  build:
    runs-on: ubuntu-latest
    permissions: { contents: read, packages: write }
    steps:
      - uses: actions/checkout@v4
      - uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/metadata-action@v5
        id: meta
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
      - uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

### Best practices

- Pin action versions (`@v4`, not `@latest`); cache dependencies; use secrets;
  set minimal permissions; use matrix builds for multi-version testing.
- Use **reusable workflows** (`on: workflow_call` with `inputs`/`secrets`) for
  common patterns; compose with `uses: ./.github/workflows/reusable-test.yml`.
- Implement **approval gates** for production (`environment: production`);
  add failure notifications (Slack/email); use self-hosted runners for
  sensitive workloads.
- Security scanning: Trivy (SARIF) → upload to GitHub Security; Snyk.

## GitLab CI patterns

### Basic pipeline

```yaml
stages: [build, test, deploy]
build:
  stage: build
  image: node:20
  script: [npm ci, npm run build]
  artifacts: { paths: [dist/], expire_in: 1 hour }
  cache: { key: ${CI_COMMIT_REF_SLUG}, paths: [node_modules/] }
test:
  stage: test
  script: [npm ci, npm run lint, npm test]
  coverage: '/Lines\s*:\s*(\d+\.\d+)%/'
deploy:
  stage: deploy
  image: bitnami/kubectl:latest
  script: [kubectl apply -f k8s/, kubectl rollout status deployment/my-app]
  only: [main]
  environment: { name: production, url: https://app.example.com }
```

### Patterns

- **Multi-environment deploy** via YAML anchors (`&deploy_template` / `<<:`),
  staging on `develop`, production `when: manual` on `main`.
- **Terraform pipeline**: validate → plan (save `tfplan` artifact) → apply
  (`when: manual`, `dependencies: [plan]`).
- **Security scanning**: include SAST / Dependency-Scanning / Container-Scanning
  templates; Trivy image scan with `--exit-code 1`.
- **Caching strategies**: branch-slug keys, global vs per-job caches,
  `policy: pull-push`.
- **Dynamic child pipelines**: generate `child-pipeline.yml` as an artifact,
  trigger it with `strategy: depend`.
- Best practices: pin image tags, use artifacts, manual gates for production,
  environments for tracking, pipeline schedules, CI/CD variables for secrets.

## AI-assisted GitHub workflow automation

- **Automated PR review**: GitHub Action that fetches changed files + diff,
  calls an LLM, posts a structured review (summary / what looks good / issues /
  suggestions / security notes). Filter to code files, include context from
  changed files.
- **Issue triage**: LLM classifies issue (bug/feature/question/docs/other),
  severity, area; applies labels; posts a repro-steps follow-up when missing;
  stale-issue management via `actions/stale@v9` with exempt labels.
- **Smart test selection**: analyze changed paths → run only affected suites via
  a matrix; fall back to "all".
- **Deploy with AI risk assessment**: summarize commits since last tag, score
  deployment risk, `core.setFailed` on high risk; automated rollback job that
  checks out the last stable tag, redeploys, notifies Slack.
- **Git ops**: `/rebase` comment-triggered rebase; AI-assisted cherry-pick with
  conflict prediction; weekly stale-branch cleanup PR.
- **@mention bot**: respond to `@ai-helper explain|review|fix|test|docs` on
  issues/PRs with diff/description context.
- **Repo config**: CODEOWNERS, branch protection via API (required status
  checks, required reviews, linear history, no force push).

Security: store API keys in secrets, minimal permissions, validate inputs, don't
log secrets. Reliability: job timeouts, rate-limit handling, retry logic,
rollback procedures.

## Guarded git PR workflow (delivery loop)

Move completed changes from local review to a verified PR without bypassing
repository policy.

1. **Policy gate first:** read AGENTS.md / contribution / maintainer docs;
   inspect current branch, worktree, remotes, upstream, effective target
   protection; discover repo-native validation/commit/PR commands. Repository
   policy wins over flags and shorthand.
2. **Capture the exact change:** `git status --short --branch`,
   `git diff --stat`, `git diff --cached --stat`, `git branch --show-current`.
   Confirm every file in scope; stop if dirty/staged files can't be separated.
3. **Review in parallel:** independent bounded passes (correctness, security,
   coverage/policy) each with the raw diff + repo instructions; main agent owns
   dedup, severity, edits, final verification.
4. **Validate and repair:** targeted checks then the full required suite; fix
   only source/policy defects in scope; rerun targeted failure then full suite.
   Don't weaken gates or treat deterministic failures as flaky.
5. **Prepare branch + commit:** fetch target; create topic branch off target if
   on a protected branch; stage only intended paths; focused conventional
   commits. Never force-push a shared branch without authorization.
6. **Push + PR:** `git push -u origin <topic>`, `gh pr create --base --head
   --title --body-file`. Body must truthfully state what/why, tests actually
   run, risk/rollback/breaking notes, issue links. Never mark pending checks as
   complete.
7. **Verify remote result:** `gh pr view --json
   headRefOid,baseRefOid,mergeable,mergeStateStatus,url`, `gh pr checks`. Bind
   evidence to the current full head SHA; discard stale conclusions on head/base
   change. Use the repo's guarded merge path; don't bypass required checks,
   merge queues, or maintainer commands.

Stop when: PR exists at intended head, checks green (or one exact blocker),
review evidence current, unrelated user work preserved, requested merge/deploy
verified.

## Iterating a PR until CI passes

Feedback-fix-push-wait cycle:
1. Identify PR (`gh pr view --json number,url,headRefName`); stop if none.
2. Fetch categorized review feedback. Priorities: `high` and `medium` = must
   address (auto-fix); `low` = present a numbered list and let the user choose;
   `resolved` and informational `bot` comments = skip. Review-bot findings are
   treated like human feedback — never silently ignore them.
3. Understand root cause from log snippets (trace backwards, don't assume from
   the check name); fix all instances, not just the one mentioned; extend
   existing tests rather than adding new files.
4. Verify locally before committing; commit + push; then poll CI in a loop
   (30s), addressing new high/medium feedback immediately.
5. Exit on: all checks pass + post-CI feedback clean. Ask for help after the
   same failure twice. Reply on inline threads with what changed + why; check
   for existing bot replies to avoid duplicates.

## Code review handling (receiving)

- Review is technical evaluation, not emotional performance. Respond to
  feedback with action, not defensiveness.
- Forbidden: dismissing valid feedback, claiming "works on my machine",
  silently ignoring, or over-justifying without checking.
- Classify unclear feedback by asking what outcome is expected; apply YAGNI to
  "professional" features; push back only with evidence and a concrete
  alternative; acknowledge correct feedback and gracefully correct your own
  pushback.

## Git discipline (workflow & versioning)

- **Trunk-based development**: keep `main` always deployable; short-lived
  feature branches (1–3 days); feature flags > long branches. Commit early and
  often (each increment a save point); atomic commits (one logical thing);
  descriptive messages (intent, not obvious diff); keep concerns separate; size
  changes.
- **Worktrees** let agents work in parallel without interfering; merge and
  clean up when done.
- **Git hooks** (Husky + lint-staged for JS/TS, pre-commit framework for
  Python): lint/format/typecheck staged files in `pre-commit`; enforce commit
  message format in `commit-msg`; run tests in `pre-push`. Hooks are local-only
  by default — use a framework to share them with the team.
- **Advanced recovery**: interactive rebase, cherry-pick, `git bisect` for bug
  introduction, worktrees for multi-branch work, `reflog` for recovery.
- **Pre-commit hygiene**: review what you're about to commit, ensure no secrets,
  run tests.

## Platform automation (GitHub / GitLab / Bitbucket via MCP)

For programmatic issue/PR/branch/check/workflow operations:
- Confirm tool availability and search current tool schemas before composing
  calls; resolve exact `owner/repo`; never request/persist credentials.
- Apply the same repository-policy gate as the CLI workflow; prefer native
  repo commands/guarded merge paths over generic tool calls.
- Read current item state (comments, labels, linked PRs) before changing state;
  re-read and verify the resulting state.
- Common pitfalls: ID format mismatches, rate limits, URL-encoded paths,
  pagination, plan restrictions.
