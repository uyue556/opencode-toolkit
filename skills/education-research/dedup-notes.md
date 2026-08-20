# Dedup Notes — education-research

Consolidated 25 source SKILL.md files (education ×5, science ×10, research ×10)
into one skill with 9 sub-topic references.

## Topics merged

| Source skills | Merged into |
|---|---|
| `learn`, `teach`, `puzzle-activity-planner` | `references/learning-and-teaching.md` |
| `examprep-ai` | `references/exam-prep.md` |
| `lesson-generator` | `references/course-artifacts.md` |
| `survey-generator` | `references/survey-paper.md` |
| `research-prompt`, `gemini-deep-research`, `pi-web-search`, `deepapi` (research/deep + search/web) | `references/research-questions.md` |
| `papers-skill`, `ii-commons` | `references/literature-search.md` |
| `fact-check-x-complete` | `references/fact-checking.md` |
| `deepapi`, `youtube-transcript`, `news-sentiment-engine` | `references/scraping-and-media.md` |
| `astropy`, `biopython`, `cirq`, `matplotlib`, `networkx`, `qiskit`, `scanpy`, `seaborn`, `statsmodels`, `sympy` | `references/scientific-python.md` |

## Notable duplicates dropped / merged

- **Web-search engines** (`pi-web-search`, DeepAPI `/v1/search/web`,
  `/v1/research/deep`) all cover "get current web evidence." Kept the
  query-count routing from pi-web-search, folded the DeepAPI search/research
  endpoints into one table, and dropped the duplicate curl bodies.
- **Research-execution engines** (`gemini-deep-research` CLI vs DeepAPI
  `/v1/research/deep` vs batched web search) share the "run a cited report"
  job; each kept only its unique mechanics in `research-questions.md`.
- **PDF/text extraction** appears in `papers-skill` (`read`), `pi-web-search`
  (`fetch_content`), and `ii-commons` (`markdown`); kept one "how to read a
  paper" flow and cross-referenced the tools.
- **"Never invent citations / validate against real sources"** appeared in
  `survey-generator`, `fact-check-x-complete`, `papers-skill`, `learn`, and
  `teach`; consolidated into the SKILL.md Best Practices and each relevant
  reference once.
- **Safety boilerplate** ("requires upstream tool/API key; no unauthorized
  external actions") was duplicated verbatim in `learn`, `teach`,
  `lesson-generator`, `survey-generator`, `deepapi`, `youtube-transcript`,
  `pi-web-search` — reduced to one section in SKILL.md.
- **DeepAPI endpoint descriptions** repeated the same safety/polling text ~18
  times; collapsed into a single endpoint table + one execution loop.
- **Lesson-structure advice** overlaps between `learn` and `teach` (objectives,
  active practice, feedback, next step); kept the tutoring-loop form from
  `learn` and the workspace/mission form from `teach` as distinct sections.
- **Marketing/promotional content dropped**: news-sentiment-engine's "Pro
  Version $29" pitch, self-congratulatory preambles, and version-pinning/
  provenance hash boilerplate.

## Scripts

- No `scripts/` directories were actually shipped in the source libraries
  (`papers-skill` references `scripts/papers.py`, `gemini-deep-research`
  references `scripts/research.py` + `requirements.txt`, `survey-generator`
  references `build_artifact.py` — none present on disk).
- Carried over the one genuinely self-contained, deterministic snippet: the
  yt-dlp `json3 → txt` flattener → `scripts/yt_json3_to_txt.py`.
- `survey-generator`'s `style_spec.json` (13KB) and `research_bundle_template.json`
  were condensed into reference prose in `survey-paper.md` because the build
  script they serve is not present; the bundle schema is preserved as a
  reproducible template there.

## Dropped content

- **`teach`'s HTML-lesson authoring** (beautiful Tufte-style lessons, assets
  components) — kept in condensed form in `learning-and-teaching.md`, but the
  HTML formatting specifics are runtime concerns.
- **DeepAPI image generation and email endpoints** — kept in the endpoint table
  (research-adjacent workflows) but detail trimmed.
- **`news-sentiment-engine`'s optional Node clone setup** — summarized as a
  caveat; the core pattern (RSS → dedup → sentiment → briefing) is fully kept.

## Gaps / doubts

- Science skills (10) were skimmed via frontmatter + headings only; their
  full-depth code examples were not read. `scientific-python.md` gives routing
  and orientation, not library-grade detail — acceptable for this domain, but a
  deeper pass would recover more code snippets.
- `gemini-deep-research` and `papers-skill` scripts are referenced but absent,
  so their CLI invocation paths in the references are best-effort reconstructions.
- `survey-generator`'s rendered HTML example and full `style_spec.json` are not
  carried (missing build script + size); workflows that need the actual renderer
  must obtain it upstream.
