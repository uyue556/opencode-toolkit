# AI UI Tools & Design Tool Automation

Workflows for AI-assisted UI generation (Stitch, Vizcom) and for automating the main design tools (Figma, Canva, Webflow via Rube/Composio MCP).

## Contents

1. [Golden rule for all MCP automation](#golden-rule-for-all-mcp-automation)
2. [Google Stitch — effective UI prompts](#google-stitch--effective-ui-prompts)
3. [Vizcom — sketch-to-render](#vizcom--sketch-to-render)
4. [Figma automation](#figma-automation)
5. [Canva automation](#canva-automation)
6. [Webflow automation](#webflow-automation)

---

## Golden rule for all MCP automation

**Always call the tool-discovery/search endpoint** (`RUBE_SEARCH_TOOLS` etc.) before invoking any named tool — schemas change frequently. Every workflow below names the *intent* and key params; actual tool slugs come from the live schema.

Connections: single shared setup — add `https://rube.app/mcp` as an MCP server (no API keys), then `RUBE_MANAGE_CONNECTIONS` with the app toolkit (`figma`/`canva`/`webflow`), follow the OAuth link if not ACTIVE, confirm ACTIVE before working.

## Google Stitch — effective UI prompts

Stitch is a Gemini-powered text/image→UI generator (multi-screen flows, responsive, HTML/CSS + Figma export). Quality is decided by the prompt.

**Prompt formula:**

```
[Screen/Component Type] for [User/Context]
Key Features:
- [specific feature details]
- ...
Visual Style:
- [color scheme][aesthetic][layout approach]
Platform: [Mobile/Web/Responsive]
```

Rules:
- Be specific: components + layout + style + context ("Member dashboard with course grid, progress bar, community sidebar, purple card theme" — not "dashboard").
- State required states (loading/empty/error) and interactions (hover, click, transitions).
- Multi-screen: list each screen as bullets before generating.
- Iterate: use annotate-to-edit for targeted changes, generate several variants to explore, then refine progressively (broad → specific).
- Use design vocabulary ("hero section", "card layout", "glassmorphic", "bento grid") — it maps to real UI language.
- **Stitch is a starting point**: refactor exported code for production (semantic HTML, ARIA, alt text, optimized images, animations); verify breakpoints and contrast before handoff.

## Vizcom — sketch-to-render

AI rendering for physical products (furniture, electronics, transportation, consumer goods).

1. Analyze input (sketch / 3D screenshot / text description).
2. Choose a render style — Photorealistic for finals, Refine to iterate.
3. Craft a prompt with material precision (anodized aluminum, frosted glass, carbon fiber), lighting direction (cinematic, high-contrast), and descriptive adjectives + weights.
4. Iterate on the infinite canvas (textures, colors, forms) until striking; present the high-fidelity render.

Always specify materials + lighting — the two things that prevent the generic "plastic-y AI render".

## Figma automation

Key intents → tools (verify slugs at runtime):

- **Parse URLs**: extract `file_key`, `node_id`, `team_id` from a Figma URL. Convert node ids `1-541` (URL dash form) → `1:541` (API colon form).
- **Read files**: get file JSON (`simplify` for AI-friendly, `depth` to bound size). Only Design files (`/design/`, `/file/`); FigJam + Slides return 400; broad reads return 413 — narrow ids/depth.
- **Render/export**: render node ids as png/svg/jpg/pdf (scale 0.01–4.0), download by {node_id,file_name,format}; URLs ~30 days; 32MP cap.
- **Tokens**: extract colors/typography/spacing; convert to Tailwind config with the *full* token object (never strip fields). Team/team styles endpoints return only published assets; team_id must come from the URL.
- **Comments/versions**: list/add comments (one level of replies), reactions, version history.
- **Browse**: team projects, project files, team styles.

## Canva automation

- **List designs**: search by `query`, follow `continuation` tokens; substring not fuzzy; deleted designs may linger.
- **Create**: from brand templates or fresh; `design_type` must match Canva types exactly; sizes have bounds; assets must be uploaded first.
- **Upload assets**: create upload job → poll `FETCH_UPLOAD_JOB_STATUS` until success; PNG/JPG/SVG/MP4/GIF; then reference `asset_id`.
- **Export**: create export job → poll result for download URL; formats pdf/png/jpg/svg/mp4/gif/pptx; MP4 only for animations; download URLs expire — use promptly.
- **Folders**: create folder (unique name within parent), move items.
- **Autofill**: from *brand* templates only; placeholder names are case-sensitive; data types must match (text vs image URL).

Async pattern everywhere: initiate → poll every 2–3s → success/failed. Add exponential backoff for bulk; parse defensively (data may nest under `data`).

## Webflow automation

- **Sites**: list → capture `site_id` (24-char hex).
- **CMS collections**: `GET_COLLECTION` first to learn *field slugs* (not display names); create needs `field_data` with `name` + `slug`; update needs existing `item_id`; image = `{url, alt, fileId}`; items are staged — publish to make live.
- **Publish**: republishes ALL staged changes (confirm with user first); requires ≥1 target (custom domain IDs or `publish_to_webflow_subdomain`); rate limit 1/min.
- **Pages**: list/get metadata; GET_PAGE_DOM returns node structure, not rendered HTML.
- **Assets**: upload requires real `file_content` base64 (not a placeholder) + `md5` of the raw bytes + MIME type.
- **Ecommerce**: orders are read-only; site must have ecommerce enabled.

IDs are MongoDB ObjectIds (`^[0-9a-fA-F]{24}$`) — invalid IDs → 404. OAuth scope errors surface as 403. Destructive ops (delete item, publish) always confirm intent.

## Notes

- These tools change fast; treat the references above as *intent maps* and always re-sync tool schemas at runtime (golden rule).
- Never put credentials/tokens in prompts or client code; keep them in local config/env vars.
- Automation results (Figma renders, Canva exports) should still pass the review gates in `references/ui-ux.md` and `references/accessibility.md` before shipping.