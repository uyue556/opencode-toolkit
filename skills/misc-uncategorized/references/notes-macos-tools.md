# Notes, Knowledge & macOS Tools

Consolidates: obsidian-markdown, obsidian-cli, obsidian-bases, obsidian-clipper-template-creator,
json-canvas, apple-notes-search, macos-menubar-tuist-app, macos-screen-recorder,
macos-spm-app-packaging, speed, slack-gif-creator, screenstudio-alt, magic-animator,
photopea-embedded-editor, favicon (see ui-ux-design).

## 1. Obsidian Flavored Markdown

Obsidian extends CommonMark/GFM. Syntax reference:
- **Wikilinks**: `[[Note]]`, `[[Note|Display]]`, `[[Note#Heading]]`, `[[Note#^block-id]]`;
  block IDs via `^block-id` after a paragraph (own line for lists/quotes).
- **Embeds**: `![[Note]]`, `![[image.png]]`, `![[file.pdf]]`, `![[image.png|300]]`.
- **Callouts**: `> [!type]` (note, tip, warning, danger, info, abstract, question, success,
  failure, example, quote…); optional `+` for foldable, `-` for default-collapsed.
- **Properties**: YAML frontmatter (title, tags, aliases, date, custom); `#tag` inline,
  `#nested/tag` hierarchy.
- **Comments**: `%% hidden %%`. Math: `$...$` / `$$...$$` (LaTeX). Diagrams: Mermaid fenced
  blocks. Footnotes: `[^1]` + `[^1]: content`.
Use wikilinks for in-vault notes (Obsidian tracks renames), Markdown links for external URLs.

## 2. Obsidian CLI

Interact with a running Obsidian instance (must be open). `obsidian help` is always up-to-date.
Syntax: parameters `name="value"` (quote spaces), flags boolean (`silent overwrite`), multiline
via `\n`/`\t`. File targeting: `file=<name>` (wikilink-style) or `path=<path>` (exact from root);
defaults to active file. Vault targeting + plugin development cycle (build/refresh/QA), additional
dev commands.

## 3. Obsidian Bases (.base)

Schema: global filters (all views), formula properties (reusable across views), property display
names, summary formulas, one or more views. Filter syntax: single / AND / OR / NOT / nested;
operators (contains, equals, is, >, <, date-range…). Properties: file properties + the `this`
keyword. Formula syntax + key functions; Duration type (date arithmetic with units
y/M/d/w/h/m/s; avoid dividing a Duration then rounding — compute via `date` math). View types:
Table, Cards, List, Map. Default summary formulas. Complete examples: task tracker, reading list,
daily-notes index.

## 4. Obsidian Web Clipper Template Creator

Create templates for the Obsidian Web Clipper: workflow, selector verification rules (verify
selectors against the live page, not guessed), output format, examples. Target: a clipping template
that reliably captures the right fields.

## 5. JSON Canvas

`.canvas` files (JSON Canvas Spec 1.0): `{"nodes": [], "edges": []}`. Create: base structure →
unique 16-char hex ids → nodes with `id/type/x/y/width/height` → edges via `fromNode`/`toNode` →
validate JSON + id references. Node types: text (text/color), file (file/subpath), link (url),
group (label). Edges: from/to node-side/end, optional color. Add nodes with 50-100px spacing to
avoid overlap.

## 6. Apple Notes Search (apple-notes MCP)

Hybrid search + connection-discovery across the user's own Apple Notes (on-device embeddings,
BM25, clustering, Swanson-ABC bridges; only synthesis calls an LLM). One-time setup must be walked
with the user (MCP server + macOS Full Disk Access). Tool map per job: recall a note → search;
find bridges → connection tools; synthesize a position → synthesis. State ranking caveats when
results look off.

## 7. macOS Menubar App (SwiftUI + Tuist)

Build/refactor/review SwiftUI macOS menubar apps using Tuist. Core rules, expected file shape,
workflow, validation matrix, failure patterns + fix direction, completion checklist.

## 8. macOS Screen Recorder (sck-record)

Capture main display PLUS system audio via ScreenCaptureKit — no BlackHole/loopback drivers.
Use ScreenCaptureKit's built-in audio capture; handle permissions (Screen Recording + Microphone),
config for display/audio selection, output format.

## 9. macOS SwiftPM App Packaging (no Xcode)

Bootstrap a SwiftPM macOS app folder, then build/package/run without Xcode. Two-step: copy
`assets/templates/bootstrap/` + rename `MyApp` (Package.swift, Sources, version.env, APP_NAME/
BUNDLE_ID); copy scripts (package_app.sh, compile_and_run.sh, launch.sh, sign-and-notarize.sh,
make_appcast.sh). Validation checkpoints: `.app` bundle structure, binary present+executable,
`codesign -dv --verbose=4`, `spctl --assess --type execute`, `stapler validate`, Gatekeeper re-check
after notarization. Known notarization failures documented.

## 10. Speed Reader (RSVP)

Launch an RSVP speed reader displaying text one word at a time with Spritz-style ORP
highlighting. Get text from `$ARGUMENTS` or the previous response; strip markdown; escape for JS;
write `reader.html` replacing `<!-- CONTENT_PLACEHOLDER -->` with the content script; `open` it;
tell user Space = play/pause.

## 11. Slack GIF Creator

Create animated GIFs optimized for Slack. Slack requirements (size/format/duration limits); core
workflow: create builder → generate frames → save with optimization. Drawing: work from
user-uploaded images (use as reference or directly) or draw from scratch (circles/ovals, stars/
triangles/polygons, lines, rectangles). Making graphics look good: consistent stroke, palette
constraints, motion economy. Available utilities in the skill's toolkit.

## 12. Screen Studio Alt (open-source headless)

Open-source Screen Studio alternative: auto speed-up of idle, auto-zoom on click clusters,
keystroke overlay. Easy path + gotchas learned the hard way (kept so they're not relearned).

## 13. Magic Animator

AI-powered animation for motion in logos, UI, icons, social media assets. Context, execution
workflow, strict rules (keep animation intent-aligned, respect brand), limitations.

## 14. Photopea Embedded Editor

Embed Photopea in web apps with **photopea.js** (yikuansun/PhotopeaAPI) — never raw postMessage.
CDN/npm install; `Photopea.createEmbed(container)` (container needs fixed width/height);
`pea.runScript(js)` (returns echoToOE values + "done"), `pea.loadAsset(arrayBuffer)`,
`pea.openFromURL(url, asSmart)`, `pea.exportImage("png"|"jpg")`; other formats via
`saveToOE("webp:0.85")` / `"psd:true"` / `"svg:true"`. Plugin mode: `new Photopea(window.parent)`.
Robust patterns: `addImageAndWait` (poll layer count after `app.open`), batch watermark
(translate smart-object layer to bottom-right, set opacity), template + text edit
(`textItem.contents = "..."`), export each layer as PNG.
Scripting = Photoshop CC 2015 JS interface. Set `app.preferences.rulerUnits = Units.PIXELS` before
pixel math. Key objects: `app` (activeDocument, documents, foregroundColor, UI.*), `Document`
(resizeImage/resizeCanvas/crop/trim/flatten/close/saveToOE/suspendHistory/exportDocument),
`Layers/ArtLayers/LayerSets` (getByName, add, recursive walk), `ArtLayer` (translate/rotate/
resize/rasterize, filters apply*, adjustments adjust*), `TextItem` (contents/font/size/color/
justification/tracking/warp*), `Selection` (select/feather/contract/fill/stroke), `SolidColor`
(rgb/cmyk/hsb/lab/hexValue), BlendMode enum, `executeAction` for AM-level ops (edit smart object,
hue/saturation as layer).
Gotchas: container must have size or createEmbed never resolves; return data only via echoToOE;
CORS for remote URLs (`Access-Control-Allow-Origin: *`); serialise dynamic values with
`JSON.stringify` before embedding in runScript; save+close smart objects when done; React Strict
Mode double-mount → guard with ref.

## 15. Related

- Favicon generation → `ui-ux-design.md` §9.
- Media/music/video generation (mmx, Gemini) → `ml-media-tools.md`.
