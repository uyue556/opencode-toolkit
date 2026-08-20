# NoSQL & Vector Databases

Synthesized from: `nosql-expert`, `weaviate`, `vector-database-engineer`,
`similarity-search-patterns` (+ playbook), `vector-index-tuning` (+ playbook), `embedding-strategies`
(selection overlap), `postgresql` (pgvector).

## ToC

1. [Distributed NoSQL mental model (Cassandra/DynamoDB)](#distributed-nosql-mental-model)
2. [Vector database operations (Weaviate)](#vector-database-operations)
3. [Similarity search patterns](#similarity-search-patterns)
4. [Vector index tuning](#vector-index-tuning)

## Distributed NoSQL mental model

SQL: model entities + relationships, answer any query. Distributed NoSQL (Cassandra/DynamoDB):
**model queries first**; you typically cannot add a query later without a new table/index.

- List entities → list access patterns → design tables to serve each pattern with a single lookup.
- **Partition key is king**: high-cardinality keys distribute traffic. Low-cardinality keys
  (e.g. `status="active"`) create hot partitions.
- Clustering/sort keys pre-sort data within a partition for efficient range queries.
- **Single-table design** (DynamoDB adjacency lists): one table, PK `USER#123`, SK `PROFILE`/`ORDER#...`
  → one network request returns related records.
- Denormalize and duplicate freely (storage is cheap; consistency is managed with batch writes/eventual consistency).
- Cassandra/Scylla: no joins/aggregates — pre-compute counter tables; never `ALLOW FILTERING` in prod;
  writes are cheap (LSM appends); tombstones are expensive markers — avoid high-velocity deletes.
- DynamoDB: GSI for alternate views (eventually consistent), LSI must exist at creation; TTL for free
  expiry; size partitions so a single partition doesn't grow unbounded (>10GB → shard keys).
- Anti-patterns: scatter-gather scans, hot keys, relational modeling with joins in app code.

## Vector database operations

Generic workflow (exemplified by Weaviate, applies to Pinecone/Qdrant/Milvus/pgvector):

1. List collections first (`list_collections`); inspect schema (`get_collection`) — properties, types,
   vectorizer, replication, multi-tenancy.
2. Explore data distribution before querying (`explore_collection`).
3. Create a collection with a custom schema before importing (default vectorizer unless user requests
   otherwise); for PDF imports collection creation is automatic.
4. Import CSV/JSON/JSONL/PDF; set `WEAVIATE_URL` + `WEAVIATE_API_KEY` (and provider keys for vectorizers).
5. Choose search type: hybrid (default, best balance), semantic (conceptually similar),
   keyword (exact terms/IDs), filtered fetch (precise retrieval by ID/conditions),
   Query-Agent ask mode (synthesized answer + citations) vs search mode (raw objects).

## Similarity search patterns

- **Hybrid search beats pure semantic in most cases**: BM25/TF-IDF for keywords + vector similarity for
  semantics, combined with Reciprocal Rank Fusion; tune weights per query type.
- Metadata pre-filtering: reduce the search space before vector similarity (date/source/category) —
  semantic similarity ≠ relevance.
- Rerank: retrieve a larger candidate set (top 20–50), rerank with a cross-encoder, return top-K (5).
- Query expansion for short/ambiguous queries: LLM-generated variants, synonyms, HyDE, multi-query + dedup.
- Contextual compression when retrieved chunks exceed the window: extract sentences, summarize, dedup,
  order by relevance.
- Hierarchical/multi-granularity indexing (paragraph/section/document) with parent-child context.
- Evaluate retrieval separately from generation (MRR, Recall@K, NDCG); refresh embeddings when source
  documents change (version hashes, TTL); don't mix embedding models (incompatible vector spaces).
- Choose chunking by content type: sentence/paragraph boundaries + overlap + preserved headers; never
  fixed-token cuts that split ideas mid-sentence (see `data-ai.md` for embedder code).

## Vector index tuning

Key levers (HNSW / IVF / PQ) and trade-offs:

- **HNSW**: high recall, fast; tune `M` (edges per node) and `efConstruction`/`efSearch` — more edges +
  wider search = higher recall, more memory/latency. `efSearch` is the online knob; raise it for
  quality-critical queries, lower for latency.
- **IVF/PQ**: lower memory; `nlist` (cluster count) for recall; PQ quantization for memory at some recall cost.
- Measure latency/recall/memory on **your** data (MTEB-style or your own eval set); index build time and
  re-index strategy matter (plan for index rebuilding as data changes).
- Tune: distance metric (cosine vs L2 vs dot — must match normalization), dimensions (Matryoshka
  dimension reduction, 384–1536 typical), metadata filters, caching frequent queries, monitoring drift.
- pgvector: HNSW index on a `vector` column; set `hnsw.ef_search` per query; keep vectors normalized
  for cosine.
