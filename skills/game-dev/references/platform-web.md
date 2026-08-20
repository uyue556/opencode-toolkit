# Web Browser Game Development (HTML5 / WebGL / WebGPU)

> Framework selection and browser-specific principles. For stack choice details see `engine-selection.md`.

## Framework selection (quick tree)

```
What type of game?
│
├── 2D
│   ├── Full game engine features? -> Phaser 4
│   ├── Fast prototype / jam?      -> Kaplay
│   ├── Raw rendering power?       -> PixiJS 8
│   └── Tiny / no dependency?      -> Raw Canvas / WebGL
│
├── 3D
│   ├── Full engine (physics, XR)? -> Babylon.js
│   └── Rendering focused?         -> Three.js
│
├── Hybrid (DOM UI + canvas moments)
│   └── Custom shell + guest viewport (Canvas/Kaplay/Phaser/Pixi in a region/modal)
│
└── Narrative-first
    └── Ink (inkjs) or Twine export + DOM host
```

## Hybrid shell + guest

Use when chrome is HTML (menus, inventories, text, dashboards) but bursts of play need a canvas:

1. Mount guest in a container; pass context in.
2. Run a **local** game loop in the guest.
3. Return results (score, pass/fail); **destroy** the guest (RAF, listeners, GL context as needed).

Do not let the guest own global app routing unless the product *is* a full-screen game.

## WebGPU adoption (2025)

| Browser | Support |
|---------|---------|
| Chrome / Edge | Since v113 |
| Firefox | Since v131 |
| Safari | Since 18.0 |

~73% global coverage. Decisions:

- **New GPU-heavy projects:** WebGPU with WebGL fallback.
- **Broad legacy / simple 2D:** start with WebGL or Canvas 2D.
- **Feature detect** with `navigator.gpu`.

## Performance principles

| Browser constraint | Strategy |
|--------------------|----------|
| No local file access | Asset bundling, CDN |
| Tab throttling | Pause when hidden (`visibilitychange`) |
| Mobile data limits | Compress assets |
| Audio autoplay | Require user interaction |

**Optimization priority:** asset compression (KTX2, Draco, WebP) -> lazy loading -> object pooling -> draw-call batching -> Web Workers for heavy computation.

## Asset strategy

| Type | Format |
|------|--------|
| Textures | KTX2 + Basis Universal (or WebP/PNG for simple 2D) |
| Audio | WebM/Opus (fallback: MP3) |
| 3D Models | glTF + Draco/Meshopt |

| Phase | Load |
|-------|------|
| Startup | Core assets, <2MB |
| Gameplay | Stream on demand |
| Background | Prefetch next level |

## PWA for games

**Benefits:** offline play, install, fullscreen, optional push.
**Requirements:** service worker, web app manifest, HTTPS.

## Audio handling

- Create/resume `AudioContext` on first click/tap.
- Prefer Web Audio API; pool sources; preload common SFX.
- Compress with WebM/Opus when possible.

## Anti-patterns

| Don't | Do |
|-------|-----|
| Load all assets upfront | Progressive loading |
| Ignore tab visibility | Pause when hidden |
| Block on audio load | Lazy load audio |
| Skip compression | Compress everything |
| Assume fast connection | Handle slow networks |
| Leave canvas engines running off-screen | Tear down guests |

> The browser is the most accessible platform. Respect its constraints.
