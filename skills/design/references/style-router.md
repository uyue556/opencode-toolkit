# Style Router — 48 Opinionated Aesthetics

Consolidation of the `design-it` 48-style system. Use this to map a user request (exact keyword or fuzzy intent) to ONE concrete style, then implement it faithfully. Do not blend styles unless the user explicitly asks.

## How to route

1. Match the user's words (Chinese or English) to a style below. You do not need an exact match — use semantics.
2. Read that style's entry: Core principles → Visual DNA → Key CSS recipe.
3. If the user gave no colors, pick a palette from `color-typography-layout.md` and set CSS variables.
4. Web vs app: web = CSS variables + grid/flexbox + transitions. Native (SwiftUI/Flutter/RN/Compose) = map palette into the theme engine, use platform elevation/animation instead of CSS. Core visual principles stay the same.

## Fuzzy keyword map

| User says | Route to |
|---|---|
| Apple style, VisionOS, spatial, glass | `spatial-design`, `bento-ui`, `glassmorphism`, `floating-ui` |
| Windows 8, Metro, live tiles | `tile-design` |
| Terminal, hacker, HUD | `sci-fi-interface`, `brutalist-typography` |
| Bauhaus, grid, clean, editorial | `swiss-design`, `editorial-design` |
| Cyber, Matrix, neon dystopia | `cyberpunk-ui`, `synthwave` |
| Retro, vintage, nostalgic | `retro-design`, `y2k-design`, `vaporwave`, `frutiger-aero` |
| Brutal, raw, exposed | `brutalism`, `neo-brutalism` |
| Premium, luxury, elegant | `minimalism`, `maximalism`, `swiss-design` |
| 极简 / minimal | `minimalism`, `flat-design` |
| 玻璃拟态 / glass / frosted | `glassmorphism`, `aurora-ui`, `spatial-design` |
| 赛博朋克 / cyberpunk | `cyberpunk-ui` |
| 新拟态 / soft UI | `neumorphism` |
| 复古 / retro | `retro-design`, `vaporwave`, `synthwave` |
| 卡片 / card / bento | `card-based-design`, `bento-ui`, `widget-based-design` |
| 数据 / dashboard / 大屏 | `dashboard-design`, `data-dense-design`, `command-center-ui` |
| 3D / 立体 | `3d-ui`, `isometric-design`, `spatial-computing-ui` |
| 多彩 / bold / maximal | `vibrant-maximalism`, `maximalism`, `color-blocking` |

## Contents

1. [Modern UI](#modern-ui) — minimalism, flat-design, flat-design-2, material-design, glassmorphism, neumorphism, skeuomorphism, claymorphism, aurora-ui, bento-ui
2. [Depth & 3D](#depth--3d) — 3d-ui, isometric-design, layered-design, floating-ui, spatial-design
3. [Typography](#typography) — swiss-design, editorial-design, typography-first, brutalist-typography
4. [Retro & Historical](#retro--historical) — brutalism, neo-brutalism, retro-design, y2k-design, cyber-y2k, vaporwave, synthwave, frutiger-aero, retro-futurism
5. [Modern Trends](#modern-trends) — dark-mode, monochromatic-ui, gradient-design, duotone-design, color-blocking, soft-pastel, high-contrast, vibrant-maximalism, maximalism
6. [Futuristic](#futuristic) — cyberpunk-ui, sci-fi-interface, holographic-ui, ai-native-ui, spatial-computing-ui
7. [Data & Product](#data--product) — dashboard-design, card-based-design, widget-based-design, tile-design, data-dense-design, command-center-ui

---

## Modern UI

### minimalism
*"Remove until nothing is left but the essential."* Use for premium/saas/portfolios; keywords 极简, clean, Apple, luxury.
- Extreme whitespace — double what you'd first choose (48–120px padding); strict type scale for hierarchy (no colors/boxes); zero decor: no borders, shadows, textures.
- DNA: pure/off-white backgrounds; geometric sans (`Inter`, `SF Pro`, `Helvetica Neue`), extreme weight contrast (Thin vs Black); 8px baseline grid.
- Recipe: `max-width: 800px; margin: 0 auto; padding: 120px 24px`; buttons = transparent + 1px border + uppercase tracking.

### flat-design
*"Digital surfaces should look digital."*
- Zero depth (no shadows/bevels/gradients/3D); sharp simple geometry; solid-color contrast.
- DNA: strong legible sans; solid monochrome icons; `border-radius: 0`.
- Recipe: hover via opacity change only (no lifting); structure via borders and fills.

### flat-design-2
*"Flat, but with subtle physics hints of interactability."*
- Mostly flat; soft large-spread shadows reserved for interactive elements; barely-visible micro-gradients.
- DNA: tinted shadows (`rgba(43,48,58,0.08)`, never pure black); clean sans.
- Recipe: `box-shadow: 0 10px 30px tinted` + `translateY(-4px)` on hover.

### material-design
*"Digital paper and ink; stacked material."*
- Z-axis elevation where shadows communicate state; meaningful continuous motion (ripple, shared-element); strict 8dp grid + component anatomy.
- DNA: Roboto/Google Sans + Material Type Scale; semantic color mapping (primary/secondary/surface/error); radii 4–16px.
- Recipe: elevation shadows (e.g. `0 3px 1px -2px rgba(0,0,0,.2), 0 2px 2px 0 rgba(0,0,0,.14), 0 1px 5px 0 rgba(0,0,0,.12)`); uppercase 500-weight button text, letter-spacing 1.25px.

### glassmorphism
*"Frosted window blending with a vibrant background."* Keywords 玻璃拟态, frosted, translucent.
- `backdrop-filter: blur()` is the defining trait; semi-transparent rgba panels; 1px light border = glass edge.
- DNA: needs a rich background (gradient/mesh/photo) to show; high-contrast text; soft drop shadow.
- Recipe: `background: rgba(255,255,255,.15); backdrop-filter: blur(16px) saturate(180%); border: 1px solid rgba(255,255,255,.3); border-radius: 16px`.

### neumorphism
*"Elements extruded from the background by one light source."*
- Surface and element share the exact base color; dual shadows (light top-left, dark bottom-right); no borders.
- DNA: mid-tone neutrals only (never pure white/black); rounded soft fonts (`Nunito`, `Quicksand`); pill/rounded shapes.
- Recipe: `box-shadow: 9px 9px 18px var(--shadow), -9px -9px 18px var(--highlight)`; pressed state inverts to inset shadows.

### skeuomorphism
*"Interfaces that look like their physical counterparts."*
- Realistic textures (leather, metal, wood, paper); physical lighting (specular, bevels, inner shadows); real-world metaphors (toggle switches, dials).
- DNA: palette depends on simulated material; object-matched type (typewriter for paper, LCD for screens).
- Recipe: layered gradients + textures with `background-blend-mode`; multi-layer `box-shadow` (inset highlight + inset shade + drop); press = deepen inner shadows + `translateY(2px)`.

### claymorphism
*"Pristine digital claymation — soft, bubbly, approachable."*
- Inflated 3D volume via inner shadows; continuous max-radius curves; colors contrast with background (unlike neumorphism, it detaches).
- DNA: pastel/bright hues; playful thick rounded fonts (`Fredoka One`, `Nunito`); squicles + circles.
- Recipe: `box-shadow: 8px 8px 24px rgba(0,0,0,.15), inset -8px -8px 16px rgba(0,0,0,.1), inset 8px 8px 16px rgba(255,255,255,.4)`; bouncy hover (`cubic-bezier(0.34,1.56,0.64,1)`).

### aurora-ui
*"Northern lights trapped under frosted glass."*
- Blurred color orbs floating in background; glassy overlays on top; slow fluid motion.
- DNA: dark deep background + luminous cyan/magenta/lime orbs; thin elegant sans; minimal foreground.
- Recipe: absolute-positioned `radial-gradient` circles with `filter: blur(80px)`, `animation: float 20s ease-in-out alternate`; foreground `backdrop-filter: blur(20px)`.

### bento-ui
*"Everything in its right place — structured modular grid."*
- Strict responsive multi-column grid (3×3/4×4/masonry); every block a consistently-rounded compartment; perfectly equal gaps.
- DNA: Apple-esque fonts; off-white bg making white compartments pop; edge-to-edge images or one large 3D icon per cell.
- Recipe: `display: grid; grid-template-columns: repeat(4,1fr); grid-auto-rows: 200px; gap: 24px`; cards `border-radius: 32px`; span classes for size variation.

## Depth & 3D

### 3d-ui
*"Breaking the plane — interfaces in rotatable 3D space."*
- True z-axis movement; perspective; interactive tilt/rotation on pointer or gyroscope.
- DNA: high-contrast palettes to show geometry; blocky/extruded type; rendered 3D assets (.glb/.gltf) not flat icons.
- Recipe: parent `perspective: 1000px`, child `transform-style: preserve-3d` + `rotateX/rotateY`, inner content `translateZ(30px)`; hover straightens + pulls forward.

### isometric-design
*"The architect's view — parallel projection at 30°."*
- No vanishing point; exact 30-degree projection; blocky "SimCity" architecture.
- DNA: muted realistic colors; flat or plane-mapped text; hard shadows at fixed ±45°.
- Recipe: `transform: rotateX(60deg) rotateZ(-45deg)` on the grid; pseudo-element side/top faces with `skewY(-45deg)`/`skewX(-45deg)`.

### layered-design
*"Stacking context — overlapping independent layers."*
- Explicit overlap breaks the grid; every layer visually distinct; parallax (background slower than foreground).
- DNA: distinct bg vs floating elements; oversized overlapping type; negative space around overlaps.
- Recipe: `position: absolute` layers + `z-index`, negative margins, offset content card pulled over a background image.

### floating-ui
*"Defying gravity — elements hovering above the surface."*
- Elements never touch screen edges; large diffuse shadows directly beneath; pill shapes.
- DNA: tinted off-white bg; airy sans with generous line-height; floating-island pill nav.
- Recipe: `position: fixed; bottom: 32px; left: 50%; transform: translateX(-50%); border-radius: 50px; box-shadow: 0 16px 40px rgba(0,0,0,.08)`.

### spatial-design
*"UI that belongs in the room — glass panels reacting to real light."*
- Environmental transparency (blur reveals environment); dynamic cursor lighting; thin specular rim.
- DNA: purely `rgba()` white/black — color comes from background; sharp legible type (SF Pro); outlined icons.
- Recipe: `background: rgba(255,255,255,.2); backdrop-filter: blur(40px) saturate(150%); box-shadow: inset 0 1px 1px rgba(255,255,255,.6), 0 24px 48px rgba(0,0,0,.1)`.

## Typography

### swiss-design
*"Form follows function; the grid is absolute."* Keywords Bauhaus, grid, clean, International Typographic Style.
- Mathematical grids; asymmetry preferred; flush-left/ragged-right (never center); objective documentary imagery.
- DNA: B/W + one saturated accent (Swiss red); huge size contrast (6rem vs 1rem); `Helvetica Neue`/`Inter`.
- Recipe: 12-col CSS grid; header spans columns leaving right side empty; `text-align: left`.

### editorial-design
*"The digital magazine — sophisticated type pairings, elegant pacing."*
- Serif + sans pairing (high-contrast serif headings, clean sans body); drop caps & pull quotes; columnar layout with hairline rules.
- DNA: paper-white bg, ink-black text; `Playfair Display`/`Merriweather` + `Lato`/`Source Sans Pro`.
- Recipe: `column-count: 2` body; `::first-letter` drop cap; pull quotes with top/bottom 2px rules.

### typography-first
*"The words are the interface — no distractions."*
- Hyper-sized headlines that become graphic elements; text-only chrome (no boxes); kinetic/moving type.
- DNA: extreme contrast, B/W or dark + one neon accent; display fonts (`Anton`, `Oswald`, `Bebas Neue`).
- Recipe: `font-size: 25vw` with `white-space: nowrap` + outline via `-webkit-text-stroke`.

### brutalist-typography
*"Text that breaks the rules to demand attention."*
- Overlapping/clipped/off-screen text; intentional "ugly" system fonts at massive size; harsh contrast.
- DNA: system fonts (`Times New Roman`, `Arial`, `Courier`) at 150px+; marquees, blinking, underlines through descenders.
- Recipe: negative margins + `font-size: 15vw; line-height: 0.7; letter-spacing: -5px`; red-highlight blocks.

## Retro & Historical

### brutalism
*"Raw materials exposed — rejection of polish."*
- Celebrate default browser styling; expose structure with visible borders/grid lines; intentional awkwardness.
- DNA: clashing high contrast (`#0000FF` links, `#FF0000` accents, `#C0C0C0`); Courier/Times/Comic Sans; dithered images.
- Recipe: default elements, oversized `.brutalist-btn` with `border: 2px outset`, system link blue.

### neo-brutalism
*"Brutalism but it pops — hard lines, stark shadows, vibrant color."*
- Solid black `box-shadow` with 0 blur, offset right/down; 2–4px black borders everywhere; flat high-contrast color.
- DNA: off-white bg + black borders + saturated lemon/cyan/coral; bold geometric sans (`Space Grotesk`, `Archivo Black`).
- Recipe: `--neo-shadow: 6px 6px 0px #000`; active state = `translate(4px,4px)` + remove shadow (the "press").

### retro-design
*"Warm analog nostalgia — muted tones, grain, classic type."*
- Sun-faded palettes; grain/noise overlay; groovy display + typewriter/serif body.
- DNA: mustard/burnt-orange/sage on aged paper; `Cooper Black`, `Garamond`, `Courier`; stamps, wavy borders, halftone.
- Recipe: `background-blend-mode: multiply` noise; `text-shadow: 2px 2px 0` offset colors; rotated stickers/badges.

### y2k-design
*"The optimistic shiny future as imagined in 1999."*
- Chrome/metallic gradients; organic "blob" shapes; tech-optimism motifs (circuits, crosshairs, grids).
- DNA: silver/chrome + cyan/hot-pink/lime; wide sans or pixel fonts (`Orbitron`, `Syncopate`); outer glows, starry glints.
- Recipe: chrome text = multi-stop gradient with `-webkit-background-clip: text`; blob buttons via asymmetric `border-radius`.

### cyber-y2k
*"Y2K through a distorted modern lens — darker, glitchier, holographic."*
- Holographic iridescent gradients; glitch/RGB-split art; aggressive tribal-tech vectors.
- DNA: black bg + purple/cyan/lime/pink fluid gradients; stretched or technical mono fonts; chromatic aberration.
- Recipe: rainbow `background-size: 1800%` animation; glitch = `::before/::after` cyan/magenta offsets of `attr(data-text)`.

### vaporwave
*"A surreal 90s-computing dream of pastel neon."*
- Windows 95 / Mac OS 9 chrome (grey boxes, hard bevels, blue titlebars); pastel+neon mix; collage (classical art, early 3D, kanji).
- DNA: cyan/magenta/lavender + Windows grey `#C0C0C0`; `MS Sans Serif`/`Tahoma`/pixel fonts; fullwidth aesthetic text.
- Recipe: `border: 2px outset #fff` with dark right/bottom = classic 90s button; `:active { border-style: inset }`; gradient sun.

### synthwave
*"Driving a Ferrari through a neon digital grid at midnight."*
- Dark by default (pitch black/purple); neon glowing vectors; the perspective grid to the horizon.
- DNA: `#0B0C10`/`#110022` bg; cyan/hot-pink/yellow neon; 80s chrome + script display fonts.
- Recipe: layered `text-shadow` glows in element color; floor grid via `perspective(500px) rotateX(60deg)` + fade mask.

### frutiger-aero
*"Mid-2000s optimism — glossy plastic, clear water, blue skies."*
- Hyper-glossy convex gradients; skeuomorphic nature (grass, bubbles, water); saturated translucency (Aero glass).
- DNA: sky blue/cyan/lime/white (no dark); humanist sans (`Frutiger`, `Segoe UI`); deep shadows + bright top-edge highlights.
- Recipe: button = 4-stop vertical gradient + `inset` top highlight + convex shine; aero panel `rgba(255,255,255,.4)` + blur + brighter top border.

### retro-futurism
*"The 1950s-60s future — rockets, atoms, aerodynamic chrome."*
- Sweeping curves and teardrop shapes (nothing square); space-age motifs (stars, orbits, fins); mid-century pastels + chrome.
- DNA: turquoise/atomic-tangerine/mint + silver; Googie/cursive/mid-century geometric (`Futura`); sleek bezels, offset overlaps.
- Recipe: asymmetrical border-radius (`40px 10px 40px 10px`); starburst via `clip-path: polygon(...)`; swooping rounded background bands.

## Modern Trends

### dark-mode
*"Not inverted colors — a constructed hierarchy of light on dark."*
- Never pure black (`#121212`-class); elevation shown by *lightness* (shadows invisible in dark); desaturate accents.
- DNA: `#121212` base, `#1E1E1E`/`#242424` elevated; text `rgba(255,255,255,.87/.60)`; drop one font weight vs light mode.
- Recipe: elevated cards `border: 1px solid rgba(255,255,255,.05)`; hover = lighter surface (element moves "closer").

### monochromatic-ui
*"One hue explored through all its tints, tones, and shades."*
- Single base hue for the whole UI; darkest tint vs lightest shade must pass contrast; texture/opacity instead of extra color.
- DNA: one dominant hue extrapolated; clean type (weight carries hierarchy); shadows tinted with the hue, never black.
- Recipe: build with HSL (`hsl(210,80%,10%)` → `hsl(210,40%,95%)`); mid-tones for secondary text.

### gradient-design
*"Color in motion — fluid transitions add energy and depth."*
- Gradients are the primary visual (bg, text, borders); blend analogous/adjacent hues to avoid muddy middles; subtle animation.
- DNA: vibrant pairs (purple→coral, deep blue→cyan); heavy sans for gradient text masks; minimal structure so gradients breathe.
- Recipe: animated mesh `background: linear-gradient(-45deg, ...); background-size: 400%`; gradient text via `background-clip: text`.

### duotone-design
*"Everything stripped to exactly two clashing or complementary colors."*
- Dark color replaces shadows, light replaces highlights; all photos treated to the duotone palette; massive solid type.
- DNA: high-contrast pairs (navy+peach, deep purple+neon lime); heavy condensed sans (`League Gothic`, `Oswald`).
- Recipe: image → `filter: grayscale(100%) contrast(1.5)` + `mix-blend-mode: multiply` over light layer, `screen` overlay of dark.

### color-blocking
*"The grid made visible — large solid swaths of contrasting color."*
- Viewport divided into solid-color rectangles; blocks touch (1–2px black separators or none); type balances block weight.
- DNA: 3–4 strong colors (Industrial Chic or bold yellow/navy/pink); clean bold sans.
- Recipe: CSS grid with `gap: 4px` + black container background = Mondrian-style separators; `2px solid #000` borders.

### soft-pastel
*"Calm, airy, gentle — washed-out cheerful hues."*
- Desaturated high-lightness colors (heavy white); large friendly radii; airy spacing.
- DNA: mint/baby-blue/blush/lavender/buttercream on warm off-white (`#FFFBF7`, not `#FFF`); rounded sans; tinted soft shadows.
- Recipe: `border-radius: 24px`; `box-shadow: 0 20px 40px rgba(174,198,207,.15)`; darker version of pastel for text contrast.

### high-contrast
*"Maximum legibility — stark, powerful, universally accessible."*
- WCAG AAA (7:1) on every pairing; visible borders + focus states; no ambiguous greys or low-opacity text.
- DNA: B/W + one luminous accent (yellow/cyan); robust sans (`Atkinson Hyperlegible`, `Inter`), base 18px+; 2px solid borders, minimal shadows.
- Recipe: `:focus-visible { outline: 4px solid var(--hc-focus); outline-offset: 4px }`; underlined links, thickness 2px.

### vibrant-maximalism
*"More is more — explosion of color, pattern, typography."*
- Sensory overload (patterns over gradients over photos); deliberate clashing colors; 3–4 typefaces mixed.
- DNA: all saturated unmuted hues; chaotic type mix (massive serif + bubble subhead + mono body); stickers, marquees, 3D renders.
- Recipe: multi-radial-gradient backgrounds; multi-color `text-shadow` offsets; rotating sticker elements.

### maximalism
*"Controlled maximalism — dense and rich but deeply intentional."*
- High density; ornate detailing (decorative borders, textures, flourishes); strict underlying grid holds the chaos.
- DNA: jewel tones (emerald/ruby/sapphire/gold) or Monochromatic Brown; ornate serifs (`Cinzel`, `Playfair Display`) + legible sans; thin elegant dividers.
- Recipe: dense grid `repeat(6,1fr)`; gold double borders with inner dashed rule.

## Futuristic

### cyberpunk-ui
*"High tech, low life — neon cutting through megacity smog."*
- Neon on black; chamfered/clipped corners (cut metal plates); glitch + data streams.
- DNA: acid yellow/cyan/hot pink on black; squared industrial sans (`Rajdhani`, `Teko`) + mono for data; diagonal stripes, outer glows.
- Recipe: `clip-path: polygon(...)` chamfers; hover = accent swap + cyan/red offset `box-shadow` glitch.

### sci-fi-interface
*"Heads-Up Display — tactical, precise, analytical."*
- Wireframe/outline-built UI (strokes not fills); circular arrays & radar sweeps; monochrome + red-for-alerts only.
- DNA: midnight bg, pure cyan/green/amber; technical monospace (`Share Tech Mono`, `VT323`) all-caps; corner brackets, coordinates.
- Recipe: corner brackets via `::before/::after`; `text-shadow: 0 0 10px` glow; blinking warning (`animation: blink 1s step-end infinite`).

### holographic-ui
*"Made of light — projected interfaces, visible but translucent."*
- Never fully solid (zero-opacity backgrounds); scanlines/interference sell the projection; luminous edges brighter than centers.
- DNA: monochrome cyan/blue/green + white cores; thin technical sans with glowing `text-shadow`; `rgba` + `mix-blend-mode: screen`.
- Recipe: `background: rgba(0,200,255,.05)` + 4px repeating scanline gradient + edge glow; subtle flicker keyframes.

### ai-native-ui
*"Fluid, adaptive, conversational — the interface morphs to serve content."*
- Conversational-first (prompt input is primary navigation); generative loading states (shimmer text, morphing gradients, skeletons); self-sizing adaptive components.
- DNA: clean white/dark base + iridescent gradient "AI presence"; readable system fonts; subtle glowing borders during generation.
- Recipe: animated shimmer text (`background-clip: text` + 200% gradient); gradient border via double background-clip.

### spatial-computing-ui
*"Beyond spatial design — 3D windows floating in AR."*
- True Z-space hierarchy (modals float in front); gaze/precise-pointer hover cues; thick frosted-glass windows casting soft shadows.
- DNA: translucent whites/blacks only; `SF Pro` weight hierarchy; radii 24–32px, rounded rectangles + circles.
- Recipe: `perspective: 1200px` scene; window `backdrop-filter: blur(50px) saturate(200%)` + `translateZ(-100px)`; modal `translateZ(50px)` forward; hover = `translateZ(10px) scale(1.05)`.

## Data & Product

### dashboard-design
*"Data at a glance — organized, scannable, functional."*
- Modular grid (sidebar + top nav + widget cards); data hierarchy (KPI numbers large on top, charts middle, tables bottom); muted background so white cards pop.
- DNA: 1–2 colors, red/green only for trends; tabular sans (`Inter`, `Roboto Mono` for numbers); subtle shadows or 1px borders.
- Recipe: `grid-template-columns: 250px 1fr; grid-template-rows: 70px 1fr`; KPI card = title (grey small) + value (2rem bold).

### card-based-design
*"Bite-sized consumption — discrete information in distinct containers."*
- Self-contained cards (image, title, description, action); responsive reflow (4-col → 1-col); clear card/background boundary.
- DNA: flexible; bg slightly darker than cards; in-card type hierarchy; `border-radius: 8–12px` + medium shadow.
- Recipe: `grid-template-columns: repeat(auto-fill, minmax(300px,1fr))`; hover = `translateY(-4px)` + deeper shadow.

### widget-based-design
*"Miniature applications — small functional blocks designed to be rearranged."*
- Strict aspect ratios (1×1, 2×1, 2×2); glanceability (key data instantly, deep action in full app); inner radius nests inside outer radius.
- DNA: bright solid color or full-bleed photo widgets; huge numbers + tiny sub-labels.
- Recipe: `grid-auto-rows: 160px` forced squares; span classes for sizes; weather widget = gradient + 3rem thin temp.

### tile-design
*"Authentically digital — sharp squares, typography, flat color."*
- Zero border-radius (perfect squares); live tiles flip/scroll data; horizontal panning grids.
- DNA: flat saturated tiles on dark; `Segoe UI Light` white text; wireframe mono icons.
- Recipe: `grid-template-columns: repeat(4,150px)`; live tile content `animation: slideUp 5s infinite`; `:active { transform: scale(.95) }`.

### data-dense-design
*"Density is a feature — for experts, fewer clicks beat whitespace."*
- Compact 2–4px spacing; monospace/tabular numbers aligned vertically; every pixel functional.
- DNA: Industrial Chic/Minimalist Slate; 11–13px base; `Fira Code`/`JetBrains Mono`; thin 1px borders (`#333`/`#e0e0e0`); dark themes preferred for long sessions.
- Recipe: right-aligned numeric cells; even-row striping; row hover = selection highlight.

### command-center-ui
*"Mission Control — global monitoring, real-time alerts, high-stakes data viz."*
- Dark/black backgrounds (NOC room); map/topology at center; alert hierarchy (90% calm blue/grey, critical flashes amber/red).
- DNA: black or deep navy; electric cyan/amber/critical red accents; `Orbitron`/`Roboto`/`Share Tech`; glowing borders, radar sweeps.
- Recipe: 3-pane grid (300px | 1fr | 300px); panel headers gradient + cyan underline; `pulse-red` box-shadow alert animation.

---

## Cross-platform notes

- **Web (React/Vue/HTML):** expose the style's palette as CSS variables; CSS grid/flexbox; transitions for hover/press.
- **SwiftUI:** map palette to `Color(hex:)`; use `.shadow(color:radius:x:y:)` for elevation; `.ultraThinMaterial` for glass; `rotation3DEffect` for 3D.
- **Flutter:** theme `ColorScheme`/`ThemeData`; `BoxDecoration` + `BoxShadow`; `backdropFilter` for glass.
- **React Native:** map to theme engine; platform elevation shadows; `transform: [{ perspective }]` for 3D.
- **Jetpack Compose:** `MaterialTheme` colorScheme/typography; `Modifier.shadow`; `graphicsLayer` transforms.

## Limitations

- These are aesthetic directions, not strict specs — adapt to real content and the project's design system.
- A style that hurts usability (e.g., glowing text at body size, neumorphism on forms) should be relaxed; accessibility always wins.
- Each source style was a ~300-line template with per-platform code samples; the essential principles and CSS recipes are preserved here; if you need deep platform sample code, write it from these principles.
