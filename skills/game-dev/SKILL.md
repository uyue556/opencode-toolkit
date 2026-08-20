---
name: game-dev
description: >-
  Comprehensive game development skill covering the full lifecycle: engine
  selection (Unity, Godot, Unreal, Phaser, PixiJS, Kaplay, Babylon.js, Three.js),
  2D/3D/web/mobile/PC/console/VR-AR development, game design (GDD, core loop,
  balancing, player psychology), art & audio pipelines, multiplayer networking,
  Unity ECS/DOTS + Jobs + Burst, Godot 4 GDScript patterns + 3.x->4 migration,
  Minecraft Bukkit/Spigot/Paper plugins, and idea->build AI-assisted workflows.
  Use whenever the user mentions: build a game, make a game, game idea, game
  design, game loop, game engine, engine selection, 游戏开发, 做游戏, 游戏设计,
  游戏引擎, 游戏制作, Unity, Godot, 虚幻引擎, Unreal, Phaser, PixiJS, shaders,
  着色器, 渲染管线, multiplayer, 联机, 多人游戏, game art, 游戏美术, game audio,
  游戏音效, 游戏音乐, ECS, DOTS, GDScript, Minecraft 插件, bukkit, or asks to
  prototype/port/deploy a game.
risk: none
---

# Game Development (game-dev)

> One skill for the whole game-dev lifecycle: pick the right engine, build the
> core loop, and ship for web / mobile / PC / console / VR. Engine-specific depth
> lives in `references/`. If the user writes in Chinese, respond in Chinese.

## When to use this skill

- Starting or structuring any game project, or choosing among engines/frameworks.
- Building game systems: loops, state, input, physics, AI, art, audio, multiplayer.
- Targeting a specific platform: web (HTML5/WebGL/WebGPU), mobile, PC/console, VR/AR.
- Working inside Unity (incl. DOTS/ECS), Godot 4 (GDScript), or Minecraft plugins.
- Taking a raw idea through GDD -> blueprint -> prototype -> deploy.

## Core workflow

1. **Clarify the fit** — platform, genre, primary loop, art scope, team size, budget.
2. **Select the engine** — open `references/engine-selection.md`.
3. **Design first** — nail the core loop + write a GDD (`references/game-design.md`).
4. **Build per dimension & platform** — `references/2d-games.md` / `3d-games.md` plus the matching platform file.
5. **Follow the engine guide** — `references/unity.md`, `references/godot.md`, or `references/minecraft-bukkit.md`.
6. **Profile on real hardware, test, deploy** — never ship unmeasured.

## Selection routing

| Need | Open |
|------|------|
| Engine/framework choice (web & native) | `references/engine-selection.md` |
| Web/HTML5/WebGL/WebGPU, hybrid DOM+canvas | `references/platform-web.md` |
| Mobile (iOS/Android) | `references/platform-mobile.md` |
| PC & console (Steam, cert, controllers) | `references/platform-pc-console.md` |
| VR/AR comfort & performance | `references/platform-vr-ar.md` |
| Core loop, GDD, balancing, psychology | `references/game-design.md` |
| 2D sprites / tilemaps / cameras / genres | `references/2d-games.md` |
| 3D rendering / shaders / lighting / LOD | `references/3d-games.md` |
| Multiplayer & networking | `references/multiplayer-networking.md` |
| Art style, asset pipelines, animation | `references/game-art.md` |
| Sound design, music, adaptive audio | `references/game-audio.md` |
| Unity 6 / URP / C# / optimization | `references/unity.md` |
| Unity DOTS / ECS / Jobs / Burst | `references/unity-ecs.md` |
| Unity ECS deep playbook (patterns, jobs, code) | `references/unity-ecs-playbook.md` |
| Idea -> Unity project pipeline (AI assets) | `references/unity-ai-pipeline.md` |
| Godot 4 GDScript patterns + 3->4 migration | `references/godot.md` |
| Godot deep playbook (scenes, signals, code) | `references/godot-gdscript-playbook.md` |
| Minecraft Bukkit/Spigot/Paper plugins | `references/minecraft-bukkit.md` |

## Core principles (all platforms)

### 1. The game loop

```
INPUT  -> Read player actions
UPDATE -> Process game logic (fixed timestep)
RENDER -> Draw the frame (interpolated)
```

- Physics/logic run at a fixed rate (e.g. 50 Hz); rendering as fast as possible.
- Interpolate between states for smooth visuals.
- Hybrid / UI-heavy web games: keep the outer app DOM/event-driven; run a classic
  loop only inside canvas/WebGL viewports (wherever simulation ticks).

### 2. Pattern selection matrix

| Pattern | Use when | Example |
|---------|----------|---------|
| State Machine | 3-5 discrete states | Player Idle->Walk->Jump |
| Object Pooling | Frequent spawn/destroy | Bullets, particles |
| Observer/Events | Cross-system communication | Health -> UI updates |
| ECS | Thousands of similar entities | RTS units, particles |
| Command | Undo, replay, networking | Input recording |
| Behavior Tree | Complex AI decisions | Enemy AI |
| Content-as-data | Designers ship levels/events without code | JSON/YAML packs |

**Decision rule:** start with a State Machine; add ECS only when performance demands it.

### 3. Input abstraction

Abstract input into ACTIONS, not raw keys:

```
"jump" -> Space, Gamepad A, Touch tap
"move" -> WASD, Left stick, Virtual joystick
```

### 4. Performance budget (60 FPS = 16.67ms)

| System | Budget |
|--------|--------|
| Input | 1ms |
| Physics | 3ms |
| AI | 2ms |
| Game logic | 4ms |
| Rendering | 5ms |
| Buffer | 1.67ms |

**Optimization priority:** Algorithm -> Batching -> Pooling -> LOD -> Culling. Profile first, always.

### 5. AI selection by complexity

| AI type | Complexity | Use when |
|---------|------------|----------|
| FSM | Simple | 3-5 states, predictable behavior |
| Behavior Tree | Medium | Modular, designer-friendly |
| GOAP | High | Emergent, planning-based |
| Utility AI | High | Scoring-based decisions |

### 6. Collision strategy

| Type | Best for |
|------|----------|
| AABB | Rectangles, fast checks |
| Circle | Round objects, cheap |
| Spatial hash | Many similar-sized objects |
| Quadtree | Large worlds, varying sizes |

### 7. Universal anti-patterns

| Don't | Do |
|-------|-----|
| Update everything every frame | Use events, dirty flags |
| Create objects in hot loops | Object pooling |
| Cache nothing | Cache references |
| Optimize without profiling | Profile first |
| Mix input with logic | Abstract input layer |
| Pick an engine by hype | Match engine to genre + team + delivery target |
| Polish before fun | Prototype fast, then polish |

## Best practices

- **Start with the 30-second core loop** — Action -> Feedback -> Reward -> Repeat. Nail it before anything else.
- **Write the GDD even for solo projects** — a living one-page doc beats tribal knowledge.
- **Use ScriptableObjects / Resources for data** — decouple data from logic.
- **Profile against platform budgets weekly**, on real devices, not emulators.
- **Never trust the client in multiplayer** — the server is the source of truth.
- **Version control from day one** (Git + LFS for large assets); commit often.
- **Generate 3-5 AI asset variations and review licensing** before shipping commercial work.

## Common pitfalls

- **Vague brief ("make a game")** — ask 2-3 targeted questions (genre, platform, scope) before drafting.
- **Scope creep** — use the scope calibration table and a Must/Should/Could/Won't priority matrix.
- **AI assets that clash with art style** — repeat the GDD's art-direction keywords in every asset prompt.
- **Engine picked by hype** — fit the engine to the delivery target, interaction model, and team.
- **Client-authoritative netcode** — validate on the server: did the projectile hit, was timing possible?

## Examples

- "Browser 2D platformer" -> engine-selection -> platform-web -> 2d-games -> game-design
- "Mobile puzzle" -> platform-mobile -> game-design
- "Multiplayer VR shooter" -> platform-vr-ar -> 3d-games -> multiplayer-networking
- "I want a cozy farming game with magic for mobile" -> unity-ai-pipeline (full brief-to-build roadmap)
- "Port my Godot 3 project" -> godot (GDScript 2.0 migration guide)

> Great games come from iteration, not perfection. Prototype fast, then polish.

## Limitations

- This skill is guidance, not a substitute for environment-specific validation, testing, or expert review.
- AI tools and their capabilities evolve rapidly — verify current availability and pricing before recommending.
- Performance budgets are guidelines — always profile on actual target hardware.
- Stop and ask for clarification if required inputs, permissions, safety boundaries, or success criteria are missing.
