# Data AI — RAG, Embeddings, Vector Retrieval, LLM Apps

Synthesized from: `rag-engineer`, `embedding-strategies`, `vector-database-engineer`,
`similarity-search-patterns`, `vector-index-tuning`, `llm-app-patterns`, `recsys-pipeline-architect`,
`local-llm-expert`, `ai-engineering-toolkit`, `clarity-gate` (evaluation discipline).

## ToC

1. [RAG pipeline architecture](#rag-pipeline-architecture)
2. [Embedding selection & pipelines](#embedding-selection--pipelines)
3. [Chunking strategies](#chunking-strategies)
4. [Retrieval optimization & evaluation](#retrieval-optimization--evaluation)
5. [LLM application patterns](#llm-application-patterns)
6. [Recommendation/ranking pipelines](#recommendationranking-pipelines)

## RAG pipeline architecture

Document → chunking → preprocessing → embedding → vector store → retrieval → generation.

Guiding principles: retrieval quality > generation quality (fix retrieval first); chunk size depends on
content type and query patterns; embeddings have blind spots; always evaluate retrieval separately from
generation; hybrid search beats pure semantic in most cases.

Pipeline stages (LLM apps): ingestion (chunking, embeddings, storage) → retrieval (semantic/hybrid,
metadata filters, rerank) → generation (context assembly with relevance thresholds). See
`nosql-vector.md` for the vector-store operations half.

## Embedding selection & pipelines

Model comparison (dimensions / max tokens / best-for): text-embedding-3-large (3072/8191, high
accuracy), text-embedding-3-small (1536/8191, cost-effective, Matryoshka reduction), voyage-2
(1024/4000, code+legal), bge-large-en-v1.5 (1024/512, open source), all-MiniLM-L6-v2 (384/256, fast/light),
multilingual-e5-large (1024/512, multi-language).

- Match model to content type (code vs prose vs multilingual); don't reuse one model across types.
- Batch requests, normalize embeddings for cosine, cache embeddings, respect token limits.
- Don't mix embedding models in one index; don't skip preprocessing; don't over-chunk.
- BGE-style query prefix ("Represent this sentence for searching relevant passages: ...") and
  E5 instruction prefixes ("query:" / "passage:") improve retrieval.
- Local embedders: `sentence-transformers` on GPU; Matryoshka dimension reduction via API params.

## Chunking strategies

- Semantic chunking (sentence/paragraph boundaries, topic-shift detection via embedding similarity,
  overlap, preserve headers as metadata) beats fixed token counts — fixed splits cut ideas mid-sentence.
- Recursive character splitting (LangChain-style separators `["\n\n","\n",". "," ", ""]`) as a robust default.
- Markdown/structured docs: split by headers preserving hierarchy; code: split by functions/classes
  (tree-sitter) with surrounding context.

## Retrieval optimization & evaluation

- Retrieve larger candidates (top 20–50), rerank with a cross-encoder, return top-K (5). Cache reranker.
- Pre-filter by metadata (date/source/category) before vector search; post-filter by relevance.
- Context: set a minimum similarity cutoff, order by relevance, compress/summarize if overflowing —
  more context ≠ better (attention limits, cost, drift).
- Evaluate retrieval metrics (MRR, Recall@K, NDCG) on a labeled set, **separately** from generation;
  track over time. Refresh embeddings when source documents change (version hashes, TTL).
- A/B your prompts: prompt versioning + eval harness; measure latency/cost/quality.

## LLM application patterns

- Agents: ReAct (reason → act), function/tool calling (schemas + validation), plan-and-execute,
  multi-agent collaboration (orchestrator/worker).
- Prompt IDE: templates with variables, versioning + A/B tests, prompt chaining (research→analyze→summarize).
- LLMOps: track metrics (cost, latency, token usage, evals); logging/tracing; evaluation framework.
- Production: caching (semantic + exact), rate limiting + exponential backoff, fallback strategies,
  structured output validation. Budget context per stage; don't cram everything into one prompt.

## Recommendation/ranking pipelines

Composable architecture: Source → Hydrator → Filter → Scorer → Ranker → Policy (six-stage pipeline).
Examples: content feed, RAG retrieval reranker, notification triage. Build the pipeline as a runnable
scaffold with clear inputs/outputs so it can be A/B tested and swapped per stage.
