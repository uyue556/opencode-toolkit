# Advanced & Miscellaneous Testing

Framework migration, visual regression, A/B testing, pairwise generation, workflow
(orchestration) testing, accessibility, and mock-data detection. Merged from:
`test-framework-migration-skill`, `smartui-skill`, `ab-testing`, `pypict-skill`,
`temporal-python-testing`, `screen-reader-testing`, `mock-hunter`,
`lambdatest-agent-skills`, `network-101`, `go-playwright` (framework-agnostic parts),
`awt-e2e-testing`, `tdd-workflows` (alias note).

## Framework migration (Selenium / Playwright / Puppeteer / Cypress)

When converting tests between frameworks:

1. **Detect source framework** from message/code: Selenium (`driver.findElement`,
   `By.id`, `WebDriver`), Playwright (`getByRole`, `toBeVisible`, `@playwright/test`),
   Puppeteer (`page.$`, `page.goto`, `puppeteer.launch`), Cypress (`cy.get`,
   `cy.visit`, `cy.should`). If ambiguous, ask.
2. **Detect target framework** from the user's wording ("to Playwright", etc.). If
   only source named, ask which target.
3. **Detect language.** Selenium supports Java/Python/C#/JS; Playwright is typically
   JS/TS — migrating to it usually implies rewriting to TypeScript/JavaScript.
4. **Always read the mapping reference for the specific pair** (e.g.,
   selenium-to-playwright.md) before generating code.
5. **Apply mappings:** locators (`By.id("x")` → `page.getByRole`/`locator('#x')`),
   waits (explicit `WebDriverWait` / auto-wait / `cy.should`), actions, assertions,
   lifecycle (driver vs page), cloud config.

Validation:
- No leftover source-API calls.
- Playwright target: auto-wait assertions (`expect(locator).toBeVisible()`), not
  raw `waitForTimeout`.
- Cypress target: no async/await with `cy`; chain style.
- Selenium target: explicit `WebDriverWait`, never `Thread.sleep`.

## Visual regression (SmartUI / TestMu)

Framework-agnostic screenshot comparison (Playwright, Selenium, Cypress, Puppeteer).

- Playwright: `await smartuiSnapshot(page, 'Homepage')` from `@lambdatest/smartui-cli`.
- Selenium: `((JavascriptExecutor) driver).executeScript("smartui.takeScreenshot=...")`.
- Run: `npx smartui exec -- npx playwright test` (or `node test.js`); config in
  `smartui.config.json` (browsers, viewports, `waitForPageRender`).
- Approval workflow: first run creates baseline → subsequent runs compare → diffs
  reviewed/approved in dashboard → approved becomes new baseline.
- Auth: `PROJECT_TOKEN` (CLI) or `LT_USERNAME`/`LT_ACCESS_KEY` (Selenium cloud).
- Anti-patterns: no viewport config, no wait for render, screenshotting everything,
  no approval process.

General visual regression principle (framework-agnostic): screenshot before →
change → after, compare; baseline + approval process; key pages/components only.

## A/B testing & experimentation

Design statistically valid experiments.

1. **Start with a hypothesis** (specific prediction): "Because [observation], we
   believe [change] will cause [outcome] for [audience]. We'll know when [metrics]."
2. **Test one thing** — single variable per test (A/B, A/B/n, MVT, split URL).
3. **Statistical rigor:** pre-determine sample size, don't peek/stop early, commit
   to methodology. 95% confidence = p < 0.05.
4. **Metrics:** primary (business value, calls the test), secondary (context),
   guardrails (must not regress — e.g., support tickets, refunds).
5. **Traffic allocation:** 50/50 default; 90/10 conservative; ramping for risk.
6. **During the test:** monitor for technical issues, don't change variants, don't
   add new traffic sources, don't peek.
7. **Analyze:** reached sample size? significant? effect meaningful vs MDE? secondary
   consistent? guardrails ok? segment differences?

Sample size (per variant): at 5% baseline, 10% lift ≈ 27k; 20% ≈ 7k; 50% ≈ 1.2k.
Growth program: hypothesis backlog → ICE prioritization (Impact+Confidence+Ease)/3 →
run → analyze → playbook → repeat. Track velocity: 4-8 experiments/month, 20-30%
win rate, 2-4 week duration, 20+ backlog.

## Pairwise test generation (pypict)

Generate pairwise test combinations to reduce the test matrix while covering all
pairs of input values. Use when you need combinatorial coverage with minimal cases
(e.g., many parameters, many values each).

## Workflow / orchestration testing (Temporal)

Three test types:

1. **Unit:** workflows with time-skipping (`WorkflowEnvironment.start_time_skipping`
   makes month-long workflows test in seconds); activities with `ActivityEnvironment`.
2. **Integration:** Workers with mocked activities to isolate workflow logic.
3. **End-to-end:** full server with real activities — use sparingly.

```python
@pytest.fixture
async def workflow_env():
    env = await WorkflowEnvironment.start_time_skipping()
    yield env
    await env.shutdown()

@pytest.mark.asyncio
async def test_workflow(workflow_env):
    async with Worker(workflow_env.client, task_queue="test-queue",
                      workflows=[YourWorkflow], activities=[your_activity]):
        result = await workflow_env.client.execute_workflow(
            YourWorkflow.run, args, id="test-wf-id", task_queue="test-queue")
        assert result == expected
```

Principles: time-skipping, mock activities at boundaries, replay testing for
determinism, ≥80% coverage, fast feedback.

## Accessibility — screen reader testing

- Verify ARIA implementations, form accessibility, dynamic-content announcements,
  navigation.
- DevTools accessibility tree: interactive elements have accessible names; heading
  hierarchy (h1→h2→h3, no skips); focus order logical; color contrast ≥ 4.5:1;
  ARIA live regions announce changes.
- Automated tooling: axe-core (`cypress-axe` for Cypress), Lighthouse, axe-core +
  Playwright.

## Mock-data detection (MockHunter)

Audit a live page to determine which visible values are REAL vs MOCK vs LLM vs
HARDCODED vs BROKEN vs UNKNOWN. Useful for vibe-coded apps (Lovable, Bolt, v0,
Replit) where the UI looks complete but data isn't wired up.

Five phases: setup/questions → navigate & catalog (inventory headings/buttons/stats)
→ test interactivity → trace provenance → report.

Provenance decision tree (per visible value): found in a network response?
- 4xx/5xx → BROKEN; endpoint matches `/ai|generate|llm|chat` → LLM; shape matches
  faker/MSW/mockoon → MOCK; DB row matches → REAL; else UNKNOWN.
Not in any response → string literal in DOM → HARDCODED; computed from
random/Date.now → MOCK; else UNKNOWN.

Uniformity flags (suspect seeded data): identical values across rows, all-round
percentages, timestamps clustered in one minute, <3 unique values across 10+ rows.

Safety: read-only DB SELECTs only; skip destructive/ambiguous controls; dedicated
test account; placeholder credentials; never run active interaction on apps you
don't own without permission.

## Browser automation registry (framework-agnostic)

When choosing browser tooling: Playwright = default (auto-wait, cross-browser);
Puppeteer = Chrome-only + stealth ecosystem; Selenium = legacy/bindings. Delegation:
API testing → backend skills; load testing → this skill's load reference; visual
regression → `advanced-and-misc.md` (above); overall strategy → this skill's routing.
For general-purpose scraping automation, see `e2e-browser-testing.md` (stealth
section).

## Test automation at scale / cloud

- Use env vars for cloud credentials (`LT_USERNAME`, `LT_ACCESS_KEY`) — never
  hardcode.
- Page Object Model to separate logic from selectors.
- Explicit waits over fixed sleeps everywhere.
- Parallelize where supported; capture screenshots/logs on failure.
- Match dependency versions to framework recommendations; don't mix major versions.
- Don't write order-dependent tests; don't hardcode URLs/credentials/env values.
- Don't ignore flaky tests — fix root cause, not permanent retries.
