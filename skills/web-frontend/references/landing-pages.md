# Landing pages & marketing sites

Merged from `front-end/landing-page-generator` (incl. `references/conversion-patterns.md`,
`references/landing-page-patterns.md`, `references/seo-checklist.md`), `front-end/interactive-portfolio`,
and the SEO notes from `web-development/frontend-seo` (see `seo-metadata.md`).

## Process

1. Extract the brief: product, audience, one promise, one call to action (CTA).
2. Map the page to a conversion structure (below).
3. Build with the project stack; default to static/SSG where possible (fast, SEO-safe).
4. Write real copy (not lorem); short sentences, concrete benefits.
5. Audit: above-the-fold clarity (5-second test), LCP/CLS, a11y, responsive, metadata.

## Conversion copy frameworks

- **AIDA**: Attention → Interest → Desire → Action.
- **PAS**: Problem → Agitate → Solve.
- **BAB**: Before → After → Bridge (state the current pain, the desired outcome, how you get there).

Landing page sections that convert (in order): hero → social proof → problem → solution →
how it works → features → testimonials → pricing/CTA → FAQ → final CTA → footer.

## Landing page patterns (masonry → storyboard)

Strong page layouts by goal:

| Goal | Pattern |
|---|---|
| Show everything fast | **Hero mesh / brick wall** (tiles of value) |
| Guide a decision | **Storyboard** (narrative: problem → proof → CTA) |
| Feature a single product | **Big single visual** + 3 value props |
| Many use cases | **Use-case tabs** (one page, many audiences) |
| Launch/timeline | **Timeline / countdown** + email capture |

Pricing: always frame with a highlighted plan; comparisons in tables; FAQ section
(a11y-friendly `<details>` or accordion) handles objections.

## Hero section (the 5-second test)

- One headline (benefit, not feature), one subhead (how/why), one primary CTA + one
  secondary link (no more).
- The hero must answer: what is it, who is it for, what do I do now.
- Use an explicit hero image/visual (screenshot/mockup) — abstract gradients read as
  filler. Preload the hero image (LCP).
- Social proof immediately under the hero (logos, metrics, avatars).

## Trust, proof, and conversion details

- Testimonials: real names + roles + photos; specific outcomes ("we cut load time 40%").
- Metrics with sources; avoid unverifiable claims.
- CTA labels are verbs with outcome ("Start free trial", "Book a demo"), not "Submit".
- Every CTA visible without scrolling on mobile; sticky mobile CTA for long pages.
- Forms: minimal fields (ask name+email first); inline validation; clear privacy line.

## Portfolio / interactive sites

- Lead with the best 3 works; case studies follow a template (challenge → approach →
  outcome with metrics); one consistent visual system; smooth scroll navigation.
- Typography-forward design works for portfolios (see `design-system.md`).

## Landing SEO checklist (condensed)

- One `title` (≤60 chars, keyword-front) + meta description per page; unique per page.
- Single `h1` with the primary keyword; hierarchical headings.
- Canonical URL; Open Graph + Twitter cards (`og:image` 1200×630).
- Semantic HTML (`<main>`, `<nav>`, `<header>`, `<footer>`); descriptive link text.
- Structured data: `Product`/`Organization`/`FAQ`/`BreadcrumbList` JSON-LD.
- Sitemap.xml + robots.txt; every page reachable in ≤3 clicks.
- Mobile-first; LCP ≤ 2.5s or SEO is moot (full list in `seo-metadata.md`).

## Common pitfalls

| Pitfall | Fix |
|---|---|
| Hero with no value proposition | Benefit headline + subhead + 1 CTA |
| Generic stock hero gradient | Product screenshot/mockup |
| "Learn more" everywhere | Outcome verbs on CTAs |
| Lorem ipsum shipped | Real copy before "final" review |
| No social proof above fold | Logos/metrics right under hero |
| FAQ as plain text | Accordion + FAQ JSON-LD |
