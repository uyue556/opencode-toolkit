# Color, Typography & Layout Systems

Cross-cutting systems used by every style. Pick a palette here when the user gives no colors; build type and layout from these scales so screens stay coherent.

## Contents

1. [10 Universal Palettes](#10-universal-palettes) — use verbatim when the user has no colors
2. [Theme Factory themes](#theme-factory-themes) — presentation/brand themes
3. [Color rules](#color-rules) — 60-30-10, contrast, dark mode, mono/gradient/duotone techniques
4. [Typography systems](#typography-systems) — type scale, Swiss, editorial, typography-first
5. [Layout systems](#layout-systems) — grid, spacing, data/product layouts

---

## 10 Universal Palettes

When the user provides their own colors, use exactly those. Otherwise MUST pick one palette below (avoiding generic neon/purple gradients). Each has four roles; define them as CSS variables: `--bg-primary`, `--text-primary`, `--cta-highlight`, `--secondary-base`.

| # | Palette | Backgrounds | Primary text/accent | CTA/highlight | Secondary base |
|---|---|---|---|---|---|
| 1 | **Yacht Club** (nautical/elegant) | `#F9F6F0` | `#1B2A49` | `#C85A32` | `#E2D8C9` |
| 2 | **Desert Mirage** (warm/organic) | `#F4EFEA` | `#2D2B2A` | `#A65E44` | `#8C8781` |
| 3 | **Industrial Chic** (strong/minimal) | `#D1D1D1` | `#111111` | `#9A3B3B` | `#757575` |
| 4 | **Monochromatic Brown** (comfort/nostalgic) | `#D9CBBF` | `#4A362D` | `#7A4C3A` | `#948275` |
| 5 | **Earth-Grounded Elegance** (calm/sustainable) | `#F7F5F0` | `#3A4B3A` | `#8A9A86` | `#D3CEC4` |
| 6 | **Minimalist Slate** (professional/tech) | `#F4F4F9` | `#2B303A` | `#5C6B73` | `#C0C5C1` |
| 7 | **Midnight Luxury** (premium/dark) | `#0A0A0A` | `#F5F5F0` | `#B59A5F` | `#1C1C1C` |
| 8 | **Sophisticated Neutral** (upscale/lifestyle) | `#E6E2DD` | `#1F1C1B` | `#524036` | `#B8B0A8` |
| 9 | **Warm Tech** (corporate/modern) | `#EAEAEA` | `#1C252E` | `#C28F79` | `#2C3E50` |
| 10 | **Modern Editorial** (magazine/high-contrast) | `#F9F9F9` | `#121212` | `#D44A3A` | `#8F8F8F` |

**60-30-10 rule:** 60% backgrounds/secondary, 30% primary text/accents, 10% CTA/highlights.

---

## Theme Factory themes

Presentation/brand themes for decks and marketing artifacts (from `theme-factory`). Pick one, then optionally create a custom theme in the same shape. All use DejaVu Sans (Bold for headers) unless noted.

1. **Ocean Depths** — professional maritime. Deep Navy `#1a2332`, Teal `#2d8b8b`, Seafoam `#a8dadc`, Cream `#f1faee`. Corporate/finance/consulting.
2. **Sunset Boulevard** — warm vibrant sunset colors. Marketing/promotional.
3. **Forest Canopy** — natural grounded earth tones. Sustainability/nature.
4. **Modern Minimalist** — grayscale versatility. Charcoal `#36454f`, Slate `#708090`, Light Gray `#d3d3d3`, White `#ffffff`. Tech, architecture, data viz.
5. **Golden Hour** — rich warm autumnal palette. Lifestyle/premium.
6. **Arctic Frost** — cool crisp winter tones. Wellness/clean tech.
7. **Desert Rose** — soft sophisticated dusty tones. Fashion/beauty.
8. **Tech Innovation** — bold modern tech aesthetic. Product/startup.
9. **Botanical Garden** — fresh organic garden colors. Health/organic.
10. **Midnight Galaxy** — dramatic cosmic deep tones. Entertainment/premium.

Custom theme creation: name it like the list, define 4+ role colors with hex codes and purpose, pair header/body fonts, state "best used for", then show it for approval before applying.

---

## Color rules

- **Contrast first.** Normal text ≥ 4.5:1 (AA), large text ≥ 3:1, AAA = 7:1/4.5:1. Check every text/background pairing, including tinted shadows and pastel-on-white. Use `scripts/contrast-checker.js`.
- **Dark mode:** never pure black (`#121212` class); elevated surfaces get *lighter* not shadowed; desaturate brand accents; primary text `rgba(255,255,255,.87)`, secondary `.60`.
- **Monochromatic:** build a hue ramp in HSL (`hsl(210,80%,10%)` → `hsl(210,40%,95%)`); tint shadows with the base hue; let font weight carry hierarchy.
- **Gradients:** blend adjacent hues to avoid muddy middles (red→yellow→green, not red→green); keep the rest of the layout minimal.
- **Duotone:** two colors only; process all photos; heavy condensed type.
- **Soft pastel:** colors = hue + heavy white; warm off-white background; tinted (not black) shadows.
- **High contrast:** single luminous accent on B/W; visible focus rings; avoid greys/opacity.
- **Color blocking:** 3–4 strong colors, blocks touch with 1–2px black separators.

## Typography systems

- **Type scale:** pick 3–4 sizes (e.g., display / H1 / body / caption), not arbitrary sizes. Hierarchy from weight + size + leading before color.
- **Spacing scale:** multiples of 8px; generous 48–120px for minimal/airy styles; 2–4px only for data-dense.
- **Swiss:** one neutral sans family; huge size contrast; flush-left/ragged-right; asymmetry; never center.
- **Editorial:** high-contrast serif display + clean sans body; drop caps; pull quotes; 2-column body with hairline rules.
- **Typography-first:** 25vw display type, outline strokes, minimal chrome; text is the interface.
- **Brutalist type:** system fonts, oversized, clipping/overlap intended.
- **Tabular numbers** (`font-variant-numeric: tabular-nums`) for any data alignment; monospace for dense data.

## Layout systems

- **Bento / widget grid:** `repeat(4,1fr)` / `auto-fill minmax(160px,1fr)` with fixed row heights and equal gaps; consistent 24–32px radii; span classes for size.
- **Card grid:** `repeat(auto-fill, minmax(300px,1fr))`, gap 24px; cards pop off a slightly darker background.
- **Dashboard:** `250px 1fr` columns + `70px 1fr` rows; KPI cards top, charts middle, tables bottom.
- **Data-dense:** zero-gap grid/tables; thin 1px cell borders; right-aligned numbers; row hover highlight.
- **Command center:** `300px | 1fr | 300px`; dark; central map/topology; red/amber reserved for alerts.
- **Tile/Metro:** fixed 150px squares; horizontal panning; live-content animation.
- **Swiss grid:** 12-col grid; content columns define rhythm; empty space is intentional.
- **Flat/color-block:** structure from solid fills and 1–2px borders only — no shadows.

## Notes

- Web: expose every palette as CSS variables; native: map roles into the platform theme engine (ColorScheme, ThemeData, MaterialTheme), keep the 60-30-10 proportions.
- Always let the *user's* colors win; palettes are a fallback and a shared vocabulary for review.
