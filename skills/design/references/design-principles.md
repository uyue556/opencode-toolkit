# Design Principles & Taste

How to make design decisions that hold up: research-backed UX/UI principles, antipatterns, quality gates that protect execution order, and micro-interaction polish.

## Contents

1. [The core taste model](#the-core-taste-model) — beating the generic AI look
2. [UX/UI principles evaluation](#uxui-principles-evaluation) — 168 principles + AI-era UX
3. [Antipatterns & UX smells](#antipatterns--ux-smells)
4. [Design orchestration & quality gates](#design-orchestration--quality-gates)
5. [Micro-interactions & "spells"](#micro-interactions--spells)

---

## The core taste model

The single most valuable judgment: **specific beats generic.** Every source skill converges on this. Before writing code, state:

- the screen's **job** and primary user,
- the **content hierarchy** (what is most important, in order),
- the **primary action**,
- the **required states** (loading, empty, error, success, permission),
- allowed **components and tokens** from the existing system,
- **forbidden generic patterns** (interchangeable card grids, filler metrics, decorative gradients, generic copy).

Then implement *product-specific* decisions, not decorations. Paste-in card grids with lorem metrics is the #1 smell.

### When you should stop and ask

If scope (platform/style), permissions, or success criteria are missing, ask — a well-scoped half-screen beats a guessed full app.

## UX/UI principles evaluation

Evaluate any interface against research-backed principles (source: uxuiprinciples, 168 principles). Run this as a checklist audit:

1. **Describe the interface** (screen/flow) without judgment, first.
2. **Check principles by category**: usability, hierarchy, legibility, consistency, feedback, affordance, error handling, decision quality.
3. **Return findings as**: principle violated → severity (critical/serious/moderate/minor) → remediation step.
4. **For AI-powered surfaces** (chat, autocomplete, generative output) apply 44 AI-era principles focused on: trust, transparency, safety, controllability, and explaining capability/limits.

### High-signal principles to always check

- One clear primary action per screen; hierarchy (visual weight) matches importance.
- Every clickable thing *looks* clickable (affordance); disabled states are visibly disabled.
- Feedback within ~1s for every action; visible success/error/loading states.
- Consistent navigation and identical components behave identically.
- Forms: inline validation, helpful error text, reversible/preventable destructive actions.
- No layout shift on load (CLS); no unexpected context change on focus.
- Errors recoverable; empty states teach; permissions requested in context.

## Antipatterns & UX smells

- **Card-grid filler** — cards with no real content or different purpose. Fix: only use a grid when each cell has distinct real content.
- **Metric soup** — meaningless numbers with no context. Fix: KPI = number + label + trend + time window.
- **Decorative state** — loading spinners that don't resolve into content; empty states that don't suggest next action.
- **Style drift** — inconsistent radii, colors, and spacing across a product. Fix: tokens + DESIGN.md.
- **Hidden affordance** — text that looks like text but is a button (or vice versa).
- **Motion for its own sake** — decorative animation that slows task completion; always allow reduced-motion.
- **Over-polarized palettes** — neon/purple gradients used by default; use the universal palettes instead.
- **Copying references wholesale** — extract the *pattern*, implement with the project's system and content.

## Design orchestration & quality gates

A meta-process (from `design-orchestration`) that keeps order: **ideas → reviewed designs → validated code.** Follow it whenever a design change carries meaningful risk.

1. **Brainstorming (mandatory if no validated design exists).** Produce: Understanding Lock (same problem, agreed), Initial Design, and a Decision Log. Don't skip to code.
2. **Risk classify** the design: low / moderate / high (consider user impact, irreversibility, cost, complexity, novelty).
3. **Escalate by risk:** low → implement; moderate → recommend multi-agent review; high → *require* multi-agent review.
4. **Review stage restricts scope:** no new ideation or problem re-opening; only critique, revision, and decision resolution.
5. **Execution readiness gate:** design approved + decision log complete + assumptions and known risks documented. Otherwise block implementation and route back.

This is a *routing* process — it decides which step runs next, not what the design looks like.

## Micro-interactions & "spells"

High-craft details that turn "functional" into "memorable" (from `design-spells`). Use for polish of finished features, not as the base.

### Where to look

The "boring" standard parts: submit buttons, profile photos, scroll indicators, pricing toggles, empty states, loaders, hover states, page transitions.

### Rules

- **Delight, don't distract** — the detail must be additive and feel expensive; never a usability barrier.
- **Quality floor** — a janky spell is worse than none: 60fps+, GPU-accelerated (`transform`/`opacity`), zero layout shift.
- **Context-matched** — adapt the pattern to the brand; it must serve the product's narrative.
- Kill local favorites: magnetic hover, physics-based springs, reveal-on-scroll typing. Prefer CSS/`Anime.js`/`Framer Motion`; disable under `prefers-reduced-motion`.

### Anti-generic mandates

Both `vizcom` and `design-spells` and `antigravity` share one instruction: **do not build the common/default style**. If a component would look identical in any template gallery, it needs either a named style, a real content decision, or a crafted detail.

## Notes

- These principles come from 168-principle UX research, WCAG-based review methodology, and quality-gate orchestration — treat them as a reusable review checklist, not cargo-cult rules.
- Pair with `references/ui-ux.md` for the review *process* and `references/accessibility.md` for the compliance side.