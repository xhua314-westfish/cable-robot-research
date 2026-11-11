# Current Research State

**Version:** 0.7  
**Last Updated:** 2026-11-12  
**Current Phase:** Phase B — Six-Cable Configuration Design and Sensing Validation  
**Current Milestone:** B5.4 E1a-A (Config 2 rail-position optimisation and sampled robustness checks) completed  
**Next Research Priority:** B5.4 E1a-B — Fair rail-position optimisation and comparison across six Core-eligible configurations  
**Primary Tool:** MATLAB

---

## 1. Research Direction and Scope

**Long-term goal:** Develop a cable-length-based measurement system to estimate the position, orientation and, eventually, deformation/shape of a **passively moving balloon-like body** in a simplified stomach-inspired environment.

The system measures passive motion; it does **not** prescribe the balloon's trajectory. Motors may follow cable displacement to maintain small positive tension, subject to later physical validation.

### Two Parallel Research Workstreams

**Workstream A — Six-Cable Prototype and Experiments (Current Priority)**

- Six-cable configuration design.
- Geometric and sensing verification.
- Mechanical installation and mounting constraints.
- Low-tension cable sensing.
- Sensor calibration and pose estimation.
- Experimental validation.
- Rigid-to-flexible balloon extension.

**Workstream B — Seven-/Eight-Cable Theory and Simulation**

- Measurement redundancy.
- Local observability and Jacobian analysis.
- Pose-estimation uncertainty.
- Sensing workspace.
- Geometric and tension feasibility.
- Consistent six-/seven-/eight-cable performance comparison.

Additional cables are not assumed to improve sensing automatically.

**Important:** Do not declare a final six-cable prototype or globally optimal configuration yet. The latest E1a configuration is a preferred **sampled numerical candidate**, not an experimentally validated device.

---

## 2. Model, Definitions and Evaluation Sets

### 2.1 Established Engineering Model

| Item | Current Definition |
|---|---|
| Engineering frame | 280 × 300 × 320 mm |
| Coordinate system | X = Length, Y = Width, Z = Height |
| Balloon volume | 550 mL |
| Balloon model | Rigid sphere |
| Balloon radius | 50.8266 mm |
| Initial cable number | 6 |
| Measurement | Cable length |
| Motion | Passive and unknown |
| Anchor | World-frame position `A_i` |
| Attachment | Balloon-body position `r_i` |
| Current anchor installation region | Twelve edges of the rectangular frame |
| Future mounting concept | Fixed prototype mounting with provision for adjustment |

The engineering frame is a simplified boundary, **not a clinically validated continuous gastric workspace**.

The current model assumes ideal straight, zero-thickness cables. Actual pulley exit points, connector dimensions and cable diameters remain to be determined.

### 2.2 Cable Geometry and Measurement Jacobian

For cable \(i\):

\[
B_i=P+Rr_i
\]

\[
D_i=A_i-B_i
\]

\[
L_i=\|D_i\|
\]

\[
u_i=\frac{D_i}{L_i}
\]

where:

- \(P\): balloon centre position.
- \(R\): body-to-world rotation matrix.
- \(r_i\): body-frame attachment coordinate.
- \(B_i\): world-frame attachment coordinate.
- \(A_i\): world-frame anchor coordinate.
- \(D_i\): cable direction from attachment to anchor.
- \(L_i\): cable length.

The six-cable measurement Jacobian is:

\[
H_i=
\begin{bmatrix}
-u_i^T & (u_i\times Rr_i)^T
\end{bmatrix}
\]

The scaled Jacobian is:

\[
H_s=H\operatorname{diag}
\left(
1,1,1,\frac1{r_b},\frac1{r_b},\frac1{r_b}
\right)
\]

Primary local sensing indicators:

- Jacobian rank.
- Minimum scaled singular value \(\sigma_{\min}\).
- Scaled condition number \(\kappa\).
- Predicted and simulated pose-estimation error.

Full Jacobian rank does not guarantee global pose uniqueness or acceptable experimental accuracy.

### 2.3 Current Geometric Feasibility Checks

**Cable–Sphere Outward Direction**

\[
(Rr_i)^T D_i\ge -10^{-9}\ \mathrm{mm}^2
\]

This tests whether a cable leaves the spherical attachment in an outward direction.

**Cable–Cable Interference**

All 15 cable pairs are checked using the minimum distance between finite three-dimensional line segments.

Current numerical contact threshold:

\[
d_{ij}>10^{-6}\ \mathrm{mm}
\]

These are numerical geometry conditions, not verified physical clearance specifications.

**Outward Angular Margin**

\[
m_i(q)=\arcsin
\left(
\frac{(Rr_i)^TD_i}{r_bL_i}
\right)
\]

A positive margin indicates outward cable departure relative to the sphere's tangent direction.

### 2.4 Distinct Evaluation Pose Sets

These sets must not be confused.

| Evaluation Set | Translation | Orientation | Number of Poses |
|---|---|---|---:|
| Historical wider benchmark | `{-50,0,50}` mm per axis | Identity and single-axis ±10° | 189 |
| Core development set | `{-20,0,20}` mm per axis | Identity and single-axis ±5° | 189 |
| Original off-grid set | Random positions in `[-20,20]` mm | Simultaneous RPY within ±5° | 150 |
| Additional independent set | Random positions in `[-20,20]` mm | Simultaneous RPY within ±5° | 200 |
| E1a combined evaluation | Core + both off-grid sets | Mixed discrete pose samples | **539** |

The 539-pose collection represents a finite numerical test set, not a proof of continuous-workspace feasibility.

The historical wider benchmark is separate from the Core set and is not simply a superset of it.

### 2.5 Installation Perturbation Model

Current assumed perturbation:

\[
\Delta t_i=\pm0.005
\]

Each anchor is perturbed independently while the other five remain fixed.

There are:

\[
6\times2=12
\]

installation perturbation cases per configuration.

These values are assumed for numerical evaluation and have not been established from actual hardware tolerances.

---

## 3. Historical Research Progress — B1.4 to B5.2

### B1.4–B1.6 — Initial Candidate Definition

**Status:** Completed.

The first candidate-generation approach used a simplified rectangular boundary and a rigid spherical balloon.

Initial candidate sets:

- **26 anchor candidates** sampled on the rectangular boundary.
- **40 attachment candidates** sampled on the balloon surface.

The anchor candidates were generated using regular sampling on six boundary faces.

The attachment candidates were generated using spherical coordinates and verified against:

\[
\|r_i\|=r_b
\]

**Research outcome:** Established a reproducible initial geometry and candidate-generation workflow.

**Limitation:** The initial anchor candidates were mathematical search points and did not explicitly enforce installation on the twelve frame edges.

### B2.1–B2.2 — Initial Six-Cable Configuration Search

**Status:** Completed.

Three initial configurations were evaluated:

| Configuration | Anchor Selection | Attachment Selection |
|---|---|---|
| Baseline | Fixed predefined anchors | Initial attachment arrangement |
| Experiment A | Fixed anchors | Variable attachments |
| Experiment B | Variable anchors | Variable attachments |

Reference-pose results:

| Metric | Baseline | Experiment A | Experiment B |
|---|---:|---:|---:|
| Jacobian rank | 6 | 6 | 6 |
| Scaled minimum singular value | 0.004393 | 0.535345 | 0.533600 |
| Scaled condition number | 490.956 | 3.5759 | 3.2365 |

**Research outcome:** Anchor and attachment geometry strongly influence local sensing quality.

**Limitation:** Reference-pose optimisation does not establish multi-pose geometric feasibility or global optimality.

### B3 — Multi-Pose Geometric Feasibility

**Status:** Completed.

The historical 189-pose benchmark was used to evaluate cable–sphere and cable–cable interference.

| Metric | Experiment A | Experiment B |
|---|---:|---:|
| Combined geometric feasibility | 40/189 | 105/189 |
| Main limitation | Cable–sphere interference | Cable 5–6 contact |

**Research outcome:** A configuration with good reference-pose sensing quality may be geometrically infeasible over much of the tested motion region.

This motivated multi-pose screening instead of reference-pose-only selection.

### B4 — Jacobian and Sensing Quality Verification

**Status:** Initial Jacobian, conditioning and assumed-noise studies completed.

Completed work:

- Analytical and numerical Jacobian comparison.
- Jacobian rank verification.
- Singular-value and condition-number evaluation.
- Local pose-uncertainty analysis.
- Comparison of geometrically feasible pose subsets.

Experiment B generally showed better sampled sensing performance than Experiment A.

The initial uncertainty analysis used assumed independent cable-length noise with standard deviation:

\[
\sigma_L=0.1\ \mathrm{mm}
\]

These are theoretical or simulated predictions, not experimentally calibrated sensing errors.

### B5.1 — Configuration Diagnosis and Candidate Expansion

**Status:** Completed.

The original candidate sets were expanded:

| Candidate Type | Initial | Expanded |
|---|---:|---:|
| Anchor | 26 | 98 |
| Attachment | 40 | 100 |

The new attachment candidate generation used Fibonacci sphere sampling.

An important experiment was Modified B′, obtained by changing the attachment pairing of C5 and C6.

| Metric | Original B | Modified B′ |
|---|---:|---:|
| Wide-benchmark geometry | 105/189 | **189/189** |
| Reference \(\sigma_{\min}\) | 0.533600 | 0.075854 |
| Reference \(\kappa\) | 3.2365 | 23.575 |

**Research conclusion:** Changing cable pairing can improve geometry but significantly reduce sensing quality.

Geometry and sensing must therefore be evaluated together.

### B5.2 — Multi-Pose Screening of Representative Configurations

**Status:** Completed.

Five configurations were compared:

- Original B.
- Modified B′.
- F1 — Six-Face Distributed.
- F2 — Opposite/Layered.
- F3 — Asymmetric.

| Configuration | Core Geometry | Wider Benchmark Geometry |
|---|---:|---:|
| Original B | 108/189 | 105/189 |
| Modified B′ | 189/189 | 189/189 |
| F1 | 74/189 | 54/189 |
| F2 | 189/189 | 178/189 |
| F3 | 189/189 | 157/189 |

**Research conclusions:**

1. Increasing candidate density does not guarantee better configurations.
2. Pairing has a strong influence on cable routing and feasibility.
3. Reference-pose sensing optimisation is insufficient.
4. Structured spatial configurations deserve further investigation.
5. Geometric feasibility and sensing quality must be evaluated over consistent pose sets.

---

## 4. B5.3 — Literature-Informed Twelve-Rail Structured Configurations

**Status:** Initial configuration generation and screening completed.

### 4.1 Research Motivation

The earlier B1–B5.2 studies allowed anchor points at mathematical locations on the rectangular boundary.

However, practical prototype mounting requires a more realistic installation model.

Relevant literature notes are stored in:

`02_Paper_Reading/Literature_Review/workspace definition/`

These notes cover:

- Reconfigurable cable-driven parallel robots.
- Crossed cable routing.
- Anchor and attachment optimisation.
- Cable interference-free workspace analysis.
- Multi-pose configuration evaluation.

The **twelve-edge rail restriction** was introduced as a prototype-oriented engineering design decision inspired by the literature and mounting requirements.

It should not be presented as a universal requirement established by those papers.

### 4.2 Twelve-Rail Anchor Model

The rectangular frame contains:

- Four X-direction edges.
- Four Y-direction edges.
- Four Z-direction edges.

Total:

\[
N_{\mathrm{rails}}=12
\]

Every anchor is parameterised by:

\[
A_i(\rho_i,t_i)
=
E_{0,\rho_i}
+
t_i(E_{1,\rho_i}-E_{0,\rho_i})
\]

where:

- \(\rho_i\): selected rail ID.
- \(t_i\in[0,1]\): normalised position along the rail.
- \(E_{0,\rho_i}\), \(E_{1,\rho_i}\): rail endpoints.

The first rail candidate sampling produced:

- 12 complete rails.
- 60 sampled rail-point records.
- 44 unique spatial points.
- 8 shared frame corners.

Rail identity and physical coordinates must both be retained because a shared corner may belong to multiple rails.

### 4.3 Three Structured Configuration Families

Three families were proposed as **research hypotheses**, not proven optimal configurations.

**S1 — Structured Layered**

Rail composition:

- Four X-direction rails.
- Two Z-direction rails.

Research hypothesis:

A structured, layered anchor layout may provide good spatial coverage and acceptable sensing performance.

Motivation:

- Layered configurations investigated in previous B5.2 experiments.
- Literature-informed configuration and cable-routing design.
- Potential benefits from distributing attachment directions across layers.

**S2 — Distributed**

Rail composition:

- Two X-direction rails.
- Two Y-direction rails.
- Two Z-direction rails.

Research hypothesis:

Using rail directions from all three axes may increase cable-direction diversity and improve independent measurement information.

Motivation:

- Reduce excessive concentration of anchors in one region.
- Study effects of more balanced spatial distribution.
- Compare sensing and interference against layered layouts.

**S3 — Asymmetric**

Rail composition:

- One X-direction rail.
- Two Y-direction rails.
- Three Z-direction rails.

Research hypothesis:

Controlled spatial asymmetry may improve some sensing directions without causing unacceptable geometric interference.

Motivation:

- Previous F3 asymmetric configuration performance.
- Potential sensitivity gains from non-symmetric attachment geometry.
- Need to investigate geometry–sensing trade-offs.

### 4.4 Candidate Generation

Six anchor layouts were generated for each family.

| Family | Layouts |
|---|---:|
| S1 — Structured Layered | 6 |
| S2 — Distributed | 6 |
| S3 — Asymmetric | 6 |
| **Total** | **18** |

The configurations were constructed by combining:

1. Structured rail assignment.
2. Anchor position sampling.
3. Balloon-surface attachment selection.
4. Cable pairing search.
5. Reference-pose feasibility and sensing screening.

The exact attachment coordinates and pairings are retained in the saved MATLAB configuration datasets.

### 4.5 Multi-Pose Geometry and Sensing Screening

Each configuration was evaluated at all 189 Core poses.

For every pose:

1. Calculate attachment world coordinates and cable lengths.
2. Check Cable–sphere outward direction.
3. Calculate all 15 Cable–cable distances.
4. Determine geometric feasibility.
5. Calculate the six-cable measurement Jacobian.
6. Check Jacobian rank.
7. Calculate scaled singular values and condition number.

A configuration must pass all 189 Core geometric and rank checks before being considered Core-eligible.

Among the 18 configurations, six passed:

\[
\boxed{[2,\ 4,\ 6,\ 8,\ 12,\ 17]}
\]

| Config ID | Family | Core Geometry and Rank | Worst-Core \(\sigma_{\min}\) | Minimum Cable Distance |
|---|---|---:|---:|---:|
| **2** | S1 | 189/189 | **0.396711** | 4.6508 mm |
| **4** | S1 | 189/189 | 0.202621 | **34.2128 mm** |
| **6** | S1 | 189/189 | 0.268443 | 18.1059 mm |
| **8** | S2 | 189/189 | 0.226512 | 9.5408 mm |
| **12** | S2 | 189/189 | 0.366266 | 9.3165 mm |
| **17** | S3 | 189/189 | 0.278687 | 15.2926 mm |

**Research decision:** Config 2 was selected as the first case for detailed rail-position optimisation because it had relatively strong Worst-Core sensing quality.

This does **not** mean Config 2 has been established as the globally best six-cable configuration.

Configs 4, 6, 8, 12 and 17 remain active candidates.

---

## 5. B5.4 — Unified Evaluation, Pose Estimation and E1a

### 5.1 Unified Configuration Evaluation

**Status:** Completed for the initial 18 configurations.

A unified evaluation procedure was established to compare:

- Geometric feasibility.
- Jacobian rank.
- Worst and median sensing indicators.
- Minimum cable clearance.
- Cable length and stroke.
- Configuration eligibility.

Regression checks reproduced the previously obtained results.

This provides a common basis for future configuration comparisons.

### 5.2 Preliminary Nonlinear Pose Estimation and Noise Sensitivity

**Status:** Preliminary synthetic experiments completed; experimental validation pending.

The six Core-eligible configurations were evaluated using a nonlinear pose-reconstruction procedure.

The noise-free test verified numerical consistency between the forward cable-length model and the pose estimator.

A subsequent numerical experiment used independent cable-length noise:

\[
\sigma_L=0.100\ \mathrm{mm}
\]

There were 360 simulation trials per configuration.

Total:

\[
6\times360=2160
\]

All 2160 simulated tests converged.

Selected results:

| Metric | Best Observed Configuration | Result |
|---|---|---:|
| Lowest simulated position RMSE | Config 12 | 0.16779 mm |
| Lowest simulated orientation RMSE | Config 2 | 0.21444° |

These are model-based results under assumed noise conditions.

They do not establish experimentally measured sensing accuracy or prove that one configuration is superior in every respect.

### 5.3 E1a-A — Config 2 Anchor Rail Position Optimisation

**Status:** Completed as a controlled numerical optimisation and sampled robustness study.

**Research Question:**

Can changing only the anchor positions along their fixed rails improve sensing quality and cable clearance while preserving geometric feasibility?

Fixed variables:

- Rail assignment.
- Attachment coordinates.
- Cable pairing.
- Balloon geometry.

Optimisation variables:

\[
t=[t_1,t_2,t_3,t_4,t_5,t_6]
\]

### 5.4 E1a-A Research Procedure

**Step 1 — Single-Variable Sensitivity**

Each anchor position was independently varied by:

\[
\Delta t_i=\pm0.05,\ \pm0.10
\]

The purpose was to identify how each variable influenced:

- Core GeometryPass.
- Minimum cable distance.
- Worst-Core \(\sigma_{\min}\).
- Condition number.

Of the first 25 trials, 21 remained Core-eligible.

**Step 2 — Conditional Feasible Rail Intervals**

Each \(t_i\) was scanned over:

\[
t_i\in[0,1]
\]

Other anchors remained fixed.

Forty-one coarse positions and transition refinement were used to estimate conditional geometric feasibility intervals.

These intervals must not be treated as permanent hard bounds for joint optimisation.

**Step 3 — Sequential Coordinate Search**

Two searches were conducted.

*Sensing-oriented:*

Maximise Worst-Core \(\sigma_{\min}\) while preserving the baseline cable-clearance requirement.

*Clearance-oriented:*

Maximise minimum cable distance while preserving the baseline Worst-Core sensing requirement.

Each accepted change updated the complete six-dimensional configuration before the next cable was considered.

**Step 4 — Off-Grid Geometry Verification**

The optimised configurations were tested on previously untested combined-axis poses.

An additional Cable–sphere failure was discovered for C1.

**Step 5 — Targeted C1 Repair**

C1 was moved along Rail R5:

\[
t_1:0.400\rightarrow0.375
\]

This repaired the known C1 interference at original off-grid Pose 149.

**Step 6 — Independent Pose Validation**

An additional 200-pose set revealed a second Cable–sphere failure involving C4.

**Step 7 — Targeted C4 Repair**

C4 was moved along Rail R8.

Two candidates were retained:

- `t4 = 0.450` — sensing-favoured.
- `t4 = 0.470` — outward-margin-favoured.

**Step 8 — Final Sampled Robustness Comparison**

Both repaired candidates passed:

- All 539 sampled geometric and rank checks.
- All 12 independent single-anchor installation perturbation tests.

The `t4=0.470` configuration was selected as the current E1a preferred candidate.

### 5.5 Original Config 2 — Before E1a

**Family:** S1 — Structured Layered.

Rail assignment:

```matlab
rho_original = [5 6 7 8 1 4];
```

Rail parameters:

```matlab
t_original = [ ...
    0.400000 0.600000 0.550000 ...
    0.450000 0.700000 0.300000 ];
```

| Cable | Rail | Original Anchor `A_i` (mm) |
|---|---|---|
| C1 | R5 | `[-28,-150,-160]` |
| C2 | R6 | `[28,150,-160]` |
| C3 | R7 | `[14,-150,160]` |
| C4 | R8 | `[-14,150,160]` |
| C5 | R1 | `[-140,-150,64]` |
| C6 | R4 | `[140,150,-64]` |

Original performance:

| Metric | Result |
|---|---:|
| Core geometry and rank | 189/189 |
| Worst-Core scaled \(\sigma_{\min}\) | 0.396711 |
| Minimum ideal cable distance | 4.6508 mm |
| Combined 539-pose geometry | 538/539 |

One combined pose produced a C1 Cable–sphere outward-direction failure.

### 5.6 Current Preferred E1a Configuration

**Identifier:** `E1a_Robust_Config2_v1`

**Family:** S1 — Structured Layered.

**Status:** Preferred numerical candidate, not final prototype.

Rail assignment:

```matlab
rho_E1a = [5 6 7 8 1 4];
```

Optimised rail positions:

```matlab
t_E1a_Robust_Config2_v1 = [ ...
    0.375000 0.446898 0.304465 ...
    0.470000 0.754805 0.314867 ];
```

Selected anchor coordinates:

| Cable | Rail | Selected Anchor `A_i` (mm) |
|---|---|---|
| C1 | R5 | `[-35,-150,-160]` |
| C2 | R6 | `[-14.8686,150,-160]` |
| C3 | R7 | `[-54.7498,-150,160]` |
| C4 | R8 | `[-8.4,150,160]` |
| C5 | R1 | `[-140,-150,81.5376]` |
| C6 | R4 | `[140,150,-59.2426]` |

Attachment coordinates and cable pairing are unchanged from the saved B5.3 Config 2.

Use the exact attachment coordinates stored in the MATLAB configuration dataset.

**Current verified numerical performance:**

| Evaluation Metric | Result |
|---|---:|
| Combined sampled geometry | **539/539** |
| Full-rank Jacobian on sampled poses | **539/539** |
| Worst scaled \(\sigma_{\min}\) over 539 poses | **0.508750** |
| Minimum ideal cable distance | **6.1055 mm** |
| Minimum nominal outward angle | **+1.545778°** |
| Limiting cable | C1 |
| Limiting combined pose | 338 |
| Independent single-anchor perturbations | **12/12** |
| Worst perturbed outward angle | **+1.1734°** |
| Worst perturbed cable distance | **6.0597 mm** |

The alternative `t4=0.450` configuration achieved:

- Worst 539-pose \(\sigma_{\min}=0.509699\).
- Minimum outward angle = +0.757986°.
- Worst perturbed outward angle = +0.43616°.
- Installation perturbations = 12/12.

The `t4=0.470` candidate loses approximately 0.19% of the worst 539-pose scaled singular value relative to `t4=0.450`, while substantially increasing outward angular margin.

### 5.7 Improvement Versus the Original Config 2

| Comparable Metric | Original | Preferred E1a | Change |
|---|---:|---:|---|
| Minimum ideal cable distance | 4.6508 mm | 6.1055 mm | **+31.3%** |
| Combined 539-pose geometry | 538/539 | 539/539 | One observed failure repaired |
| Minimum outward angle | Negative at a known pose | +1.545778° | Observed interference eliminated |
| Original Core Worst \(\sigma_{\min}\) | 0.396711 | Not separately reported here | Same-domain comparison required |
| Final 539-pose Worst \(\sigma_{\min}\) | Not reported as a fully feasible baseline | 0.508750 | Do not calculate a mixed-domain percentage |

**Important:** The original `0.396711` value was computed on Core 189 poses, while the final `0.508750` was computed on 539 poses.

The ratio between these values is not a valid like-for-like sensing improvement.

The earlier **31.7% Core sensing improvement** belongs to the pre-repair sensing-oriented sequential-search result, not directly to the final repaired configuration.

---

## 6. Current Research Limitations

### 6.1 Configuration Selection

Only Config 2 has received detailed E1a rail-position optimisation.

The other five Core-eligible configurations remain to be optimised:

\[
[4,\ 6,\ 8,\ 12,\ 17]
\]

No final inter-family ranking has been established.

### 6.2 Training and Validation Separation

The 539-pose set has been used for failure discovery and targeted repair.

Therefore, it is now a development and repair-evaluation set rather than a fully untouched independent final validation set.

A fresh holdout is required for final configuration selection.

### 6.3 Continuous Workspace Feasibility

Passing 539 discrete pose tests does not guarantee interference-free motion at every intermediate pose or orientation.

Continuous workspace and additional stress testing remain open.

### 6.4 Physical Cable and Mounting Geometry

The current model excludes:

- Actual cable diameter.
- Pulley and cable-guide offsets.
- Connector footprints.
- Mounting bracket dimensions.
- Carriage size.
- Rail-end dead zones.
- Frame obstacles.
- Physical cable deflection.

### 6.5 Installation Error

The current 12 perturbation cases vary only one anchor at a time.

Simultaneous anchor errors, attachment placement errors and systematic mounting bias have not yet been evaluated.

### 6.6 Experimental Sensing Accuracy

Jacobian singular values and simulated pose reconstruction are useful theoretical indicators.

They do not replace:

- Sensor calibration.
- Independent ground truth.
- Experimental position/orientation accuracy.
- Estimator convergence and ambiguity evaluation.
- Measurement error propagation under real noise and bias.

### 6.7 Tension and Passive Motion

Positive low-tension feasibility remains unresolved.

The prototype must maintain cable tautness without intentionally controlling or significantly disturbing balloon motion.

### 6.8 Flexible Balloon and Additional Cables

Full balloon deformation estimation and six-/seven-/eight-cable comparative validation remain future research objectives.

---

## 7. Updated Research Plan and Immediate Priorities

### 7.1 Current Task — Repository Consistency and Research Presentation

**Status:** In progress.

Before continuing technical optimisation:

1. Consolidate the B1.4–B5.4 research timeline.
2. Review and update GitHub research state and project plans.
3. Remove or correct inconsistent current-status statements.
4. Preserve historical research logs.
5. Develop a clear research-presentation narrative.

GitHub files are updated manually, one file at a time.

### 7.2 B5.4 E1a-B — Six-Configuration Fair Comparison

**Status:** Next technical research priority.

**Research Question:**

How do the six Core-eligible configurations compare after receiving equivalent anchor rail-position optimisation?

Candidate configurations:

```matlab
eligible_config_ids = [2 4 6 8 12 17];
```

Each configuration retains:

- Its own original rail assignments.
- Its own attachment coordinates.
- Its own cable pairing.

Only rail-position parameters are optimised during E1a-B.

**Fair comparison requirements:**

1. Use the same optimisation method.
2. Use equivalent search budgets.
3. Use common development pose sets.
4. Apply the same geometry and rank constraints.
5. Compare sensing over identical pose domains.
6. Record cable clearance and outward angular margin.
7. Include installation perturbation sensitivity.
8. Use a fresh independent validation set.
9. Avoid copying Config 2's conditional feasible intervals to other configurations.
10. Retain multiple Pareto-relevant candidates where justified.

Expected output:

A reproducible comparison of optimised S1, S2 and S3 configurations and a justified shortlist.

### 7.3 B5.4 E1b — Rail Assignment Optimisation

**Status:** Planned after E1a-B.

E1a changes the location of anchors **along fixed rails**.

E1b introduces rail assignment as an additional discrete design variable.

\[
\rho_i\in\{R1,R2,\ldots,R12\}
\]

Research question:

Can a different selection of physical rails improve geometry, sensing quality or robustness beyond position-only adjustment?

Initially:

- Keep attachment coordinates fixed.
- Keep cable pairing fixed.
- Evaluate controlled single-cable rail reassignment.
- Optimise the new anchor position on the selected rail.
- Use consistent multi-pose evaluation criteria.

Then consider more complex coordinated rail reassignment if justified.

### 7.4 E2 — Attachment Point Optimisation

**Status:** Planned.

Investigate balloon-surface attachment positions with anchor and pairing variables controlled.

Evaluate:

- Sphere outward geometry.
- Cable routing.
- Jacobian quality.
- Sensitivity to attachment placement error.
- Physical attachment feasibility.

### 7.5 E3 — Cable Pairing Optimisation

**Status:** Planned.

Hold the anchor and attachment point sets fixed while testing alternative pairings.

Study:

- Cable–cable interference.
- Cable–sphere interference.
- Sensing direction independence.
- Worst-case Jacobian quality.
- Mechanical routing complexity.

### 7.6 E4 — Joint Configuration Optimisation

**Status:** Planned.

Combine:

- Rail assignment.
- Rail position.
- Attachment positions.
- Cable pairing.

Use geometry and mechanical constraints with sensing objectives.

Compare Pareto-relevant configurations and avoid unsupported claims of global optimality.

### 7.7 Later Stages — Estimation, Prototype and Experiments

Remaining work includes:

- Independent pose-estimation validation.
- Sensor and system calibration.
- Cable length and stroke requirements.
- Tension feasibility.
- Motor and sensor selection.
- Actual pulley and mounting geometry.
- Prototype V1.0 fabrication.
- Rigid balloon experiments.
- Flexible balloon compatibility and experiments.
- Six-/seven-/eight-cable theoretical comparison.

---

## 8. Repository Reference Hierarchy

| File / Directory | Purpose |
|---|---|
| `AGENTS.md` | Repository entry instructions |
| `AGENTS2.md` | Stable AI and research working rules |
| `CURRENT_STATE2.md` | Verified current research progress |
| `08_Project_Management/Roadmap.md` | Long-term milestones |
| `08_Project_Management/November/` | Research schedules and active plans |
| `02_Paper_Reading/Literature_Review/workspace definition/` | Relevant configuration and workspace literature |
| `03_Simulation/MATLAB/` | MATLAB scripts and numerical experiments |
| `05_My_Research/` | Technical design documents |
| `06_Research_Log/2026-11/` | Verified research evidence |

### Important Research Logs

- `B5_1_Lesson2_Candidate_Expansion_and_Pairing_2026_11_10.md`
- `B5_2_Multi_Pose_Geometric_Screening_2026_11_10.md`
- `B5_3_Twelve_Rail_Structured_Configuration_Research_Log_2026_11_11.md`
- `B5_4_E1a_Anchor_Rail_Position_Optimisation_Research_Log_2026_11_12.md`

### Active Planning Reference

`08_Project_Management/November/B5_3_to_B5_6_Revised_Research_Plan_Thesis_Informed_2026_11_10.md`

This plan should be reviewed to incorporate E1a-B as the next technical priority.

---

## 9. Current Research Decision

**Current preferred numerical design:**

`E1a_Robust_Config2_v1`

**Completed:**

- Initial anchor and attachment candidate generation.
- Reference-pose six-cable configuration search.
- Multi-pose geometry and sensing verification.
- Literature-informed twelve-rail configuration design.
- S1/S2/S3 initial configuration generation.
- Screening of 18 configurations.
- Identification of six Core-eligible configurations.
- Config 2 rail-position optimisation.
- C1 and C4 geometric failure diagnosis and repair.
- Final 539-pose sampled geometry and rank verification.
- Independent single-anchor perturbation tests.

**Next technical task:**

B5.4 E1a-B — Apply equivalent rail-position optimisation to Configs 2, 4, 6, 8, 12 and 17 and conduct a fair comparison.

**Subsequent task:**

B5.4 E1b — Rail Assignment Optimisation.

**Current scientific conclusion:**

A six-cable configuration constrained to twelve frame-edge rails can achieve strong sampled geometric feasibility and useful local sensing performance after controlled anchor-position optimisation.

However, only one of the six Core-eligible configurations has received detailed rail-position refinement.

The current preferred E1a configuration should therefore be retained as a **reference candidate**, not declared the final optimal six-cable system.

---

**Guiding Principle:** Research questions determine the methods. Numerical evidence supports configuration decisions. Independent testing and physical experiments are required to validate the actual sensing system.
