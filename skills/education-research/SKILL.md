---
name: education-research
description: >-
  End-to-end companion for learning, teaching, and research: tutor any topic with
  evidence-based methods (zone of proximal development, retrieval practice, spaced
  review), plan lessons and classroom activities, generate interactive course
  artifacts and exam-prep roadmaps, run deep research and literature reviews across
  arXiv/Semantic Scholar/PubMed, fact-check AI answers, generate source-backed survey
  papers, and route to the right scientific Python library. Trigger on: learn, teach,
  tutor, lesson, course, 教学, 学习, 辅导, 课程, 备课; exam, flashcards, quiz, roadmap,
  备考, 考试, 复习, 刷题; research, literature review, survey, 文献综述, 调研, 研究,
  论文, 综述; paper search, arxiv, pubmed, semantic scholar, citation, 引文; fact-check,
  verify claims, 事实核查, 验证; deep research, 深度研究; web scrape, youtube transcript,
  字幕; scientific computing, matplotlib, seaborn, statsmodels, sympy, astropy,
  biopython, scanpy, networkx, qiskit, cirq.
---

# Education & Research

One skill for the full learning-to-publishing pipeline: teaching and tutoring,
exam prep and course design, literature search and review, deep research,
fact-checking, science writing, and scientific computing.

## When to Use

Use this skill whenever the user wants to:

- **Learn / be taught**: "teach me", "explain", "tutor me", "help me study",
  教我, 辅导, 学习, 复习.
- **Prepare for an exam**: convert a syllabus, past papers, or notes into a
  prioritized roadmap, flashcards, predicted paper, or readiness check (备考,
  考试, 预测题, 重点).
- **Build a course artifact**: a standalone interactive lesson, mini-course,
  study guide, survey paper, or quiz (课程, 课件, 测验).
- **Plan a classroom/event activity**: puzzle-based activities, team building.
- **Do research**: turn a vague question into a precise research brief, run a
  multi-step deep research agent, search academic literature, read papers,
  build a reading list (调研, 文献, 综述, 深度研究, 论文).
- **Verify claims**: fact-check an AI answer or citations against primary sources
  (事实核查, 验证).
- **Write science**: generate a source-backed survey paper artifact.
- **Do scientific computing**: pick and use the right Python package
  (matplotlib, seaborn, statsmodels, sympy, astropy, biopython, scanpy,
  networkx, qiskit, cirq).

## Core Workflow

There are two lanes. Identify which one the request belongs to, then follow it.

### Education lane (teach / learn / prepare)

1. **Diagnose** — infer the learner's current level, goal, time available, and
   preferred depth from the prompt. Ask at most 1–3 short questions, only when
   the answer would materially change the lesson. If unsure, state a reasonable
   assumption and start.
2. **Set the mission** — for multi-session learning, capture *why* they want to
   learn it (concrete outcome, not "understand X"). Ground every decision in it.
3. **Teach one concept at a time** — concrete example before abstraction; keep
   lessons small enough to fit working memory; stay in the zone of proximal
   development (challenge "just enough", never overwhelming).
4. **Make it active** — include retrieval questions, prediction prompts, worked
   examples followed by a similar problem, debugging/critique tasks, or a
   knowledge check. Give specific feedback: why the right answer is right and
   why tempting wrong answers fail.
5. **Assess and adapt** — adjust difficulty from answers: slow down and add
   examples on confusion, increase difficulty when consistently correct,
   revisit misconceptions explicitly.
6. **Record progress** — for durable learning, keep learning records, a
   glossary, and reference docs (see `references/learning-and-teaching.md`).

For exam prep, route to the roadmap workflow (`references/exam-prep.md`);
for an interactive course artifact, route to `references/course-artifacts.md`.

### Research lane (question → evidence → verification → writing)

1. **Scope the question** — turn the vague need into ONE precise, self-contained
   research prompt: explain the project in plain English, name the single
   question to answer, number 3–6 sub-questions, state constraints, and define
   "done". Full template: `references/research-questions.md`.
2. **Search the right corpus** — arXiv/Semantic Scholar/PubMed for literature,
   policy corpora for regulation, general web search for current events. See
   `references/literature-search.md` and `references/research-questions.md`.
3. **Extract evidence** — download PDFs, pull transcripts, fetch pages. Keep
   stable identifiers (arXiv ID, PMID, PMCID, DOI) alongside every result.
4. **Verify** — check citations against the cited page (citation fidelity is a
   separate judgment from factual correctness) and corroborate material claims
   with primary sources. See `references/fact-checking.md`.
5. **Synthesize and write** — produce a cited report, literature review, or
   survey paper. Never invent bibliography entries.

## Selection Routing

| What the user asks for | Route to |
|---|---|
| Tutoring, explanations, study plans, lesson design | `references/learning-and-teaching.md` |
| Multi-session teaching workspace (MISSION/lessons/records) | `references/learning-and-teaching.md` |
| Classroom/event puzzle activities, 课堂活动 | `references/learning-and-teaching.md` (Activities) |
| Exam roadmap, past-paper analysis, flashcards, mock paper, readiness | `references/exam-prep.md` |
| Interactive course / mini-course / study-guide HTML artifact | `references/course-artifacts.md` |
| Source-backed academic survey paper artifact, 综述 | `references/survey-paper.md` |
| Vague → precise deep-research brief; deep-research agent runs | `references/research-questions.md` |
| Paper search, arXiv/Semantic Scholar/PubMed, PDF download, citations | `references/literature-search.md` |
| Fact-check an AI answer, verify citations, 事实核查 | `references/fact-checking.md` |
| Web scraping, YouTube transcripts, news sentiment briefing | `references/scraping-and-media.md` |
| Which Python lib for a stats/plot/math/bio/astro/graph/quantum task | `references/scientific-python.md` |

## Best Practices

- **Concrete before abstract.** Beginners need simple vocabulary, worked
  examples, and frequent checks; intermediates need comparison and common
  failure modes; advanced learners need compression, edge cases, and realistic
  tasks.
- **Build storage strength, not fluency.** In-the-moment recall feels like
  mastery but fades. Use retrieval practice, spacing, and (for skills)
  interleaving — this is "desirable difficulty".
- **Keep lessons short.** Learners' working memory is small. One tangible win
  per lesson beats a long lecture. Lessons may rarely be revisited; reference
  docs and glossaries will be — make those the compressed, well-structured
  artifacts.
- **Never fabricate evidence.** Every cited paper must be real, every survey
  bibliography entry must exist, every exam note must map to the uploaded
  syllabus. If input is missing, say so and ask.
- **Separate judgments in fact-checking.** A reputable source can still be an
  irrelevant citation. Record citation fidelity (faithful / unfaithful /
  unlinked / not cited) independently from the verdict (supported /
  contradicted / insufficient).
- **Corroborate consequential claims.** For time-sensitive facts verify
  publication dates; prefer primary sources (official docs, papers, filings,
  regulators) over forums and social media, which are weak signal only.
- **Define "done" before starting research.** Don't stop at the first plausible
  answer. Run a self-critique pass that lists gaps, contradictions, and
  single-source claims, then search again to close them.
- **Use stable identifiers and freshness cutoffs.** Report arXiv IDs, PMIDs,
  and corpus cutoff dates so results are reproducible and recent-claim
  judgments are honest.
- **Least privilege for tools.** Set explicit spend caps on paid scrape/search
  APIs, keep email as drafts unless sending is approved, and never expose API
  keys in logs, prompts, or outputs.

## Do & Don't

- **Do** match difficulty to the learner and the request's time budget.
- **Do** include a source link, the specific claim, and a one-line "why it
  matters" per research finding.
- **Do** open only validated, trusted URLs (https, no private/reserved hosts)
  when verifying citations.
- **Do** confirm ambiguous inputs (course code, save paths, research scope)
  once, then proceed.
- **Don't** teach a whole subject in one pass unless a survey is explicitly
  requested.
- **Don't** fabricate past-paper predictions beyond the supplied syllabus — flag
  predicted items as predicted.
- **Don't** pretend to execute code unless the environment actually runs it;
  give fixed snippets with expected outputs and reasoning instead.
- **Don't** treat search snippets as evidence — open the supporting page.
- **Don't** download paywalled full text or OCR scanned PDFs silently; state the
  limitation and offer alternatives.

## Example

**Input:** "I have my OS exam tomorrow. Here's the syllabus [paste] and 3 past
papers [upload]. I have 4 hours."

1. Route to `references/exam-prep.md`, Sprint mode (3–5 hrs).
2. Extract N questions, classify by type (theory/numerical/MCQ/coding/lab), tag
   difficulty Easy→Medium→Hard.
3. Build ranked tables and notes for the top ~25 questions, Easy across all
   types first.
4. Produce a coverage tracker mapping every note to a syllabus unit.
5. Offer flashcards, a predicted paper, or a readiness dashboard.

**Input:** "Write me a deep research brief on EU AI Act compliance for API
startups, then run it."

1. Route to `references/research-questions.md`; build the one-paragraph brief
   with 3–6 numbered sub-questions and a source hierarchy.
2. Execute via the chosen engine (Gemini Deep Research agent, DeepAPI
   `/v1/research/deep`, or batched web search with hard query minimums).
3. Verify consequential claims against primary sources, then output a single
   detailed markdown file.

## Common Pitfalls

- **Over-explaining before practice.** Lead with an active task for explicit
  practice requests; then give targeted feedback.
- **Coverage ≠ learning.** Merely covering material does not warrant a learning
  record — require evidence the user can use the concept.
- **Rate limits.** Semantic Scholar's anonymous tier throttles; back off with
  retries and fall back to arXiv for arXiv-indexed work rather than piling on
  parallel queries.
- **Context blowups.** Keep PDF page extraction capped (e.g. `--max-pages 10`),
  defer full-document reads until needed, and pull big-page content on demand
  rather than at once.
- **Wrong output shape.** Don't force learning into apps or web pages unless
  requested; don't leave citations only in hidden data — render real links.
- **Fallback masking.** If an automated path fails, tell the user you fell back
  and why, rather than silently switching tools.

## Safety & Limitations

- Requires the upstream tool, account, API key, or local setup when a workflow
  names one; never commit, print, or transmit keys.
- Generated predictions, scores, and reports are heuristics, not guarantees —
  exam prep cannot ensure marks, and sentiment/impact scores are briefing aids,
  not authoritative analysis.
- For medical, legal, financial, or policy-sensitive conclusions, require
  qualified professional review and cite sources with preserved uncertainty.
- Does not authorize destructive, production, paid, or external-message actions
  without explicit user approval.
