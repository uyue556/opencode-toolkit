# Deduplication & Synthesis Notes

Consolidation of 14 source skills → 1 consolidated `legal` skill. Source dirs:

```
/home/administrator/.config/opencode/skill-libraries/legal/       (8 skills)
/home/administrator/.config/opencode/skill-libraries/leiloeiro/   (6 skills)
```

## Source inventory (14 SKILL.md scanned)

| # | Source | Merged into |
|---|---|---|
| 1 | legal/advogado-criminal | `references/brazilian-criminal-law.md` + SKILL.md §Criminal |
| 2 | legal/advogado-especialista | SKILL.md (framework) + many references |
| 3 | legal/customs-trade-compliance | `references/customs-trade-compliance.md` |
| 4 | legal/employment-contract-templates | `references/employment-contract-playbook.md` (carried verbatim) |
| 5 | legal/fda-food-safety-auditor | `references/fda-food-safety.md` |
| 6 | legal/fda-medtech-compliance-auditor | `references/fda-medtech.md` |
| 7 | legal/legal-advisor | SKILL.md §Good-first-analysis / §Advisor mode |
| 8 | legal/lex | `references/lex-cross-jurisdictional.md` + `references/lex-findings.md` (carried verbatim) |
| 9 | leiloeiro/leiloeiro-avaliacao | `references/auctions-valuation.md` |
| 10 | leiloeiro/leiloeiro-edital | `references/auctions-edital.md` |
| 11 | leiloeiro/leiloeiro-ia | `references/auctions-orchestration.md` (orchestrator role absorbed) |
| 12 | leiloeiro/leiloeiro-juridico | `references/auctions-legal.md` + risk framing in `auctions-risk.md` |
| 13 | leiloeiro/leiloeiro-mercado | `references/auctions-market.md` |
| 14 | leiloeiro/leiloeiro-risco | `references/auctions-risk.md` (primary) |

## Sub-topic merge mapping (14 → 1)

- **Criminal law + Maria da Penha**: advogado-criminal + overlapping content in advogado-especialista →
  `brazilian-criminal-law.md` (single source of truth for the 5 victim-flow channels, protective measures,
  Pacote Antifeminicídio, surveillance law, procedural steps).
- **Auction domain**: 6 leiloeiro skills shared ~30% boilerplate (orchestrator preamble, disclaimers,
  common CPC/9.514 references, portal list). Removed duplication; each area kept its unique content:
  valuation (NBR 14653), edital audit (8 blocks), legal framework, market/liquidity, risk scoring,
  orchestration (7-step workflow).
- **Fontes**: 8 fontes.md files → single `fontes.md` (de-duplicated legislative/jurisprudential lists;
  merged auction portals across all 6 leiloeiro sources; merged US/EU/UK customs + FDA + LEX official
  sources).
- **Customs**: decision-frameworks.md, edge-cases.md, communication-templates.md carried verbatim as
  separate references (referenced by customs-trade-compliance.md).

## Duplicates dropped

1. Repeated orchestration preambles ("Integração", "ponto de contato") present in all 6 leiloeiro
   SKILL.md files → collapsed into `auctions-orchestration.md` §1 workflow; rest removed.
2. Repeated disclaimers/risk warnings repeated verbatim in each source → kept once in SKILL.md §Safety
   boundaries + once in auction references.
3. Repeated legislation references across fontes.md files (CPC 774–925, Lei 9.514/1997, NBR 14653,
   Lei 8.009/1990) → single canonical entry in `fontes.md`.
4. Overlap criminal/family between advogado-especialista and advogado-criminal (e.g., Maria da Penha
   both places) → deduplicated to criminal ref.
5. Overlap between leiloeiro-juridico and leiloeiro-risco on nullity/impugnação and desocupação →
   legal framework in `auctions-legal.md`; quantified risks in `auctions-risk.md`.
6. Duplicate ITBI discussion across leiloeiro-market, leiloeiro-risco, and leiloeiro-ia → single
   section in `auctions-risk.md` §8.
7. Templates duplicated between employment-contract-templates (template copies under `templates/`) →
   not carried (only the playbook); referenced in SKILL.md selection table.

## Scripts

- **0 scripts carried.** None of the 14 source skills contained a `scripts/` directory (verified in the
  inventory: every source had only SKILL.md + references/ + templates/). The consolidated skill ships an
  empty `scripts/` dir per SYNTHESIS.md.

## Carried verbatim (5 files)

- `references/employment-contract-playbook.md` (from employment-contract-templates/resources/)
- `references/lex-findings.md` (from lex/findings.md)
- `references/customs-decision-frameworks.md`
- `references/customs-edge-cases.md`
- `references/customs-communication-templates.md`

## Gaps / doubts

1. **Dates**: source SKILL.md files carry `date_added` ranging 2024–2026 (several marked 2026-03-06);
   trustworthiness unknown. Checked. Figures marked as reference-period (Selic/CDI 2025, CUB Jan/2025)
   should be re-verified by the agent at use time — noted in each reference.
2. **No scripts anywhere** — SYNTHESIS.md expected `scripts/` to carry tooling; none existed.
3. **Lex templates** (`lex/templates/*.md`) were read for content but not carried (many are
   jurisdiction-specific boilerplate already covered by `lex-cross-jurisdictional.md` + `lex-findings.md`).
4. **Consolidated SKILL.md must stay <500 lines** — references carry the depth; the selection table
   enumerates all 21 reference files (must all exist).
5. `employment-contract-templates` had a `resources/implementation-playbook.md` inside a
   non-`references/` dir — mapped to `references/` in the consolidated layout.
