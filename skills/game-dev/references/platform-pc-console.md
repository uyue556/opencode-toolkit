# PC & Console Game Development

> Engine selection, platform features, and optimization strategies for desktop.

## Engine selection

See the PC/console decision tree and comparison matrix in `engine-selection.md`.

## Platform features

**Steam integration:**

| Feature | Purpose |
|---------|---------|
| Achievements | Player goals |
| Cloud Saves | Cross-device progress |
| Leaderboards | Competition |
| Workshop | User mods |
| Rich Presence | Show in-game status |

**Console certification:** PlayStation = TRC, Xbox = XR, Nintendo = Lotcheck. Study the requirements early.

## Controller support

Map ACTIONS, not buttons:

```
"confirm" -> A (Xbox), Cross (PS), B (Nintendo)
"cancel"  -> B (Xbox), Circle (PS), A (Nintendo)
```

**Haptics:** light = UI feedback, medium = impacts, heavy = major events.

## Performance optimization

| Engine | Profiler |
|--------|----------|
| Unity | Profiler Window |
| Godot | Debugger -> Profiler |
| Unreal | Unreal Insights |

| Bottleneck | Solution |
|------------|----------|
| Draw calls | Batching, atlases |
| GC spikes | Object pooling |
| Physics | Simpler colliders |
| Shaders | LOD shaders |

## Engine-specific principles

- **Unity 6:** DOTS for performance-critical systems, Burst for hot paths, Addressables for asset streaming.
- **Godot 4:** GDScript for rapid iteration, C# for complex logic, Signals for decoupling.
- **Unreal 5:** Blueprint for designers, C++ for performance, Nanite for high-poly environments, Lumen for dynamic lighting.

## Anti-patterns

| Don't | Do |
|-------|-----|
| Choose engine by hype | Choose by project needs |
| Ignore platform guidelines | Study certification requirements |
| Hardcode input buttons | Abstract to actions |
| Skip profiling | Profile early and often |

> Engine is a tool. Master the principles, then adapt to any engine.
