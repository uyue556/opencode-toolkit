# Evaluation, Benchmarks & LLM-as-Judge

Merged from: `llm-evaluation`, `advanced-evaluation`, `evaluation`, `evalu`,
`hugging-face-evaluation`, `hugging-face-community-evals`, `bdistill-behavioral-xray`,
`bdistill-knowledge-extraction`, `runaway-guard` (eval portions).

## 1. Principles
- **Eval before you optimize.** Any prompt/model/RAG/agent change is a
  hypothesis; score it on a fixed eval set, not vibes.
- **Golden set first**: build a curated set of ~50–200 realistic cases with
  ground truth (expected answer / rubric / known-good retrieval).
- **Separate dev and test**: tune on dev, report once on held-out test.
- **Determinism**: pin model versions, seeds, and prompt hashes so runs are
  comparable; run evals in CI.
- **Slice results**, don't average blindly: group by difficulty, domain, language,
  length, and failure class — a good average hides a broken slice.

## 2. Metrics by task
- Classification/NER: precision, recall, F1 (macro/micro/weighted), confusion
  matrix; per-class breakdown.
- QA / generation: exact match (EM), ROUGE/BLEU for lexical tasks; semantic
  similarity for paraphrasing.
- Retrieval: hit-rate@k, recall@k, MRR, nDCG on golden (query→relevant) sets.
- Summarization: faithfulness (does it hallucinate beyond source?), coverage,
  factual consistency; ROUGE is a weak proxy — use faithfulness models/judges.
- Code: pass@k on unit tests, compile rate; not just string match.
- Agents: task success rate, tool-call correctness, trajectory validity,
  abort rate, budget used, steps taken.

## 3. LLM-as-judge
When to use: open-ended quality (helpfulness, tone, faithfulness, code quality)
where no metric exists.

- **Rubric prompts**: give the judge explicit criteria + a scale (e.g., 1–5)
  with anchors per level. Ask for a brief justification then the score, in a
  structured format (JSON) for parsing.
- **Pairwise vs pointwise**: pairwise ("which is better") is more reliable for
  subtle differences; pointwise with a rubric for absolute scoring. Report both
  if uncertain.
- **Bias controls**:
  - Position bias (first answer favored): randomize order; run both directions.
  - Verbosity/style bias: instruct to ignore length; blind the judge to source
    attribution where possible.
  - Self-preference: don't have the same model that generated judge itself.
  - Judge on the final answer, not the prompt.
- **Validate the judge**: spot-check judge scores against human labels
  (correlation/agreement, e.g., Cohen's κ ≥ 0.6 target); if the judge disagrees
  with humans, fix the rubric.
- **Structured rubric + JSON output** makes judge results reproducible.

## 4. Test-time evaluation harness
- Run evals against a stable snapshot of the model+prompt (a "lock" step before
  release).
- Regression gating: each prompt/model/RAG change must not regress scores beyond
  a noise threshold; compute variance by running a subset multiple times.
- Keep evals **fast** (small representative set) for iteration; reserve the full
  set for release gates.
- Store results (per-case scores + judge outputs) for diffing across runs.

## 5. Behavioral & capability probing
- Probe for specific capabilities and failure modes with targeted suites:
  instruction-following, adversarial inputs, injection resistance, calibration
  (confidence vs accuracy), gender/race bias in outputs.
- Build an **adversarial set** alongside the golden set: edge cases, ambiguous
  inputs, malicious prompts, known failure classes. Never train on it.
- For agents: simulate failure scenarios (tool errors, missing info, injected
  content in tool output) and assert the agent handles them.

## 6. Evaluation of evals (meta-eval)
- When adding a new judge/metric, measure it: does it track human judgement on
  a sample? Is it stable across seeds?
- Prefer metrics that separate the models you know to be good vs bad (sanity
  check the metric has signal).

## 7. Community & open benchmarks
- Use established leaderboards for sanity and model selection (MMLU, GSM8K,
  HumanEval, MT-Bench, IFEval, etc.), but ALWAYS complement with your own
  domain-specific golden set — leaderboards don't measure your workload.
- Community eval frameworks (Hugging Face `evaluate`, `lighteval`, `lm-eval-harness`)
  give standard metrics for many benchmarks; wire them into your harness.
- For RAG/agents, community datasets exist but your own corpus is the ground truth.

## Anti-patterns
- Tuning prompts with no eval set.
- Reporting one averaged number that hides a broken slice.
- Judge with no rubric, no validation against humans, no position-bias control.
- Testing on training data / tuning hyperparameters on the test set.
- Skipping CI gating because "it looks fine."

## Quick recipe
1. Curate golden set (100+ realistic cases with ground truth).
2. Pick per-task metrics; add LLM-as-judge only where needed (with rubric).
3. Validate the judge against human labels.
4. Wire into CI: run on every prompt/model change; gate on regression thresholds.
5. Slice by domain/difficulty; report deltas, not just means.
