# Research Questions & Deep-Research Execution

Two halves: (1) turning a vague need into one precise deep-research brief
(*research-prompt*), and (2) executing it with a research engine
(*gemini-deep-research*, DeepAPI `/v1/research/deep`, batched web search from
*pi-web-search*).

## 1. The Deep-Research Brief

Goal: ONE self-contained paragraph a researcher with zero prior knowledge of
the project can act on with zero back-and-forth.

**Rules**

- **One paragraph.** No headers, no bullets in the deliverable.
- **Prompt the job, not the topic.** Give search handles (timeframe, ranking,
  source type, decision logic).
- **Assume zero prior knowledge.** Open by explaining in plain English what the
  project/product is, why it exists, and the current situation.
- **Lead with the goal + decision.** State the single question the research must
  answer and the decision/use it informs.
- **Embed all context.** Names, dates, product, prior known facts, constraints.
- **Number 3–6 sub-questions inline** (1, 2, 3…). One mission per prompt.
- **State constraints** — what to include, what to avoid ("only non-Chinese
  competitors", "no marketing fluff").
- **Source hierarchy.** Prefer primary sources (official docs, GitHub, papers,
  filings, changelogs); forums/X/Reddit are weak signal only, never factual
  proof.
- **Contradiction handling.** Separate confirmed facts / inference / unresolved
  uncertainty; don't force fake consensus; flag low-confidence claims.
- **Completion bar (define "done").** Corroborate each key claim with multiple
  independent primary sources where they exist; where scarce, say so explicitly.
  Keep going until every numbered sub-question is covered.
- **Gap round before finishing.** Require a self-critique pass: list gaps,
  contradictions, and single-source claims, then run another search round to
  close them — repeat until clean.
- **Constrain output hard, method loosely.** Strict deliverable; flexible search
  path.
- **Fixed per-finding output:** source link + specific claim + one-line "why it
  matters / why a viewer should care". Verifiable, citable facts only.
- **Last sentence:** output everything into a single detailed markdown file.

**Process to build it:** pull context from project files/conversation → write the
plain-English explainer → identify the ONE question → draft 3–6 numbered
sub-questions → add constraints + per-finding format → compress to one paragraph.

**Template**

> [For a reader with zero prior knowledge: in 1–2 plain-English sentences, what
> the project/product is, why it exists, and the current situation.] Research
> [TOPIC + key identifying facts] to answer one question: [THE QUESTION] — for
> [DECISION / END USE]. Find: (1) …; (2) …; (3) …; (4) …. [Constraints: include
> X, avoid Y.] Prefer primary sources; treat forums/social as weak signal only;
> if sources conflict, separate fact from inference and flag what needs
> verification. Don't stop at the first plausible answer: corroborate each key
> claim with multiple independent primary sources where they exist (and say so
> explicitly where they don't), continuing until every numbered question is
> covered to that bar. Before finishing, do a self-critique pass — list gaps,
> contradictions, and any single-source claims, then run another round of
> searches to close them, repeating until clean. For each point, give the source
> link, the specific claim, and a one-line "why it matters". No marketing fluff
> — verifiable, citable facts only. Output everything into a single detailed
> markdown file.

## 2. Execution Engines

### Gemini Deep Research agent

Autonomous "analyst-in-a-box": plans, searches, reads, synthesizes into a cited
report. 2–10 minutes per task.

- **Requirements**: Python 3.8+, `httpx`, `GEMINI_API_KEY`. Show the user the
  exact query, the fact that it goes to Google, expected cost, and output
  destination; start only after explicit approval. Never put private workspace
  material or credentials in a query.
- **CLI**: `research.py --query "…" [--format "…"] [--stream | --no-wait]`;
  `--status <id>`, `--wait <id>`, `--continue <id>` for follow-ups, `--list`,
  `--json` / `--raw` outputs.
- **Cost/time**: ~$2–5 and ~250k–900k input tokens per task (estimate, not a
  spending authorization).
- Reports may contain incomplete/stale/incorrect citations — verify
  consequential claims against primary sources.

### DeepAPI `/v1/research/deep`

Paid web research endpoint. `POST` with `query`, optional `context`,
`maxCostUsd` (default 0.10). Returns a terminal envelope; report
`debitMicrousd` and summarize returned sources. Requires `DEEPAPI_API_KEY`;
use the deep-api execution loop (poll `next.path` while `status: running`).
See `scraping-and-media.md`.

### Batched web search (hard query minimums)

When doing search-driven research yourself, count queries before synthesizing:

- **"web search"** → at least **2** queries, varied keywords/angles.
- **"extensive web research"** → at least **4** queries, totally different
  keywords/angles.
- **"deep research"** → at least **8** queries, totally different keywords and
  angles, run across 2–3 successive batches (refine angles after each batch).

A single batched search call counts each query toward the total; fire another
batch if the first is under the minimum. Never stop short.

For page fetch: get markdown (handles PDFs, YouTube, GitHub); big pages
(>30k chars) are truncated — pull the rest on demand so they don't blow
context.

## 3. When to Prefer Which Engine

| Need | Engine |
|---|---|
| Literature reviews, technical topics, arXiv-indexed | Academic search (see `literature-search.md`) |
| Current web facts, market, comparative analysis | Deep-research agent or batched web search |
| A paid, quick, source-cited report with budget control | DeepAPI `/v1/research/deep` |
| Evidence outside the above corpora | General web search |

## Limitations

Paid engines cost money and may return stale/incorrect citations; every
consequential claim still needs primary-source verification. Always get user
approval before spending.
