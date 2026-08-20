# Automation Discovery, Audits & Prompt Engineering

Front-of-the-funnel work: figuring out what *can* be automated, and sharpening the prompts that drive automations.
For "research an uncertain implementation question before writing code", see `browser-automation.md` (auto-research
pattern) — this file covers the audit and prompt-shaping pieces.

## Automation discovery audit

When the user asks "what can I automate in my business?" (or "show me automation opportunities"), run a structured
audit instead of guessing their stack.

### Step 1 — Intake (5 questions, one at a time)

1. **Role & team size** — what's your role, how many people on the team?
2. **Top 3 repetitive tasks** — most repetitive weekly tasks?
3. **Connected tools** — which tools do you actively use (Gmail, Calendar, Slack, Notion, Jira, Asana, HubSpot, ...)?
4. **Pain point** — which task costs the most time or causes the most errors?
5. **Automation goal** — save time, reduce errors, or hand off entirely?

Wait for each answer before moving on. Intake prevents wasted recommendations on tools the user doesn't use.

### Step 2 — Audit the stated stack

Surface concrete patterns per tool:

- **Gmail**: auto-labeling/routing, draft generation for recurring emails, invoice/attachment extraction to Drive or
  Notion, no-reply follow-up reminders.
- **Google Calendar**: meeting-prep summaries (agenda + attendee context), booking links with intake forms, post-meeting
  action-item extraction.
- **Slack**: daily standup collection → summary, keyword alerts routed to the right person, emoji-reaction approvals.
- **Task trackers** (Asana/Jira/Notion/Linear): auto-create tasks from email/Slack, status-update reminders, weekly
  overdue/blocked digest.
- **CRMs** (HubSpot/Salesforce/Pipedrive): lead scoring/routing, deal-stage follow-up sequences, contact enrichment on
  new leads.

Stay scoped to tools the user mentioned — don't recommend automations for tools they don't use.

### Step 3 — Prioritize on a 2x2

| | Low effort | High effort |
|---|---|---|
| **High impact** | Do first (quick wins) | Plan carefully |
| **Low impact** | Nice to have | Skip for now |

For the top 3 quick wins, report: what it does, which tools it connects, estimated time saved per week, and the
suggested implementation path (Zapier / Make / n8n / custom code). Start with no-code/low-code quick wins — earn the
right to build custom code.

### Step 4 — Output

Deliver a markdown **Automation Opportunity Report**: business context → top 3 quick wins → full ranked opportunity
list → a single recommended next step. Verification: user answered all 5 questions, received a ranked list, identified
at least one quick win they can start this week, and has a clear next step.

Reject the rationalizations: skipping intake, listing every possible automation (overwhelming kills adoption), and
recommending complex custom code first.

## Prompt engineering for automation

When turning a user request into a prompt that will drive an automation (an agent, an AI node, a tool description),
apply framework discipline:

- **Analyze intent first.** Is it a direct instruction, a vague goal, a debugging task, or a creative brief?
- **Ask clarifying questions only when the intent is genuinely ambiguous.** Don't interrogate for a clear request.
- **Pick a framework that fits** (from the source skill's library): RTF (Role/Task/Format), RODES (Role/Objective/
  Design/Edge cases/Steps), RISEN (Role/Instructions/Steps/End goal/Narrowing), Chain of Thought (step-by-step
  reasoning — good for debugging/math), Chain of Density (iteration for density), RACE/RISE/STAR/SOAP (situational
  answers), CLARITY.
- **ALWAYS:** preserve the user's original intent; output the optimized prompt ready to paste; ask before changing
  meaning. **NEVER:** silently drop constraints, invent requirements, or over-engineer a simple request.
- Examples: complex-but-clear prompts get a framework with no clarification round; code-debugging requests get Chain
  of Thought.

This pairs with the tool-description guidance in `n8n-agents.md` — a tool's name/description *are* a prompt, and the
same discipline (state when to use it, give an example, be specific) applies.
