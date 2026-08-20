# Tokens, NFTs, Wallets & Web3 Frontend

Guidance for token/NFT platforms, wallets, account abstraction, and dApp frontends,
synthesized from production Web3 developer patterns.

## Contents
- [Tokens & NFT Platforms](#tokens--nft-platforms)
- [Web3 Frontend & Wallets](#web3-frontend--wallets)
- [Account Abstraction (ERC-4337)](#account-abstraction-erc-4337)

## Tokens & NFT Platforms

- **ERC-20** for fungible assets; **ERC-721** for one-of-a-kind NFTs; **ERC-1155**
  for collections/games where batch operations save gas.
- **Metadata**: store pointer (URI) on-chain, content on IPFS. Prefer on-chain
  metadata (SVG/JSON in contract) for immutability and generative art.
- **Marketplaces**: OpenSea-compatible contracts; support listings, offers, and
  royalties via **EIP-2981**.
- **Royalties & creator economics**: enforce per-sale royalty on secondary markets.
- **Fractional NFT ownership**: split a NFT into ERC-20 shares to enable shared
  ownership / tokenization.
- **Dynamic NFTs**: mutate metadata via Chainlink oracles or time-based mechanics.
- **Cross-chain NFT bridges**: pair mint/lock + burn/unlock between chains.
- **Utility integrations**: gaming items, memberships gating, governance tokens.
- **IPFS integration**: pin metadata and media; pinning services for permanence.

Tokenomics (also see `defi-protocols.md`): vesting schedules, bonding curves,
reward distribution, treasury management, protocol-owned liquidity, burning
mechanisms, and game-theoretic incentive design for multi-token economies.

## Web3 Frontend & Wallets

- **Wallet integration**: MetaMask, WalletConnect, Coinbase Wallet; detect provider
  and support fallback/QR flows.
- **Stacks**: Wagmi + RainbowKit for modern React; web3.js / ethers.js / viem for
  lower-level libs; React/Next.js for dApp structure.
- **Auth & sessions**: signed-message proof (`personal_sign` typed data) to bind
  a wallet to a session; never handle private keys in the frontend.
- **Gasless transactions**: meta-transactions (EIP-712 typed signatures + relayers /
  ERC-4337 paymasters) to remove friction for onboarding.
- **Web3 UX**: show clear connection/loading/error states; handle network switching;
  provide onboarding flows and fallback modes for non-wallet users.
- **Mobile**: React Native + Web3 mobile SDKs; wallet-connect v2 for native wallet apps.
- **DID / verifiable credentials**: decentralized identity and attestation UX.

Security: frontends must never expose API keys or private keys; validate all
allowances, use revoke patterns, and warn users about phishing domains.

## Account Abstraction (ERC-4337)

- Dual-track accounts (EOA + smart contract wallet) give users upgradeable, gasless,
  and recoverable accounts.
- Components: `EntryPoint`, account contracts, `UserOperation`, bundlers, paymasters.
- Benefits: multi-sig-in-wallet, session keys, batch transactions, sponsorship
  of user gas fees (onboarding).
- Risks: paymaster trust assumptions and bundler censorship — document choice of
  paymaster/bundler and fallbacks.