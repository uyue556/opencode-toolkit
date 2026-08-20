# Node Infrastructure, Indexers, Oracles & Enterprise

Deployment, infrastructure, oracle integration, and enterprise/permissioned
blockchain patterns.

## Contents
- [Local Development & Node Ops](#local-development--node-ops)
- [Indexing & Data](#indexing--data)
- [Oracles & External Data](#oracles--external-data)
- [Enterprise & Permissioned Chains](#enterprise--permissioned-chains)

## Local Development & Node Ops

- Local tools: **Hardhat**, **Foundry**, **Ganache** for fast iteration; use them
  with forks of mainnet for realistic state (see `web3-testing.md`).
- Testnets before mainnet; automate deployments per network, keep reproducible
  deploy scripts and versioned artifacts.
- **RPC node management**: use multiple providers for redundancy and rate-limit
  safety; load balance between dedicated/infura/alchemy endpoints.
- **IPFS nodes**: run peers and pinning services for metadata/media permanence.
- **Monitoring & analytics**: dashboards for block/tx latency, gas prices,
  contract activity, and anomaly detection.
- Multi-chain deployment: per-chain config, verify on each explorer, watch for
  EVM/non-EVM differences in wallets and tooling.

## Indexing & Data

- **The Graph Protocol**: subgraph schemas + handlers for contract event indexing;
  graph syncs are queried via GraphQL.
- Custom indexers for chains/contracts not covered by subgraphs (SQL + RPC scrapers).
- Index events not storage reads: subgraphs react to emitted logs, so emit rich,
  structured events in contracts.
- Handle reorgs: indexers should tolerate chain reorgs (fork-aware ranges).

## Oracles & External Data

- **Chainlink**: price feeds (aggregated, manipulation-resistant) + **VRF** for
  verifiable randomness.
- **API3**: first-party oracles / dAPIs — data providers serve their own feeds.
- **Band**, **Pyth**: alternative price feeds with different update mechanisms and
  latencies.
- **Chainlink Functions**: off-chain computation triggered on-chain for custom logic.
- Oracle security:
  - Never accept a single spot price for financial decisions — use TWAP or
    cross-reference multiple independent feeds.
  - Check staleness (heartbeat/`updatedAt`) before trusting a feed.
  - Protect against front-running when consuming oracle updates (MEV/gas races).
  - Time-sensitive logic needs liveness guarantees from the oracle provider.

## Enterprise & Permissioned Chains

- Private/consortium networks (Hyperledger Fabric, Quorum/Besu, Corda) with
  membership control and KYC/AML.
- Use cases: supply-chain tracking and verification, digital identity (DID,
  verifiable credentials), asset tokenization (real estate, commodities,
  securities), voting/governance platforms, CBDCs.
- Custody integration: enterprise wallets, qualified custody, multisig/threshold
  schemes, hardware wallets.
- Compliance: jurisdictions differ — design reporting, audit trails, and data
  retention to match the operating region.