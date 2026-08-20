# Financial Modeling, Metrics & Trading

Build startup financial models, business cases, fundraising scenarios, KPI dashboards, and (optionally) trading/risk analytics. Sources: `startup-financial-modeling`, `startup-business-analyst-financial-projections`, `startup-business-analyst-business-case`, `startup-metrics-framework`, `business-analyst`, `kpi-dashboard-design`, `quant-analyst`, `backtesting-frameworks`, `risk-manager`, `risk-metrics-calculation`, `options-flow-analyzer`, `longbridge`.

## Startup Financial Model (3–5 years)

### Revenue model (cohort-based)

```
MRR = Σ (Cohort Size × Retention Rate × ARPU) + Expansion
ARR = MRR × 12
```

Track monthly new customers, retention curve (typical SaaS: M1 100%, M3 90%, M6 85%, M12 75%, M24 70%), ARPU, expansion revenue.

### Cost structure

- **COGS**: hosting, payment processing, variable support, third-party per customer. SaaS gross margin 75–85%.
- **S&M**: CAC, marketing programs, sales comp, tools. 40–60% of revenue early stage.
- **R&D**: engineering, PM, design. 30–40%.
- **G&A**: execs, finance/legal/HR, office. 15–25%.

### Cash flow & runway

```
Runway = Cash Balance / Monthly Burn
Monthly Burn = Monthly Revenue − Monthly Expenses
```

Revenue ≠ cash (payment terms); expenses are paid before revenue collected — model cash conversion carefully.

### Headcount planning

- Fully-loaded cost = base salary × 1.3–1.4 (benefits/taxes).
- Early-stage SaaS ratios: Eng 40–50%, S&M 25–35%, G&A 10–15%, CS 5–10%.
- Hiring takes 3–6 months to fill and 3–6 months to ramp; plan buffer.

### Three-scenario framework

- **Conservative (P10)**: new customers −30%, churn +20%, pricing −15%, CAC +25%. Used for cash management.
- **Base (P50)**: most likely. Used for board reporting.
- **Optimistic (P90)**: +30% customers, −20% churn, +15% price, −25% CAC.

### Business-model templates

- **SaaS**: gross margin 75–85%, CAC payback <12 mo, net retention 100–120%. Example: Y1 $500K ARR → Y2 $2.5M → Y3 $8M.
- **Marketplace**: GMV × take rate (10–30%); contribution margin 60–70%.
- **E-commerce**: gross margin 40–60%, contribution 20–35%, CAC payback 3–6 mo.
- **Services/agency**: gross margin 50–70%, utilization 70–85%, revenue/employee.

### Model validation sanity checks

- Revenue growth achievable (3× yr 2, 2× yr 3).
- LTV/CAC > 3, payback < 18 months.
- Burn multiple < 2.0 in yr 2–3.
- Revenue per employee growing.
- S&M spend aligns with CAC/growth.

## Key Startup Metrics (with formulas)

- **CAC** = total S&M spend / new customers. **Blended CAC** must include salaries, content, tools, retainers — not just ad spend.
- **LTV** = ARPU × gross margin % / churn rate.
- **CAC payback** = CAC / ARPU.
- **LTV:CAC** — healthy 3:1 to 5:1.
- **Burn multiple** = net burn / net new ARR (<2.0).
- **Magic number** = net new ARR / S&M spend (>0.5).
- **Rule of 40** = growth % + profit margin % (>40).
- **NRR (Net Revenue Retention)** = (starting ARR + expansion − contraction − churn) / starting ARR.
- **Quick ratio** = (new + expansion) / (contraction + churn).

### Metrics by business model

- SaaS: MRR, NDR, CAC payback, expansion.
- Marketplace: GMV, take rate, liquidity.
- Consumer: retention, virality, engagement.
- B2B: ACV, sales efficiency, win rate.

## Fundraising Integration

- **Dilution**: post-money = pre-money + investment; dilution % = investment / post-money.
- **Use of funds** — typical split: product 40%, S&M 40%, G&A 10%, working capital 10%.
- **Milestone-based planning**: raise enough to reach the next milestone + 6 months buffer.
- **VC growth benchmark (3-3-2-2-2 rule, from $1M ARR)**: 3× in yrs 1–2, then 2× years 3–7. Most companies miss it — knowing it lets you match or explicitly choose not to.
- **Funding-stage marketing tiers**: pre-seed/bootstrapped = organic only, $0 paid; seed close = $5–15K/mo paid + first marketing hire; seed deployment = $20–50K/mo + designer; Series A = $50–150K/mo + full team; Series B+ = $150K+/mo + brand/PR. Adjust by category (D2C needs higher floor, B2B lower).

## Investor Business Case (10-section structure)

1. **Executive summary** (1–2 pages, lift-and-share): company, problem, solution, TAM/SAM/SOM, traction, financial snapshot table, funding ask.
2. **Problem & market opportunity** (2–3 pages): quantified problem cost, market landscape, sizing with methodology, target customer profile.
3. **Solution & product**: features, how it works, differentiation, roadmap, IP/defensibility.
4. **Competitive analysis**: competitive matrix, 3–5 differentiators, positioning map, barriers to entry.
5. **Business model & GTM**: revenue model, pricing tiers, CAC, channels, sales motion, customer success.
6. **Financial projections**: cohort revenue, 3-yr P&L table, unit economics, metrics trajectory, scenarios, path to profitability.
7. **Team & organization**: leadership, headcount plan, org evolution (e.g., 5→15→35→60), equity/comp.
8. **Traction & milestones**: current metrics, achieved milestones, next 12–18 months.
9. **Risks & mitigation**: market, execution, financial, regulatory.
10. **Funding request & use of proceeds**: amount, structure, milestones, timeline, next round.

**Quality bar:** quantify everything; acknowledge risks honestly; cite sources; exec summary ≤2 pages; be realistic, not optimistic. Filename: `business-case-[company]-YYYY-MM-DD.md`.

## KPI Dashboard Design

- **Hierarchy**: executive summary (4–6 headline KPIs) → department views → detailed drilldowns.
- **KPI levels**: strategic (monthly/quarterly, execs), tactical (weekly/monthly, managers), operational (real-time/daily, teams).
- **Departmental KPI sets**: Sales (MRR/ARR/ARPU, pipeline value, win rate, avg deal size, cycle length); Marketing (CPA, CAC, MQL, conversion, marketing ROI); Product (DAU/MAU, stickiness, feature adoption, NPS, churn); Finance (gross/net margin, EBITDA, current ratio, cash flow, DSO, inventory turnover).
- **Layout best practices**: limit to 5–7 KPIs, show context (trends/targets), consistent color (red=bad/green=good), enable drilldown, match update frequency.
- **Don't**: show vanity metrics, overcrowd, use 3D charts, hide methodology, ignore mobile.

## Trading / Quantitative Analytics (optional cluster)

Label all output as **analytical signals, not financial advice**.

### Backtesting (production-grade)

- Define hypothesis, universe, timeframe, evaluation criteria.
- Build point-in-time data pipelines and realistic cost models (fees, slippage).
- Event-driven simulation; train/validation/test splits; walk-forward testing.
- Never present backtests as guarantees of future performance.

### Quant analysis

- Risk-adjusted returns over absolute returns; out-of-sample testing to avoid overfitting; separate research and production code; use pandas/numpy/scipy with realistic market-microstructure assumptions.

### Portfolio risk metrics

- **Risk manager**: define risk per trade in R (1R = max loss); expectancy = (win% × avg win) − (loss% × avg loss); size positions by account-risk %; monitor correlation; use stops systematically.
- **Risk metrics**: VaR, CVaR/Expected Shortfall, Sharpe, Sortino, max drawdown; stress-test with Monte Carlo; for regulatory reporting.

### Options flow (real vs. lottery separation)

- Raw P/C ratios mislead: a P/C of 0.35 may be 84% lottery calls (deep OTM, <$0.10 premium).
- Separate real calls (strike within 5% of spot, meaningful premium) from lottery calls; same for puts.
- Output: real P/C ratio, lottery %, per-expiry breakdown, anomaly detection (P/C shift >0.3, OI surge >30%, IV spike >20%), sentiment classification.
- Requires Polygon.io API; cross-check against price action, news, liquidity.

### Longbridge securities CLI

- 125+ skills for HK/US/A-share/SG markets, trilingual (zh-CN/zh-TW/en).
- Workflow: `longbridge --help` to discover subcommands (never hard-code names) → `longbridge <sub> --help` → call with `--format json` → render in the user's language.
- Read-only by default; trade features require `login --trade`; watchlist/order mutations follow preview + confirm.
