# Tool Use & MCP Servers

Designing tool interfaces so agents can reliably use external systems — MCP server development. Consolidated from `mcp-builder` and `mcp-builder-ms` (incl. their best-practices reference), plus tool-design guidance from `ai-agents-architect`.

## Table of contents

1. [MCP concept and workflow](#mcp-concept-and-workflow)
2. [Designing tools for agents](#designing-tools-for-agents)
3. [Language & transport selection](#language--transport-selection)
4. [Implementation](#implementation)
5. [Security](#security)
6. [Testing the server](#testing-the-server)
7. [Evaluating the server with realistic questions](#evaluating-the-server-with-realistic-questions)
8. [Microsoft MCP ecosystem](#microsoft-mcp-ecosystem)

---

## MCP concept and workflow

The Model Context Protocol lets LLMs interact with external services through well-designed tools. The quality of an MCP server is measured by **how well it enables LLMs to accomplish real-world tasks**.

Four phases: (1) research and planning, (2) implementation, (3) review and test, (4) evaluation with realistic questions.

Protocol reference: start from `https://modelcontextprotocol.io/sitemap.xml`, fetch pages with a `.md` suffix (e.g., `/specification/draft.md`). Load SDK READMEs from the Python / TypeScript SDK repos. Use the MCP Inspector (`npx @modelcontextprotocol/inspector`) to test.

---

## Designing tools for agents

- **API coverage vs. workflow tools.** Balance comprehensive endpoint coverage with higher-level workflow tools. When uncertain, prioritize comprehensive API coverage — it gives agents flexibility to compose operations.
- **Naming.** snake_case with a service prefix so the server can coexist with others; action-oriented verbs. `github_create_issue`, `slack_send_message` — never bare `create_issue`.
- **Context management.** Concise tool descriptions; results filterable and paginated; tools return focused, relevant data.
- **Actionable errors.** Error messages guide agents toward solutions with specific next steps ("Try using filter='active_only' to reduce results").
- **Descriptions must match behavior exactly.** Tool descriptions must narrowly and unambiguously describe what the tool does — agents route on them.
- **Annotations:** `readOnlyHint`, `destructiveHint`, `idempotentHint`, `openWorldHint`. Hints only — never a security boundary.

---

## Language & transport selection

| Language | Best for | SDK |
|---|---|---|
| TypeScript (recommended) | General servers, broad compatibility | `@modelcontextprotocol/sdk` |
| Python | Data/ML pipelines, FastAPI integration | `mcp` (FastMCP) |
| C#/.NET | Microsoft/Azure enterprise | `Microsoft.Mcp.Core` |

| Transport | Use case | Notes |
|---|---|---|
| Streamable HTTP | Remote servers, multi-client, cloud | Bidirectional, stateless option; requires auth |
| stdio | Local integrations, desktop, single-user | Simple; never log to stdout (use stderr) |

Avoid deprecated SSE. For remote servers, prefer stateless JSON over stateful sessions for scale and maintainability.

---

## Implementation

Project scaffolding and tool registration per language (see SDK README; patterns below).

**Input schema:** Zod (TS) or Pydantic (Python) with constraints, clear descriptions, and examples in field descriptions.

**Output schema:** define `outputSchema` where possible; use `structuredContent` in tool responses (TS SDK) so clients can process outputs programmatically; also return readable text.

**Per-tool implementation:** async/await for I/O; proper error handling with actionable messages; pagination support where applicable (respect a `limit` param, return `has_more` / `next_offset` / `total_count`; default 20–50 items); never load entire datasets into memory.

**Shared utilities:** API client with auth, error-handling helpers, response formatting (JSON + Markdown), pagination helpers.

**Response formats:** support both JSON (programmatic) and Markdown (human-readable default) where it improves agent experience.

**Naming:** Python server `{service}_mcp`; Node `{service}-mcp-server`; no version numbers in the name.

**Annotations defaults:** `readOnlyHint=false`, `destructiveHint=true`, `idempotentHint=false`, `openWorldHint=true`.

---

## Security

- **AuthN/AuthZ:** OAuth 2.1 with certificates from recognized authorities; validate access tokens before processing; accept only tokens intended for your server. API keys in environment variables, validated at startup, never in code.
- **Input validation:** sanitize file paths (directory traversal), validate URLs/external identifiers, check parameter sizes/ranges, prevent command injection in system calls, schema-validate all inputs.
- **Errors:** standard JSON-RPC error codes; report tool errors inside the result (not protocol-level errors); helpful-but-not-revealing messages; log security-relevant errors server-side; clean up resources on errors.
- **DNS rebinding (local streamable HTTP):** validate the `Origin` header, bind to `127.0.0.1` not `0.0.0.0`.
- **Testing:** functional, integration, security (auth, sanitization, rate limiting), performance under load/timeouts, and error handling.

---

## Testing the server

- **TypeScript:** `npm run build` then MCP Inspector.
- **Python:** `python -m py_compile your_server.py` then MCP Inspector.
- Review for DRY, consistent error handling, full type coverage, clear tool descriptions.
- Verify each tool with at least a couple of valid/invalid input cases and confirm errors are actionable.

---

## Evaluating the server with realistic questions

After implementing, create 10 realistic evaluation questions to test whether an LLM can actually use your server end-to-end.

**Process:** inspect the tools → explore available data with READ-ONLY operations → generate 10 complex, realistic questions → verify each answer yourself beforehand.

**Question requirements:** independent (not dependent on others); read-only (non-destructive); complex (multiple tool calls / deep exploration); realistic (human-relevant use cases); verifiable (single clear answer, comparable by string); stable (answer won't change over time).

**Output format:**

```xml
<evaluation>
  <qa_pair>
    <question>Find the project created in Q2 2024 with the highest number of completed tasks. What is the project name?</question>
    <answer>Website Redesign</answer>
  </qa_pair>
</evaluation>
```

**Running evaluations** (script-style CLI; requires `pip install anthropic mcp` and an `ANTHROPIC_API_KEY`):

```bash
# stdio: script launches the server for you
python scripts/evaluation.py -t stdio -c python -a my_mcp_server.py -e API_KEY=abc123 evaluation.xml
# sse/http: start the server first, then connect
python scripts/evaluation.py -t http -u https://example.com/mcp -H "Authorization: Bearer token123" evaluation.xml
# save report
python scripts/evaluation.py -t stdio -c python -a my_server.py -o evaluation_report.md evaluation.xml
```

`-t {stdio,sse,http}` · `-m MODEL` · `-c COMMAND` · `-a ARGS` · `-e KEY=VALUE` · `-u URL` · `-H "Key: Value"` · `-o OUTPUT`.

The report gives accuracy (correct/total), average duration, average/present tool calls per task, per-task pass/fail, the agent's approach summary, and the agent's feedback on your tools — use that feedback to improve descriptions, parameter docs, and error messages.

---

## Microsoft MCP ecosystem

Before building custom, check whether Microsoft already provides a server:

| Server | Type | Covers |
|---|---|---|
| Azure MCP | Local | 48+ Azure services (Storage, KeyVault, Cosmos, SQL…) |
| Foundry MCP | Remote (`https://mcp.ai.azure.com`) | Models, deployments, evals, agents |
| Fabric MCP | Local | Microsoft Fabric, OneLake, item definitions |
| Playwright MCP | Local | Browser automation/testing |
| GitHub MCP | Remote | GitHub |

Guidance: Azure service integration → use Azure MCP; AI Foundry agents/evals → Foundry MCP; custom internal APIs or third-party SaaS → build custom. C#/.NET pattern: command hierarchy (BaseCommand → GlobalCommand → SubscriptionCommand), naming `{Resource}{Operation}Command`, optional args with `.AsRequired()`/`.AsOptional()`.