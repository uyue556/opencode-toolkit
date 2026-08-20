# Estimation & Sprint Planning

Estimate AI-assisted and hybrid human+agent development work using research-backed PERT statistics, confidence bands, and calibration feedback loops. Merged from: `progressive-estimation`.

## When to Use

- Estimating development tasks where AI agents handle part of the work.
- Sprint planning with hybrid human+agent teams.
- Batch sizing a backlog (handles 5 or 500 issues).
- Staffing/capacity planning with agent multipliers.
- Release date forecasting with confidence intervals.

## The Process

1. **Mode Detection** — determine the team's working mode: human-only, hybrid, or agent-first.
2. **Task Classification** — categorize by size (XS–XL), complexity, and risk.
3. **Formula Application** — apply research-backed multipliers (empirical studies) based on mode.
4. **PERT Calculation** — expected value from three-point estimation.
5. **Confidence Bands** — generate P50, P75, P90 intervals.
6. **Output Formatting** — format estimates for Linear, JIRA, ClickUp, GitHub Issues, Monday, or GitLab.
7. **Calibration** — feed actuals back to improve future estimates.

## Three-Point PERT

For each task capture three estimates and combine them:

- **O** = optimistic estimate
- **M** = most likely estimate
- **P** = pessimistic estimate

Expected value: `E = (O + 4M + P) / 6`

Standard deviation: `σ = (P - O) / 6`

Confidence bands follow the normal distribution around E:
- **P50** = expected value (what will happen on average)
- **P75** ≈ E + 0.67σ (safe planning number)
- **P90** ≈ E + 1.28σ (high-confidence commitment)

## Example Invocations

- **Single task:** "Estimate building a REST API with authentication using Claude Code"
- **Batch mode:** "Estimate these 12 JIRA tickets for our next sprint"
- **With context:** "We have 3 developers using AI agents for ~60% of implementation. Estimate this feature."

## Best Practices

- Start with a single task to calibrate before moving to batch mode.
- Feed back actual completion times to improve the calibration system.
- Use "instant mode" for quick T-shirt sizing without full PERT analysis.
- Be explicit about team composition and agent usage percentage.

## Common Pitfalls & Fixes

| Problem | Fix |
|---|---|
| Overconfident estimates | Use P75 or P90 for commitments, not P50 |
| Missing context (team size, agent %) | Ask clarifying questions; provide team composition & agent usage |
| Stale calibration | Re-calibrate when team composition or tooling changes significantly |
| Gut-feel numbers | Always use the PERT formula; never single-point guesses |

## Sprint Planning Routing

- **Sprint/cycle/iteration setup in a tool** (Jira sprints+boards, Linear cycles, Monday items, Asana sections) → see `tool-automation.md` for the specific tool's workflow.
- **Breaking backlog into issues** → see `prd-and-issues.md`.
- **Tracking sprint execution** → see `planning-with-files.md` and `feature-tracking.md`.

## Do & Don't

| Do | Don't |
|---|---|
| Commit using P75/P90 | Promise P50 as a deadline |
| Re-calibrate on actuals | Assume yesterday's calibration holds forever |
| State team mode + agent % up front | Estimate without clarifying context |
| Use instant T-shirt sizing for quick triage | Run full PERT for trivial tasks |
