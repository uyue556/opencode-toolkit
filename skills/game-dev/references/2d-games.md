# 2D Game Development

> Principles for 2D game systems (sprites, atlases, tilemaps, physics, cameras, genre patterns).
> Pair with `engine-selection.md` for framework choice.

## Shell vs guest (web)

| Setup | 2D systems live... |
|-------|---------------------|
| Full-screen 2D game | Entire app (Phaser/Kaplay/Pixi/Canvas) |
| Hybrid DOM + challenges | Only inside guest viewports; tear down when done |

## Sprite systems

| Component | Purpose |
|-----------|---------|
| Atlas | Combine textures, reduce draw calls |
| Animation | Frame sequences (often 8-24 FPS) |
| Pivot | Rotation/scale origin |
| Layering | Z-order control |

Animation principles: squash and stretch for impact; anticipation before action; follow-through after action.

## Tilemap design

| Factor | Recommendation |
|--------|----------------|
| Size | 16x16, 32x32, 64x64 |
| Auto-tiling | Use for terrain |
| Collision | Simplified shapes |

| Layer | Content |
|-------|---------|
| Background | Non-interactive scenery |
| Terrain | Walkable ground |
| Props | Interactive objects |
| Foreground | Parallax overlay |

## 2D physics

| Shape | Use case |
|-------|----------|
| Box | Rectangular objects |
| Circle | Balls, rounded |
| Capsule | Characters |
| Polygon | Complex shapes |

- Pixel-perfect vs physics-based: pick **one** approach per game.
- Fixed timestep for consistency.
- Use layers for filtering.

## Camera systems

| Type | Use |
|------|-----|
| Follow | Track player |
| Look-ahead | Anticipate movement |
| Multi-target | Two-player |
| Room-based | Metroidvania |
| Static | Board games, modal skill-checks |

Screen shake: short duration (50-200ms), diminishing intensity, used sparingly.

## Genre patterns

**Platformer:** coyote time (leniency after edge), jump buffering, variable jump height.

**Top-down:** 8-directional or free movement; aim-based or auto-aim; decide whether rotation matters.

## Anti-patterns

| Don't | Do |
|-------|-----|
| Separate textures | Use atlases |
| Complex collision shapes | Simplified collision |
| Jittery camera | Smooth following |
| Pixel-perfect on physics | Choose one approach |
| Orphaned RAF/listeners after a guest closes | Full teardown |

> 2D is about clarity. Every pixel should communicate.
