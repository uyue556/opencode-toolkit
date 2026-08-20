# VR / AR Development

> Immersive experience principles. **Comfort is not optional — sick players don't play.**

## Platform selection

| VR platform | Use case |
|-------------|----------|
| Quest | Standalone, wireless |
| PCVR | High fidelity |
| PSVR | Console market |
| WebXR | Browser-based |

| AR platform | Use case |
|-------------|----------|
| ARKit | iOS devices |
| ARCore | Android devices |
| WebXR | Browser AR |
| HoloLens | Enterprise |

## Comfort principles (motion sickness prevention)

| Cause | Solution |
|-------|----------|
| Locomotion | Teleport, snap turn |
| Low FPS | Maintain 90 FPS |
| Camera shake | Avoid or minimize |
| Rapid acceleration | Gradual movement |

Comfort settings: vignette during movement, snap vs smooth turning, seated vs standing modes, height calibration.

## Performance requirements

| Platform | FPS | Resolution |
|----------|-----|------------|
| Quest 2 | 72-90 | 1832x1920 |
| Quest 3 | 90-120 | 2064x2208 |
| PCVR | 90 | 2160x2160+ |
| PSVR2 | 90-120 | 2000x2040 |

Frame budget: VR requires **consistent** frame times; a single dropped frame = visible judder. 90 FPS = 11.11ms budget.

## Interaction principles

| Controller type | Use |
|-----------------|-----|
| Point + click | UI, distant objects |
| Grab | Manipulation |
| Gesture | Magic, special actions |
| Physical | Throwing, swinging |

**Hand tracking:** more immersive but less precise — good for social/casual, challenging for action/precision.

## Spatial design

- World scale: **1 unit = 1 meter** (critical). Test with real measurements.
- Depth cues, in order: stereo -> motion parallax -> shadows (grounding) -> occlusion (layering).

## Anti-patterns

| Don't | Do |
|-------|-----|
| Move camera without player | Player controls camera |
| Drop below 90 FPS | Maintain frame rate |
| Use tiny UI text | Large, readable text |
| Ignore arm length | Scale to player reach |
