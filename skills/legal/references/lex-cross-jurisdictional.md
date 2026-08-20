# LEX — Cross-Jurisdictional Truth Engine (USA / Canada / EU)

Merged from the `lex` skill and its 5 templates (`01_business_foundation`, `02_employment_workforce`,
`03_sales_commercial`, `04_real_estate`, `05_intellectual_property`). Purpose: eliminate legal
hallucination by grounding drafting in official government sources across 29 jurisdictions (USA,
Canada, +27 EU member states). For the full official-portal list see `lex-findings.md`.

## Workflow

1. **Identify jurisdiction** — is the entity/contract target in the USA, Canada, or the EU?
2. **Search & fetch context** — find the relevant legal pattern/template; read granular metadata.
3. **Scaffold drafting** — generate the foundation-level document using the matching template;
   every draft includes the mandatory AI-generated-content disclaimer.
4. **Verify authority** — always include a "Verified Sources" section with official government links
   (US `*.gov`, EU `*.europa.eu`, CA `*.gc.ca` / `*.canada.ca`).

## Rules

- **Trust but verify:** always attach the official links in your output.
- **Table format:** use tables when comparing jurisdictions.
- **No guessing:** if a jurisdiction is outside US/CA/EU, state that it is outside LEX coverage.
- **No anecdotal advice:** stick to template findings and verified government domains.

## Jurisdiction nuance tables (from templates)

### Business foundation (entity types)

| Contract | USA | Canada | EU |
|---|---|---|---|
| Operating Agreements (LLC) | State-variable (Delaware vs California) | LLCs don't inherently exist; use Shareholder/Partnership or ULCs | LLC-equivalents (GmbH, SARL, s.r.o.) need highly formalized AoA/Statutes |
| Shareholders' Agreements | C/S-Corps; equity, Board, vesting | Common under CBCA/OBCA; USA-type unanimous agreements | Strict local corporate codes; statutory pre-emption rights |
| Partnership Agreements | GP/LP/LLP standard | Provincial Partnership Acts | Variable: separate legal personality in some states, not others |
| Articles of Association | "Articles of Incorporation"/"Certificate of Formation" | Model articles | Comprehensive public "rulebook" aligned with EU Company Law Directives |

### Employment & workforce (highest variance)

| Contract | USA | Canada | EU |
|---|---|---|---|
| Employment Agreements | "At-Will" focus | "Reasonable Notice" (Common Law) or statutory minimums | No at-will; statutory notice periods (e.g., Zákoník práce CZ), fixed-term limits, Working Time Directive |
| Independent Contractor | Avoid IRS/DOL misclassification; emphasize lack of control | CRA "Personal Services Business" rules | Misclassification heavily penalized; subordination elements forbidden (CZ "Švarcsystém") |
| NDA | Unilateral/mutual; perpetual for trade secrets | Similar; detail trade-secret definition | Similar; bound by whistleblowing directives |
| Non-Compete | Banned/restricted in several states (e.g., California) | Enforceable only if narrowly tailored | Highly restricted; garden leave or mandatory compensation (CZ Konkurenční doložka ≥50% avg monthly earnings) |
| IP Assignment | "Work Made For Hire" standard | Similar; moral rights must be waived | Extremely localized: DE/FR full transfer impossible; CZ only usage licenses for personal rights |

### Sales & commercial

| Contract | USA | Canada | EU |
|---|---|---|---|
| MSA | Umbrella; limits of liability crucial; state common law | Similar; often ON/BC jurisdiction | B2B commercial regulations of member states |
| SOW | Below MSA; defines deliverables | Same | Same |
| Bills of Sale | UCC implied warranties | Provincial Sale of Goods Acts | Consumer Rights Directive: right of withdrawal (14 days) + minimum 2y guarantees |
| ToS | Arbitration + class-action waivers common | Similar; QC class-action waivers often unenforceable | Unfair Contract Terms Directive; arbitration vs consumers needs explicit secondary consent |
| Privacy Policies | Fragmented (CCPA/CPRA, COPPA, HIPAA) | PIPEDA (federal) + QC Law 25 | GDPR: opt-in consent, right to be forgotten, DPAs |

### Real estate & facilities

Real-estate law is almost entirely localized — templates are structural frameworks, not plug-and-play
advice. Residential forms often MUST be the statutory version from the local government. Distinguish
clearly: a **Lease** grants exclusive possession; a **License** grants permission to use. EU examples:
France's 3-6-9 commercial leases; Germany's rent control and near-indefinite residential leases; CZ
Civil Code (Občanský zákoník). Canada: LTB (Ontario), TAL (Quebec) with government-mandated lease forms.

### Intellectual property

| Contract | USA | Canada | EU |
|---|---|---|---|
| Licensing | Highly flexible (geo/time/market) | Similar; moral rights considered | EU competition law; exclusive licenses can't block parallel imports (Single Market) |
| Franchise | FTC + state regulation; bulky FDD | Provincial disclosure (BC, AB, ON, NB, MB, PEI) | Member-state level (e.g., FR Loi Doubin) |
| Software Development | "Work Made For Hire" gives copyright to payer | Author holds raw copyright until explicit written assignment; waive moral rights | Some states (FR, DE) cannot transfer copyright — only exclusive usage licenses (CZ personal rights) |

## Examples

- Compare US vs EU notice periods → use the employment-workforce template (jurisdiction table above).
- Draft a Czech house-sale contract → use N-Lex for the specific Civil Code/property act sections;
  produce the scaffold in Czech with a Verified Sources section.

## Common pitfall

Legal hallucination about specific EU notice periods → always pull the employment table / official
labor-code reference (e.g., CZ Act No. 262/2006 Coll.) before asserting a number.

## Related references

- `contracts-compliance-drafting.md` for the drafting discipline and disclaimers.
- `employment-contract-playbook.md` for full generic employment templates (jurisdiction-neutral).
- `lex-findings.md` for the per-country official legal portals.
