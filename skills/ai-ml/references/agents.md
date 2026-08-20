# Agents, Tool Use & Orchestration

Merged from: `autonomous-agent-patterns`, `autonomous-agents`, `multi-agent-architect`,
`agent-tool-builder`, `tool-design`, `agent-orchestrator`, `agent-orchestration-*`,
`agent-creator`, `agent-squad`, `bdi-mental-states`, `computer-use-agents`,
`agentphone`, `agentmail`, `voice-agents`, `voice-ai-engine-development`,
`loki-mode`, `odw`, `loopy`, `agents-md`, `subagent-orchestrator`.

## 1. Agent loop fundamentals
Standard loop: **observe** (read state/tool output) → **think** (decide next
action) → **act** (call a tool / emit final answer) → **reflect** (update
memory/state). Rules:

- Every loop needs a **termination condition**: max iterations, budget cap, time
  bound, or a success/failure predicate. Never a bare `while True`.
- Track and log the full trajectory (input, tool calls, outputs, decisions) for
  replay, debugging, and eval.
- Checkpoint/restart: if the loop dies, it should be resumable from the last
  good state.
- Deterministic escapes: a human-interrupt path and a bounded retry with backoff.

## 2. Tool design
Good tools are the difference between capable and useless agents.

- **Name & description**: describe when to use it, the inputs/outputs, and any
  side effects. Be specific: "use when…"; ambiguous descriptions cause wrong picks.
- **Schema**: strict typed params; use enums where the space is closed; document
  units, formats, and defaults.
- **Narrow tools over broad ones**: many small tools beat a giant kitchen-sink
  tool — easier to reason about, easier to validate, easier to sandbox.
- **Feedback**: return structured results (success, data, error) not prose, so
  the agent can act on them. Include error codes and hints.
- **Idempotency**: make mutating tools safe to retry.
- **Guard rails**: permission checks, budget checks, and confirmation for
  destructive ops inside the tool, not just in the prompt.

## 3. Tool-calling & MCP
- Prefer the provider's native tool-call/function-calling API (structured,
  validated) over forcing the model to emit tool JSON in text.
- MCP (Model Context Protocol) standardizes tool + resource access: one client
  can talk to many servers (filesystem, browser, DB, APIs). Define tools as MCP
  when you want portability across agents.
- Validate every tool argument before execution; sanitize file paths and shell
  commands rigorously.
- Present tool results as first-class context (fenced, labeled) so the model can
  cite and reason over them.

## 4. Multi-agent & orchestration
- **Roles**: planner → executor(s) → critic/verifier; or specialist agents
  (researcher, coder, reviewer). Each subagent gets a focused system prompt and
  its own budget/scope.
- **Patterns**:
  - *Orchestrator–worker*: one coordinator decomposes work, delegates, collects.
  - *Pipeline/sequential*: each stage hands off to the next.
  - *Debate/critic*: independent answers + critique loop (costly; use sparingly).
  - *Hierarchical teams* (squad): subagents with a lead; scope must be explicit.
- Keep the orchestration logic **in code**, not in the prompt: the control flow
  (who calls whom, merging) should be deterministic and testable.
- Pass compact context between agents (summaries + references), not giant blobs.
- Fail fast: if a subagent errors, retry bounded, then degrade gracefully.

## 5. Agent memory & state
- Working memory (per task) + long-term memory (cross-session facts).
- Use structured memory (typed entries, metadata, timestamps) for reliable
  retrieval; avoid freeform narrative blobs.
- Summarize + compress history under budget pressure (see `prompt-context.md`).
- Persist state between runs; design schemas for resumability.

## 6. Computer-use agents (browser/desktop)
- Browser automation via Playwright/Puppeteer/Chrome DevTools (or MCP browser
  servers): screenshot-driven perception + accessibility tree for grounding.
- Take screenshots after each action to verify the effect; feed the DOM/AX tree
  (not raw pixels) to the model for reliability.
- Keep a DOM-action language: `click(selector)`, `type(text)`, `navigate(url)`,
  `wait(condition)`, `extract(...)`, `screenshot()`.
- Bound: page/time limits, allowlist domains, no secrets typed into forms
  without confirmation.
- Voice interfaces (phone/voice agents): use streaming ASR → LLM → TTS
  (e.g., Twilio + STT/TTS), with interruption handling and call state machines;
  define slot-filling dialogs and fail-safes for silence.

## 7. Human-in-the-loop
- Define which actions require approval (payments, deletes, external sends,
  irreversible state changes). Gate them in the tool layer.
- Provide a clean approve/reject/edit surface for the human; stream progress.
- Fallback: when the agent is uncertain or hits a guardrail, hand back to human
  with context instead of guessing.

## 8. Reliability & safety
- Budget caps (cost + iterations) enforced in code — never trust the prompt alone.
- Rate limits and concurrency bounds; retry with exponential backoff + jitter.
- Injection defense: tool outputs and web content are untrusted; fence them and
  prevent the model from acting on instructions found in data.
- Sandbox untrusted tool execution (containers, read-only FS, no network) where
  feasible.
- Eval: keep a trajectory test suite (see `evaluation.md`) — replays of known
  scenarios with expected tool calls.

## Checklist before shipping an agent
- [ ] Termination: max iterations, cost cap, timeout — all enforced in code.
- [ ] Every tool: typed schema, description, error feedback, idempotent.
- [ ] Destructive tools require human approval.
- [ ] Full trajectory logging for replay.
- [ ] Tool arguments sanitized (paths, shell, URLs).
- [ ] Injection-fenced prompts around tool/data content.
- [ ] Resumable state; failure degrades gracefully.
