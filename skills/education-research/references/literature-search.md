# Literature Search & Reading

Academic research workflows: search Semantic Scholar and arXiv, inspect
citations, download PDFs, extract text (*papers-skill*), plus deterministic
search across arXiv / PubMed / PMC / US policy corpora with freshness cutoffs
(*ii-commons*).

## 1. Papers CLI (Semantic Scholar + arXiv + PDF)

Bundled Python CLI `papers.py` (upstream; requires `httpx`, `arxiv`,
`PyMuPDF`). Install check with the **same interpreter** used to run it:

```bash
python -c "import httpx, arxiv, fitz" 2>&1 || python -m pip install httpx arxiv PyMuPDF
```

Subcommands:

| Subcommand | Purpose | Example |
|---|---|---|
| `search <query> [--limit N]` | Semantic Scholar search (max 20) | `search "diffusion models" --limit 5` |
| `detail <paper_id>` | Metadata, TL;DR, top references | `detail 10.48550/arXiv.2310.06825` |
| `citations <paper_id> [--limit N]` | Papers citing this one (max 20) | `citations <id> --limit 15` |
| `arxiv <query> [--max-results N]` | arXiv preprint search (max 10) | `arxiv "RLHF" --max-results 5` |
| `download <arxiv_id> [--save-dir D]` | Save PDF locally | `download 2310.06825 --save-dir ./pdfs` |
| `read <pdf_path> [--max-pages N]` | Extract embedded PDF text | `read ./pdfs/foo.pdf --max-pages 10` |

ID auto-detect: `10.` prefix → DOI; bare numeric 10+ digits → arXiv ID; long
hex → Semantic Scholar paperId.

### Typical flows

- **Literature scan**: `search` a topic → present a ranked table
  (`# | Title | Year | Citations | ID`) → ask which papers to dig into.
- **Deep-read one paper**: `detail` to confirm → `download` → `read` the first
  ~10 pages → summarize as problem · method · key result · limitations.
- **Impact analysis**: `detail` the anchor paper → `citations --limit 20` →
  cluster citing papers by year/theme, highlight most-cited follow-ups.

### Best practices

- Always `detail` before `download` to confirm the paper matches intent.
- Include the paper ID alongside every title so the user can re-query precisely.
- Cite as `[FirstAuthor et al., Year] *Title* (cites: N)`; report the absolute
  save path for downloaded PDFs.
- Don't crawl: the CLI retries 429s with exponential backoff; don't pile on
  parallel queries. Don't raise `--max-pages` to 100+ without warning — it
  consumes huge context.

### Limitations

- Cannot fetch paywalled full text (Elsevier, Springer, Wiley); open arXiv PDFs
  only. Scanned image-PDFs have no embedded text — offer an alternative version
  or note OCR is required.
- Semantic Scholar's anonymous tier rate-limits aggressively (message:
  "搜索失败: rate limit, retries exhausted"). Wait ~10s and retry once, or fall
  back to `arxiv` for arXiv-indexed work.
- Outbound HTTPS only to `api.semanticscholar.org` and `arxiv.org`; no
  credentials. Confirm the save path with the user before downloading to an
  unexpected location.

## 2. II-Commons (arXiv / PubMed / PMC / US policy)

Deterministic retrieval CLI `@intelligentinternet/ii-commons` (Node 18+).
Use when reproducibility, stable identifiers, or freshness matter.

- **Check freshness first**: `npx @intelligentinternet/ii-commons cutoff` —
  report the corpus cutoff date before interpreting "recent" results.
- **Search the right corpus**:
  ```bash
  npx @intelligentinternet/ii-commons search arxiv "large language model inference" --max-results 10
  npx @intelligentinternet/ii-commons search pubmed "type 2 diabetes review" --start 20240000 --max-results 10
  npx @intelligentinternet/ii-commons search policy "state overtime rule for agricultural workers" --jurisdictions US-CA --max-results 10
  ```
  `arxiv` = preprints/technical; `pubmed` = biomedical/clinical; `policy` =
  supported US policy corpora.
- **Retrieve**: `meta "arXiv:2402.03578"`, `markdown "PMCID:PMC11152602"`.
  Build summaries from search results first; fetch full Markdown only when
  detailed inspection or full-document grounding is needed.
- **Best practices**: prefer server-side date filters (`--start`, `--end` for
  arXiv/PubMed); preserve canonical identifiers (`arXiv:<id>`, `PMID:<id>`,
  `PMCID:PMC<id>`, `policy:<jurisdiction>:<id>`); use `cutoff` as the
  authoritative freshness boundary; keep non-time filters conservative until the
  first results show scope.
- **Security**: don't expose `II_COMMONS_API_KEY`; outputs are retrieval
  evidence, not expert review. Pass user-derived queries as argument arrays, not
  interpolated shell strings (double quotes don't protect against command
  substitution).

## 3. Building a Reading List / Survey Bibliography

- Expand the candidate pool beyond the anchor resource using a paper-search
  tool (Semantic Scholar, arXiv, an index).
- Curate only **real papers**; every entry needs key, authors, year, title,
  venue, 1–2 sentence summary. Never invent entries.
- See `survey-paper.md` for the full survey bibliography workflow.
