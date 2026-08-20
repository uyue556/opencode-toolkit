# Mobile Game Development (iOS / Android)

> Platform constraints and optimization principles. The most constrained platform — respect battery and attention.

## Platform constraints

| Constraint | Strategy |
|------------|----------|
| Touch input | Large hit areas, gestures |
| Battery | Limit CPU/GPU usage |
| Thermal | Throttle when hot |
| Screen size | Responsive UI |
| Interruptions | Pause on background |

## Touch input principles

| Touch | Desktop/Console |
|-------|-----------------|
| Imprecise | Precise |
| Occludes screen | No occlusion |
| Limited buttons | Many buttons |
| Gestures available | Buttons/sticks |

Best practices:

- Minimum touch target: **44x44 points**.
- Visual feedback on touch.
- Avoid precise timing requirements.
- Support both portrait and landscape.

## Performance targets

**Thermal management:**

| Action | Trigger |
|--------|---------|
| Reduce quality | Device warm |
| Limit FPS | Device hot |
| Pause effects | Critical temp |

**Battery optimization:**

- 30 FPS is often sufficient.
- Sleep when paused.
- Minimize GPS/network.
- Dark mode saves OLED battery.

## App store requirements

**iOS (App Store):** privacy labels, account deletion (if account creation exists), screenshots for all device sizes.

**Android (Google Play):** target current year's SDK, 64-bit required, App Bundles recommended.

## Monetization models

| Model | Best for |
|-------|----------|
| Premium | Quality games, loyal audience |
| Free + IAP | Casual, progression-based |
| Ads | Hyper-casual, high volume |
| Subscription | Content updates, multiplayer |

## Anti-patterns

| Don't | Do |
|-------|-----|
| Desktop controls on mobile | Design for touch |
| Ignore battery drain | Monitor thermals |
| Force landscape | Support player preference |
| Always-on network | Cache and sync |

## Unity mobile budget reference

| Metric | Mobile target |
|--------|---------------|
| Target FPS | 30/60 |
| Draw calls | < 100 |
| Triangles/frame | < 100K |
| Texture memory | < 150MB |
| Build size | < 150MB |
