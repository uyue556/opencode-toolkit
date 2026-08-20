# Auction Analysis — End-to-End Orchestration (Leilões de Imóveis)

Merged from `leiloeiro-ia`, the integrator skill. It orchestrates the five specialised auction
references: `auctions-edital.md`, `auctions-legal.md`, `auctions-valuation.md`, `auctions-market.md`,
`auctions-risk.md`. Use this when the user presents a lot/edital or asks a strategic auction question.

## When to use

Leilão, leilão judicial, leilão extrajudicial, hasta pública, arrematação, arrematar imóvel, auction
(拍卖), "analisa esse leilão", "vale a pena comprar em leilão".

## Request routing

| Type of request | Action |
|---|---|
| Specific edital/lote analysis | Full 7-step workflow + module cascade |
| Punctual legal doubt | Direct answer with precise legal basis |
| Market/price analysis | Focus on valuation + market references |
| Concept/education | Didactic explanation |
| Bid strategy | Combine legal + financial references |

## 7-step integrated workflow

1. **Enquadramento jurídico** — type (judicial / extrajudicial / bank / direct sale); applicable law
   (CPC, Lei 9.514/97); process phase; who runs the auction.
2. **Tipo de leilão**
   - Judicial (CPC 879–903): penhora → avaliação → edital → 1ª praça (lance mínimo = avaliação,
     Art. 891) → 2ª praça (any value except vil preço — below ~50% of valuation, STJ).
   - Extrajudicial / alienação fiduciária (Lei 9.514/97): consolidação → 1º leilão (mínimo = contract
     value) → 2º leilão (15 days later, mínimo = dívida) → if unsold, creditor keeps the property
     (Art. 27 §5).
   - Venda direta/bank: property already consolidated; direct negotiation, no public competition.
3. **Riscos jurídicos** — bem de família (Lei 8.009/90); cônjuge intimado (Art. 842 CPC); nullity and
   preclusion deadlines; pending ônus reais; propter-rem debts; suspensive appeals/embargos; edital
   regularity; matrícula status. See `auctions-legal.md`.
4. **Riscos financeiros e operacionais** — IPTU/condomínio debts, desocupação/imissão cost, obras,
   cartório costs (ITBI, escritura, registro), 5% comissão, realistic time-to-liquidity. See
   `auctions-risk.md`.
5. **Análise de mercado** — VMP estimate, current deságio, liquidity by region/typology, average
   resale time, end-buyer profile. See `auctions-valuation.md` + `auctions-market.md`.
6. **Estratégia recomendada** — safe max bid (VMP − costs − safety margin); ideal buyer profile;
   post-auction strategy (quick resale / reform+resale / income); exit conditions (when NOT to bid).
7. **Conclusão objetiva** — verdict template:

```
VEREDICTO: [COMPRAR / NÃO COMPRAR / COMPRAR APENAS SE...]
Valor máximo de lance: R$ ___________
Deságio atual: ____%   Deságio mínimo aceitável: ____%
Risco geral: [BAIXO / MÉDIO / ALTO / MUITO ALTO]
Prazo estimado de retorno: ___ meses   ROI estimado: ___% a.a.
PRINCIPAIS RISCOS: 1.___ 2.___ 3.___
AÇÃO RECOMENDADA: ___
```

## Module cascade (for a full edital analysis)

```
Passo 1: EDITAL → extract data (auctions-edital)
Passo 2: JURÍDICO → map legal risks (auctions-legal)
Passo 3: AVALIAÇÃO → estimate VMP and margin (auctions-valuation)
Passo 4: MERCADO → liquidity, ROI, strategy (auctions-market)
Passo 5: RISCO → integrated final score (auctions-risk)
Passo 6: VEREDICTO → unify in the Etapa 7 template
```

Each module feeds the next; keep the analysis cohesive, don't repeat information.

## Key legislation & jurisprudence

- CPC/2015 (Lei 13.105/2015), Arts. 774–925 (execution), esp. 829–854 penhora, 870–878 avaliação,
  879–903 expropriação/hasta, 904–909 adjudicação.
- Lei 9.514/1997 (alienação fiduciária); Lei 8.009/1990 (bem de família); CC (propriedade, garantias
  reais); Lei 6.015/1973 (registro); Decreto 21.981/1932 (regulamento de leiloeiros).
- STJ: Súmula 308 (hipoteca construtora-banco não impede adquirente), Súmula 478 (condominial credit
  has no preference over hipotecário), Súmula 364 (bem de família covers single/separated/widowed);
  REsp 1.582.489 (vil preço < 50% avaliação); REsp 1.616.038 (arrematante vs IPTU when edital silent —
  divergent, case-by-case).

## Auction platforms & portals

- General: leilaojudicial.com.br, zukerman.com.br, lanceimovel.com.br, sold.com.br, bidberry.com.br,
  superbids, megaleiloes.
- Banks (direct): Caixa leilaoimoveis.caixa.gov.br / caixavbr.com.br; BB
  portaldegarantias.bancodobrasil.com.br; Santander santanderx.com.br; Itaú estilocarteiraativo.com.br;
  Bradesco bradescoprevidencia.com.br/imoveis; Inter bancointer.com.br/imoveis.

## User profiles — communication

- **Leigo (first-time buyer):** no juridiquês (say "dívida que acompanha o imóvel" not "propter rem");
  analogies; clear risk examples; always recommend a lawyer for the paperwork; use ⚠️/✅.
- **Investidor (ROI):** straight to numbers — deságio, total cost, ROI, TIR, timeline; benchmark vs
  CDI/FIIs/poupança; liquidity & exit strategy; scenarios; financial tables.
- **Advogado:** precise articles/paragraphs/incisos; case law with numbers; divergent theses and
  majority currents; procedural terminology; deadlines and appeals.
- **Leiloeiro/corretor:** practical operation — comissão, responsibilities, documentation, regulation
  (Decreto 21.981/1932, JUCERJA).

## Absolute restrictions

Never invent laws/articles/decisions; never minimize documented legal risks; never guarantee an
investment result; always signal when analysis depends on specific documents; expose jurisprudential
divergences (e.g., arrematante vs IPTU debts).
