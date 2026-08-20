# Game Design Principles

> Design thinking for engaging games. Fun is discovered through iteration, not designed on paper.

## Core loop design — the 30-second test

Every game needs a fun 30-second loop:

```
1. ACTION   -> Player does something
2. FEEDBACK -> Game responds
3. REWARD   -> Player feels good
4. REPEAT
```

| Genre | Core loop |
|-------|-----------|
| Platformer | Run -> Jump -> Land -> Collect |
| Shooter | Aim -> Shoot -> Kill -> Loot |
| Puzzle | Observe -> Think -> Solve -> Advance |
| RPG | Explore -> Fight -> Level -> Gear |

## Game Design Document (GDD)

Essential sections:

| Section | Content |
|---------|---------|
| Pitch | One-sentence description |
| Core loop | 30-second gameplay |
| Mechanics | How systems work |
| Progression | How player advances |
| Art style | Visual direction |
| Audio | Sound direction |

A fuller GDD also covers: executive summary (elevator pitch + USPs), gameplay (core-loop diagram, abilities, win/loss, difficulty curve), world & narrative, art direction (color palette with hex codes, UI/UX style), audio direction (music per scene, SFX categories, voice), technical spec (engine version, render pipeline, performance budgets, SDKs), monetization strategy, and a development roadmap with a priority matrix (Must/Should/Could/Won't).

**Principles:** keep it living (update regularly); visuals help communicate; less is more (start small). Even solo projects benefit from a written GDD.

## Player psychology

**Motivation types (Bartle):**

| Type | Driven by |
|------|-----------|
| Achiever | Goals, completion |
| Explorer | Discovery, secrets |
| Socializer | Interaction, community |
| Killer | Competition, dominance |

**Reward schedules:**

| Schedule | Effect | Use |
|----------|--------|-----|
| Fixed | Predictable | Milestone rewards |
| Variable | Addictive | Loot drops |
| Ratio | Effort-based | Grind games |

## Difficulty balancing

```
Too Hard -> Frustration -> Quit
Too Easy -> Boredom     -> Quit
Just Right -> Flow      -> Engagement
```

| Strategy | How |
|----------|-----|
| Dynamic | Adjust to player skill |
| Selection | Let player choose |
| Accessibility | Options for all |

## Progression design

| Type | Example |
|------|---------|
| Skill | Player gets better |
| Power | Character gets stronger |
| Content | New areas unlock |
| Story | Narrative advances |

**Pacing:** early wins (hook quickly), gradually increase challenge, rest beats between intensity, meaningful choices.

## Anti-patterns

| Don't | Do |
|-------|-----|
| Design in isolation | Playtest constantly |
| Polish before fun | Prototype first |
| Force one way to play | Allow player expression |
| Punish excessively | Reward progress |
