# Unity AI Game Creator — Idea-to-Build Pipeline

> A workflow-driven guide: transform a raw game concept into a complete Unity
> development plan with AI-generated assets, scene blueprints, music/SFX prompts,
> scripts, and deployment-ready builds. Unlike generic Unity reference, this is a
> pipeline: the user gives an idea, the agent delivers an actionable roadmap.

## Master pipeline

```
PHASE 1: IDEATION -> PHASE 2: BLUEPRINT -> PHASE 3: GENERATION -> PHASE 4: ASSEMBLY -> PHASE 5: DEPLOYMENT
  Game Brief         GDD + Scenes        AI Prompts + Assets    Project Setup          Build + Store
  Genre Analysis     Architecture        Scripts + Audio        Core Systems           QA + Submit
  Scope Assessment   Scene Blueprints    Voice + UI             Polish + Juice         Analytics
```

## Phase 1: Ideation & deep analysis

Extract dimensions; ask only for what is ambiguous:

| Dimension | What to extract | If unclear |
|-----------|-----------------|------------|
| Genre | Primary + secondary blend | Suggest 3 combinations |
| Platform | Mobile, PC, Console, WebGL, VR/AR | Recommend by scope |
| Perspective | 2D, 2.5D, 3D, top-down, side-scroll, FPS, TPS | Infer from genre |
| Art style | Realistic, stylized, pixel, low-poly, anime | Suggest 3 options |
| Core loop | The 30-second repeating action | Identify from description |
| Target audience | Age range, gamer profile | Recommend by genre |
| Session length | Average play session | Infer from platform + genre |
| Monetization | F2P, premium, hybrid | Recommend by platform |
| Scope | Solo, small team, studio | Ask if not obvious |
| Timeline | MVP weeks, full release | Suggest milestones |

Also provide: **top 3 reference games** (what they do well), **market gap**, **core differentiator**, **risk assessment** (technical + market, with mitigations).

**Scope calibration:**

| Scope | Timeline | Team | Feature budget |
|-------|----------|------|----------------|
| Prototype | 1-2 weeks | Solo | Core loop only |
| Vertical slice | 4-6 weeks | Solo-2 | 1 complete level + polish |
| MVP | 8-12 weeks | 2-4 | 3-5 levels + save + UI |
| Full release | 16-24+ weeks | 3-8 | Complete content + multiplayer |

## Phase 2: Blueprint & design

**GDD** (see `game-design.md` for design depth): executive summary, gameplay, world & narrative, art direction (hex palette), audio direction, technical spec (Unity version, render pipeline, budgets, SDKs), monetization strategy, development roadmap with Must/Should/Could/Won't priority matrix.

**Scene blueprint** per scene: environment (ground, skybox, lighting, props with positions), interactive objects, characters/NPC AI + patrol paths, UI overlay (HUD, prompts), audio layers (BGM mood/tempo/loop, ambient SFX, triggers), camera setup (Cinemachine/fixed/follow), systems active (save checkpoints, spawners, particles).

**Recommended project structure:**

```
Assets/_Project/
├── Scripts/ (Core, Gameplay, UI, Data, Audio, Utilities)
├── Prefabs/ (Characters, Environment, UI, VFX)
├── Scenes/
├── Art/ (Models, Textures, Materials, Animations, UI_Assets)
├── Audio/ (Music, SFX, Ambience)
├── ScriptableObjects/
└── Resources/
```

## Phase 3: AI-powered asset generation

For each asset category, provide ready-to-use prompts for current AI tools (tools evolve — verify availability):

| Asset | Tools | Prompt must include |
|-------|-------|---------------------|
| 3D models | Meshy.ai, Tripo3D, Rodin | Name, art style, purpose, poly budget, texture res, PBR maps, animation-ready, Unity import settings (scale, normals, material) |
| Textures/2D | Leonardo.ai, Midjourney, DALL·E | Type (seamless tile / sprite / UI / concept), res, tiling, PBR maps, Unity import (type, filter, compression) |
| Music | Suno, Soundraw, Sonauto | Track name, scene context, mood, BPM, duration, instruments, loop points, dynamic layers |
| SFX | ElevenLabs, OptimizerAI/SFX Engine | Name, category, context, duration, variation count, 3D config |
| Voice | ElevenLabs, Play.ht, Coqui | Character, voice profile, line, emotion, context |
| UI/UX | UI Toolkit or image gen | Element name, screen context, style, states (normal/hover/pressed/disabled), dimensions, anchors |

## Phase 4: Assembly & development

**Project initialization:** Unity 6 LTS; pipeline per target (URP mobile/stylized, HDRP high-fidelity, Built-in 2D); build/player settings (color space, scripting backend); essential packages (Input System, Cinemachine, TextMeshPro, Addressables); Git LFS.

**Development order:** Foundation (GameManager, event system, scene mgmt, input) -> Core gameplay (player controller, camera, core loop) -> Content & systems (levels, UI, audio manager, save/load) -> Polish (VFX/juice, progression, tutorial, settings) -> Platform & release (profiling, monetization, analytics, submission).

**Script architecture:** GameManager singleton or service locator; observer events (C# events + ScriptableObject Events); JSON save + encryption; generic object pool; state machines; audio singleton with mixer groups; UI Toolkit with MVVM/event binding; Addressables async scene loading; Input System Action Maps.

## Phase 5: Quality & deployment

**Performance budgets:** see the table in `unity.md`.

**Testing checklist:** core loop stability, UI responsiveness, save/load persistence, audio balance, memory leaks, frame-rate stability, input device coverage, edge cases (low battery, interruptions), accessibility, localization.

**Store submission:** app icon, feature graphic, screenshots, promo video, descriptions, keywords, privacy policy, age/content ratings — with AI prompts for marketing assets.

## Pitfalls

- **Vague idea** ("make a game") — ask 2-3 targeted questions first.
- **Scope creep** — use scope calibration + priority matrix.
- **AI assets don't match style** — repeat the GDD's art-direction keywords in every prompt.
- **Performance** — set platform budgets early; profile weekly.

## Do & Don't

- ✅ Start with the core loop; profile before optimizing; ScriptableObjects for data; 3-5 AI variations; test on real devices; version control from day one.
- ❌ Don't hardcode tool choices (present alternatives); don't skip the GDD; don't optimize prematurely; don't ship AI assets without licensing review.
