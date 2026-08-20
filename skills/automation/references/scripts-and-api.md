# Scripts, Scheduling, CI/CD, Git & API Integration

Automation beyond visual workflow builders: shell scripts & cron, CI/CD pipelines (GitHub Actions, CircleCI, Render),
a safe git automation flow, and API integration (Gemini). Read `../SKILL.md` first for the shared workflow.

## ToC
- [Scripts & scheduling](#scripts--scheduling)
- [CI/CD pipelines (GitHub Actions, CircleCI)](#cicd-pipelines-github-actions-circleci)
- [Deployment platforms (Render)](#deployment-platforms-render)
- [Safe git automation](#safe-git-automation)
- [API integration (Gemini)](#api-integration-gemini)

## Scripts & scheduling

- Inventory the build/test/deploy steps and target environments before automating anything.
- For cron/scheduled work, be explicit about timezone and DST; add buffer for long-running jobs; log execution times;
  avoid scheduling at exactly midnight (busy period).
- Make scripts idempotent: store processed IDs / state so re-runs don't duplicate work.
- Keep credentials out of scripts — env vars or a secret manager; never commit secrets.

## CI/CD pipelines (GitHub Actions, CircleCI)

### Design

- **Inventory** current build/test/deploy steps and target environments first.
- Define **stages** (lint → test → build → deploy) with caching, artifacts, and quality gates.
- Add security scans, secret handling, and **approvals for risky steps** (deploys, migrations).
- Document rollout, rollback, and notification strategy.
- Don't run deployment steps without approvals and rollback plans; treat secrets and env changes as high risk.

### CircleCI (via Rube MCP)

- **Project slug format**: `gh/<org>/<repo>` (GitHub) — this trips everyone up.
- Hierarchy: `Pipeline → Workflow → Job`. Trigger a pipeline, then monitor the workflow/jobs until done.
- Retrieve build **artifacts** and **test results** from finished jobs; paginate.
- VCS-triggered pipelines may be skipped if `skip` params set — verify trigger params.

### GitHub Actions (workflow design)

- Use reusable workflows and composite actions to avoid copy-paste across repos.
- Cache dependencies to keep pipelines fast; upload artifacts for debugging.
- Use environment-specific secrets (`secrets.ENV_VAR`), never inline secrets in YAML.
- Add quality gates (tests, coverage, lint) that block merges; approval environments for production deploy.

## Deployment platforms (Render)

- List/browse services, trigger deployments, and **monitor status** (deploy-and-monitor pattern: trigger → poll →
  report URL/status).
- Resolve service IDs first; deploys are async — poll deployment status rather than assuming success.

## Safe git automation

A streamlined scan → branch → commit → push → PR flow that groups related changes and reduces confirmation overhead.

1. **Detect & group**: run `git status`, `git diff --stat`, `git diff --name-only`, `git diff --staged --stat` in
   parallel. Group files by module/directory and by "modified together recently". Present the groups and let the user adjust.
2. **Branch name**: derive from the dominant change, format `<type>/<short-description>` (`feature`/`fix`/`refactor`/
   `docs`/`test`/`chore`), kebab-case, max 50 chars (e.g. `feature/add-user-auth`). Show it, ask for one-word confirmation.
3. **Commit**: stage explicit pathspecs only — `git add -- path/to/file` (keep generated paths NUL-delimited;
   **never concatenate untrusted filenames into a shell command**). Commit message: first line `<type>: <description>`
   (≤72 chars) + grouped body. Preview, one-word confirm.
4. **Push & PR**: `git push -u origin <branch>`; `gh pr create` with title from branch name, body summarizing changes +
   file breakdown. Check `git remote -v` — if a fork, use the fork's remote. Skip any step on "no".

Rules: never commit secrets/credentials/large binaries; generate names from actual changes (don't ask the user to name
things); respect repository maintainer rules and review gates; confirm destructive/publishing actions explicitly.

## API integration (Gemini)

Patterns for integrating a generative-AI API into an app (model selection, multimodal, streaming, function calling).

- **Install**: `npm install @google/generative-ai` (JS/TS) or `pip install google-generativeai` (Python). Store the key
  in an env var — never hardcode.
- **Model selection**: flash models for high-throughput/cost-sensitive tasks; pro for complex reasoning/long context;
  always stream for user-facing chat UIs to cut perceived latency.
- **Multimodal**: pass images as base64 `inlineData` + mimeType; for files > ~20MB use the File API instead of inline.
- **Function calling**: declare functions (`name`, `description`, `parameters` with `required`), inspect
  `response.functionCalls()` to execute, then send the result back to the model.
- **Multi-turn chat**: `startChat({ history })` and keep sending messages.
- **Errors**: `429` → exponential backoff; `400` → invalid request (check prompt/params); `RESOURCE_EXHAUSTED` → quota,
  queue + backoff. `API_KEY_INVALID` → env var / active key. Check `promptFeedback.blockReason` when responses are
  blocked by safety filters.
- Set persistent behavior with `systemInstruction`; honor safety ratings in responses for production.

## Automation of development workflow (meta)

For "automate my dev process" requests: define pipeline stages with caching/artifacts/quality gates, add security
scans + secret handling + approvals for risky steps, and document rollout/rollback/notification strategy. Output a
summary of stages and triggers, proposed workflow files, required secrets/env vars, and risks/rollback notes.
