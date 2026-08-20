---
name: agent-orchestration-category-pointer
description: "Pointer to a library of 7 specialized Agent Orchestration skills. Use when working on agent-orchestration-related tasks."
risk: none
---

# Agent Orchestration Capability Library 🎯

This is a **pointer skill**. The 7 specialized Agent Orchestration skills are stored in a hidden vault to keep your startup context minimal.

## Available skills in this category

- **agent-self-scheduling** — Schedule AI agent runs with cron, loops, or external clocks while avoiding unsafe tight autonomous timers.
- **codex-subagent** — Launch Codex CLI as an isolated subagent for bounded coding, review, or verification tasks.
- **delegating-to-agents** — Delegate bounded work to other AI agents while preserving context, ownership, and progress checks.
- **goal-loop** — Draft and explain persistent goal-loop prompts for long-running agent work with clear stop conditions.
- **grok-build** — Delegate well-specified implementation tasks to xAI's Grok Build CLI running headlessly while the orchestrating agent plans, writes task specs, reviews every diff, and owns the result.
- **multi-agent-task-orchestrator** — Route tasks to specialized AI agents with anti-duplication, quality gates, and 30-minute heartbeat monitoring
- **orchestrate** — Coordinate focused subagents on substantial work, keep their ownership non-overlapping, and integrate verified results. Use for large-scope Codex tasks; keep trivial work with the coordinator.

## How to load a skill

1. Identify the skill name above matching your task.
2. Use `view_file` to read its `SKILL.md` from the vault:
   `/home/administrator/.config/opencode/skill-libraries/agent-orchestration/<skill-name>/SKILL.md`
3. Follow those instructions to complete the request.

**Vault path:** `/home/administrator/.config/opencode/skill-libraries/agent-orchestration`

> Do not guess best practices — always read from the vault first.

> ⚠️ **Anti-loop guard**: Do NOT invoke skills recursively or check for applicable skills before every response. Each skill should be loaded at most once per user request. If you have already identified and loaded the relevant skill for this task, proceed with execution — do not re-scan for skills.
