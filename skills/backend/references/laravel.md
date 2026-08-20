# Laravel / PHP Backend

## Role & scope

Senior Laravel engineering (Laravel 10/11+): production-grade, maintainable,
idiomatic solutions. Clean architecture, readability, testability, security,
performance, convention over configuration. Prefer Laravel-native solutions over
third-party packages; avoid unnecessary abstractions.

## Engineering principles

### Architecture
- Keep controllers thin; move business logic into Services.
- Use FormRequest for validation; API Resources for API responses.
- Use Policies/Gates for authorization; apply Dependency Injection.
- Avoid static abuse and global state.

### Routing
- Use route model binding; group routes logically; apply middleware properly;
  separate `web` and `api` routes.

### Validation
- Always validate input; never use `request()->all()` blindly.
- Prefer FormRequest classes; return structured validation errors for APIs.

### Eloquent & database
- Use `$guarded`/`$fillable` correctly (prevent mass assignment).
- Avoid N+1 with eager loading (`with()`).
- Prefer query scopes for reusable filters.
- Avoid raw queries unless necessary; use transactions for critical operations.

### API development
- Use API Resources; standardize JSON structure; proper HTTP status codes.
- Implement pagination; apply rate limiting.

### Authentication
- Use Laravel's native auth; prefer **Sanctum** for SPA/API tokens.
- Hash passwords securely; never expose sensitive data in responses.

### Queues & jobs
- Offload heavy operations to queues; use dispatchable jobs; ensure idempotency
  where needed (see `queues-and-jobs.md`).

### Caching
- Cache expensive queries; use cache tags if supported; invalidate properly.

### Views
- Escape user input (Blade auto-escapes); avoid business logic in views; use
  components for reuse.

## Anti-patterns to avoid

- Fat controllers; business logic in routes; massive service classes.
- Direct model manipulation without validation; blind mass assignment.
- Hardcoded configuration values; duplicated logic across controllers.

## Output standards

- Complete, production-ready examples with namespaces, strict types, PSR
  standards, proper return types, minimal meaningful comments.
- When reviewing: identify structural problems, suggest Laravel-native
  improvements, explain tradeoffs, provide refactored examples.
- Don't introduce microservices unless requested; keep solutions pragmatic.

## Sources

- `laravel-expert`.