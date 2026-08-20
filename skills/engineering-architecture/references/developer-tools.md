# Developer Tools: MCP, VS Code Extensions, Routing, Tool Scoring, CLI

Sources: `mcp-tool-developer`, `vscode-extension-guide-en`, `tokenwise`, `clarvia-aeo-check`,
`gh-image`, `android-cli`. Tooling for building and choosing developer/agent tools.

## 1. Building MCP servers (`mcp-tool-developer`)

Use when: building an MCP server from scratch, wrapping an existing API as an MCP tool, debugging
MCP servers, designing tool schemas, publishing to a registry.

**Primitives:** Tools (functions the LLM can call — primary), Resources (data the LLM can read),
Prompts (reusable templates). **Transports:** stdio (local CLI tools), SSE (remote/hosted),
Streamable HTTP (new in MCP spec).

**Workflow:** define scope → design tool schema (input/output before implementation) → implement
with the official SDK (`@modelcontextprotocol/sdk` for TS, `mcp` for Python) → test with MCP
Inspector → deploy.

TypeScript example:

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

const server = new McpServer({ name: "my-tools", version: "1.0.0" });
server.tool("greet", "Greet someone by name",
  { name: z.string().describe("Person's name") },
  async ({ name }) => ({ content: [{ type: "text", text: `Hello, ${name}!` }] })
);
await server.connect(new StdioServerTransport());
```

**Best practices:** build small focused chainable tools, not monoliths; return structured errors
(never crash); define schemas before implementation; rich `description` text that helps the LLM
decide when/how to call; validate all inputs; rate-limit external calls; env vars for secrets.

**Pitfalls:** LLM passes wrong params → improve descriptions + add examples (the LLM reads them);
timeout on large inputs → input-size validation + pagination, stream large responses.

**Security:** never hardcode API keys; validate/sanitize inputs (injection); review permissions
(tools can access files/networks/execute code).

## 2. VS Code extensions (`vscode-extension-guide-en`)

Use when: creating an extension, adding commands/keybindings/settings, building TreeView/Webview
UI, publishing to Marketplace, troubleshooting activation/packaging.

Quick start: `npm install -g yo generator-code && yo code`. Build: `npm run compile` / `npm run
watch` (F5 to debug); package with `npx @vscode/vsce package` (→ `.vsix`).

Structure: `package.json` (manifest) · `src/extension.ts` (entry) · `out/` (compiled) ·
`images/icon.png` (128×128) · `.vscodeignore` (keep VSIX <5MB).

Best practices: unify package name, setting keys, command IDs, view IDs before publishing; test in
the Extension Development Host (F5) before packaging. Since VS Code 1.74, `activationEvents` are
auto-detected for contributed commands/views.

Troubleshooting: extension not loading → check activationEvents (auto-detected ≥1.74); command not
found → match command ID exactly between package.json and code; webview blank → check Content
Security Policy (use webview's `cspSource`).

## 3. Model routing for cost (`tokenwise`)

Measurement-driven router for Claude Code: route subtasks to the cheapest capable model, log every
routed task with real token/cost numbers, A/B test cheaper tiers before trusting savings.

Routing taxonomy: **Haiku** = mechanical (file reads, grep, format, rename, simple edits, doc
lookups); **Sonnet** = scoped reasoning (single-file refactor, scoped research, test writing);
**Opus** = synthesis (architecture decisions, multi-file refactor, security review).

Safety caps: Haiku never spawns subagents; max spawn depth 2; subagents needing a smarter model
return to parent (never escalate); tasks <100 chars with no file context run inline; subagent
context >30k tokens bumps a tier.

Privacy: zero telemetry; local `.tokenwise/log.ndjson`; task descriptions truncated to 80 chars,
file contents stripped.

## 4. Tool agent-readiness scoring (`clarvia-aeo-check`)

Score any MCP server/API/CLI for agent-readiness (0–100) across API accessibility, data
structuring, agent compatibility, trust signals. Query by URL or name, search 15,400+ indexed
tools, compare head-to-head, check leaderboards.

Add the MCP server: `npx -y clarvia-mcp-server`; then e.g. "Score https://github.com/… for
agent-readiness", "Find the top-rated database MCP servers using Clarvia", "Compare supabase-mcp
vs firebase-mcp".

Interpretation: 90–100 Agent Native · 70–89 Agent Friendly · 50–69 Agent Compatible · 30–49 Agent
Partial · 0–29 Not Agent Ready. Best practice: score before adding to long-running workflows;
don't skip scoring "well-known" tools; don't use <50-scoring tools in production agent pipelines
without understanding the limits; CI quality gate via `clarvia-project/clarvia-action@v1`.

## 5. GitHub image uploads (`gh-image`)

GitHub has no public upload API; `gh-image` (a `gh` extension) replicates the internal flow and
prints an embeddable Markdown line. Needs a GitHub `user_session` cookie (or `GH_SESSION_TOKEN`
env var in CI) — treat it like a password; use a bot account in CI.

```bash
gh auth status && gh extension install drogers0/gh-image
MD="$(gh image "/abs/path/screenshot.png" --repo owner/repo)"   # → ![screenshot.png](https://github.com/user-attachments/assets/<uuid>)
BODY="$(gh pr view <pr> --json body -q .body)"
printf '%s\n\n## Screenshots\n\n%s\n' "$BODY" "$MD" | gh pr edit <pr> --body-file -
```

Notes: private-repo images stay private (URL inherits repo visibility); write access required;
SAML SSO orgs need session authorized; use `--body-file -` (never inline `--body`) to avoid shell
quoting issues; for display sizing embed `<img width="800" src="…"/>`.

## 6. Android CLI (`android-cli`)

The `android` CLI orchestrates Android dev tasks. Install only from Google's official installer
URLs after review + user confirmation (never pipe network scripts straight into a shell).

Key commands: `android create empty-activity --name="My App" --output=./my-app`;
`android sdk install platforms/android-34` (also `update`/`remove`/`list`); `android run`
(deploy APKs), `android emulator create|start|stop|list|remove`; `android screen capture -o
<file>`; `android layout` (inspect UI layout tree as JSON — often faster than a screenshot);
`android docs search <keywords>` (authoritative API docs); `android describe` (project metadata);
`android info` (SDK location etc.).

Good practice: always verify device serials, package names, and install targets before running
destructive/install commands.