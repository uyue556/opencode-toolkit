# Multiplayer & Networking

> Networking architecture and synchronization principles. **Never trust the client — the server is the source of truth.**

## Architecture selection

```
What type of multiplayer?
│
├── Competitive / Real-time  -> Dedicated Server (authoritative)
├── Cooperative / Casual     -> Host-based (one player is server)
├── Turn-based               -> Client-server (simple)
└── Massive (MMO)            -> Distributed servers
```

| Architecture | Latency | Cost | Security |
|--------------|---------|------|----------|
| Dedicated | Low | High | Strong |
| P2P | Variable | Low | Weak |
| Host-based | Medium | Low | Medium |

## Synchronization principles

| Approach | Sync what | Best for |
|----------|-----------|----------|
| State sync | Game state | Simple, few objects |
| Input sync | Player inputs | Action games |
| Hybrid | Both | Most games |

**Lag compensation:**

| Technique | Purpose |
|-----------|---------|
| Prediction | Client predicts server |
| Interpolation | Smooth remote players |
| Reconciliation | Fix mispredictions |
| Lag compensation | Rewind for hit detection |

Design for 100-200ms latency — don't ignore it.

## Network optimization

| Technique | Savings |
|-----------|---------|
| Delta compression | Send only changes |
| Quantization | Reduce precision |
| Priority | Important data first |
| Area of interest | Only nearby entities |

| Data | Update rate |
|------|-------------|
| Position | 20-60 Hz |
| Health | On change |
| Inventory | On change |
| Chat | On send |

## Security (server authority)

```
Client: "I hit the enemy"
Server: Validate -> did projectile actually hit?
                   -> was player in valid state?
                   -> was timing possible?
```

| Cheat | Prevention |
|-------|------------|
| Speed hack | Server validates movement |
| Aimbot | Server validates sight line |
| Item dupe | Server owns inventory |
| Wall hack | Don't send hidden data |

## Matchmaking

| Factor | Impact |
|--------|--------|
| Skill | Fair matches |
| Latency | Playable connection |
| Wait time | Player patience |
| Party size | Group play |

## Anti-patterns

| Don't | Do |
|-------|-----|
| Trust the client | Server is authority |
| Send everything | Send only necessary |
| Ignore latency | Design for 100-200ms |
| Sync exact positions | Interpolate/predict |
