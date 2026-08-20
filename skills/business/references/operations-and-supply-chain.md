# Operations & Supply Chain

Operational excellence across retail, manufacturing, logistics, energy, and quality. Sources: `inventory-demand-planning`, `production-scheduling`, `quality-nonconformance`, `returns-reverse-logistics`, `energy-procurement`, `carrier-relationship-management`, `customer-support`.

## 1. Inventory Demand Planning

**Role context:** demand planner at a 40–200 store retailer, 300–800 SKUs, between merchandising/supply chain/finance.

### Forecasting methods by demand pattern

| Pattern | Primary method | Fallback |
|---|---|---|
| Stable, high-volume | Weighted moving average (4–8 wk) | Single exponential smoothing |
| Trending | Holt's double exponential | Linear regression (26 wk) |
| Seasonal | Holt-Winters | STL decomposition + SES |
| Intermittent/lumpy (>30% zero) | Croston's / SBA | Bootstrap simulation |
| Promotion-driven | Causal regression (baseline + promo lift) | Analogous item lift |
| New product (0–12 wk) | Analogous item profile | Category average |
| Event-driven | Regression with external regressors | Manual override, documented |

Optimize alpha/beta/gamma on holdout data, never the fitting data. High alpha (>0.3) chases noise; low alpha (<0.1) responds too slowly.

### Forecast accuracy metrics

- **MAPE**: breaks on low-volume items (use only for 50+ units/week).
- **WMAPE**: Σ|errors| / Σ|actuals| — reflects dollars; finance's metric.
- **Bias**: <±5% healthy; >±10% = structural problem.
- **Tracking signal**: cumulative error / MAD; >±4 = model drifted, re-parameterize.

### Safety stock

- `SS = Z × σ_d × √(LT + RP)` for normal, stationary demand. Service levels: 95% (Z=1.65) A-items, 99% (Z=2.33) critical, 90% (Z=1.28) C-items. **95%→99% nearly doubles safety stock** — quantify the cost.
- With lead-time variability: `SS = Z × √(LT_avg × σ_d² + d_avg² × σ_LT²)`. Vendors with CV > 0.3 need 40–60% more safety stock.
- Lumpy demand → Croston's + bootstrapped distribution. New products → analog profiling + 20–30% buffer for 8 weeks.

### Reorder logic

- **Inventory position** = on-hand + on-order − backorders − committed. Never reorder on on-hand alone.
- Min/Max (stable demand); ROP/EOQ (`√(2DS/H)`, round to case packs); Periodic review (R,S) for fixed vendor days; vendor-tier review frequencies (A weekly, B bi-weekly, C monthly).

### Promotions

- Strip promo volume from baseline history; apply lift multiplicatively.
- Typical lifts: 15–40% TPR only; 80–200% TPR + display + circular; 300–500%+ doorbuster.
- Cannibalization 10–30% for close substitutes; model post-promo dip (30–50% of incremental lift, weeks 1–3).

### ABC/XYZ classification

- ABC on **margin contribution** (not revenue): A = top 20% → 80% of margin; B = next 30% → 15%; C = bottom 50% → 5%.
- XYZ on de-seasonalized CV: X <0.5, Y 0.5–1.0, Z >1.0.
- Policy: AX automated + tight SS; AZ human review every cycle; CX automated generous; CZ discontinuation candidates.

### Seasonal management

Buy 12–20 weeks ahead; allocate 60–70% initial, keep 30–40% open-to-buy reserve. Markdowns when sell-through <60% of plan at midpoint; each week of markdown delay costs 3–5 points of margin. Hard cutoff 2–3 weeks before next season.

### Escalation triggers

Projected A-item stockout within 7 days → 4 hrs; vendor lead time +25% → 1 day; promo forecast miss >40% → 1 week; excess >26 wks supply → 1 week; bias >±10% for 4 wks → 2 weeks; service <90% → 48 hrs.

**KPIs:** WMAPE <25%, bias ±5%, A-item in-stock >97%, weeks of supply 4–8, excess >10% red flag, dead stock <2%.

## 2. Production Scheduling

**Role context:** senior scheduler, discrete/batch manufacturing, 3–8 lines, 50–300 staff/shift, between production/planning/quality/maintenance.

### Fundamentals

- **Forward vs backward**: backward is default (preserves flexibility, minimizes WIP); switch to forward when latest-start is already past (expedite).
- **Finite vs infinite capacity**: MRP is infinite; never trust an MRP schedule without running finite-capacity logic. MRP = *what*; FCS = *when*.
- **Drum-Buffer-Rope (ToC)**: drum = constraint (highest util ratio, >85%); buffer = time buffer (~50% of constraint lead time) protecting the drum; rope limits new work to the drum's rate. A minute lost at the constraint = a minute lost for the whole plant.
- **JIT/heijunka**: level the sequence (A:B:C 3:2:1 → A-B-A-C-A-B, not AAA-BB-C).

### Changeover optimization (SMED)

Phase 1: document + classify internal/external. Phase 2: convert internal→external (pre-staging tools). Phase 3: streamline internal (quick-release clamps). Phase 4: eliminate adjustments (poka-yoke). 40–60% setup reduction from phases 1–2. Sequence light→dark / small→large. Campaign vs mixed-model: lean toward campaigns when changeovers >60 min / >$500; mixed-model when <15 min or short lead times needed.

### Bottleneck management

WIP pileup ≠ constraint (could be upstream batch-dumping or shared resource). Verify: would adding 1 hr capacity here increase plant output? Buffer zones: green <33% (protected), yellow 33–67% (expedite), red >67% (management attention). **Subordination:** non-constraints serve the constraint, not their own utilization. Constraint can shift with product mix — schedule per shift.

### Disruption response

Machine breakdown: assess repair time → is it the constraint? If yes, activate contingency (OT on alternate equipment, subcontract, re-sequence). Re-sequencing priority: (1) protect constraint, (2) protect customer commitments by penalty exposure, (3) minimize changeover cost, (4) level labor. Communicate within 30 min, lock schedule for ≥4 hrs.

### OEE

`OEE = Availability × Performance × Quality`. World-class 85%+; typical discrete 55–65%. A 2% yield improvement at the constraint = 2% capacity expansion. Plan adherence >90% of jobs starting within ±1 hr; closing the loop with rolling re-plan cadence; worst failure = schedule diverges and shop floor ignores it.

**KPIs:** on-time delivery >95%, constraint OEE >75%, first-pass yield >97%, unplanned downtime <5%.

## 3. Quality & Non-Conformance

**Role context:** senior quality engineer, regulated manufacturing (FDA 21 CFR 820, IATF 16949, AS9100, ISO 13485).

### NCR lifecycle

Identification (quarantine/tag immediately) → documentation (NCR number, spec clause, measurement data) → investigation (isolated vs systemic; containment before RCA) → MRB disposition: use-as-is (needs engineering justification, customer approval in aerospace/auto), rework (to full conformance, re-inspect), repair (permanent deviation, concession), RTV (SCAR + scorecard), scrap (documented, authorized).

### Root cause analysis

- **5 Whys**: simple; fails on complex multi-factor problems. Each "why" verified with data.
- **Ishikawa (fishbone 6M)**: hypothesis generation, prevents premature convergence.
- **Fault Tree Analysis**: top-down AND/OR logic; for safety-critical (aerospace, ISO 14971).
- **8D**: automotive-expected; D0-D8 (emergency response → team → problem def → containment → root cause → corrective → implementation → prevention → recognition).
- **Red flags you stopped at symptoms**: root cause contains "error"/"human error"; action is "retrain"; root cause restates the problem.

### CAPA

Triggers: repeat NC (3+ same failure mode), customer complaints, audit findings, field failures, SPC signals. Corrective = existing NC; Preventive = potential NC (trend/risk/near-miss). Write specific measurable actions ("add torque verification at Station 12 with calibrated wrench, effective 2025-04-15"), not "improve inspection." **Verify (implemented) ≠ Validate (prevented recurrence).** Monitoring: 90 days or 3 lots. FDA cites CAPA deficiencies more than any other subsystem.

### SPC

Chart selection: X-bar/R (n=2–10), X-bar/S (n>10), I-MR (n=1), p/np/c/u charts for attributes. Cp = spread, Cpk = centering (Cp=2.0 + Cpk=0.8 → fix the mean). IATF requires Cpk ≥1.33 established, Ppk ≥1.67 new. Western Electric rules: 1 point >3σ = act immediately; 9 one-side, 6 trending, 14 alternating = investigate. **Don't tamper with common-cause variation.**

### Incoming inspection

AQL (Z1.4/2859-1): Level II standard; tightened after 2 of 5 lots rejected; reduced after 10 accepted. Critical defects AQL=0. CoC reliance: new supplier always inspect; qualified supplier CoC + reduced; critical dimensions always inspect.

### Supplier quality

Scorecards: PPM (<500), on-time, SCAR response, lot acceptance. Escalation: SCAR → watch (60 days) → controlled shipping (90 days) → new source qualification → ASL removal. Develop vs switch: develop if unique capability + high switching cost + addressable gaps; switch if unwilling to invest or deteriorating despite CARs.

**Cost of quality (Juran):** prevention 5–10% (every $1 returns $10–100), appraisal 20–25%, internal failure 25–40%, external failure 25–40% (most volatile). **KPIs:** CAPA on-time >90%, effectiveness >85%, CoQ <3% revenue.

## 4. Returns & Reverse Logistics

### Returns policy logic

Standard 30-day window (electronics 15), condition requirements, gift receipts = exchange/store credit only, no-receipt caps, restocking fees (opened electronics 15%, special order 20–25%), BORIS (buy-online-return-in-store) with price-match-to-original-purchase, international (returnless refund when shipping >40% of value; duty drawback needs re-export proof).

### Grading & disposition

- **Grade A (Like New)**: restock as new/open-box at 85–100% retail; 45–90 sec inspection.
- **Grade B (Good)**: open-box/renewed 60–80% retail; 90–180 sec.
- **Grade C (Fair)**: secondary channels 30–50% retail; refurb if <20% of recovered value.
- **Grade D (Salvage)**: parts/materials 5–15% retail; else recycling/destruction.

### Fraud detection

Score returns: high-frequency returns, item-swap patterns (new-in-box returns of worn/used), receipt forgery, refund-to-card vs. store-credit preferences, serial-number mismatches. Balance fraud prevention against false-positive friction on legitimate customers.

### KPIs

Return rate, return reason distribution, restockable %, refund turnaround time, fraud rate, vendor recovery (RTV) ROI, warranty claim rate.

## 5. Energy Procurement

**Role context:** C&I energy buyer, $15–80M annual spend, 10–50+ sites.

### Bill anatomy

Energy charges (40–55% of bill; deregulated → competitively procured), demand charges ($8–25/kW on peak 15-min interval; 20–40%; one bad interval = $5–15K), capacity charges (your PLC during 1–5 system-peak hours; cutting load then = 15–30% savings next year — highest-ROI demand response), T&D (non-bypassable), riders/surcharges.

### Procurement strategies

- **Fixed-price (full requirements)**: budget certainty, 5–12% risk premium. Best when predictability > cost.
- **Index/variable**: lowest long-run cost, full spike exposure (ERCOT Winter Storm Uri: $9,000/MWh). Requires risk appetite.
- **Block-and-index (hybrid)**: fixed blocks cover baseload 60–80%; variable floats. Blocks should match load shape.
- **Layered procurement**: buy in tranches over 12–24 months (e.g., 25% per quarter across two years) — eliminates "did we lock at the top?" — the most effective risk technique for most buyers.
- **RFP**: 5–8 REPs, 36 months interval data, load factor, credit check suppliers (bankruptcy forces default service), flexibility provisions.

### Demand charge management

Shift load from peak 15-min intervals (compressor startup vs HVAC peak), demand-response events at system peaks (cuts capacity charges), thermal storage, on-site generation at peak.

### PPAs & renewables

Evaluate against: contract length (10–20 yr), price vs. forward curve, REC ownership, delivery/interconnection, counterparty credit, exit clauses, budget certainty vs. flexibility.

**KPIs:** cost per kWh vs. benchmark, budget variance vs. plan, % spend hedged, demand charges per facility, sustainability/renewable % and REC position.

## 6. Carrier Relationship Management

**Role context:** transportation manager, 40–200+ carriers, TL/LTL/intermodal.

### Rate components (negotiate independently)

Base linehaul (negotiate lane-by-lane), fuel surcharge (negotiate the FSC *table* — base trigger, increment, index lag), accessorials (detention $50–100/hr after 2 hrs free time — #1 invoice dispute; liftgate, residential, inside), minimum charges, contract vs spot. Healthy portfolio: 75–85% contract, 15–25% spot; >30% spot = routing guide failing.

### Scorecard (track 5, not 20)

On-time delivery ≥95% (measure pickup and delivery separately), tender acceptance ≥90% (rejecting <75% = rate below market, renegotiate), claims ratio <0.5% of spend, invoice accuracy ≥97%, tender-to-pickup within 2 hrs (late pickup = "soft rejecting").

### Portfolio strategy

Consolidate vs diversify by lane criticality and market conditions. When capacity tightens, how you treated carriers when loose determines whether they cover your freight. Spot vs contract decisions: spot 10–30% higher in tight markets, 5–20% lower in soft. Carrier exit criteria: sustained scorecard failure, compliance violations (FMCSA SAFER vetting), capacity unreliability, unresolved claims.

### RFP process

Lane-level RFPs, standardized bid package, evaluate on cost + service + capacity + compliance + financial stability. Negotiation tone: firm, fact-based, quantify impact. Performance reviews: scorecard-driven, structured, forward-looking.

**KPIs:** OTD, tender acceptance, claims ratio, rate vs. market index, carrier count concentration, on-time pickup.

## 7. Customer Support

Design AI-powered support operations: conversational AI chatbots (Intercom Fin, Zendesk AI), automated ticketing with SLA + escalation, knowledge-base self-service, omnichannel (email/chat/social/WhatsApp) with context preservation, sentiment analysis, CSAT/NPS/CES tracking, support ROI (cost per contact), e-commerce order/returns support, crisis management (surge capacity, incident protocols), agent training + QA.

**Response approach:** listen with empathy → analyze context → identify best solution → communicate clearly → verify understanding → follow up → document insights → optimize processes → escalate appropriately → measure success.
