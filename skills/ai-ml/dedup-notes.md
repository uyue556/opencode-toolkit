# Dedup & Consolidation Notes — ai-ml

Consolidation of 131 source skills → 1 ai-ml skill (this).

Source libraries scanned: `skill-libraries/ai-ml` (128 SKILL.md files),
`skill-libraries/ai` (1: weaviate-cookbooks), `skill-libraries/ai-research`
(1: bdistill-knowledge-extraction), `skill-libraries/ai-testing`
(1: bdistill-behavioral-xray).

## Output structure
- `SKILL.md` — routing table + core principles + quick-start recipes.
- `references/prompt-context.md` — prompts, few-shot, CoT, context engineering,
  compression, degradation, RSCIT optimizer.
- `references/llm-apps.md` — LLM app architecture, structured output, streaming,
  caching, cost, gateways, productization, provider notes.
- `references/rag-retrieval.md` — chunking, embeddings, hybrid search + RRF,
  reranking, evaluation, memory.
- `references/agents.md` — agent loops, tool design, MCP, multi-agent
  orchestration, computer-use, memory, HITL, reliability.
- `references/training.md` — train-vs-prompt decision, data, SFT/DPO/GRPO, LoRA,
  sentence-transformers, vision, hyperparams, sklearn.
- `references/evaluation.md` — metrics, golden sets, LLM-as-judge, bias
  controls, harness, probes.
- `references/mlops-serving.md` — lifecycle, serving, monitoring, cost/runaway
  control, rollout.
- `references/hf-ecosystem.md` — Hub, datasets, Spaces, ZeroGPU, GGUF/local,
  jobs, hardware.
- `references/media-generation.md` — fal.ai image/video, AI Studio, workflow
  chaining.

## Skills merged by topic
- **Prompt/context**: prompt-engineering-patterns, llm-prompt-optimizer,
  context-engineering, context-fundamentals, context-compression,
  context-degradation, context-manager, context-agent, context-guardian,
  context-driven-development, context-optimization.
- **LLM apps**: llm-structured-output, prompt-caching, llm-ops, ai-engineer,
  llm-application-dev-family, ai-wrapper-product, ai-product, ai-studio,
  neon-ai-gateway, routerbase-model-gateway, claude-api, gemini-api-dev,
  langchain-architecture.
- **RAG**: hybrid-search-implementation, weaviate-cookbooks, rag-family,
  mesh-memory.
- **Agents**: autonomous-agent-patterns, autonomous-agents, multi-agent-architect,
  agent-tool-builder, tool-design, agent-orchestrator, agent-orchestration-family,
  agent-creator, agent-squad, bdi-mental-states, computer-use-agents, agentphone,
  agentmail, voice-agents, voice-ai-engine-development, loki-mode, odw, loopy,
  agents-md, subagent-orchestrator.
- **Training**: trl-training, hugging-face-model-trainer, hugging-face-vision-trainer,
  train-sentence-transformers, scikit-learn, hugging-face-jobs (training parts).
- **Eval**: llm-evaluation, advanced-evaluation, evaluation, evalu,
  hugging-face-evaluation, hugging-face-community-evals, bdistill-behavioral-xray,
  bdistill-knowledge-extraction, runaway-guard(eval).
- **MLOps**: mlops-engineer, ml-engineer, llm-ops, runaway-guard, monte-carlo-monitoring-advisor,
  lineage-tracking, hugging-face-trackio, huggingface-zerogpu, hugging-face-gradio.
- **HF ecosystem**: huggingface-local-models, hugging-face-datasets,
  hugging-face-cli, hf-mcp, hf-mem, huggingface-spaces, hugging-face-jobs,
  hugging-face-model-trainer, hugging-face-vision-trainer, hugging-face-evaluation,
  hugging-face-community-evals, hugging-face-tool-builder, hugging-face-paper-publisher,
  hugging-face-dataset-viewer, huggingface-best, hugging-face-trackio, gguf-conversion.
- **Media**: fal-generate, fal-image-edit, fal-platform, fal-upscale, fal-workflow,
  ai-studio-image.

## Dropped skills (and why)
- **Persona/nuance-only, low actionable distinct content** (largely discussions or
  single-persona interview formats — not usable engineering guidance): yann-lecun,
  ilya-sutskever, sam-altman, yann-lecun-tecnico, bdi-mental-states (folded into
  agents instead), agent-squad/agent-orchestrator type (folded into agents.md).
- **Off-domain / non-AI-ML**: claude-speed-reader (RSVP reading), ui-skills
  (general UI constraints), app-builder (general app scaffolding; not AI-specific), claude-win11-speckit-update-skill (Windows admin),
  claude-ally-health (medical assistant app), claude-scientific-skills (generic
  research; subsumed by evaluation.md), claude-d3js-skill (visualization library
  use — not ML; referenced only).
- **Marketing/product**: ai-seo (rank). ai-product & ai-wrapper-product folded
  into llm-apps.md (productization).
- **Niche tool-specific wrappers**: agentfolio, molykit, aomi-transact, brave-man,
  brooks-harness, agentic-actions-auditor, claude-monitor, claude-in-chrome-troubleshooting,
  claude-settings-audit, obsidian-integrations — single-use wrappers without
  generalizable practice captured elsewhere.

## Scripts
- No generally reusable scripts existed in sources. The only script found
  (`loki-mode/scripts/take-screenshots.js`) is hardcoded to that skill's local
  dashboard paths; not portable → **not carried**. The `scripts/` dir is created
  for future reusable scripts (e.g., cost estimator, eval runner) but kept empty
  deliberately rather than shipping dead-weight.

## Gaps / assumptions
- `hugging-face-vision-trainer` and `train-sentence-transformers` reference
  per-type training notebook files in their own `references/` dirs; the concrete
  notebook contents were summarized into training.md rather than copied verbatim
  (kept sub-500-line files; notebooks are bulky).
- fal workflow JSON structure is documented conceptually; exact node schema
  depends on the platform's current model list — prefer the platform model-list
  API at runtime.
- Multi-lingual: skill description includes Chinese triggers (微调, 训练, RAG, 评测,
  etc.) so Chinese prompts route here.

## Line counts
- SKILL.md: keep < 500 lines (current draft ~150). Each reference under ~220
  lines → no per-file TOC needed yet (add TOC if any file exceeds ~300 lines).