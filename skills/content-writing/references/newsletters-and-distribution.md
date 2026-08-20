# Newsletters, Distribution & Recurring Content

Email/newsletter content, internal status comms, daily digests, and cross-platform distribution mechanics.

## Table of Contents
1. Newsletters & recurring digests
2. Internal status communications (3P updates)
3. Cross-platform distribution checklist
4. Measuring distribution

## 1. Newsletters & Recurring Digests

Recurring content (newsletters, daily reports) works when it is **curated, scannable, and quality-gated**:

- **Quality over quantity.** Low-quality items don't enter the digest; when enough good material is gathered, stop collecting rather than padding.
- **Curate with a point of view.** A newsletter is a selection judgment, not a dump of everything. Include a one-line "why this matters" per item.
- **Give every item a sharp title** and 1-2 sentence summary; link to the source. Keep formatting consistent across editions.
- **Fault tolerance:** if one source fails, the rest of the pipeline continues; degrade gracefully (fall back to serial collection) and note degraded mode in the output rather than silently dropping quality.
- **Cache/reuse:** avoid re-collecting the same sources each run; reuse seen items.
- **Timestamps matter:** date-stamp every edition; mark data accuracy ("accurate as of [Month Year]").

**Template:** header with date → item groups (each: Title → summary → source) → footer with generation note and sources used.

## 2. Internal Status Communications

For team/company updates, match the format and tone to the type:

- **3P updates (Progress, Plans, Problems):** lead with progress, state plans crisply, and surface problems up front with what you need. Short, honest, specific.
- **Status / project updates:** what shipped, what's blocked (and why), what's next, with dates. Link artifacts (docs, PRs, dashboards).
- **Company newsletter:** headline the theme, keep a consistent rhythm, celebrate outcomes with numbers, and include the FAQ-worthy questions.
- **Incident reports:** timeline → impact → root cause → fix → prevention.
- **FAQ answers:** answer directly first (one paragraph), then add context; keep it reusable.

Load the matching guideline for the communication type; if it doesn't fit a known category, ask what format is expected.

## 3. Cross-Platform Distribution Checklist

Before publishing one piece across platforms:
1. **Write once, adapt per platform** — shorten for social, expand for your blog, restructure for email.
2. **Canonical URL discipline** — publish original on your own domain first, wait 1-2 days for indexing, then cross-post to platforms with the `canonical_url` pointing to your original.
3. **Platform-specific metadata** — per-platform titles, descriptions (155 chars), cover images, tags (max 4 on Dev.to; use dedicated-feed tags on Hashnode), series grouping.
4. **CTA placement** — always end with a concrete next step; vary by platform (read more / subscribe / try it).
5. **Engage after publishing** — reply to every comment within 24h; the algorithm and the community both reward it.

## 4. Measuring Distribution

**Track the funnel:** search/social → post → docs/quickstart → signup → activation. Metrics per stage: views, read ratio / time-on-page, click-through, bounces, conversions.

**Resonance metrics:** shares/backlinks (HN, Reddit, Twitter) > raw views. Followers-from-post measures conversion quality. Newsletter signups measure list growth.

**Iterate:** low views → title/tags; low comments → end with a question; high bounce → structure/hook; low followers → stronger CTA and series.

**Distribution cadence:** 4+ posts/month = rapid growth; 2-3 = steady; 1 = sustainable; sporadic = minimal retention. Pick a cadence you can sustain and keep the rhythm.