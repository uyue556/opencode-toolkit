# Testing

Consolidates: junit-5-skill, testng-skill, vitest-skill, cucumber-skill, robot-framework-skill,
wjttc-builder, wjttc-tester, hyperexecute-skill, newman-cicd-integration,
postman-newman-automation, postman-openapi-converter, puppeteer-skill, accesslint-scan,
accesslint-diff.

## 0. Common Principles

- Test type first: unit (fast, isolated) vs integration (with real deps) vs E2E (full flow) vs
  contract. Choose the smallest layer that catches the bug.
- One assertion per test name that reads like a sentence.
- Anti-patterns: testing implementation details, asserting on mocks, giant setup, testing the
  framework, `Thread.sleep`, conditional logic in tests, tests that pass without running.

## 1. JUnit 5 (Java)

- Basic: `@Test`, `assertEquals/assertTrue/assertNull`, `assertThrows`.
- Parameterized: `@ParameterizedTest @ValueSource/@CsvSource/@MethodSource`; named arguments.
- Mockito: `@Mock`, `@InjectMocks`, `when(...).thenReturn(...)`, `verify(...)`;
  `ArgumentCaptor` for captured args.
- Nested: `@Nested` for grouped contexts; lifecycle `@BeforeEach/@AfterEach`.
- Maven: `junit-jupiter`, `mockito-core`, `maven-surefire-plugin`.
- Deep patterns → test doubles, time-based tests (`Clock` injection), exception assertions.

## 2. TestNG (Java)

- Groups: `@Test(groups = {"smoke","regression"})`; run with XML suites or `mvn -Dgroups=smoke`.
- Data providers: `@DataProvider(name=...)` + `@Test(dataProvider=...)`; parallel via
  `data-provider-thread-count`.
- XML suite: `<suite><test><classes>` config; parallel `methods`/`tests`/`instances`.
- Soft assertions (`SoftAssert`) to collect multiple failures; listeners (`ITestListener`),
  lifecycle annotations (`@BeforeSuite/@BeforeClass/@BeforeMethod`).

## 3. Vitest (JS/TS)

- `describe/it/expect`; `vi.fn()`, `vi.mock()` (hoisted), `vi.spyOn()`, `vi.useFakeTimers()`.
- In-source testing (`if (import.meta.vitest)`), snapshot testing (`toMatchSnapshot`),
  React testing (`@testing-library/react` + `@testing-library/jest-dom`).
- Config in `vitest.config.ts`: environment, globals, setupFiles, coverage.

## 4. Cucumber BDD (Gherkin)

- Feature file: `Feature/Scenario/Given-When-Then`; tags `@smoke @regression`.
- Step definitions in Java (`@Given("...")` w/ regex or Cucumber expressions) or JS
  (`Given('...', async function(){})`).
- Hooks: `@Before/@After` per scenario/tag; share state via `World` (JS) or DI (Java).
- Cloud execution on TestMu AI (LambdaTest) for parallel cross-browser runs.

## 5. Robot Framework (Python)

- Keyword-driven: `.robot` files with `*** Settings / Variables / Test Cases / Keywords ***`.
- Custom keywords; data-driven via `[Template]`; API tests with `RequestsLibrary`.
- Setup: `pip install robotframework robotframework-seleniumlibrary robotframework-requests`.
- Run: `robot tests/` or `robot --include smoke tests/`; reports `report.html`/`log.html`.

## 6. WJTTC Championship Test Suites (wjttc-builder / wjttc-tester)

"Championship-grade" testing discipline:
- Two-layer architecture: Layer 1 industry-standard 100% coverage; Layer 2 expert stress + edge
  cases (WJTTC tier 1-5: happy path → edge cases → stress → adversarial → production-scale).
- **Signal integrity audit (the Red-Means-Real doctrine)**: every failure must be a genuine
  defect, not a flaky/environmental failure. Audit flake sources (timing, order-dependence,
  shared state, network) and eliminate them on sight. Inverse rule: a test that can pass for the
  wrong reason is not a test.
- We test the testing: the suite's own signal is audited before it's trusted.
- Tester: pre-audit signal integrity BEFORE running anything new; execution loop; report with
  summary/failures/edge cases/performance/bugs/coverage/verdict + tier verdict.
- When the conversation is the real gate: for non-deterministic criteria, be explicit about the
  judgment standard.

## 7. HyperExecute (TestMu AI / LambdaTest cloud)

Operate HyperExecute end-to-end: analyze project, create YAML, validate, run on cloud, triage
failures. Helper scripts provided; keep YAML minimal; leverage parallel sharding; review logs on
failure.

## 8. Newman / Postman API Testing

- **newman-cicd-integration**: generate CI configs that install Newman + run collections on
  GitHub Actions, GitLab CI, Jenkins (declarative), Azure DevOps, CircleCI. Best practices: never
  hardcode credentials (secrets), store collection/env files in repo, use `if: always()` /
  `when: always` so tests run even after earlier steps fail, exit codes gate the pipeline.
- **postman-newman-automation**: core `newman run collection.json -e env.json`; data-driven with
  CSV; env overrides without file (`--env-var key=value`); HTML reporter
  (`-r cli,json,html`); shell wrapper + Jenkins pipeline scaffolding.
- **postman-openapi-converter**: convert OpenAPI 3.x / Swagger 2.0 (YAML/JSON) → Postman
  Collection v2.1. Mapping: OpenAPI paths/operations → Postman requests; parameters/requestBody →
  Postman variables & bodies; auth schemes → collection auth; servers → baseUrl variable.
  Generate example bodies from schemas; handle edge cases (empty responses, $ref resolution,
  oneOf); output environment file with `baseUrl`; quality checklist (all paths covered, auth set,
  examples valid).

## 9. Puppeteer

- Basic: `puppeteer.launch()`, `browser.newPage()`, `page.goto()`, `page.$eval/$$eval`,
  `page.waitForSelector/NetworkIdle/Load`.
- Wait strategies: explicit selectors over fixed sleeps; network idle for SPA.
- Screenshot & PDF: `page.screenshot({fullPage})`, `page.pdf()`.
- Network interception: `page.setRequestInterception(true)` to mock/stub API responses, block
  heavy assets.
- Cloud execution on TestMu AI for cross-browser.

## 10. Accessibility Scans (accesslint)

- **accesslint-scan**: audit a live page, locate each WCAG violation precisely, return a
  selector-grounded fix worklist WITHOUT editing.
  ```bash
  PORT=$(npx -y @accesslint/chrome@latest ensure | node -e 'process.stdin.on("data",d=>process.stdout.write(""+JSON.parse(d).port))')
  npx -y @accesslint/cli@latest "<url>" --port "$PORT" --format json
  ```
  Flags: `--selector`, `--wait-for`, `--include-aaa`, `--disable <rules>`.
  Report: counts by impact, then per violation — where (selector verbatim + file:line when
  `source` present; never fabricate), evidence (contrast ratio / missing attribute), fix
  (mechanical or `NEEDS HUMAN`). Apply mechanical fixes and re-run to verify.
  Tear down: `npx -y @accesslint/chrome@latest stop --all` (skip if `ensure` said managed:false).
  Gotchas: never hardcode port 9222 (`ensure` determines it); CLI exit 2 = bad URL/page never
  loaded.
- **accesslint-diff**: same audit, but diff a live page against a baseline — by default compares
  uncommitted changes (stash-based) so you only see new violations introduced by your edits.
