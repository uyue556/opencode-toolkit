# Data Engineering

Synthesized from: `data-engineer`, `data-engineering-data-pipeline`, `spark-optimization`,
`dbt-transformation-patterns` (+ playbook), `snowflake-development`, `data-quality-frameworks`,
`warehouse`, `database-cloud-optimization-cost-optimize`.

## ToC

1. [Pipeline architecture & ingestion](#pipeline-architecture--ingestion)
2. [Orchestration](#orchestration)
3. [Storage: lakehouse patterns](#storage--lakehouse-patterns)
4. [dbt transformation patterns](#dbt-transformation-patterns)
5. [Data quality framework](#data-quality-framework)
6. [Spark optimization](#spark-optimization)
7. [Snowflake development](#snowflake-development)
8. [Monitoring & cost](#monitoring--cost)

## Pipeline architecture & ingestion

1. Define sources, SLAs, and data contracts before building.
2. Choose the pattern: ETL (transform before load), ELT (load then transform), Lambda (batch + speed
   layers), Kappa (stream-only), Lakehouse (unified ACID).
3. Ingestion — batch: incremental loading with watermark columns, retry with exponential backoff,
   schema validation + dead-letter queue for invalid records, metadata tracking (`_extracted_at`, `_source`).
   Streaming: exactly-once semantics, manual offset commits inside transactions, windowing for
   time-based aggregations, replay capability.
4. Validate data before writing to production sinks; protect PII with least-privilege access.

## Orchestration

- **Airflow**: task groups, XCom for inter-task communication, SLA monitoring, `execution_date` for
  incremental runs, retries with backoff.
- **Prefect**: task caching for idempotency, parallel `.submit()`, artifacts for visibility, auto-retries.
- Alternatives: Dagster (asset-based), Azure Data Factory, Step Functions, Kubernetes CronJobs/Argo.

## Storage / lakehouse patterns

- **Delta Lake**: ACID via append/overwrite/merge; upsert with predicate matching; time travel;
  optimize (compact small files, Z-order); vacuum old files.
- **Apache Iceberg**: partitioning + sort-order optimization; `MERGE INTO` upserts; snapshot isolation;
  binpack compaction; snapshot expiration.
- File sizing: 512MB–1GB Parquet files; partition by date/entity but avoid over-partitioning (>1GB/partition).

## dbt transformation patterns

- Medallion layers: `sources → staging → intermediate → marts`.
  Naming: `stg_`, `int_`, `dim_`/`fct_`.
- Materializations: staging = view (light cleaning), intermediate = ephemeral (business logic),
  marts = table/incremental.
- Incremental strategies: `delete+insert` (default), `merge` (late-arriving data, set
  `merge_update_columns`), `insert_overwrite` (partition-based, BigQuery). Always guard `is_incremental()`.
- Source definitions: `loaded_at_field` + freshness `warn_after`/`error_after`; column tests
  (unique/not_null/relationships), model-level recency tests.
- Extract repeated logic into macros (`cents_to_dollars`, `limit_data_in_dev`); avoid hardcoded dates
  (`{{ var('start_date') }}`); test in dev target, deploy via `dbt build`.
- Commands: `dbt run --select +model`, `dbt test`, `dbt build`, `dbt docs generate`, `dbt compile`.

## Data quality framework

- **Great Expectations**: table-level (row count, column count) + column-level (uniqueness,
  nullability, type, value sets, ranges) expectations; checkpoints to run validation; Data Docs;
  failure notifications.
- **dbt tests**: schema tests in YAML + custom tests with `dbt-expectations`.
- **Data contracts**: agree critical datasets, quality dimensions, ownership, alerting, and remediation
  before automating validation in CI/CD.
- Don't block critical pipelines without a fallback plan; handle sensitive data securely in validation outputs.

## Spark optimization

Key levers:

- Execution model: Job → Stages (separated by shuffles) → Tasks (one per partition). Minimize wide
  transformations; right-size partitions (128–256MB).
- Enable **AQE** (`spark.sql.adaptive.enabled`, `coalescePartitions`, `skewJoin`).
- Joins: broadcast small tables (<10–50MB), sort-merge for large, bucketed joins to avoid shuffle,
  salting for skew (`F.concat(key, "_", salt)`), `skewedPartitionFactor`.
- Caching: `persist(MEMORY_AND_DISK)` for reused DataFrames; `unpersist()` when done; checkpoint to
  break long lineage.
- Memory: `spark.memory.fraction=0.6`, `storageFraction=0.5`, `memoryOverhead` for non-JVM;
  Kryo serializer; Arrow for pyspark.
- Formats: Parquet/Delta with snappy + 128MB row groups; predicate pushdown + column pruning;
  `OPTIMIZE ... ZORDER BY` for multi-dim filters.
- Shuffle: `shuffle.partitions` tuned (≈200 default), pre-aggregate locally before shuffle,
  `approx_count_distinct` instead of `distinct().count()`.
- Debug: `df.explain("extended"|"cost")`, check partition skew (max/avg ratio >2x), monitor Spark UI
  for spills/GC. Don't collect large data, don't use UDFs when built-ins exist.

## Snowflake development

- SQL: `snake_case`, no double-quoted identifiers, CTEs over nested subqueries, explicit column lists
  (never `SELECT *`), idempotent `CREATE OR REPLACE`.
- Stored procedures: variables need the `:` prefix inside SQL (`:var`) or Snowflake raises
  "invalid identifier".
- Semi-structured: VARIANT with casts (`src:price::NUMBER(10,2)`); `STRIP_NULL_VALUE = TRUE`; `LATERAL FLATTEN`.
- Pipelines: Dynamic Tables (declarative — default; set `TARGET_LAG`; incremental DTs can't depend on
  full-refresh DTs), Streams+Tasks (imperative CDC; tasks start SUSPENDED — `ALTER TASK ... RESUME`),
  Snowpipe (continuous file load).
- Cortex AI: `AI_COMPLETE`, `AI_CLASSIFY`, `AI_FILTER`, `AI_EXTRACT`, `AI_SENTIMENT`, `AI_REDACT`;
  old names deprecated. `TO_FILE('@stage','file.pdf')` — stage and filename are separate args.
- Snowpark: lazy DataFrames; don't `collect()` large data; prefer vectorized UDFs.
- Performance: cluster keys only on multi-TB tables; `SEARCH OPTIMIZATION ON EQUALITY`; start X-Small,
  autoscale; separate warehouses per workload; estimate AI token cost before running.
- Security: least-privilege RBAC with database roles; audit `ACCOUNTADMIN`; masking + row-access policies.

## Monitoring & cost

- Track: records processed/failed, data size, execution time, success/failure rates, freshness.
- Alerts: failures, performance degradation, data staleness. Dashboards: Grafana/CloudWatch.
- Cost: lifecycle policies (hot→warm→cold), spot for batch / on-demand for streaming / serverless for
  ad-hoc, query optimization (partition pruning, clustering, predicate pushdown), audit warehouse
  queries (see `sql-postgres.md`).
