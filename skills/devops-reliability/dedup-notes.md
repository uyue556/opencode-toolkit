# Devops-Reliability — Consolidation Notes

Consolidated **57 source skills** from 4 libraries into one skill:

- `devops` (38 skills)
- `reliability` (14 skills)
- `operations` (4 skills)
- `ml-ops` (1 skill)

Output: `/home/administrator/.config/opencode/skills/devops-reliability/`

## Topics merged (per reference file)

| Reference | Sources merged | Notes |
|---|---|---|
| `ci-cd-github-actions.md` | github-actions-advanced, deployment-pipeline-design, github-actions-debugger, mise-configurator | GHA deep content; pipeline architecture + DORA metrics; debugger folded into debugging section; mise toolchain standardization folded in |
| `deployment-strategies.md` | deployment-procedures, shipping-and-launch, pre-release-review, deployment-validation-config-validate, deployment-engineer, devops-deploy, deploy-to-vercel, server-management(partial) | Deployment strategies + principles; launch checklist + staged rollout + rollback plan; pre-release review (read-only audit); config validation; 13-phase web QA; server process management |
| `docker-containers.md` | docker-expert, apple-container | Dockerfile/multi-stage/security/Compose/image-size; apple-container kept as a one-paragraph niche note |
| `kubernetes-gitops.md` | kubernetes-architect, k8s-manifest-generator, helm-chart-scaffolding, k8s-security-policies, gitops-workflow, service-mesh-observability, service-mesh-expert | Manifests + Helm + security (PSS/NetPol/RBAC/OPA) + GitOps (ArgoCD/Flux) + progressive delivery + service mesh |
| `terraform-iac.md` | terraform-skill, terraform-specialist, terraform-module-library, terraform-aws-modules, aegisops-ai | Terraform best practices + testing matrix + versioning + modern features; AWS module examples folded into module development; FinOps/policy audit angle from aegisops-ai |
| `monitoring-observability.md` | observability-engineer, observability-and-instrumentation, grafana-dashboards, distributed-tracing, service-mesh-observability(partial), datadog-automation, sentry-automation, pagerduty-automation, monte-carlo-analyze-root-cause | Pillars + instrumentation + Grafana + tracing + PromQL + tool automation + data-incident RCA workflow |
| `slo-error-budgets.md` | slo-implementation, observability-monitoring-slo-implement | SLO framework; duplicate SLO guidance merged (the `observability-monitoring-slo-implement` mini-skill added nothing beyond slo-implementation) |
| `sre-oncall.md` | on-call-handoff-patterns, server-management, pagerduty-automation, incident-response-incident-response | Handoff templates + rotation hygiene + escalation + server ops + PagerDuty notes |
| `incident-response.md` | incident-responder, incident-runbook-templates, incident-response-incident-response, devops-troubleshooter, incident-response-smart-fix | Severity + command + playbooks + runbooks + investigation protocol |
| `postmortems.md` | postmortem-writing, incident-response-smart-fix, brendangregg-use-tsa(partial) | Postmortem templates + facilitation + evidence discipline |
| `performance-troubleshooting.md` | brendangregg-use-tsa, application-performance-performance-optimization, devops-troubleshooter(partial), server-management(partial) | USE/TSA + 60s triage + app optimization + troubleshooting priority |
| `mlops-remote-gpu.md` | remote-gpu-trainer | Rented-GPU lifecycle + platform survival matrix + training-debug layer + teardown iron law |
| `cron-scheduling.md` | cron-doctor | Five cron death-traps + validation engine usage |

## Notable duplicates merged / dropped

- **Three "SRE/incident responder persona" skills** (`incident-responder`, `incident-response-incident-response`,
  `devops-troubleshooter`) overlapped heavily (severity tables, first-5-minutes, communication
  cadence). Kept the best structure once in `incident-response.md`; unique bits (smart-fix
  orchestration, runbook playbooks) folded in.
- **Four "expert persona" skills** (`observability-engineer`, `kubernetes-architect`,
  `deployment-engineer`, `terraform-specialist`, `devops-troubleshooter`) are mostly marketing
  preamble + capability lists with little procedural content. Extracted the actionable items;
  dropped the persona fluff per dedup rules.
- **SLO trio** (`slo-implementation`, `observability-monitoring-slo-implement`,
  `observability-monitoring-monitor-setup`): the two `observability-monitoring-*` mini-skills are
  ~50 lines of routing boilerplate; merged into `slo-error-budgets.md` /
  `monitoring-observability.md`. `observability-monitoring-monitor-setup` (56 lines, mostly
  placeholders) was dropped as content-free beyond the merged guidance.
- **Terraform set** (5 skills): `terraform-skill` is the authoritative deep guide;
  `terraform-specialist`/`terraform-module-library`/`terraform-aws-modules` contributed module
  structure + AWS examples, all folded; no duplicated advice left in two places.
- **Service mesh pair** (`service-mesh-observability`, `service-mesh-expert`): the "expert" is a
  66-line persona stub; merged into `kubernetes-gitops.md` mesh section.
- **`distributed-debugging-debug-trace`** (52-line stub) folded into tracing guidance in
  `monitoring-observability.md`.
- **`deploy-to-vercel`** — platform-specific CLI walkthrough; condensed to a line in the platform
  selection table of `deployment-strategies.md` (the domain skill is platform-agnostic).
- **`sshepherd`, `vps-server-management`** — private/host-specific SSH tooling and a hardcoded
  host inventory; not generalizable, dropped. Server ops *principles* came from `server-management`.
- **`tool-use-guardian`** — agent-tooling meta-skill (wrapping the agent's own tool calls), not a
  dev-ops/reliability concern; dropped.
- **`kubestellar-console`, `pi-custom-model`** — product/tool specific (multi-cluster dashboard,
  Pi model slugs); out of scope, dropped.
- **`fedora-hyprland-installer`** — desktop Linux installer, unrelated to devops-reliability;
  dropped.
- **`aegisops-ai`** — Gemini-orchestrated governance tool; only the FinOps/policy-audit angle was
  retained in `terraform-iac.md`.
- **`anti-sleep`** — trivial macOS caffeinate snippet; dropped (mentioned in no reference).
- **`incident-response-smart-fix`** — 37-line pointer to an AI-orchestrated debug pipeline; the
  one unique practice (parallel hypothesis tracks + verification-before-completion) is captured
  in `incident-response.md` and `postmortems.md`.
- **`vibecode-production-qa-validator`** — Next.js-specific 13-phase QA; condensed into the
  "production QA for fullstack apps" section of `deployment-strategies.md`.
- **`monte-carlo-analyze-root-cause`** — kept as a workflow because it encodes a genuinely
  reusable data-incident RCA procedure (lineage walk, ETL checks, evidence synthesis), stripped
  of the bundled-MCP-server routing specifics.
- **`apple-container`** — niche; one paragraph retained in `docker-containers.md`.
- **`devops-deploy`** (Portuguese) — contained a clean Python Dockerfile + SAM template +
  deploy commands; the generic Docker/Compose/healthcheck content is already covered, so only
  platform-selection guidance was retained. Dropped as duplicate.

## Scripts carried over

- `scripts/cron-engine.js` + `scripts/cli.js` — copied verbatim from
  `devops/cron-doctor/scripts/` (zero-dependency cron parse/validate/next-runs engine; genuinely
  reusable, deterministic). See `references/cron-scheduling.md` for usage.

### Scripts NOT carried (and why)

- `remote-gpu-trainer` bundles many bash/python helpers (run_one/run_queue wrappers,
  mem_monitor, gpu_health, health_patrol.sh.template, verify_local.py, setup-china-mirrors…),
  but they are deeply coupled to the upstream skill's platform profiles and directory layout,
  and several are templates rather than ready scripts. They did not exist in the source library
  copy (`profiles/` and `scripts/` dirs were absent from the installed skill). Reference the
  upstream `remote-gpu-trainer` repo; the *principles* they encode are fully captured in
  `references/mlops-remote-gpu.md`.
- No other source skill shipped a `scripts/` directory.

## Gaps / doubts

- The source-library copy of `remote-gpu-trainer` was missing its `scripts/`, `profiles/`, and
  `references/` directories (SKILL.md only). Deep platform facts were re-derived from the
  SKILL.md's own survival matrix; live per-platform billing/teardown details should be
  re-verified against current provider docs (as the source itself instructs).
- Persona-style skills (observability-engineer, kubernetes-architect, etc.) were skimmed via
  headings only; their content is largely non-actionable capability lists, but any unique
  checklist item they contained may not have been captured.
- `github-actions-advanced` was deep-read in full (1100 lines) and its patterns summarized;
  very long copy-paste workflow examples were compressed into the reference rather than
  reproduced verbatim.
- Chinese triggers in the frontmatter description are translation-equivalents of the main use
  cases; they should be adequate for triggering but were not validated against a Chinese corpus.
