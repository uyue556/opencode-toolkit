# Learning & Teaching Methods

Covers adaptive tutoring (DAIR.AI *learn*), the mission-based teaching
workspace (*teach*, Matt Pocock), and classroom puzzle activity planning
(*puzzle-activity-planner*).

## 1. Adaptive Tutoring Loop

For conversational tutoring, small questions, and study plans.

1. **Diagnose** — current familiarity, goal/use case, preferred depth, time
   available, format preference. Ask at most 1–3 short questions; only when the
   missing information would materially change the lesson. If the user wants to
   begin immediately, state a reasonable assumption and start.
2. **Pick a small next objective** — one useful concept at a time. Avoid
   covering a whole subject in one pass unless a survey is explicitly requested.
3. **Teach with a concrete example before abstractions.** Use plain language
   first, then introduce precise terms once the learner has a handle on the
   idea.
4. **Give an active task** — retrieval questions, prediction prompts, a worked
   example followed by a similar problem, debugging/critique tasks, short
   applied exercises, spaced review of earlier ideas.
5. **Provide immediate, specific feedback** — explain why the right answer is
   right and why tempting wrong answers fail.
6. **Record the next step** when useful.

### Difficulty banding

- **Beginner**: simple vocabulary, worked examples, frequent checks.
- **Intermediate**: comparison, practice, common failure modes.
- **Advanced**: compression, edge cases, tradeoffs, realistic tasks.

### Quality bar for a lesson

- Matches the learner's level and goal.
- Has at least one concrete example.
- The practice task is solvable from the lesson.
- Answer key / feedback included (in a self-contained response) or the learner
  is asked to attempt first (interactive back-and-forth).
- Next step is clear; any generated files/code actually work in the target
  environment.

### Check design

- MCQs: only one answer clearly correct unless multiple is asked; distractors
  unambiguous.
- Also good: short-answer prompts, fill-in-the-blank, explain-the-mistake,
  code tracing/prediction, mini-projects with clear success criteria.
- For programming, don't pretend to execute code unless the environment runs
  it; provide fixed snippets with expected outputs and reasoning.

## 2. Long-Term Learning Science

- **Fluency strength vs storage strength.** Fluency (in-the-moment retrieval)
  gives an illusory sense of mastery. Storage strength (long-term retention) is
  the real goal. Build it with **desirable difficulty**: retrieval practice
  (recall from memory), spacing (distribute practice over time), and
  interleaving (mix related topics — skills practice only).
- For knowledge acquisition, *difficulty is the enemy* (it eats working
  memory). For skill acquisition, *difficulty is the tool* (effortful retrieval
  builds storage).
- Lessons should be short and completable quickly; each gives one tangible win
  tied to the mission, in the zone of proximal development.

## 3. Multi-Session Teaching Workspace

For stateful learning across many sessions, treat the working directory as a
teaching workspace with these files. Create them lazily.

- **`MISSION.md`** — the *reason* the user is learning this topic; grounds all
  teaching. One mission per workspace. Format: `Why` (concrete outcome),
  `Success looks like` (observable things), `Constraints`, `Out of scope`.
  Concrete over abstract; push back on vagueness; keep under a screen; revise
  when reality shifts.
- **`RESOURCES.md`** — curated trusted sources for knowledge plus communities
  for wisdom. Annotate every entry (what it covers, when to reach for it).
  Prefer primary sources and strong moderation; prune ruthlessly; surface gaps
  explicitly. Never trust parametric knowledge when a resource can be found.
- **`GLOSSARY.md`** — canonical language for the workspace. Add a term only
  once the user understands it. Be opinionated (pick one term, list aliases to
  avoid); keep definitions tight; use glossary terms inside other definitions;
  flag ambiguities; revise in place as understanding deepens.
- **`./learning-records/NNNN-slug.md`** — decision-grade insights, like ADRs.
  Write one when the user demonstrates genuine understanding of something
  non-trivial, discloses prior knowledge (record the depth claimed), corrects a
  misconception, or the mission shifts. Do NOT log mere coverage or session
  journals. Number sequentially; on contradiction, mark the old record
  `Status: superseded by LR-NNNN` rather than deleting it. Used to compute the
  zone of proximal development.
- **`./lessons/NNNN-slug.html`** — the primary teaching unit: one tightly
  scoped, self-contained, beautiful lesson (Tufte-style typography) that the
  user can review later. Link via anchors to other lessons and reference docs.
  Recommend one primary high-trust source per lesson; include citations for
  claims; remind the user they can ask follow-up questions.
- **`./reference/*.html`** — compressed, print-friendly cheat sheets, reference
  algorithms, syntax, glossaries. Lessons are rarely revisited; reference docs
  are — invest in them. Glossaries, once created, must be adhered to everywhere.
- **`./assets/*`** — reusable components (shared stylesheet first, quiz
  widgets, simulators). Reuse is the default: read `./assets/` before
  authoring, never inline something a second lesson would duplicate.
- **`NOTES.md`** — scratchpad for user preferences and working notes.

### Quizzes inside lessons

- Feedback loop should be tight — immediate and ideally automatic.
- For quiz answers, use equal word/character counts across options so formatting
  leaks no clue.

### Wisdom

When a question needs real-world judgment, attempt an answer but ultimately
delegate to a **community** (forum, subreddit, class, local group) where the
learner can test skills. Find high-reputation communities; respect opt-out
preferences.

## 4. Puzzle-Based Classroom & Event Activities

Plan puzzle activities for classrooms, parties, team-building, or events.

**Process:** (1) understand the event — audience, group size, duration, theme;
(2) select puzzle types matched to the audience; (3) build a minute-by-minute
timeline with transitions and timing buffers; (4) generate one-click
pre-configured generator links with theme content baked into URL parameters;
(5) create a materials/prep checklist with print quantities.

**Puzzle types:** word search (vocab, warm-ups), crossword (vocab review, test
prep), sudoku (math warm-ups, logic), bingo (group review), jigsaw
(ice-breakers, collaboration).

**Output plan:** activity header (occasion/audience/duration/difficulty), 2–3
objectives, puzzle menu table with links, timeline, materials checklist,
differentiation tips (easier/harder adaptations).

**Rules:** match difficulty to audience; suggest 2–3 puzzle types for variety;
apply the theme consistently; always pre-fill URL parameters.

Example generator URLs:
```
https://jigsawmake.com/word-search-maker?title=Ocean%20Animals&words=DOLPHIN,OCTOPUS,SEAHORSE&gridSize=12
https://jigsawmake.com/crossword-puzzle-maker?title=Science&clues=GRAVITY:Force%20pulling%20down|OXYGEN:Gas%20we%20breathe
https://jigsawmake.com/bingo-card-generator?title=Party%20Bingo&items=Dance,Laugh,Sing&cardCount=25
```

## 5. Output-Format Discipline

Choose the lightest format that satisfies the request: conversational lesson,
study plan (multi-session), markdown notes, exercises/quizzes, code examples,
diagrams/tables. Files, notebooks, slides, or web pages only when requested or
clearly useful. For multi-day plans, include cadence, daily focus, active
practice, and review checkpoints.
