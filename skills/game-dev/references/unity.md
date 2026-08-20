# Unity Development (Unity 6 / URP / C#)

> Expert Unity 6 LTS development: modern rendering pipelines, scalable architecture,
> performance optimization, and cross-platform deployment.

## Core Unity mastery

- Unity 6 LTS features and Long-Term Support benefits; Unity Hub project management.
- Package Manager + custom package development; Asset Store integration and pipeline optimization.
- Version control (Unity Collaborate, Git + LFS for large assets, Perforce).
- Unity Cloud Build and automated deployment pipelines.

## Modern rendering pipelines

- **URP** for mobile/stylized; **HDRP** for high-fidelity; Built-in for legacy/2D migration.
- Custom render features and renderer passes; post-processing stack.
- Shader Graph for visual shaders; HLSL for advanced effects.
- Lighting/shadow optimization per target platform.

## Performance optimization

- Unity Profiler (CPU/GPU/memory), Frame Debugger, Memory Profiler.
- LOD systems and automatic LOD generation; occlusion + frustum culling.
- Texture streaming, Addressables for asset loading.
- Physics optimization and collision efficiency.

## Advanced C# game programming

- C# 9.0+ patterns; Unity-specific optimization.
- Job System + Burst Compiler for hot paths (see `unity-ecs.md`).
- Async/await replacing coroutines where appropriate.
- GC minimization: reuse buffers, object pooling.

## Architecture & design patterns

- ECS for large-scale simulation (see `unity-ecs.md`).
- MVC / MVVM for UI and logic; Observer for decoupled communication.
- State machines for player/game state; object pooling for hot spawn paths.
- Singleton vs Service Locator vs dependency injection — prefer the latter for testability.

## Asset management

- Addressable Assets System for dynamic content; asset bundles.
- Texture/audio compression; animation compression; mesh LOD.
- **Scriptable Objects for data-driven design** — decouple data from logic.
- Prevent circular asset dependencies.

## UI/UX

- UI Toolkit (uGUI) + Canvas optimization; responsive multi-resolution UI.
- Input System with Action Maps for multi-platform input.
- Localization/i18n; accessibility features.

## Physics & animation

- Unity Physics / Havok; 2D and 3D physics optimization.
- Animation state machines + blend trees; Timeline for cutscenes.
- Cinemachine camera system; IK and procedural animation.
- Particle systems / VFX Graph optimization.

## Networking & multiplayer

- Unity Netcode for GameObjects; Mirror as an alternative.
- Client-server sync, lag compensation, bandwidth management.
- Relay and lobby services; cross-platform multiplayer; voice chat.

## Platform-specific development

- **Mobile:** URP 30fps targets, draw calls < 100, build < 150MB (see `platform-mobile.md`).
- **Console:** PlayStation (TRC), Xbox (XR), Nintendo (Lotcheck) certification.
- **PC:** Steam integration, Windows optimizations.
- **WebGL:** build optimization, browser compatibility.
- **VR/AR:** XR Toolkit + platform features (see `platform-vr-ar.md`).

## Advanced graphics & shaders

- Shader Graph + HLSL custom effects; compute shaders.
- PBR material workflows; VFX Graph for high-performance particles.
- HDR + tone mapping; custom post-processing / screen-space techniques.

## Audio

- Audio System + Audio Mixer groups; 3D spatial audio / HRTF.
- Dynamic/adaptive music; Wwise + FMOD integration.
- Audio streaming, compression, platform-specific settings (see `game-audio.md`).

## Testing & DevOps

- Unity Test Framework (play mode / edit mode); performance benchmarks + regression.
- Memory leak detection; crash reporting + analytics.
- Cloud Build CI, automated build pipelines, release management.

## Response approach

1. Analyze requirements for the optimal architecture and pipeline.
2. Recommend performance-optimized solutions using modern Unity features.
3. Provide production-ready C# with error handling and logging.
4. Include cross-platform considerations and platform-specific optimizations.
5. Plan testing, memory management, and deployment strategies.

## Do & Don't

| Don't | Do |
|-------|-----|
| Optimize before profiling | Profile first (Profiler/Frame Debugger) |
| Hardcode assets by path | Use Addressables / references |
| Singleton everything | Prefer events / ScriptableObject events |
| Ignore target platform limits | Design to platform budgets |
| Ship untested | Test on real devices, all target platforms |

## Budget reference (Unity)

| Metric | Mobile | PC | Console |
|--------|--------|----|---------|
| Target FPS | 30/60 | 60/120 | 60 |
| Draw calls | < 100 | < 500 | < 300 |
| Triangles/frame | < 100K | < 2M | < 1M |
| Texture memory | < 150MB | < 1GB | < 512MB |
| Build size | < 150MB | < 2GB | < 4GB |
