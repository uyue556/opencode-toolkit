# Unity ECS / DOTS Patterns

> Production patterns for Unity's Data-Oriented Technology Stack (DOTS): Entity
> Component System, Job System, and Burst Compiler. Use when managing thousands
> of entities, converting OOP code to ECS, or optimizing CPU-bound logic.
> Full code samples live in `unity-ecs-playbook.md`.

## When to use

- High-performance Unity games; thousands of similar entities (RTS units, particles).
- Implementing data-oriented systems; parallelizing CPU-bound logic with Jobs + Burst.
- Converting OOP game code to ECS.

## ECS vs OOP

| Aspect | Traditional OOP | ECS/DOTS |
|--------|-----------------|----------|
| Data layout | Object-oriented | Data-oriented |
| Memory | Scattered | Contiguous |
| Processing | Per-object | Batched |
| Scaling | Poor with count | Linear scaling |
| Best for | Complex behaviors | Mass simulation |

## Core concepts

```
Entity    : Lightweight ID (no data)
Component : Pure data (no behavior)
System    : Logic that processes components
World     : Container for entities
Archetype : Unique combination of components
Chunk     : Memory block for same-archetype entities
```

Component kinds: `IComponentData` (plain data), tag components (zero-size markers like `EnemyTag`), `IBufferElementData` (variable-size arrays), `ISharedComponentData` (grouped entities).

## Key patterns (details + code in playbook)

1. **Systems: prefer `ISystem` over `SystemBase`** — unmanaged, Burst-compatible. Use `SystemAPI.Query<T>` with `foreach`; auto-generates jobs.
2. **Entity queries** — `EntityQueryBuilder` for complex cases (`WithAll`, `WithNone`, `FilterWriteGroup`); `ToEntityArray` / `ToComponentDataArray` for bulk reads.
3. **Structural changes require Entity Command Buffers (ECB)** — create/destroy/add/remove are deferred to sync points. Use `ParallelWriter` in jobs.
4. **Aspects (`IAspect`)** — group related components into one readable struct; cleaner systems.
5. **Singletons** — exactly one entity with a component; read with `GetSingleton`, write with `GetSingletonRW`.
6. **Baking** — `Baker<Authoring>` converts MonoBehaviour-authored data into components; use `TransformUsageFlags` and `DependsOn`.
7. **Jobs with Native collections** — `IJobParallelFor` + `NativeParallelMultiHashMap` for spatial hashing; dispose native arrays with the job dependency.

## Performance tips

- Burst-compile everything (`[BurstCompile]`).
- Prefer `IJobEntity` over manual iteration; schedule parallel when possible.
- Avoid structural changes in hot paths — use enableable components (`IEnableableComponent`) instead of add/remove.
- Watch chunk utilization; group similar entities.
- Dispose native collections — they leak if forgotten.

## Do & Don't

| Don't | Do |
|-------|-----|
| Use managed types | Keep Burst-compatible unmanaged types |
| Structural change in jobs | Use ECB (deferred) |
| Over-architect | Start simple, add ECS only when perf demands |
| Ignore chunk utilization | Group similar entities |
| Forget disposal | Dispose native collections with job dependencies |
| Add/remove in hot paths | Use enableable components |
