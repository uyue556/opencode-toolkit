# Debugging & Fixing

Systematic debugging, root-cause analysis, and fixing failing tests. Merged from:
`systematic-debugging`, `bug-hunter`, `test-fixing`, `debugger`, `debugging-strategies`,
and the debugging integration in `test-driven-development`.

## The iron law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

Symptom fixes are failure. Random fixes waste time and create new bugs. Use this for
ANY technical issue: test failures, bugs, unexpected behavior, performance problems,
build failures, integration issues. Especially under time pressure — systematic
debugging is faster than guess-and-check thrashing.

## The four phases

Complete each phase before the next.

### Phase 1 — Root cause investigation

1. **Read error messages carefully.** Full stack traces, line numbers, file paths,
   error codes. Don't skip warnings.
2. **Reproduce consistently.** Exact steps? Every time or random? Not reproducible →
   gather more data, don't guess.
3. **Check recent changes.** `git diff`, recent commits, new deps, config, environment.
4. **Gather evidence in multi-component systems.** For each component boundary
   (CI → build → signing, API → service → database), log what enters and exits,
   verify env/config propagation. Run once to see WHERE it breaks, then investigate
   that component.
5. **Trace data flow.** Where does the bad value originate? What called this with a
   bad value? Trace upward to the source. Fix at the source, not the symptom.

### Phase 2 — Pattern analysis

- Find similar *working* code in the same codebase; read the reference implementation
  completely (don't skim).
- List every difference between working and broken — don't assume "that can't matter".
- Understand dependencies: settings, config, environment, assumptions.

### Phase 3 — Hypothesis and testing

- Form ONE specific hypothesis: "I think X is the root cause because Y."
- Test minimally: the smallest change, one variable at a time.
- Verified? → Phase 4. Not verified? → new hypothesis. Don't stack fixes.
- If you don't know something, say so — don't pretend.

### Phase 4 — Implementation

1. **Create a failing test case first** (simplest reproduction; automated test if
   possible). Never fix bugs without a test.
2. **Implement a single fix** for the root cause. No "while I'm here" improvements.
3. **Verify:** test passes, no other tests broken, issue actually resolved.
4. **If 3+ fixes have failed → STOP and question the architecture.** Each fix
   revealing new coupling/shared-state problems in different places, or fixes
   requiring "massive refactoring," means the pattern itself is wrong — discuss
   with your human partner before attempting more fixes.

## Debugging techniques

- **Binary search:** insert checkpoints; does the bug occur before/after this line?
- **Print/log debugging:** log input, transform, pre-save, result.
- **Diff debugging:** compare working vs broken (recent changes, environments, data).
- **Rubber duck debugging:** explain the code line by line out loud.
- **Time travel:** `git bisect start; git bisect bad; git bisect good <old-commit>`;
  git checks out commits for you to test.
- **Minimal reproduction:** simplify until the bug either reproduces clearly or
  disappears.
- **Isolation:** comment out / substitute mock data to narrow the failing layer.

## Common bug patterns

| Pattern | Example bug | Fix |
|---------|-------------|-----|
| Null/undefined | `user.profile.name` throws | Guard, or fix the source that fails to set the value |
| Race condition | `fetchData().then(d => data = d)` then read `data` | `await`, or react to state |
| Off-by-one | `for (i = 0; i <= len; i++)` | `< len` |
| Type coercion | `count == 0` matches `""`/`[]`/`null` | `===` |
| Async without await | `const r = asyncFn(); r.data` is undefined | `await asyncFn()` |

Fix root cause, not symptom: hiding the error (`|| 'Unknown'`) is a band-aid;
ensure the login actually sets the user ID and test it.

## Tooling

- **Browser DevTools:** Console (errors), Sources (breakpoints), Network (API),
  Application (cookies/storage), Performance (slow ops). Also see
  `e2e-browser-testing.md` for the DevTools MCP workflow.
- **Node.js:** `node --inspect app.js` then `chrome://inspect`.
- **VS Code:** `launch.json` with `"type": "node", "request": "launch"`.
- **Logs:** `tail -f logs/app.log`, `journalctl -u myapp -f`.

## Fixing failing tests (systematic)

When asked to "fix the tests":

1. **Initial run** — get the full list of failures; analyze error types and
   affected modules.
2. **Smart grouping** — group by error type (ImportError, AttributeError,
   AssertionError), module/file, or root cause (missing deps, API changes,
   refactoring impact). Prioritize by number of affected tests and dependency order.
3. **Fix order:** infrastructure first (import errors, missing deps, config), then
   API changes (signatures, module moves, renames), finally logic issues
   (assertion failures, business logic, edge cases).
4. **Fix & verify per group:** run the focused subset
   (`pytest tests/path/file.py -v`, `pytest -k "pattern"`), ensure green before
   moving on.
5. **Final:** run the full suite; confirm no regressions and coverage intact.

Use `git diff` to understand what changed. Keep changes minimal and focused; fix one
group at a time.

## When stuck

1. Take a break.
2. Explain it to someone (or a rubber duck).
3. Search for the exact error message (GitHub issues, Stack Overflow).
4. Simplify: minimal reproduction.
5. Delete and rewrite the problematic code if it's beyond repair.
6. Ask for help with context and what you've tried.

## Documentation

After fixing, document: symptom, root cause, fix, files changed (with lines),
how you tested it, and the prevention (regression test).

## Red flags — stop and follow process

- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "Add multiple changes, run tests"
- "Skip the test, I'll manually verify"
- "It's probably X, let me fix that"
- "One more fix attempt" after 2+ failures
- Each fix reveals a new problem in a different place (→ architecture)

All of these mean: stop, return to Phase 1.
