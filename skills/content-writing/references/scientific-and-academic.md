# Scientific & Academic Writing

Research-backed writing that survives peer review: manuscript structure, reporting guidelines, citations, and venue adaptation.

## Table of Contents
1. Process: outline → full paragraphs
2. IMRAD structure & section guidance
3. Writing principles (clarity, concision, accuracy, objectivity)
4. Reporting guidelines by study type
5. Figures and tables
6. Citations & reference management
7. Field-specific language
8. Common rejection reasons
9. Professional report formatting

## 1. Process: Outline → Full Paragraphs

**Never submit bullets in a scientific manuscript.** Use two stages:

1. **Stage 1 — outline.** Gather literature, then create a structured outline: main arguments, key studies to cite, data points, logical flow. Bullets are scaffolding only.
2. **Stage 2 — full prose.** Convert every bullet to complete sentences; add transitions; integrate citations naturally inside sentences; add context; ensure logical flow; vary sentence structure. Read paragraphs aloud to check flow.

**Where lists ARE acceptable:** only in Methods (inclusion/exclusion criteria, materials, participant characteristics) and Supplementary Materials. Never in Abstract, Introduction, Results, Discussion, or Conclusions. **Abstracts flow as paragraphs** — no labeled Background/Methods/Results sections unless the journal explicitly requires them.

## 2. IMRAD Structure & Section Guidance

- **Introduction:** importance of the problem → systematic literature review → knowledge gap → research question/hypotheses → novelty and significance.
- **Methods:** reproducible detail — participants/samples, procedures, statistics with justification, equipment, ethical approval/consent.
- **Results:** objective findings without interpretation; logical flow from primary to secondary outcomes; integrate figures/tables; report significance with effect sizes.
- **Discussion:** relate results to the question → compare with literature → honest limitations → mechanistic explanation → implications and future work.

**Drafting order:** figures & tables first (the data story) → Methods (easiest) → Results → Discussion → Introduction → Abstract → Title.

## 3. Writing Principles

- **Clarity:** precise language; define terms/abbreviations at first use; logical flow; active voice where clearer.
- **Concision:** cut redundant words; average 15-20 words per sentence; remove qualifiers; respect word limits.
- **Accuracy:** exact values at appropriate precision; consistent terminology; distinguish observations from interpretations; acknowledge uncertainty.
- **Objectivity:** unbiased results; no overstatement; acknowledge conflicting evidence; neutral professional tone.
- **Tenses:** past tense for methods/results, present for established facts.

## 4. Reporting Guidelines by Study Type

Follow the applicable checklist for completeness and transparency:
- **CONSORT** — randomized controlled trials
- **STROBE** — observational studies (cohort, case-control, cross-sectional)
- **PRISMA** — systematic reviews and meta-analyses
- **STARD** — diagnostic accuracy
- **TRIPOD** — prediction models
- **ARRIVE** — animal research · **CARE** — case reports
- **SQUIRE** — quality improvement · **SPIRIT** — study protocols · **CHEERS** — economic evaluations

## 5. Figures and Tables

- **Tables** for precise numerical data and multi-variable exact values; **figures** for trends, patterns, relationships.
- One table/figure per ~1000 words; never duplicate text vs display; each is self-explanatory with a complete caption; label all axes/rows/columns with units; include sample sizes (n) and statistical annotations.
- Common types: bar (categories), line (trends), scatter (correlations), box (distributions), heatmap (matrices).
- Ideal paper: graphical abstract + methods flowchart + results visualizations + a conceptual diagram.

## 6. Citations & Reference Management

**Major styles:** AMA/Vancouver (numbered, biomedical), APA (author-date, social science), Chicago (notes-biblio or author-date), IEEE (numbered square brackets, engineering).

**Practice:** cite primary sources; recent literature (last 5-10 years in active fields); balanced citation distribution across intro/discussion; verify every citation against the original; use a reference manager.

**BibTeX hygiene:** one entry type per source kind (`@article`, `@book`, `@inproceedings`, `@phdthesis`, `@misc`); complete required fields (author/title/year plus journal/volume/number/pages/DOI as applicable); standardize field order and author names; deduplicate; validate DOIs resolve; format pages as `123--145`.

**Metadata sources:** CrossRef (DOIs, free), PubMed E-utilities (biomedical, PMID/PMCID), arXiv API (preprints), DataCite (datasets/software).

## 7. Field-Specific Language

- **Biomedical:** precise clinical terminology ("myocardial infarction," not "heart attack"); patients vs participants; generic drug names first; standardized disease nomenclature.
- **Molecular biology:** italic gene symbols (*TP53*) vs regular proteins (p53); species-specific casing (BRCA1 vs Brca1); italics for binomial species names (*E. coli*).
- **Chemistry:** IUPAC nomenclature; SI-derived concentration units (mM, μM); standard notation.
- **Social/behavioral:** person-first language; validated construct names; "participants," not "subjects."
- **General:** match audience expertise (specialized vs broad-impact journals); define abbreviations at first use but don't over-define; keep terminology consistent throughout — one term per concept; don't mix clinical and basic-science register (don't call mice "patients").

## 8. Common Rejection Reasons

1. Incomplete/inappropriate statistics. 2. Over-interpretation or unsupported conclusions. 3. Poorly described methods. 4. Small/biased samples. 5. Poor writing quality. 6. Inadequate literature context. 7. Unclear figures/tables. 8. Failure to follow reporting guidelines.

**Revision pass:** check the "red thread" (logical flow), terminology consistency, self-explanatory displays, guideline adherence, citation accuracy, per-section word counts, grammar/spelling.

## 9. Professional Report Formatting

For research reports, white papers, grant/technical reports (not journal manuscripts): use a professional LaTeX style — Helvetica typography, colored box environments for key findings/methodology/recommendations/limitations, alternating-row tables, and scientific notation commands (`\pvalue`, `\CI{}`{}, `\effectsize`, `\meansd`, significance stars). Compile with XeLaTeX/LuaLaTeX.

For journal/conference-specific tone (e.g., Nature/Science story-driven, Cell mechanistic depth, NEJM structured abstracts, NeurIPS contribution bullets): adapt to the venue's conventions and reviewer expectations before submission.