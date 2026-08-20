---
name: database-category-pointer
description: "Pointer to a library of 16 specialized Database skills. Use when working on database-related tasks."
risk: none
---

# Database Capability Library 🎯

This is a **pointer skill**. The 16 specialized Database skills are stored in a hidden vault to keep your startup context minimal.

## Available skills in this category

- **database-cloud-optimization-cost-optimize** — You are a cloud cost optimization expert specializing in reducing infrastructure expenses while maintaining performance and reliability. Analyze cloud spending, identify savings opportunities, and implement cost-effective architectures across AWS, Azure, and GCP.
- **database-migration** — Master database schema and data migrations across ORMs (Sequelize, TypeORM, Prisma), including rollback strategies and zero-downtime deployments.
- **database-migrations-migration-observability** — Migration monitoring, CDC, and observability infrastructure
- **database-migrations-sql-migrations** — SQL database migrations with zero-downtime strategies for PostgreSQL, MySQL, and SQL Server. Focus on data integrity and rollback plans.
- **drizzle-orm-expert** — Expert in Drizzle ORM for TypeScript — schema design, relational queries, migrations, and serverless database integration. Use when building type-safe database layers with Drizzle.
- **neon-postgres-branches** — Choose and create the right Neon branch type for testing and development. Use when users ask about Neon branching, migration testing with real data, isolated test environments, schema-only branch workflows for sensitive data, or branch creation via Neon CLI or Neon MCP. Triggers...
- **neon-postgres-egress-optimizer** — Diagnose and fix excessive Postgres egress (network data transfer) in a codebase. Use when a user mentions high database bills, unexpected data transfer costs, network transfer charges, egress spikes, "why is my Neon bill so high", "database costs jumped", SELECT * optimization, query...
- **nosql-expert** — Expert guidance for distributed NoSQL databases (Cassandra, DynamoDB). Focuses on mental models, query-first modeling, single-table design, and avoiding hot partitions in high-scale systems.
- **postgres-best-practices** — Postgres performance optimization and best practices from Supabase. Use this skill when writing, reviewing, or optimizing Postgres queries, schema designs, or database configurations.
- **postgresql** — Design a PostgreSQL-specific schema. Covers best-practices, data types, indexing, constraints, performance patterns, and advanced features
- **postgresql-cli** — PostgreSQL interactive terminal (psql) reference and usage guide. Use this skill whenever the user mentions psql, PostgreSQL command-line client, backslash commands, meta-commands, \d commands, database inspection, SQL scripting in PostgreSQL, importing/exporting data with psql, \copy,...
- **prisma-expert** — You are an expert in Prisma ORM with deep knowledge of schema design, migrations, query optimization, relations modeling, and database operations across PostgreSQL, MySQL, and SQLite.
- **saas-multi-tenant** — Design and implement multi-tenant SaaS architectures with row-level security, tenant-scoped queries, shared-schema isolation, and safe cross-tenant admin patterns in PostgreSQL and TypeScript.
- **sql-optimization-patterns** — Transform slow database queries into lightning-fast operations through systematic optimization, proper indexing, and query plan analysis.
- **sqlmap-database-pentesting** — Provide systematic methodologies for automated SQL injection detection and exploitation using SQLMap.
- **supabase-postgres-best-practices** — Postgres performance optimization and best practices from Supabase. Use this skill when writing, reviewing, or optimizing Postgres queries, schema designs, or database configurations.

## How to load a skill

1. Identify the skill name above matching your task.
2. Use `view_file` to read its `SKILL.md` from the vault:
   `/home/administrator/.config/opencode/skill-libraries/database/<skill-name>/SKILL.md`
3. Follow those instructions to complete the request.

**Vault path:** `/home/administrator/.config/opencode/skill-libraries/database`

> Do not guess best practices — always read from the vault first.

> ⚠️ **Anti-loop guard**: Do NOT invoke skills recursively or check for applicable skills before every response. Each skill should be loaded at most once per user request. If you have already identified and loaded the relevant skill for this task, proceed with execution — do not re-scan for skills.
