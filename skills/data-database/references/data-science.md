# Data Science & Analysis

Synthesized from: `data-scientist`, `polars`, `plotly`, `data-storytelling`,
`data-quality-frameworks`, `data-engineering-data-driven-feature`, `data-structure-protocol` (graph
navigation overlap), `data-engineering-data-pipeline` (quality overlap).

## ToC

1. [Data scientist workflow](#data-scientist-workflow)
2. [Polars for in-memory data](#polars-for-in-memory-data)
3. [Visualization with plotly](#visualization-with-plotly)
4. [Data-driven feature development](#data-driven-feature-development)
5. [Data storytelling](#data-storytelling)

## Data scientist workflow

1. Understand business context; define measurable analytical objectives.
2. Explore thoroughly (statistical summaries + plots); profile missing values, outliers, distributions.
3. Pick methods from data characteristics + business goal (stats / ML / causal).
4. Validate rigorously: hypothesis tests, cross-validation, effect sizes, power analysis.
5. Communicate clearly: visuals + actionable recommendations; document methodology for reproducibility.

Toolkit: Python (pandas, NumPy, scikit-learn, SciPy, statsmodels), R (dplyr, ggplot2, tidymodels),
SQL (window functions, CTEs), polars/PySpark/Dask for scale. Experiments: A/B + multivariate design,
stratified randomization, power analysis, multiple-testing control, sequential testing/early stopping,
difference-in-differences / synthetic control for causal claims. Model work: interpretability (SHAP/LIME),
drift monitoring, MLflow/DVC for versioning, containerized serving.

## Polars for in-memory data

Use when pandas is too slow but data still fits in RAM (roughly 1–100GB). Expression-based, Apache
Arrow-backed, parallel by default, lazy evaluation.

- Core: `pl.col("x")`, `df.select(...)`, `df.filter(...)`, `df.with_columns(...)`,
  `df.group_by("city").agg(pl.len(), pl.col("age").mean())`.
- **Lazy**: `pl.scan_csv/scan_parquet(...)` builds a query plan → `.filter().select().collect()`;
  benefits: predicate/projection pushdown, auto parallelization, streaming (`collect(streaming=True)`).
- Window: `.mean().over("city")` keeps row count; mapping strategies `group_to_rows`/`explode`/`join`.
- I/O: CSV/Parquet/JSON/Excel, cloud storage, partitioned files. Parquet is the performance format.
- Migration from pandas: no index (integer positions), strict typing, `with_columns` for parallel
  computes. Prefer native expressions over `map_elements` (Python) in hot paths; select only needed
  columns early; use Categorical for low-cardinality strings and tight int sizes.

## Visualization with plotly

- `plotly.express` (px) for fast, declarative charts; `graph_objects` (go) for full control.
- Chart types: line/scatter/bar, box/violin (distributions), heatmap/contour/3D surface, candlestick +
  rangeslider for finance, animated frames for time.
- Interactivity: custom hover templates, rangeslider, zoom/pan, web-embeddable.
- Dashboards: Dash app for multi-plot layouts; themes (`plotly_white`, `plotly_dark`, ...);
  export to static images/HTML when needed.
- Best for hover/zoom/pan or web-embedded charts; for publication-static figures, matplotlib/seaborn
  still win.

## Data-driven feature development

Build features guided by data, not assumptions (works for product + ML features):

1. **Analysis & hypothesis**: EDA → business hypothesis → statistical experiment design.
2. **Architecture**: feature architecture + analytics instrumentation plan + pipeline design.
3. **Implementation**: instrument with analytics (see `analytics.md`), integrate ML if applicable.
4. **Pre-launch validation**: analytics validation + experiment setup.
5. **Launch**: gradual rollout, real-time monitoring.
6. **Decide**: statistical analysis → business impact → post-launch optimization.

Success = clear success criteria, measurable instrumentation, and a monitoring loop that closes
launch→analyze→iterate.

## Data storytelling

Structure: Hook → Context → Rising action → Climax (key insight) → Resolution (recommendation) →
Call to action. Three pillars: **Data** (evidence), **Narrative** (meaning), **Visuals** (clarity).

- Frameworks: Problem-Solution, Trend, Comparison stories.
- Techniques: progressive reveal (add layers one slide at a time), contrast/compare (before/after),
  annotation + highlight (annotate launch spikes, threshold lines, shaded periods).
- Headlines: `[specific number] + [business impact] + [actionable context]` (e.g. "Q4 Sales Beat Target
  by 23% — Here's Why"). Lead with the "so what"; front-load the insight; use the rule of three;
  handle uncertainty honestly (confidence intervals, caveats); end with a concrete ask.
- Don'ts: data dump, burying the insight, jargon, showing methodology first, losing the narrative.

Structural memory note: for long-lived codebases/data projects, keeping a graph of modules/objects
(identity by UID, connections with a reason) makes impact analysis before schema/API changes reliable.
