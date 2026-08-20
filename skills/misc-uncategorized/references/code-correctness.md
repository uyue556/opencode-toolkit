# Code Correctness, Review & Debugging

Consolidates the Logic-Lens family (logic-review, logic-locate, logic-explain, logic-diff,
logic-fix-all), correctness-first family (invariant-guard, lemmaly, complexity-cuts, mathguard,
doc2math), axiom, doubt-driven-development, variant-analysis, phase-gated-debugging,
bugs-are-annoying, bug-hunt-swarm, review-swarm, brooks-* (audit/debt/review/sweep),
clean-code-guard, andrej-karpathy, sharp-coder, super-code, sharp-edges, simplify-code,
review-and-simplify-changes, unslop-review, docs-guard, woo-guard, re-create,
deprecation-and-migration, orchestrate-batch-refactor.

## 0. Routing (logic family)

- **logic-review**: review a single file/function for logic bugs (no confirmed failure).
- **logic-locate**: find root cause of a CONFIRMED failure via backward-then-forward tracing.
- **logic-explain**: explain what code does for a given input via step-by-step execution trace.
- **logic-diff**: compare two code versions for semantic equivalence via side-by-side tracing.
- **logic-fix-all**: repository-wide audit-and-fix pipeline (health → review → locate/explain →
  fix → diff-verify → iterate).

## 1. Logic Review — the Five-Field Contract

Semi-formal execution tracing. Each finding MUST contain five literal field labels:
`Premises:` / `Trace:` / `Divergence:` / `Trigger:` / `Remedy:` (Chinese: 前提 / 追踪 / 偏差 /
触发 / 修复). These exact tokens are consumed by downstream graders — do NOT paraphrase or
substitute synonyms; a synonym that reads fine to a human breaks the contract.
No-bug case still emits the full skeleton with `Divergence: None — [why the premise holds]`.

Process: (0) language + scope routing; (1) establish claimed behavior + entry points; (2) build
premises; (3) build risk-path ledger (L1–L9 classes: naming/scope, operator coercion, boundary
blindspot, mutation/aliasing, error-swallowing, callee contract mismatch, concurrency, logic
error, encoding/timezone); (4) deep-trace normal + edge paths; (5) identify divergences, apply
reachability gate; (5.5) adversarial red team (disprove each finding via premise/path/consequence
rebuttal; design-intent gate for L3); (6) Iron Law five-field discipline; (6.5) remedy dry-run;
(7) output with literal `**Logic Score:** XX/100`; (8) optional execution verification.

Disambiguation rules: multi-context state access = L7 never L4; operator-level coercion = L2 (not
L6); single-context error swallow = L5 (not L7); timezone/locale lost at data-type level = L9.

## 2. Correctness-First Coding (invariant-guard / lemmaly / mathguard / complexity-cuts)

Family thesis: correctness and complexity are designed before code is written.

**invariant-guard — The Iron Law: NO LOOP OR RECURSION WITHOUT A WRITTEN INVARIANT AND
TERMINATION ARGUMENT.** Pre-write protocol (in this order): function contract (pre/post + return)
→ loop invariants (one per loop) → termination arguments (strictly decreasing measure) → base
cases + measure for recursion → edge-case table (empty, singleton, all-equal, sorted, duplicates,
negatives, overflow, NaN/±Inf/denormals, off-by-one, concurrent modification) → illegal states
made unrepresentable (sum types, newtypes, parse-don't-validate) → code → self-check. If 1–6
missing, do not emit code. Canonical trap: Boyer-Moore majority vote, binary-search leftmost —
the bug is in the contract, not the loop body.

**lemmaly — algorithm-first**: state Big-O, data structure, and algorithm family BEFORE writing
loops/queries/recursion. Rule catalog scans for accidental O(n·m), missing precomputation,
wrong data-structure choice, non-termination. For new code.

**complexity-cuts**: lower Big-O on EXISTING code, one transformation at a time, with
verify-revert-stop. Never change semantics and patch the test to match; preserve semantics and
verify each transformation. Time reductions (hash lookup for membership, two-pointer, prefix
sums, avoid repeated scans, precompute). Space reductions (in-place, streams, memoization only
when it pays). Stop when the remaining work is constant-factor or readability loses.

**mathguard**: math-heavy escalation for n≥10^6 — probabilistic structures (Bloom, HyperLogLog,
Count-Min, MinHash/LSH), FFT/transforms, JL projection, sweep line, geometric spatial queries.
Pre-proposal protocol: prove the approach before writing. Canonical example: distinct-user counting
→ HyperLogLog with auditable error bound (silent OOM or billing errors happen without it).

**doc2math**: convert narrative technical docs into grounded Mathematical Problem Specifications —
variables, constraints, objective, units. Zero-inference protocol: never infer numbers absent from
the source; surface missing information explicitly; validate and score completeness.

## 3. Axiom — First-Principles Assumption Audit

Bilingual (中文/English). 5 phases: (1) problem reframing (confirm the real question before
touching assumptions), (2) assumption mining across three layers (surface/middle/deep — find
8–12, reject vague), (3) classification: Physical Fact (accept) / Historical Convention (check if
environment changed) / Subjective Belief (verify, seek counter-evidence) / Interest-Driven (trace
the incentive chain — who profits?), (4) risk ranking: Fragility × Impact, output Top-3 with a
specific verification question each, (5) reconstruction from verified premises, explicitly
comparing "before vs after" cognitive shift; if identical, explain why. Anti-sycophancy: no
agreeing-without-analysis. Quick mode: output the ONE thing to verify first.

## 4. Doubt-Driven Development

Every non-trivial decision gets a fresh-context adversarial review before it stands. Steps:
CLAIM (surface what stands) → EXTRACT (smallest reviewable unit) → DOUBT (invoke a fresh-context
reviewer — a subagent that didn't do the work — with the artifact + contract; write prompt +
artifact + contract to a temp file, pipe via stdin to avoid shell metacharacter issues; supports
cross-model escalation to Codex/Gemini in read-only plan mode) → RECONCILE (fold findings back) →
STOP (bounded loop, not recursion). Red flags: reviewing your own work in the same context,
rationalizing defects, infinite doubt loops.

## 5. Debugging Protocols

**phase-gated-debugging** — 5 phases, code edits blocked until root cause confirmed:
(1) REPRODUCE (run 2-3x, capture exact error; no reading code, no hypothesizing, no editing);
(2) ISOLATE (read code, add `// DEBUG` logging, binary search; don't fix even if you see it);
(3) ROOT CAUSE (5 Whys; state analysis; **WAIT for user confirmation**); (4) FIX (remove DEBUG,
minimal change to confirmed root cause only); (5) VERIFY (original failing test passes, related
tests, intermittent → 5+ runs; on failure go back to phase 2).
Bug-type strategies: crash → backward trace of bad value; wrong output → binary search logging;
intermittent → diff passing vs failing logs; regression → `git bisect`; performance → timing at
stage boundaries.

**bugs-are-annoying** — adversarial correctness pass. Bug taxonomy + severity (critical/
intermediate/normal), output `bugs.md` in defined format, re-run behavior keeps history, hard
rules, fix mode only on explicit trigger.

**bug-hunt-swarm** — parallel read-only multi-agent root-cause investigation: build bug packet →
bound the investigation → launch 4 investigators (reproduction & scope; code path & failure seam;
recent change & regression; proof plan & observability) → synthesize ranked hypotheses → output a
clear diagnosis path. Read-only: no agent edits.

**variant-analysis** — find similar vulnerabilities/bugs across codebases via pattern-based
analysis: understand original issue → create an exact match → identify abstraction points →
iteratively generalize → analyze & triage. Pitfalls: too-narrow search scope, over-specific
pattern, single vulnerability class, missing edge cases.

## 6. Review Swarms & Diff Review

**review-swarm** — parallel read-only review of a current diff/scope: 4 reviewers (intent &
regression; security & privacy; performance & reliability; contracts & coverage) → aggregate &
filter → order output → recommend path forward.

**simplify-code / review-and-simplify-changes** — determine scope + diff command → launch 4
parallel review sub-agents (reuse; code quality; efficiency; clarity & standards) → aggregate →
fix carefully → validate → summarize.

## 7. Brooks-Lint Family (architecture / debt / review / sweep)

- **brooks-audit**: architecture audit — module dependency graph (Mermaid), layering integrity,
  circular imports, structural decay. Scans decay risks (dependency disorder, domain model
  distortion, + four more), testability seam assessment, Conway's Law check. Output: Mermaid
  graph FIRST (nodes colored red/yellow/green), then findings. Has an onboarding mode (explain
  without diagnosing).
- **brooks-debt**: tech debt assessment — scan all six decay risks, list every finding before
  scoring; Pain × Spread priority formula; classify debt intent; group by decay risk; output debt
  summary table + refactoring roadmap.
- **brooks-review**: PR review surfacing decay risks, design smells, maintainability issues with
  Symptom → Source → Consequence format.
- **brooks-sweep**: full-sweep — unified analysis across code decay, architecture, tech debt,
  test quality, THEN applies fixes: safe changes auto-applied, risky confirmed first. Pre-flight
  consent notice required. Iterate to clean rounds; cap non-critical rounds at 3; retire
  3-retry failures to unresolvable; output Full Sweep Report.

## 8. Clean Code & AI-Specific Guardrails

**clean-code-guard** — review generated/changed code against Clean Code, SOLID, DRY, KISS, YAGNI
+ LLM-specific failure-mode checklist. AI-specific guardrails are the highest-leverage section:
over-engineering, speculative abstraction, copy-paste with drift, dead code, incorrect error
handling, over-commenting. The floor: never cut correctness for simplicity.

**andrej-karpathy** — Karpathy guidelines: (1) think before coding, (2) simplicity first, (3)
surgical changes (small focused diffs), (4) goal-driven execution (check against the goal).

**super-code / sharp-coder** — dense, correct, idiomatic code; minimal bloat; compression pass on
your own draft; guardrail check before presenting; generation-token rules (no unrequested
artifacts, no prose overhead). Sharp-coder adds a "caveman compression" speak layer with
auto-clarity (drop compression for nuanced explanation).

**sharp-edges** — analyze footguns: algorithm/mode-selection traps, dangerous defaults, primitive
vs semantic APIs, configuration cliffs, silent failures, stringly-typed security. Surface,
demonstrate, and document sharp edges rather than avoiding analysis.

## 9. Unslop Review

Rewrite code-review comments so they read like a human teammate: cut corporate-AI throat-clearing
("I notic…", "great question!", "as an AI"), keep the substance, drop emoji/surplus politeness,
one clear actionable point. Tone: direct, specific, kind.

## 10. Docs Guard & Woo Guard

- **docs-guard**: review generated/changed docs before shipping — accuracy must-fix (wrong
  commands, outdated APIs), versioning/drift, substance should-fix (missing edge cases), structure
  worth-noting. Verify commands against the actual codebase.
- **woo-guard**: review WooCommerce extensions/payment/shipping integrations — order & product
  data must-fix, checkout & money must-fix (never break payment flows), runtime discipline
  should-fix.

## 11. Re-create (controlled erasure & rebuild)

When structural rot makes patching impossible: PHASE 1 justify the erasure (must clear the bar);
PHASE 2 read the target completely; PHASE 3 erasure declaration — USER MUST CONFIRM; PHASE 4
controlled erasure (preserve list); PHASE 5 rebuild against the preservation list; PHASE 6 blast
radius verification. Hard rules: never erase without confirmation; preserve behavior contract;
verify blast radius. Trigger phrases: "re-create", "rewrite this module", "this file is beyond
saving".

## 12. Deprecation & Migration

Code is a liability; Hyrum's Law makes removal hard; deprecation planning starts at design time.
Decision: compulsory vs advisory deprecation. Process: (1) build the replacement, (2) announce +
document (deprecation notice w/ migration guide), (3) migrate incrementally, (4) remove the old
system. Patterns: Strangler (route traffic gradually), Adapter (compat shim), Feature-flag
migration. Avoid zombie code (deprecated-but-undeleted) — schedule removal.

## 13. Orchestrate Batch Refactor

Plan large refactors with dependency-aware work packets + parallel analysis. Work-packet rules
(small, dependency-isolated, reversible), planning contract, agent prompting contract, safety
guardrails (no parallel edits to same file), validation strategy (verify each packet before next).
Parallelize only when packets are truly independent.
