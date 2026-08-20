# Remotion — programmatic video in React

Remotion renders videos with React components: every frame is a React render, so transitions, text overlays,
data-driven visuals, and audio are all code. This reference merges the walkthrough-video workflow (screens →
video) with the core best-practice rules.

## Table of Contents

- [Project setup](#project-setup)
- [Composition architecture](#composition-architecture)
- [Transitions & timing](#transitions--timing)
- [Media & assets (images, video, audio, fonts)](#media--assets)
- [Captions & subtitles](#captions--subtitles)
- [Text & data visualization](#text--data-visualization)
- [Metadata, decoding & measurement](#metadata-decoding--measurement)
- [Rendering](#rendering)
- [Walkthrough video workflow (screens → video)](#walkthrough-video-workflow)
- [Troubleshooting & best practices](#troubleshooting--best-practices)

## Project setup

```bash
npm create video@latest -- --blank        # choose TypeScript template, place in video/
cd video && npm install @remotion/transitions @remotion/animated-emoji
```

Render: `npx remotion render <CompositionId> output.mp4` (quality via `--quality`, codec `--codec h264|h265`,
parallelism via `--concurrency`). Preview with `npm run dev` (Remotion Studio). Use the Remotion MCP server
(`remotion:mcp_render` etc.) when configured.

## Composition architecture

- Every composition is registered in `Root.tsx` with `<Composition id="..." component={...} durationInFrames={}
  fps={30} width={} height={} />`.
- Sequence items in time with `<Sequence from={frame} durationInFrames={n}>`; trim clips with `from`/`durationInFrames`,
  delay with `delayRender`.
- Use `useCurrentFrame()` + `interpolate()` for frame-driven animation; `spring({frame, fps, config})` for
  natural spring motion.
- Dynamic metadata: `calculateMetadata()` lets you set duration/dimensions/props based on fetched data.
- Set default props on the `Composition` for remounting between Studio edits.

## Transitions & timing

- `@remotion/transitions` provides `fade`, `slide`, `wipe`, `flip`, `clockWipe`, `springTiming`, `linearTiming`.
  Rendered via `TransitionSeries` with `TransitionSeries.Sequence` / `.Transition` children.
- Standard durations: 0.5–1s for subtle cuts, ~1s spring enters, keep pacing consistent per scene.
- Timing curves: `linearTiming`, `easing` (easeInOut), `springTiming` — springs read as "natural"; overdamped
  configs (`damping: ~15`, `stiffness: ~100`) avoid rubber-banding.

## Media & assets

- **Images**: `<Img src={...}>` (never raw `<img>` — Remotion tracks assets).
- **Video/Audio**: `<Video>`/`<Audio>` with `trimBefore`, `endAt`, `volume` (function-of-frame for ramps),
  `playbackRate` (speed), and `pitchCorrection`. Loop with `<Series>` or manual sequences.
- **GIFs**: `@remotion/gif/<Gif>` keeps frames in sync with the timeline (don't use `<img>` for animated GIFs).
- **Fonts**: load Google Fonts via `@remotion/google-fonts/<FontName>` (`await loadFont()`), or `loadFont`
  from `@remotion/fonts` for local files, with `weights`/`subsets`. Never depend on OS fonts.
- **Tailwind**: configure with the official Tailwind plugin; build classNames normally.
- **Lottie**: `@remotion/lottie/lottie` with `useLottie(animationData)` (fetch the JSON yourself) or the Lottie MCP.
- **3D**: `@remotion/three` + React Three Fiber; `useThree`/`getVideoTexture` for scene-into-texture.

## Captions & subtitles

- Fix timing/intervals with `@remotion/transitions` captions; import `.srt` via `parseSrt` from
  `@remotion/captions`; transcribe audio with `whisper.cpp`/`@remotion/transcript` then render.
- Display TikTok-style caption pages and word highlighting with `@remotion/captions` utilities.

## Text & data visualization

- Measure text/fit-to-container and detect overflow with `measureElement()` / `@remotion/layout-utils`.
  Avoid jitter: measure once in `calculateMetadata`, not per frame.
- Measure DOM nodes after `waitForHeight`/`delayRender`; use `useMeasure` from layout utils.
- Charts: build with standard libs or the `@remotion/chart` package; animate with `Sequence` + `interpolate`.
- Animated text: mask reveals, per-letter stagger via `interpolate`, or `@remotion/animated-emoji`.

## Metadata, decoding & measurement

Use the `@remotion/media-utils` (or Mediabunny) helpers instead of hardcoding:
- `getVideoDuration`, `getVideoDimensions`, `getAudioDuration` — returns seconds/dimensions from a file.
- `canUseVideoDecoder` / `canUseRemote` — check decode feasibility before rendering video text.
- Extract frames at timestamps: `extractFrame` (e.g. for a time-thumbnail) via `@remotion/media-utils`/Mediabunny.

## Rendering

```bash
npx remotion render WalkthroughComposition output.mp4
npx remotion still <CompositionId> thumbnail.png   # stills
```

## Walkthrough video workflow

Generate "app walkthrough" videos from screen captures (e.g. a Stitch project) with smooth zooms, fades, and
text overlays.

1. **Discover MCP servers**: `list_tools`; look for `stitch:` and `remotion:` prefixes.
2. **Retrieve screens**: `list_projects` (filter `view=owned`) → pick project → `list_screens` → `get_screen`
   per screen (grabs `screenshot.downloadUrl`, `width`, `height`, title/description). Download screenshots with
   curl/web_fetch into `assets/screens/{screen-name}.png`, ordered by walkthrough flow.
3. **Build a `screens.json` manifest**: per screen `{id, title, description, imagePath, width, height, duration}`.
4. **Write components**:
   - `ScreenSlide.tsx` — shows one image with a zoom/fade-in (`useCurrentFrame()` + `spring()`), title/description
     overlay, `duration` per screen.
   - `WalkthroughComposition.tsx` — imports the manifest, sequences slides with `<Sequence>`, applies
     `@remotion/transitions`, adds hotspots (pulsing rings at x/y), a progress indicator, and numbered steps.
   - `config.ts` — fps (30 default), dimensions matching screen aspect, total duration.
5. **Preview in Remotion Studio** (`npm run dev`), tune per-screen durations and easing, then render
   `npx remotion render WalkthroughComposition output.mp4`.

Optional extras: voiceover narration (TTS script from screen descriptions, `<Audio>` at `from=...`), dynamic
annotations extracted from the app's HTML (`htmlCode.downloadUrl` → headings/buttons → timed callouts).

## Troubleshooting & best practices

| Issue | Fix |
|---|---|
| Blurry screenshots | Use full-resolution downloads; scale proportionally |
| Misaligned text | Match composition dimensions to real screen size |
| Choppy animation | 60fps; spring configs with reasonable damping |
| Build fails | Node compatibility; install all deps; check docs |
| Timing feels off | Adjust per-screen durations; preview in Studio |

- Keep aspect ratio true to source; consistent per-scene timing; readable overlay text (contrast, size);
  spring animations for natural motion.
- PNG for UI screenshots, JPG for photos; compress assets.
- Captions/accessibility preferred; match output dimensions to the target platform.

Resources: https://www.remotion.dev/docs — Transitions, AI skills, MCP; `npx skills add remotion-dev/skills`.