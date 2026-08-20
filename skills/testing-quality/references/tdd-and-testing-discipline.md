# TDD & Testing Discipline

Test-driven development, the red-green-refactor cycle, and the discipline rules that
make test-first work. Merged from: `test-driven-development`, `tdd-workflow`,
`tdd-workflows-tdd-cycle`, `tdd-workflows-tdd-red`, `tdd-workflows-tdd-green`,
`tdd-workflows-tdd-refactor`, `tdd-workflows` (alias), `tdd-orchestrator`,
`test-automator` (TDD portions), and `testing-patterns`.

## The iron law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Write code before the test? Delete it and start over — no "reference", no
"adapting" it while writing tests. If you didn't watch the test fail, you don't
know it tests the right thing. Tests written after code pass immediately, and
passing immediately proves nothing.

### The three laws

1. Write production code only to make a failing test pass.
2. Write only enough test to demonstrate the failure.
3. Write only enough code to make the test pass.

## The red-green-refactor cycle

### RED — write one failing test

- One behavior per test. If the name contains "and", split it.
- Clear name describing expected behavior (`should_X_when_Y`).
- Real code, not mocks, unless mocking is unavoidable.
- Cover happy path, edge cases (empty/null/boundary/Unicode), and error states.

```typescript
test('retries failed operations 3 times', async () => {
  let attempts = 0;
  const operation = () => {
    attempts++;
    if (attempts < 3) throw new Error('fail');
    return 'success';
  };
  const result = await retryOperation(operation);
  expect(result).toBe('success');
  expect(attempts).toBe(3);
});
```

**Verify RED (mandatory):** run the test; confirm it *fails* (not errors), the
failure message is expected, and it fails because the feature is missing — not a
typo. Test passes? You're testing existing behavior — fix the test. Test errors?
Fix the error, re-run until it fails correctly.

### GREEN — minimal code

Write the simplest code that passes. No extra features, no optimization, no
refactoring beyond the test (YAGNI).

```typescript
async function retryOperation<T>(fn: () => Promise<T>): Promise<T> {
  for (let i = 0; i < 3; i++) {
    try {
      return await fn();
    } catch (e) {
      if (i === 2) throw e;
    }
  }
  throw new Error('unreachable');
}
```

**Verify GREEN (mandatory):** run the test; it passes, other tests still pass, and
the output is pristine (no warnings/errors). Test still fails? Fix the code, not
the test.

### REFACTOR — clean up, stay green

After green only: remove duplication, improve names, extract helpers. Keep tests
green. Don't add behavior. Commit after each refactor. See `code-quality-and-review.md`
for the refactoring catalog (extract method, value objects, SOLID, etc.).

### Repeat

Next failing test → next feature increment.

## AAA pattern

Every test follows Arrange-Act-Assert: set up data, execute code under test,
verify the outcome.

## Common rationalizations (and the reality)

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code breaks; the test takes 30 seconds. |
| "I'll test after" | Tests-after pass immediately and prove nothing. |
| "I already manually tested" | Ad-hoc ≠ systematic; no record, can't re-run. |
| "Deleting X hours is wasteful" | Sunk cost; keeping unverified code is technical debt. |
| "Keep as reference, write tests first" | You'll adapt it — that's testing after. Delete means delete. |
| "Test hard = design unclear" | Listen to the test: hard to test = hard to use. |
| "TDD is dogmatic" | Test-first finds bugs before commit, faster than debugging after. |
| "Tests-after achieve the same goals" | Tests-after answer "what does it do?"; test-first answers "what should it do?". |

**Red flags — stop and start over:** code before test, test passes immediately,
can't explain why it failed, rationalizing "just this once", multiple fixes at
once, skipping the test.

## Coverage thresholds & refactoring triggers

- Minimum line coverage 80%, branch coverage 75%, critical path 100% (adjust to
  project).
- Refactor when cyclomatic complexity > 10, method > 20 lines, class > 200 lines,
  duplicate blocks > 3 lines.

## Incremental vs suite mode

- **Incremental:** write ONE failing test → make ONLY that test pass → refactor →
  repeat.
- **Suite:** write ALL failing tests for a feature → implement to pass all →
  refactor → add integration tests.

## Multi-agent / orchestrator TDD

For large initiatives, coordinate specialized agents:

| Phase | Agent | Job |
|-------|-------|-----|
| Spec & test design | architect-review | Define acceptance criteria, edge-case matrix |
| RED | test-automator | Write failing tests; verify they fail for the right reason (GATE) |
| GREEN | backend-architect | Minimal implementation; keep tests green |
| REFACTOR | code-reviewer | SOLID, de-duplication; tests stay green |
| Review | architect-review | Verify TDD process, coverage, quality |

Chicago School (state-based, real objects) vs London School (interaction-based,
mocks) — pick per codebase; the boundary-mocking rules in `test-quality-review.md`
apply either way.

## Verification checklist (before marking done)

- [ ] Every new function/method has a test
- [ ] Watched each test fail before implementing (for the right reason)
- [ ] Wrote minimal code to pass each test
- [ ] All tests pass; output pristine
- [ ] Tests use real code; mocks only at boundaries
- [ ] Edge cases and error paths covered

## Anti-patterns

- Writing implementation before tests
- Writing tests that already pass
- Skipping the refactor phase
- Modifying tests to make them pass
- Ignoring failing tests
- Testing implementation details instead of behavior
- Multiple responsibilities per test
- Brittle tests tied to internals

## When to use TDD (and when not)

High value: new features, bug fixes, complex logic. Low value: throwaway
prototypes, generated code, config files, UI layout-only tweaks — ask your human
partner before skipping.
