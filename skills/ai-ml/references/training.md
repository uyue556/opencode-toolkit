# Training, Fine-Tuning & Embeddings

Merged from: `trl-training`, `hugging-face-model-trainer`, `hugging-face-vision-trainer`,
`train-sentence-transformers`, `scikit-learn`, `hugging-face-jobs`, `ai-studio`,
`llm-ops` fine-tune section, `ai-engineer` fine-tune section.

## 1. Decide whether to train at all
Order of preference before touching training:
1. **Prompt engineering** — cheapest; covers most instruction/style changes.
2. **RAG / retrieval** — for knowledge you don't want baked into weights.
3. **Context engineering / structured output** — output formatting and grounding.
4. **Fine-tuning** — only for behavior, domain style, output format, or
   performance that prompting+RAG can't reach.

Fine-tuning is warranted when: consistent failure on a specific task family,
desired output format/voice, latency/cost reduction by shrinking the model, or
removing the need for long few-shot context.

## 2. Data is the whole game
- Quality >> quantity: a few hundred carefully curated examples beat tens of
  thousands of noisy ones for SFT.
- **Dedupe** near-duplicates; check for label noise; balance classes.
- Format matches your method:
  - SFT: `{instruction, input, output}` (or chat messages).
  - DPO/GRPO: `{prompt, chosen, rejected}` pairs / trajectories.
  - Sentence-transformers: `(anchor, positive)` pairs / triplets / labels.
  - Vision: image + target (classification labels, bboxes, masks).
- Hold out a real eval set (same distribution) before training; never tune on it.
- Inspect a random sample + edge cases by hand before launching a run.

## 3. Methods
- **SFT** (supervised fine-tuning): teach style/format/behavior. `TRL.SFTTrainer`
  with packing, chat templates. Fast, cheap, most common.
- **DPO** (direct preference optimization): align to preferences from chosen/
  rejected pairs; simpler than RLHF, no reward model at train time. Use
  `DPOTrainer`; tune β (reference: 0.1), watch for over-optimization/DR.
- **GRPO** (group relative policy optimization): on-policy RL, group-relative
  advantages; strong for reasoning (math/code) — reward via verifiable checks.
  Use `GRPOTrainer`. Careful: reward hacking, KL drift; monitor reward + KL.
- **PEFT** (LoRA/QLoRA): train adapters, not full weights. Most fine-tunes
  should use LoRA (r 8–64) for cost and portability; QLoRA 4-bit to fit on one
  GPU. Merge adapters before serving/exporting.
- **Full fine-tune** only when adapter capacity is the bottleneck.
- **Embeddings**: train with sentence-transformers losses (see below).

## 4. Sentence-transformers (embeddings) training
- Architectures: Bi-encoder (embedding models), Cross-encoder (rerankers),
  Sparse encoder (SPLADE/MaxSim-style).
- Losses by goal:
  - Contrastive/triplet for similarity ranking;
  - CoSENT/supervised contrastive for labeled pairs;
  - MultipleNegativesRankingLoss for (query, positive) pairs from click/log data;
  - MarginRanking / triplet margin for ordinal relevance.
- Model selection (`base_model_selection`): start from a strong pretrained
  sentence-transformer (BGE/E5/gte/nomic), adapt dimension, max_seq_length to
  your data (do NOT keep 512 if docs are short — huge speedup).
- Eval: `Evaluator` callbacks (Spearman/MRR/Accuracy) on a dev set each epoch.
- Export to Hub with task config so `sentence_transformers` auto-loads.
- When to retrain vs use the existing strong model: only when your domain has
  vocabulary/format the pretrained embedding misses and you have data.

## 5. Vision model training
- Image classification: `Trainer` + `timm`/`AutoModelForImageClassification`.
- Object detection: `Detectron2` or transformers detection models; data as COCO.
- Segmentation: SAM2 / segmentation models — provide masks; fine-tune the
  lightweight heads, not the whole SAM.
- Data: preprocess (resize, normalize) consistent with the pretrained backbone;
  augment conservatively; watch class imbalance.
- Save to Hub (`hub_saving`) with model card + config so it's reloadable.

## 6. Hyperparameters & hardware
- TRL defaults are sane; start from them, change one thing at a time.
- LR: SFT ~1e-4–5e-5 (LoRA 1e-4–3e-4); DPO ~5e-6–5e-5. Warmup 5–10%.
- Epochs: 1–3 for SFT; early-stop on eval; watch for overfit (train vs eval gap).
- Batch: fit as large as VRAM allows; gradient accumulation to effective batch.
- Hardware: LoRA/QLoRA on consumer GPUs; `bitsandbytes` 4-bit; consider HF
  ZeroGPU/Jobs for serverless GPU; for big runs use HF jobs or your cluster.
- Memory: `flash_attn` (if available), gradient checkpointing, bf16/mixed precision.

## 7. Run, monitor, save
- Save checkpoints + best model to the HF Hub (`model.save_pretrained`, push).
- Monitor: loss curves, eval metrics, gradient norms, LR schedule; for RL
  methods also reward, KL, and generation quality samples.
- Convert to GGUF for local/llama.cpp serving after merging adapters
  (see `hf-ecosystem.md` / `mlops-serving.md`).
- Pin everything: dataset version, base model, config, seed, env/package versions.

## 8. Scikit-learn (classical ML)
- Use for tabular/small-data problems where LLMs are overkill: trees/GBM,
  logistic regression, clustering, embeddings as features.
- Pipeline: clean → feature scale → split (stratified) → cross-validate →
  tune (grid/random search) → evaluate on held-out with the business metric.
- Feature store discipline: derive features in one place; version the dataset.
- For text: TF-IDF/bag-of-words or embedding features feeding a linear/GBM model
  — often beats a big LLM for structured tabular classification.

## Anti-patterns
- Fine-tuning on noisy uncurated scrapes and hoping for the best.
- Training for weeks on a task prompting + RAG already solves.
- Forgetting an eval set; tuning hyperparameters on the test set.
- Full fine-tune when LoRA suffices.
- Blindly copying LR/batch from a blog; change one knob at a time.

## Checklist
- [ ] Justified that fine-tuning is needed (not prompt/RAG-able).
- [ ] Curated, deduped, formatted data + held-out eval set.
- [ ] Method chosen (SFT/DPO/GRPO/embeddings/vision) with matching data format.
- [ ] LoRA default; monitor train vs eval; early stop.
- [ ] Best model pushed to Hub; adapters merged; config pinned.
