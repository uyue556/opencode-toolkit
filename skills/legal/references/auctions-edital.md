# Auction Edital — Pericial Audit of Auction Notices

Merged from `leiloeiro-edital`. Audits judicial and extrajudicial auction notices (editais) for hidden
risks, dangerous clauses, debts, occupation, and opportunity classification.

## 8-block audit protocol

### Bloco 1 — Identification & framing
Extract: process number (judicial), auctioneer name & habilitation (Junta Comercial), platform,
dates/times of 1st and 2nd auctions, comitente (bank, exequente, cartório), type (judicial CPC /
extrajudicial Lei 9.514 / venda direta), modalidade (1º/2º/único).

### Bloco 2 — Property description & location
Address (full, CEP, number, complement); type; total and built area (compare with matrícula); matrícula
number and registry; IPTU number; construction standard; declared conservation state; garage included?
Alerts: edital area ≠ matrícula area → possible irregularity; no matrícula number → research before
bidding; vague description → request the valuation laudo.

### Bloco 3 — Valuation and minimum bid
Extract: Valor de Avaliação (VAN); minimum 1st bid (= VAN judicial / VAN extrajudicial); minimum 2nd bid
(≈50% VAN judicial / dívida extrajudicial); valuation date; appraiser.
Alert flags: valuation >12 months old (revaluation possible, Art. 873 CPC); VAN far below/above market
(investigate); extrajudicial 2nd minimum = dívida → can be far below market (opportunity).

### Bloco 4 — Occupation status
Is the property vacant, occupied by the executado, occupied by third party (tenant/invader), or omitted
(⚠️ risk)? Impact table:

| Situation | Risk | Est. cost | Timeline |
|---|---|---|---|
| Vacant | Low | Zero | Immediate |
| Cooperative debtor | Med-Low | Negotiation | 30–90 days |
| Resistant debtor | High | R$ 5–15k (action) | 6–18 months |
| Tenant with contract | Medium | Indemnity | 3–6 months |
| Third-party invader | High | Reintegração action | 6–24 months |

If occupied: who answers for desocupação per the edital? Imissão liminar already granted? Legal support
from bank/credor? Registered lease with running term (may have to be respected)?

### Bloco 5 — Debts & registered ônus
Debts: IPTU, condomínio, lixo/iluminação, água/esgoto, melhoria. Clause reading table:

| Edital wording | Interpretation | Risk |
|---|---|---|
| "vendido no estado em que se encontra" | Debts may follow | High |
| "livre de ônus" | Arrematante doesn't answer | Low |
| "débitos a cargo do arrematante" | You pay everything | High — quantify |
| Edital silent on debts | Propter-rem rule applies | Medium |
| "débitos pagos com o produto da arrematação" | Judge reserves funds | Low |

ALWAYS quantify before bidding: IPTU certificate, condomínio extract, water/gas declaration.

Ônus reais on the matrícula: hipoteca (bank, value, date), prior alienação fiduciária, usufruto (who,
lifetime?), servidão, inalienabilidade clause, aforamento/terreno de marinha (laudêmio 5% per
transmission), prior penhoras (preference order). Usufruto vitalício → no right of use while the
usufrutuário lives.

### Bloco 6 — Payment conditions
Accepted forms; cash deadline; parcelamento (Art. 895 CPC: 25% at auction + balance up to 30 days or as
determined); bank financing accepted? Leiloeiro comissão __% (standard 5%) — on the bid or separate?
ITBI (2–3% by municipality); registro/escritura costs.

**Total cost estimate:** lance + comissão (5%) + ITBI (2–3%) + registro + advogado (if imissão) + IPTU
arrears + condomínio arrears + obras = CUSTO TOTAL REAL.

### Bloco 7 — Documentary & legal regularity
(a) Edital publication (Art. 887 CPC / Art. 27 Lei 9.514): official gazette, major newspaper, court
portal, 5-day minimum lead? (b) Mandatory intimações (Art. 889): devedor/fiduciante, cônjuge,
hipotecário creditor, usufrutuário, preemption-right holder? (c) Leiloeiro habilitado: Junta Comercial
matrícula, court accreditation, extrajudicial auctioneer appointed by creditor. (d) Edital complete
(Art. 887 §1): description, valuation, ônus, payment conditions, date/time/place.

## Risk matrix (/14)

| Factor | Low (0) | Med (1) | High (2) |
|---|---|---|---|
| Posse | Vacant | Occupied (cooperative) | Occupied (litigious) |
| Débitos | Free of ônus | Informed & quantified | Omitted or high |
| Ônus reais | None | Subrogated hipoteca | Usufruto/penhoras |
| Documentation | Perfect | Minor irregularities | No habite-se/averbação |
| Processo | No embargos | Non-suspensive embargos | Suspensive embargos |
| Avaliação | Current & fair | Defasada | Over/under-valued |
| Deságio | > 40% | 20–40% | < 20% |

Score: 0–2 BAIXO ✅ · 3–6 MÉDIO ⚠️ · 7–10 ALTO 🔴 · 11–14 MUITO ALTO ❌.

## Verdict template

```
EDITAL #___ · Imóvel: ___ · Data: ___
SCORE /14: ___ · CLASSIFICAÇÃO: ___
DESÁGIO POTENCIAL: ___% · CUSTO TOTAL ESTIMADO: R$ ___ · VMP ESTIMADO: R$ ___ · MARGEM: R$ ___
POSITIVOS: ✅ ___
ALERTAS: ⚠️ ___
AÇÃO: [ ] ARREMATAR [ ] ARREMATAR com cautelas [ ] AGUARDAR 2º LEILÃO [ ] NÃO ARREMATAR [ ] DILIGÊNCIAS
```

## Key deadlines

5 days edital lead (Art. 887 CPC) · 15 days purga da mora extrajudicial (Art. 26 §1 Lei 9.514) ·
10 days to annul arrematação (Art. 903) · 30 days 1st→2nd extrajudicial · 15 days to pay balance
(Art. 890) · 60 days imissão na posse (judicial, Art. 894).

## Bank direct-sale editais (CEF, BB, Santander)

- **Caixa (caixavbr.com.br):** lot identification, VMAV (Valor Mínimo de Aquisição e Venda), à vista
  discount 5–10%, CEF financing up to 80% VMAV / 360 months, FGTS allowed, "no estado em que se
  encontra", debts usually on the buyer, 5% comissão. Not subject to CPC.
- **BB/Santander/Itaú:** simplified edital (not CPC); bank-set price (internal laudo); 5–6% commission;
  may finance; **"no estado em que se encontra e ônus" = buyer assumes EVERYTHING** (IPTU, condomínio,
  obras, ocupação).
- Direct-sale checklist: VMAV vs market (ZAP/VivaReal); financing/FGTS; proposal deadline; embedded vs
  separate commission; explicit debt responsibility; occupied/vacant status; available inspection.

## Top-10 edital traps

1. "No estado em que se encontra e ônus" → surprise debts.
2. Edital silent on occupation → desocupação cost.
3. Valuation 3+ years old → defasado value.
4. High condomínio not informed → elevated fixed expense.
5. Faixa de marinha / aforamento → 5% laudêmio.
6. Garage "exceto box" → you lose the spot.
7. Built area not averbada → regularization cost.
8. 2nd auction = dívida (not market) → looks great, check debts.
9. Comissão "ALÉM do lance" → 5% extra.
10. Parcelamento with steep interest (IGP-M/IPCA/1% a.m.) → hidden finance cost.
