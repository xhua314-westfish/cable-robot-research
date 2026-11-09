# B5.1 — Candidate Region Expansion and Geometry-Constrained Pairing

**Research date:** 2026-11-10 (research session label)  
**Research phase:** Phase B — Balloon-Specific Cable Sensing Design  
**Stage:** B5.1, Lessons 2.1–2.3.3  
**Status:** MATLAB outputs reviewed; reference-pose checks completed; Core/Benchmark multi-pose checks pending  
**Primary tool:** MATLAB  
**Research goal:** Develop reproducible, diverse six-cable candidates for passive rigid-balloon 6-DOF sensing. This is a measurement system, not an active trajectory controller.

## 1. Research questions and motivation

1. Does the original 26-point anchor set limit configuration exploration?
2. Does the original 40-point latitude/longitude attachment set miss useful sphere-surface locations?
3. How can six-anchor layouts be generated in distinct, interpretable families?
4. For fixed anchor and attachment sets, can pairing improve sensing while passing reference-pose geometric checks?

**Context:** Experiment B had good reference-pose sensing (`σ_min = 0.533600`, `κ = 3.2365`) but cable 5–6 interference on sampled poses. A modified B′ pairing eliminated detected zero-thickness interference on the original 189-pose benchmark at the expense of poor sensing. Therefore geometric validity and sensitivity must be considered jointly.

## 2. Fixed model and conventions

| Item | Definition |
|---|---|
| Engineering boundary | X length 280 mm, Y width 300 mm, Z height 320 mm; centred at origin |
| Anchor region | Six faces of `[-140,140] × [-150,150] × [-160,160]` mm box |
| Balloon | Rigid sphere, nominal 550 mL; `r_b = 50.8266 mm` |
| Attachment coordinates | Body-frame points on sphere |
| Cable number | Six |
| Reference pose | `P = [0,0,0] mm`, `R = I` |
| Geometry | Straight, zero-thickness cable segments, no wrapping |
| Local pose model | Three translations (mm), three world-frame rotation increments (rad) |
| Jacobian scaling | `H_s = H diag(1,1,1,1/r_b,1/r_b,1/r_b)` |

For cable `i`:

\[
B_i=P+Rr_i,\qquad D_i=A_i-B_i,\qquad L_i=\|D_i\|,\qquad u_i=D_i/L_i.
\]

With `s_i = Rr_i`, the cable-length Jacobian row is

\[
H_i=\begin{bmatrix}-u_i^T&(u_i\times s_i)^T\end{bmatrix}.
\]

The core workspace fixed in the previous session has 27 balloon-centre positions with `x,y,z ∈ {-20,0,20} mm` and seven orientations (identity, single-axis ±5°), totalling **189 sampled poses**. The original benchmark also has 189 sampled poses but uses ±50 mm and single-axis ±10°. Neither establishes a continuous workspace.

## 3. Lesson 2.1 — Anchor Candidate Expansion

### Method

Reconstruct the original 3×3 face grid and build a denser 5×5 face grid by retaining only 3D grid points located on at least one boundary face. For `n` evenly spaced coordinates on each axis, the number of unique box-surface points is

\[
N_{\mathrm{surface}}=n^3-(n-2)^3.
\]

### MATLAB results

| Check | Actual result |
|---|---:|
| Original surface candidates | 26 (`3³−1³`) |
| Expanded surface candidates | 98 (`5³−3³`) |
| Duplicate points | None (assertion passed) |
| All expanded points on faces | Passed |
| Original 26 reconstructed points included in expanded 98 | Passed |
| Dataset saved | `B5_1_anchor_candidates.mat` |

The figures showed the same engineering boundary with denser sampling on each surface. **Interpretation:** The expanded set offers more allowable positions. More random trials over the original 26-point set cannot sample locations outside that set; however the new 98-point set has **not** yet been shown to improve sensing or feasibility.

## 4. Lesson 2.2 — Attachment Candidate Expansion

### Method

Load the original B1 40-point set (`8` azimuth values × `5` elevation values). Generate `N=100` Fibonacci sphere points:

\[
z_i=1-2\frac{i+0.5}{N},\quad \phi_i=i\pi(3-\sqrt 5),\quad \rho_i=\sqrt{1-z_i^2},
\]
\[
r_i=r_b\,[\rho_i\cos\phi_i,\,\rho_i\sin\phi_i,\,z_i]^T,\qquad i=0,\ldots,N-1.
\]

### MATLAB results

| Check | Actual result |
|---|---:|
| Original attachment candidates | 40 |
| Fibonacci candidates | 100 |
| Maximum sphere radius error | `1.421 × 10⁻¹⁴ mm` |
| Duplicate points | None (assertion passed) |
| Minimum chord distance among original 40 | `19.4505 mm` |
| Minimum chord distance among Fibonacci 100 | `15.7073 mm` |
| Dataset saved | `B5_1_attachment_candidates.mat` |

**Interpretation:** Fibonacci sampling provides a denser, approximately even sphere-surface candidate distribution. The smaller minimum distance is unsurprising for more candidates on the same sphere and does **not** make the final six-point layout worse. The 100-point set is **not** automatically a superset of the old 40 points. Both are preserved for controlled comparison. Candidate-set spacing is distinct from the spacing of six selected physical attachment points.

## 5. Lesson 2.3.1 — Anchor Configuration Families

The expanded anchor set was restricted to face-interior points for an unambiguous family assignment. This produced **54** eligible points, nine on each of six faces. Three *representative* six-anchor sets were sampled with `rng(42)`; each is only one instance of its family.

| Family | Face allocation | Min anchor distance (mm) |
|---|---|---:|
| F1 — Six-Face Distributed | `+X, -X, +Y, -Y, +Z, -Z` | `102.5914` |
| F2 — Opposite/Layered | `+Z×2, -Z×2, +X, -X` | `130.0961` |
| F3 — Asymmetric | `+Z×3, +Y×2, -X` | `70.0000` |

**Actual selected anchors (mm):**

| Family | Cable | Anchor `(x,y,z)` |
|---|---:|---|
| F1 | 1 | `(140,-75,0)` |
| F1 | 2 | `(-140,75,80)` |
| F1 | 3 | `(-70,150,80)` |
| F1 | 4 | `(70,-150,0)` |
| F1 | 5 | `(0,-75,160)` |
| F1 | 6 | `(0,-75,-160)` |
| F2 | 1 | `(-70,-75,160)` |
| F2 | 2 | `(0,75,160)` |
| F2 | 3 | `(70,0,-160)` |
| F2 | 4 | `(-70,75,-160)` |
| F2 | 5 | `(140,-75,-80)` |
| F2 | 6 | `(-140,75,80)` |
| F3 | 1 | `(0,75,160)` |
| F3 | 2 | `(0,-75,160)` |
| F3 | 3 | `(70,-75,160)` |
| F3 | 4 | `(0,150,-80)` |
| F3 | 5 | `(-70,150,0)` |
| F3 | 6 | `(-140,0,0)` |

**Interpretation:** F2 has the largest minimum anchor spacing among these three specific instances. This does **not** establish superior sensing or multi-pose geometry. Dataset saved as `B5_1_configuration_families.mat`.

## 6. Lesson 2.3.2 — Initial Attachment Selection

### Method

For each fixed six-anchor layout, select six distinct points from the Fibonacci-100 set using a greedy pairing heuristic. Provisional filters:

- Selected attachment pair separation at least **20 mm** (experimental generation parameter, not hardware requirement).
- Reference-pose outward cosine `0.2 ≤ u_i · (r_i/r_b) ≤ 0.9`, with target near `0.6` for ranking (heuristic values, not proven optimal).
- Maintain six distinct attachment points.

### Actual reference-pose sensing results (before pairing optimisation)

| Metric | F1 | F2 | F3 |
|---|---:|---:|---:|
| Jacobian rank | 6 | 6 | 6 |
| Scaled minimum singular value | `0.039051` | `0.165045` | `0.375288` |
| Scaled condition number | `60.825515` | `12.761140` | `5.416895` |

The initial configurations were stored in `B5_1_initial_6cable_configurations.mat`. The F3 sample had the best reference-pose sensitivity of these three, but no multi-pose performance was established.

## 7. Lesson 2.3.3 — Geometry-Constrained Sensing-Informed Pairing

### Research question

With the six anchor coordinates and the six physical attachment sites fixed for each family, does changing only their one-to-one pairing improve reference-pose sensitivity **while passing the same ideal-geometry checks**?

### Method and decision rule

Enumerate `6! = 720` permutations per family. At `P=0`, `R=I`, each candidate is checked in sequence:

1. **Sphere:** For every cable, require `s_i · D_i ≥ -10⁻⁹ mm²`, where `s_i = Rr_i`. For straight ideal segments attached to a rigid sphere, this excludes inward routing at the sphere surface.
2. **Cable–cable:** For all `15` pairs, compute minimum finite-segment distance using the **existing** `B3_1_segment_distance_3d_2026_11_02.m`. Reject distances `≤10⁻⁶ mm` (numerical zero-thickness contact threshold, **not physical clearance**).
3. **Sensing:** Require `rank(H_s)=6`; among survivors, select maximum reference-pose `σ_min(H_s)` and report `κ(H_s)`.

The selected configurations are *reference-pose screened candidates*, **not multi-pose verified solutions**.

### Actual MATLAB outputs

| Metric | F1 Six-Face | F2 Layered | F3 Asymmetric |
|---|---:|---:|---:|
| Total pairings | 720 | 720 | 720 |
| Sphere-passing | 8 | 2 | 14 |
| Full-geometry-passing | 8 | 2 | 14 |
| Full-rank geometry-passing | 8 | 2 | 14 |
| Original pairing geometric pass | Yes | Yes | Yes |
| Original `σ_min` | `0.039051` | `0.165045` | `0.375288` |
| Original `κ` | `60.825515` | `12.761140` | `5.416895` |
| Best feasible pairing (1-based attachment indices) | `[4 3 2 6 5 1]` | `[1 2 3 4 5 6]` | `[1 2 3 4 5 6]` |
| Best feasible `σ_min` | `0.153511` | `0.165045` | `0.375288` |
| Best feasible `κ` | `15.130220` | `12.761140` | `5.416895` |
| Minimum cable–cable distance of best pairing | `8.004738 mm` | `47.987403 mm` | `23.299113 mm` |

Additional checks: nested pass-count assertions passed; result dataset saved as `B5_1_geometry_constrained_pairing.mat`.

### Scientific interpretation

- **F1:** Re-pairing increased the reference-pose minimum scaled singular value from `0.039051` to `0.153511` (about **3.93×**) and reduced condition number from `60.83` to `15.13`. This demonstrates that the original pairing—not merely the six-face anchor positions—contributed to its poor initial sensitivity.
- **F2:** Only two of 720 permutations passed the sphere and line-segment tests. Its original pairing `[1 2 3 4 5 6]` already maximised `σ_min` among those survivors.
- **F3:** Fourteen permutations passed; the original pairing likewise maximised `σ_min` among them. It has the highest reference-pose `σ_min` among these **three fixed-layout examples**.
- **All families:** `SpherePass = GeometryPass` in these outputs, meaning the additional cable–cable contact test rejected none of the permutations that passed the sphere test **at this one reference pose and numerical threshold**. This does not demonstrate future collision-free motion or finite cable clearance.
- The `8 / 2 / 14` survivors are the numbers of valid permutations for fixed point sets, **not** feasible workspace coverage rates.

### Student reflection

**Q1:** Why geometry before sensing? — A pairing with a good Jacobian but cable penetration/interference cannot be considered usable; geometry is a feasibility filter, sensing is an objective among survivors.

**Q2:** Does F1 having more valid pairings than F2 prove better workspace coverage? — No. Reference-pose pairing counts do not describe feasibility as the balloon translates and rotates; the same fixed pose set must be tested.

## 8. Key findings and limitations

1. Candidate expansion was implemented and numerically checked: anchors `26 → 98`, attachments `40 → Fibonacci 100`.
2. Three interpretable anchor distribution families were established but only **one** six-anchor instance of each has been tested.
3. Attachment selection was greedy with provisional angular/spacing heuristics; better attachment subsets may exist.
4. Constrained reference-pose pairing can improve `σ_min` substantially (F1), but F2/F3 did not benefit with their fixed point sets.
5. No claim of global optimum, true physical clearance, continuous workspace, actual pose accuracy, tension feasibility, or flexible-balloon compatibility is supported.
6. Anchor/attachment separation and cable-direction similarity remain **auxiliary or mechanical** criteria. Sensing evaluation must use the complete scaled Jacobian and multi-pose checks.
7. The three candidate configurations may need further adjustment or re-selection after the next geometry screening.

## 9. Next research decision — B5.2 Multi-Pose Geometric Screening

**Question:** Which fixed candidate configurations remain free of detected cable–sphere penetration and cable–cable contact across a predeclared **189-pose Core Workspace**, not just `P=0, R=I`?

**Evaluation plan:**

1. Load saved `best_configs` from B5.1 and use a single consistent Core pose set (27 translations × 7 rotations, with correct degree-to-radian conversion and a declared rotation convention).
2. Reuse B3.2 sphere-outward and finite-segment clearance checks at every Core pose.
3. Record separate pose-wise sphere failures, cable–cable contacts, combined pass masks, worst clearance and failing cable pairs.
4. Preserve unsuccessful family results; do not silently exclude hard poses.
5. Compare against original B and Modified B′ using identical pose definitions when their datasets are available.
6. In subsequent B5.3, compare scaled Jacobian sensitivity across **the same poses**, not only each candidate’s favourable feasible subset.

**Provisional acceptance for initial prototype:** all *required* Core samples should satisfy the stated ideal geometric constraints, followed by finite-thickness/hardware clearance and sensing tests. Until mechanical dimensions are defined, numerical contact-free results are **not** an engineering sign-off.

## 10. Reproducibility and files

**Input/derived MATLAB files:**

- `B1_geometry_baseline.mat` (original reference geometry)
- `B5_1_anchor_candidates.mat` (A26, A98)
- `B5_1_attachment_candidates.mat` (r40, r100)
- `B5_1_configuration_families.mat` (A_families)
- `B5_1_initial_6cable_configurations.mat` (C_families)
- `B3_1_segment_distance_3d_2026_11_02.m` (existing finite-segment distance function)
- `B5_1_geometry_constrained_pairing.mat` (best_configs, screening results)

**Random seed:** `rng(42)` for representative family sampling and initial attachment selection (Fibonacci point generation itself is deterministic). The exact script versions and output figures should be committed with the research record once locally verified.

**Relevant project references:**

- B1 geometric candidate definition, B3.2 multi-pose interference checks, B4.1 measurement Jacobian and sensing quality.
- Cheng & Lau (2023), *Cable Attachment Optimization for Reconfigurable Cable-Driven Parallel Robots Based on Various Workspace Conditions*, DOI: `10.1109/TRO.2023.3288838` — workspace/placement methodology; not a direct passive-sensing optimum.
- Youssef & Otis (2020), *Reconfigurable Fully Constrained Cable Driven Parallel Mechanism for Avoiding Interference Between Cables*, DOI: `10.1016/j.mechmachtheory.2020.103781` — interference-aware geometry; physical reconfiguration differs from this fixed-anchor measurement rig.

## 11. Session handoff

**Current workstream:** A — Six-Cable Prototype and Experiments  
**Completed task:** B5.1 Lessons 2.1–2.3.3 — candidate expansion, family generation, initial attachment selection, geometry-constrained pairing  
**Verified results:** Candidate counts and radius checks; family coordinates and anchor spacing; per-family reference-pose Jacobian metrics; 720-permutation geometric/sensing screening counts  
**Unresolved issues:** Core/Benchmark pose geometry and clearance, alternative attachment selections, multi-pose sensitivity, real connector dimensions, tension and flexible-body effects  
**Next action:** B5.2 Lesson 1 — evaluate the three saved best pairings over the Core 189 poses with the existing B3 interference methods.
