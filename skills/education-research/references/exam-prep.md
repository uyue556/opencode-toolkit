# Exam Prep & Revision Roadmap

Adapted from *examprep-ai*. Converts syllabi, past papers, and notes into a
prioritized "High Score Roadmap" with ranked question tables, notes per question
type, flashcards, a predicted paper, and a readiness dashboard.

## Read Only What You Need

| What the student asks | Use |
|---|---|
| Full roadmap / "what to study" | Full Roadmap Mode |
| Theory / definitions / explanations | Theory Notes |
| Numerical / calculation / derivation | Numerical Notes |
| MCQ / True-False practice | MCQ Notes |
| Coding / algorithm / trace / debug | Coding Notes |
| Lab / practical / viva | Lab Notes |
| Flashcards | Flashcards |
| Mock exam paper | Predicted Exam Paper |
| Score estimate / readiness | Exam Readiness Dashboard |

Always also load the shared foundations below. Do not load all sections for a
focused request.

## Shared Foundations

### Difficulty scale (universal)

| Level | Signal words | Student goal |
|---|---|---|
| Easy | define, state, list, name, identify, what is | guaranteed marks — study first |
| Medium | explain, describe, compare, calculate, implement, trace | mid-paper marks |
| Hard | derive, prove, optimize, analyze, evaluate, design, why | score separators — study last |

Order rule: always present **Easy → Medium → Hard**, never reversed.

### Intake (ask once, then proceed)

1. Collect at least one of: syllabus, past question papers, notes, or subject
   name + university.
2. Confirm course code if OCR confidence < 80%: "I detected [X] — is this
   correct?"
3. Ask time available. If no answer → default Standard Mode (6–12 hrs) and
   state the assumption.

### Study modes

| Mode | Time | Load |
|---|---|---|
| Emergency | 1–2 hrs | Easy only, top 10 questions |
| Sprint | 3–5 hrs | Easy + Medium, top 25 questions |
| Standard (default) | 6–12 hrs | All difficulties, full roadmap |
| Advance | Days+ | Daily schedule + mock papers |

### Syllabus guardrail

- Map every question to a syllabus unit (≥70% match → `[IN SYLLABUS]`).
- Never generate content for topics absent from the uploaded syllabus.
- Out-of-syllabus items → flag, ask before including.

### Probability score

```
Score = (Frequency × 0.40) + (Recency × 0.30) + (Unit Weight × 0.20) + (Marks × 0.10)
```

- Frequency: appearances ÷ max appearances × 100
- Recency: last 2 yrs = 100 · 3–4 yrs = 60 · older = 30
- Unit Weight: core = 100 · elective = 50
- Marks: 10+ = 100 · 5–9 = 60 · 2–4 = 30 · MCQ = 20

## Full Roadmap Mode

1. **Extract** all questions; note year/source. Confirm:
   "Extracted [N] questions from [M] papers for [Course]. Found:
   📝[A] 🔢[B] 🔘[C] 💻[D] 🧪[E]. Proceed?"
2. **Classify + tag difficulty** using the five-type table:

   | Type | Identify by |
   |---|---|
   | Theory | define, explain, discuss, compare, differentiate |
   | Numerical | calculate, find, solve, derive, prove, numbers in question |
   | MCQ/T-F | options listed, "true or false", "which of the following" |
   | Coding | write a program, implement, trace output, algorithm, flowchart |
   | Lab | experiment, procedure, observation, aim, apparatus, viva |

3. **Build ranked tables** (one per type):
   `# | Question | Times | Marks | Difficulty | Unit | Priority`
   with Priority `🔥 Must / ✅ Do`.
4. **Generate notes** using the matching type section below. Order: Easy across
   all types first → Medium → Hard.
5. **Coverage tracker**: per unit, mark `✅ past paper / ⚠️ predicted / — n/a`
   per type. For any gap, generate one predicted question + note, labelled
   `[PREDICTED — not from past papers]`.
6. **Offer** flashcards, a predicted paper, or a readiness dashboard.

## Note Templates by Type (difficulty × type)

### Theory
- **Easy (30s)**: ANSWER (2–4 bullets max) · KEY TERM · MEMORY HOOK.
- **Medium (2min)**: DEFINITION (1 sentence) · MAIN POINTS (• • • •) ·
  DIAGRAM (text description to sketch) · EXAM TIP (what the examiner rewards).
- **Hard (5min/10min write)**: INTRO · SECTION 1/2/3 (subtopic points) ·
  DIAGRAM · CONCLUSION · MARKS HINT (intro ~2, each section ~3, diagram ~2,
  conclusion ~1) · MEMORY (acronym/order trick).

### Numerical
- **Easy**: FORMULA · GIVEN→FIND · WORKED EXAMPLE (substitute, calculate,
  answer+unit) · COMMON MISTAKE · MEMORY HOOK.
- **Medium**: FORMULA(S) · APPROACH (which formula when) · WORKED EXAMPLE
  (setup, apply condition, calculate, verify) · WATCH OUT (the tripping
  condition) · EXAM TIP (show working — method marks).
- **Hard (derivation/proof)**: PREREQUISITES · DERIVATION (step by step from
  first principles) · WORKED EXAMPLE · MARKS BREAKDOWN (method vs answer) ·
  COMMON ERRORS.

### MCQ / True-False
- **Easy**: CORRECT · WHY CORRECT · WHY OTHERS WRONG (per option) · KEY FACT.
- **Medium**: CORRECT · REASONING (identify concept → apply rule → eliminate
  wrong) · TRAP (why students pick wrong).
- **Hard (trap/edge case)**: CORRECT · WHY TRICKY (assumption exploited) ·
  ELIMINATE (drop each, with reason) · RULE (the precise rule that settles it).

### Coding
- **Easy**: PATTERN (algorithm/structure) · TEMPLATE (minimal skeleton) ·
  KEY LINES (what the examiner looks for) · MEMORY HOOK.
- **Medium**: APPROACH (sub-tasks, data structures, step-by-step logic) ·
  ANNOTATED CODE · EDGE CASES · EXAM TIP (comment code).
- **Hard**: TRACE → iteration table (Iter · VarA · VarB · Output) + final
  output; OPTIMIZE → naive O(?) → optimized O(?) + key insight; DEBUG → bug
  location / type / fix / why it works.

### Lab
- **Easy**: AIM · APPARATUS · RESULT · KEY TERM.
- **Medium**: AIM/APPARATUS · PROCEDURE (step by step) · OBS TABLE (headers +
  example row) · RESULT (how to state conclusion) · PRECAUTIONS.
- **Hard (analysis/viva)**: ANALYSIS (result in context, formula, source of
  error) · VIVA Q&A (3 questions) · EXAM TIP (what viva examiners always ask).

## Flashcards

One card per question: `[TYPE EMOJI][DIFFICULTY EMOJI] Q: … A: 1–2 lines Key:
formula/term/pattern`.

## Predicted Exam Paper

One paper, all types represented, every question labelled type + difficulty.
Header banner: `AI PREDICTION — Not official. For practice only.` Sections:
A — Short/Objective (Easy), B — Medium Answer, C — Long Answer (Hard).

## Exam Readiness Dashboard

Grid of TYPE × (Easy/Medium/Hard/Overall) percentages, plus PREPAREDNESS %,
MARKS RANGE, STRONG / WEAK→FOCUS lists, and Confidence + basis (N papers).

## Quality Checks (before every output)

| Check | Rule |
|---|---|
| Syllabus compliance | Every note maps to a syllabus unit |
| Difficulty order | Easy before Medium before Hard — never reversed |
| Numerical accuracy | Worked examples compute correctly |
| Code validity | Snippets are syntactically correct |
| Note length | Readable in ≤2–5 min per note |
| No hallucination | No facts absent from uploaded materials |
| Course code confirmed | OCR-detected code verified by student |

## Error Responses

- No syllabus → ask for unit list as text.
- One past paper only → lower prediction confidence; more papers = better.
- OCR failure → ask student to retype.
- Out-of-syllabus question → skip; ask whether to include anyway.
- Mixed subjects → offer to separate.
- No time given → default Standard Mode, state assumption.
- No numericals/coding found → ask for a paper that includes them if the exam
  has these.

## Limitations

Prediction scores are heuristics from supplied materials; sparse/outdated inputs
reduce reliability. Never fabricate syllabus coverage. Not a substitute for
official course guidance, accessibility accommodations, academic-integrity
policies, or instructor feedback.
