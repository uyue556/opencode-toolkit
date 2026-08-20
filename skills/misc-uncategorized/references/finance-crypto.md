# Finance & Crypto

Consolidates: xvary-stock-research, yield-intelligence, longbridge-market-data,
longbridge-fundamentals, longbridge-content, atlas-ledger, emblemai-crypto-wallet, nft-standards,
billing-automation. (Persona "warren-buffett" → personas-it.md.)

## 0. Compliance

Research support, not investment advice. Never fabricate non-public data. Cite filing form/date
when stating a hard financial figure. Surface assumptions and kill criteria; never claim certainty.

## 1. XVARY Stock Research

Institutional-depth equity memos from public SEC EDGAR + market data (no paid terminal).
Commands:
- `/analyze {ticker}` — full workflow: EDGAR fundamentals via `tools/edgar.py` → quote/valuation
  via `tools/market.py` → apply methodology framework → compute four-pillar scorecard → output
  structured analysis.
- `/score {ticker}` — score-only: Momentum, Stability, Financial Health, Upside Estimate; score
  table + interpretation + sensitivity checks.
- `/compare {t1} vs {t2}` — side-by-side: score both, compare conviction drivers, key risks,
  valuation asymmetry; winner by setup quality + conditions that flip the view.

Output shape for `/analyze`: Verdict (Constructive/Neutral/Cautious) → Conviction Rationale →
Scores → Thesis Pillars → Top Risks → Kill Criteria (thesis-invalidating conditions) → Financial
Snapshot → Next Checks. Execution rules: uppercase tickers, prefer latest annual + quarterly
EDGAR, cite form/date, concise + decision-oriented, if a tool fails state exactly what data is
missing (never hallucinate). Required footer.

## 2. Yield Intelligence

Passive-income portfolio analysis (dividend yields, Treasury rates, REIT income, monthly cashflow).
Workflow (no MCP required): gather parameters → asset-class scan → score and rank → build
allocation → present results. Optional live data source. Best practices: separate yield from total
return, watch payout sustainability, tax awareness.

## 3. Longbridge (market data / fundamentals / content)

CLI-based, sub-topic routing to reference guides per skill:
- **market-data**: `quote`, `depth` (L2 order book), `brokers` (HK), `trades`, `intraday`,
  `kline`, `static`, `calc-index` (PE/PB/turnover/DPS), `capital` (intraday flow), `market-temp`
  (sentiment 0-100), `trading` (schedule/calendar), `security-list`, `participants`,
  `subscriptions` (WebSocket).
- **fundamentals**: `financial-report`, `financial-statement`, `business-segments`, `dividend`,
  `valuation` (PE/PB/PS/peer), `industry-valuation`, `operating` (HK KPIs), `corp-action`,
  `invest-relation`, `company`, `executive`, `valuation-rank`, `compare`.
- **content**: `news`, `filing` (regulatory filings), `topic` (community discussion); SEC EDGAR
  filing analysis framework; MCP fallback.

## 4. Atlas Ledger (contract companion)

Turns observed drift in an agent contract into clauses in `Atlas.md`. Distillation steps:
(1) state drift as observable facts, not motive; (2) draft clause WHEN / DON'T / INSTEAD; (3)
pass FOUR acceptance gates (record only if it passes all); (4) provisional vs confirmed; (5)
propose, write only after confirmation; (6) write to Atlas.md merging first. Format: `# Atlas
Ledger` with `## Confirmed Clauses` + `## Provisional Observations`.

## 5. EmblemAI Crypto Wallet

Crypto wallet management across 7 blockchains via EmblemAI Agent Hustle API: balance checks,
token swaps, portfolio analysis. Setup + supported chains; core endpoints; behaviors; link to docs.

## 6. NFT Standards

- **ERC-721**: OpenZeppelin `ERC721URIStorage` + `Enumerable` + `Ownable`; mint with `_safeMint`
  + `_setTokenURI`; required overrides (`_beforeTokenTransfer`, `_burn`, `tokenURI`,
  `supportsInterface`); supply caps, per-mint limits, withdraw.
- **ERC-1155**: multi-token; `_mint`/`_mintBatch`/`_burn` with per-id supply tracking.
- Metadata: off-chain (IPFS JSON with name/description/image/attributes + display_type/max_value)
  or on-chain (base64-encoded JSON + SVG, ERC721 tokenURI override).
- Royalties: EIP-2981. Soulbound: non-transferable override. Dynamic NFTs: mutable metadata.
- Gas-optimized minting: ERC721A (batch mint amortizes cost). Marketplace integration + best
  practices (validate `msg.sender`, check approvals, safe transfer).

## 7. Billing Automation

Automated billing systems: recurring billing, invoice generation, dunning management, proration,
tax. Follow the implementation playbook (resources/implementation-playbook.md); safety first —
money flows require tests + explicit confirmation before destructive/costly actions.
