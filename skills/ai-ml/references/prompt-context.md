# Prompt & Context Engineering

Merged from: `prompt-engineering-patterns`, `llm-prompt-optimizer`,
`context-engineering`, `context-fundamentals`, `context-compression`,
`context-degradation`, `context-manager`, `context-agent`, `context-guardian`,
`context-driven-development`, `context-optimization`.

## 1. Prompt structure
A robust prompt has: **role/identity** → **task statement** → **input** →
**output contract** → **constraints/style** → **examples (few-shot)** →
**failure handling**.

- Be explicit about the task verb: "Extract", "Classify", "Rewrite", "Summarize".
- State the audience and desired tone.
- Give the model an out: "If the information is absent, say UNKNOWN" —
  prevents hallucinated filler.
- Use delimiters (`---`, `XML tags`, `fenced blocks`) to separate instructions
  from data; never rely on whitespace alone.

## 2. Few-shot & in-context learning
- Provide 2–5 high-quality examples; label them clearly (`Example 1`, `Input`,
  `Output`). Show the *reasoning* where useful, not just inputs/outputs.
- Prefer examples that cover edge cases and failure modes, not just typical
  success cases.
- If examples are long, weigh token cost: many short examples often beat few long.
- For classification, include "hard negatives" — near-miss examples the model
  should reject.

## 3. Chain-of-thought (CoT)
- Use `"Think step by step before answering."` only when reasoning helps.
- For math/logic, force output into a two-phase format: `<scratch>` then
  `<answer>`, so the final answer is extractable even when the scratch is wrong.
- Zero-shot CoT: append "Let's think through this carefully, then give a final
  answer." For strict tasks, guard the length and ban the model from revealing
  scratch if that matters.
- Alternatives to full CoT for latency/cost: least-to-most prompting, and
  "think" only for hard cases (route easy inputs to a cheap model).

## 4. Output contract
- For anything consumed programmatically: JSON Schema / Pydantic, or tool-call
  form. State the schema in the prompt AND validate in code.
- Ask the model to emit valid JSON only, with no markdown fences, when the API
  doesn't already guarantee it.
- Include allowed values for enums, required vs optional fields, types, and
  length caps in the schema description.
- On validation failure: return the validator error to the model as context and
  ask it to fix (max 2 retries), then fall back.

## 5. Context engineering
Context is a hierarchy of information the model sees. Organize by importance:

1. **Global invariants** (system prompt): identity, hard constraints, tone,
   safety policy. Keep small and stable.
2. **Task-specific instructions** (user/system): the current job.
3. **Grounding data** (retrieved docs, tool results, memory): the authoritative
   facts for this turn.
4. **History/scratch**: prior turns and intermediate reasoning.

Rules:
- Put the most important instruction first and last (primacy & recency effects);
  bury noise in the middle.
- Keep the system prompt short; move details to per-task instructions.
- Ensure the model can distinguish instruction from data (delimiters).
- Trim or summarize stale history rather than letting it accumulate.

## 6. Context degradation & failure modes
As context grows, models degrade: earlier content is attended less (lost-in-the-middle),
instruction following decays, irrelevant tokens cause attention dilution.

- **Lost in the middle**: critical facts must appear early or at the very end.
- **Context overload**: past ~context/2 useful tokens, add diminishing returns;
  compress or retrieve instead of piling on.
- **Injection/conflict**: untrusted text in the middle can override instructions
  that came before it — fence it and add explicit "ignore unrelated text" rules.
- **Staleness**: old turns contradict new ground truth; expire or summarize them.

Mitigations: sliding window with summary, structured memory, retrieval instead
of full dump, and re-asserting the system prompt.

## 7. Compression
Compression strategies, in order of preference for token savings:

1. **Reduce what you send**: retrieve top-k, dedupe, truncate to the answer-relevant
   span (chunk by question intent).
2. **Summarize** (extractive or model-based) older context into bullet points.
3. **Abstractive compression**: ask a cheap model to compress passages while
   preserving quoted facts (avoid paraphrasing numbers/names).
4. **Drop-stopwords/minified formatting** only as a last resort — hurts quality.

Validation: every compression step must be checked against an eval set (does the
answer to a question remain derivable after compression?). If not, keep the span.

## 8. RSCIT prompt optimizer loop
For systematically improving a prompt:
**R**eview current prompt → **S**earch for weakness (errors on eval set) →
**C**ritique hypotheses (why it fails) → **I**terate on edits (change one variable
at a time) → **T**est on eval set and keep only winning variants.

- Change exactly one thing per iteration; keep a ledger of what you tried.
- Use an eval suite (see `evaluation.md`), not vibes, to score each candidate.
- Prompt versioning: store prompts as code with hashes so evals are reproducible.

## 9. Context for agents & long sessions
- Maintain a compact, always-present "memory" summary plus a working set of
  retrievable notes; never re-inject the whole history.
- Use the context budget: reserve headroom for tool results and grounding.
- On budget pressure, compress the oldest, least-relevant turns first.
- After any compression or summarization, update the memory summary and any
  pointers; verify the extracted facts survived (verification checklist).

## Quick rules of thumb
- 1 instruction per paragraph; numbered lists for multi-step instructions.
- Capitalize or bold critical negatives ("DO NOT", "NEVER").
- Few-shot beats describing the format; describe + show when space allows.
- When a task is hard, don't only prompt harder — use retrieval, tools, or a
  stronger model, and measure the delta.
