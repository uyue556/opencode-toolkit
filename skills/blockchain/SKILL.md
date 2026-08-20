---
name: blockchain
description: "End-to-end blockchain & Web3 engineering: Solidity smart contracts, DeFi protocols (staking, AMMs, governance, lending, flash loans), token/NFT standards, Hardhat & Foundry testing, mainnet forking, wallets & dApp frontends, node infrastructure, oracles, Bitcoin Lightning channel factories, and autonomous crypto BD agents. Use whenever the user mentions 区块链, blockchain, Web3, smart contract, 智能合约, Solidity, DeFi, AMM, NFT, token, staking, governance, lending, flash loan, DAO, ERC-20/721/1155, 加密货币, crypto, Hardhat, Foundry, testing, 闪电网络, Lightning, channel factory, wallet, node, oracle, exchange listing, crypto BD."
---

# Blockchain / Web3 Engineering

Consolidated guidance for building, testing, and reviewing blockchain systems:
smart contracts, DeFi protocols, tokens/NFTs, Web3 frontends, node infrastructure,
Bitcoin Lightning channel factories, and crypto business-development agents.

## When to use this skill

- Writing or reviewing Solidity smart contracts (tokens, staking, AMMs, governance,
  lending, flash loans) and dApp backends.
- Setting up Hardhat/Foundry test suites, mainnet forks, fuzzing, coverage, verification.
- Building NFT platforms, tokenomics, wallets, or Web3 frontends.
- Deploying node infrastructure, indexers, oracles, or multi-chain tooling.
- Explaining or reviewing Lightning Network channel factories / Layer 2 scaling.
- Building an AI agent that discovers and acquires token listings for an exchange.

## Do not use when

- The task is plain (non-crypto) business development or trading-bot logic.
- You need a specific chain's SDK in depth beyond what references cover — ask for the
  target chain/ecosystem first.

## Core workflow

1. **Clarify scope**: chain/ecosystem (EVM, Solana, Cosmos, Polkadot, Bitcoin L2...),
   goal, constraints (permissions, budget, security boundaries), success criteria.
2. **Design**: pick standards/libraries first (OpenZeppelin, Solmate), then architecture
   (contracts, roles, upgrade path). Prefer battle-tested patterns over novel ones.
3. **Implement**: write production-ready code with explicit access control, events,
   and gas awareness.
4. **Test**: unit + integration + fuzzing, using mainnet forks against real contracts.
5. **Secure**: run static analysis (Slither, Mythril), verify invariants, plan an audit
   before anything user-facing.
6. **Deploy & monitor**: testnet → mainnet, verify on Etherscan, track on-chain health.

## Selection routing

| Task | Open |
|------|------|
| Solidity patterns, standards, proxies, gas optimization, contract security | `references/solidity-development.md` |
| Staking, AMM, governance, lending, flash-loan templates | `references/defi-protocols.md` |
| Hardhat/Foundry testing, forking, fuzzing, coverage, CI, verification | `references/web3-testing.md` |
| Tokens/NFTs, marketplaces, royalties, wallets, dApp frontends, account abstraction | `references/nft-tokens-web3-frontend.md` |
| Node infra, indexers, oracles, RPC, enterprise/permissioned chains | `references/node-infra-oracles.md` |
| Lightning channel factories / SuperScalar explainer + review checklist | `references/lightning-channel-factories.md` |
| Autonomous crypto BD agent (discovery, scoring, outreach) | `references/crypto-bd-agent.md` |

## Best practices

- **Use established libraries** (OpenZeppelin, Solmate); don't hand-roll crypto primitives.
- **Test >90% coverage**, including edge cases, access-control failures, and reentrancy.
- **Test against mainnet forks** so logic runs against real token/dex contracts.
- **Audit before launch**; use proxy patterns (transparent/UUPS/beacon) only with
  timelocks and pause mechanisms for upgrades.
- **Minimize gas** and contract size; document every public function's behavior.
- **Verify on Etherscan** after deploy; keep deployment scripts reproducible.
- **Monitor** contracts, wallets, and indexers after shipping.

## Do & Don't

- DO check the trust model and on-chain footprint of any design before scaling it.
- DO get human approval before any automated outreach or external payment.
- DO keep API keys and private keys out of code, logs, and shared memory.
- DON'T trust token names — always key pipeline data by verified contract address.
- DON'T deploy without reentrancy guards, access control, and edge-case tests.
- DON'T treat raw price/oracle data as final — cross-reference 2+ sources.

## Common pitfalls

- Reentrancy: use `ReentrancyGuard` + CEI (checks-effects-interactions) order.
- Rounding/underflow: track `rewardPerTokenStored` accumulators correctly; test `0` shares.
- Time locks: validate `block.number` window start/end on both `vote` and `execute`.
- Flash loans: verify repayment (balance before + fee) inside the loan function, not the
  callback; the callback must return `true`.
- Oracle manipulation: prefer TWAP or multiple feeds; never accept a single spot price.
- Forks: pin `blockNumber` in tests so results are reproducible.
- Channel factories: understand invalidation/timeout trees and watchtower needs before
  recommending them for production.

## Examples

- "Build a production-ready DeFi lending protocol with liquidation mechanisms" →
  `defi-protocols.md` + `web3-testing.md`.
- "Implement a cross-chain NFT marketplace with royalty distribution" →
  `nft-tokens-web3-frontend.md` + `solidity-development.md`.
- "Design a DAO governance system with token-weighted voting" →
  `defi-protocols.md` (governance template).
- "Explain Lightning channel factories and compare to LSP alternatives" →
  `lightning-channel-factories.md`.
- "Build an agent that finds and evaluates new token listings for our exchange" →
  `crypto-bd-agent.md`.

## Limitations

- These patterns are a starting point, not a substitute for audits, formal
  verification, or environment-specific validation. Ask for clarification when
  inputs, permissions, or success criteria are missing.
