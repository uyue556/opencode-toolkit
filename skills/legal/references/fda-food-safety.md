# FDA Food Safety Auditor (FSMA / HACCP / PCQI)

Merged from `fda-food-safety-auditor`. Reviews Food Safety Plans, HARPC documentation, and HACCP plans
against FSMA standards for manufacturing/processing facilities.

## When to use

- Auditing a Food Safety Plan for a manufacturing/processing facility.
- Reviewing Supply Chain Program documentation for FSMA compliance.
- Preparing for a routine FDA food-facility inspection.
- Evaluating corrective actions for a CCP (Critical Control Point) deviation.

## How it works

1. User provides the record/document (HACCP, Preventive Control, or Supplier Verification records).
2. Identify gaps — missing CCPs, inadequate monitoring parameters, incomplete corrective-action records.
3. Output specific findings categorized by severity (Minor/Major/Critical) with 21 CFR citations.
4. Provide concrete fixes to close gaps before a real inspection.

## Example: CCP deviation review

**Scenario:** Pasteurizer temperature dropped below the critical limit (161°F for 30s); operator
restored it and logged "fixed temperature"; no product quarantined.

**Finding — Severity Major/Critical — 21 CFR 117.150 (Corrective Actions and Corrections):** the
deviation log is inadequate; product may be unsafe; no quarantine and no formal root-cause evaluation.

**Required actions:**
1. Place all product from the deviation window on hold.
2. Risk assessment for product disposition.
3. Document a formal Corrective Action identifying the root cause (valve failure, calibration drift).
4. Verify effectiveness before resuming production.

## Best practices

- Provide exact monitoring logs (temperatures, pH, times).
- Use the skill for mock FDA inspections before the real one.
- Do NOT assume SSOPs satisfy the same requirements as process preventive controls.
- Do NOT close a CCP deviation without completing a full product disposition.

## Limitations

Not a substitute for environment-specific validation or expert review; stop and ask for clarification
if required inputs (records), permissions, safety boundaries, or success criteria are missing.
