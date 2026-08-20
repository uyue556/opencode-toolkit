# Motion & Depth

Engineering guidance for animated, 3D, and spatial interfaces: tool selection, 3D model pipeline, performance budgets, animation rules, and reduced-motion.

## Contents

1. [3D stack selection](#3d-stack-selection)
2. [3D model pipeline](#3d-model-pipeline)
3. [3D performance](#3d-performance)
4. [Scroll-driven animation](#scroll-driven-animation) (GSAP, R3F)
5. [CSS depth effects](#css-depth-effects)
6. [Motion rules](#motion-rules)
7. [Validation checklist](#validation-checklist)

---

## 3D stack selection

| Tool | Best for | Curve | Control |
|---|---|---|---|
| Spline | Quick prototypes, designer-friendly | Low | Medium |
| React Three Fiber | React apps, complex scenes | Medium | High |
| Three.js vanilla | Max control, non-React | High | Maximum |
| Babylon.js | Games, heavy 3D | High | Maximum |

Decision tree: quick element? → Spline. Using React? → R3F. Need max performance/control? → vanilla Three.js.

Spline: `<Spline scene="https://prod.spline.design/xxx/scene.splinecode" />`. R3F: `Canvas` + `useGLTF('/model.glb')` + `OrbitControls`.

## 3D model pipeline

1. Model in Blender (or export from source).
2. Reduce poly count — <100K for web, <50K mobile.
3. Bake textures (combine materials).
4. Export as **GLB/GLTF** (smallest web format).
5. Compress with `gltf-transform`:
   ```bash
   npm i -g @gltf-transform/cli
   gltf-transform optimize in.glb out.glb --compress draco --texture-compress webp
   ```
6. Test file size — target <5MB.
7. Load with suspense + progress UI (`useProgress` from drei).

## 3D performance

Targets: desktop 60fps / ≤500K tris; mobile 30–60fps / ≤100K tris; low-end 30fps / ≤50K tris.

- Use `Instances`/`Instance` (drei) for repeated objects instead of many meshes.
- Limit lights — one ambient + one directional is plenty.
- Use LOD (Level of Detail) for far objects.
- Lazy-load models (`lazy(() => import('./Model'))`).
- Cap canvas `dpr` (1 on mobile; 2 desktop) and allow frame drops (`performance={{ min: 0.5 }}`).
- Add a WebGL detection + static-image fallback for unsupported devices.
- Compress models (Draco + texture compression) before shipping.

## Scroll-driven animation

- **R3F + ScrollControls:** `useScroll()` offset drives mesh rotation/material/camera in `useFrame`.
- **GSAP + ScrollTrigger:** `gsap.to(camera.position, { scrollTrigger: { trigger, scrub: true }, z: 5, y: 2 })`.
- Common effects: camera dolly through scene, model rotation on scroll, reveal/hide, color/material shifts, exploded-view.

## CSS depth effects

Useful CSS-only depth (no WebGL), combining examples from many styles:

- **Perspective + preserve-3d:** parent `perspective: 1000px`; child `transform-style: preserve-3d`; move content with `translateZ()`; hover straightens + lifts (`translateZ(50px)`).
- **Glass:** `backdrop-filter: blur(16–50px) saturate(150–200%)` + `rgba` fill + 1px translucent border + specular inset highlight. Requires a richly textured background.
- **Floating:** fixed pill nav `bottom: 32px; border-radius: 50px; box-shadow: 0 16px 40px rgba(0,0,0,.8@8%)`; large margins so nothing touches edges.
- **Isometric:** `transform: rotateX(60deg) rotateZ(-45deg)`; side/top faces via skewed pseudo-elements; hard angled shadows.
- **Layered/parallax:** `position: absolute` + `z-index` + negative margins; background layers move slower than foreground on scroll.
- **Aurora orbs:** absolute radial-gradients with `filter: blur(80px)` drifting 20s (animate transform only).

## Motion rules

From `antigravity` and the style system:

- Every state change (hover/focus/active) transitions smoothly — minimum `0.3s ease-out`. Never snap instantly.
- **Stagger entrances** — grid items enter ~0.1s apart ("dominoes"), not all at once.
- **Parallax** — background slower than foreground.
- **Will-change:** use `will-change: transform` for animated elements; never animate `box-shadow` or `filter` continuously (paint cost).
- Match the style's shadow/weight language — "antigravity" floating look = layered soft diffuse shadows (`0 20px 40px rgba(0,0,0,.05)`) + glass + perspective depth.
- **Accessibility:** disable all animation under `@media (prefers-reduced-motion: reduce)`. Keep essential state changes as opacity/transform fades.

## Validation checklist

- [ ] Loading indicator exists while 3D/async models load (Suspense fallback; no blank).
- [ ] WebGL fallback provided (static image / 2D variant) for unsupported devices.
- [ ] Models compressed (Draco + textures) and <5MB.
- [ ] OrbitControls don't capture scroll (`enableZoom={false}` or separate wheel handling).
- [ ] `dpr` capped on mobile; frame-rate budget respected.
- [ ] Entrance animations staggered; total motion duration reasonable.
- [ ] `prefers-reduced-motion: reduce` honored.
- [ ] Motion uses transform/opacity only (no continuous box-shadow/filter animation).

## Notes

- Depth without purpose is decoration: favor 3D/motion where it explains state, product, or story; otherwise keep it scarce.
- For the *visual* depth styles (3d-ui, floating-ui, glassmorphism, spatial-design, aurora, neumorphism, claymorphism, holographic, isometric, layered, skeuomorphism) see their recipes in `style-router.md`.