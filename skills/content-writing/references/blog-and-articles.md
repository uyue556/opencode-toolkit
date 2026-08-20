# Blog Posts & Articles

Standards for blog posts, articles, tutorials, and platform publishing. Merges Sentry's blog standards, the SEO-AEO structure, WordPress + Yoast writing, Dev.to/Hashnode publishing, and tutorial engineering.

## Table of Contents
1. Blog post standards (the "would I share this?" bar)
2. Structure & sections
3. SEO-AEO long-form structure
4. Tutorials
5. WordPress + Yoast + JSON-LD
6. Dev.to / Hashnode publishing
7. Content types map

## 1. Blog Post Standards

Set the bar: every post should be something a senior practitioner would share with their team or reference in a decision — specific, technically credible, mildly irreverent, never corporate.

**Banned language:** "We're excited to announce," "best-in-class," "cutting-edge," "seamless," "empower/leverage/unlock," "robust," "streamline," "At [Company], we believe…," filler transitions ("That said," "It's worth noting," "At the end of the day"), and "In this post, we will explore."

**Non-negotiables:**
- A real human byline, never "The Team."
- Code that works (tested, with imports, config, context).
- A diagram if a system has more than two interacting components.
- Numbers for any performance claim.
- For decisions: explain what you didn't choose and why.
- A defined "who is this for" before writing.

**The "Would I share this?" test.** A shareable post contains at least one of: a technical decision with trade-offs, original data, a real debugging story, an honest accounting of something that went wrong, or a how-to that saves real time. Otherwise it belongs in the changelog.

## 2. Structure & Sections

Order sections by what the reader is asking, not your narrative:

1. **What problem does this solve?** (1-2 paragraphs max)
2. **How does it actually work?** — the underlying mechanism, not button clicks (bulk of the post)
3. **What were the trade-offs or alternatives?** (separates good from great)
4. **How do I use/try/implement this?**
5. For deep-dives: **what didn't work** and **known limitations** (builds trust).

**Titles** make a specific claim, tell a story, or promise a payoff:
- Strong: "Your JavaScript bundle has 47% dead code. Here's how to find it."
- Weak: "Performance improvements in Sentry."

**Headings** must carry information ("Why time-series pre-aggregation destroys debugging context," not "Background").

**Closing:** end with a link, a way to try it, or a concrete next step. Never generic hype or a recap.

## 3. SEO-AEO Long-Form Structure

For content that should rank AND be cited by AI engines (Perplexity, ChatGPT):

1. **TL;DR block first.** 2-3 sentence direct answer to the core question, in a blockquote right after the H1. This is the first block AI engines try to extract. It must answer a *specific* question.
2. **Heading skeleton before writing body.** H1 + 4-6 H2s; first H2 is a "What Is" section whose opening line is a clean, standalone definition sentence.
3. **Section order:** What Is → Why It Matters → How It Works (H3 sub-concepts) → Practical Steps → Common Mistakes → FAQ → Conclusion.
4. **Exactly 5 FAQ entries.** Questions use long-tail/secondary keywords. Each answer < 50 words and fully self-contained (no "as mentioned above").
5. **Comparison table** wherever the topic compares options.

Add a **Truth Box** (5 key-point table) right after the introduction when the format permits it.

## 4. Tutorials

Tutorials teach a skill through progressive practice:

- **Learning objective first:** "After this tutorial, you will be able to ______." Use measurable verbs (build, debug, optimize), not "understand."
- **Concept decomposition:** each concept explainable in a few paragraphs; no concept depends on something introduced later (no forward references).
- **Rhythm per section:** Concept intro (with one analogy) → minimal runnable example → guided practice with expected output → variation → challenge → troubleshooting.
- **Learn-by-doing:** every concept gets immediate practice. Pattern: I do → We do → You do.
- **Cognitive load:** ≤ 2-3 new concepts per section; code examples fit a screen; every line of code teaches something.
- **Time budget:** reader starts doing within minutes; give realistic time estimates.
- **Error tables:** Error message → Cause → Fix.
- **Code discipline:** copy-paste-runnable, imports included, expected output shown, real values not `foo/bar`.

## 5. WordPress + Yoast + JSON-LD

To generate publication-ready WordPress posts:

- Inputs to confirm: title, primary keyword, intent (informational/commercial/transactional), niche, optional Yoast SEO + image count.
- Research requirement: if browsing, review ≥10 sources; if not, disclose the limitation and never claim unverified source counts or "industry estimates suggest" without evidence.
- Output order: full post → (if requested) Yoast metadata → (if requested) JSON-LD schema (`BlogPosting`, `FAQPage`).
- Yoast batch: focus keyphrase, SEO title, slug, meta description, social title, social description, suggested internal/external links.
- Image SEO: per-image alt text (at least one must carry the primary keyword), title, caption, description, placement; always include a Featured Image.
- Formatting rules: no numbered headings, no long dashes, short sentences, `|` tables, no hyphen bullets in the contents block.

## 6. Dev.to / Hashnode Publishing

**Cross-posting and canonical URLs** (protect your SEO):
1. Publish on your own blog first (canonical). 2. Wait 1-2 days for indexing. 3. Cross-post to Dev.to and Hashnode with `canonical_url` pointing to your original.
- Dev.to: frontmatter supports `title`, `published`, `description`, `tags` (max 4), `cover_image`, `canonical_url`, `series`.
- Hashnode: set SEO title/description (155 chars), 1600x840 cover, enable ToC for long posts.

**What performs:** beginner tutorials and listicles on Dev.to (broader, more beginner audience); in-depth tutorials, architecture and DevOps posts on Hashnode (more senior). **Engage:** reply to every comment within 24h, turn posts into series, end with a question to drive comments.

**Metrics that matter:** views, reactions, comments, read ratio / time, followers-from-post. Low views → better title/tags; low comments → end with a question; high bounce → better hook and structure.

## 7. Content Types Map

| Type | Best for | Structure |
|------|----------|-----------|
| Tutorial | Teaching a skill | Step-by-step, code-heavy |
| Guide | Comprehensive coverage | Sections + reference material |
| Comparison | Decisions | Table-based pros/cons |
| Announcement | Launching features | News lead, what/why/how |
| Thought leadership | Authority | Opinion, predictions |
| Case study | Social proof | Problem → Solution → Results |
| Troubleshooting | Fixing errors | Error → Cause → Fix |

**Do not write** if: you're the only one who cares, 10 identical posts exist, or the topic is too broad ("Introduction to JavaScript").