# API Documentation, OpenAPI, Postman & SDKs

Documentation is a product. It reduces support burden, drives adoption, and is
only useful if it stays in sync with code. Keep docs as close to code as
possible (generate from annotations/specs, validate examples with tests).

## OpenAPI / Swagger spec generation

### Workflow

1. **Gather context**: OpenAPI 3.x vs Swagger 2.0, YAML vs JSON, what the API
   does, endpoint list (or extract from code), auth types, data models, any
   existing partial spec to extend.
2. **Build the spec** — always produce a complete, valid spec (no `# TODO`
   placeholders). Structure: `openapi`, `info`, `servers`, `tags`, `paths`,
   `components`.
3. **Extract from code** automatically when source is provided:
   - Express/Koa/Fastify: `.get()/.post()/...` calls, `:param` → `{param}`,
     `authenticate` middleware → security requirement.
   - FastAPI/Flask: decorators + Pydantic models → schemas.
   - Spring Boot: `@GetMapping` etc. + DTOs.
   - DRF: ViewSets + Serializers.
   - Rails: routes + strong params.

### Spec quality rules

- Use `$ref` for any schema used more than once (`components/schemas`).
- Every schema/response body gets an `example` or `examples`.
- Mark required fields with the `required` array.
- Prefer `format`: `int32`, `int64`, `date`, `date-time`, `uuid`, `email`,
  `uri`, `byte`, `binary`.
- Include a `PagedResult` pattern for paginated endpoints and a standard
  `Error` schema (`code`, `message`, optional `details`).
- Document security schemes: Bearer JWT, API key (header — never in query,
  leaks into logs), OAuth 2 flows, Basic (HTTPS only), OpenID Connect.
  Apply security globally, override per-operation where it differs.
- Path params always `required: true`; document query defaults & enums.

### Response codes to always include

`200/201/204` (success), `400`, `401`, `403`, `404`, `409`, `422`, `429`,
`500`. `$ref` the shared error responses to avoid repetition.

### Quality checklist

- [ ] `openapi`/`swagger` version present
- [ ] Every path has ≥1 operation with a unique camelCase `operationId`
- [ ] Every operation has a success response; 4xx and 5xx defined
- [ ] All `$ref` targets exist in `components/`
- [ ] Security schemes defined AND applied
- [ ] ≥1 example per schema/response body
- [ ] No orphaned schemas (everything referenced)

## API docs content structure

1. Introduction (what, base URL, version, contact)
2. Authentication (how, token management, security best practices)
3. Quick Start (working example, common use case)
4. Endpoints (grouped by resource)
5. Data models (schemas, field descriptions, validation rules)
6. Error handling (code reference, response format, troubleshooting)
7. Rate limiting (limits, headers, handling 429)
8. Changelog (versions, breaking changes, deprecations)
9. SDKs & tools (client libraries, Postman collection, OpenAPI spec)

Rules: consistent format across endpoints, realistic example data (not
"foo"/"bar"), document every error case, mark required vs optional, keep
examples tested and in sync.

## Postman collections

Generate import-ready Postman Collection v2.1 JSON:

```json
{
  "info": {
    "name": "My API",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json",
    "_postman_id": "<uuid>",
    "description": ""
  },
  "variable": [{ "key": "base_url", "value": "https://api.example.com", "type": "string" }],
  "item": []
}
```

- Parse from cURL: `-X` → method, `-H` → header, `-d` → body, `-u` → basic auth,
  `--bearer` → bearer.
- Use `{{base_url}}` and `{{token}}` variables; never hardcode hosts/tokens.
- Group related endpoints into folders.
- Emit a companion Postman Environment JSON (`base_url`, `api_key`, ...).
- Quality gates: valid JSON, every request has method+url+header, tokens as
  variables.

## SDK generation

Client SDK structure (any language): base `client` (base URL, auth, retry) +
one file per resource + models + typed error classes + utils (retry, pagination).

Rules:
- Retry with exponential backoff on 429 and 5xx, honoring `Retry-After`.
- `User-Agent` header identifying SDK name/version.
- Typed models (dataclasses in Python, interfaces in TS, structs in Go).
- Resource classes mirror the API resource hierarchy.
- Provide a usage example for every generated class.
- Map HTTP errors to typed exceptions: `AuthenticationError` (401),
  `AuthorizationError` (403), `NotFoundError` (404), `ValidationError` (422),
  `RateLimitError` (429), `ServerError` (5xx).

## Developer onboarding / time-to-first-call (TTFAC)

TTFAC = time from first interaction to first successful API response. It is the
most predictive metric for adoption.

- **Auth is the #1 friction.** Give test API keys immediately, pre-fill examples,
  delay production requirements (payment/identity) until later.
- **Sandbox**: instant access, realistic behavior, clear `sk_test_`/`sk_live_`
  key prefixes, pre-populated test data, magic values that always succeed/decline,
  generous (or zero) rate limits.
- **Interactive docs**: "Try it" with real (not mocked) responses, pre-auth with
  sandbox key, copy-as-cURL.
- **Recover failures**: error responses with `recovery.steps` and links; clear
  messages like "API key should start with 'sk_test_'".
- **Measure**: track signup → key created → first call → first success; find
  drop-off points; audit the first-call experience quarterly.

Tools: Swagger UI / Redoc / Stoplight Elements for interactive docs; ReadMe /
Postman Published Docs for portals; k6 / Checkly for monitoring.

## Sources

- `openapi-spec-generator`, `api-documentation-generator`, `api-documenter`,
  `postman-collection-generator`, `api-sdk-generator`, `api-onboarding`,
  `api-integration/openapi-spec-generation`.