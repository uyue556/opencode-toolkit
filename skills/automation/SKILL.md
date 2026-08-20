---
name: automation
description: >
  Design and build automation end-to-end: workflow platforms (n8n, Zapier, Make/Integromat),
  AI agents and sub-workflows in n8n, browser automation (Skyvern, BrowserAct, CDP/browser-harness),
  web scraping (Apify Actors + Crawlee), SaaS/app automation via MCP (Slack, Notion, Gmail/Outlook,
  HubSpot, Stripe, Zendesk, Intercom, ClickUp, Airtable, Shopify, SendGrid, Zoom, Google apps, CI/CD),
  scheduled/cron jobs, shell scripts, GitHub Actions, git automation, and API integration (Gemini).
  Use whenever the user mentions: 自动化, 工作流, 流程, workflow, automation, n8n, Zapier, Make,
  Integromat, trigger, 触发器, 定时任务, cron, schedule, 浏览器自动化, browser automation, Playwright,
  Skyvern, 爬虫, scraping, scrape, Apify, Actor, 抓取, MCP 自动化, Composio, Rube, 脚本, script,
  GitHub Actions, CI/CD, git 自动化, RPA, 邮件自动化, email automation.
risk: critical
---

# Automation

Consolidated guidance for building automation that is reliable, observable, and maintainable.
Routes to sub-topic references; read the file that matches the task, then the shared workflow below.

## When to use

- User wants to automate a business process, integration, or repetitive task ("make this run automatically").
- Task involves n8n, Zapier, Make, Skyvern, Apify, GitHub Actions, cron/scheduling, or any MCP-driven SaaS automation.
- Task involves browser automation, web scraping/extraction, or building a pipeline between apps.
- Task involves writing code nodes, agent tools, or scripts as part of an automation.
- User is auditing what could be automated (automation opportunity discovery).

## Core workflow (applies to every automation)

1. **Understand the trigger.** What starts it: event/webhook, schedule, manual, or change-detection? If scheduled, confirm timezone explicitly.
2. **Route to the right reference** (see Selection routing). Don't build with the wrong tool.
3. **Plan the flow first.** Trigger → validate → transform → act → handle errors. Start with the simplest shape that solves the problem; iterate, never one-shot.
4. **Resolve IDs and schemas before running.** Always inspect the live tool schema (search/`get_node`) rather than trusting memorized field names.
5. **Validate before activating.** Node/step validation, then a test run with sample data. Expect 2–3 validate→fix cycles as normal.
6. **Design failure to be visible.** Every path that can fail needs an error route, a status code/message that tells the truth, and (for unattended jobs) an alert.
7. **Document.** Descriptive names, a description with the contract (inputs/outputs), and who/what it notifies.

## Selection routing

| Task | Read | Notes |
|---|---|---|
| Pick Zapier vs Make vs n8n, or design a platform workflow | `references/workflow-platforms.md` | Zapier: simple+7000 apps; Make: visual branching+ops pricing; n8n: self-hosted+code |
| n8n workflow design, expressions, node config, validation, MCP tools | `references/n8n-workflows.md` | The 5 core patterns, `{{ }}` syntax, `$json.body`, operation-aware config |
| n8n Code nodes or Custom Code Tool (JS/Python) | `references/n8n-code.md` | Return formats, webhook `.body`, Python stdlib-only sandbox, Code Tool string-in/out |
| n8n AI agents, tool calling, memory, RAG | `references/n8n-agents.md` | Sub-node pattern, `$fromAI`, structured output, human review |
| n8n sub-workflows, error handling, binary/data | `references/n8n-advanced.md` | Typed inputs, `mode: each`, error outputs, `$json` vs `$binary` |
| Browser automation (fill forms, login, extract, screenshots) | `references/browser-automation.md` | Skyvern CLI, BrowserAct, CDP via browser-harness |
| Web scraping / data extraction at scale | `references/scraping-apify.md` | Apify actor selection, `run_actor.js`, actor development |
| Automate a specific SaaS app (Slack/Notion/CRM/helpdesk/email/… ) | `references/saas-mcp-automation.md` | Rube/Composio MCP pattern + per-app quick reference + Google OAuth + SendGrid |
| Scripts, cron/scheduling, CI/CD, GitHub Actions, git, API (Gemini) | `references/scripts-and-api.md` | Pipeline stages, safe git flow, Gemini SDK patterns |
| "What can I automate in my business?" audit | `references/discovery-audit.md` | 5-question intake → ranked opportunity list |

## Best practices

- **Start minimal, add complexity only when needed.** Progressive disclosure beats over-configuration.
- **Test with real data before going live.** Cover failure scenarios, not just the happy path.
- **Use the live schema, always.** Platform schemas change; search tools exist for a reason. Don't hardcode field names from memory.
- **Design for idempotency.** Store processed IDs, dedupe webhook events, make retries safe. Non-idempotent retries (sends, payments) cause duplicates.
- **Match status codes to cause.** 4xx = caller's fault (decide upstream), 5xx = your fault (error path). Never return 200 for an error body.
- **Bounded, noisy-failure retries.** Retry transient blips (`retryOnFail`, exponential backoff); let only persistent failures reach humans.
- **Never hardcode credentials** in parameters, prompts, workflows, or scripts — use platform credential systems / env vars / secret managers.
- **Watch cost.** Zapier tasks and Make operations are metered: batch, aggregate, filter before looping.
- **Assume every integration breaks eventually.** Apps update APIs, OAuth tokens expire. Document connections, monitor history.

## Do & Don't

**Do:**
- Do pick the lightest tool that covers the job (e.g. Text Classifier before Agent+Switch; Set node before Code node).
- Do name things discoverably (verb-first prefixes) and document the input/output contract.
- Do search before building — a reusable sub-workflow or actor may already exist.
- Do verify after every page-changing/state-changing action (screenshot, `validate`, read-back).
- Do keep secrets, scraped content, and untrusted data isolated (sanitize before shell/`eval`/queries).
- Do confirm the target environment before writes — wrong-instance writes usually fail silently.

**Don't:**
- Don't build automations in one shot — the working pattern is edit → validate → fix, repeatedly.
- Don't skip error handling because it "works in tests."
- Don't pass binary bytes through agent tools or chat surfaces — use storage keys/URLs.
- Don't type passwords into browser automation — use stored credentials.
- Don't ignore quota/task counts for loops and batch operations.
- Don't deploy unattended workflows without an alert path and a fallback channel.

## Examples

1. **Webhook → Slack notify.** Webhook trigger → Set (map fields) → Slack post. Add an error branch with an explicit responseCode.
2. **Daily report.** Schedule (explicit timezone) → HTTP fetch → Code aggregate → Email. Attach an Error Trigger workflow for failures.
3. **SaaS sync.** GitHub webhook → transform → Create Jira/HubSpot record → dedupe on ID stored in a table/spreadsheet.
4. **Agent with tools.** Chat trigger (exclude bot's own ID) → AI Agent (model + `toolWorkflow` tools + window memory + structured output w/ autoFix) → reply. Raise `maxIterations` for multi-tool agents.
5. **Scraping.** Pick an Apify actor from the use-case table, fetch its schema, run `run_actor.js`, summarize; offer follow-up actors.
6. **Form autofill.** Skyvern: classify task → session create → `act`/`type`/`click` → `validate` + screenshot. Never `type` passwords — use `login` with stored credentials.

## Common pitfalls

- **Webhook data lives under `.body`** — `{{$json.body.field}}`, not `{{$json.field}}`. The single most common n8n/Zapier mistake.
- **Wrong nodeType prefix** in n8n MCP (`nodes-base.*` vs `n8n-nodes-base.*`).
- **Half-wired error handling**: `onError` set but error output not wired (silent discard, run shows "succeeded").
- **Dropdowns want IDs, not labels.** Type text instead of selecting, or a dynamic value fails. Search/find the ID first.
- **Zap auto-disabled at 95% error rate**; tasks burned by loops; Make ops burned by retries.
- **Timezone drift** in scheduled triggers — set timezone explicitly, document it.
- **Binary stripped by JSON transforms** — re-attach `$binary` or Merge by position.
- **Treating the Custom Code Tool like a Code node** — it's string-in/string-out, no `$fromAI`.
- **Agent won't use a tool** — tool names/descriptions ARE the prompt; write them like an API.
- **Wrong environment/instance** — verify `current` instance before credential writes.

## Reference files

- `references/workflow-platforms.md` — Zapier/Make/n8n selection + core patterns + sharp edges
- `references/n8n-workflows.md` — n8n patterns, expressions, node config, validation, MCP tools
- `references/n8n-code.md` — Code nodes (JS/Python) + Custom Code Tool
- `references/n8n-agents.md` — AI agents, tools, memory, structured output, RAG
- `references/n8n-advanced.md` — sub-workflows, error handling, binary & multimodal data
- `references/browser-automation.md` — Skyvern, BrowserAct, CDP/browser-harness
- `references/scraping-apify.md` — Apify actor selection, running, developing, actorization
- `references/saas-mcp-automation.md` — Rube/Composio MCP per-app automation + Google OAuth + email
- `references/scripts-and-api.md` — cron/scheduling, CI/CD, git automation, Gemini API
- `references/discovery-audit.md` — automation opportunity audit
- `scripts/run_actor.js` — Apify actor runner (quick answer / CSV / JSON export)

## Limitations

- Platform schemas, node versions, and model availability vary by instance/version — always verify against the live target.
- Validation never proves side-effect safety (sends, writes, purchases), idempotency, or correct tool selection; inspect and test those separately.
- Some settings (n8n Error Workflow assignment, tags) are UI-only and must be handed to the user as exact UI steps.
- This skill chooses the tool and the approach; it does not authorize running state-changing automations or deploying to production without user approval.
