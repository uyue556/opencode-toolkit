# LLM Application Development

Merged from: `llm-structured-output`, `prompt-caching`, `llm-ops`, `ai-engineer`,
`llm-application-dev-*`, `ai-wrapper-product`, `ai-product`, `ai-studio`,
`neon-ai-gateway`, `routerbase-model-gateway`, `claude-api`, `gemini-api-dev`,
`llm-application-dev`, `langchain-architecture`, `app-builder`, `project-development`.

## 1. Architecture
Keep LLM calls behind a thin adapter layer: `model.call(prompt, schema, opts)`.
This lets you swap models, add retries, log, and cache without touching business
logic. Layers:

- **App/UI layer** — user-facing, streaming.
- **Agent/service layer** — orchestration, tools, memory.
- **Model gateway** — routing, caching, retries, cost caps, fallbacks.
- **Providers** — OpenAI/Anthropic/Gemini/HF/self-hosted.

## 2. Structured output
- Define outputs as Pydantic/JSON Schema first; pass the schema to the provider
  (`response_format` / tool-call form).
- Never regex-parse free text. If forced to, wrap in a permissive parser with
  repair heuristics (strip fences, find first `{`…`}`), then validate.
- Provide the schema description with per-field guidance (enum values, types,
  nullability, examples).
- Retry loop: `validate → on error, resend with the validation error → max 2
  retries → fallback response`.

## 3. Streaming
- Stream tokens to the UI for perceived latency; aggregate for the final record.
- For tool-call/structured streams, accumulate the raw stream and parse once at
  completion, or use the provider's streaming tool-call events.
- Backpressure: don't buffer unbounded; use async iterators.

## 4. Prompt caching
- Cache the stable prefix (system prompt + shared instructions) so repeated
  calls pay only the delta. Providers (Anthropic/OpenAI) auto-cache long stable
  prefixes; make the volatile part (user data) the suffix.
- Cache the full request-response at the gateway keyed by
  `(model, prompt_hash, params)` when output is deterministic and reusable
  (factual lookups), with a TTL.
- Never cache PII; hash inputs for the key; store cost alongside cache hits.
- Measure cache hit rate and token savings as part of cost telemetry.

## 5. Cost & latency control
- Right-size the model: cheap/fast model for drafts, extraction, classification;
  frontier model only for hard reasoning. Route by input signals.
- Batch independent calls; parallelize with bounded concurrency.
- Cap max_tokens and use early stop where possible; estimate cost per call via
  token counts × price and log every call.
- Set a hard per-session/per-run budget (see `mlops-serving.md` for runaway
  guard). Kill autonomous loops when the cap hits.
- Use caching + compression before reaching for a bigger model.

## 6. Gateway & routing (Neon AI Gateway / RouterBase patterns)
- Central gateway: single auth, per-provider keys, retries with backoff,
  failover to a fallback provider, rate limiting per user/team.
- Provider abstractions keep vendor-specific params out of app code.
- Expose `/v1/chat/completions`-compatible endpoint so tools can be pointed at it.
- Log model, latency, tokens, cost, errors; surface cost per customer/feature.

## 7. Productization (AI wrapper / AI product patterns)
- Find the real job-to-be-done; the LLM is a component, not the product.
- Design the prompt/schema contracts as API boundaries — they are the product's
  interface; version them.
- Guardrails: input filtering, output moderation, PII redaction, copyright/abuse
  checks on both directions.
- Streaming UX + skeletons keep users engaged during model latency.
- Instrument: activation, completion rate, retries, and quality evals, not just
  token count.

## 8. Provider-specific notes
- **Anthropic Claude**: system prompt is top-level; good long-context; use tool
  use for structured output; prompt caching on long stable prefixes.
- **OpenAI**: `response_format` JSON; functions/tools for structure; logit_bias
  for constrained enums.
- **Gemini**: multimodal input; function calling; controlled generation via
  response schema.
- **Local/Ollama/llama.cpp**: no auto-cache guarantees; structure via grammar
  (GBNF) or format strings; run on GPU/CPU with quantization.

## 9. LangChain framework notes
- Use when you need quick assembly of chains/tools; prefer the new LangGraph
  style for stateful agents over legacy chains.
- Keep prompts as templates with `PromptTemplate`; version them.
- Don't let the framework hide the actual prompts/schema from you — the
  underlying prompt is what gets evaled.
- Understand the abstraction leak: map framework concepts to raw provider calls
  before debugging weird behavior.

## 10. Security
- Treat model output as untrusted: render with escaping; don't execute LLM
  JSON blindly; validate paths/URLs before use.
- Sanitize any user text that ends up in prompts (injection), especially in
  tool-call arguments.
- Keep keys server-side; never log raw prompts that contain PII; redact before
  telemetry.

## Deliverables checklist
- [ ] Adapter layer isolates providers; models swappable.
- [ ] Structured output with schema + validation + retry.
- [ ] Cost per call logged; session budget enforced.
- [ ] Streaming wired for UX latency.
- [ ] Prompt caching enabled; cache-hit telemetry.
- [ ] Eval suite gates prompt/model changes.
- [ ] No secrets in code; injection-resistant rendering.
