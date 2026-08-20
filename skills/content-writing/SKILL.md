---
name: content-writing
description: "Consolidated content-writing skill: write, edit, and publish high-quality written content — blog posts, articles, copywriting, storytelling, technical documentation, newsletters, social posts, and scientific/academic writing. Use whenever the user asks to 写文章, 写博客, 文案, 改写, 润色, 去AI味, proofread, blog post, article, copy, landing page, newsletter, technical docs, README, ADR, tutorial, SEO content, story, essay, or publish to Dev.to/Hashnode/WordPress."
risk: safe
source: consolidated from content (66) + writing (3) + creative (2) libraries
---

# Content Writing

Write clear, credible, human-sounding content that earns attention and survives editing. This skill consolidates 71 source skills into one workflow: know the reader → choose the format → write with an honest, concrete voice → structure for the medium → edit out AI tics → verify accuracy before publishing.

## When to Use

- Blog posts, articles, tutorials, and long-form content (blog, Dev.to, Hashnode, WordPress)
- Copywriting for ads, landing pages, product pages, email sequences, internal comms
- Storytelling, essays, opinion pieces, and creative prose (incl. Chinese 中文评论/随笔)
- Technical documentation: README, API docs, ADRs, wikis, changelogs, reference guides
- SEO / AEO content planning, keyword targeting, meta and featured-snippet optimization
- Editing and proofreading: grammar fixes, humanizing AI text, 去AI味/降AIGC
- Scientific papers, reports, and citation management
- Newsletters, status updates, and cross-platform distribution

## Core Workflow

1. **Know the reader.** Audience, awareness stage, and pain point come before a single word. If any are unclear, ask (or use the devrel audience-context pattern from `references/technical-writing.md`).
2. **State the problem or the conclusion up front.** Never open with background, hype, or company history. The first 2-3 sentences decide whether anyone keeps reading.
3. **Choose the format for the goal** (see Routing table) and write to that structure.
4. **Write with specific, concrete evidence.** Numbers over adjectives; trade-offs over claims; honest limitations build trust.
5. **Edit in two passes.** First technical/accuracy (claims, code, links), then editorial (voice, rhythm, AI tics). See `references/editing-and-proofreading.md`.
6. **Verify before publishing.** Test code, click links, confirm dates/versions, keep a change log of your edits.

## Selection Routing

| Task | Reference file |
|------|----------------|
| Blog post / article / SEO-AEO structure / WordPress / Dev.to–Hashnode publishing | `references/blog-and-articles.md` |
| Tutorials (step-by-step teaching content) | `references/blog-and-articles.md` (§ Tutorials) |
| Conversion copy, landing page, ads, content marketing strategy, internal comms | `references/copywriting-and-marketing.md` |
| Essays, opinion pieces, creative prose, Socratic explanations, Chinese 评论/随笔 | `references/storytelling-and-creative.md` |
| README, API docs, ADRs, wikis, reference guides, changelogs, agent-friendly docs | `references/technical-writing.md` |
| DevRel content for developers | `references/technical-writing.md` (§ DevRel) |
| SEO planning, keywords, meta, snippets, content clusters, E-E-A-T | `references/seo-content.md` |
| Proofreading, humanizing AI text, 去AI味/降AIGC, style transfer, concise rewrites | `references/editing-and-proofreading.md` |
| Papers, reports, citations, IMRAD | `references/scientific-and-academic.md` |
| Newsletters, status updates, daily reports, distribution | `references/newsletters-and-distribution.md` |

## Best Practices (cross-cutting)

- **Write like a senior practitioner, not a press release.** Specific, opinionated, direct. One good joke is enough; humor must serve the content.
- **Numbers beat adjectives.** "p99 went from 340ms to 45ms" beats "significantly faster." If you can't verify a number, don't invent one — state that no reliable estimate exists.
- **Show the trade-offs.** A post that explains what you didn't choose (and why) separates great from good.
- **Headings must convey information.** "Background / Architecture / Results" is weak; "Why pre-aggregation destroys debugging context" is strong.
- **Structure follows the reader's questions**, not your internal narrative: What problem → How it works → What were the trade-offs → How do I use it.
- **End with something useful** (a link, a CTA, a next step), never a recap or generic hype.
- **Keep it scannable**: short paragraphs (2-3 sentences), lists, tables, descriptive headings.

## Do & Don't

**Do:**
- Open with a specific problem or a conclusion.
- Mirror the reader's own language for their problem.
- Cite primary sources; link official docs; include dates and versions.
- Acknowledge limitations; if it's beta, say beta.
- Proofread twice: once for meaning/accuracy, once for voice.

**Don't:**
- Use banned marketing words: "seamless," "best-in-class," "empower," "leverage," "unlock," "robust," "streamline," "cutting-edge."
- Use AI tics: em-dash overload, "It's not X, it's Y," "In today's world," "Let's explore," "Ultimately," "It's important to note," rule-of-three padding, hollow intensifiers.
- State beliefs as announcements ("At [Company], we believe…"). Just state them.
- Claim AI does more than it can ("finds the root cause" ≠ "suggests a likely root cause").
- Fabricate citations, data, or vague "industry estimates suggest" claims.

## Common Pitfalls

1. **Writing before knowing the audience** — style without a psychological mechanism doesn't change beliefs (see copywriting reference).
2. **Buried lede** — putting the answer last; developers and readers want the answer first.
3. **Padded word count** — when in doubt, go deeper on substance, not length. Silence beats slop.
4. **Untested code/examples** — every snippet must run as written, with imports, expected output, and error handling.
5. **Skipping the editorial pass** — AI-generated text carries cadence tells; always run the AI-tell checklist before publishing.
6. **Over-optimizing for search** — thin or keyword-stuffed content loses; write for humans, optimize after.

## Selection Check

- Name and purpose clear; trigger matches (English + Chinese keywords in description).
- Route detail to the matching `references/*.md`; don't inline it here.
- Every claim below traces to a source skill (see `dedup-notes.md`).
