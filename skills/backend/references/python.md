# Python Backend: FastAPI & Django

## FastAPI

Async-first, type-driven APIs with automatic OpenAPI docs.

### Router pattern

```python
@router.get("/items/{item_id}", response_model=Item)
async def get_item(item_id: str) -> Item: ...

@router.get("/items", response_model=list[Item])
async def list_items() -> list[Item]: ...

@router.post("/items", status_code=status.HTTP_201_CREATED)
@router.delete("/items/{id}", status_code=status.HTTP_204_NO_CONTENT)
```

- Define Pydantic models (request/response) before handlers; they become the
  OpenAPI schema.
- Auth dependency: `current_user: User = Depends(get_current_user_required)`
  for required auth (raises 401); `Optional[User]` for optional auth.
- Use dependency injection for DB sessions, auth, and services.
- Use `Annotated[...]` types (FastAPI 0.100+) for modern DI style.
- Async SQLAlchemy 2.0 (`asyncpg`) + Alembic migrations; repository pattern for
  data access; connection pooling.
- Background tasks: `BackgroundTasks` for light work; Celery/Dramatiq for real
  queues (see `queues-and-jobs.md`).
- Security: OAuth2/JWT (python-jose/pyjwt), CORS config, rate limiting, input
  sanitization.
- Testing: pytest + pytest-asyncio, `TestClient`, factory_boy/Faker fixtures,
  pytest-mock for external services.
- Production: Uvicorn/Gunicorn config, Pydantic Settings for env config, Docker
  multi-stage builds, health checks, structured logging (loguru/structlog),
  OpenTelemetry tracing, Prometheus metrics.
- Docs: `/docs` (Swagger UI) is automatic — keep models and examples accurate.

## Django / DRF

Follow Django's "batteries included": use built-in features before third-party
packages.

### Architecture

- Modular apps by feature; environment-specific settings; service layer for
  business logic; repository pattern where it helps.
- Django 5.x: async views/middleware; ASGI deployment (Uvicorn/Daphne);
  Django Channels for WebSockets; Celery for background tasks.
- ORM: `select_related` (FK), `prefetch_related` (reverse/m2m) to prevent N+1.
  Annotate in viewsets, access in serializers (never `SerializerMethodField`
  that queries per object).
- Custom managers/querysets for reusable filters.
- Signals sparingly; prefer explicit service calls for clarity.

### API (DRF)

- Serializers define the API shape; validate input; `ModelViewSet` + `Router`
  for CRUD; paginate all list endpoints (enforce limits).
- Auth: `djangorestframework-simplejwt` for JWT with refresh tokens;
  `django-guardian` for object-level permissions; permission classes for RBAC.
- CORS, CSRF, XSS protections on by default — don't weaken them.
- Consistent JSON error format and HTTP status codes.

### Performance review (how to audit Django)

Research-first, report only provable findings. Priority order:
1. **N+1 queries** (CRITICAL) — related field accessed in a loop; fix in the
   view AND serializer. Validate: trace view → queryset → template/serializer.
2. **Unbounded querysets** (CRITICAL) — paginate; use `.iterator()` for large
   batch jobs.
3. **Missing indexes** (HIGH) — full-table scans on large tables.
4. **Write loops** (HIGH) — per-row writes cause lock contention; batch.
5. Inefficient patterns (LOW) — rarely worth reporting.
Zero findings is acceptable — don't manufacture issues.

### Access control review (IDOR)

- Understand the authorization model first: how is auth enforced (login
  required, mixins, permissions, custom managers, ownership fields)?
- Map the attack surface: resources + operations exposed.
- Trace specific flows: can user A access user B's object? Test `get_object`,
  querysets, and permission classes.
- Report findings with confidence levels; fixes must enforce access, not just
  document it.
- Investigation commands: find view base classes, custom managers, ownership
  fields, permission classes.

### Testing

- pytest-django + factory_boy; Django TestCase/TransactionTestCase/
  LiveServerTestCase; DRF APIClient; coverage.
- Test service/business logic, permission checks, and query counts.

## Sources

- `fastapi-pro`, `fastapi-router-py`, `django-pro`, `django-perf-review`,
  `django-access-review`, `pubmed-database`/`uniprot-database` (REST data APIs).