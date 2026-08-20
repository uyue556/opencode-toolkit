# Consulting Frameworks & Organization Diagnostics

Structured brainstorming for web projects and Chinese-language organizational diagnosis/repair. Sources: `web-project-brainstorming` (consulting), `crossframe-org` (business).

## Web Project Brainstorming (Consulting Framework)

A structured, masterclass-level framework for brainstorming web projects, web apps, or page redesigns at inception. Walk the user through **six phases sequentially, one at a time** — never dump all phases in one response.

### Phase 1 — Core Concept & Scoping
Target audience, core value (what problem does it solve), top 3–5 mandatory features.

### Phase 2 — UX & Information Architecture
Page hierarchy/sitemap, user journeys (step-by-step flows to complete key goals), responsive approach (mobile-first, desktop-first, or balanced).

### Phase 3 — Visual Styling & Design System
Design aesthetic (modern, minimalist, glassmorphism, luxury), color palette (prefer tailorable HSL/RGB models over static keywords), typography (Inter, Outfit, Syne), interactive states (hovers, clicks, transitions, loading).

### Phase 4 — Technical Stack & Architecture
Frontend framework (React/Next.js/Vite/Astro/Svelte/vanilla), styling (vanilla/Tailwind/CSS modules), data & backend (REST/GraphQL/tRPC/Firebase/Supabase/SQLite), state management (Zustand/Context/Redux/local).

### Phase 5 — SEO, Accessibility, Performance
Title/meta structure, semantic HTML hierarchy (one `<h1>` per page), ARIA/keyboard/contrast, preloading, lazy loading, SSR, CDN.

### Phase 6 — MVP Scope & Project Phases
Phase 1 = absolute minimum viable deployable; Phase 2 = enhancements. **Enforce this strictly to prevent scope creep.**

**Best practices:**
- Ask questions incrementally, one phase at a time.
- Propose logical defaults when the user is unsure.
- Document explicit non-goals to prevent feature creep.
- Flag security requirements early (SSL, CORS, secure auth storage, env-var protection); never store credentials in blueprint docs.

**Output:** a Project Blueprint document with sections for concept, IA/UX, styling (with HSL color tokens), technical architecture, SEO/performance, and MVP vs Phase 2 roadmap.

## Organization Diagnostics (CrossFrame Org — 中文)

组织修复专项：用于团队、项目、组织、责任链、授权链、反馈写回、复盘失真、修复。中文为权威语义。**本 skill 不独立触发**——由 `crossframe-suite` 路由。默认中文回答。

### 使用场景
- 项目失败、团队反复卡住、需求漂移、跨部门断裂。
- 反馈没有进入下一轮结构改变、复盘越做越假。
- 需要组织诊断备忘录、反馈写回方案、复盘改造建议、低风险试点计划。

### 内部组织 intake（每次输出前先在内部写清）
- **组织对象**：团队/项目/流程/会议/角色/跨部门接口/治理层。
- **事实边界**：用户给出的事实 vs 推测 vs 证据缺口。
- **失败现象**：延期、返工、沉默、复盘失真、需求漂移、加速后更乱。
- **责任链**：谁对结果负责，谁能改变条件，谁承担失败成本。
- **授权链**：谁有权限改规则、资源、优先级、时间表、接口和停止条件。
- **反馈链**：信号从哪来、经过谁转译、写回到什么规则/资源/角色/时间表。
- **中层承接负荷**：中层是否在替组织吸收冲突、解释、补锅、翻译和情绪成本。
- **机制候选**：至少两个互相竞争的解释，不能直接压成"执行力差"。
- **停止条件**：哪些动作一旦负反馈就必须暂停、降档或撤回。
- **低风险试点**：最小、可观察、可撤回、能写回结构的小动作。

### 硬规则
- **不准写管理鸡汤**："加强沟通、提升主人翁意识、统一思想、提高执行力"这类无结构变量建议禁用。
- **不准把问题压给执行层**：涉及基层/执行/个人努力的判断，必须同时检查授权链、资源链、时间链和反馈写回。
- **不准只有复盘没有写回**：每个建议都要说明写回到什么规则、资源、角色、接口或时间表。
- **不准只有加速没有停止条件**：冲刺、加会、升级管理都必须有暂停、降档、撤回或保护边界。
- **不准把中层耗竭解释成能力不足**：先检查组织是否把翻译、缓冲、补锅和冲突成本长期压给中层。
- **不准把复盘报告/OKR 更新/合规记录/道歉声明/会议纪要当成修复本身**；它们最多是修复副产品。
- **不准用组织诊断替代劳动法、合规、心理健康、医疗、安全或正式申诉处置。**
- **不准为了显得积极而扩大范围**：先找最小可逆试点。

### 输出结构
默认先给短的**组织推理提纲**，再输出用户需要的备忘录/方案。输出必须落到现实组织变量：角色、权限、资源、时间、接口、节奏、证据、停止条件。第一段用普通组织语言说明：发生了什么、为什么重复、下一步先改什么。术语只做后台映射，不能用"这是典型的 X"替代诊断。

### 路由（组织专项）
- 项目失败/延期/反复返工 → 组织诊断备忘录。
- 复盘失真 → 复盘改造建议。
- 基层反馈没人听、问题无法写回 → 反馈写回方案。
- 中层疲惫/夹在中间/长期补锅 → 组织诊断备忘录（先查结构负荷）。
- 想要改造/试点/行动计划 → 低风险试点计划 + 停止条件卡。
- 情绪很急、组织正在加速 → 先输出停止条件卡，再给低风险试点。
