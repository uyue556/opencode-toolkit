---
name: testing-quality
description: >-
  Testing and quality engineering across the whole stack — unit, integration, E2E,
  load, and visual testing; TDD red-green-refactor discipline; debugging and test
  fixing; test-quality review; code quality audits; and pre-ship verification gates.
  Use whenever the user mentions: tests, testing, unit test, pytest, jest, vitest,
  playwright, cypress, e2e, end-to-end, integration test, TDD, red-green, refactor,
  coverage, mocking, fixtures, load test, k6, performance test, flaky tests, test
  failure, debug, debugging, code review, linting, quality gate, test pyramid,
  visual regression, smartui, ship gate, verify done, or the Chinese keywords:
  测试, 单元测试, 集成测试, 端到端, 自动化测试, 测试驱动开发, 覆盖率, 调试, 代码审查, 代码质量,
  性能测试, 回归测试, 冒烟测试, 测试用例.
---

# Testing & Quality Engineering

A consolidated playbook for writing, running, reviewing, and shipping high-quality
software. It merges testing discipline (TDD, unit/integration/E2E), automation
frameworks, debugging, test review, code quality, and pre-ship verification into
one routing skill. Follow the workflow, then read the reference file for your
specific task.

## When to use this skill

- User asks to write, generate, review, or fix tests in any language/framework.
- User is debugging a bug, test failure, or unexpected behavior.
- User wants TDD, test-first development, or a red-green-refactor workflow.
- User wants a code review, quality audit, or pre-ship verification.
- User mentions a testing framework (pytest, Jest, Vitest, Playwright, Cypress, k6),
  a testing activity (unit, integration, E2E, load, visual, regression), or Chinese
  triggers like 测试 / 单元测试 / 覆盖率 / 调试 / 代码审查 / 性能测试.

## Core workflow

1. **Clarify the ask.** Is it: write tests / review tests / fix failing tests /
   debug a bug / load-test / review code quality / gate a deploy? Pick the routing
   row below.
2. **Understand the stack.** Read the project's testing config and existing tests
   before writing new ones. Match the framework, structure, and conventions already
   in use. Project-specific rules (CLAUDE.md / AGENTS.md / CI) win over this skill.
3. **Apply TDD when writing behavior.** For any feature or bugfix, write a failing
   test first, watch it fail for the *right* reason, write minimal code, watch it
   pass, then refactor. Never ship production code with no failing test having
   preceded it.
4. **Write tests that earn their place.** One behavior per test, behavior not
   implementation, mock only at system boundaries, data-driven for variants. Before
   writing any test ask: "What bug does this catch that no other test catches?"
5. **Verify with the real thing.** Run the tests. Check coverage on changed lines,
   not just the happy path. Confirm failure modes for error/edge cases.
6. **Review and gate.** Review tests and code against the quality rules, run the
   linter, and — before deploy — verify the *live* state, not the deploy log.

## Selection routing

Read the reference that matches your task:

| Task | Reference |
|------|-----------|
| TDD discipline, red-green-refactor, iron law, multi-agent TDD | `references/tdd-and-testing-discipline.md` |
| Unit tests: pytest, Jest/Vitest, factories, mocking, coverage, generation | `references/unit-testing.md` |
| E2E / browser: Playwright, Cypress, locators, waits, auth, Android, DevTools | `references/e2e-browser-testing.md` |
| Review generated/changed tests; nine universal test rules | `references/test-quality-review.md` |
| Load & performance testing with k6 | `references/load-performance-testing.md` |
| Debugging, root-cause analysis, fixing failing tests | `references/debugging-and-fixing.md` |
| Code review, clean code, audits, linting, tech debt | `references/code-quality-and-review.md` |
| Pre-ship gate, verifying "done"/"shipped" claims | `references/ship-gates-and-verification.md` |
| Framework migration, visual regression, A/B testing, pairwise, specialized | `references/advanced-and-misc.md` |

## Best practices

- **Tests are specifications.** A test you can't write means you don't understand
  the requirement. If a test is hard to write, the design is hard to use.
- **Test behavior, not implementation.** Assert observable outcomes. Don't assert
  that an internal helper was called — it breaks on refactors and catches nothing.
- **Mock only at system boundaries:** network/HTTP, LLM APIs, databases (when not
  the subject), filesystem I/O, clock/randomness, third-party SDKs. Never mock your
  own internal helpers, DTOs, or state objects — construct real ones.
- **Name tests for the scenario:** `test_<scenario>_<expected_outcome>`, e.g.
  `test_malformed_response_falls_back_to_default`.
- **Production regression tests are sacred.** Tests reproducing a real bug are
  always justified; reference the incident and never delete them.
- **Replace waits with conditions.** No arbitrary `sleep`/`waitForTimeout` in any
  framework — use auto-wait, `waitForResponse`, `cy.intercept()`, `pytest` retries.
- **Isolate tests.** Fresh state per test; shared auth via session/storage-state
  helpers; never depend on execution order.
- **Coverage is a floor, not a goal.** Track it, but a test with no assertions or a
  mock-heavy test that re-verifies the framework is worse than no test.
- **Fix root causes, not symptoms.** Debug from evidence: reproduce, read errors,
  check recent changes, form one hypothesis, test it minimally.
- **Quality gates before deploy.** Run tests, linter, and review — then verify the
  live revision matches what you intended to ship.

## Do & Don't

| Do | Don't |
|----|-------|
| Write the failing test first and watch it fail | Skip the RED phase; write tests after and call it TDD |
| Use user-facing locators (`getByRole`, `getByText`, `data-cy`) | Use fragile CSS/XPath/`nth-child`/auto-generated selectors |
| Use data-driven tests for value variants | Copy-paste tests differing by one value |
| Mock at boundaries; use real objects for state/values | Mock internal classes, Pydantic models, or the framework itself |
| Use explicit waits/retries/assertions | Use arbitrary sleeps and manual `waitForTimeout` |
| Verify live state after deploy (version endpoint, logs) | Report "shipped" from the deploy command's exit code alone |
| Check the project's own testing docs first | Apply generic patterns that override project conventions |

## Common pitfalls

- **Test passes immediately** → you're testing existing behavior or the mock, not
  the feature. Delete and start over.
- **Test errors instead of failing** → fix the error, re-run until it fails for the
  right reason (missing feature, not a typo).
- **Near-duplicate test bodies** → merge with `parametrize` / `test.each`.
- **Mocking the DB to test the DB** → when persistence is the subject, run against a
  real test database with real migrations.
- **Flaky tests "fixed" with retries** → investigate the root cause (race, shared
  state, timing) instead of hiding it.
- **3+ failed fixes on the same bug** → stop and question the architecture, not the
  code.
- **"Deploy succeeded" ≠ new version is live** → confirm the running revision.

## Examples

- **"Write pytest tests for the payments API"** → read `references/unit-testing.md`;
  use fixtures, `parametrize`, and mock only HTTP boundaries.
- **"Make the failing e2e tests pass"** → read `references/debugging-and-fixing.md`
  and `references/e2e-browser-testing.md`; group failures by root cause, fix
  infrastructure first.
- **"Is my app production-ready?"** → read `references/code-quality-and-review.md`,
  then `references/ship-gates-and-verification.md` before deploy.
- **"生成单元测试/测试驱动开发/覆盖率"** → 先读 `references/tdd-and-testing-discipline.md`
  与 `references/unit-testing.md`，按 TDD 流程先生成失败测试再实现。

## References (detail)

- `references/tdd-and-testing-discipline.md` — TDD cycle, iron law, three laws,
  AAA, verification checkpoints, anti-patterns, multi-agent orchestration.
- `references/unit-testing.md` — pytest patterns, Jest/Vitest patterns, factories,
  mocking boundaries, coverage & test generation, anti-patterns.
- `references/e2e-browser-testing.md` — Playwright, Cypress, selector & wait
  strategies, auth isolation, Android journey testing, DevTools workflow, webapp
  testing.
- `references/test-quality-review.md` — nine universal rules for reviewing tests,
  severity guide, reporting format, stack-specific patterns.
- `references/load-performance-testing.md` — k6 scenarios, thresholds, HTTP/WS,
  browser load, CI integration, result analysis.
- `references/debugging-and-fixing.md` — systematic four-phase debugging, root-cause
  tracing, bug patterns, test-fixing workflow, debugger tooling.
- `references/code-quality-and-review.md` — review checklists, clean code,
  comprehensive audits, find-bugs, tech debt, linting (ShellCheck), spec compliance.
- `references/ship-gates-and-verification.md` — pre-ship gate, silent failure modes,
  live verification, verifying agent "done" claims against git.
- `references/advanced-and-misc.md` — framework migration, SmartUI visual regression,
  A/B testing, pairwise test generation, Temporal workflows, screen readers,
  mock detection, browser-automation registry.
