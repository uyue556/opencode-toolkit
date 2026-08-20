# .NET Backend: ASP.NET Core

## Stack

- Frameworks: ASP.NET Core 8+ — controller-based or Minimal APIs.
- ORM: Entity Framework Core 8+ (or Dapper).
- Databases: SQL Server, PostgreSQL, MySQL.
- Auth: ASP.NET Core Identity, JWT, OAuth 2.0, Azure AD.
- Background: `IHostedService` / `BackgroundService`, Hangfire, Quartz.NET.
- Real-time: SignalR. Testing: xUnit/NUnit, Moq, FluentAssertions.
- Validation: FluentValidation or Data Annotations.
- APIs: RESTful, gRPC, GraphQL (HotChocolate).

## Patterns

### Minimal API + EF Core

```csharp
var builder = WebApplication.CreateBuilder(args);
builder.Services.AddDbContext<AppDbContext>(o =>
    o.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));
builder.Services.AddAuthentication().AddJwtBearer();
builder.Services.AddAuthorization();

var app = builder.Build();
app.MapPost("/api/users", async (CreateUserRequest req, AppDbContext db) => {
    // validate, hash password, create user, save
    return Results.Created($"/api/users/{user.Id}", new UserResponse(user));
}).WithName("CreateUser").WithOpenApi();
app.Run();
```

### Controller-based API

`[ApiController]`, `[Route("api/[controller]")]`, inject `DbContext` + `ILogger`.
Use `AsNoTracking()` for read-only queries and project with `Select(...)` to
DTOs to avoid over-fetching.

### JWT

Generate tokens with `JwtSecurityToken` + `HmacSha256`, issuer/audience/claims,
short expiry (1h). Configure validation with `AddJwtBearer()`, matching
`Issuer`, `Audience`, and signing key with what you sign with.

### Background service (IHostedService)

Create a scope per iteration (`IServiceProvider.CreateScope()`), fetch a batch
of work, process, save, delay. Handle `CancellationToken` for graceful shutdown.

## Best practices

- Async/await for all I/O; DI everywhere.
- Configuration via `appsettings.json`; User Secrets for local dev; env vars in
  production.
- EF Core migrations (`Add-Migration`, `Update-Database`).
- Global exception handling middleware; structured logging (Serilog);
  health checks (`AddHealthChecks`).
- API versioning; Swagger/OpenAPI; AutoMapper for DTO mapping.
- CQRS with MediatR for complex domains.
- Output caching (.NET 8+); response compression; connection pooling.
- Policy-based / role-based / claims-based authorization; custom handlers for
  fine-grained rules.

## Assumptions & limits

- Assumes modern .NET (ASP.NET Core 8+); older .NET Framework needs different
  patterns. Does not cover frontend or provider-specific cloud deployment unless
  requested.

## Sources

- `dotnet-backend`, `dotnet-backend-patterns`.