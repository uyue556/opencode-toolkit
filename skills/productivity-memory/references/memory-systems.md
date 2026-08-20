# Memory Systems

Design and operate agent memory: short-term (context window), long-term (vector stores),
entity and graph memory, plus consolidation, decay, and retrieval. Core insight: **memory
quality = retrieval quality, not storage quantity.** A million stored facts mean nothing if
you cannot find the right one.

## The memory spectrum

Memory is a layered spectrum, not one store:

| Layer | Scope | Access | Persistence |
|---|---|---|---|
| Working memory | context window | zero-latency | volatile |
| Short-term | session | searchable | session-scoped |
| Long-term | cross-session | retrieval needed | semi-permanent |
| Permanent | archival | queryable | permanent |

## CoALA memory types (choose the right type per info)

- **Semantic** — facts and knowledge: user preferences, domain knowledge. Stored as
  structured profiles or collections.
- **Episodic** — timestamped experiences: past conversations, task outcomes. Used for
  learning from experience.
- **Procedural** — how-to knowledge: rules, skills, workflows, few-shot examples.

## Architecture choice

- Simple persistence needs → **file-system-as-memory** (naming conventions, JSON/YAML, timestamps).
- Semantic search needs → **vector RAG with rich metadata** (entity tags, validity, source, confidence).
- Relationship reasoning → **knowledge graph** (entities + relations).
- Time-aware queries / avoid outdated-fact clashes → **temporal knowledge graph** (valid_from/valid_until).

Benchmark (Deep Memory Retrieval): Zep temporal KG 94.8% accuracy; MemGPT 93.4%; GraphRAG
~75-85%; plain vector RAG ~60-70%; recursive summarization 35.3% (information loss).

## Vector store selection

| Store | Scale | Managed | Filtering | Hybrid | Cost | Latency |
|---|---|---|---|---|---|---|
| Pinecone | Billions | Yes | Basic | No | High | 5ms |
| Qdrant | 100M+ | Both | Best | Yes | Medium | 7ms |
| Weaviate | 100M+ | Both | Good | Best | Medium | 10ms |
| ChromaDB | 1M | Self | Basic | No | Free | 20ms |
| pgvector | 1M | Self | SQL | Yes | Free | 15ms |

Embedding models: `text-embedding-3-large` (best quality, $0.13/1M), `text-embedding-3-small`
(good balance, $0.02/1M), `nomic-embed-text-v1.5` (open, 768 dim), `all-MiniLM-L6-v2` (384 dim, fastest).
Always use the **same embedding model for indexing and querying**; mixing models produces garbage similarity.

## Retrieval quality

- **Filter with metadata first, then search.** Pure semantic similarity is not relevance
  ("user likes Python" vs "Python is a language"). Always filter by user_id, type, time.
- **Hybrid search** (semantic + keyword, RRF fusion) beats pure vector for many domains.
- **Rerank** with a cross-encoder on top-20 candidates for precision.
- **Budget retrieved context.** Token-budget the system prompt, user profile, recent messages,
  and retrieved memories separately; compute `max_k = max_tokens // avg_chunk_tokens`.
- **Test retrieval before production**: build a recall@k eval with test queries; don't assume
  your chunk size works.

## Chunking

- General guidance: **256–512 tokens**; overlap 10–20%.
- Content-specific: documentation 512, code 1000 (language-aware splitters respect
  function/class boundaries), conversation 256, articles 768.
- **Structure-aware**: split on markdown headers so each chunk keeps header metadata.
- **Contextual chunking** (Anthropic): prepend a short document-summary context to each chunk
  *before embedding* (store the original chunk, embed the contextualized text). Cuts retrieval
  failures ~35%. Fixes the sharp edge where retrieved chunks make no sense in isolation.
- **Hierarchical chunking**: store 256/512/1024 granularities; retrieve at the level matching
  the query type (factual = small, conceptual = large).

## Memory lifecycle patterns

- **Tiered memory**: every message goes to the buffer; extract entities; score importance
  (`prefer/like/hate` +0.3, `decided/chose` +0.3, `my/I am/I have` +0.2, length +0.1, user msg +0.1);
  store only memory-worthy items. Consolidate: promote short-term with importance >0.7 or
  referenced >2 times into long-term.
- **Background memory formation**: extract insights after the conversation goes idle
  (LLM prompt: key facts, preferences, tasks, patterns) instead of in real-time — higher
  quality, no latency cost.
- **Consolidation**: cluster similar memories (threshold ~0.9), merge with an LLM, delete
  originals. Trigger on growth, stale results, schedule, or request.
- **Decay**: time-based soft-delete for episodic; utility score for the rest:
  `0.4*recency + 0.3*frequency + 0.3*importance`, where recency uses an exponential
  72h half-life `0.5^(hours/72)`. Archive below threshold (~0.2).
- **Entity memory**: upsert facts per entity (merge, dedupe, track lastMentioned/mentionCount,
  confidence + source per fact) so "John Doe" stays one identity across conversations.
- **Preference updates replace, not append**: delete the old preference for a category before
  storing the new one, or version facts explicitly (`supersedes`, `valid_from`).
- **Temporal scoring** on retrieval: `final = 0.7*similarity + 0.3*time_decay` (30d half-life)
  so stale preferences don't override current ones.

## Sharp edges

- **Context isolation is the enemy of memory** — always name/scope memories so retrieval can
  find them (namespace, user_id, type).
- **Contradictory memories retrieved together**: detect conflicts on storage (LLM yes/no on
  contradiction) and resolve by replace/version, plus periodic LLM consolidation of clusters.
- **Retrieved memories exceed context window**: use token budgets and dynamic k; prioritize
  recent messages > profile > retrieved memories.
- **Privacy is critical**: namespace every key by user (`user:{id}:memory:{id}`); mandatory
  user filter on every search; export/delete-user-data paths for GDPR. Never query without
  user filtering.
- **Model upgrades break retrieval**: track `embedding_model` in metadata, filter on it,
  re-embed via a migration collection, then switch over.
- **In-memory stores lose data on restart** — use persistent storage in production.

## Tooling notes

- **LangMem** (LangChain) — semantic/episodic/procedural stores for LangGraph agents.
- **MemGPT / Letta** — OS-style virtual context, hierarchical tiers, automatic paging.
- **Mem0** — user-memory layer for personalization (preferences/history).
- **Zep** — temporal knowledge graph, best DMR accuracy.

## Hierarchical agent memory (scoped CLAUDE.md / HAM)

For coding-agent projects, replace one monolithic CLAUDE.md with a scoped hierarchy to cut
token spend:

```
project/
├── CLAUDE.md              # root context (~200 tokens) + Context Routing section
├── .memory/
│   ├── decisions.md       # ADRs
│   ├── patterns.md        # reusable patterns
│   ├── inbox.md           # unconfirmed inferences awaiting confirmation
│   └── audit-log.md
└── src/
    ├── api/CLAUDE.md      # scoped context, ~250 tokens each
    └── components/CLAUDE.md
```

- Root `CLAUDE.md` holds a `## Context Routing` map (`→ api: src/api/CLAUDE.md`) so the agent
  loads the right sub-context without guessing.
- Keep root <60 lines, sub-files <75 lines. Audit every ~2 weeks (stale/missing coverage).
- Review `.memory/inbox.md` periodically: confirm or reject inferred items — this is the same
  "ask instead of guess" honesty rule as the ledgers.
- Real-world example savings: ~7,500 → ~450 tokens/prompt (~94%).

## Long-context compression (RecallMax pattern)

- Inject external context with **deduplication + source attribution** to avoid hallucination
  drift — don't just concatenate.
- Auto-summarize past turns preserving **tone, intent, key facts, emotional register**
  (not just "what happened").
- Compress long histories into high-density token sequences before hitting the window limit;
  prefer compression over raw truncation.
- Run cross-reference fact checks on high-stakes outputs.
