# Property Appraisal for Auctions (ABNT NBR 14653)

Merged from `leiloeiro-avaliacao`. Senior engineer/architect appraiser for judicial and extrajudicial
auction valuations. Estimates are indicative — they never replace a licensed appraisal by a
CREA/CAU-registered professional.

## Table of contents

- [1. Types of value (ABNT NBR 14653-1)](#1-types-of-value-abnt-nbr-14653-1)
- [2. Method 1 — Direct comparative (main)](#2-method-1--direct-comparative-main)
- [3. Method 2 — Income (income-generating)](#3-method-2--income-income-generating)
- [4. Method 3 — Evolutionary / cost (special properties)](#4-method-3--evolutionary--cost-special-properties)
- [5. Reviewing a judicial valuation laudo](#5-reviewing-a-judicial-valuation-laudo)
- [6. Location score & safety margin](#6-location-score--safety-margin)
- [7. By property type](#7-by-property-type)
- [8. Online market research & CUB](#8-online-market-research--cub)
- [9. By value band & financing](#9-by-value-band--financing)

---

## 1. Types of value (ABNT NBR 14653-1)

| Concept | Definition | Use in auctions |
|---|---|---|
| Valor de Mercado (VMP) | Most likely free, informed, unconstrained transaction price | Edital basis (judicial valuation) |
| Valor de Liquidação Forçada (VLF) | Price under forced quick sale | Estimate the real auction price |
| Valor de Uso | Value for a specific use/user | End-buyer analysis |
| Custo de Reedição | Cost to reproduce under similar conditions | Special/industrial properties |

Practical relation: `VLF = VMP × (1 − fator de liquidação)` with typical factor 0.20–0.40.

## 2. Method 1 — Direct comparative (main)

For residential/commercial with market samples.

**Sample collection:** ≥5 comparable properties (Grau II/III ABNT): same neighborhood or comparable
region; same type; ±30% area band; recent transactions (last 6–12 months). Sources: ZAP, Viva Real,
OLX, Quinto Andar, registry escrituras, local CRECI brokers.

**Homogenization factors:**
- Área: `Fa = (Área Padrão / Área Amostra)^0.25` (smaller units carry higher R$/m²).
- Padrão construtivo (NBR 12721): Luxo/Alto 1.30 · Normal 1.00 · Simples 0.80 · Mínimo 0.65.
- Estado de conservação: Novo/Reformado 1.00 · Bom 0.90 · Regular 0.80 · Mau 0.65 · Ruim 0.50.
- Localização: Superior >1.00 · Similar 1.00 · Inferior <1.00 (calibrate by infrastructure/commerce/transit).
- Andar: low 1–3 = 0.95 · mid 4–9 = 1.00 · high 10+ = 1.05–1.15 · cobertura 1.20–1.50.
- Garagem: none 0.90–0.95 · 1 = 1.00 · 2 = 1.05–1.10.

**Statistics:** mean homogenized unit value; campo de arbítrio ±15% (Grau I) / ±10% (Grau II); remove
outliers (>2 standard deviations).

**Final:** `VMP = Valor Unitário Homogeneizado (R$/m²) × Área (m²)`.

## 3. Method 2 — Income (income-generating)

For malls, hotels, corporate slabs, gas stations, leased properties.

```
Renda Líquida Anual = Renda Bruta − Despesas Operacionais
Cap Rate = Renda Líquida / VMP        →   VMP = Renda Líquida / Cap Rate
```

Typical Brazilian cap rates (2024): residential high-end SP/RJ 4–6%; medium residential 5–8%; offices
7–10%; logistics galpões 8–12%; retail 8–12%; hotels 10–15%.

Example: R$10k/month leased, expenses IPTU 500 + condomínio 800 + vacancy 5% → net R$8,265/mo =
R$99,180/yr; cap rate 8% → VMP ≈ R$1,239,750.

## 4. Method 3 — Evolutionary / cost (special properties)

For industrial, galpões, hospitals, schools, no-comparables.

```
Valor Total = Valor do Terreno + Valor das Benfeitorias (depreciadas)
Benfeitorias = Custo de Reprodução × (1 − Depreciação)
```

**CUB (SINDUSCON, monthly per state; ref. SP Jan/2025 R$/m²):** R1-B 2.0–2.4k · R1-N 2.4–3.1k ·
R1-A 3.1–4.2k · R8-N 2.1–2.7k · R8-A 2.8–3.6k · R16-N 2.2–2.9k · CSL-8 2.7–3.8k · GI 1.4–2.0k.
Always consult sindusconsp.com.br for the current monthly figure.

**Depreciação (Ross-Heidecke)** — % retained: 0–10y: Novo 100/Bom 85/Regular 70/Mau 55 · 11–20y:
85/72/59/46 · 21–30y: 70/59/49/38 · 31–40y: 55/47/38/30 · >40y: 45/38/31/24.

## 5. Reviewing a judicial valuation laudo

Formalities: appraiser with valid CREA/CAU; inspection date (not emission); physical description;
declared method; Grau (I/II/III) and fundamentação. Technical content: ≥3 samples (Grau I) / ≥5
(Grau II); sample sources; homogenization shown; campo de arbítrio; resulting R$/m²; clear final calc.

Weak/suspicious signs: <3 samples; distant/foreign samples; no inspection date; value far from market
without justification; laudo copied from a prior process; appraiser without CREA/CAU in the property's state.

## 6. Location score & safety margin

**Score /50** (0–5 each): infrastructure — public transport, commerce/services, schools/hospitals,
parks; urbanism — favorable zone, build potential (coef. aproveitamento), restrictions (APP, marine
band, tombamento); market — historical appreciation, new developments, liquidity. Interpretation:
40–50 excellent · 30–39 good · 20–29 average · 10–19 below average · 0–9 poor (iliquidity risk).

**Safety margin / max bid:**
```
VMP − (ITBI + cartório ≈4–5%) − comissão 5% − débitos IPTU/condomínio − desocupação − obras −
margem 10–20% = LANCE MÁXIMO RECOMENDADO
```
Also state the minimum acceptable deságio over VMP.

## 7. By property type

- **Apartamento:** vagas, andar, face (sun), churrasqueira, depósito; very high liquidity in SP/RJ/BH/Curitiba.
- **Casa em condomínio:** leisure area, security, taxa, build restrictions; high liquidity.
- **Terreno urbano:** zone/coef. aproveitamento, incorporation potential (VGV); medium liquidity.
- **Sala comercial:** padrão, rua, pedestrian flow, vaga; low-medium liquidity.
- **Galpão logístico/industrial:** pé-direito ≥8m, docas, truck access, AVCB; medium-high on logistic axes.
- **Imóvel rural:** ITR, CAR, reserva legal, access, water, energy; low liquidity.

## 8. Online market research & CUB

15-minute script: (1) ZAP by neighborhood+type, filter ±20% area and bedrooms, note 5 sale-priced
samples with R$/m²; (2) Viva Real same search, 3–5 more; (3) apply elasticity — listings negotiate
10–15% (×0.85–0.90; ×0.80 weak market, ×0.92 hot); (4) average adjusted R$/m² × area = VMP ±15%;
(5) validate with Google Street View (entorno, commerce, transit, facade state).

## 9. By value band & financing

| Band | Error margin | Liquidity | Liquidation factor | Ideal deságio |
|---|---|---|---|---|
| Popular ≤ R$300k | ±15% | High | 0.20 | ≥30% |
| Medium R$300–800k | ±10% | Med-High | 0.25 | ≥35% |
| High R$800k–2M | ±10% | Medium | 0.30 | ≥40% |
| Luxo > R$2M | ±15% | Low | 0.35–0.45 | ≥45% |

Financing: direct sale CEF yes (up to 80% VMAV, FGTS); BB/Santander yes; extrajudicial depends on
edital; **judicial generally NO** (payment at auction or short installment, Art. 895 CPC: 25% down +
balance up to 30 installments, 1% a.m., hipoteca on the property — default = lose property AND the down
payment).

**References:** ABNT NBR 14653-1:2019, -2:2011, -3:2004; NBR 12721; CUB/SINDUSCON; COFECI; IBAPE;
FIPEZAP.
