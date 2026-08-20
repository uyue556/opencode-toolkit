# Editing & Proofreading (incl. Humanizing AI Text)

Making prose correct, clean, and human — proofreading, AI-tell removal in English and Chinese (去AI味/降AIGC), and style transfer.

## Table of Contents
1. Proofreading workflow (preserve voice)
2. English AI-tell removal (21 pattern categories)
3. Humanizing Chinese text — 去AI味/降AIGC
4. Automated cleanup (unslop CLI)
5. Concise rewrites

## 1. Proofreading Workflow (Preserve Voice)

Transform flawed writing into publication-ready prose **without altering the author's intent or voice**.

**Do:** fix grammar (subject-verb agreement, tense consistency, articles, prepositions, pronouns), spelling (keep US/UK variant), punctuation (commas, apostrophes, quotes, sentence boundaries), readability (structure, flow, redundancy).

**Never:** change meaning, formalize casual writing without cause, dilute emotional intensity, replace distinctive vocabulary for no reason, expand content, or rewrite whole paragraphs that are merely imperfect.

**Process for inline text:**
1. **Isolate** the text meant for proofreading.
2. **Error-detection pass:** grammar, spelling, punctuation, fragments, run-ons, tenses, articles, pronouns, redundancy, awkward phrasing.
3. **Voice-preservation check (critical):** before editing a sentence, ask — is the tone intentional? Is the repetition rhetorical? Is the fragmentation stylistic? If grammatically valid and intentional → do not change.
4. **Minimal necessary corrections:** smallest effective edit; precision over preference.
5. **Clarity & flow:** break run-ons, merge fragments, improve transitions, remove redundancy.
6. **Validation:** confirm zero remaining errors, tone consistent, meaning unchanged, no stylistic identity erased; document every edit.

**Output:** corrected version + a modification log (or an updated file with `UPDATED_` prefix when the user requests file mode). A friendly closing note.

## 2. English AI-Tell Removal

When asked to "clean up AI writing" / "make this sound less like AI," audit for AI-isms, then rewrite.

**Detect (21 pattern categories):** formatting issues (em dashes, bold overuse, emoji-style headers, bullet-heavy sections), sentence-structure problems (hedging, hollow intensifiers, rule of three), template/transition phrases, significance inflation ("pivotal," "serves as a testament to"), copula avoidance, synonym cycling (repeating the same idea in fresh words), vague attributions, filler phrases, generic conclusions, chatbot artifacts, promotional language, false ranges, inline-header lists, title-case headings, cutoff disclaimers.

**Replace (43-entry table, sample):**
- leverage → use; utilize → use; robust → reliable; seamless → smooth/straightforward; foster → build/encourage; embark → start; cutting-edge → new/modern; streamline → simplify; "In today's rapidly evolving landscape" → cut.

**Output format (audit):** (1) **Issues found** — quote every AI-ism; (2) **Rewritten version**; (3) **What changed**; (4) **Second-pass audit** — re-read the rewrite for surviving tells.

**Caveats:** pattern matching is guideline-based, not absolute (some flagged words are fine in context); it doesn't verify facts or find real citations for vague attributions.

## 3. Humanizing Chinese Text — 去AI味/降AIGC

Detect AI-like Chinese writing, make it sound natural, and optionally convert styles.

**Detection markers:** rigid 第一/第二/最后 structures; mechanical connectors (综上所述, 值得注意的是, 由此可见); abstract grandiose wording with low information density; repeated sentence rhythm and even paragraph length; conclusions too complete, certain, and template-driven.

**Rewrite in the smallest useful pass:** remove formulaic connectors first; vary sentence length and paragraph rhythm; replace repeated verbs/nouns; swap abstract summaries for concrete observations; keep claims, facts, citations, and terminology intact.

**Academic AIGC reduction** (for 知网/维普/Wanfang-style checks): keep discipline-specific terminology unchanged; replace AI-academic stock phrases with grounded scholarly phrasing; reduce absolute certainty with measured hedging; vary paragraph structure; add limitations if the conclusion feels unnaturally complete. Example shifts: 本文旨在 → 本文尝试/本研究关注; 具有重要意义 → 值得关注/有一定参考价值; 研究表明 → 前人研究发现/已有文献显示. Never invent citations or data.

**After rewriting, validate:** same meaning, less templated, natural rhythm, no factual drift, correct register. For academic text, do not over-casualize.

**Style conversion** (only after the base text reads naturally): casual, zhihu, xiaohongshu, wechat, weibo, literary, academic — change tone/structure/surface wording, keep meaning stable.

**Output rules:** show the main AI-like patterns found; explain the rewrite strategy in 1-3 bullets; return the rewritten text; optional note on remaining weak spots.

## 4. Automated Cleanup (unslop CLI)

Deterministic post-processing for AI prose (prose only — never code/JSON/structured data):
```bash
echo "This leverages cutting-edge AI…" | unslop --stdin --deterministic
cat draft.md | unslop --stdin --deterministic > clean.md
```
Use `--deterministic` in CI/pre-commit so output is reproducible. Run unslop on the final draft, not iterations. Combine with the manual audit above. Always review output — automated cleanup can occasionally shift meaning. Doesn't catch factual errors.

## 5. Concise Rewrites

When the user wants a shorter, simpler, or TLDR version: rewrite the previous output more briefly while preserving all substance. Do nothing else. Compress structure and examples, never claims. (Pair with `bulletmind` in `storytelling-and-creative.md` when a bullet hierarchy is wanted instead of prose.)