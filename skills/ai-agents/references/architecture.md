# Agent Architecture

Design principles, loop patterns, memory systems, and multi-agent architecture decisions. Adapted from `ai-agents-architect` and `multi-agent-patterns` (with their internal references).

## Table of contents

1. [Agent loop patterns](#agent-loop-patterns)
2. [Tool registry and tool specs](#tool-registry-and-tool-specs)
3. [Memory architectures](#memory-architectures)
4. [Planning and recovery](#planning-and-recovery)
5. [Multi-agent architecture](#multi-agent-architecture)
6. [Sharp edges](#sharp-edges)

---

## Agent loop patterns

### ReAct loop (Reason-Act-Observe)

For simple tool use with a clear action-observation flow.

- **Thought:** reason about the next step.
- **Action:** select and invoke a tool.
- **Observation:** process the tool result.
- Repeat until task complete or stuck — **always** with a max-iteration limit.

### Plan-and-Execute

For complex tasks needing multi-step planning.

- Planning phase: decompose the task into steps.
- Execution phase: execute each step.
- Replanning: adjust the plan based on results.
- Planner and executor can be separate models if desired.

### When to choose which

Use ReAct when the action path is short and tools are few; use Plan-and-Execute when the task has many steps or requires decomposition up front. If a turn ends but the goal is unmet and a verifiable stop condition exists, consider a goal loop (see `references/orchestration.md`).

---

## Tool registry and tool specs

### Tool registry

For many tools, or tools that change at runtime:

- Register tools with schema + examples.
- A tool-selector picks relevant tools for the task.
- Lazy-load expensive tools; track usage for optimization.
- **Keep 5–10 tools per agent.** More tools mean more confusion, higher latency, worse selection. Use a selection layer or specialized agents for large tool sets.

### Complete tool spec (mandatory)

Agents choose tools based on descriptions — the agent literally cannot know what it doesn't see:

- Clear one-sentence purpose.
- When to use (and when NOT to).
- Parameter descriptions with types, constraints, and examples.
- Example inputs and outputs.
- Error cases to expect, with recovery hints.
- Tool annotations when supported: `readOnlyHint`, `destructiveHint`, `idempotentHint`, `openWorldHint` (hints, not security guarantees).

### Error handling

- Return error messages to the agent (type + recovery hint). Let it retry or pick an alternative.
- Never swallow exceptions — silent failures become loud failures later.
- Log errors for debugging.
- Validate all tool inputs before touching external systems (Pydantic/Zod schemas).

---

## Memory architectures

- **Working memory:** current task context. Clear between tasks.
- **Episodic memory:** past interactions/results (e.g., session history via a checkpointer).
- **Semantic memory:** learned facts and patterns. Use RAG for retrieval from long-term memory.

Rules:

- Summarize rather than store verbatim.
- Filter by relevance before storing.
- Use RAG for long-term memory.
- Clear working memory between tasks.
- Checkpoint after each successful step; resume from last checkpoint on failure; clean up on completion.

---

## Planning and recovery

- **Checkpoint recovery:** save task state, memory, and progress after each successful step so long-running tasks survive failures.
- **Circuit breakers** for repeatedly failing tools.
- **Retry with exponential backoff** for transient errors (WebSockets, network calls).
- **Replan when evidence changes** — plans are living documents, not contracts.

---

## Multi-agent architecture

### Why multi-agent

Single agents hit context ceilings. Multi-agent systems partition work across context windows — the primary design benefit is **context isolation**, not role simulation. Cost reality: single agent ≈ 1× tokens, single agent with tools ≈ 4×, multi-agent ≈ 15×. Model selection often beats doubling tokens; use both strategies deliberately.

### Pattern 1: Supervisor / Orchestrator

```
User Query -> Supervisor -> [Specialist, Specialist, Specialist] -> Aggregation -> Final Output
```

- **When:** clear decomposition, cross-domain coordination, human oversight matters.
- **Advantages:** strict control, easy human-in-the-loop, plan adherence.
- **Disadvantages:** supervisor context is a bottleneck; supervisor failures cascade; the "telephone game" loses fidelity when the supervisor paraphrases sub-agent responses.

**Telephone-game fix:** give sub-agents a `forward_message` tool so they can pass final responses directly to the user without supervisor synthesis when appropriate.

### Pattern 2: Peer-to-peer / Swarm

- Handoff via explicit protocols (e.g., `transfer_to_agent_b()` returning the next agent).
- **When:** flexible exploration, emergent requirements, breadth-first search.
- **Advantages:** no single point of failure, scales for breadth-first work.
- **Disadvantages:** divergence risk without a state keeper; coordination complexity grows with agent count. Use convergence checks and TTL limits.

### Pattern 3: Hierarchical

Strategy (goals) → Planning (decomposition) → Execution (atomic tasks). Best for large projects with layered abstraction; watch for misalignment and error propagation between layers.

### Context isolation mechanisms

- **Full context delegation:** share the planner's context for complex subtasks (sub-agent gets its own tools but full context).
- **Instruction passing:** for simple subtasks, pass only the instructions needed.
- **File-system memory:** shared state via persistent storage to avoid context bloat; introduces latency and consistency challenges.

### Consensus and coordination

- **Weighted voting** by confidence/expertise — naive majority lets weak models' hallucinations weigh the same as strong reasoning.
- **Debate protocols:** adversarial critique across rounds often beats collaborative consensus on complex reasoning.
- **Trigger-based intervention:** watch for stall and sycophancy markers (agents mimicking each other without unique reasoning).

### Framework considerations

- **LangGraph:** graph-based state machines (explicit nodes/edges, `references/frameworks.md`).
- **AutoGen:** conversational/event-driven, GroupChat.
- **CrewAI:** role-based process flows, hierarchical crews.
- **PydanticAI:** typed agents + tool handoffs (`references/frameworks.md`).

### Failure modes

| Failure | Mitigation |
|---|---|
| Supervisor bottleneck | Constrain worker output schemas; checkpoint supervisor state; direct pass-through of final responses |
| Coordination overhead | Minimal communication; clear handoff protocols; async patterns; batch results |
| Divergence | Per-agent objective boundaries; convergence checks; time-to-live limits |
| Error propagation | Validate outputs before passing downstream; retry with circuit breakers; idempotent operations |

---

## Sharp edges

| Situation | Why it breaks | Fix |
|---|---|---|
| Agent loop without iteration limits | Runs forever, drains API credits, hangs app | max_iterations, max_tokens/turn, timeout, cost caps, circuit breakers |
| Vague/incomplete tool descriptions | Wrong tool selection, parameter errors, "agent can't do X" | Complete tool specs (see above) |
| Tool errors not surfaced to agent | Agent continues on wrong data | Return error type + recovery hints; let it retry |
| Storing everything in memory | Context overflow, stale references, token bloat | Selective memory, summarization, RAG, clear working memory |
| Too many tools (20+) | Wrong selection, slow responses, truncated tool lists | 5–10 tools per agent; selection layer; dynamic loading |
| Multiple agents when one suffices | Duplicate work, coordination overhead, debugging cost | Start single-agent; justify the overhead; verify true independence |
| No tracing/logging | Can't explain failures; hours of debugging | Log thought/action/observation; track tool calls, tokens, latency |
| Fragile parsing of agent output | Works sometimes; small prompt changes break it | Structured output; fuzzy matching; retry with format instructions |
