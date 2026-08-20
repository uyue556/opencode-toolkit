---
name: ai-agents
description: >-
  Design, build, orchestrate, evaluate, and operate AI agents — autonomous
  agents, tool use / function calling, memory, planning, multi-agent systems,
  subagent delegation, agent loops, MCP servers, voice agents, and agent
  benchmarking. Use whenever the user mentions 智能体, AI代理, agent, 多智能体,
  multi-agent, supervisor, swarm, orchestrator, subagent, delegation, 编排,
  agent loop, 循环, tool use, function calling, MCP, 工具, memory 记忆,
  guardrails 护栏, voice agent 语音助手, or evaluating/benchmarking/testing an
  agent. Routinely consult this skill when asked to "build an agent", "design a
  multi-agent system", "route work to agents", "benchmark the agent", "wire an
  MCP server", or "make the agent more reliable".
---

# AI Agents

Build agents that act autonomously while staying controllable. This skill
consolidates agent architecture, orchestration, behavior, evaluation, tool
use / MCP, and voice agents. Agents fail in unexpected ways, so design for
graceful degradation, explicit failure modes, bounded loops, and real
verification before you declare anything done.

## When to use

- Designing or building a single autonomous agent (loop design, tools, memory, planning).
- Structuring a multi-agent system (supervisor, swarm, hierarchical, parallel dispatch).
- Delegating bounded work to other agent CLIs (Codex, Grok, Antigravity, Claude Code, Pi, Hermes).
- Evaluating, benchmarking, or testing agent capability and reliability.
- Building MCP servers / tool interfaces so agents can use external systems.
- Building voice agents (STT → LLM → TTS) or transcribing audio.
- Making long-running or scheduled agent work safe (bounded loops, stop rules, guardrails).

## Core workflow

1. **Clarify scope.** One sentence objective, explicit success criteria, what must NOT change, and the verifiable check that proves progress. If "done" is undefined, define it before starting.
2. **Choose architecture.** Start with ONE agent with good tools. Add agents only when a single context window or tool set is the proven bottleneck (see routing table).
3. **Build the loop.** Every agent needs: a max-iteration / budget limit, explicit error propagation, structured outputs, and logging of thoughts/actions/observations.
4. **Orchestrate deliberately.** If multi-agent: give each agent non-overlapping ownership, a task registry to prevent duplicate work, quality gates (evidence, not claims), and a heartbeat for stale work.
5. **Verify.** Run the acceptance check after every change. Test adversarially, statistically (stochastic outputs), and on production-shaped samples before trusting benchmark numbers.
6. **Bound and schedule.** Prefer user-supplied stop conditions over invented time/iteration limits. Never put an LLM on a tight autonomous timer without an external clock and explicit approval.

## Selection routing

| Task | Where to go |
|---|---|
| Agent loop design, tool specs, memory, error handling, sharp edges | `references/architecture.md` |
| Multi-agent architecture decisions (supervisor/swarm/hierarchical, context isolation, consensus) | `references/architecture.md` (Multi-Agent section) |
| LangGraph stateful graphs / state machines | `references/frameworks.md` (LangGraph) |
| PydanticAI typed agents (Python) | `references/frameworks.md` (PydanticAI) |
| Orchestrator with task registry, quality gates, heartbeats | `references/orchestration.md` |
| Parallel / independent subagent dispatch | `references/orchestration.md` (Parallel dispatch) |
| Goal loops and bounded agent autonomy | `references/orchestration.md` (Goal loops) |
| Delegating to Codex / Grok / Antigravity / other CLIs | `references/delegation-cli.md` |
| Scheduling recurring agent runs | `references/orchestration.md` (Scheduling) |
| Agent-to-agent messaging / agent networking | `references/agent-networking.md` |
| Behavior discipline, safe-prompt rewriting, token/context optimization | `references/behavior-guardrails.md` |
| Loop design with stop rules and guardrails | `references/behavior-guardrails.md` (Bounded loops) |
| Evaluating / benchmarking an agent | `references/evaluation.md` |
| Building MCP servers / tool interfaces | `references/tool-use-mcp.md` |
| Voice agents (STT/TTS/realtime) or audio transcription | `references/voice-agents.md` |
| Hosted / sandboxed / background agents | `references/orchestration.md` (Hosted agents) |

## Core principles

- **Fail loudly, not silently.** Never swallow tool exceptions — return error type plus a recovery hint so the agent can retry or choose an alternative.
- **Tools are documentation.** A tool's description IS its spec: one-sentence purpose, when to use (and when not), typed params, example inputs/outputs, expected errors. Vague descriptions cause wrong tool selection and wrong answers.
- **Memory is for context, not a crutch.** Summarize instead of storing verbatim; filter by relevance; clear working memory between tasks; use RAG for long-term retrieval.
- **Planning reduces, doesn't eliminate, errors.** Keep plans short and update them as evidence changes. Replan when results contradict the plan.
- **Multi-agent adds complexity — justify it.** The primary benefit is context isolation, not role-playing. Measure the coordination overhead before paying it.
- **Metrics get gamed.** Benchmarks reward pattern-matching; production is long-tail. Evaluate multi-dimensionally and never let a single metric decide.
- **Verification is the contract.** Output is a claim; tests and diffs are evidence. Review every subagent diff yourself before accepting it.

## Do & Don't

- **Do** set `max_iterations`, `max_tokens`, timeouts, and cost caps on every agent loop.
- **Do** keep 5–10 tools per agent; use a tool-selection layer or specialized agents for larger tool sets.
- **Do** require explicit user approval for destructive, irreversible, production, financial, or external-message actions.
- **Do** attribute commits and PRs to the prompting user, not the app identity.
- **Do** pass untrusted text (diffs, issues, chat) via stdin or a temp file, never interpolated into a shell command.
- **Don't** regex-parse freeform LLM output — use structured output (JSON mode / function calling) and retry with format instructions on parse failure.
- **Don't** run agents with overlapping file ownership in parallel; use worktrees and a task registry.
- **Don't** treat a no-progress loop as success, or report an exhausted budget as success.
- **Don't** ship stale code or assumptions from an earlier cycle — re-read current state before consequential actions.
- **Don't** put secrets in prompts, MCP tool args, or code; use environment variables / secret managers.

## Common pitfalls

- **Agent loops forever / burns API credits.** Missing iteration/time/cost limits. Add circuit breakers for tool failures and a no-progress stop rule.
- **Test data leaks into the agent.** Fine-tuning data, system-prompt examples, or RAG documents containing test answers inflate scores. Detect leakage (exact match, memorization, RAG retrieval) and rotate tests.
- **Flaky CI because LLM output is stochastic.** Run each test multiple times, require ~80% pass rate, flag flakiness, and use statistical comparison instead of deterministic pass/fail.
- **Supervisor bottleneck / telephone game.** Supervisors paraphrase sub-agent output and lose fidelity. Let sub-agents pass final responses directly to the user when appropriate, and constrain worker output schemas.
- **Orchestrator does the work itself.** Give every role explicit NOT-blocks ("you never write code; you delegate") — this measurably reduces task drift.
- **Two agents edit the same file.** File-level locking, per-task ownership, and one worktree per parallel agent.
- **Brittle output parsing.** LLMs don't emit perfectly consistent text. Use structured outputs; fuzz-match actions; handle multiple formats.

## Examples

- **Fix N failing test files.** Group by root cause; if independent, dispatch one agent per file with scope, constraints, and a required summary; review each diff, then run the full suite. Don't parallelize related failures.
- **Research brief with parallel scouts.** Send read-only scouts to independent sources at low reasoning effort; reconcile disagreements yourself; keep final judgment with the coordinator.
- **Code review across models.** "Ask codex to review my uncommitted changes" — run the external CLI read-only, then summarize its findings, state where you agree/disagree, and treat its output as a peer opinion, not authority.
- **Coverage lift via a goal loop.** Write a one-sentence objective, constraints (no new deps, mirror test style), a validate command (`pytest --cov=...`), and a verifiable stop condition ("coverage ≥ 75% AND all tests pass") — forbid narrowing tests to pass.

## Related skills

Works well with: `rag-engineer`, `prompt-engineer`, `structured-output`, `llm-observability`, `testing-fundamentals`.

## Limitations

- Content here consolidates the source libraries listed in `dedup-notes.md`; framework code (LangGraph/PydanticAI/MCP SDKs) evolves — verify against current docs before shipping.
- Nothing here substitutes for environment-specific validation, security review, or expert judgment.
- Stop and ask when required inputs, permissions, safety boundaries, or success criteria are missing.
