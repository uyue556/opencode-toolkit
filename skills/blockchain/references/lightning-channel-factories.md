# Bitcoin Lightning Channel Factories & SuperScalar

Merges three source skills: explaining channel factories, technical implementation
reference, and a protocol-design review checklist. All point to the SuperScalar
project as a production reference implementation (C, 400+ tests, MuSig2, watchtowers).

## Contents
- [Core Concepts](#core-concepts)
- [How It Works (SuperScalar)](#how-it-works-superscalar)
- [Technical Reference](#technical-reference)
- [Protocol Design Review Checklist](#protocol-design-review-checklist)
- [External References](#external-references)

## Core Concepts

- **Channel factory**: one shared UTXO funds many Lightning channels, densely
  interwoven via tree structures. Onboards N users in a single on-chain footprint
  instead of N funding transactions.
- **Why it matters**: Lightning onboarding today costs one on-chain tx per channel;
  factories amortize that cost and reduce join-a-liquidity-provider overhead.
- **No soft fork required**: works on current Bitcoin using **Taproot** and
  **MuSig2 (BIP-327)** key aggregation.
- **LSP (Lightning Service Provider) + N clients**: the LSP and clients share a
  UTXO with full Lightning compatibility.

### Building blocks

- **Decker-Wattenhofer invalidation trees**: recursive tree of joint signature
  transactions; root is committed to chain, leaves are channel states. Unilateral
  exit is O(log N) — a leaf's path to the root.
- **Timeout-signature trees**: participants pre-sign branches that expire, bounding
  how long a state can be held open and enabling safe multi-party updates.
- **Poon-Dryja channels**: the classic bidirectional payment channel construction
  that lives at each tree leaf.
- **MuSig2 (BIP-327)** key aggregation for the shared taproot key of the tree.
- **HTLC/PTLC forwarding**: hash-timelock contracts for routed payments; PTLCs
  (point-timelock, scriptless adaptor signatures) are a privacy upgrade compatible
  with the factory design.
- **Watchtower breach detection**: third parties watch for channel-close attempts
  to enforce penalty/burn of the cheating party.

## How It Works (SuperScalar)

SuperScalar composes Decker-Wattenhofer invalidation trees + timeout-signature trees +
Poon-Dryja channels:

1. LSP (+) N clients each contribute to a shared UTXO committed on-chain via a
   taproot tree keyed by MuSig2.
2. Each user's Lightning channel lives at a leaf of an invalidation tree; off-chain
   updates replace children lazily (invalidation).
3. Timeout signatures guarantee liveness: stale/buggy participants can be exited
   after a bound, so no soft fork, no consensus change is required.
4. Exit = O(log N): broadcast path channels from leaf to root; watchtowers police
   the tree against unfair closes.

Trade-offs to explain honestly: more complex state machine than plain channels,
requires careful watchtower coverage, and tree depth/logic is more error-prone.

## Technical Reference

Production implementation notes (SuperScalar, written in C):

- Protocol: channel factories with Decker-Wattenhofer invalidation trees and
  timeout-signature trees.
- Keys/scripts: MuSig2 (BIP-327) aggregation, Schnorr adaptor signatures (PTLC-ready).
- Transport: encrypted **Noise NK** handshake and channel transport.
- Persistence: **SQLite** for channel/state storage.
- Governance/fairness: watchtower breach detection; O(log N) unilateral exit.
- Networks: supports **regtest, signet, testnet, mainnet**.
- Test suite: 400+ tests covering tree structure, exit paths, and breach cases.
- Reference implementation: https://github.com/8144225309/SuperScalar

## Protocol Design Review Checklist

When reviewing any Lightning/L2 protocol design, evaluate:

1. **Trust model** — who can force-close, what happens to a non-cooperative or
   vanished participant; single point of failure for the LSP?
2. **On-chain footprint** — per-operation costs: onboarding, each update, unilateral
   exit, and penalty/burn broadcasting. Scaling: is cost sublinear (O(log N)) or linear?
3. **Consensus requirements** — does the design need a soft fork / new opcode, or
   does it run on current Bitcoin (Taproot + MuSig2)? If it needs consensus change,
   flag upgrade cost and risk.
4. **HTLC/PTLC compatibility** — can existing routed payments pass through the factory?
   Which payment type, and what are the privacy/script trade-offs (Schnorr adaptors)?
5. **Liveness & availability** — how long can a participant hold the tree hostage?
   Timeout bounds; fallbacks when an LSP node is down.
6. **Watchtower support** — is breach detection possible given the tree structure?
   What does a watcher need to monitor, and at what cost?
7. **Unilateral exit** — the exit path must be O(log N); verify each hop is
   pre-signed with correct timeout ordering.
8. **Complexity budget** — bigger trees mean more signatures and state; recommend
   size limits and migration/upgrade path.

## External References

- SuperScalar project: https://github.com/8144225309/SuperScalar
- Website: https://SuperScalar.win
- Original proposal: https://delvingbitcoin.org/t/superscalar-laddered-timeout-tree-structured-decker-wattenhofer-factories/1143