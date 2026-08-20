# FDA MedTech Compliance Auditor (SaMD / IEC 62304 / 21 CFR 820)

Merged from `fda-medtech-compliance-auditor`. Focus: Software as a Medical Device (SaMD) and
traditional medical equipment regulation — 21 CFR Part 820 (Quality System Regulation), IEC 62304
(Software Lifecycle), ISO 13485, ISO 14971 (Risk Management), 21 CFR Part 11 (electronic records).

## When to use

- Reviewing Software Validation Protocols for medical devices.
- Auditing a Design History File (DHF) for a software-based diagnostic tool.
- Checking IT infrastructure against 21 CFR Part 11.
- Preparing a CAPA for a software defect.

## How it works

1. User specifies the document (or states the focus standard: Part 820, Part 11, ISO 13485,
   ISO 14971, IEC 62304).
2. Audit findings categorized by severity (Major, Minor, Opportunity for Improvement) with
   regulatory citations.
3. Actionable steps to resolve each finding and strengthen audit readiness.

## Example: CAPA root-cause review

**Scenario:** CAPA opened for a software defect in a Class II device. Documented root cause:
"developer error — unclear requirements." Corrective action: developer retraining.

**Finding — Severity Major — 21 CFR 820.100(a)(2) / IEC 62304 Section 5.1:** "Developer error" is a
symptom, not a root cause; retraining alone is a known red flag for FDA inspectors. The true root cause
lies in the software requirements-engineering process.

**Required actions:**
1. 5-Whys or Fishbone analysis targeting the requirements-gathering/review process.
2. Update the SRS and the corresponding process SOP.
3. Document an effectiveness check with a measurable criterion (e.g., zero requirements-related
   defects in next 3 releases).
4. Do not close the CAPA on retraining alone.

## Best practices

- Provide exact wording from SOPs, risk tables, or validation plans.
- Expect strict interpretations — find weaknesses before a real inspector does.
- Link every software defect to a clinical risk item in the ISO 14971 risk file.
- Do NOT assume "we tested it and it works" satisfies IEC 62304 verification.

## Limitations

Not a substitute for environment-specific validation or expert review; stop and ask for clarification
if required inputs, permissions, safety boundaries, or success criteria are missing.
