# Game Audio Principles

> Sound design and music integration. Roughly 50% of the game experience is audio — a muted game loses half its soul.

## Audio category system

| Category | Behavior | Examples |
|----------|----------|----------|
| Music | Looping, crossfade, ducking | BGM, combat music |
| SFX | One-shot, 3D positioned | Footsteps, impacts |
| Ambient | Looping background layer | Wind, crowd, forest |
| UI | Immediate, non-3D | Button clicks, notifications |
| Voice | Priority, ducking trigger | Dialogue, announcer |

**Priority hierarchy when channels compete:** Voice (highest) > Player SFX > Enemy SFX > Music (duckable) > Ambient (lowest, droppable).

## Sound design decisions

| Approach | When to use | Trade-offs |
|----------|-------------|------------|
| Recording | Realistic needs | High quality, time intensive |
| Synthesis | Sci-fi, retro, UI | Unique, requires skill |
| Library samples | Fast production | Common sounds, licensing |
| Layering | Complex sounds | Best results, more work |

**Layering structure (example: gunshot):** Attack (initial transient: click/snap) + Body (main character: boom/blast) + Tail (decay/room: reverb, echo) + Sweetener (special sauce: shell casing, mechanical).

## Music integration

```
Game State -> Music Response
├── Menu             -> Calm, loopable theme
├── Exploration      -> Ambient, atmospheric
├── Combat detected  -> Transition to tension
├── Combat engaged   -> Full battle music
├── Victory          -> Stinger + calm transition
├── Defeat           -> Somber stinger
└── Boss             -> Unique, multi-phase track
```

**Transitions:** Crossfade (smooth mood shift), Stinger (immediate event), Stem mixing (dynamic intensity), Beat-synced (rhythmic gameplay), Queue point (next natural break).

## Adaptive audio

**Intensity parameters:** threat level (music intensity), health (filter/reverb — low health = muffled), speed (tempo/energy), environment (reverb/EQ), time of day (mood/volume).

**Vertical vs horizontal:**

| System | What changes | Best for |
|--------|--------------|----------|
| Vertical (layers) | Add/remove instrument layers | Intensity scaling |
| Horizontal (segments) | Different music sections | State changes |
| Combined | Both | AAA adaptive scores |

## 3D audio

| Element | 3D positioned? | Reason |
|---------|----------------|--------|
| Player footsteps | No (or subtle) | Always audible |
| Enemy footsteps | Yes | Directional awareness |
| Gunfire | Yes | Combat awareness |
| Music | No | Mood, non-diegetic |
| Ambient zone | Yes (area) | Environmental |
| UI sounds | No | Interface feedback |

**Distance behavior:** near = full volume/frequency; medium = volume + high-freq rolloff; far = low volume, low-pass filter; max = silent or ambient hint.

## Platform formats & memory budgets

| Platform | Format | Reason |
|----------|--------|--------|
| PC | OGG Vorbis, WAV | Quality, no licensing |
| Console | Platform-specific | Certification |
| Mobile | MP3, AAC | Size, compatibility |
| Web | WebM/Opus, MP3 fallback | Browser support |

| Game type | Audio budget | Strategy |
|-----------|--------------|----------|
| Mobile casual | 10-50 MB | Compressed, fewer variants |
| PC indie | 100-500 MB | Quality focus |
| AAA | 1+ GB | Full quality, many variants |

## Mix hierarchy

| Category | Relative level | Notes |
|----------|----------------|-------|
| Voice | 0 dB (reference) | Always clear |
| Player SFX | -3 to -6 dB | Prominent but not harsh |
| Music | -6 to -12 dB | Foundation, ducks for voice |
| Enemy SFX | -6 to -9 dB | Important but not dominant |
| Ambient | -12 to -18 dB | Subtle background |

**Ducking rules:** voice plays -> duck music/ambient -6 to -9 dB; explosion -> brief duck of everything else; menu open -> gameplay audio -3 to -6 dB.

## Anti-patterns

| Don't | Do |
|-------|-----|
| Play the same sound repeatedly | Use variations (3-5 per sound) |
| Max volume everything | Use a proper mix hierarchy |
| Ignore silence | Silence creates contrast |
| One music track loops forever | Provide variety, transitions |
| Skip audio in prototype | Placeholder audio matters |
