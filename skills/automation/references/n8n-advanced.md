# n8n Sub-workflows, Error Handling, Binary Data, Multi-instance

The parts that separate reliable production workflows from demo ones: reusable sub-workflows, loud-and-recoverable
failures, file/binary handling, and safely working across multiple n8n instances.

## ToC
- [Sub-workflows](#sub-workflows)
- [Error handling](#error-handling)
- [Binary & file data](#binary--file-data)
- [Multiple n8n instances over MCP](#multiple-n8n-instances-over-mcp)

## Sub-workflows

A sub-workflow is a reusable function: an **Execute Workflow Trigger** declares typed inputs, the body does the work,
the last node returns output, and callers invoke it via an **Execute Workflow** node. It's the primary reuse
mechanism in n8n — without it, identical logic gets copy-pasted and quietly drifts apart.

### Should this be a sub-workflow?

```
Could this be needed in another workflow?      → Yes → extract.
Is it a generic concern (auth, retry, parsing)? → almost always extract.
Is it >5 nodes and conceptually one thing?      → probably extract.
Is it one HTTP call with no logic?              → don't (a boundary for nothing).
Tightly coupled to one caller's data shape?     → fix the data shape first.
```

Extraction buys readability (caller shows one node), testability (`n8n_test_workflow` with pinned input), and
replaceability. A 20-node workflow is fine if it's mostly linear Execute Workflow calls; 15+ inline-transform nodes is not.

### The two non-negotiables

1. **Search before you build.** `n8n_list_workflows()` + `n8n_get_workflow({id})`. The name is the discovery surface
   (MCP can't filter by tag) — use verb-first prefixes: `Subworkflow:`, `<Domain>:`, `Tool:`.
2. **Use "Define Below" with typed fields, not passthrough.** Passthrough has no schema → agents can't fill params and
   structured callers have nothing to bind. Exceptions: **binary input** (typed fields are JSON-only) and **zero inputs**
   (Define Below needs ≥1 field — start the body with a "Keep Only Set" node noting no inputs expected).

### Inputs/outputs as a contract

- Typed inputs: `workflowInputs.values` entries with `name` + `type` (`string`, `number`, `boolean`, `array`, `object`).
  Read them in the body as `$json.<name>`.
- Document inputs/outputs in the workflow `description` — it's what `n8n_list_workflows` matches against.
- **Return natural shapes, not storage shapes** (arrays as arrays, dates as ISO strings, regardless of how stored).
- **Return errors, don't always throw:** expected failures (parse error, not-found) return `{ ok: false, error: "..." }`
  so callers branch without an error output; reserve throwing for genuinely unexpected failures.
- **The contract is frozen once it has callers.** Adding optional fields is safe; renaming/removing is a **silent break**
  (n8n won't error on an unrecognized input — the body just sees `undefined`). Migrate every caller in the same change.
- Shape output with a final **Set node named `Return`** — the one legitimate trailing-Set exception, making the API visible.

### Calling sub-workflows

- **`mode`: `all` vs `each`.** For a body that assumes exactly one item (per-run aggregation, "this is THE customer"),
  use `mode: each` — it iterates per input item. `all` hands the body all N items at once and breaks that assumption.
  Prefer `mode: each` over an internal Loop Over Items.
- **`waitForSubWorkflow`** defaults to `true` (caller blocks, continues with output). `false` = fire-and-forget:
  `mode: each` + `waitForSubWorkflow: false` is **the only true parallelization n8n offers** — N runs execute
  concurrently, but the caller never knows when they finish. Only useful with a completion-tracking mechanism
  (a Data Table the sub-workflow updates).

### Splitting by input shape (N+1 pattern)

When input contracts genuinely differ (binary vs JSON, sync vs async, divergent auth), don't cram them under one
passthrough trigger + internal Switch. Build **N+1 sub-workflows**: one outer per contract doing input-specific prep,
all calling one shared downstream with a normalized shape.

### Sub-workflow as an agent tool

A typed Define Below trigger doubles as an agent tool (agent fills fields via `$fromAI`). Zero-input works (the only
decision is whether to invoke); binary does not wire cleanly as a tool.

### Anti-patterns

Duplicating logic in 3 workflows → extract once. Building without searching → duplicates grow. Passthrough when not
binary/zero-input → no schema, use Define Below. Name like `Helper 3` → verb-first prefix. `mode: all` on a
single-item body → use `each`. No `description` → won't be found. Renaming a live field without migrating callers →
silent `undefined`. 30-node workflow → extract sections.

## Error handling

Default: when a node throws, the **whole workflow halts** — fine for interactive runs, wrong for anything unattended
(webhook API, cron, queue worker, agent tool): the caller gets a timeout/500, the operator gets no alert.

| Workflow shape | Error posture |
|---|---|
| Webhook/API (with Respond to Webhook) | **Required.** Every fallible node's error output wired; status code matches cause. |
| Scheduled/cron/queue/agent tool (unattended) | **Required.** A workflow-level error workflow, plus `retryOnFail` on network nodes. |
| Internal one-off you watch yourself | Optional — default `stopWorkflow` is fine. |

**The #1 silent trap — per-node error output is a TWO-step setup:**

1. Set `onError: "continueErrorOutput"` on the node (this creates the second output).
2. Wire that error output (`connections.<node>.main[1]`, `sourceIndex: 1`) to a real handler.

Doing only one is worse than none: `onError` set but output unwired → error data silently discarded, run shows as
**succeeded**. Output wired but `onError` not set → slot never fires, workflow halts. This half-wired state does NOT
surface in `validate_workflow` — verify with `n8n_get_workflow` that both halves exist.

`onError` values: `stopWorkflow` (default), `continueRegularOutput` (rare, usually wrong), `continueErrorOutput` (the one to wire).

### Self-healing first: retryOnFail

Before building error branches, absorb transient failures on **any network-calling node** (HTTP, Gmail/Slack/Discord,
DBs, AI nodes): `retryOnFail: true, maxTries: 3, waitBetweenTries: 5000`. A 429 or upstream hiccup retries and
succeeds on its own; the error output then fires only on real, persistent failures. Limits: retry fires on any error
(no per-status filter), `maxTries` caps at 5, `waitBetweenTries` caps at 5000ms.

### API workflows: the canonical shape

Webhook-triggered workflows that respond to their caller have one overriding rule: **no hanging branches**. Every
path — success and error — must end at a `Respond to Webhook`, or the caller waits until timeout.

- Fan in many fallible nodes' `main[1]` to ONE error Respond node.
- **Validation failures (4xx) are decided upstream** with IF/Switch or a Set-node schema validator, not via error outputs.
  Error outputs are for unexpected failures (5xx).
- **`responseCode` defaults to 200 — even on error branches.** An error branch returning 200 looks like success to the
  caller's client. Set `responseCode` explicitly on every error Respond.

### Map cause → status code

| Cause | Status | `error` code | Where handled |
|---|---|---|---|
| Required field missing / wrong type | 400 | `validation_error` | Upstream check |
| Auth missing/invalid | 401 | `unauthorized` | Upstream check |
| Authenticated but not allowed | 403 | `forbidden` | Upstream check |
| Resource absent | 404 | `not_found` | Branch on the lookup result |
| State conflict (duplicate, race) | 409 | `conflict` | Detect with logic |
| Rate limited | 429 | `rate_limit_exceeded` | Set `Retry-After` |
| Node threw, cause unknown | 500 | `internal_error` | Error output |
| Third-party API error | 502 | `upstream_error` | HTTP node error output |
| Downstream down | 503 | `service_unavailable` | Detect specific error |
| Upstream timeout | 504 | `upstream_timeout` | Error output filtered by message |

Use a single expression-driven Respond when paths differ only by code/message — compute the code inline from
`$json.error.message` (400 on `INVALID_ID`, 429 on rate limit, 504 on timeout, 502 on upstream/llm/api, else 500).
Body envelope: `{ "error": "<code>", "message": "<human text>" }`. **Never leak** stack traces, SQL, upstream bodies,
or tokens into the response — log privately, return sanitized messages.

### Workflow-level error workflow (the catch-all)

Per-node outputs catch what you anticipated. An **error workflow** (separate workflow starting with an **Error Trigger**)
catches everything else — unwired nodes, crashes between nodes, whole-workflow timeouts. Minimal: `Error Trigger → Set
(build alert) → Slack/email`. A good alert includes workflow name, links to editor + failed execution, failed node, and
the real error message.

Two traps: (1) **recursion** — if the error workflow notifies on the same channel that's down, it fails too and the
original error vanishes; notify on a *different* channel and add a Data Table fallback. (2) a "handled" error won't
bubble up — if a wired error output drops the data, n8n considers it handled and the error workflow does NOT fire.

> Assigning the error workflow is a **UI setting** (Workflow Settings → Error Workflow) — no MCP tool exists for it.
> Build it with MCP, then hand the user the exact UI step.

### Anti-patterns (quick)

`onError` set but unwired → silent discard. Wired but no `onError` → halts. No error branch on webhook → caller timeout.
200 with error body → caller reads success. One 500 for everything → caller can't distinguish. Catching errors in a Code
node and returning them as data → downstream processes error-shaped data. Network node without retryOnFail → alert noise.
No error workflow on unattended jobs → failure goes nowhere.

## Binary & file data

Every n8n item has two independent slots: **`$json`** (structured data) and **`$binary`** (file bytes). They travel
side by side. File contents — the PDF, image, zip — live in `$binary`, never `$json`.

### Three rules that prevent 90% of binary bugs

1. **File contents are in `$binary.<key>`, not `$json`.** After HTTP download, Read Files, or an email-attachment
   trigger, bytes are in `$binary`. Reading `$json.data` for file contents gives you nothing.
2. **Binary cannot cross the AI-agent tool boundary — in either direction.** Tool args and returns are JSON only.
   Pre-stage to storage and pass a key/URL through JSON.
3. **Chat surfaces render images by URL, not by `$binary`.** Slack/Discord/Teams/Telegram don't read the binary slot;
   the image must live somewhere a URL can fetch (user's object storage or drive — n8n ships no CDN). Signed URLs with
   expiry for sensitive content.

### Producing & reading binary

- HTTP download: set `responseFormat: "file"` or bytes arrive as garbled text in `$json`.
- Most nodes have a `binaryPropertyName` — producer names the slot, consumer references it. Default key: `data`.
- In a Code node, read with `this.helpers.getBinaryDataBuffer(0, 'data')` (itemIndex, propertyName) — don't hand-decode
  base64. Write by building the slot: `{ data: Buffer.from(text).toString('base64'), mimeType, fileName, fileExtension }`.
- **A Code node returning `[{json:{...}}]` without re-attaching `binary` silently drops the file.** Return
  `binary: $input.item.binary` explicitly.

### Keeping binary alive across transforms

JSON-only nodes (Edit Fields, Code, IF) can drop `$binary`. Two fixes: pass-through option on the transforming node
(`includeOtherFields`), or **fan out and Merge by position** — route the source into both the transform and a bypass
branch, recombine with `Merge` in `combineByPosition` mode (field counts must line up).

### The agent-tool binary boundary

Inbound (user upload → agent tool must operate on it): split out `files[]`, upload each to private storage under a
hashed key, re-merge before the agent, set `executeOnce: true` so N files don't trigger N agent runs, inject keys +
original names into the system prompt ("use EXACTLY this key"), tool downloads by key.
Outbound (tool generates a file → agent returns): tool uploads, returns `{ ok: true, key, url, mimeType }`, agent embeds
the URL. `passthroughBinaryImages: true` only changes what the LLM *sees* (vision, images only) — not a tool channel.

## Multiple n8n instances over MCP

When `n8n_instances` is available, one MCP connection can reach several instances (prod/staging/one per client).
Every other tool runs against **whichever instance this session is currently targeting** — there's no per-call
instance argument. A misroute usually returns wrong data or `NOT_FOUND` with **no error**.

Golden rules:
1. **Discover first**: `n8n_instances({mode:"list"})` → `{ current, default, available }`. Match by name, never hard-coded id.
2. **Switch by name**: `n8n_instances({mode:"switch", name:"<instance>"})`.
3. **Switch in its own turn** — never batch `switch` with a dependent operation (no ordering guarantees in one batch).
4. **Verify before high-stakes ops** (credential create/update/delete, destructive edits): re-`list`, confirm `current`.
5. **Unexpected `NOT_FOUND` is usually a wrong-instance misroute, not a deletion** — re-check instance, don't recreate.
6. **`INSTANCE_AMBIGUOUS`** (credential write when this session never switched itself): run `switch` on THIS session to
   confirm the target, then retry. Don't work around it.

If the selected instance is deleted mid-session, the next call silently falls back to the default instance — re-`list`
to see where you are. Copy-between-instances: switch→A, read; switch→B (own turn); list to confirm; create.
