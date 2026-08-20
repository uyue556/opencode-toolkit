# Scientific Computing in Python

Route to the right library, then use the guidance below. All ten skills are
condensed here; for deeper library-specific detail consult the upstream
package docs. These skills set *how to drive the library*, not just that it
exists.

## Routing Table

| Task | Library | Domain |
|---|---|---|
| Any plotting — static/animated/interactive, fine control | matplotlib | foundation |
| Publication-quality statistical graphics from tabular data | seaborn | stats viz |
| Regression, GLM, time series, inference, diagnostics | statsmodels | statistics |
| Symbolic algebra, calculus, exact math | sympy | mathematics |
| Graphs / networks (social, citation, biology, transport) | networkx | graphs |
| Astronomy data (units, coordinates, FITS, cosmology, time) | astropy | astronomy |
| Bioinformatics (sequences, alignments, Entrez, PDB, phylo) | biopython | biology |
| Single-cell RNA-seq end-to-end analysis | scanpy | bioinformatics |
| Quantum circuits & simulators (IBM ecosystem) | qiskit | quantum |
| Quantum circuits & simulators (Google ecosystem) | cirq | quantum |

## Plotting & Visualization

### matplotlib (foundation)

- Prefer the **object-oriented API** (`fig, ax = plt.subplots()`) over bare
  `pyplot` calls for reusable, publication-quality figures.
- **Hierarchy**: Figure → Axes → (spines, ticks, labels); artists live on axes.
- Subplots: regular grid (`subplots(2,2)`), flexible `mosaic`, or full-control
  `GridSpec`.
- Save: high-res PNG for slides/papers (`dpi=300`), **vector PDF/SVG for
  publications**, `transparent=True` when needed.
- 3D via `mpl_toolkits.mplot3d` (surface, scatter, line). Styles: `'ggplot'`,
  `'bmh'`, `'fivethirtyeight'`, etc.

### seaborn (statistical, dataset-oriented)

- Two interfaces: **function** (`sns.scatterplot`) and **objects**
  (declarative `p.So()` chains) for more control.
- Plot families: **relational** (scatter/line, faceted), **distribution**
  (hist/KDE, bivariate KDE, joint + marginals, pairplot), **categorical**
  (swarm/violin/bar, split violins, error bars), **regression** (simple and
  polynomial, residual checks).
- Automatic statistical estimation (CIs), semantic mapping to color/size/style,
  and minimal-code multi-panel figures are its reason to exist.

## Statistics (statsmodels)

- **Regression**: ALWAYS add a constant for the intercept
  (`X = sm.add_constant(X)`); fit OLS, then inspect summary, predictions with
  CIs, diagnostics, and residual plots.
- **Logistic**: `sm.Logit(y, X)` → odds ratios, predicted probabilities
  (threshold 0.5), evaluation, marginal effects.
- **Time series (ARIMA)**: check stationarity first; plot **ACF/PACF to choose
  p,q**; fit `ARIMA(p,d,q)`; forecast; residual diagnostics.
- **GLM**: Poisson for counts (log link) → rate ratios; check
  **overdispersion** after fitting.
- Use for estimation, inference, and diagnostics across simple to complex
  econometric models.

## Symbolic Math (sympy)

- **Always define symbols first**: `x, y = sp.symbols('x y')`. Use assumptions
  (`positive=True`, etc.) for better simplification.
- Use **exact arithmetic** (never floating-point constants in symbolic
  expressions). Convert to numbers with `sp.N()` / `.evalf()` when needed.
- **lambdify** converts to fast NumPy callables for many evaluations.
- Capabilities: calculus, equation solving, matrices/linear algebra,
  physics/mechanics (Lagrangian), code generation.

## Graphs (networkx)

- Create graphs, add any-hashable nodes/edges; directed, undirected,
  multi-edge.
- Algorithms: shortest paths, degree/betweenness centrality, PageRank, community
  detection, connectivity / connected components.
- Generators: complete/cycle, Erdős–Rényi, Barabási–Albert scale-free,
  Watts–Strogatz small-world, grid, random tree.
- Read/write: edge lists, GraphML (preserves attributes), GML, JSON.

## Astronomy (astropy)

- **Units/quantities**: use `u.Quantity` — never raw numbers; convert with
  `.to()`.
- **Coordinates**: transform between frames (ICRS → Galactic → AltAz) via
  `astropy.coordinates`.
- **Time**: `astropy.time` for precise time handling (astronomical scales).
- **FITS**: `astropy.io.fits` for reading/writing FITS headers and data.
- **Tables**: `astropy.table` for tabular data manipulation.
- **Cosmology**: `astropy.cosmology` for distance/age calculations; **WCS** for
  world-coordinate systems on images.

## Bioinformatics (biopython)

- **Sequences**: `Bio.SeqIO` to read/write FASTA/GenBank (e.g. convert
  GenBank→FASTA).
- **Alignments**: `Bio.Align` / `Bio.AlignIO` (pairwise, multiple).
- **Database access**: `Bio.Entrez` (NCBI) — an API key lifts the rate limit
  from 3 to 10 req/s; search PubMed, fetch records.
- **BLAST**: `Bio.Blast` for running and parsing BLAST searches.
- **Structure**: `Bio.PDB` to parse structures and compute distances (e.g.
  between alpha carbons).
- **Phylogenetics**: `Bio.Phylo` to read, visualize, and analyze trees.

## Single-Cell RNA-seq (scanpy)

- Data lives in **AnnData**: `obs` (cells), `var` (genes), `layers`
  (counts/processed), `obsm` (reduced dims).
- **Standard workflow**: QC (identify mitochondrial genes, compute + plot QC
  metrics, filter cells/genes) → normalize to 10k counts per cell → `log1p` →
  save raw counts → identify highly variable genes → regress out unwanted
  variation → scale → PCA → neighborhood graph → UMAP → clustering (Leiden) →
  marker genes → trajectory analysis → visualization.

## Quantum Computing

### Qiskit (IBM ecosystem)

- Build circuits (e.g. Bell state), visualize, run locally on the simulator.
- Use **primitives** `Sampler`/`Estimator` for execution; **transpile** for
  hardware; Qiskit Patterns workflow (map → optimize → execute → post-process).
- Providers: IBM Quantum (100+ qubits), IonQ, Amazon Braket, others.

### Cirq (Google ecosystem)

- Qubits, circuit building, `cirq.Simulator` for results.
- **Parameterized circuits** with symbolic parameters + sweeps over values.
- Hardware via Google Quantum Engine, IonQ, AQT, Pasqal, Azure Quantum; support
  noise modeling and quantum experiments.

## Cross-Cutting Advice

- Match the library to the deliverable: statsmodels for *inference and
  diagnostics*, seaborn/matplotlib for *presentation*, sympy for *exact*
  results, networkx for *relationships*.
- For anything in these libraries, consult the official docs for version
  specifics; this reference gives orientation, not an API reference.
