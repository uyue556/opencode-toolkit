# Source-Backed Survey Papers

Generate an academic-style survey paper as a single self-contained HTML file
with a curated bibliography. Adapted from DAIR.AI *survey-generator*. The agent
owns research curation; prose/figures/HTML are produced by an LLM in one API
call (upstream: Kimi via Fireworks `build_artifact.py`).

## Inputs

- `topic`: a concise survey topic (e.g. "Agentic Engineering").
- `source_url`: a public anchor resource — a curated list, canonical blog post,
  arXiv survey, GitHub awesome-list, or papers index. Rich anchors: DAIR.AI
  AI Papers of the Week, GitHub awesome-* repos, arXiv survey PDFs.
- Optional: `bibliography_size` (default 20; 40–50 comprehensive; 80–100
  exhaustive), `section_count` (default 6–10).

Collect missing inputs before proceeding.

## Workflow

1. **Read the anchor resource.** For GitHub repos fetch README and papers
   indices; for arXiv surveys use abstract, figures, section headings; for blog
   posts read in full. Extract subtopics and named papers/systems.
2. **Define the taxonomy and sections.** Rooted at the topic: 4–8 branches each
   with 2–4 non-overlapping children. Draft 6–10 numbered sections matching the
   progression: introduction → foundations → methods → evaluation → open
   problems.
3. **Curate the bibliography.** Only real papers, sized to `bibliography_size`.
   Each entry needs `key`, `authors`, `year`, `title`, `venue`, and a 1–2
   sentence `summary`. **Never invent papers.** Every section's `papers` array
   must reference existing bibliography keys.
4. **Write `research_bundle.json`** with the required top-level fields:
   `title`, `authors_placeholder`, `anchor_source`, `abstract_hints`,
   `taxonomy`, `paradigms`, `stack`, `sections`, `table`, `bibliography`.
5. **Run the generator** (upstream: `python3 build_artifact.py` from the skill
   dir; requires `FIREWORKS_API_KEY`; reads `research_bundle.json` +
   `style_spec.json`; writes a versioned HTML). Override the model with
   `FIREWORKS_MODEL=…`.
6. **Preview and iterate on inputs, never on output HTML.** Weak figures →
   sharpen `style_spec.json` (required figures, figure-quality notes); thin
   prose → tighten section `guidance` fields in the bundle.

## Bundle Schema Notes (research_bundle_template)

- `taxonomy`: `{root, branches:[{name, children:[leaf,…]}]}`.
- `paradigms`: per paradigm `{name, nodes:[…], flow:"A -> B -> C -> A"}`; use
  `bi:` to mark bidirectional edges.
- `stack`: ordered layers `[{name, role}]` (foundational → topmost).
- `sections`: `{id, title, guidance, papers:[keys]}`.
- `table`: `{columns:[…], rows:[{col: value,…}]}`.
- `bibliography`: `{key, authors, year, title, venue, summary}`.

## Figure Rules (from style_spec)

When a generated figure must obey layout constraints, enforce invariants
declaratively rather than hoping the model is careful:

- Absolute SVG viewport + per-element coordinates or a deterministic formula
  (e.g. `rect_pitch > rect_height`, fixed `rect_width`, `center_x` formula for N
  nodes, min horizontal gap between adjacent rects).
- Group each panel under `<g transform="translate(OFFSET,0)">` with panel-local
  coordinates to stop panels collapsing; pin translate offsets to the panel
  background x positions and center content on panel-local x.
- Figure captions must use the exact required IDs in sequence (Figure 1 before
  2 before 3), even if it means two figures in one section.
- Widen viewports (e.g. 720px) and keep labels within a fixed margin
  (e.g. tspans within x=710) to avoid clipping.

## Hard Rules

1. Never invent bibliography entries; every cited paper is a real work with a
   real venue.
2. Every section's `papers` reference keys present in the bibliography.
3. Never edit generated HTML — iterate on the bundle/style spec and rerun.
4. Keep the style spec topic-agnostic; topic content lives only in the bundle.
5. No em dashes or arrow symbols in bundle prose fields.

## Requirements

`FIREWORKS_API_KEY` in the environment; Python 3 stdlib only for the upstream
build script. Tested up to ~100 bibliography entries (`max_tokens` ~81920).

## Limitations

Requires the upstream tool/account/API key. Validate the generated artifact
against real sources before final use.
