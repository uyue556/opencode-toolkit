# SEO / AEO Content

Search-optimized and AI-extraction-ready content: fundamentals, planning, writing, metadata, snippets, freshness, and E-E-A-T.

## Table of Contents
1. Fundamentals: how engines evaluate quality
2. Content planning & clusters
3. On-page SEO writing
4. Words & structure (headers, density, entities)
5. Meta titles, descriptions, URLs
6. Featured snippets (position zero) & AEO
7. Content refresh & cannibalization
8. Auditing (score-driven) and E-E-A-T

## 1. Fundamentals: How Engines Evaluate Quality

- **E-E-A-T** is a quality-evaluation framework, not a direct ranking factor: Experience (first-hand), Expertise (competence), Authoritativeness (recognition), Trustworthiness (reliability). Competing pages are often separated by *trust and experience*, not keywords.
- **Core Web Vitals** measure page experience, not deservingness: LCP < 2.5s, INP < 200ms, CLS < 0.1. They matter when content quality is comparable.
- **Technical SEO** enables ranking (crawlability, indexation, canonicals, HTTPS, clean URLs, mobile); **content quality earns it.**
- **Structured data (schema)** helps engines understand meaning (Article, FAQPage, Person, Product, BreadcrumbList) and enables, but never guarantees, rich results.
- **AI-assisted content:** engines evaluate output quality, not authorship. Publish only human-reviewed, accurate, original synthesis. Unedited AI output and keyword-stuffed text is risky use.

Relative importance when pages are similar: content relevance/quality > authority & trust > page experience > mobile > technical accessibility.

## 2. Content Planning & Clusters

**Topical authority map (pillar + clusters):**
1. Define the pillar page (broad core topic).
2. Generate cluster articles on sub-topics (one primary keyword + intent each).
3. Build an internal link map — clusters link up to the pillar; pillar links down to clusters; siblings cross-link where relevant.
4. Run a content gap analysis against competitors.

**Keyword research tiers:** extract seed keywords → expand into difficulty tiers (head/mid/long-tail) → add AEO question keywords (how/what/why forms) → run a cannibalization check → build a content map (keyword → page).

**Planning principles:** prioritize topics by search volume × business value; map each keyword to intent (informational/commercial/transactional); schedule a calendar with pillar refresh dates; cover the full question-space, not just the exact match.

## 3. On-Page SEO Writing

- **Introduction (50-100 words):** hook immediately, state the value proposition, include the primary keyword naturally, set expectations.
- **Body:** comprehensive coverage, logical flow, supporting data, semantic variations, clear H2/H3 hierarchy.
- **Conclusion:** summarize, CTA, reinforce delivered value.
- **Quality standards:** original, valuable, 0.5-1.5% keyword density, grade 8-10 reading level, 2-3 sentence paragraphs, bullets for scannability, data-backed claims.
- **E-E-A-T elements to include:** first-hand experience mentions, specific cases, cited statistics, expert perspective, practical advice.
- **Deliverables of a content package:** full article, 3-5 title variations, meta description, key takeaways, internal linking suggestions, optional FAQ.

## 4. Words & Structure

- **Keyword density:** ~0.5-1.5%; prevent over-optimization with semantic variations and LSI-related terms. Density is a diagnostic, not a target.
- **Entity analysis:** identify related entities and synonyms the page must cover to satisfy topical relevance.
- **Header hierarchy:** one H1 matching the title; H2s carry secondary keywords and are scannable; H3s for sub-concepts; no duplicate H2s.
- **Siloing:** group topically related pages under a parent section with a clear internal-link structure.
- **URL slugs:** lowercase, hyphens, < 60 chars, primary keyword early, drop stop words.

## 5. Meta Titles, Descriptions, URLs

- **Title tag:** 50-60 chars; primary keyword in the first 30; add power words, numbers, or year for freshness; decide brand position (beginning vs end).
- **Meta description:** 150-160 chars; primary + secondary keywords; action verbs and benefits; a compelling CTA.
- **URL:** under 60 chars; keyword early; hyphens/lowercase only.
- Create 3-5 variants per element; optimize for both mobile truncation and desktop; validate character counts.
- For CMS: Yoast/RankMath fields (WordPress) or component props (Astro/Next.js).

## 6. Featured Snippets (Position Zero) & AEO

**Snippet formats:**
- **Paragraph:** 40-60 words; direct answer in the opening sentence; question-based header.
- **List:** numbered steps (5-8 items) or bullets for features, under a clear header.
- **Table:** comparison data and specifications, clean formatting.

**Strategy:** answer questions near the content's beginning; use exact SERP questions as headers; give immediate, self-contained answers; provide supporting detail bullets; suggest FAQPage/HowTo schema; add jump links for long content.

**AEO (AI extraction) rules:** TL;DR block right after H1 that answers one specific question; a standalone definition sentence opening the "What Is" section; exactly 5 FAQ entries, each answer < 50 words and self-contained; comparison tables where a choice is involved.

## 7. Content Refresh & Cannibalization

**Refresh priorities (matrix):** refresh first where traffic is high but performance is slipping, or where the topic has changed. Look for: outdated statistics/dates/examples, obsolete product features, superseded versions, and weak structure. Add new data, update titles to current year when relevant, and re-verify links.

**Cannibalization:** detect keyword overlap between your own pages. Address by differentiating angles, merging thin pages, or redirecting. Prevention: one primary keyword (plus clearly distinct variants) per page; document intent per URL.

## 8. Auditing & E-E-A-T

**Content quality scoring:** score content on E-E-A-T signals, word-count vs competitors, readability, keyword optimization, structure, multimedia, internal/external linking, AI-citation readiness, and freshness. Output: score /100, issues, severity-ranked fixes, projected score after fixes.

**E-E-A-T authority building:** strengthen author bylines (credentials, real name), cite primary sources, show first-hand experience, maintain transparency (about page, contact, privacy), and earn external citations/links over time.

**SEO health audit (technical):** crawlability (sitemap, robots, redirects, status codes), indexation (canonicals, noindex leakage), performance (CWV), mobile-friendliness, security (HTTPS), then on-page (titles, descriptions, headings, images, internal links). Report as a 0-100 index with severity/confidence-weighted category scores.

**Incident response (traffic drop):** triage first (confirmed ranking drop? technical outage? core update?), reconstruct the timeline, segment by page/query/device/geo, check technical integrity, reassess content quality, build a prioritized evidence-based action plan with an executive summary.