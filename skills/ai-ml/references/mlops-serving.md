# MLOps, Serving, Deployment & Cost Control

Merged from: `mlops-engineer`, `ml-engineer`, `llm-ops`, `runaway-guard`,
`monte-carlo-monitoring-advisor`, `hugging-face-jobs`, `huggingface-spaces`,
`huggingface-local-models`, `huggingface-zerogpu`, `hugging-face-gradio`,
`hf-mem`, `lineage-tracking`, `hugging-face-trackio`.

## 1. Lifecycle & reproducibility
- **Pipelines as code**: data prep → train → eval → promote → deploy, all
  versioned and runnable from one command.
- **Artifact registry**: datasets, checkpoints, adapters, eval results, deployments
  each pinned with hash + metadata; a model registry records lineage (data →
  model → metrics → deployment).
- **Environments**: pin Python/package versions (uv/poetry/conda lockfiles) and
  GPU/CUDA versions. Reproduce the exact env that trained the model.
- **GitOps**: configs (models, prompts, topologies) in the repo, reviewed like
  code; deploys trigger from the registry, not ad hoc.
- **Secrets**: HF tokens, API keys, and cloud creds via env vars / secret
  manager; never in code or artifacts.

## 2. Experiment management
- One experiment ledger: dataset hash, base model, config, seed, metrics, cost,
  artifacts. Reproduce any run from the ledger alone.
- Compare runs on the same eval set; freeze an eval set snapshot per dataset version.

## 3. Serving & deployment
- **Local standardized interface**: expose the model behind one HTTP/OpenAI-style
  API (`/v1/chat/completions`, `/v1/embeddings`, `/v1/rerank`) so services can
  swap backends.
- Options by need:
  - **Hugging Face Spaces + ZeroGPU**: fast serverless GPU for demos and
    lightweight services; free tier for prototyping; scale via concurrency settings.
  - **HF Jobs**: for batch training/inference jobs on ephemeral GPUs; good for
    finetune runs and bulk inference.
  - **Self-hosted**: vLLM / llama.cpp / TGI / Ollama for inference serving on
    your own GPUs; vLLM for high-throughput multi-user; llama.cpp + GGUF for
    CPU/small machines (see `hf-ecosystem.md`).
  - **Cloud/enterprise**: AWS SageMaker, Vertex AI, Azure ML for managed,
    K8s for custom infra.
- Serve the **merged/quantized** model (merge LoRA adapters, export ONNX/GGUF)
  rather than the raw training checkpoint.

## 4. Scaling & performance
- Prefill/decode split; continuous batching (vLLM/TGI) for throughput.
- Quantization to fit/accelerate: FP16 → INT8/INT4, AWQ/GPTQ/GGUF; measure
  latency + quality tradeoff on your own data before committing.
- Cache layers: KV-cache reuse, prompt caching, response caching (see
  `llm-apps.md`).
- Load test: users-per-second, tokens/sec, p50/p95 latency, and error rates
  under load before release.

## 5. Monitoring & observability
- Record per request: model, prompt hash, tokens in/out, latency, cost, and
  response snapshot (or pointer). Stream to a trace store.
- **Quality drift**: sample outputs and score with the eval harness
  (judge/metrics) on a schedule; alert on score regressions — accuracy can drift
  even when latency is fine.
- **Cost drift**: per-feature/per-tenant cost telemetry; alert on spikes.
- **Latency/error SLOs**: p95 latency, error rate, token throughput; alert + auto-remediate.
- **Prompt/input drift**: monitor input distribution shifts (embedding distance,
  length, domain) that can silently break quality.
- Monte-Carlo-style monitoring: sample, don't inspect everything; use multiple
  monitors (quality/latency/cost) with alert thresholds, and a feedback loop into
  the eval harness.

## 6. Cost control & runaway guard
Set up **before** going live:

- **Per-call cost calc**: `tokens_in × price_in + tokens_out × price_out`.
  Log every call's estimated $ cost.
- **Hard caps, enforced in code** (never prompt-only):
  - Per-run / per-session budget (reset on a schedule).
  - Per-agent-loop iteration cap + time bound (see `agents.md`).
  - Daily/weekly spend alerts and an automatic kill switch that stops the run.
- Failure modes that blow budgets: retry storms, repetitive agent loops,
  unbounded context growth, high-concurrency user abuse. Guard each: backoff +
  jitter on retries; loop caps; context budget; rate limiting + quotas per user.
- **Right-size the model**: route easy requests to cheap models; batch; cache.
- Idle GPU waste: tear down serverless GPU when idle; batch jobs can use
  serverless (HF ZeroGPU) instead of always-on GPUs.
- Track cost per feature/customer to detect abuse early.

## 7. Safe rollout
- Canary/shad: route 1–10% of traffic to a new model/prompt; compare on the
  eval harness + live metrics; roll back fast on regression.
- Keep previous model/prompt versions deployed for rollback (one command).
- Pre-deploy gate: full eval suite + a smoke test (each major flow).

## Checklist before serving
- [ ] Unified serving API (OpenAI-compatible) behind the model.
- [ ] Merged/quantized artifact from the registry (not a raw checkpoint).
- [ ] Per-request cost/latency logging; traces flowing.
- [ ] Hard budget caps enforced in code + spend alerts.
- [ ] Quality + cost + latency monitors with alerts.
- [ ] Canary rollout with fast rollback; previous version retained.
- [ ] Secrets in env/secret-manager only.