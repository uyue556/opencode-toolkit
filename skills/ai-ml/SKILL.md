---
name: ai-ml
description: >-
  Deep AI/ML engineering skill covering large language models, agent systems,
  RAG and retrieval, fine-tuning, evaluation, MLOps, serving, and the Hugging
  Face ecosystem. Use for building LLM-powered products, designing prompts and
  context, orchestrating autonomous and multi-agent systems, implementing hybrid
  search and embeddings, training or fine-tuning models (SFT/DPO/GRPO/RLHF,
  sentence-transformers, vision models), setting up evaluation harnesses and
  LLM-as-judge, controlling cost and runaway spend, deploying and serving models
  (local GGUF, ZeroGPU, Spaces, jobs), and operating the HF hub. 深度覆盖 AI/ML 工程：
  大语言模型应用、智能体系统、检索增强生成(RAG)、提示词工程、上下文工程与压缩、模型微调与训练
  (SFT/DPO/GRPO/RLHF、嵌入模型、视觉模型)、评测体系(LLM-as-judge)、MLOps、模型部署与推理、
  成本控制、以及 Hugging Face 生态(hub/数据集/Space/ZeroGPU/GGUF 本地模型)。
---

# AI-ML Engineering

## When to use
Use this skill for any task that builds, trains, evaluates, deploys, or operates
machine learning and LLM systems: LLM-powered features, agents, retrieval,
fine-tuning, eval harnesses, MLOps, or Hugging Face workflows. If the task is
pure general-purpose software (web apps, devops, databases) use the appropriate
general skill instead. If the task is specifically about CLI tooling or desktop
apps, defer to those domain skills.

## Routing
Start here, then open the relevant reference file for in-depth guidance:

| Topic | Reference | Trigger |
|-------|-----------|---------|
| Prompt engineering, context engineering, compression | `references/prompt-context.md` | prompts, few-shot, CoT, context window, context degradation, compression, 提示词, 上下文 |
| LLM app dev, structured output, caching, gateways, product | `references/llm-apps.md` | structured output, JSON schema, prompt caching, streaming, cost, gateway, product, 应用, 结构化输出 |
| RAG, hybrid search, embeddings, vector DBs | `references/rag-retrieval.md` | RAG, retrieval, hybrid search, chunking, rerank, embedding, vector DB, 检索 |
| Agents, tool use, multi-agent orchestration, computer use | `references/agents.md` | agent, tool call, MCP, multi-agent, orchestration, autonomy, computer use, 智能体, 工具调用 |
| Training, fine-tuning, SFT/DPO/GRPO, vision, embeddings | `references/training.md` | fine-tune, SFT, DPO, GRPO, RLHF, TRL, sentence-transformers, vision trainer, 微调, 训练 |
| Evaluation, benchmarks, LLM-as-judge | `references/evaluation.md` | eval, benchmark, LLM-as-judge, metric, regression, 评测 |
| MLOps, serving, deployment, monitoring, cost control | `references/mlops-serving.md` | MLOps, serving, deploy, monitor, cost cap, runaway, 部署, 运维 |
| Hugging Face hub, datasets, jobs, Spaces, local models | `references/hf-ecosystem.md` | Hugging Face, HF hub, dataset, Spaces, ZeroGPU, GGUF, quantization, local model, 数据集, 本地模型 |
| Image/video/media generation | `references/media-generation.md` | image gen, video gen, fal, ComfyUI, diffusion, 图像, 视频 |

## Core operating principles

1. **Cost is a first-class constraint.** Always compute and state estimated cost
   before running multi-step or multi-call workflows. Prefer cheap models
   (smaller, cached, batched) for draft passes and reserve frontier models for
   decisions. Set a hard budget cap before any autonomous loop.
2. **Prefer explicit structured data over prose.** LLM output you consume
   programmatically must use validated JSON Schema, Pydantic models, or tool
   calls — never free text parsed by regex. Validate and retry on schema errors.
3. **Measure before optimizing context.** Profile the actual token spend and
   failure mode first; then apply compression, caching, chunking, or summarization.
4. **Assume non-determinism.** Never depend on a specific generation; build
   retries, fallbacks, idempotency, and safety checks around every model call.
5. **Eval early, eval continuously.** Any prompt, model, or RAG change must be
   gated by a regression eval suite, not vibes. Keep evals fast and run them in CI.
6. **Agents need guardrails.** Any autonomous loop gets: a bounded loop count,
   a budget cap, a sandbox/permission layer for tools, and a hard stop handler.

## Quick-start recipes

### LLM app with structured output
1. Define output with a Pydantic model / JSON Schema.
2. Call the model with the schema; request tool-use/function-calling form if supported.
3. Validate response; on failure, feed the error back to the model once (max 2 retries).
4. Stream tokens for UX; use prompt caching for repeated prefixes.
5. Wrap in a cost tracker; log prompt/response for the eval suite.

### RAG pipeline
1. Split documents into semantic chunks (see chunking rules in `rag-retrieval.md`).
2. Embed with a strong embedding model (see `rag-retrieval.md` for the current pick).
3. Store in a vector DB (FAISS, Weaviate, qdrant); add BM25/FTS index for hybrid.
4. Retrieve top-k from both, fuse (RRF), rerank with a cross-encoder, then generate.
5. Eval: retrieval hit-rate + answer faithfulness; keep a golden QA set.

### Fine-tune a model
1. Check whether fine-tuning is even needed — prompt engineering + RAG often suffices.
2. Prepare dataset in the required format (see `training.md`); inspect and dedupe.
3. Pick method by goal: SFT for style/instruction, DPO/GRPO for preference,
   sentence-transformers losses for embeddings, timm/Detectron for vision.
4. Use TRL `SFTTrainer` / `DPOTrainer` / `GRPOTrainer` or `Trainer` for vision.
5. Monitor loss + a held-out eval; save to hub; convert to GGUF for local serving.

### Autonomous agent loop
1. Give the agent: system prompt with goal, a tool list (or MCP), and a budget.
2. Loop: think → call tool → observe → decide; enforce max iterations and cost cap.
3. Route sub-tasks to subagents; each subagent gets a focused system prompt.
4. Add human-in-the-loop for any destructive/irreversible tool.
5. Log the full trajectory for replay and eval.

## Anti-patterns (do not do)
- Parsing free-form model text with regex where schema/tool-calls exist.
- Tuning prompts by hand for 30 minutes when a 100-example eval suite would do.
- Sending whole corpora into context instead of retrieval.
- Fine-tuning when RAG + prompting solves it (and vice versa — don't bolt RAG
  onto a task that needs behavioral fine-tuning).
- Infinite agent loops without iteration/budget/timeout caps.
- Flying blind: no cost tracking, no eval, no version pinning of models/prompts.

## Cross-cutting concerns
- **Versioning**: pin model names, prompts, and embeddings; store as code.
- **Secrets**: keep API keys and HF tokens in env vars / `.env`, never in code.
- **Testing**: unit-test schema parsers; integration-test retrieval with golden
  data; keep model calls behind thin adapters so they are mockable.
- **Observability**: log model calls (model, prompt hash, tokens, cost, latency,
  response) to a trace store before you need to debug.

## Files
- `references/*.md` — deep guidance per sub-topic (see Routing table).
- `scripts/` — small reusable scripts for cost estimation, eval runners, etc.
- `dedup-notes.md` — which source skills were merged and what was dropped.
