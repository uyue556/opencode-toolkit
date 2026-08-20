# AI Agents, Orchestration & Governance

Consolidates: crewai, langfuse, subagent-orchestrator, agentflow, nika, polis-protocol, evolution,
yes-md, protect-mcp-governance, manifest, blockrun, cowork-to-code-bridge, accint-solve/frames/
commitments, antigravity-maintainer-batch-release, maxia, superpowers-lab.

## 0. Routing

- **crewai** → building Python role-based multi-agent crews.
- **langfuse** → LLM observability/tracing/prompt management/evaluation.
- **subagent-orchestrator** → quota-aware parallel subagents for large multi-file tasks.
- **agentflow** → Kanban-orchestrated AI development pipelines (Asana/GitHub Projects/Linear).
- **nika** → repeatable AI work as checked, budgeted workflow files.
- **polis-protocol** → self-optimizing "city of agents" with chronicle/register/contract.
- **yes-md / protect-mcp-governance / manifest / akf (see planning-ops)** → agent governance.
- **blockrun** → LLM API w/ budget control and real-time X search.
- **maxia** → AI-to-AI marketplace on Solana.
- **accint-*** → triage a goal through a scored-memory loop (acc_act runtime workflows).

## 1. CrewAI (Python)

Structure with YAML configs (recommended): `config/agents.yaml` (role/goal/backstory/tools),
`config/tasks.yaml` (description/agent/expected_output/context for chaining). Use `@CrewBase`
decorators + `Agent(config=...)`, `Task(config=...)`, `Crew(agents, tasks, process,
verbose=True)`; run with `crew.kickoff(inputs={...})`.
- **Process**: sequential (chain) vs hierarchical (manager agent delegates — set
  `manager_llm`); manager decides which agent handles which task and how to combine results.
- **Planning**: `planning=True` + `planning_llm` → step-by-step plan injected into each task,
  more consistent results; access via `crew.plan`.
- **Memory**: `memory=True` (short-term within task, long-term across executions, entity).
  Custom backends via `LongTermMemory(storage=...)`, `embedder`.
- **Flows** (`crewai.flow.flow`): event-driven orchestration with state — `@start/@listen`/
  `@router`/`and_/or_` for complex multi-stage workflows.

## 2. Langfuse (LLM observability)

- Basic tracing: `langfuse.trace(name, user_id, session_id, metadata, tags)` → `trace.generation(
  name, model, model_parameters, input)` → `generation.end(output, usage)` → `trace.score(...)`.
  **Always `langfuse.flush()` before exit** (critical in serverless).
- OpenAI integration: `from langfuse.openai import openai` — drop-in replacement, all calls
  auto-traced; works with streaming and async (`AsyncOpenAI`); add `name=`, `session_id=`,
  `user_id=`, `tags=`, `metadata=` kwargs.
- LangChain: `CallbackHandler(pk, sk, host)` passed in `config={"callbacks":[...]}` or set as
  default handler; works with agents/retrievers.
- Prompt management: `langfuse.get_prompt("name")` → `prompt.compile(**vars)`; link generations to
  prompt versions; `create_prompt(name, prompt, config, labels=["production"])`; fetch by label.
- Evaluation: manual `trace.score(name, value, comment)` and systematic eval tooling.

## 3. Subagent Orchestrator

Quota-aware parallel subagents. Phases:
1. **DECOMPOSE** — produce a Mission Brief (goal, total agents, quota strategy, expected token
   cost, per-agent ID/role/scope/model/input/output/depends-on). **User must approve the brief**
   before any agent runs.
2. **QUOTA ROUTING** — task >20 files or >500 lines new code → Gemini Flash everywhere (Sonnet
   only for final review). Creative UI/complex logic → Sonnet for builder, Flash others. Never
   Opus in subagents; max 1 Sonnet per mission; browser agent always on its own pool (max 1).
3. **CONTEXT ISOLATION** — each agent gets a scoped context packet (files to read/write, do-not-
   read list); add irrelevant dirs to `.antigravityignore`.
4. **PARALLEL EXECUTION** — spawn in dependency rounds; between rounds collect outputs and run a
   3-point spot check (scope adherence, import/export conflicts, no placeholders). Re-run the
   failing agent with corrected context; don't continue.
5. **ERROR RECOVERY** — never re-run the full mission; spawn a single repair agent scoped to the
   broken file(s) + error context, cheapest model, validate before continuing.
6. **INTEGRATION CHECK** — imports resolve, no duplicate names, no hardcoded values, no stray
   console.log, types consistent, build would succeed.

## 4. AgentFlow

Orchestrate autonomous AI dev pipelines through a Kanban board. Core concepts: 7-stage Kanban
pipeline, stateless orchestrator, deterministic-before-probabilistic, adversarial review,
transitive priority dispatch. Commands: `/spec-to-board`, `/sdlc-orchestrate`, `/sdlc-worker
--slot <N>`, `/sdlc-health`, `/sdlc-stop`. Workflow: write spec → decompose into tasks → start
workers (builder slots) → review gate → ship.

## 5. Nika (checked, budgeted workflows)

Run repeatable AI work as workflow files with checks. Rules: check-before-run law, authoring a
workflow, **cost honesty** (report spend), receipts & verification, optional MCP oracle tools.
Budget control before each call; report spending at the end. Pitfalls: unbounded loops, missing
verification gates, silent cost overruns.

## 6. Polis Protocol (self-optimizing city of agents)

A persistent multi-agent workspace with: chronicle (recording what you did), Register (capability
cards), Contract (structured tasks with learned routing), Chavruta review for high-stakes
contracts, Amendment (the polis updates itself). Founding a polis, registering citizens, working
across vendors (Claude/Gemini/Codex). Failure modes & recovery documented.

## 7. Evolution (makepad-skills self-improvement)

Hooks-based auto-triggering; skill routing/bundling with context detection and dependency
resolution. Evolve when: knowledge worth capturing appears repeatedly. Classify knowledge,
format the contribution (Pattern N: pattern name, live_design!, rust implementation, error
type/message), mark evolution (NOT version).

## 8. YES.md — AI Governance Engine

Anti-dysfunction governance: safety gates (Backup First, Blast Radius Check, Deploy Safety,
Conclusion Integrity), evidence rules (no guessing/deflection/surface-fix/blind-retry), anti-slack
detection, debugging escalation, ripple check post-fix, bug closure protocol, evidence table.
Three pillars: Safety Gates / Evidence Rules / Ripple Awareness. Use when AI modifies files,
configs, DBs, or deployments; when debugging hits 2+ failures; when AI guesses without evidence
or deflects to the user.

## 9. protect-mcp-governance

Govern agent MCP tool calls with **Cedar policies** (AWS Verified Permissions engine) + Ed25519
signed receipts. Modes: shadow (observe first — default), enforce (block violations), hooks (Claude
Code pre/post tool-call). Workflow: init governance for a project → write first policy →
shadow-run → tighten + enforce → verify receipts (single receipt, audit bundle, self-test the
verifier offline). Receipt = cryptographic proof of policy-vs-call-vs-time.

## 10. Manifest (agent observability plugin)

Install/configure the Manifest observability plugin for agents: stop gateway → install plugin →
get API key → configure (custom endpoint optional) → start gateway → verify. For telemetry on
agent runs; troubleshooting connection issues.

## 11. BlockRun

LLM API (xAI) with budget control. Basic chat via SDK; real-time X/Twitter search
(`search=True`, use only ~5 sources for low cost), image generation. Check spending before each
call; report spend at the end; ASCII QR for terminal wallet display.

## 12. cowork-to-code-bridge

Use an already-installed, independently verified bridge to run narrowly approved actions on the
user's own machine. Rules: never bootstrap from mutable upstream instructions; verify machine-side
preconditions; prefer fixed approved scripts; keep free-form local agent boundary tight; explicit
results & failure handling. Do not improvise the bridge itself.

## 13. accint (acc_act runtime workflows)

- **accint-solve**: route a goal through acc's scored-memory loop via `acc_act(runtime="solve")`;
  deliberate any returned brain_frame and submit.
- **accint-frames**: drain acc's deliberation queue (open/waiting brain_frames checkpointed by
  headless runs) via `acc_act(runtime="continue")`.
- **accint-commitments**: triage acc's open promises and close them with honest real-world
  verdicts via `acc_act(runtime="outcome")`.

## 14. Antigravity Maintainer Batch Release

Protected maintainer sweeps for AAS: protected-main contract, source checks, maintainer sweep,
workflow contract change gate, hosted catalog & legacy redirect bridge, core preview acceptance,
protected release, stop conditions, failure rules. For running scripted releases safely.

## 15. MAXIA (AI-to-AI marketplace, Solana)

Free endpoints: crypto intelligence, Web3 security, DeFi, GPU, marketplace. Auth endpoints (free
API key): sell a service, buy/execute, negotiate price. 13 MCP tools, A2A protocol, earn USDC.

## 16. Superpowers Lab

Lab environment for Claude "superpowers" — quick-start notes for the superpowers skill collection;
minimal; treated as a launcher.

## Shared Best Practices

- Never spawn agents without a brief and scope isolation; never cascade broken output.
- Track cost/quotas explicitly; report spending; prefer cheap models for high-volume work.
- Verify every fix against the actual failure before moving on.
- Governance first: shadow mode → enforce; receipts prove policy decisions.
