# Dedup Notes — ai-agents consolidation

Consolidated 39 source skills from 6 libraries into one `ai-agents` skill
(SKILL.md + 9 reference files). Record of every merged topic, duplicate, and drop below.

## Source libraries scanned (39 SKILL.md files)

- `ai-agents/` — 20 skills
- `agent-behavior/` — 5 skills
- `agent-evaluation/` — 1 skill
- `agent-orchestration/` — 7 skills
- `voice-agents/` — 5 skills
- `orchestration/` — 1 skill

Fully deep-read: agent-evaluation, ai-agents-architect, langgraph, pydantic-ai,
mcp-builder (+ its 4 reference files), mcp-builder-ms, multi-agent-patterns,
parallel-agents, dispatching-parallel-agents, loop-library, llm-council,
multi-advisor, hosted-agents, hosted-agents-v2-py, agent-manager-skill,
multi-agent-task-orchestrator, goal-loop, agent-self-scheduling, codex-subagent,
delegating-to-agents, orchestrate, grok-build, open-dynamic-workflows,
lambda-lang, polis-protocol, pilot-protocol, run-deep-swe, codex-fable5,
fable-safe-prompt, zipai-optimizer, dispatch, ditto, voice-ai-development,
audio-transcriber, fal-audio, pipecat-friday-agent. Skimmed via headings + partial
read: m365-agents-dotnet, m365-agents-ts, auri-core (binary file, read SSML +
architecture sections).

## Notable duplicates merged

- **mcp-builder ↔ mcp-builder-ms**: nearly identical MCP four-phase workflow.
  Merged into `references/tool-use-mcp.md`; kept the Microsoft ecosystem catalog
  (Azure/Foundry/Fabric/Playwright/GitHub MCP servers, C#/.NET patterns) as the
  final section. The two SKILL.mds are ~90% same text.
- **parallel-agents ↔ dispatching-parallel-agents ↔ multi-agent-task-orchestrator ↔ orchestrate ↔ open-dynamic-workflows**: all cover subagent coordination. Merged
  into one Orchestration section; kept unique bits — spec prompts (dispatching),
  agent-catalog table (parallel-agents), task registry + quality gates + 30-min
  heartbeat (multi-agent-task-orchestrator), deployment/cost guidance (orchestrate),
  adversarial verification + dependency declaration (ODW).
- **delegating-to-agents ↔ codex-subagent ↔ grok-build ↔ dispatch**: all delegate
  to external CLIs. Merged into `references/delegation-cli.md`; common rules
  deduplicated (one task per launch, review all diffs, self-contained prompts,
  stdin `</dev/null`, no credentials). Kept tool-specific commands (codex exec flags,
  grok CLI flags, cmux/TUI quoting rules).
- **fable-safe-prompt + codex-fable5**: both "Fable" family habits. Merged into
  `references/behavior-guardrails.md` (evidence-first loop + safe-prompt swap table);
  dropped duplicated identity-caveat preamble.
- **llm-council + multi-advisor**: both multi-perspective parallel advisory. Merged
  into a single "Multi-perspective advisory (councils)" subsection; shared rules
  (parallel responses → ranking → synthesis; no forced consensus; action-oriented
  outcomes) merged; provider-specific phases kept as reference text.
- **zipai-optimizer + general prompt-caching best practices**: token/context rules
  merged into `references/behavior-guardrails.md`.
- **goal-loop + loop-library + agent-self-scheduling**: all about bounded autonomy.
  Goal-loops' stop-condition discipline and loop-library's terminal-state rules
  merged under "Goal loops" / "Bounded loops & guardrails"; scheduling got its own
  subsection. "Never put an LLM on a tight timer" appears once.
- **hosted-agents + hosted-agents-v2-py**: hosted/background-agent infra vs the
  Azure-specific SDK version. Merged; Azure code kept as one subsection.

## Skills dropped (and why)

- **multi-advisor (Portuguese)**: persona-advisory product is mostly marketing
  fluff and persona voice scripts; the reusable core (parallel advisory +
  synthesis) survives in orchestration.md; the fantastical persona table was dropped.
- **auri-core (Portuguese, binary)**: a product/business spec for one Alexa voice
  assistant (pricing plans, revenue projections, Go-to-market). Only the SSML tip
  and the reference architecture (Alexa + Claude + DynamoDB + Polly) were extracted
  into voice-agents.md. Business content dropped.
- **fal-audio**: 28-line stub pointing at a GitHub repo with no substantive content —
  folded into provider-selection table in voice-agents.md.
- **agent-manager-skill**: 47-line wrapper around a third-party `main.py`; retained
  only its tmux-fleet pattern as a sentence in orchestration.md (external repo not
  vendored).
- **m365-agents-dotnet / m365-agents-ts**: Microsoft 365/SDK-specific multi-channel
  agents build guides. Skimmed via headings; no cross-cutting agent-design signal
  beyond "agents run in an ASP.NET/Express host" — dropped from the consolidated
  skill as out-of-scope framework tutorials. (Noted as a gap if M365 work is a
  frequent user need.)
- **ditto**: mostly an installer-routing wrapper around an external runtime; the
  generalizable principle (evidence-backed user-profile mining, approval gates)
  kept as a short optional section in behavior-guardrails.md.
- **lambda-lang / pilot-protocol / polis-protocol**: each is a specific protocol
  skill; kept in full as `references/agent-networking.md` because they are
  distinct mechanisms (messaging language, overlay network, learning router), not
  duplicates of each other.

## Boilerplate dropped everywhere

- Repeated "Limitations" boilerplate blocks present in ~35 source files
  ("Use this skill only when...", "Stop and ask for clarification...") collapsed to
  one short section in SKILL.md.
- Marketing/self-congratulatory preamble ("battle-tested across 10,000+ tasks",
  "Bring the magic") removed.
- Repeated "Works well with / When to Use / Related skills" listing blocks (mostly
  references to skills that do not exist in this install) dropped.