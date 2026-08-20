---
name: design
description: "Consolidated design skill for producing high-quality, opinionated interfaces: picking a specific aesthetic (minimalist, brutalist, glassmorphism, bento, cyberpunk, etc.), building color/typography/layout systems, UX review, design systems, motion/3D, and accessibility. Use whenever the user asks to design/build/review a UI or website (UI设计, 前端界面, 视觉设计, 页面, 交互, 风格, 配色, 排版, 登录页, landing page, dashboard), wants a specific visual style (极简, 玻璃拟态, 赛博朋克, 新拟态, 复古, Bento), needs WCAG/accessibility fixes (无障碍, 可访问性), wants UI review or design tokens, or needs to apply a consistent theme (主题, 配色方案)."
---

# Design

A single entry point for all design work: choosing and executing a specific aesthetic, composing color/typography/layout, validating UI, building design systems, adding motion/3D, and guaranteeing accessibility.

## When to use

- User wants to **build a UI** (web or app screen, landing page, dashboard, component) and expects it to look considered, not generic.
- User names a **style or mood** — 极简/minimal, 玻璃拟态/glass, 赛博朋克/cyberpunk, 新拟态/neumorphism, 复古/retro, Bento, brutal, premium, dark, etc.
- User asks to **review or fix** a design: 难看/ugly, feels generic ("AI slop"), 配色/colors wrong, 排版/typography, 无障碍/accessibility, WCAG, contrast.
- User wants a **design system**: design tokens, DESIGN.md, Figma component library, theme.
- User wants **motion/3D** polish: 动效/animation, 3D, scroll effects, glassmorphism depth.
- User is doing AI-assisted UI generation (Stitch, etc.) and wants effective prompts or a source-of-truth design doc.

## Core workflow

1. **Clarify the ask.** Screen type (web/app/component), platform (desktop/mobile/responsive), primary user job, and any hard constraints. If a design system exists, use it — do not invent tokens.
2. **Pick an aesthetic.** Map the request to one specific style via `references/style-router.md`. Do not blend styles unless asked. If the user gives no style, choose one that fits the product context.
3. **Choose colors.** If the user specified colors, use exactly those. Otherwise pick one palette from `references/color-typography-layout.md` (10 universal palettes + theme-factory themes) and expose them as CSS variables / theme tokens. Apply the 60-30-10 rule.
4. **Compose type + layout.** Establish hierarchy with the typography and layout systems in `references/color-typography-layout.md` (grid, spacing scale, type scale) before adding decoration.
5. **Implement.** Write code per the style's principles. For depth/motion, follow `references/motion-depth.md`; for platform adaptation see the cross-platform notes in `references/style-router.md`.
6. **Validate.** Review against `references/ui-ux.md` (visual + UX gates) and `references/accessibility.md` (contrast, keyboard, screen reader). Fix, don't defer.
7. **Document the system.** For multi-screen work, capture decisions in a DESIGN.md (`references/design-systems.md`) so new screens stay consistent.

## Selection routing

| Task | Reference |
|------|-----------|
| "Which style fits this request?" + all 48 aesthetics, keyword→style mapping, per-platform notes | `references/style-router.md` |
| Color palettes (10 universal + 10 theme-factory), 60-30-10, typography systems, layout systems (grid/bento/cards/dashboard/data-dense) | `references/color-typography-layout.md` |
| Design taste, UX/UI principles, antipatterns, micro-interactions/"spells", brainstorm→review→execute orchestration | `references/design-principles.md` |
| 3D web (Three.js/R3F/Spline/GLB pipeline), motion rules, GSAP, depth effects, reduced-motion | `references/motion-depth.md` |
| Visual validation, UI research (UIZZE), web interface guidelines, review gates | `references/ui-ux.md` |
| Design tokens, DESIGN.md, Rayden in Figma, token extraction | `references/design-systems.md` |
| WCAG 2.2 audit, contrast, keyboard, screen reader, remediation, CI | `references/accessibility.md` |
| AI UI tools (Stitch prompting, Vizcom) and design-tool automation (Figma/Canva/Webflow via Rube MCP) | `references/tools-automation.md` |

## Best practices

- **Specific beats generic.** A precise brief ("member dashboard, progress bar, purple card grid") produces a designed result; "make a nice website" produces slop. State screen job, content hierarchy, primary action, required states (loading/empty/error/success).
- **Design systems first.** Colors, radii, shadows, and type must come from tokens, not ad-hoc values. Name tokens semantically (surface, elevated, primary-text, cta).
- **Typography is hierarchy.** Prefer weight/size/leading over color to establish order; use a type scale, not random sizes.
- **Whitespace is a tool.** Generous margins are the cheapest premium cue. When in doubt, double the padding.
- **Shadows carry meaning.** Soft+large = floating; hard+offset = playful (neo-brutalism); dual (light/dark) = neumorphic; none = flat. Never use a random shadow.
- **Motion should explain.** Animate transitions between states, not everything. Stagger entrances ~0.1s; keep state changes ≥0.3s ease-out; honor `prefers-reduced-motion`.
- **Respect the platform.** Web uses CSS variables/grid/transitions; native apps map palettes to the theme engine (elevation/shadows, platform animations).
- **Always accessibility-check before shipping.** Contrast, focus indicators, keyboard order, labels — these are design quality, not a checklist afterthought.

## Do & Don't

- DO use one of the 10 universal palettes verbatim (exact hexes) when the user gives no colors — they avoid the generic neon-purple gradient look.
- DO name styles explicitly and commit to one ("this is glassmorphism over a photo background").
- DO add a fallback (static image, loading indicator) for any 3D/WebGL content.
- DO copy only the *pattern* from reference products — never their brand, copy, or exact layout.
- DON'T blend five aesthetics because each sounds nice; pick one and execute it well.
- DON'T use pure black `#000` for dark-mode backgrounds (use `#121212`-class greys).
- DON'T center Swiss-style text, use drop shadows in flat design, or add borders in minimalism — styles have rules; follow the chosen one's.
- DON'T ship a state you didn't validate (loading/empty/error), and never claim a visual check you didn't run.
- DON'T animate `box-shadow`/`filter` continuously; prefer `transform`+`opacity` and `will-change`.

## Common pitfalls

- **Generic AI look**: solved by a named style + fixed palette + real content (not "lorem" filler metrics).
- **Style drift across screens**: fix by writing a DESIGN.md and reusing tokens.
- **Contrast failures in styled color**: check every text/background pairing, especially tinted shadows and pastel-on-white.
- **Motion sickness**: default to subtle, and disable motion under `prefers-reduced-motion`.
- **3D that hurts**: compress GLB (<5MB), limit triangles (<100K mobile), cap DPR on mobile, provide a WebGL fallback.
- **Automation assumptions**: every MCP tool schema changes — always call the tool-discovery/search endpoint before calling the tool.

## Example: taking a vague request to a finished screen

1. User: "做一个科技感的产品落地页" → ask platform + pick style: **cyberpunk-ui** (or glassmorphism if they meant "modern tech").
2. Palette: **Midnight Luxury** (dark) from the universal palettes → CSS variables.
3. Type: squared tech sans (`Rajdhani`) for headings, monospace for data accents; 12-col grid.
4. Build with clip-path chamfers, neon glows on dark, one data stream.
5. Check: WCAG contrast for the neon-on-black text (bump opacity), focus-visible rings, `prefers-reduced-motion` off for glitch.
6. Record tokens + screen rules in DESIGN.md.

## Limitations

- This skill routes and teaches; it does not replace human design judgment, user research, legal/compliance review, or real-device testing.
- Referenced automation tools (Figma/Canva/Webflow) require their MCP connections and current tool schemas; see `references/tools-automation.md`.
- Stop and ask for clarification when scope, platform, style, or success criteria are unclear.
