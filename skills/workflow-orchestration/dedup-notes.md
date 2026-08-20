# Deduplication Notes — workflow-orchestration

Consolidation report for the `workflow-orchestration` skill.

## Source libraries scanned

| Library | Skills | Outcome |
|---------|--------|---------|
| `workflow` | 62 | Primary source; deep-read core orchestration/agent/CI skills |
| `workflow-bundle` | 9 | Skimmed; contributed the phase-based bundle pattern + MLOps pipeline |
| `granular-workflow-bundle` | 16 | Skimmed; same bundle pattern, domain-specific content out of scope |
| **Total** | **87** | |

## Topics merged

1. **Durable-execution platform selection & sharp edges** — merged
   `workflow-automation` (n8n/Temporal/Inngest/Step Functions/Azure Durable),
   `workflow-orchestration-patterns`, `inngest`, `trigger-dev`, `upstash-qstash`
   into `references/durable-execution-platforms.md`.
2. **Orchestration pattern recipes** — `workflow-orchestration-patterns` +
   `temporal-python-pro` + `temporal-golang-pro` + `workflow-automation`
   (sequential/parallel/orchestrator-worker/saga/entity/async-callback,
   determinism, versioning, retry/heartbeat) into
   `references/orchestration-patterns.md`.
3. **Pipelines & DAGs** — `airflow-dag-patterns` (+ its 509-line playbook),
   `ml-pipeline-workflow`, and the phase-bundle pattern from `workflow-bundle` /
   `granular-workflow-bundle` into `references/pipelines-dags.md`.
4. **Agent workflow design** — `ai-loop`, `subagent-driven-development`,
   `executing-plans`, `acceptance-orchestrator`, `closed-loop-delivery`,
   `verification-before-completion`, `ask-questions-if-underspecified`,
   `task-intelligence` (+ its problem-catalog/time-patterns refs),
   `full-stack-orchestration-full-stack-feature`, `antigravity-workflows` into
   `references/agent-workflow-design.md`.
5. **State machines & track delivery** — `conductor-new-track`,
   `conductor-implement`, `conductor-status`, `conductor-validator`,
   `conductor-manage`, `conductor-revert`, `conductor-setup` (scaffolding bits),
   `workflow-patterns`, and the `build` research→plan→progress→phase pipeline
   into `references/state-machines-tracks.md`.
6. **CI/CD + git/PR orchestration** — `github-actions-templates`,
   `gitlab-ci-patterns`, `github-workflow-automation`, `git-pr-workflows-git-workflow`,
   `iterate-pr`, `finishing-a-development-branch`, `git-workflow-and-versioning`,
   `git-hooks-automation`, `receiving-code-review`, `git-pr-workflows-pr-enhance`,
   `github-automation` / `gitlab-automation` / `bitbucket-automation` (guarded
   pattern) into `references/git-ci-orchestration.md`.

## Notable duplicates merged / dropped

- **`temporal-python-pro` vs `workflow-orchestration-patterns` vs `temporal-golang-pro`:**
  heavy overlap on determinism rules, idempotency, retry, versioning,
  workflow-vs-activity split. Kept the single best explanation in
  `orchestration-patterns.md`; SDK-specific detail (decorators, timeouts,
  test suites, mTLS) routed per-language.
- **`create-pr`, `pr-writer`, `pr-merge-champion`, `git-pr-review`:**
  near-duplicate PR-authoring skills; condensed into the guarded-PR workflow and
  PR-iteration guidance. Individual commit/branch conventions (`commit`,
  `create-branch`) folded into git-discipline; not reproduced in full.
- **`requesting-code-review` / `receiving-code-review`:** both code-review
  posture skills; kept the receiving-side guidance (the actionable one).
- **`workflow-bundle` (9) and `granular-workflow-bundle` (16):** near-identical
  phase-based templates, one per technology domain (WordPress, K8s, React,
  FastAPI, Terraform, security, testing…). The domain content belongs to other
  domains; only the reusable **orchestration pattern** (Overview → When to Use →
  Phases: skills-to-invoke / actions / copy-paste prompts) was kept. Dropped
  the domain-specific copies.
- **`changelog-automation`, `issues`, `gh-review-requests`, `address-github-comments`,
  `bitbucket/gitlab/github-automation`:** platform/mechanic-specific; only the
  reusable policies (verify state, dedup, guarded mutation, review-request
  filtering) survived in `git-ci-orchestration.md`.
- **`git-pr-workflows-onboard`:** onboarding/knowledge-transfer content, out of
  scope for orchestration — dropped.
- **`crossframe`, `crossframe-suite`, `crossframe-public`, `crossframe-review`:**
  Chinese structural-diagnosis reasoning framework, unrelated to workflow
  orchestration — dropped entirely.
- **`lint-and-validate`:** procedural validation steps, subsumed by
  verification-before-completion discipline — dropped.
- **`git-advanced-workflows`:** recovery techniques summarized into git-discipline
  bullet; full guide dropped as out-of-domain detail.

## Scripts

No genuinely reusable scripts were carried over. The three source libraries
contained no `scripts/` directories (the `iterate-pr` / `gh-review-requests`
skills reference `fetch_pr_checks.py` / `fetch_review_requests.py` under
`${CLAUDE_SKILL_ROOT}/scripts`, but those scripts are not shipped in the source
libraries). `scripts/` is kept empty; the PR-iteration and review-request flows
documented in `references/git-ci-orchestration.md` describe equivalent `gh`
CLI commands as a fallback.

## Gaps / doubts

- `airflow-dag-patterns` and `conductor-*` referenced `resources/implementation-playbook.md`
  files; only airflow's playbook and temporal-golang's playbook/testing files
  existed and were absorbed. Conductor scaffolding shell snippets (conductor-setup)
  were summarized rather than copied verbatim.
- The full text of every `workflow-bundle` / `granular-workflow-bundle` phase was
  not read (25 files, highly formulaic); pattern captured from representative
  samples.
- Cross-language SDK detail (Java, TypeScript Temporal) was intentionally
  dropped to keep the reference lean; Python + Go cover the shipped skills.
