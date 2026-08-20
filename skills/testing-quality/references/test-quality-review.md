# Test Quality Review

Universal rules for reviewing generated or changed test code before it ships.
Merged from: `test-guard`, `brooks-test`, and the review guidance in
`lambdatest-agent-skills`, `test-automator`, `tdd-orchestrator`.

## When to apply

Activate reactively after any agent writes, edits, generates, or refactors tests —
unit, integration, E2E, or snapshot, in any framework. Also apply while *writing*
tests if the user invokes review before the fact. Report violations concisely
(rule number, location, why, fix) grouped by file; skip files with no violations.

## Adapt to the project first

1. Check the project's own agent instructions and testing docs — project-specific
   rules win on conflict.
2. Identify the test stack and read the matching patterns:
   - Python / pytest → the pytest sections in `unit-testing.md`
   - JS/TS / Jest / Vitest → the Jest sections in `unit-testing.md`
   - PHP / PHPUnit → apply the same rules with `#[DataProvider]`, Pest
3. Map system boundaries: network calls, databases, filesystem, clock/randomness,
   third-party SDKs, LLM APIs. Existing fixtures reveal where the project draws them.

## The nine rules

### Rule 1 — Test behavior, not implementation
Assert return values and observable side effects from the caller's perspective.
Never assert that an internal helper was called with specific arguments — that
breaks on every refactor while catching nothing. *Violation:* asserting a mock of
an internal function was called where that function isn't a system boundary.

### Rule 2 — Every mock must be justified
Mock only at system boundaries: network/HTTP, LLM APIs, databases (when not the
subject), filesystem I/O on external paths, clock/randomness, third-party SDKs.
Never mock internal classes or helpers to "isolate a unit" — those seams hide
integration bugs. When you mock a boundary, assert what the caller *does with the
response*, not that the mock received specific arguments.

### Rule 3 — One scenario per test, data-driven for variants
Tests that share identical setup and differ only in input/output values → merge
into `@pytest.mark.parametrize`, `test.each`, or `#[DataProvider]`. Keep separate
tests when setup, assertions, mock configs, or the scenario genuinely differ.

### Rule 4 — Every test must justify its existence
Ask: "What bug does this catch that no other test catches?" Delete tests that only
catch typos, verify default values of data classes, or test trivial pass-through
logic. Common unjustified tests: constructors setting attributes, rejecting input
the type system already forbids, string formatting of log messages.

### Rule 5 — Name tests for the scenario
Pattern: `test_<scenario>_<expected_outcome>`. The name should read like a
requirement, not echo the function signature.

| Bad | Good |
|-----|------|
| `test_parse_response_missing_field` | `test_malformed_response_falls_back_to_default` |
| `test_add_tags_single_string` | `test_single_tag_normalizes_to_list` |

### Rule 6 — Production regression tests are sacred
Tests reproducing a real production bug are always justified. Reference the
incident (date, issue ID, short description) in the name or a comment, and never
delete them. Exempt from Rule 4.

### Rule 7 — No tests for framework guarantees
Don't test that the validation library validates, the ORM commits, or the router
returns 404. Test *your* logic on top of the framework. *Violation pattern:* a
test that still passes if you deleted all project custom code and kept framework
defaults.

### Rule 8 — State and value objects are real, never mocked
Never mock a data model, DTO, entity, or state object. Construct a real instance —
mocking hides field-name typos and validation errors. If constructing is painful,
that's design feedback: add a builder/factory helper, not a mock.

### Rule 9 — Infrastructure under test gets real infrastructure
When DB queries, schema behavior, or persistence logic *is the subject*, run
against a real test database with real migrations (pytest-postgresql, testcontainers,
SQLite-compatible, or a session fixture running `alembic upgrade head`). Mocking the
session there tests nothing. Mocking the DB is fine when persistence is only a side
effect of the behavior under test.

## Severity guide

- **Must fix:** Rules 1, 2, 8 — hide real bugs or make tests brittle.
- **Should fix:** Rules 3, 4, 5, 7 — bloat and maintenance drag.
- **Sacred:** Rule 6 — never delete.
- **Worth noting:** Rule 9 — test architecture; flag but don't block small changes.

## Reporting format

```
**Rule N violation** in `tests/path/file.ext::<test_name>`
- What: <one sentence describing the violation>
- Fix: <one sentence describing what to do instead>
```

## Writing new tests — the gate

Before writing each test, ask: **"What specific bug does this catch that no other
test in this suite catches?"** If you can't answer clearly, don't write it. Then
double-check: mock-heavy unit tests that assert implementation details, near-duplicate
test bodies, and tests that re-verify the framework are the most common agent
over-generation failures — each looks productive in a diff and costs maintenance
forever.

## Broader test-suite review (Brooks/engineering books lens)

When reviewing an existing suite structurally, also scan for:
- **Brittleness:** tests coupled to implementation details, exact string/output
  matching where semantics matter, environment-dependent tests.
- **Test decay:** slow suites, flaky tests, missing isolation, shared mutable state,
  tests that pass but assert nothing.
- **Coverage quality:** gaps in critical paths; coverage numbers that look good but
  are dominated by trivial assertions.
- **Legacy code:** characterize with tests (golden master) before refactoring;
  use seams and dependency breaking for testability rather than mocking everything.

## What test review is NOT

- It doesn't run tests (use the project runner).
- It doesn't enforce code style (that's the linter).
- It doesn't decide *what* to test — only *how* to test it.
- It doesn't flag pre-existing violations in files you're not touching, unless asked
  to audit.
