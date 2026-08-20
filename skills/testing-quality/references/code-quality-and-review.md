# Code Quality & Review

Code review, clean code, auditing, linting, and technical debt. Merged from:
`code-review-checklist`, `find-bugs`, `clean-code`, `uncle-bob-craft`,
`vibe-code-auditor`, `kaizen`, `codebase-cleanup-tech-debt`, `shellcheck-configuration`,
`spec-to-code-compliance`, `comprehensive-review-full-review`,
`comprehensive-review-pr-enhance`, `codex-review`, `fix-review`, `vibers-code-review`,
`code-refactoring-refactor-clean`, `openclaw-github-repo-commander`.

## Code review checklist

### Pre-review
- Read the PR description and linked issues; understand the problem being solved.
- Check CI passes; pull the branch and run it locally when possible.

### Functionality
- Code solves the stated problem; edge cases and error handling present.
- User input validated; no logical errors (off-by-one, wrong conditions).
- Loops terminate; recursion has base cases; state management correct.

### Security
- SQL injection prevented (parameterized queries), XSS escaped, CSRF protected.
- Auth required and authorization verified (not just authentication/IDOR).
- Passwords hashed; no hardcoded secrets; env vars for secrets.
- Dependencies: no known vulnerabilities, pinned versions, no unnecessary deps.

### Performance
- No unnecessary loops/queries; no N+1 problems; caching appropriate; no leaks.

### Tests
- New code has tests; edge cases covered; tests meaningful; all pass; coverage
  adequate. (See `test-quality-review.md` for *how*.)

### Maintainability
- Readable, descriptive names; small focused functions; DRY; proper separation of
  concerns; no dead/commented-out code; comments explain why, not what.

### Git/process
- Clear commit messages, no merge conflicts, branch up to date, no stray files.

Review style: small changes, constructive feedback, prioritize security > bugs >
quality, skip cosmetic nitpicks, use automated tools (linters, scanners). Don't
rubber-stamp; be specific with examples.

## Finding bugs & security issues in a diff

1. Get the FULL diff (`git diff <base>...HEAD`); read every changed line if truncated.
2. Map the attack surface: user inputs, DB queries, auth checks, session/state ops,
   external calls, crypto.
3. Run the checklist for every changed file: injection, XSS, auth, authorization/
   IDOR, CSRF, race conditions (TOCTOU), session security, crypto, information
   disclosure, DoS, business logic.
4. Verify each potential issue: is it handled elsewhere? Is there a test? Read
   surrounding context.
5. Pre-conclusion audit: list every file reviewed, every checklist item's status,
   and areas you couldn't verify. Don't invent issues.

Report format per issue: `File:Line`, severity (Critical/High/Medium/Low), problem,
evidence, concrete fix, references (OWASP etc.).

## Clean code (Uncle Bob)

- **Names:** intention-revealing (`elapsedTimeInDays` not `d`), searchable,
  pronounceable; classes = nouns, methods = verbs; no disinformation.
- **Functions:** small, do one thing, one level of abstraction, 0-2 arguments
  (3+ justified), no side effects.
- **Comments:** don't comment bad code — rewrite it. Good: legal, intent of regex,
  TODOs. Bad: mumbling, redundant, misleading, noise.
- **Error handling:** exceptions over return codes; try-catch-finally first;
  don't return null; don't pass null; validate at boundaries.
- **Classes:** small, single responsibility, stepdown rule (read like top-down
  narrative).
- **Tests:** F.I.R.S.T. — Fast, Independent, Repeatable, Self-Validating, Timely;
  the three laws of TDD.
- **Smells:** rigidity, fragility, immobility, viscosity, needless complexity,
  needless repetition, opacity.

### Craft beyond clean code (Uncle Bob architecture/SOLID)
- **Dependency Rule:** dependencies point inward — business rules in the center,
  adapters at the edges.
- **SOLID in context:** SRP, Open/Closed, Liskov, Interface Segregation, Dependency
  Inversion — apply where they fit, name the violation and location.
- **Design patterns:** introduce only when duplication or variation justifies them
  (Rule of Three — third duplication / second reason to change); avoid cargo cult.
- Review: name the smell, propose 1-2 concrete refactors, note whether tests exist
  and sustainable pace. This does not replace the linter/formatter.

## Auditing AI-generated / "vibe" code

Assess whether code that "works" is robust, maintainable, production-ready. Seven
dimensions:

1. **Architecture & design:** identifiable entry point, layer boundaries, no god
   objects/circular deps/scattered DB queries.
2. **Consistency & maintainability:** consistent naming, single-purpose functions,
   no 3+ copy-paste blocks (extract), no obscuring abstractions, no magic numbers.
3. **Robustness & error handling:** input validation on entry points, no bare
   `except`/catch-all, edge cases handled, retries + timeouts on external calls.
4. **Production risks:** no hardcoded config/URLs, structured logging, no N+1 or
   unbounded loops, graceful shutdown, health checks, rate limiting.
5. **Security & safety:** no `eval`/`exec`/`os.system` misuse, no credentials in
   source/logs, no SQL injection, no path traversal, no insecure deserialization,
   no insecure defaults (DEBUG=True).
6. **Dead or hallucinated code:** unused functions/imports, imports not in declared
   deps, references to APIs that don't exist in the used library version, comments
   contradicting code, unreachable code.
7. **Technical debt hotspots:** deep nesting, boolean flags, 5+ params, functions
   that will break under load.

Pattern shortcuts: `eval`/`exec` → critical; bare `except` → silent failure;
`password/secret/key/token` literal → hardcoded creds; `f"SELECT` string concat →
SQL injection; `requests.get` without timeout → prod risk; `while True` without
break → unbounded loop.

Output: executive summary (3-5 bullets, severity-tagged), critical/high/mid/low
findings with location + before/after fix, production-readiness score (0-100,
-15 CRITICAL / -8 HIGH / -3 MEDIUM, security CRITICAL -20), refactoring priorities
(P1-P5 with effort), quick wins. Ground every finding in actual code — do not invent.

## Kaizen — continuous improvement (when refactoring)

- **Incremental over revolutionary:** smallest viable improvement, one at a time,
  verify each change, commit after each.
- **Error-proofing (poka-yoke):** make invalid states unrepresentable (types,
  discriminated unions, `NonEmptyArray`, branded types); validate at boundaries;
  guard clauses; fail fast with clear messages; validate config at startup.
- **Standardized work:** follow existing codebase patterns; document "why"; automate
  standards with linters/type checks/tests/CI.
- **JIT/YAGNI:** build only what's needed now; optimize only when measured; abstract
  only after 3+ cases; prefer duplication over a wrong abstraction.

## Technical debt analysis

Inventory by type: code (duplication, complexity >10, deep nesting, long methods,
god classes), architecture (leaky abstractions, violated boundaries), technology
(deprecated APIs, unsupported deps), testing (coverage gaps, brittle/slow/flaky),
documentation, infrastructure (manual deploys, no rollback/monitoring). Assess cost
in velocity (hours per fix × frequency) and quality impact. Remediate in phases
(e.g., Strangler Fig / Branch by Abstraction for legacy), with prevention strategy
and success metrics. Prioritize by ROI.

## Linting — ShellCheck (shell scripts)

- Analyze bash/sh/dash/ksh; 100+ warnings; configure via `.shellcheckrc`
  (`shell=bash`, `enable=...`, `disable=SC...`) and env vars.
- Common codes: SC2086 (double-quote to prevent word splitting), SC2016 (no
  expansion in single quotes), SC2009 (use pgrep), SC2012 (use find not ls),
  SC2015 (avoid `&&`/`||` instead of if-then-else), SC1004 (line continuation).
- Integrate into CI as a quality gate.

For other languages, the principle generalizes: static analysis in CI as a gate,
configured per project, with false positives suppressed explicitly.

## Spec-to-code compliance

For blockchain/audit contexts (or any formal spec): verify code implements exactly
what the spec says — never infer unspecified behavior, cite exact evidence (spec
section + code file/line), provide confidence scores for mappings, classify
ambiguity instead of guessing, treat undocumented behavior as UNDOCUMENTED CODE PATH.
Phases: discover docs → normalize → build spec IR → build code IR → alignment →
classify divergence (CRITICAL/HIGH/MEDIUM/LOW) → audit-grade report.

## PR enhancement & reviewing fixes

- **PR descriptions:** categorize changes (source/test/config/docs/build), template
  with Summary / Changes / Why / Testing / Risks & Rollback; add a review checklist
  matching the changed file categories; flag security-sensitive files and large diffs;
  suggest splitting >20 files or >1000 lines.
- **Reviewing fix commits (audit follow-up):** verify the fix addresses the root
  cause, not symptoms; check for regressions and side effects; confirm tests cover
  the fixed scenario; check for similar vulnerabilities elsewhere; document the
  resolution approach.
- **Verify fixes don't introduce new bugs:** compare against the original finding,
  check completeness, ensure no new vulns in related code.
