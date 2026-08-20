# Dedup Notes — blockchain

## Source library
`/home/administrator/.config/opencode/skill-libraries/blockchain/` (7 SKILL.md files, no scripts/ or assets/).

## Merged

- **3 Lightning skills → `references/lightning-channel-factories.md`**
  (lightning-factory-explainer, lightning-channel-factories, lightning-architecture-review).
  All three were near-duplicates (~56 lines each) describing the same Decker-Wattenhofer /
  timeout-tree / MuSig2 / SuperScalar content with identical reference links. Kept the
  strongest technical detail (C implementation, Noise NK, SQLite persistence, 400+ tests,
  network support) and added a distinct protocol-design review checklist that only the
  architecture-review variant hinted at.
- **blockchain-developer + defi-protocol-templates + web3-testing**: capability/persona lists
  from blockchain-developer were distilled into SKILL.md scope + routing, and its deeper
  sub-topics became `solidity-development.md` (patterns/standards/security),
  `nft-tokens-web3-frontend.md`, and `node-infra-oracles.md`. Concrete Solidity templates
  went to `defi-protocols.md`; concrete test code to `web3-testing.md`.
- **crypto-bd-agent → `references/crypto-bd-agent.md`**: kept in full (self-contained,
  production-tested, no overlap; 240 lines of dense content).

## Duplicates dropped / not reproduced

- Repeated "Do not use / Instructions / Limitations" boilerplate that each source skill
  carried verbatim — not reproduced more than once in SKILL.md.
- The identical SuperScalar link block appeared in all three Lightning skills; kept once.
- The `resources/implementation-playbook.md` pointer (in every source skill) refers to a file
  that does not exist — dropped.
- "Assets/scripts" lists (staking-contract.sol, hardhat-config.js, test-suite.js, etc.) in
  resource sections point to files that do not exist in any source directory — not carried;
  the actual code was inlined into references instead.

## Notable gaps / doubts

- Sources have **no scripts/ directories** at all; nothing to carry.
- `defi-protocol-templates` advertises a lending/borrowing template but ships no code —
  documented as notes in `references/defi-protocols.md#lending-notes`.
- Founder/persona prose (behavioral traits) from blockchain-developer was summarized rather
  than reproduced verbatim.
- SuperScalar URLs point to a real project but were not independently verified.