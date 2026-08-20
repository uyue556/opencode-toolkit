# Workflow & Personal Productivity

Patterns for running productive sessions with a user: eliciting requirements, stress-testing
plans, building docs through dialogue, handoffs, setup walks, and reading context before
acting. The through-line: **ask one thing at a time, give recommended answers, patch rather
than overwrite, and never guess when you can ask.**

## Rich elicitation (before starting ambiguous work)

Fire when a request has **2+ ambiguous dimensions, each with 3+ viable answers**. Goal: a
correct first draft, not three revision cycles.

Trigger checklist (count how many apply):
- multiple valid output formats → ask format
- audience unknown → ask audience
- tone ambiguous → ask tone
- scope could be narrow or broad → ask depth/length
- technical vs simple unclear → ask technical level
- multiple strategic directions → ask which direction
- constraints unknown → ask constraints

If 2+ apply, ask. Method:
- Max 3 questions per round, grouped into one call; lead with a 1–2 sentence framing.
- Mark exactly **one** option per question as **(Recommended)** (the lowest-risk / most-common
  default — "no preference" is rarely true).
- Re-run the checklist after each round; stop as soon as you have enough. Hard cap at 3 rounds;
  after round 3, state remaining assumptions and proceed.
- Each round must unlock *new* dimensions, not re-ask resolved ones. Don't mechanically label
  rounds in the UI.
- Use `single_select` for mutually exclusive choices, `multi_select` for combinations.

Do **not** trigger for factual lookups, clearly scoped requests, or minor unknowns with a safe
default.

## Grilling (stress-test a plan before building)

Interview the user relentlessly about a plan until you reach a shared understanding:
- Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.
- For each question, **provide your recommended answer**.
- Ask questions **one at a time**, waiting for feedback before continuing — asking several at
  once is bewildering.
- If a question can be answered by exploring the codebase, explore the codebase instead.
- Variants: `grill-with-docs` (retains what it learns in `CONTEXT.md` + ADRs; use when there's
  a codebase), `grill-me` (stateless, no codebase).

## Interview-style doc building (the file IS the conversation)

The user's preferred mode for durable strategic docs (life priorities, principles, ranked
lists, reviews). AI does **not** propose content.
1. Create the file with a skeleton (header, sections, "to be filled in" placeholders) — one
   write. After that, **NEVER overwrite — only patch**.
2. Ask **ONE** concise, specific, single-faceted, open-ended question.
3. Wait for the answer.
4. **Patch the file with the user's words before asking the next question.** Order is
   answer → patch → ask next, never reversed.
5. Repeat until complete.

Hard rules:
- Never dump multiple questions in one message (bundling 2 also violates this).
- **User lists are unordered sets.** When the user lists items, do not infer rank or priority
  from typing order; ask explicitly "Which of these is #1?".
- Ask about the *dynamic*, not the name, when a person is referenced.
- No snark, no filler; no speculative additions ("anything else?" prompts) unless asked.
- Keep sections empty until the user supplies content; don't fill gaps with AI content.

## Brain-to-docs

Interview to turn project vision + decisions into README and ADR documentation. Same one-
question-at-a-time, patch-the-file loop; produce durable docs (README + ADRs) as you go.

## Read all ADRs first

Before summarizing architectural context or making decisions, **read every ADR** in the
project. A summary built from a subset misleads; decisions chain.

## Handoff (crossing sessions cleanly)

Compact the current conversation into a handoff document for a fresh agent, **saved to the
OS temp directory, not the workspace**:
- Include a "suggested skills" section for the next agent.
- Do not duplicate content already captured elsewhere (PRDs, plans, ADRs, issues, commits,
  diffs) — reference by path/URL.
- Redact sensitive information (API keys, passwords, PII).
- If the user passes arguments, treat them as a description of what the next session will
  focus on and tailor the doc accordingly.
- Use a handoff (fork to a fresh session) vs `/compact` (continue same thread, summarize old
  turns): handoff when you want a fresh window with current context preserved; compact at
  intentional phase breaks. Never compact mid-phase.

## Setup help

Walk the user through setup/installation **one step at a time**, keeping the remaining steps
visible in every response so they always know where they are. Don't batch steps or skip ahead.

## Markdown rendering in cmux

Displaying Markdown in a cmux pane reliably:
- **Never `move-surface` a markdown viewer** — the moved viewer renders blank (known bug).
- Option A: open it right the first time —
  `cmux markdown open /abs/path.md --direction right --focus false`; don't move it after.
- Option B: if conflicting right panes exist, close the unused ones first
  (`cmux list-panes --workspace "$CMUX_WORKSPACE_ID"` → close their surfaces), then open fresh.
- Anchor to `$CMUX_WORKSPACE_ID`; pass `--focus false`; only close panes the user isn't using;
  you can't screenshot a markdown surface to verify — ask the user if unsure.

## Interview coaching (job search)

For full job-search lifecycle coaching (JD decoding, resume/LinkedIn, mock interviews,
transcript analysis, comp negotiation, storybank), keep **persistent state** in a file
(`coaching_state.md`) so the coaching session picks up where it left off. Commands cover
`kickoff`, `prep <company>`, `analyze`, `salary`. This is a large dedicated system; only route
to it when the user explicitly wants job-search coaching.

## Router ("which flow fits?")

When the user asks which skill/flow fits their situation, route by situation rather than
reciting the whole catalog: an idea with a codebase → grill-with-docs; no codebase → grill-me;
multi-session build → PRD → issues → fresh session per issue; thread full or branching →
handoff; incoming bug reports → triage; personal context → context artifacts.

## Session hygiene

- Keep the core thinking (grilling → PRD → issues) in **one unbroken context window**; start
  each implementation in a fresh session from the issue.
- Respect the "smart zone" (~120k tokens): before it degrades, hand off.
