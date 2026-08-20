# Solidity Development & Smart Contract Security

Synthesis of production-grade Solidity patterns, standards, upgrade paths, gas
optimization, and security auditing practices. Use alongside the concrete code
in `defi-protocols.md` and test patterns in `web3-testing.md`.

## Contents
- [Standards (EIPs)](#standards-eips)
- [Architecture Patterns](#architecture-patterns)
- [Upgradeable Contracts](#upgradeable-contracts)
- [Gas Optimization](#gas-optimization)
- [Security & Auditing](#security--auditing)
- [Cross-Ecosystem Notes](#cross-ecosystem-notes)

## Standards (EIPs)

- **ERC-20**: fungible tokens — implement `transfer/transferFrom/approve`, total
  supply, and events. Use OpenZeppelin `ERC20` + `ERC20Permit` for gasless approvals.
- **ERC-721**: non-fungible tokens — `safeTransferFrom`, token ownership, metadata URL.
- **ERC-1155**: multi-token — batch transfer/mint, saves gas for collections.
- **EIP-2981**: royalty standard for marketplaces (creator economics).
- **EIP-4337**: account abstraction / smart wallets (see `nft-tokens-web3-frontend.md`).
- **ERC-20Votes**: snapshot-based voting power for governance (see `defi-protocols.md`).

## Architecture Patterns

- **Proxy contracts**: delegate calls to a logic implementation behind a proxy
  storage layer (diamond standard, factory patterns for fine-grained upgradability).
- **Factory patterns**: deploy many identical child contracts; store the deployer
  reference and restrict child creation to the factory.
- **CEI (Checks-Effects-Interactions)**: do all state mutations before external calls
  to avoid reentrancy.
- **ReentrancyGuard**: guard every function that interacts with external contracts.
- **Emergency controls**: pausable (`Ownable` + `Pausable`), timelocks, multisig
  for every critical operation.
- **Multi-signature + threshold cryptography**: split control of treasuries and
  upgrade keys across several signers.

## Upgradeable Contracts

- Patterns: transparent proxy, UUPS (recommended for new projects), beacon proxy
  (shared implementation across many proxies).
- Storage: never change declaration order; append fields only; use
  `Initializable`/`onlyInitializing` instead of constructors.
- Governance: combine upgrades with timelocks and guardian/nameable roles.
- Alternatives: immutable upgrades via EIP-2535 diamond if you need many facets.

## Gas Optimization

- Prefer `calldata` over `memory` for external function args.
- Avoid dynamic arrays in hot paths (use mappings).
- Pack structs/storage (`uint128`/`uint96`) to reduce slots.
- Cache repeated storage reads in local variables inside the same function.
- Batch where possible (ERC-1155 batch transfers, multi-call).
- Monitor contract deployed size against the 24KB EIP-170 limit; use optimizer
  `runs` to tune for called vs. deployment costs.

## Security & Auditing

- Static analysis: **Slither**, **Mythril** (automated scan each build).
- Formal verification: **Certora** for high-value invariants; Vyper for
  audit-friendly simpler contracts.
- Fuzz/property tests: foundry `testFuzz*` + `vm.assume` (see `web3-testing.md`).
- Vulnerability classes to always check: reentrancy, integer overflow/underflow
  (Solidity ≥0.8 reverts by default), access control, oracle manipulation,
  malicious token callbacks, front-running/MEV, delegatecall hijack.
- Never deploy to production without a professional security audit; document
  contract behavior and keep audit-ready comments.
- Incident response: monitor exploit patterns, have pause + upgrade paths ready,
  and a communication plan.

## Cross-Ecosystem Notes

- **Solana / NEAR / Cosmos**: Rust smart contracts; use Anchor (Solana), and the
  Cosmos SDK for custom chains.
- **Polkadot**: Substrate parachain development; Rust.
- **Cardano**: Plutus (Haskell); **Algorand**: PyTeal + atomic transfers.
- **Hyperledger Fabric**: enterprise permissioned networks, Go/Node chaincode.
- **Bitcoin L2**: Taproot, MuSig2, channel factories — see
  `lightning-channel-factories.md`.
- Multi-chain deployment: keep per-chain network configs, verify each chain's
  explorer, and watch for EVM vs. non-EVM differences in wallets and indexers.