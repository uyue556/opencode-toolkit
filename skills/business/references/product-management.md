# Product Management & Validation

Product thinking end-to-end: idea validation, discovery, prioritization, PRDs, product marketing context, and Chinese-language product decision-making. Sources: `idea-autopsy`, `before-you-build`, `idea-os`, `product-manager`, `product-manager-toolkit`, `product-decision-agent`, `product-marketing`, `product-marketing-context`.

## Idea Validation (before building)

### Idea Autopsy (ruthless kill-list)

Turn the agent into a business-idea pathologist: hunt for the one sentence that kills an idea before money is spent. Every autopsy ends in a hard verdict.

**Step 1 — Kill-list check.** If a `REJECTION.md` kill-list exists, a NICHE match = DEAD (cite the row, stop). A KILL-PATTERN match = strong prior, not a verdict — run the specific check to confirm. Schema:

```markdown
# REJECTION.md — my kill-list
## Killed ideas
| # | Idea/Niche | Killed (date) | Hard reason | Pattern |
## Survivors under test
| Idea | Passed filters (date) | Pending test | Deadline |
```

**Step 2 — The five filters (one hard NO = dead):**
1. **Real pain?** A 2am problem, or a nice-to-have vitamin?
2. **Buyer has money?** Right now — not after the product helps them.
3. **Proven demand?** Can the user name one live competitor ad?
4. **Legal to charge for?** Regulated/licensed/illegal in target market — name the law if suspicious.
5. **A moat?** What stops the 50th copycat next month?

**Step 3 — Free-AI test.** If one prompt to a frontier model produces the whole deliverable free, verdict = DEAD (`free-AI`): "If AI ships your whole deliverable in one prompt, you don't have a product — you have a prompt."

**Step 4 — Live-market verification (own eyes).** Walk the user through the Meta Ad Library: number of ACTIVE advertisers, age of oldest running ad (90+ days = someone is paying because it works). Three traps: zero ads (`wrong-channel`), a few giants (`incumbent-owned`), hundreds of ads (`crowded` commodity knife-fight — demand ≠ room for you).

**Step 5 — Verdict format:**
```
VERDICT: DEAD | SURVIVED
KILL-PATTERN: <name>
THE ONE SENTENCE: <single finding that decided it>
EVIDENCE: <2-4 hard facts with sources>
NEXT: <if survived: the ONE cheapest test that could still kill it>
```

Append to `REJECTION.md` only with consent; the kill-list is the compounding asset. Demand a number, law, live ad, or quote for every claim. Never soften a verdict.

### Before-You-Build (risk review before coding)

Pause before implementation to check product risk, not code structure:
1. **Identify the build bet** — restate product/feature in one concrete sentence: user, job, current workaround/competitor.
2. **Check main risks** — demand, workflow fit, willingness to switch, distribution, pricing, data access, operational burden. Prefer specific doubts over generic brainstorming.
3. **Decide the next small test** — buyer conversation, landing page, manual concierge, prototype, waitlist, paid pilot, narrow internal trial.
4. **Continue or stop** — if evidence is weak, run a smaller experiment instead of building the full version.

Best practices: ask for user/job/alternative/switching reason before implementation; separate product risk from engineering risk; never fabricate market size, revenue, or quotes.

### Idea-OS (raw idea → build-ready plan)

Five-phase sequential pipeline that produces four linked files:

1. **Triage** — classify on two axes: idea tier (T1 weekend utility / T2 SaaS MVP or AI wrapper / T3 marketplace-B2B or regulated) × builder sophistication (S1 non-technical / S2 hobbyist / S3 founder-senior PM). State the classification in one line before proceeding.
2. **Clarify** — write `questions.md` (4–18 questions, scaling with complexity), grouped: Who & Pain · Scope & Wedge · Constraints & Goals. Every question must change what you build — generic questions rejected. **Stop and wait for answers.**
3. **Research** — `research.md` with minimum 5 web searches, 2 web fetches on named competitors, 1 source per TAM number, date on every source; unsourced items flagged `[assumption]`. Required: problem validation, JTBD, market (TAM/SAM/SOM top-down + bottom-up), competitors + positioning map, SWOT, distribution (first-100-users channel fit), risks, 3–7 non-obvious insights.
4. **PRD** — falsifiable problem statement, named personas, ranked JTBD, **non-goals (mandatory)** — it's where bad PRDs die — leading and lagging metrics.
5. **Plan** — user journey (text + mermaid), platform recommendation tied to research, conservative/modern/cutting-edge stack matrix, phased build (MVP → v1 → target) with **kill criteria per phase**, first-100-users distribution per phase, metrics per phase, 3–5 immediate next actions.

## Product Management Toolkit

### Prioritization frameworks

**RICE** — `Score = (Reach × Impact × Confidence) / Effort`.
- Reach: users/quarter. Impact: massive=3x, high=2x, medium=1x, low=0.5x, minimal=0.25x.
- Confidence: high=100%, medium=80%, low=50%. Effort: person-months.

**Value vs. Effort matrix:** high-value/low-effort = QUICK WINS (prioritize); high/high = BIG BETS (strategic); low/low = FILL-INS (maybe); low/high = TIME SINKS (avoid).

**MoSCoW:** Must / Should / Could / Won't.

**Prioritization best practices:** mix quick wins with strategic bets; consider opportunity cost; account for dependencies; buffer 20% for unexpected work; revisit quarterly; communicate decisions clearly.

### Customer discovery

- **Interview guide** (35 min): context (5 min, role/workflow/tools) → problem exploration (15 min, pain/frequency/impact/workarounds) → solution validation (10 min, concept reaction/value perception/WTP) → wrap-up (5 min, referrals).
- **Tips:** ask "why" 5 times; focus on past behavior, not future intentions; avoid leading questions; interview in their environment; look for emotional reactions; validate with data.
- **Hypothesis template:** "We believe that [building this] for [users] will [outcome]. We'll know we're right when [metric]."
- **Opportunity Solution Tree:** outcome → opportunities → solutions.

### PRD development

- **Choose template by scope**: Standard PRD (complex features, 6–8 wks), One-Page PRD (simple, 2–4 wks), Feature Brief (exploration, 1 wk), Agile Epic (sprint-based).
- **Structure**: Problem → Solution → Success Metrics; always include out-of-scope; clear acceptance criteria.
- **Best practices**: start with the problem not the solution; include success metrics upfront; state what's out of scope; use visuals; keep technical details in appendix; version-control changes.

**Standard PRD sections:** exec summary → problem definition (customer problem, market opportunity, business case) → solution overview (in/out of scope, MVP definition) → user stories & requirements (functional/non-functional) → design & UX → technical specs → GTM strategy → risks & mitigations → timeline & milestones → team & resources → appendix.

### North Star Metric

Identify the #1 value to users, make it measurable, ensure it's actionable, check it predicts business success. Feature success metrics: adoption, frequency, depth, retention, satisfaction.

### Common PM pitfalls

Solution-first thinking, analysis paralysis, feature factory (shipping without measuring), ignoring technical debt, stakeholder surprise, metric theater (vanity metrics).

## Product Marketing Context

Create/maintain a reusable context document (`.agents/product-marketing.md`) capturing positioning, ICP, and messaging — the foundation every marketing skill references.

**Workflow:** check for existing context → if none, offer auto-draft from codebase (README, landing pages, copy, package.json — faster, recommended) or start from scratch → gather section by section → confirm and save.

**Sections (12):** 1. Product overview (one-liner, category, type, business model) · 2. Target audience (company type, decision-makers, primary use case, JTBD) · 3. Personas B2B (user/champion/decision maker/financial buyer/technical influencer) · 4. Problems & pain points (core challenge, why alternatives fall short, cost, emotional tension) · 5. Competitive landscape (direct/secondary/indirect + how each falls short) · 6. Differentiation (capabilities alternatives lack, why better, why customers choose you) · 7. Objections & anti-personas (top 3 objections, who is NOT a good fit) · 8. Switching dynamics (JTBD Four Forces: Push, Pull, Habit, Anxiety) · 9. Customer language (verbatim phrasing, words to use/avoid, glossary) · 10. Brand voice (tone, style, personality) · 11. Proof points (metrics, logos, testimonials, value themes) · 12. Goals (business goal, conversion action, current metrics).

**Key tip:** push for verbatim customer language — exact phrases are more valuable than polished descriptions.

## Product Decision Agent (中文)

默认中文，用于需求优先级、Roadmap、增长、留存、转化、运营、数据异常、A/B Test、项目延期和跨团队协作。像一个能拍板的产品负责人：判断、取舍、推进，不讲概念或理论史。

**后台推理（不暴露）**: 目标、问题类型、事实vs假设、核心阻塞、主导机制（不把相关性当因果）、阶段、关键约束、相关方、证据质量、变化条件、行动模式、停止清单。

**输出结构：** 1) 问题判断（一句话指出真正问题）· 2) 原因分析（2–4条）· 3) 行动建议（1–3个动作，含时间窗口、负责人、指标、后续决策规则）· 4) 风险提醒（现在不要做什么）· 5) 需要确认（最多3个，只在会改变判断时）。

**禁止事项：** 不讲历史/引用原文；不输出"提升用户体验、加强沟通、多看数据"这类空话（除非跟具体动作、指标、时间窗口）；不平均罗列方案，必须指出主攻方向；事实不足时给最小验证动作而非硬装确定；不引用方法来源除非用户要求。

**质量标准：** 用户应立刻知道真正卡住结果的是什么、现在优先做哪一件事、哪些事暂时不要做、用什么事实/指标判断下一步是否有效。
