# 3D Game Development

> Principles for 3D game systems (rendering, shaders, physics, cameras, lighting, LOD).

## Rendering pipeline

```
1. Vertex Processing  -> Transform geometry
2. Rasterization      -> Convert to pixels
3. Fragment Processing -> Color pixels
4. Output             -> To screen
```

**Optimization principles:**

| Technique | Purpose |
|-----------|---------|
| Frustum culling | Don't render off-screen |
| Occlusion culling | Don't render hidden |
| LOD | Less detail at distance |
| Batching | Combine draw calls |

## Shader principles

| Shader type | Purpose |
|-------------|---------|
| Vertex | Position, normals |
| Fragment/Pixel | Color, lighting |
| Compute | General computation |

**When to write custom shaders:** special effects (water, fire, portals); stylized rendering (toon, sketch); performance optimization; unique visual identity. For Unity specifics see `unity.md`.

## 3D physics

| Shape | Use case |
|-------|----------|
| Box | Buildings, crates |
| Sphere | Balls, quick checks |
| Capsule | Characters |
| Mesh | Terrain (expensive) |

- Simple colliders, complex visuals.
- Layer-based filtering.
- Raycasting for line-of-sight.

## Camera systems

| Type | Use |
|------|-----|
| Third-person | Action, adventure |
| First-person | Immersive, FPS |
| Isometric | Strategy, RPG |
| Orbital | Inspection, editors |

Camera feel: smooth following (lerp), collision avoidance, look-ahead for movement, FOV changes for speed.

## Lighting

| Type | Use |
|------|-----|
| Directional | Sun, moon |
| Point | Lamps, torches |
| Spot | Flashlight, stage |
| Ambient | Base illumination |

Performance: real-time shadows are expensive — bake when possible; use shadow cascades for large worlds.

## Level of Detail (LOD)

| Distance | Model |
|----------|-------|
| Near | Full detail |
| Medium | ~50% triangles |
| Far | ~25% or billboard |

## Anti-patterns

| Don't | Do |
|-------|-----|
| Mesh colliders everywhere | Simple shapes |
| Real-time shadows on mobile | Baked or blob shadows |
| One LOD for all distances | Distance-based LOD |
| Unoptimized shaders | Profile and simplify |

> 3D is about illusion. Create the impression of detail, not the detail itself.
