# Hugging Face Ecosystem & Local Models

Merged from: `huggingface-local-models`, `hugging-face-datasets`, `hugging-face-cli`,
`hf-mcp`, `hf-mem`, `hugging-face-jobs`, `huggingface-spaces`, `hugging-face-gradio`,
`huggingface-zerogpu`, `hugging-face-model-trainer`, `hugging-face-vision-trainer`,
`hugging-face-evaluation`, `hugging-face-community-evals`, `hugging-face-tool-builder`,
`hugging-face-paper-publisher`, `hugging-face-dataset-viewer`, `huggingface-best`,
`hugging-face-trackio`, `hugging-face-jobs`/hardware guides, `gguf-conversion`.

## 1. Hub workflow
- The Hub is the central registry for models, datasets, Spaces, and configs.
  Load anything with `from_pretrained`; push artifacts with `push_to_hub`.
- Authenticate via `huggingface-cli login` (token in env, never in code).
- Model cards: REQUIRED before publishing — describe usage, training data,
  limitations, benchmarks, and license; include a usage example that runs.
- Version models: tags/commits for each push so deployments pin an exact revision;
  use `revision=` in `from_pretrained`.
- Reproducibility: commit the exact `transformers` version + configs with the
  artifact.

## 2. Datasets
- `datasets` library: load streaming datasets lazily (`streaming=True`) to avoid
  pulling everything to disk.
- Push with `Dataset.push_to_hub`; include validation/config; document cols,
  cardinality, license, and construction method in the dataset card.
- Inspect with the Hub dataset viewer UI/`dataset-viewer` API before use.
- Quality: dedupe, check class balance, filter PII, and store provenance/metadata
  on each example. Version datasets (they are code, too).
- Convert common formats (JSONL/CSV/parquet) with the dataset writers.

## 3. Spaces & ZeroGPU
- Spaces host demo apps (Gradio/Streamlit/static) publicly; the easiest way to
  ship a small service. Repos can be model repos with app files.
- **ZeroGPU**: serverless GPU-backed Spaces — pay-per-GPU-time, autoscales to
  zero when idle (saves cost). Use for demos/lightweight inference; configure concurrency.
- Requirements: pin `requirements.txt`; for heavy models use a cached warm start
  or VLLM endpoint backed by ZeroGPU.
- Common known errors: cold start timeouts (raise HF timeout or warm the Space),
  missing `requirements.txt` freeze, VRAM limits on default GPU (use a smaller
  quantization or ZeroGPU tier).
- Spaces are public — don't leak keys; use env secrets in the Space settings.

## 4. GGUF quantization & local models (llama.cpp / Ollama)
- **When local**: data privacy, no per-token costs, offline capability, low
  latency on the edge; budget CPUs.
- Convert a merged model to GGUF: use `llama.cpp/convert_hf_to_gguf.py` (or HF
  conversion scripts), then quantize (q4_K_M, q5_K_M, q8_0 goldilocks; Q4 for
  speed, Q5/Q8 for quality — measure your own tradeoff).
- Serve with llama.cpp server (OpenAI-compatible endpoint) or Ollama; embed and
  rerank models too.
- Memory fit rule: choose quantization so weights + KV cache + overhead fit in
  RAM/VRAM; ~1 bit per weight parameter byte scaling: 7B q4 ≈ 4–5 GB.
- After fine-tuning: merge LoRA → convert → quantize → serve the GGUF; keep the
  source weights/hub for regeneration.
- CPU inference: threads + vectorized builds; batch small; expect ~10–40 tok/s
  on decent CPU for 7B q4 — size expectations accordingly.

## 5. HF jobs & hardware
- **Jobs** run batch training/inference on ephemeral GPUs (H100/A100/etc.) —
  better than staying logged into a single rented box; use for fine-tuning runs
  and batch computations. Twilio/env config, artifacts → hub.
- Hardware guide quick rules: GPU memory sizing for training = (parameters ×
  bytes) × optimizer/kV overhead factor; LoRA/QLoRA to shrink; gradient
  checkpointing + accumulation to fit.
- Troubleshooting: OOM → reduce batch/grad-checkpoint/quantize; CUDA mismatch →
  pin compatible torch/cuda; slow data → dataloader with num_workers + streaming.

## 6. Model inference options matrix
| Need | Pick |
|------|------|
| High-throughput serving (many users) | vLLM / TGI on your GPU cluster |
| Small/CPU/offline | GGUF + llama.cpp / Ollama |
| Public demo, cheap, serverless GPU | Spaces + ZeroGPU |
| Batch CPU/GPU work | HF Jobs |
| One-off prototyping | `transformers` `pipeline()` locally or ZeroGPU |

## 7. HF tooling extras
- `hf-mcp`: expose HF Hub/models/datasets as MCP tools for agents.
- `hf-mem`: GPU/CPU memory helpers for fitting models (offload, device_map).
- `hugging-face-evaluate` / community evals: standard metrics and leaderboard
  scores (see `evaluation.md`).
- `trackio`-style experiment tracking for HF runs (metrics → hub); can run via Spaces.
- Tool builders: generate/reference HF tools; paper publisher: formats research
  into models/datasets/blogs (nice-to-have, not essential).

## Anti-patterns
- `from_pretrained` without pinning `revision` in prod.
- Publishing models/datasets with no card, license, or provenance.
- Pulling a huge dataset into memory when `streaming=True` exists.
- Serving a raw training checkpoint instead of the merged/quantized artifact.
- Ignoring VRAM limits on ZeroGPU and wondering why the space OOMs.
- Login tokens committed to the repo.

## Checklist
- [ ] Artifacts pinned by revision + config, reproducible.
- [ ] Model/dataset cards with usage example + license.
- [ ] Serving choice matches load (vLLM/ZeroGPU/Ollama/Jobs).
- [ ] GGUF quantized for local/CPU; quality measured, not assumed.
- [ ] Datasets streamed/deduped/provenance recorded.
- [ ] Secrets only via env / Space secrets.