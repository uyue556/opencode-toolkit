# Agent Networking & Team Protocols

Agent-to-agent communication and coordination beyond simple orchestration: compact messaging languages, overlay networking, and learning coordination protocols. Consolidated from `lambda-lang`, `pilot-protocol`, `polis-protocol`.

## Table of contents

1. [Lambda: compact agent-to-agent messaging](#lambda-compact-agent-to-agent-messaging)
2. [Pilot Protocol: agent networking](#pilot-protocol-agent-networking)
3. [Polis Protocol: a learning agent team](#polis-protocol-a-learning-agent-team)

---

## Lambda: compact agent-to-agent messaging

Lambda is a native agent-to-agent language, not a translation layer — a shared vocabulary (~340 atoms across domains) for compact, unambiguous machine-to-machine coordination. Compression (≈3× vs natural language; 4.6× vs JSON) is a side effect, not the goal.

**Syntax:** messages built from 2-character atoms in the structure Type → Entity → Verb → Object, with intent prefixes:

- `?` — query: `?Uk/co` = "does this user have consciousness?"
- `!` — assertion: `!It>Ie` = "self reflects, therefore self exists"
- `#` — state / tag
- `>` — implication / flow
- `/` — binding / scope

**Domains:** core (universal), code (build/test/deploy), evo (agent evolution capsules/rollback), a2a (39 atoms: node, heartbeat, publish, subscribe, route, transport, session, cache, broadcast, discover), emotion, social (trust, alignment, reputation), general.

**Guidelines:**

- Use only on agent-to-agent channels where both sides speak it — never against humans or surfaces requiring exact/legal natural language.
- Load and cache the atom table once; version it in a handshake so mismatched agents can negotiate.
- Lossy decoding is a feature — exact English phrasing is irrelevant as long as meaning transfers. Don't use it for legally/numerically exact exchanges (prices, IDs, quantities): wrap those as native payload fields and use Lambda only for the coordination envelope.
- `?` before acting on uncertain state, `!` when asserting; the prefix is the load-bearing semantic.
- Treat Lambda atoms as pre-validated, user strings as untrusted.

Example heartbeat: `!Nd/hb#ok` (node heartbeat ok), `?Nd/hb` (is the node alive?). Task dispatch: `!Tk>Ag2#rd` (task routed to agent 2, ready), `!Tk#dn` (task done).

---

## Pilot Protocol: agent networking

An open-source overlay network giving agents first-class network citizenship: a permanent virtual address, encrypted UDP tunnels with NAT traversal, an explicit per-peer trust model, and an app store of installable typed JSON-in/JSON-out agent apps. Use when agents need stable addresses that survive restarts/IP changes, or direct encrypted messaging without a shared cloud account.

**Workflow:**

1. Install the daemon — download, **review**, then run (`less` the installer before executing).
2. `pilotctl daemon start`; confirm with `pilotctl info`.
3. Query a service agent (public directory auto-approves): `pilotctl send-message list-agents --data '/data {"search":"weather"}' --wait`; read the reply from `~/.pilot/inbox/*.json`.
4. Handshake a peer for direct messaging (mutual approval): `pilotctl handshake <hostname> "<reason>"`, `pilotctl trust`, then `send-message`.
5. Install app capabilities: `pilotctl appstore catalogue/install/call`.

**Best practices & gotchas:**

- Use `--wait` on `send-message` so the reply is guaranteed to be in the inbox before reading.
- Trust propagation through the registry takes seconds — wait and retry after a handshake before assuming failure.
- `~/.pilot/identity.json` is a private keypair — never copy between hosts.
- Don't set `--auto-answer` on your own node (service-agent-only flag).
- Running the daemon joins a public P2P network and can install local packages — treat as state-changing, not read-only.
- Large replies may truncate in the inbox — pass a `limit` filter or use `/summary` for a synthesized digest.

---

## Polis Protocol: a learning agent team

A markdown-plus-two-scripts vendor-agnostic coordination protocol (Antigravity, Claude, Codex, Gemini share one `_polis/` folder). Unlike a passive board, it learns: a **bandit router assigns work by track record**, settled work files lessons that adjust future routing, and citizens can propose and vote on amendments to the protocol's own rules.

**Flow:**

1. **Found a polis** — scaffold with `python3 scripts/init_polis.py --project-root . --agent-id ... --vendor ... --tool ...`, pinning to a reviewed commit (use `--dry-run` first; init never overwrites).
2. **Register citizens** — each agent publishes a capability card (`_polis/citizens/`); work opens as a contract with `required_tags`, not a fixed role.
3. **Route by track record** — `polis route --polis-root _polis --contract _polis/contracts/open/your-task.md --explain` shows the score breakdown (history / self-rating / cost / availability / lessons). Agents reserve files (`polis reserve src/auth --as <citizen>`) so two agents never edit the same path; overlapping claims are rejected with the holder named.
4. **Settle, learn, amend** — `polis contract settle <id> --quality 5` files a lesson with bounded `routing_effect`; `polis reconcile` applies it; failures become guardrails future contracts inherit; rule changes go through amendment + vote.

**Notes:** routing quality depends on accurate capability cards and enough settled history; the protocol coordinates work but does not replace review/tests/explicit maintainer approval; multi-agent voting adds overhead for small tasks. External scripts are untrusted code — pin to a reviewed commit and `--dry-run` before allowing writes.