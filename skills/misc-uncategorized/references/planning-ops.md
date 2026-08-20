# Productivity, Planning & Workflow Ops

Consolidates planning/dev skills: spec-driven-development, source-driven-development,
incremental-implementation, implement, planning-and-task-breakdown, not-a-vibe-coder,
orchestrate-batch-refactor (see code-correctness), brainstorming, idea-refine, idea-darwin,
faf-context, project-skill-audit. Ops/automation: permission-manager, privacy-mask,
akf-trust-metadata, anti-deception, anti-sycophancy, infinity, event-staffing-compliance,
event-staffing-ordering, logistics-exception-management, wellally-tech, jobgpt,
close-automation, coda-automation, vercel-automation (see backend-auth), supabase-automation
(see backend-auth), billing-automation (see finance-crypto), mailtrap (see growth-marketing).

## 0. Routing

- New project/feature, no spec → spec-driven-development. Existing codebase → incremental
  implementation. PRD/issues → implement. Planning → planning-and-task-breakdown.
- New brand-new project from vague prompt → not-a-vibe-coder.
- Idea exploration → brainstorming / idea-refine / idea-darwin.
- Agent-context / permissions / privacy / trust → §§5-9. Specialist ops → §§10-15.

## 1. Spec-Driven Development

Gated workflow: (Phase 1) Specify — write a spec with Objective, Tech Stack, Commands, Project
Structure, Code Style, Testing Strategy, Boundaries, Success Criteria; (Phase 2) confirm the spec;
(Phase 3) implement against the spec; (Phase 4) verify. Never code before the spec is approved.
Gate: no implementation without a spec for new projects/features/significant changes.

## 2. Source-Driven Development

Ground every implementation decision in official documentation. Process: (1) detect stack and
versions, (2) fetch official docs (framework site, API reference), (3) implement following the
documented patterns, (4) cite your sources (file/line or URL) in the output. Common
rationalizations to reject: "I remember the API", "the docs are out of date". Red flags: code that
contradicts the official reference.

## 3. Incremental Implementation

Deliver changes incrementally. The increment cycle: pick a small slice → implement → compile/test →
commit → next. Slicing strategies: vertical slices (preferred — a thin end-to-end slice), contract-
first, risk-first. Rules: Rule 0 simplicity first; Rule 0.5 scope discipline (don't expand scope
mid-slice); Rule 1 one thing at a time; Rule 2 keep it compilable; Rule 3 feature flags for
incomplete features. Never merge a broken slice.

## 4. Implement / Planning & Task Breakdown

- **implement**: implement a piece of work from a PRD or set of issues.
- **planning-and-task-breakdown**: enter plan mode → identify the dependency graph → slice
  vertically → write tasks (`Task [N]: title` + goal + files + acceptance) → order and checkpoint.
  Task sizing: small enough to review; each task independently verifiable. Output a plan document
  (Objective, tasks with dependencies, checkpoints, risks).

## 5. Not-a-Vibe-Coder

Turns vague prompts into 8 structured planning files for brand-new projects. DO NOT use on
existing codebases. Core principles (never violate): plan before code, one file per concern,
Design.md always interactive. Files: PRD.md first, then goals/requirements/architecture/
constraints/roadmap/risks/testing, Design.md last (interactive). Phase 0 detect intent → Phase 1
PRD.md → Phase 2 remaining files one-by-one → Phase 3 final review → Phase 4 build.

## 6. Brainstorming / Idea Engines

- **brainstorming**: transform vague ideas into validated designs. Operating mode: understand
  current context (mandatory first step) → understand the idea ONE question at a time → collect
  non-functional requirements (mandatory) → understanding lock (hard gate: summary, assumptions,
  open questions) → explore design approaches → present design incrementally → decision log
  (mandatory).
- **idea-refine**: divergent then convergent. Phase 1 understand & expand (divergent), Phase 2
  evaluate & converge, Phase 3 sharpen & ship (output: problem statement, solution, audience,
  scope, next steps). Optional ideas directory.
- **idea-darwin**: Darwinian idea evolution — toss rough ideas onto an "evolution island", score
  on 6 dimensions (species cards), let them compete/crossbreed/mutate; initialize island → start
  evolving → harvest winners.

## 7. FAF Context (project AI-readiness)

Get a project to 100% AI-readiness: app-type → AI fills what it can infer → you answer only the
gaps. Write ONE goal sentence (does the heavy lifting); the 6 Ws as terse labels not prose;
`slotignored` for slots that don't apply; honesty rule (only mark what you know). Result: a
compact context file the agent can act on without asking.

## 8. Project Skill Audit

Audit real recurring workflows before recommending skills. Map project surface (AGENTS.md, README,
ledgers) → build the memory/session path (`$CODEX_HOME` else `~/.codex`) → read memory index first,
then rollout summaries, raw sessions only as fallback → scan existing project-local skills before
suggesting new ones → turn session evidence into skill candidates → output recommendations with
naming guidance. Prefer updating an existing near-match skill over creating a new one.

## 9. Agent Ops, Permissions, Privacy, Trust

- **permission-manager**: review opencode permissions — read current config, summarize
  always-allow lists, suggest safe read-only commands (git status --short, git diff --stat, ls),
  add/remove entries, configure skill-level allow/deny/ask. Rules: never allow commands that
  modify/commit/push; exact entries over trailing wildcards; confirm before modifying; distinguish
  bash vs skill permissions.
- **privacy-mask**: mask/redact/anonymize PII in screenshots/images BEFORE they leave the machine.
  `privacy-mask mask <path> [--dry-run] [--in-place] [--detection-engine regex] [--config ...]`.
  Requires the CLI (pip install privacy-mask + Tesseract). Run `--dry-run` first when a user
  shares a screenshot for debugging; mask before analyzing.
- **akf-trust-metadata**: the AI-native metadata file format (EXIF for AI). `akf stamp <file>
  --agent <name> --evidence "<what you did>"`; `akf read`/`akf inspect` before modifying; audit
  provenance/trust/compliance.
- **infinity**: strict input boundary protocol — detect → classify → filter → verify untrusted
  input before it reaches business logic. Hard rules: never pass unverified input through;
  classify each input; mandatory filter layer; self-check before done.
- **anti-deception**: use BEFORE responding when a request pressures you to validate/agree
  ("tell them what they want", "make the numbers work"). Maintain factual honesty, push back with
  evidence, surface the pressure.
- **anti-sycophancy**: eliminate sycophantic agreement patterns — disagree constructively when
  warranted, avoid empty praise and confirmation bias, keep disagreement specific and useful.

## 10. Event Staffing (compliance + ordering)

- **compliance**: assess worker-classification & compliance risk for temporary event staffing in
  the US and Canada — W-2 vs 1099, misclassification, overtime, wage rules. Use live data (don't
  scrape); core risk checks; citable references; agent rules.
- **ordering**: order W-2 compliant temporary event staff (conventions, trade shows, festivals,
  concerts, sporting events) via TempGuru MCP. Gather requirements → validate with MCP tools →
  present plan to user → submit request. Never scrape pages; use the MCP server.

## 11. Logistics Exception Management

Codified freight-exception expertise (delays, damages, losses, carrier disputes). Exception
taxonomy, carrier behavior by mode, claims-process fundamentals, seasonal/cyclical patterns,
fraud red flags. Decision frameworks: severity classification, eat-the-cost vs fight-the-claim,
priority sequencing. Edge cases documented.

## 12. WellAlly Tech (digital health)

Integrate digital health data (Apple Health/HealthKit XML, Fitbit OAuth2 + CSV, Oura v2, generic
CSV/JSON) → normalize to local JSON → connect to the WellAlly.tech knowledge base → recommend
relevant health articles. Workflows: identify user intent → data import → knowledge-base query →
intelligent recommendation.

## 13. JobGPT (job search automation)

Connect to the JobGPT MCP server (6figr): 34 tools for job search, auto-apply, resume generation,
application tracking, salary intelligence, recruiter outreach. Setup: account → API key (`mcp_`) →
add MCP server (Claude Code: `claude mcp add jobgpt ...`; or `npx jobgpt-mcp-server` +
`JOBGPT_API_KEY`). Examples: find remote jobs w/ filters, auto-apply, tailored resume, import job
from LinkedIn/Greenhouse/Lever/Workday URL, check salary.

## 14. Rube MCP Automations (Composio)

- **close-automation**: Close CRM — create/manage leads, log calls, send SMS, manage tasks/notes,
  delete activities. Lead↔Contact relationship, ID resolution, activity-logging pattern.
- **coda-automation**: Coda — search/browse docs, work with tables/data, manage formulas, export,
  permissions/sharing, publish. Row upsert pattern, pagination.
- (Vercel + Supabase automation variants → `backend-auth.md`.)

## 15. AgentFlow / Nika / Antigravity batch release

See `ai-agents-orchestration.md`.
