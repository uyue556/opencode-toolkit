# API integration patterns

Merged from `frontend/frontend-api-integration-patterns`, `web-development/react-ui-patterns`,
`web-development/ux-feedback`, and `web-development/angular` (interceptors).

## Core API client

- One typed client per service, wrapping `fetch`. Standard shape:
  ```ts
  class ApiClient {
    constructor(private base: string, private token?: () => string | null) {}
    private async request<T>(path: string, init?: RequestInit): Promise<T> {
      const res = await fetch(`${this.base}${path}`, {
        ...init,
        headers: { "content-type": "application/json", ...(init?.headers ?? {}), ...(this.token() ? { authorization: `Bearer ${this.token()}` } : {}) },
      });
      if (!res.ok) throw new ApiError(res.status, await res.json());
      return res.json() as T;
    }
    get<T>(path: string, signal?: AbortSignal) { return this.request<T>(path, { method: "GET", signal }); }
  }
  ```
- Never use the raw global fetch in components; route through the client (headers,
  error normalization, cancellation, retries all live in one place).
- Angular: same logic as an `HttpInterceptor` + HttpClient.

## Errors

```ts
class ApiError extends Error {
  constructor(readonly status: number, readonly payload: unknown) { super(`API ${status}`); }
}
const isApiError = (e: unknown): e is ApiError => e instanceof ApiError;
```

- Normalize backend error shapes into a typed `ApiError`; map 4xx → user messages,
  5xx → "server hiccup, retry".
- **Don't retry 4xx** (client bugs). Retry 5xx/network with exponential backoff + jitter.
- Never swallow errors: log, surface inline next to the action, offer retry.

## Race conditions & cancellation

- Pass an `AbortSignal` to every request; abort on unmount / when the value is superseded.
- Track in-flight requests and dedupe identical ones (per key):
  ```ts
  const inflight = new Map<string, Promise<unknown>>();
  function requestDeduped<T>(key: string, make: () => Promise<T>): Promise<T> {
    if (!inflight.has(key)) inflight.set(key, make().finally(() => inflight.delete(key)));
    return inflight.get(key)! as Promise<T>;
  }
  ```
- **Guard stale responses**: tag requests (sequence number or request token); ignore
  responses that aren't the latest (search-as-you-type). Also `AbortController.abort()`
  the previous request on new input.
- Debounce search inputs (300ms) and `useDeferredValue`/React 19 `useTransition` for
  high-frequency text updates.

## Retry & backoff

```ts
async function withRetry<T>(fn: () => Promise<T>, { retries = 3, base = 300, max = 10_000 } = {}) {
  for (let i = 0; ; i++) {
    try { return await fn(); } catch (e) {
      if (i >= retries || (isApiError(e) && e.status < 500)) throw e;
      await new Promise(r => setTimeout(r, Math.min(base * 2 ** i, max) + Math.random() * 250));
    }
  }
}
```

## Loading / error / empty / success

- Four states per surface — full table in `state-management.md`. Golden rule:
  `if (loading && !data)` (no spinner when stale data is cached).
- Skeletons sized to the real layout (reserve height) instead of spinners for above-fold.
- Empty states: explain why + primary next step.
- Errors: inline near the action, visible message, retry button, never only console.

## Optimistic updates & invalidation

- Mutations: optimistic apply → server → rollback on failure + toast the error.
- Invalidate related queries after mutations (React Query key factory — `state-management.md`).
- Disable buttons during mutation (`useFormStatus`, `pending` flag). Handle double-submit.

## Cross-cutting

- Set sensible timeouts per request; AbortController doubles as a timeout.
- Sensitive data: only what the client needs; never log tokens; tokens in `Authorization`
  header, not in URLs.
- Uploads: progress events, chunking for large files, cancel support.
- WebSockets/SSE: reconnect with backoff, resume state, batch messages.

## Common pitfalls

| Pitfall | Fix |
|---|---|
| Raw `fetch` everywhere | One ApiClient |
| Stale response overwrites new | Abort + sequence guard |
| Duplicate parallel requests | Dedup map by key |
| Retrying 4xx | Retry only 5xx/network |
| No timeout | AbortSignal timeout |
| Spinner flash on refetch | `if (loading && !data)` |
