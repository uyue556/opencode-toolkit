# Time & Journaling Ledgers

Conversational tracking into the user's own Notion database: the user reports in plain
language ("read papers 2h, gym 1h"), the agent parses into structured rows. Both `time-ledger`
and `trading-ledger` share one design contract — **the honesty contract: anything uncertain
becomes a `To-confirm` row and gets batch-asked; never fabricate.** A log that quietly
invents durations or reasons is worse than no log.

## Common pattern (both ledgers)

1. **Resolve the database (first write per session)**: Notion `search` for a *database*
   (type `database`, not a page) whose title matches the ledger name. For trading-ledger,
   confirm the exact candidate with the user before any query/write.
2. **Parse the plain-language report** into the template's controlled enum fields (copy select
   values exactly — they are the schema).
3. **Write certain facts as `Done`/`Open`; write anything uncertain as `To-confirm`** with the
   specific question in `Notes`, and ask it once in your reply.
4. **Batch reconcile**: on "tidy up my X ledger", collect *all* open questions into one message.
5. Give a short receipt after logging (rows written, which are To-confirm, what the questions are).

Known Notion MCP quirks (both): date fields must be expanded to `"date:<Field>:start":
"YYYY-MM-DD"` (a bare value fails with HTTP 400); after the first `create-pages`, read the row
back and `update-page` any date column that came back empty.

## Time ledger

Schema (template): `Entry` (title), `Activity` (select: Reading / Coding / Practice / Fitness /
Investing / Meeting / Writing / Life / Other), `Minutes` (number), `Date` (date), `Status`
(To-sort / To-confirm / Done), `Compounding` (Compounding / Consuming / Neutral), `Notes`.

Parsing rules:
- Activity mapping: books/technical → Reading; coding/building → Coding; leetcode → Practice;
  gym/running → Fitness; markets/research → Investing; meetings → Meeting; docs → Writing;
  meals/commute/chores → Life; otherwise → Other; unsure → To-confirm.
- Duration cues: "two hours"=120, "an hour"=60, "half an hour"=30, "a while"≈30 (mark
  To-confirm, it's an estimate), "all morning"≈180. Use exact numbers when given.
- Date: "today"/"yesterday" = user's local date; unspecified = today; uncertain day → ask.
- Multiple blocks in one report ("2h on X, 1h on Y") → split rows, but confirm whether totals
  are additive (default additive + one To-confirm row).
- Compounding tag only the obvious: Compounding = leaves a reusable asset; Consuming = only if
  the user volunteers it; otherwise leave blank.
- Don't judge Consuming hours — the ledger is a mirror, not a critic.

Batch reconcile: query `Status ∈ {To-sort, To-confirm} or empty`, parse each, update the
certain ones to `Done`, batch all remaining questions into one message, fill answers on reply.

## Trading ledger

Captures the decision, not just the fill: thesis, plan, and emotion at the moment of entry.

Schema (template): `Entry`, `Ticker` (text — strikes/expiries: `NVDA / NVDA 0620C150 / ESU6`),
`Market` (select: US Stocks / US Options / US Futures / A-Shares / HK Stocks / CN Futures /
Crypto / Other), `Direction` (Long / Short), `Size`, `Entry Price` / `Exit Price` (number),
`Entry Date` / `Exit Date` (date), `Thesis` (text — **the soul of the journal; if missing, ask
on the spot**), `Plan` (text — stop/target/contingency; ask if missing), `Emotion` (Calm / FOMO
/ Panic / Revenge / Boredom / Overconfidence — tag only what the user admits or what is plain,
don't diagnose), `Execution` (Per plan / Early exit / Delayed stop / Impulse / Unplanned add —
filled at close), `P&L` (realized), `Status` (Open / Closed / To-confirm / Reviewed),
`Review`, `Notes`.

Flows:
- **Open**: create `Status=Open`. Missing thesis is the one field worth interrupting for — ask
  immediately. Everything else uncertain → record, mark To-confirm.
- **Close/adjust**: find that ticker's `Status=Open` row → fill Exit/Execution/P&L → `Closed`.
  Grade `Execution` against the user's own `Plan` (stopped where planned = Per plan; ran before
  target = Early exit; held through stop = Delayed stop). No matching open row → create
  To-confirm row and ask whether the entry was never logged.
- **Review** ("review my trades"): query recent `Closed` + all `Open`. For each closed trade ask:
  *Did the thesis play out?* (wrong thesis + profit = luck — say so), *How was the execution?*
  (a per-plan loss is a good trade), *What share of trades were emotion-tagged?* Write
  conclusions to `Review`, move `Closed` → `Reviewed`. For every open position ask: *does the
  entry thesis still hold today?*

Parsing rules: infer `Market` from symbol + context (ambiguous → ask); bought put = Short
exposure + note it's a long put; record only given prices/sizes — **never look up market prices
to fill gaps**; "today" = user's local trading date (confirm); overnight US fills belong to the
US trading date.

Rules that keep it honest:
- Ask for the thesis at entry time — entry reasons decay overnight and memory flatters.
- Grade execution against the user's own plan, never hindsight.
- Never compute P&L you're unsure of (options/futures multipliers) — use the user's numbers.
- A review is not a P&L total; it grades thesis and execution.
- This skill never produces signals, price data, or buy/sell advice — it records and mirrors
  the user's own decisions.

## Safety (both)

- Mutation scope is only the single user-confirmed Notion database via the official connector
  (MCP). No shell commands, no network fetches, no credentials handled by the skill.
- First write on claude.ai pops an approval prompt — expected, not a hang.
- Self-report only by design: an auto-tracker knows what was open, not *why* time was spent;
  the broker knows the fills, only the user knows the reasons.
