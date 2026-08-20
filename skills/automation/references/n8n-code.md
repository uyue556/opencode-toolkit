# n8n Code Nodes (JavaScript & Python) and the Custom Code Tool

How to write safe, correct code inside n8n Code nodes and the AI-callable Custom Code Tool.
Two **different** runtimes with **different contracts** — the #1 source of bugs is confusing them.

## ToC
- [Code node vs Code Tool: the contracts](#code-node-vs-code-tool-the-contracts)
- [Code node: JavaScript](#code-node-javascript)
- [Code node: Python](#code-node-python)
- [Custom Code Tool](#custom-code-tool)

## Code node vs Code Tool: the contracts

| | Code node (`n8n-nodes-base.code`) | Custom Code Tool (`@n8n/n8n-nodes-langchain.toolCode`) |
|---|---|---|
| Invoked by | Previous node (workflow flow) | AI Agent (LangChain) |
| Input | `$input.all()` item stream | `query` (JS) / `_query` (Python) — string or object |
| Return | `[{json: {...}}]` items array | **A string** |
| `$fromAI()` | N/A | Not available (throws) |
| `this.helpers.httpRequest` | Yes | No |
| State / `$node` / `$json` | Yes | No |

## Code node: JavaScript

### Essentials

1. Choose **"Run Once for All Items"** mode for ~95% of use cases (aggregation, filtering, batch, transform).
   Use "Run Once for Each Item" only when each item needs independent handling.
2. Access data: `$input.all()`, `$input.first()` (single object), `$input.item` (Each Item mode), `$node["Node Name"].json`.
3. **Must return `[{json: {...}}]`** — array of objects with a `json` key. Returning a bare object, a string,
   or `$input.all()` without `.map()` breaks the workflow.
4. Webhook data is under **`.body`** (`$json.body.name`, not `$json.name`).
5. No `{{ }}` expression syntax inside code — use template literals: `` `${$json.field}` ``.

```javascript
const items = $input.all();
const total = items.reduce((sum, it) => sum + (it.json.amount || 0), 0);
return [{
  json: {
    total,
    count: items.length,
    average: items.length ? total / items.length : 0
  }
}];
```

### Built-ins

- `await $helpers.httpRequest({method:'GET', url, headers})` — HTTP calls from code.
- `DateTime` (Luxon): `DateTime.now().plus({days:7}).toFormat('yyyy-MM-dd')`.
- `$jmespath(data, 'users[?age >= `18`]')` — JSON queries.

### Top mistakes & fixes

1. Missing `return` → always return data (even `[]`).
2. `"{{ $json.field }}"` in code → use `` `${$json.field}` `` or direct access.
3. Returning an object not an array → wrap in `[{json: ...}]`.
4. No null checks → optional chaining `item.json?.user?.email || 'n/a'` or guard clauses.
5. Webhook `.body` nesting → `$json.body.field`.

### Best practices

- Prefer map/filter over manual loops; **filter early, transform late**.
- Use try/catch around HTTP calls; return an error object rather than throwing when possible.
- Debug with `console.log(...)` (browser console). Keep output structure consistent on every code path.
- Consider simpler nodes first: Set for field mapping, Filter for filtering, IF/Switch for conditionals,
  HTTP Request for plain API calls. Code node is for real logic, not these.

## Code node: Python

> **JavaScript first.** JS has full helpers (`$helpers.httpRequest`), Luxon, no external-library limits, and better
> docs — use Python only when you specifically need Python stdlib functions or are far more comfortable with it.

### Essentials

- Data access: `_input.all()`, `_input.first()`, `_input.item` (Each Item mode), `_node["Node Name"]["json"]`.
- **Must return `[{"json": {...}}]`** — list of dicts with a `json` key.
- Webhook data under `_json["body"]` (use `.get()`).
- **No external libraries** — `requests`, `pandas`, `numpy`, `bs4` all raise `ModuleNotFoundError`.
  Standard library only: `json`, `datetime`, `re`, `base64`, `hashlib`, `urllib.parse`, `math`, `random`, `statistics`.

```python
from datetime import datetime

items = _input.all()
total = sum(item["json"].get("amount", 0) for item in items)

return [{
    "json": {
        "total": total,
        "count": len(items),
        "timestamp": datetime.now().isoformat()
    }
}]
```

### Workarounds for missing libraries

- HTTP → use an **HTTP Request node** before/after the Code node, or switch to JavaScript.
- pandas/numpy → `statistics` module (`mean`, `median`, `stdev`), or manual list/dict math.
- BeautifulSoup → HTTP Request node + HTML Extract node, or JS with regex/string methods.

### Modes

Two Python variants: **Python (Beta)** (recommended — has `_input`, `_json`, `_node`, `_now`, `_jmespath()`) and
**Python (Native)** (`_items`/`_item` only, no helpers). Prefer Beta.

### Top mistakes & fixes

1. `import requests` → use HTTP Request node or JavaScript.
2. No return → always return a list.
3. `return {"json": ...}` (dict, not list) → wrap: `return [{"json": ...}]`.
4. `_json["user"]["name"]` KeyError → `_json.get("user", {}).get("name", "Unknown")`.
5. Webhook nesting → `_json.get("body", {}).get("email")`.

## Custom Code Tool

An AI-agent-invokable tool that looks like a Code node but has a **different runtime contract**:
**string in, string out.** If you treat it like a Code node, it fails.

### Rules

1. **Return a string.** Numbers auto-convert; objects/arrays throw "The response property should be a string, but it is an object".
   `return JSON.stringify({ result: 42 })` for structured output. NEVER return `[{json: ...}]` ("Wrong output type returned").
2. Input variable is fixed: `query` (JS), `_query` (Python). You can't rename it.
3. **No `$fromAI()`** in the sandbox — throws "No execution data available".
4. **No `$input`/`$json`/`$binary`/`$helpers`/`$node`/`getContext`** — it's for pure computation only.
   `DateTime` (Luxon) IS available.
5. Tool **name**: verb-y, snake_case, `[A-Za-z0-9_]+` (e.g. `calculate_car_loan`). The agent calls it by name.
6. Tool **description**: state when to use it; if unstructured mode, include an example JSON string the LLM should send.
   These two fields ARE the prompt — write them like API docs.

### Input modes (`specifyInputSchema`)

- **Unstructured** (default): AI sends one string as `query`. Parse JSON yourself with try/catch and instructive errors.
- **Structured** (`specifyInputSchema: true`): the tool becomes a `DynamicStructuredTool`; LLM passes a schema-validated
  object. Define via `schemaType:"fromJson"` + `jsonSchemaExample`, or `schemaType:"manual"` + `inputSchema`.
  Best for multi-typed-parameter production tools (the LLM tends to stringify numbers).

### Errors go back to the LLM (use that)

Throw or return an error string that tells the model what went wrong and what a valid call looks like:
`throw new Error('price must be a number, e.g. 439900')`. The agent usually corrects and retries.

### Sandbox limitations → pick the right tool

- Pure computation → **Code Tool**.
- HTTP calls / multi-step logic / full sandbox / `$fromAI` → **`toolWorkflow`** (Call Sub-workflow Tool).
- Single API call with per-param `$fromAI` → **HTTP Request Tool**.

Rule of thumb: if you find yourself wanting `$fromAI()` inside the code, you want `toolWorkflow`, not `toolCode`.

### Checklist

Node type is `@n8n/n8n-nodes-langchain.toolCode` (not `nodes-base.code`); descriptive name; description with usage +
example; read input from `query`/`_query`; no `$fromAI`/`$input`/`$helpers`; return a string; wired into an AI Agent
via `ai_tool`; tested with the exact input shape the LLM will send.
