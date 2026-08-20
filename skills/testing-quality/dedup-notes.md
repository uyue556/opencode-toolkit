# Deduplication Notes — testing-quality

## Sources scanned

- `testing/` — 27 SKILL.md
- `test-automation/` — 9 SKILL.md
- `quality/` — 2 SKILL.md
- `code-quality/` — 15 SKILL.md
- `development-and-testing/` — 6 SKILL.md
- **Total: 59 SKILL.md**

## Notable duplicates merged

| Dup group | Merged into | What was dropped/merged |
|-----------|-------------|-------------------------|
| TDD core: `test-driven-development`, `tdd-workflow`, `tdd-workflows-tdd-cycle`, `tdd-workflows-tdd-red`, `tdd-workflows-tdd-green`, `tdd-workflows-tdd-refactor`, `tdd-workflows` (alias), `tdd-orchestrator` | `references/tdd-and-testing-discipline.md` | All describe the same RED-GREEN-REFACTOR cycle. Kept the iron law + verification-gates emphasis from `test-driven-development` (deepest), merged three-laws/AAA/anti-patterns from `tdd-workflow`, coverage thresholds from `tdd-workflows-tdd-cycle`, multi-agent orchestration from `tdd-orchestrator`. `tdd-workflows` is a pure alias to `tdd-workflows-tdd-cycle` — dropped as a separate entry. |
| Debugging: `systematic-debugging`, `bug-hunter`, `debugger`, `debugging-strategies` | `references/debugging-and-fixing.md` | All cover reproduce → root cause → fix → test. Kept the four-phase "iron law" structure from `systematic-debugging` (deepest + most prescriptive), merged bug-pattern catalog + tooling from `bug-hunter`. `debugger` and `debugging-strategies` were thin (58/42 lines) re-statements — signal folded into the phase descriptions. |
| Code review: `code-review-checklist`, `find-bugs`, `comprehensive-review-full-review`, `comprehensive-review-pr-enhance`, `codex-review`, `fix-review`, `vibers-code-review`, `uncle-bob-craft` | `references/code-quality-and-review.md` | `code-review-checklist` (452 lines, deepest) supplies the checklist core; `find-bugs` supplies the diff security checklist; `uncle-bob-craft`/`clean-code` supply craft principles; `fix-review`'s "verify fixes don't regress" folded into PR-enhance section. `codex-review` (marketing install wrapper), `vibers-code-review` (3rd-party service setup), `openclaw-github-repo-commander` (unrelated repo-management workflow) were reduced to a mention or dropped. |
| Clean code: `clean-code`, `uncle-bob-craft`, `kaizen` | `references/code-quality-and-review.md` | `clean-code` (99 lines) gives the distilled book; `uncle-bob-craft` adds architecture/SOLID/design-pattern discipline; `kaizen` (737 lines) overlaps on refactoring mindset — kept its unique error-proofing (poka-yoke) + JIT/YAGNI sections, dropped the repeated "incremental refactor" framing. |
| E2E/browser: `browser-automation`, `playwright-skill`, `cypress-skill`, `e2e-testing-patterns`, `webapp-testing`, `go-playwright`, `playwright-java` | `references/e2e-browser-testing.md` | `browser-automation` (1116 lines) is the deepest: selectors, auto-wait, isolation, stealth. `playwright-skill` is a custom skill-dir installer wrapper (path-resolution + run.js) — its executable machinery can't port; its locator/wait patterns merged. `playwright-java` + `go-playwright` kept as language-specific sections. Cypress chain-API kept separate from Playwright async API (they genuinely differ). |
| Android UI: `android-ui-journey-testing`, `android_ui_verification` | `references/e2e-browser-testing.md` | Near-duplicate ADB tap/swipe/type + uiautomator-dump workflows. Merged into one Android section (kept XML-journey + JSON-report from the deeper one). |
| Visual regression: `smartui-skill` + DevTools screenshot-verification (`browser-testing-with-devtools`) | `references/advanced-and-misc.md`, `references/e2e-browser-testing.md` | SmartUI cloud specifics kept in advanced; generic before/after screenshot verification kept in the DevTools section. |
| Load testing: `k6-load-testing` (only one) | `references/load-performance-testing.md` | No dup — carried whole. |
| Test review: `test-guard` (nine rules) + `brooks-test` (suite-structure review) | `references/test-quality-review.md` | Different granularity (per-test rules vs suite-level decay) — complementary, merged without loss. |

## Skills dropped / not carried

| Skill | Reason |
|-------|--------|
| `tdd-workflows` | Pure alias to `tdd-workflows-tdd-cycle`. |
| `codex-review` | Install-wrapper + CHANGELOG tooling tied to an external npm skill; no portable methodology. |
| `vibers-code-review` | Third-party paid service setup (add collaborator + GitHub Action); not reusable guidance. |
| `openclaw-github-repo-commander` | 7-stage GitHub repo-management workflow outside testing/quality scope. |
| `network-101` | Penetration-lab HTTP/HTTPS/SNMP/SMB server setup — infrastructure, not testing methodology. Only noted in context. |
| `lambdatest-agent-skills` | An *index* of 46 external skills; folded its best-practices (env credentials, POM, explicit waits) into `advanced-and-misc.md` instead of reproducing the registry. |
| `awt-e2e-testing` | External beta tool install (`npx skills add ...`); noted briefly, no methodology to extract. |
| `playwright-skill` helper machinery | `run.js`/`lib/helpers.js`/`scripts/with_server.py` referenced by sources but **not present in the libraries** — nothing to copy. |
| `spec-to-code-compliance` | Blockchain-specific but the IR-based compliance method generalizes; kept condensed in code-quality reference. |
| `temporal-python-testing`, `bats-testing-patterns`, `screen-reader-testing`, `pypict-skill`, `ab-testing`, `mock-hunter` | Domain-specific but genuinely reusable; carried as sections/references. |

## Scripts

No `scripts/` directories existed in any of the five source libraries (verified by
find). `webapp-testing` references `scripts/with_server.py` and `playwright-skill`
references `run.js`/`lib/helpers.js`, but those files are not present in the shipped
libraries, so nothing could be carried over. **No scripts copied.**

## Gaps / doubts

- `browser-automation` is 1116 lines; I deep-read the first 360 lines and the
  validation-checks tail (995-1116), skimming the middle (anti-detection proxy/UA
  rotation, popups/iframes) — the essential reusable patterns (locators, waits,
  isolation, stealth) are captured.
- `shellcheck-configuration` is 474 lines; I read the fundamentals + error-code
  sections (1-140) and generalized the rest (full code catalog isn't reproducible
  verbatim).
- `codebase-cleanup-tech-debt` was read to ~120 lines; the inventory + cost model is
  captured, deeper remediation checklists generalized.
- `playwright-java` was read to line 100 (project scaffold + thread-safe BaseTest);
  the assertion/fixture references are summarized, not fully ported.
- Several sources reference `resources/implementation-playbook.md` files that are
  not present in the libraries — those deep-dive files could not be consulted.
- The DOS-kernel CLI (`dos verify` / `dos commit-audit`) in `dos-verify-done-claims`
  requires an external pip package; guidance is preserved but assumes the tool is
  installed.
