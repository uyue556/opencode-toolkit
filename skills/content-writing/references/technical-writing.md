# Technical Writing & Documentation

Documentation for code: DevRel content, tutorials, READMEs, API docs, ADRs, wikis, reference guides, changelogs, and agent-friendly docs.

## Table of Contents
1. DevRel content for developers
2. Code examples (the copy-paste test)
3. README structure
4. Architecture Decision Records (ADRs)
5. API documentation & reference guides
6. Changelogs
7. Wikis & onboarding guides
8. Agent-friendly documentation (AI-readable)

## 1. DevRel Content for Developers

Write content developers actually read. Load audience context first: who (role, seniority, stack), their pain points, their verbatim language, and the right voice/tone.

**Validate the topic before writing:** check search intent, community signals (Reddit/HN/Stack Overflow), competitor gaps, internal data (support tickets, GitHub issues), and keyword volume. Red flags: only you care, 10 identical articles exist, or the topic is too broad/narrow.

**Developer search behavior:** they search error messages, "how to X in Y," comparisons ("prisma vs typeorm"), best practices, and alternatives. Title should carry the primary keyword, framework names, and year when relevant.

**Quality signals:**
- Show, don't tell — code over prose.
- Address the "why" and "when," not just the "how."
- Acknowledge trade-offs; developers respect honesty.
- Link official docs and RFCs; include "Updated [Date]" and versions.
- Progressive disclosure: start simple, add complexity.
- Use real production examples, not hello world.
- Buried lede kills it — answer first, explanation second.

## 2. Code Examples (the Copy-Paste Test)

Every code snippet must:
- **Run without modification** — developers copy-paste; failure costs trust.
- **Include imports** and dependencies (`npm install` / `pip install` lines).
- **Show expected output** — what they should see when it works.
- **Handle errors** — real code has error handling; show it.
- **Use real values**, not `foo`, `bar`, `example.com`.
- **Use env vars for secrets** (`process.env.KEY`, `os.environ['KEY']`, `os.Getenv("KEY")`, `$VAR`).

**Accuracy checklist before publishing:** every snippet runs, versions are current, links work, CLI commands run, screenshots match the actual UI, no deprecated APIs, no hardcoded secrets, peer review by an engineer.

## 3. README Structure

A README serves three purposes: local development in minutes, understanding the system, and production deployment. Explore the codebase first (structure, configs, database, dependencies, scripts, CI/CD) and detect the deployment target from config files.

Sections in order:
1. **Title + one-liner** — what it is and who it's for.
2. **Key features** — 3-5 bullets.
3. **Tech stack** — language, framework, database, deployment.
4. **Prerequisites** — versions and tools needed.
5. **Getting started** — clone, install, env setup (`cp .env.example .env` + table of variables), database setup, dev server. Assume a fresh machine; every step.
6. **Architecture** — directory structure, request lifecycle, data flow, key components. Go deep.
7. **Testing** — how to run tests, test structure.
8. **Deployment** — the detected platform path, production commands, envs.
9. **Contributing / License**.

Only ask the user when the codebase can't answer (project purpose, deployment credentials, business context).

## 4. Architecture Decision Records (ADRs)

**Document decisions, not just code.** Code shows *what*; docs explain *why it was built this way* and *what alternatives were rejected*. This is the highest-value documentation you can write.

**When:** choosing frameworks/dependencies, designing data models, auth strategy, API architecture, infrastructure, anything expensive to reverse. Store in `docs/decisions/`, sequentially numbered.

Template:
```
# ADR-001: Title

## Status
Accepted | Superseded by ADR-XXX | Deprecated
## Date
YYYY-MM-DD
## Context
Why are we making this decision? Requirements, constraints.
## Decision
What did we pick?
## Alternatives Considered
Per option: pros, cons, reason for rejection.
## Consequences
Trade-offs, what this commits the team to.
```

**Lifecycle:** PROPOSED → ACCEPTED → (SUPERSEDED | DEPRECATED). Never delete old ADRs; new ADRs reference and supersede old ones.

**Inline comments:** comment the *why* (non-obvious intent, rate-limiting rationale, hydration gotchas), never the *what*. No TODO-comments for things you can just do, no commented-out code (git has history).

**Rationalizations to reject:** "the code is self-documenting" (it shows what, not why/alternatives/constraints), "we'll doc when the API stabilizes" (stable APIs come from being documented), "nobody reads docs" (agents and future-you do), "ADRs are overhead" (10 minutes now prevents a 2-hour re-debate later).

## 5. API Documentation & Reference Guides

**Per-endpoint template:** summary, parameters (name/type/required/description), responses (status codes), and a worked example.

**JSDoc/TSDoc:** describe what the function does; `@param`, `@returns`, `@throws`, `@example`. For TypeScript, prefer docs inline with types.

**Reference documentation** (reference-builder): document behavior, not implementation; every public interface; both happy path and error cases; runnable examples; consistent terminology; version everything; make search terms explicit.

Entry format: Type, Default, Required, Since, Deprecated, Description, Parameters, Returns, Throws, Examples, See Also.

**Structure:** Overview → Quick Reference (cheat sheet) → Detailed Reference (grouped) → Advanced Topics → Appendices (glossary, error codes, deprecations).

## 6. Changelogs

Use Keep a Changelog conventions:
```
# Changelog
## [Unreleased]
### Added
### Changed
### Fixed
## [1.2.0] - 2025-01-20
```
`wiki-changelog` skill generates changelogs from git history — group commits by type (added/changed/fixed/removed), keep one line per user-visible change, reference issue/PR numbers.

## 7. Wikis & Onboarding Guides

- **Wiki page writer:** each page stands alone with evidence-based depth — if you claim a behavior, cite the file/line that proves it. Include architecture and Mermaid diagrams for flows.
- **Onboarding guides:** two documents — (1) principal-level deep structure explanation, (2) zero-to-hero contributor guide with runnable first tasks. Detect the project's language and write in it.
- **Researcher/QA:** answer "how does X work" with depth, ground every claim in code evidence, iterate until coverage is complete.

## 8. Agent-Friendly Documentation (AI-readable)

- **llms.txt style:** one-line objective → core files → key concepts.
- **For RAG indexing:** clear H1-H3 hierarchy, JSON/YAML examples for data structures, Mermaid diagrams for flows, self-contained sections.
- **Rules files (CLAUDE.md etc.):** document project conventions so agents follow them; keep specs updated so agents build the right thing; ADRs prevent agents from re-deciding old decisions.
- **Red flags:** decisions without rationale, public APIs without docs/types, TODOs lingering for weeks, docs that restate code instead of intent.