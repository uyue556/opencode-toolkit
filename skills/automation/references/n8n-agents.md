# n8n AI Agents

Design guide for the n8n AI Agent node (`@n8n/n8n-nodes-langchain.agent`) and the LangChain family around it.
For the high-level "where the agent fits in the workflow" shape, see `n8n-workflows.md`.

## Pick the right node first

Reaching for an Agent when the task is one-shot classification or extraction is the most common over-build.

| You need to… | Use | Why |
|---|---|---|
| Call tools, reason over multiple turns, hold memory | **AI Agent** (`.agent`) | Full loop: model + tools + memory + optional parser |
| One-shot text in → text out, no tools | **Basic LLM Chain** (`.chainLlm`) | No agent loop, easier to debug |
| Route natural language to one of N branches | **Text Classifier** (`.textClassifier`) | ONE node, N output handles. Not Agent + Switch. |
| Pull structured fields from free text | **Information Extractor** (`.informationExtractor`) | Purpose-built extraction with schema |
| 3-way sentiment split | **Sentiment Analysis** (`.sentimentAnalysis`) | Built-in branch outputs |
| Condense a long document | **Summarization Chain** (`.chainSummarization`) | Map-reduce built in |
| Generate image/audio/video | **Provider's native single-call node** | NEVER wrap media generation in an Agent — binary doesn't flow through tools or out of the agent |

Text Classifier detail: every category needs **name AND description** — the model routes against the *description*.
Set `options.enableAutoFixing: true` for edge inputs.

Node-type formats: workflow JSON uses long `@n8n/n8n-nodes-langchain.*`; `get_node`/`validate_node` use short `nodes-langchain.*`.

## The sub-node pattern

The Agent has a main input plus up to four sub-node slots, each wired by its own connection type:

| Slot | Connection | Node example |
|---|---|---|
| model | `ai_languageModel` | `.lmChatOpenAi`, `.lmChatAnthropic`, `.lmChatOpenRouter` |
| memory | `ai_memory` | `.memoryBufferWindow`, `.memoryPostgresChat` |
| tools | `ai_tool` | native tool nodes, `.toolWorkflow`, `.toolHttpRequest`, `.mcpClientTool` |
| outputParser | `ai_outputParser` | `.outputParserStructured` |

In workflow JSON the connection lives on the **sub-node** (`"Simple Memory": {"ai_memory": [[{"node": "AI Agent", ...}]]}`).
Multiple tools stack into the same `ai_tool` index 0. The agent's final answer is **`$json.output`**.

## Two non-negotiables

1. **Tool names and descriptions ARE part of the prompt.** The model picks a tool by reading name + description —
   nothing else. `tool1` with an empty description is invisible to the model. Treat them like API design.
2. **Structured output must parse AND autoFix.** `outputParserStructured` with `autoFix: true` and a
   **coding-capable fixer model** (wire a second model into the parser's `ai_languageModel` slot). Without autoFix,
   one malformed JSON response halts the workflow.

## Strong defaults

- **Per-tool usage goes in the tool description, not the system prompt** — so it travels across agents and keeps the prompt focused.
- **Sub-workflow tools (`.toolWorkflow`) for anything multi-step.** Default here when in doubt.
- **Wrap side-effect tools in human review** (sends, payments, refunds, account changes): `.slackHitlTool` etc.
  The approval message must show the **literal** `{{ $tool.parameters.<name> }}`, never a `$fromAI` paraphrase.
- **Raise `maxIterations`** — the default is low (single digits) and surfaces as "max iterations reached"/empty output.
  15 for a focused sub-agent, 50-200 for a broad orchestrator.
- **Put the current date in the system prompt** via `{{ $now }}` — a hardcoded date is stale immediately.

## The four tool types (pick the lightest)

| Tool type | Node | Use when |
|---|---|---|
| Native tool node | `slackTool`, `gmailTool`, `toolCalculator` | Capability = one existing node + one operation |
| Sub-workflow as tool | `.toolWorkflow` | More than one node, reusable, independently testable — **default** |
| HTTP Request Tool | `.toolHttpRequest` | A single external API the agent should orchestrate |
| MCP Client Tool | `.mcpClientTool` | A maintained MCP server already covers it |
| Custom Code Tool | `.toolCode` | Pure inline computation — but string-in/out, no `$fromAI` (see `n8n-code.md`) |

### `$fromAI()` — how the agent fills tool parameters

```
={{ $fromAI('paramName', 'what to put here — be specific: format, range, example', 'string') }}
```

- `paramName` — the name the model uses (consistent snake/camel case).
- description — **part of the prompt**, write it like JSDoc.
- type (optional): `'string'` default, `'number'`, `'boolean'`, `'json'`.
- `$fromAI()` carries JSON only — **no binary**.
- **Plumb identity/authority/limits deterministically** (`userId`, refund caps, `sessionId`) from workflow context so
  the agent can't get them wrong or even see them.

## System prompt vs tool description

| System prompt | Tool description |
|---|---|
| Persona, role, voice | What this tool does |
| Global output/format rules | When to use it vs other tools |
| Refusal/safety behavior | What each parameter means and its shape |
| Display protocols | Examples of good vs bad invocations |
| Universal context (`$now`, user role) | Tool-specific gotchas (rate limits, edge cases) |

A well-described tool works in any agent that drops it in; tool details only "load" when the model considers that tool (token efficiency).

## Structured output

Add an `outputParserStructured` sub-node when downstream needs strict JSON.

1. Use `schemaType: 'manual'` with a real **JSON Schema** (required-vs-optional, enums, ranges, array constraints),
   not `jsonSchemaExample`. Reach for `fromJson` + example only for throwaway shapes.
2. `autoFix: true` + a coding-capable fixer model.

## Memory

Without a memory sub-node, every call is stateless (correct for one-shot tasks). With it, the agent holds a
conversation keyed by whatever expression you bind to `sessionKey`.

- `memoryBufferWindow` — keeps the last N exchanges per key, persists via n8n's store. Default `contextWindowLength`
  is **5, which is very low** — 50 is a saner start.
- `memoryPostgresChat` / `memoryRedisChat` — only when memory must be read *outside* the agent.
- **Plumb a stable key from the trigger** (Slack `thread_ts`, a webhook conversation ID). Never hardcode
  `sessionId: 'default'` and never put `sessionId` behind `$fromAI` (the model will fabricate a UUID).

## Binary and the agent boundary

- The model CAN see uploaded images (vision) via `options.passthroughBinaryImages: true` — image-only.
- Tools CANNOT receive binary (`$fromAI` is JSON-only). **Pre-stage uploads to storage, inject storage keys into
  the system prompt, let tools accept the key as a string and re-fetch.** (Mechanics in `n8n-advanced.md`.)
- The agent's output is text-shaped — media bytes don't survive. Use the provider's native node for media generation.

## Chat agents (Slack, Discord, Teams, Telegram)

**Non-negotiable:** any chat-triggered workflow that posts a reply MUST filter out the bot's own user ID or its own
replies re-trigger it in an infinite loop. Prefer trigger-level exclusion (Slack Trigger `options.userIds` is an
**exclusion** list — put the bot ID there); otherwise filter `$json.user !== '<BOT_USER_ID>'` in the first node.

Split into **shell + core + sub-agents** once you need loading UX, sub-agents, multi-surface reuse, or robust errors:
shell = trigger + anti-loop filter + event Switch + loading/error UX (no LLM); core = stateless agent with `chatInput`
+ `threadId` inputs and memory keyed on `threadId`; sub-agents = one narrow domain each via `.toolWorkflow`, stateless.

## RAG

Rule out cheaper lookups first: exact lookups → DB/Data Table query; freshness → a live search tool; small doc set →
list/fetch tools. Reach for a vector store only when docs are too many to list and queries are semantic.
Wire the vector store as a **retrieval tool** (`mode: 'retrieve-as-tool'`, `ai_tool`) so the agent decides when
retrieval is relevant. Embed query and documents with the **same** model.

## Anti-patterns

| Anti-pattern | Fix |
|---|---|
| Generic tool names (`tool1`, `doStuff`) | Verb-first specific names: `Search customer database` |
| Empty/one-line tool descriptions | Real description: what it does, when to use, parameter meaning |
| Per-tool instructions crammed in system prompt | Move them into tool descriptions |
| Agent + Switch to route natural language | Text Classifier (one node, N outputs) |
| Wrapping media generation in an Agent | Provider's native single-call node |
| `outputParserStructured` without autoFix | `autoFix: true` + coding-capable fixer model |
| Passing binary to a tool | Pre-stage to storage, pass keys |
| Hardcoded `sessionId` / `$fromAI` sessionId | Plumb a stable key from the trigger |
| Two near-identical tools | One tool with internal branching driven by a parameter |
| Chat bot with no bot-user filter | Exclude bot ID at trigger or first node |
| `maxIterations` at low default | Raise it |
| Human-review message built with `$fromAI()` | Show literal `{{ $tool.parameters.<name> }}` |

## Checklist

Right node (Agent vs Classifier vs Extractor vs native); model wired via `ai_languageModel`; every tool has a
verb-first name + real description; identity/limits/sessionId plumbed deterministically; `$now` in system prompt;
`maxIterations` raised; memory keyed on stable `sessionKey` with `contextWindowLength` raised; structured output =
manual schema + autoFix + coding-capable fixer; destructive tools in human review showing real params; bot filter in
place; validated with `validate_workflow` and verified with `n8n_get_workflow` (sub-nodes on `ai_*`, not `main`).

Note: the deep `ai_agents_guide` also lives in `tools_documentation({topic:"ai_agents_guide", depth:"full"})`.
