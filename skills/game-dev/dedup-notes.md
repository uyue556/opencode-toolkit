# Deduplication Notes — game-dev consolidation

Consolidated from the `game-development` library into a single `game-dev` skill.

## Source library & files scanned

`/home/administrator/.config/opencode/skill-libraries/game-development/` — 18 SKILL.md
files in total (7 top-level skills, 11 sub-skill files under the `game-development`
orchestrator directory) plus 2 implementation playbooks.

| Source skill | Fate |
|--------------|------|
| `game-development` (orchestrator) | Core principles (game loop, pattern matrix, input abstraction, perf budget, AI/collision tables) merged into `SKILL.md`; routing tables rewritten for the new layout |
| `2d-games` | -> `references/2d-games.md` |
| `3d-games` | -> `references/3d-games.md` |
| `engine-selection` | -> `references/engine-selection.md` (PC/console tree merged in) |
| `game-art` | -> `references/game-art.md` |
| `game-audio` | -> `references/game-audio.md` |
| `game-design` | -> `references/game-design.md` (GDD section merged with unity-ai-pipeline GDD content) |
| `mobile-games` | -> `references/platform-mobile.md` (Unity mobile budget table merged from unity-ai-game-creator) |
| `multiplayer` | -> `references/multiplayer-networking.md` |
| `pc-games` | -> `references/platform-pc-console.md` (engine tree merged into engine-selection) |
| `vr-ar` | -> `references/platform-vr-ar.md` |
| `web-games` | -> `references/platform-web.md` |
| `unity-developer` | -> `references/unity.md` |
| `unity-ecs-patterns` | -> `references/unity-ecs.md` + `references/unity-ecs-playbook.md` |
| `unity-ai-game-creator` | -> `references/unity-ai-pipeline.md` |
| `godot-4-migration` | -> `references/godot.md` (migration section) |
| `godot-gdscript-patterns` | -> `references/godot.md` (patterns section) + `references/godot-gdscript-playbook.md` |
| `minecraft-bukkit-pro` | -> `references/minecraft-bukkit.md` |

## Notable duplicates merged

- **Engine selection / framework routing**: `engine-selection` (web decision tree +
  comparison + architecture patterns) and `pc-games` (PC/console decision tree + Unity/
  Godot/Unreal comparison) both selected engines — merged into `references/engine-selection.md`;
  `web-games` kept its own quick framework tree in `references/platform-web.md` but its
  comparison table duplicates `engine-selection`'s, so the platform file now only links out.
- **GDD / design content**: `game-design.md` and `unity-ai-game-creator` both specify GDD
  sections — merged the extended (8-part) GDD outline into `game-design.md`; the AI pipeline
  file routes there instead of duplicating.
- **Performance budgets**: unity-ai-game-creator's platform budget table (mobile/PC/console)
  appears in both `unity.md` and `platform-mobile.md` (mobile row only) — kept once per file
  where contextually scoped.
- **Universal anti-patterns** ("profile first", "don't pick engine by hype", "abstract
  input", "object pooling") repeated across nearly every source file — normalized into the
  single table in `SKILL.md` and engine-specific Do/Don't tables only where engine-flavored.
- **Animation principles** appear in both `2d-games` (squash/stretch, anticipation,
  follow-through) and `game-art` (full 12 principles) — merged into `game-art.md`; `2d-games`
  keeps a one-line pointer.
- **Collision shapes** in `2d-games`, `3d-games`, and the orchestrator — kept per-dimension
  (2D shape table vs 3D shape table) since they genuinely differ.

## Notable skills dropped / not reproduced

- **`game-development` SKILL.md's "Sub-Skill Routing" tables** — replaced by the new
  consolidated `references/` layout (same routing intent, new paths).
- **`godot-gdscript-patterns` and `unity-ecs-patterns` SKILL.md files** — they were stubs
  that only pointed to their playbooks; their real value was the playbooks, which are
  carried verbatim with added ToCs.
- **Generic "Limitations" boilerplate** (same 3 sentences in every file) — collapsed into
  one block in `SKILL.md`; dropped from most references to save space.
- **Marketing/preamble text** in `unity-developer` ("Behavioral Traits", "Knowledge Base",
  "Example Interactions", "Response Approach") — distilled into the "Response approach"
  bullet list in `references/unity.md`; self-praise dropped.

## Scripts carried

None. No source skill shipped a `scripts/` directory with executable code — the two
`resources/implementation-playbook.md` files (Godot GDScript and Unity ECS) were the only
extra files and are preserved as references.

## Gaps / doubts

- The `game-development` sub-skill SKILL.md files have near-identical "When to Use /
  Limitations" boilerplate; content extraction relied on their substantive sections, which
  were all present.
- `minecraft-bukkit-pro` was the only non-Unity/Godot/web skill and its SKILL.md is
  checklist-style without code; kept as a single condensed reference.
- The two playbooks were carried verbatim (803 + 623 lines) rather than rewritten, to
  preserve runnable, tested code samples; they now have ToCs per the >300-line rule.
