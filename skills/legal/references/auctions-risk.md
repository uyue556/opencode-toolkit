# Auction Risk Audit — 36-Point Score, Due Diligence & Stress Test

Merged from `leiloeiro-risco` (primary) with the legal-risk framing of `leiloeiro-juridico`. Maps
legal, financial, operational, and market risks; quantifies what can be quantified; recommends the
investment decision. Scores are indicative — the final decision is the investor's.

## Table of contents

- [1. Legal risks](#1-legal-risks)
- [2. Financial risks](#2-financial-risks)
- [3. Operational risks](#3-operational-risks)
- [4. Market & systemic risks](#4-market--systemic-risks)
- [5. The 36-point score](#5-the-36-point-score)
- [6. Due diligence checklists](#6-due-diligence-checklists)
- [7. Decision tree](#7-decision-tree)
- [8. ITBI / IR risks](#8-itbi--ir-risks)
- [9. Is the arrematante protected?](#9-is-the-arrematante-protected)
- [10. Stress test (4 scenarios)](#10-stress-test-4-scenarios)

---

## 1. Legal risks

**Nullity of the arrematação** — highest-impact items: missing spouse intimação (med prob / very high
impact 🔴); edital published incorrectly (low/high 🟡); defasada valuation >12m (med/med 🟡); unimpeached
impenhorável bem (low/very high 🔴); suspensive embargos (low/very high 🔴); pending appeals (med/high 🟡);
meação not respected (low/high 🟡). Mitigate: request the process records (e-SAJ/PJe), confirm spouse
intimação, check embargos, confirm edital publication.

**Bem de família checklist:** only property? → high risk; debtor resides there? → high risk; argued in
records? → check decision; execution is a condominial/tributary credit of the property itself → legal
exception (may seize); lease guarantor (fiança)? → Súmula 549 (may seize, divergent).
**Decision:** if it IS bem de família AND the execution is not a debt of the property or an Art. 3º
credit → RISK VERY HIGH — do NOT bid without deep records analysis.

**Hidden ônus reais:** hipoteca anterior (certidão de ônus — high, may retake); usufruto vitalício
(matrícula — very high, no use); prior penhora (distribuidor — medium); servidão (matrícula — medium);
aforamento/marinha (SPU — medium, laudêmio); usucapião action (distribuidor — high, third party);
registered promessa de compra e venda (matrícula — high). Always obtain the certidão.

## 2. Financial risks

**Accumulated debts:** IPTU — check prefeitura, total (principal + 20% fine + 1% a.m.), 5y prescrição
(CTN Art. 174), propter rem. Condomínio — full extract from síndico (taxa + fines + correction),
propter rem (Súmula 478), possible parallel cobrança action. Água/esgoto — concessionária; may suspend
service (usually personal debt, varies by state). Energia elétrica — personal debt (not propter rem).
Always fill the debt table before bidding.

**Desocupação cost table:** voluntary exit 0 days / 20–30% prob; negotiation + ajuda de custo R$3–10k,
30–90d, 30–40%; imissão without resistance R$5–15k, 3–6m, 20–30%; imissão + debtor appeals R$10–30k,
6–18m, 10–20%; long process + violence R$20–50k, 12–36m, 5–10%. Opportunity cost of immobilized
capital: `capital × CDI × months / 12`.

**Obra/reforma:** budget with a 30% contingency margin.

## 3. Operational risks

**Can't finalize the arrematação:** debtor pays before auto → auction undone, money returned
(any time, low-med); suspensive embargos → suspended (until auto, low); nullity argued in 10 days →
annulment (low); late bem de família recognition → autonomous action, complex defense (very low);
third-party embargos → requires defense (very low).

**Fraud/manipulation flags:** auctioneer not registered at Junta Comercial; unknown online platform
without verifiable CNPJ; valuation incompatible with market (extremes); edital published under legal
lead time; vague lot description without matrícula; deposit demanded before seeing documents.
Protect: verify auctioneer at Junta Comercial; confirm the process on the TJ system (e-SAJ/PJe/SEEU);
never pay without process confirmation.

## 4. Market & systemic risks

**Exit liquidity scenarios:** Selic >14% → credit costs more, demand falls, longer; recession → market
freezes, 2–3× time; high local unemployment → no end buyer; new nearby development → price pressure;
zoning change → devaluation; negative local event (crime/flood) → extra 20–40% deságio.

**Environmental/geotechnical:** landslide risk (CEMADEN); flood area (municipal master plan); APP
(river margins); soil contamination (industrial, gas stations); geotechnical laudo for slopes;
sinistro history (INMET, prefeitura). Sources: cemaden.gov.br, IBGE Malha Digital, Prefeitura (alvará/
habite-se/plano diretor), MDR/MCID.

## 5. The 36-point score

```
RISCOS JURÍDICOS:
[ ] Intimação cônjuge confirmada?     Sim:0 / Não:3 / Não verificado:2
[ ] Embargos com efeito suspensivo?   Não:0 / Sim:4
[ ] Bem de família provável?          Não:0 / Possível:2 / Provável:4
[ ] Ônus reais verificados e ok?      Sim:0 / Não verificado:2 / Ônus grave:4
[ ] Documentação regular?             Sim:0 / Irregular menor:1 / Grave:3

RISCOS FINANCEIROS:
[ ] Débitos IPTU + Cond. quantificados?  Sim(≤10% VMP):0 / Altos(>10%):2 / Não verificado:2
[ ] Situação da posse?                Desocupado:0 / Cooperativo:1 / Litigioso:3
[ ] Obras necessárias?                Não:0 / Leves:1 / Pesadas:3

RISCOS OPERACIONAIS:
[ ] Leiloeiro verificado?             Sim:0 / Não:2
[ ] Processo verificado no TJ?        Sim:0 / Não:2
[ ] Edital completo?                  Sim:0 / Incompleto:2

RISCOS DE MERCADO:
[ ] Liquidez local?                   Alta:0 / Média:1 / Baixa:3
[ ] Risco ambiental?                  Baixo:0 / Médio:2 / Alto:4

SCORE TOTAL: ___ / 36
0–5 BAIXO ✅ · 6–10 MÉDIO ⚠️ · 11–18 ALTO 🔴 · 19+ MUITO ALTO ❌
```

## 6. Due diligence checklists

**Mandatory (every lot):** certidão de ônus reais (matrícula atualizada, R$50–150); certidão negativa
de IPTU (or debt extract); full edital reading (Bloco 1–8); TJ/cartório process search; Junta Comercial
auctioneer check.

**Complementary (score >5):** civil distribuidor certidão; condomínio debt extract; property/street
visit (Google Street View minimum); síndico consult; water/sanitation extract.

**High-value lots (>R$500k):** specialist attorney records review; technical inspection laudo
(engineer); comparables with local CRECI broker; debtor certidões (fraude à execução); municipal master
plan (use & occupation).

## 7. Decision tree

```
≤5 BAIXO:     ROI líquido > CDI? SIM → ARREMATAR · NÃO → wait for better opportunity
6–10 MÉDIO:   problems mitigable AND ROI > CDI+5% → ARREMATAR com cautelas · else NÃO
11–18 ALTO:   you are a specialist AND ROI > CDI+15% → evaluate with attorney · else NÃO
>18 MUITO ALTO: NÃO ARREMATAR (exceptional cases with professional support)
```

## 8. ITBI / IR risks

**ITBI on VMP (not the bid):** many municipalities charge on the valor venal de referência, up to 3×
the cost on the bid. Legal basis to contest: STJ Tema 1.113 (ITBI on effective transaction value);
in judicial auctions the carta de arrematação is the title (value = bid); extrajudicial → escritura
with bid value. Impugn administratively or via mandado de segurança. Budget pessimistically on VMP.

**IR ganho de capital on resale:** 15% (up to R$5M gain); acquisition cost = bid + ITBI + comissão +
registro + documented works; isenção selling the only property up to R$440k/5y; isenção reinvesting in
another residential within 180 days. Keep all notas fiscais (reform, regularization) to reduce the gain.

## 9. Is the arrematante protected?

General rule (Art. 903 §5 CPC): arrematação in hasta pública = acquisition with judicial protection;
the good-faith arrematante is protected against prior fraudulent alienations.

| Scenario | Risk | Protection |
|---|---|---|
| Debtor sold before penhora | Very low | Art. 903 protects |
| Third party claims bought pre-penhora | Medium | Depends on registration + good faith |
| Usucapião action by third party | High | Title conflict — may annul |
| Debtor donated to relative (fraud) | Low | Hasta-protected |

Mandatory check: civil distribuidor certidão for real actions (usucapião, reivindicatória) over the
property — if a third-party claim exists → ALTO RISCO, avoid.

## 10. Stress test (4 scenarios)

```
OTIMISTA (20%): sell at VMP in 3m; no desocupação cost; ITBI on bid → ROI ___
BASE (50%): sell at 10% discount in 6m; desocupação negotiated (R$5k); ITBI on VMP → ROI ___
PESSIMISTA (25%): sell at 20% discount in 12m; imissão action (R$15k + 6m); reforma R$30k → ROI ___
CATASTRÓFICO (5%): arrematação annulled (capital returned) OR cannot sell in 24m OR hidden debts eat
the margin → ROI ___ (possibly negative)

ROI PONDERADO = 0.20·ROI_ot + 0.50·ROI_base + 0.25·ROI_pes + 0.05·ROI_cat
> CDI → ARREMATAR · < CDI → not worth the risk
```

## Risk glossary

Propter rem (obligation that follows the property); risco jurídico (annulment/nullity/impugnação);
risco operacional (desocupação/reforma/regularização difficulty); risco tributário (ITBI on VMP vs bid;
IR on resale gain); custo de oportunidade; stress test; due diligence; VaR; margem de segurança; fraude
à execução (Art. 792 CPC); ROI ponderado.
