# Context Optimization

Keep LLM context windows within budget, route context cheaply, and control token spend
(FinOps). Use these tactics when a session is getting long, tokens cost too much, or the
agent is re-reading material it shouldn't.

## Context window strategy

- **Tiered context strategy**: below ~32k tokens use full history; below ~100k summarize
  old messages; above that go RAG (retrieve relevant, then recent messages). Pick the model
  per tier.
- **Serial position effect**: models weight the beginning and end of context most. Put
  system instructions first, critical context right after (high primacy), summarize the
  middle history, restate the current query and key constraints at the end.
- **Intelligent summarization**: score messages by importance + has-critical-info
  (+0.5) + referenced-later (+0.3); keep high-scorers verbatim, summarize the rest into one
  `[Earlier context: ...]` system block, preserving user preferences, decisions, and the
  flow. Never naive-truncate.
- **Token budget allocation**: reserve roughly system 10%, critical context 15%, history 40%,
  query 10%, response 25%; truncate/summarize each component to fit, then give any leftover
  budget to history.
- **Count tokens before sending** (tiktoken etc.); hardcoded limits should be configurable
  per model.

## Ignore-files that control what the agent reads

Configure `.geminiignore` (or equivalent ignore file for the agent tool) so the agent never
pays tokens for machine noise. Seven core rule categories:

1. **System/editor noise**: `.DS_Store`, `Thumbs.db`, `.vscode/*` (keep `settings.json`),
   `.idea/`, `.gradle/`.
2. **Dependencies & lock files**: `node_modules/`, `vendor/`, `venv/`, `package-lock.json`,
   `yarn.lock`, `pnpm-lock.yaml`, `Cargo.lock`, `composer.lock`, `poetry.lock` — lock files
   are the single largest FinOps win (thousands of redundant lines).
3. **Build outputs**: `dist/`, `build/`, `out/`, `target/`, `.next/`, `.nuxt/`, `bin/`, `obj/`.
4. **Caches**: `.vite/`, `.parcel-cache/`, `.eslintcache`, `.tsbuildinfo`, `.turbo/`,
   `.pytest_cache/`, `.ruff_cache/`.
5. **Binary/rich assets**: `*.png`, `*.jpg`, `*.webp`, `*.pdf`, `*.zip`, `*.woff2`, `*.ttf`
   — blocks expensive vision/multimodal token charges.
6. **DBs & logs**: `*.log`, `*.db`, `*.sqlite*`, `*.sql`.
7. **Compiled binaries**: `*.apk`, `*.aab`, `*.ipa`, `*.jar`, `*.class`, `*.pyc`,
   `__pycache__/`, `*.so`, `*.dll`, `*.exe`, `*.js.map`.

Rules to keep:
- Keep config manifests visible (`package.json`, `Cargo.toml`, `pyproject.toml`,
  `composer.json`) — never ignore them.
- Whitelist `.env.example` while ignoring `.env`/`.env.*` so the agent understands config
  shape without seeing secrets.
- Do not ignore real source directories (`lib/`, `app/`); block generated folders only.
- A `.geminiignore` only affects the AI tool, not git; use valid gitignore globbing.

## Personal/project context artifacts

### Context Kit (personal context files)

Local Markdown artifacts an agent reads at session start so it doesn't re-learn you each time.
Treat every such file as **private by default**; never paste into third-party tools/repos.

- Starter set: `pca-wiki.md` (durable identity/domains), `pca-mental-models.md` (decision
  rules), `pca-voice.md` (writing style), `pca-protocols.md` (hard rules).
- Keep files short enough to read at startup; separate durable facts from temporary state;
  label assumptions as assumptions; add a recurring review cadence — **stale context is worse
  than no context**.
- Never store passwords, API keys, recovery codes, tokens, or payment details in context
  artifacts. Never commit them to a public repo (gitignore the private dir).
- Before running a `curl | bash` installer, clone + inspect the script, verify it writes only
  to expected local dirs, sends no telemetry, and has a rollback path.

### project.faf (portable AI context)

One IANA-registered YAML file that tells any AI tool "how to help build this" — separate from
human READMEs. Auto-detect stack from manifests, mine README/architecture, then emit a
scored context file. Migration: `faf migrate --from CLAUDE.md|.cursorrules|README.md`, sync
across tools. Universal target formats: `.faf`, `GEMINI.md`, `.cursorrules`, `.windsurfrules`.

### Codex profiles (isolated agent state)

Run Codex CLI/Desktop with separate `CODEX_HOME` directories so work/personal/client contexts
stay isolated. `codex-profile init <name>` / `cli <name>` / `status` / `doctor`.

- Use explicit, boring profile names (`work`, `personal`, `client-a`).
- Never copy/parse/print `auth.json` tokens between profiles.
- Isolation is `CODEX_HOME`-only, not an OS sandbox (shell history, SSH, browser state are
  separate). Prefer CLI commands; get explicit approval before Desktop app launch/clone.
- Manual equivalent: `CODEX_HOME="$HOME/.codex-work" codex`.

## Best practices

- Keep one idea/session in the "smart zone" (~120k tokens) where the model still reasons
  sharply; when you near it, hand off to a fresh session instead of pushing on degraded.
- Use a handoff doc (see workflow reference) rather than raw truncation when crossing
  sessions.
- Review ignore-files and context artifacts on a schedule; both rot.
