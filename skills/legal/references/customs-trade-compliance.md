# Customs & Trade Compliance

Merged from `customs-trade-compliance` (core). Role: senior trade compliance specialist across US,
EU, UK, and Asia-Pacific. Systems: ACE (US), CHIEF/CDS (UK), ATLAS (DE), broker portals, screening
platforms, ERP trade modules. Goal: lawful, cost-optimised cross-border movement without penalties,
seizures, or debarment.

## Table of contents

- [1. HS tariff classification](#1-hs-tariff-classification)
- [2. Documentation requirements](#2-documentation-requirements)
- [3. Incoterms 2020](#3-incoterms-2020)
- [4. Duty optimisation](#4-duty-optimisation)
- [5. Restricted party screening](#5-restricted-party-screening)
- [6. Regional specialties](#6-regional-specialties)
- [7. Penalties and compliance](#7-penalties-and-compliance)
- [8. Escalation & KPIs](#8-escalation--kpis)

See also: `customs-decision-frameworks.md` (GRI/FTA/valuation/screening decision trees),
`customs-edge-cases.md` (10 full edge-case analyses), `customs-communication-templates.md`
(9 communication templates).

## 1. HS tariff classification

The Harmonized System is a 6-digit WCO nomenclature: 2 digits chapter, 4 heading, 6 subheading.
National extensions: US 10-digit HTS (Schedule B for exports), EU 10-digit TARIC, UK 10-digit commodity
codes. Classify strictly by the General Rules of Interpretation (GRI) in order:

- **GRI 1:** heading terms + Section/Chapter notes (resolves ~90%).
- **GRI 2(a):** incomplete/unfinished articles classified as complete if they have essential character.
- **GRI 2(b):** mixtures/composites by the material giving essential character.
- **GRI 3(a):** most specific heading; **3(b):** composite/sets by essential character component;
  **3(c):** if 3(a)/3(b) fail, the last heading numerically.
- **GRI 4:** most analogous goods; **GRI 5:** containers/packing; **GRI 6:** subheading level.

Common misclassification pitfalls: multi-function devices (primary function per GRI 3(b), not most
expensive component); food preparations vs ingredients (Chapter 21 vs 7–12 — check "prepared" status);
textile composites (weight % of fibres, not surface area); parts vs accessories (Section XVI Note 2);
software on physical media (the medium determines classification).

## 2. Documentation requirements

- **Commercial Invoice:** seller/buyer names+addresses, description sufficient for classification,
  quantity, unit price, total, currency, Incoterms, country of origin, payment terms (19 CFR § 141.86).
  Undervaluation → penalties under 19 USC § 1592.
- **Packing List:** weight/dimensions per package, marks matching the BOL, piece count. Discrepancies
  trigger examination.
- **Certificate of Origin:** varies by FTA (USMCA certification, EUR.1, Form A/GSP, UK origin
  declarations).
- **Bill of Lading / Air Waybill:** BOL is title+contract+receipt; carrier notations affect risk scoring.
- **ISF 10+2 (US):** filed 24h before vessel loading; 10 importer elements + 2 carrier; late/inaccurate →
  $5,000/violation liquidated damages.
- **Entry Summary (CBP 7501):** within 10 business days of entry; legal declaration — errors = penalty
  exposure under 19 USC § 1592.

## 3. Incoterms 2020

Incoterms are contractual terms (not law) that must be explicitly incorporated.

- **EXW:** buyer is exporter of record in seller's country — export-compliance risk; rarely appropriate.
- **FCA:** seller delivers to carrier, handles export clearance; 2020 allows on-board BOL for L/C.
- **CPT/CIP:** risk transfers at first carrier; CIP now requires Institute Cargo Clauses (A).
- **DAP:** seller bears all to destination except import clearance/duties.
- **DDP:** seller bears duties too; must be registered importer (or non-resident importer);
  circular-valuation risk if duty is included in invoice price.
- **Valuation impact:** CIF/CIP includes freight+insurance in customs value; FOB/FCA may add freight
  (US adds ocean freight; EU does not). Incoterms do NOT transfer title. FOB for containerised freight
  is technically wrong (use FCA).

## 4. Duty optimisation

- **FTA utilisation:** rules of origin vary — USMCA (product-specific rules, RVC, net cost), EU-UK TCA
  ("wholly obtained" + "sufficient processing"), RCEP (uniform rules, cumulation), AfCFTA (60% cumulation).
- **RVC:** TV method = (TV − VNM)/TV × 100; NC method excludes promotion/royalties/shipping — often
  higher when margins are thin.
- **FTZs:** goods not in customs territory; duty deferral, inverted tariff, no duty on waste/re-exports.
- **TIBs / ATA Carnet:** duty-free entry for equipment/samples; export within 1y (extendable to 3y) or
  full duty + bond premium.
- **Duty drawback:** 99% refund on subsequently exported goods; 3 types (manufacturing, unused,
  substitution); claims within 5y; TFTEA removed matching requirements for substitution claims.

## 5. Restricted party screening

Mandatory US lists: SDN (OFAC), Entity List (BIS), Denied Persons List (BIS), Unverified List, Military
End User List, Non-SDN Menu-Based. EU/UK: EU Consolidated Sanctions List, UK OFSI, UK Export Control
Joint Unit. Screen ALL parties (buyer, seller, consignee, end user, forwarder, banks, intermediate
consignees).

Red flags → enhanced due diligence: reluctant to give end-use info; unusual routing (free ports);
cash for expensive items; delivery to forwarder/trading company with no clear end user; capabilities
exceed stated application; no business background in product; inconsistent order patterns.

~95% of hits are false positives. Adjudicate: exact vs partial name match, address correlation, DOB,
country nexus, alias analysis; document every adjudication rationale. **Escalate true positives and
ambiguous cases to compliance counsel — never proceed with an unresolved hit.**

## 6. Regional specialties

- **US:** CEEs by industry; C-TPAT / Trusted Trader; ACE single window; Focused Assessments — prior
  disclosure before an FA starts is critical.
- **EU:** Common External Tariff; AEO (AEOC + AEOS); Binding Tariff Information (3y certainty);
  Union Customs Code (2016).
- **UK:** UK Global Tariff replaced CET; NI Protocol / Windsor Framework dual status; CDS replaced CHIEF.
- **China:** CCC certification for listed categories; 13-digit HS codes; e-commerce channels 9610/9710/9810;
  Unreliable Entity List screening.

## 7. Penalties and compliance

US framework (19 USC § 1592): **Negligence** 2× duties or 20% dutiable value (1×/10% with mitigation);
**Gross negligence** 4× or 40% (hard to mitigate); **Fraud** full domestic value + criminal referral.

**Prior disclosure (19 CFR § 162.74)** — the single most powerful mitigation tool: file before CBP
initiates investigation → caps penalties at interest (negligence) / 1× duties (gross negligence).
Requirements: identify the violation, give correct info, tender unpaid duties.

Record-keeping: 5y (19 USC § 1508); EU 3y (some states 10y). Failure to produce → adverse inference.

## 8. Escalation & KPIs

Automatic escalation: CBP detention/seizure → VP+legal within 1h; screening true positive → halt+notify
immediately; penalty exposure >$50k → VP+GC within 2h; confirmed SDN/denied party → full global stop
immediately; AD/CVD evasion investigation → outside counsel within 24h; FTA origin audit → notify
suppliers within 48h. Chain: Analyst → Trade Compliance Manager (4h) → Director (24h) → VP (48h) → GC
(immediate for seizures/SDN/>$100k).

KPIs: classification accuracy >98%; FTA utilisation >90%; entry rejection <2%; prior disclosures <2/yr;
screening adjudication <4h; CBP examination <3%; penalty exposure $0.

## When to use

Planning, auditing, or remediating customs/trade compliance: classifying products, designing
documentation flows, implementing Incoterms, optimising duty via FTA/FTZ/drawback/valuation,
investigating compliance risk or penalty exposure, screening issues.
