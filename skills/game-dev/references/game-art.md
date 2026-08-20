# Game Art Principles

> Visual design thinking for games — style selection, asset pipelines, and art direction.
> Art serves gameplay. If it doesn't help the player, it's decoration.

## Art style selection

**Decision tree:**

```
What feeling should the game evoke?
│
├── Nostalgic / Retro
│   ├── Limited palette? -> Pixel Art
│   └── Hand-drawn feel? -> Vector / Flash style
│
├── Realistic / Immersive
│   ├── High budget? -> PBR 3D
│   └── Stylized realism? -> Hand-painted textures
│
├── Approachable / Casual
│   ├── Clean shapes? -> Flat / Minimalist
│   └── Soft feel? -> Gradient / Soft shadows
│
└── Unique / Experimental
    └── Define custom style guide
```

| Style | Speed | Skill floor | Scalability | Best for |
|-------|-------|-------------|-------------|----------|
| Pixel Art | Medium | Medium | Hard to hire | Indie, retro |
| Vector/Flat | Fast | Low | Easy | Mobile, casual |
| Hand-painted | Slow | High | Medium | Fantasy, stylized |
| PBR 3D | Slow | High | AAA pipeline | Realistic games |
| Low-poly | Fast | Medium | Easy | Indie 3D |
| Cel-shaded | Medium | Medium | Medium | Anime, cartoon |

## Asset pipelines

**2D pipeline:** Concept (paper, Procreate, Photoshop) -> Creation (Aseprite, Photoshop, Krita) -> Atlas (TexturePacker, Aseprite) -> Animation (Spine, DragonBones, frame-by-frame) -> Engine import.

**3D pipeline:** Concept/blockout -> Modeling (Blender, Maya, 3ds Max) -> Retopology (Blender, ZBrush) -> UV/Texturing (Substance Painter, Blender) -> Rigging -> Animation (Blender, Maya, Mixamo) -> Export FBX/glTF.

## Color theory decisions

| Goal | Strategy | Example |
|------|----------|---------|
| Harmony | Complementary or analogous | Nature games |
| Contrast | High saturation differences | Action games |
| Mood | Warm/cool temperature | Horror, cozy |
| Readability | Value contrast over hue | Gameplay clarity |

Principles: **hierarchy** (important elements pop), **consistency** (same object = same color family), **context** (colors read differently on backgrounds), **accessibility** (don't rely only on color).

## Animation — the 12 principles (applied to games)

| Principle | Game application |
|-----------|------------------|
| Squash & stretch | Jump arcs, impacts |
| Anticipation | Wind-up before attack |
| Staging | Clear silhouettes |
| Follow-through | Hair, capes after movement |
| Slow in/out | Easing on transitions |
| Arcs | Natural movement paths |
| Secondary action | Breathing, blinking |
| Timing | Frame count = weight/speed |
| Exaggeration | Readable from distance |
| Appeal | Memorable design |

| Action | Typical frames | Feel |
|--------|----------------|------|
| Idle breathing | 4-8 | Subtle |
| Walk cycle | 6-12 | Smooth |
| Run cycle | 4-8 | Energetic |
| Attack | 3-6 | Snappy |
| Death | 8-16 | Dramatic |

## Resolution & scale

| Platform | Base resolution | Sprite scale |
|----------|-----------------|--------------|
| Mobile | 1080p | 64-128px characters |
| Desktop | 1080p-4K | 128-256px characters |
| Pixel art | 320x180 to 640x360 | 16-32px characters |

Consistency rule: pixel art work at 1x and scale up (never down); HD art define a DPI and keep the ratio; 3D = **1 unit = 1 meter**.

## Asset organization

```
[type]_[object]_[variant]_[state].[ext]

spr_player_idle_01.png
tex_stone_wall_normal.png
mesh_tree_oak_lod2.fbx
```

```
assets/
├── characters/ (player/, enemies/)
├── environment/ (props/, tiles/)
├── ui/
├── effects/
└── audio/
```

## Anti-patterns

| Don't | Do |
|-------|-----|
| Mix art styles randomly | Define and follow a style guide |
| Work at final resolution only | Create at source resolution |
| Ignore silhouette readability | Test at gameplay distance |
| Over-detail the background | Focus detail on player area |
| Skip color testing | Test on target display |
