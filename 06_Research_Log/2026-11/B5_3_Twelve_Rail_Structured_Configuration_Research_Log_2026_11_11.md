# B5.3 Research Log — Twelve-Rail-Constrained Six-Cable Configuration Design

**Date:** 2026-11-11  
**Phase:** B — Six-cable configuration development  
**Status:** B5.3 Lessons 2.1–5 completed at the simulation/screening level; B5.4 not started  
**Research system:** Passive cable-based sensing of a rigid balloon-like object (initial six-DOF model)  
**Primary tool:** MATLAB  
**Units:** mm, N (future tension), degrees for displayed Euler angles  
**Repository update mode:** Manual, file by file

---

## 1. Research Objective

> Can a physically interpretable **six-cable configuration** be constructed using anchors constrained to the **twelve edges of a rectangular frame**, while retaining discrete multi-pose geometric feasibility and local six-DOF sensing observability?

This phase replaces the earlier arbitrary **face-surface anchor sampling** with **rail-constrained mounting**. It does **not** claim an optimal or experimentally validated six-cable configuration. The balloon is passively displaced; cables are sensing elements and are intended to remain at low tension, rather than actively command a predetermined trajectory.

### Study logic

1. Define all twelve installable frame-edge rails.
2. Separate ideal carriage, pulley-centre, and effective-exit-point geometry.
3. Record measurement requirements and unknown hardware specifications.
4. Generate systematic anchor-layout families.
5. Select spherical attachments and search one-to-one pairings at the reference pose.
6. Screen selected six-cable configurations over identical **189 Core poses**.
7. Preserve both performance-oriented and clearance-oriented configurations for B5.4.

---

## 2. Fixed Model and Conventions

| Parameter | Value / convention | Evidence status |
|---|---|---|
| Engineering frame | 280 (X/length) × 300 (Y/width) × 320 (Z/height) mm | Established B1 simplification |
| Frame half extents | ±140, ±150, ±160 mm | Derived |
| Balloon model | Rigid sphere, radius **50.8266 mm**, nominal 550 mL | Initial engineering model; not deformation model |
| Anchor installation | All **12 frame edges**; 4 rails each parallel to X, Y and Z | Updated mechanical design requirement |
| Cable count | 6 | Current prototype/research baseline |
| Core translations | x, y, z ∈ {−20, 0, 20} mm | Provisional numerical workspace |
| Core rotations | (0,0,0), ±5° about one axis at a time | Provisional numerical workspace |
| Core pose count | 27 × 7 = **189** | Verified |
| Rotation convention | R = Rz(yaw) Ry(pitch) Rx(roll) | Same as previous B-stage scripts |
| Cable segment | Straight, zero thickness, B_i(q) to A_i | Idealised model |
| Sphere outward test | (Rr_i) · [A_i − (P + Rr_i)] ≥ −10⁻⁹ mm² | Numerical test |
| Cable-pair contact | Finite-segment distance d_ij > 10⁻⁶ mm | Numerical zero-thickness tolerance, not physical clearance |
| Jacobian | H_i = [−u_iᵀ, (u_i × Rr_i)ᵀ] | B4 convention |
| Scaled Jacobian | H_s = H diag(1,1,1,1/r_b,1/r_b,1/r_b) | B4 convention |

An anchor on rail ρ_i at normalised coordinate t_i is

\[
A_i = E_{\rho_i}^{(0)} + t_i \bigl(E_{\rho_i}^{(1)}-E_{\rho_i}^{(0)}\bigr), \quad 0\le t_i\le1.
\]

A complete cable configuration requires the paired body-frame attachment r_i (\|r_i\| = r_b). Mere rail assignment does not determine measurement sensitivity or ensure physically separated sliders.

---

## 3. Lesson 2.1 — Twelve-Rail Anchor Geometry

**Research question:** Where can anchors be installed on the twelve-rail frame?

### Implementation

- R1–R4: four complete Z-directed edges, 320 mm each.
- R5–R8: four complete X-directed edges, 280 mm each.
- R9–R12: four complete Y-directed edges, 300 mm each.
- Five initial sampling positions per rail (t = 0, 0.25, 0.5, 0.75, 1).
- Preserve both unique spatial positions and rail-membership relations at shared corners.

### Verified results

| Validation | MATLAB result |
|---|---:|
| Valid rails | **12 / 12** |
| Rails along X / Y / Z | **4 / 4 / 4** |
| Raw sampled rail records | **60** |
| Unique candidate positions | **44** |
| Shared geometric corners | **8** |
| Non-corner candidate points | **36** |
| Rail membership validation | **Passed** |

The 44 points are a **discrete initialisation**, not a permanent restriction of continuous rail travel. Each corner is one 3D location but belongs to three rails; the rail identity must be retained for subsequent carriage movement and mechanical installation checks.

**Saved dataset:** `B5_3_12rail_geometry_baseline.mat`

**Decision:** All future newly designed anchors must satisfy the twelve-rail constraint. Earlier B1–B5.2 configurations remain historical baselines, not automatically mechanically mountable candidates.

---

## 4. Lesson 2.2 — Mechanical Interface Definition

**Research question:** Can a rail carriage coordinate be treated as the actual cable exit point?

Three different locations were distinguished:

- **C_i:** rail carriage reference position;
- **O_i:** pulley centre (depends on mount geometry);
- **A_i^eff:** effective cable exit/tangent point, potentially pose-dependent with a pulley.

The idealised model currently uses **A_i^eff ≈ C_i** only as a provisional modelling assumption. It does not claim the pulley centre and cable exit point are identical.

### Verified MATLAB interface checks

- Twelve rails loaded.
- R1, t = 0.35 gives C = **(−140, −150, −48) mm**.
- Eight shared corners detected, each associated with three rail IDs.
- Two example carriage reference points on R1 and R5 near a shared corner are **8.5041 mm apart**; **actual hardware collision status remains unknown**.

**Mechanical decisions:** Prefer a *fixed-guidance mechanical concept* for Prototype V1, retain interfaces for later guide/pulley upgrades. Do **not** infer a physical guide type, offset, carriage collision clearance or tension range from the current ideal model.

**Unresolved parameters:** mounting orientation, pulley offset, exit-point offset, carriage/connector envelope, rail-end exclusions, cable diameter, cable-length zero offset and calibration procedure.

**Saved dataset:** `B5_3_mechanical_interface_baseline.mat`

---

## 5. Lesson 2.3 — Measurement Requirements

**Research question:** Which performance measures determine whether the sensing system succeeds?

A **14-item requirement matrix** was defined and saved. It distinguishes task-related measures from proxy quantities:

- R01: rigid six-DOF pose reconstruction;
- R02: Core geometric feasibility (provisional numerical target **189/189**);
- R03–R05: position RMSE, orientation RMSE, worst pose error (**numeric targets TBD**);
- R06: locally full-rank scaled Jacobian (**rank 6**);
- R07: real cable clearance (**TBD**);
- R08: rail mountability (**0 off-rail anchors**);
- R09: cable stroke (to evaluate against hardware);
- R10: low-tension and nonintrusive behaviour (**TBD**);
- R11–R12: reconstruction reliability and update rate (**TBD**);
- R13: installation robustness (**TBD**);
- R14: independent ground truth (**method/accuracy TBD**).

**MATLAB verification:** 14 requirements, **3 numerically specified targets**, **11 unspecified numerical targets**; Core 189/189, rank 6, off-rail count 0. These are targets, **not achieved experimental performance**.

**Saved datasets:** `B5_3_measurement_requirements.mat`, `B5_3_measurement_requirements.csv`.

**Decision:** Actual pose-estimation accuracy and robustness, not Jacobian condition number alone, must eventually govern the final prototype choice.

---

## 6. Lesson 3 — Structured Anchor Families

**Research question:** Can systematic rail assignments provide interpretable, repeatable anchor-layout alternatives?

Three families were proposed as **engineering hypotheses**, not literature-proven optimum designs:

| Family | Rail assignment rule in initial experiment | Intended investigation |
|---|---|---|
| **S1 — Structured Layered** | Four X rails + two Z rails | Layering and geometry clearance |
| **S2 — Distributed** | Two X + two Y + two Z rails | Spatial direction diversity |
| **S3 — Asymmetric** | One X + two Y + three Z rails | Asymmetric spatial sensing geometry |

For each family: 3 explicit rail assignments × 2 t-parameter patterns = **6 anchor layouts**; total **18**. The six anchors in each layout lie on six distinct rails.

### Verified results

| Family | Anchor layouts | Smallest sampled anchor-point separation among its layouts |
|---|---:|---:|
| S1 | 6 | **145.890 mm** |
| S2 | 6 | **126.507 mm** |
| S3 | 6 | **126.507 mm** |

All 18 layouts passed ideal point-to-rail checks; maximum reported rail-location error was **0 mm**.

**Saved dataset:** `B5_3_12rail_anchor_families.mat`

**Methodological limitation:** Different anchor layouts were subsequently assigned newly sampled attachment sets in Lesson 4; therefore, differences among the final configurations **cannot be attributed solely to rail parameter t**. Controlled-variable experiments in B5.4 must hold attachments and pairings fixed while varying t.

---

## 7. Lesson 4 — Attachment Selection and Pairing

**Research question:** Can the 18 rail-constrained anchor layouts form complete, locally observable six-cable configurations at the reference pose?

### Method

- Generate **100 Fibonacci-sphere attachment candidates** (maximum radial error **1.421 × 10⁻¹⁴ mm**).
- For each of the 18 anchor layouts, sample **5 six-attachment sets**, using a reproducible random seed `rng(42)` and an exploratory attachment-direction filter.
- Enumerate all **6! = 720** permutations for each set.
- Screen **18 × 5 × 720 = 64,800** pairing trials for reference-pose cable–sphere geometry, cable–cable contact and Jacobian rank.
- Retain the reference-feasible result with the largest scaled minimum singular value for each anchor layout.

### Verified result

**18/18 layouts** produced at least one reference-pose configuration satisfying the implemented geometric and numerical-rank tests.

Representative high-interest results (reference pose only):

| Config ID | Family | Reference σ_min | Reference κ | Reference min cable distance (mm) |
|---|---|---:|---:|---:|
| 2 | S1 | 0.608190 | 3.292058 | 7.597 |
| 4 | S1 | 0.446903 | 4.458946 | 34.213 |
| 5 | S1 | 0.659463 | 3.034479 | 31.367 |
| 11 | S2 | 0.751072 | 2.679184 | 10.271 |
| 12 | S2 | 0.554546 | 3.400657 | 11.524 |
| 13 | S3 | **0.767585** | **2.275063** | 2.962 |
| 17 | S3 | 0.493750 | 4.621698 | 19.205 |

**Saved dataset:** `B5_3_initial_six_cable_configurations.mat`

**Decision:** Reference-pose quality is only an initial selection criterion. In particular, Config 13's excellent reference Jacobian result does **not** qualify it for a Core-wide prototype decision.

---

## 8. Lesson 5 — 189-Pose Core Screening

**Research question:** Which of the 18 fixed candidate configurations remain geometrically feasible and rank-six throughout the Core sample set?

All configurations retained the **same anchor positions, attachment positions and one-to-one pairings** as selected in Lesson 4. No optimisation was performed in this lesson.

### Complete verified results

The σ_min and κ columns below are calculated on the **geometrically feasible poses only**; values from candidates with different pass counts are not fair direct rankings.

| Config | Family | Core geometry | Worst feasible σ_min | Worst feasible κ | Min pair distance (mm) | Max calculated stroke (mm) |
|---:|---|---:|---:|---:|---:|---:|
| 1 | S1 | 158/189 | 0.256087 | 8.1931 | 14.2577 | 74.020 |
| **2** | **S1** | **189/189** | **0.396711** | **5.2042** | **4.6508** | **72.062** |
| 3 | S1 | 106/189 | 0.142628 | 12.7472 | 38.5736 | 73.847 |
| **4** | **S1** | **189/189** | **0.202621** | **9.3044** | **34.2128** | **72.803** |
| 5 | S1 | 174/189 | 0.412039 | 4.7568 | 31.3669 | 72.513 |
| **6** | **S1** | **189/189** | **0.268443** | **7.1131** | **18.1059** | **73.784** |
| 7 | S2 | 181/189 | 0.143112 | 15.7953 | 24.5663 | 74.729 |
| **8** | **S2** | **189/189** | **0.226512** | **8.8214** | **9.5408** | **73.221** |
| 9 | S2 | 104/189 | 0.002682 | 715.9844 | 0.0084 | 75.121 |
| 10 | S2 | 142/189 | 0.037882 | 50.4487 | 10.6947 | 73.483 |
| 11 | S2 | 185/189 | 0.556566 | 3.6135 | 6.5400 | 75.432 |
| **12** | **S2** | **189/189** | **0.366266** | **5.3785** | **9.3165** | **70.177** |
| 13 | S3 | 43/189 | 0.643110 | 2.8028 | 1.7495 | 74.623 |
| 14 | S3 | 130/189 | 0.406877 | 4.7593 | 4.4708 | 72.557 |
| 15 | S3 | 187/189 | 0.294822 | 7.4720 | 17.1409 | 74.984 |
| 16 | S3 | 138/189 | 0.282671 | 6.6146 | 11.6331 | 70.147 |
| **17** | **S3** | **189/189** | **0.278687** | **8.0616** | **15.2926** | **70.720** |
| 18 | S3 | 87/189 | 0.358768 | 5.5643 | 2.7718 | 72.433 |

**Reported checks:** all 18 configurations had CablePass = **189/189** for ideal zero-thickness cable–cable checks. For those with geometry failures, the recorded failures arose from the cable–sphere outward-direction condition. All geometrically feasible poses had numerical Jacobian rank 6. These observations do not verify physical cable clearance or continuous workspace feasibility.

### Core eligibility

\[
\text{CoreEligible} = (N_{\text{geometry}}=189) \land (N_{\text{rank6 on feasible}}=189).
\]

**Exactly 6/18 were eligible:** `Config [2, 4, 6, 8, 12, 17]`.

- S1: Config 2, 4, 6;
- S2: Config 8, 12;
- S3: Config 17.

**Saved dataset:** `B5_3_early_multipose_screening.mat`

### Difference from the original shortlist algorithm

The previous shortlist selected up to two configurations **per family** by worst feasible σ_min, yielding `[2, 6, 12, 8, 17]`. This excluded **Config 4**, even though Config 4 is Core-eligible and has the **largest minimum cable separation (34.2128 mm)** of the six eligible candidates. The exclusion was a *shortlist policy*, **not an eligibility failure**. Preserve all six eligible configurations.

### Key diagnostic counterexamples

- **Config 13 (S3):** reference σ_min = 0.767585 but only **43/189** Core geometry passes; its feasible-pose worst σ_min = 0.643110 must **not** be compared as though it covered all 189 poses.
- **Config 5 (S1):** reference σ_min = 0.659463, Core **174/189**, worst feasible σ_min = 0.412039; not Core-eligible until geometry is repaired and revalidated.
- **Config 11 (S2):** Core **185/189**, worst feasible σ_min = 0.556566; a promising sensing-oriented repair candidate, but not a strict Core-pass candidate.
- **Config 15 (S3):** Core **187/189**; a near-eligible geometry repair example.

These results support prioritising geometry as an initial gate before comparing sensing indicators across identical pose sets.

---

## 9. Visualisation Selection — One Configuration per Family

**Reference-pose 3D visualisation:** choose three **Core-eligible** configurations, rather than taking the single highest reference σ_min for each family:

| Visualised configuration | Family | Core geometry | Worst Core σ_min | Worst Core κ | Min Core cable distance |
|---|---|---:|---:|---:|---:|
| **Config 2** | S1 Layered | 189/189 | **0.396711** | 5.204174 | 4.6508 mm |
| **Config 12** | S2 Distributed | 189/189 | **0.366266** | 5.378531 | 9.3165 mm |
| **Config 17** | S3 Asymmetric | 189/189 | **0.278687** | 8.061598 | 15.2926 mm |

**Rationale:** identical Core coverage and full numerical rank allow a fair first comparison of worst-Core sensing; S1/S2/S3 are all represented. They are **representative designs, not final winners**. Keep Config 4 in the broader optimisation set as a clearance-oriented comparison.

The MATLAB figure shows all six cables (`C1`–`C6`), matching anchors (`A1`–`A6` plus Rail IDs), attachment points (`B1`–`B6`), the balloon, and all twelve frame edges at **P = (0,0,0), R = I**. The title labels **Core statistics separately** from the reference-pose diagram; this avoids implying that a single image proves multi-pose feasibility.

**Visualisation script:** `B5_3_Lesson5_Visualization_S1_S2_S3_2026_11_11.m`  
**Expected figure outputs when executed locally in MATLAB:** `B5_3_Selected_S1_S2_S3_Configurations.png` and `.fig`.

---

## 10. Main Research Conclusions

1. **Rail-constrained six-cable layouts are feasible in the initial numerical sense.** All 18 anchor layouts lie on the twelve allowed rails; all 18 yielded at least one reference-feasible complete configuration; **six** passed the sampled Core geometry and rank requirements.
2. **Reference-pose sensing is not sufficient for design selection.** Config 13 illustrates severe loss of Core geometric coverage despite excellent reference Jacobian values.
3. **Geometry and sensing must be evaluated together on a common pose set.** Configs 2, 4, 12 and 17 exhibit different sensing/clearance tradeoffs despite all meeting current Core numerical gates.
4. **Rail parameters matter, but t-only causality is not yet established.** Subsequent attachment/pairing reselection confounded the previous paired-layout comparisons. B5.4 E1a must freeze the same attachments and pairings while perturbing only t.
5. **Physical installability remains incompletely specified.** Effective cable exit points, rail-carriage envelopes, cable diameters, mounting clearances, low tension and pulley/encoder calibration are still unknown or unverified.
6. **The stated task is sensing, not active motion control.** A high scaled Jacobian singular value is a proxy for local sensitivity; actual nonlinear pose-estimation error and reconstruction reliability require independent tests.

---

## 11. Limitations and Open Questions

- Only **189 discrete Core poses** were checked; no claim of continuous collision-free workspace, all-axis rotation combinations, or clinically measured stomach motion limits.
- The balloon is currently an ideal **rigid sphere**; deformation is outside the present six-DOF model.
- Cable segments are assumed straight and **zero thickness**; true physical clearance and bending/wrapping around guides are not assessed.
- Rail-carriage points are treated as **effective fixed cable exits** as an ideal approximation. Pulley-centre offsets, changing tangent points and zero offsets require later modelling/calibration.
- The six cable lines were not yet assessed for feasible low-tension operation, slack, perturbations to passive balloon motion, or real sensors.
- The 100 Fibonacci attachment points, five six-point sets per layout and three rail assignments per family do **not** exhaust design space or establish global optimality.
- The original default shortlist intentionally limited family representation and omitted one eligible clearance-oriented candidate; a separate complete eligibility set is required.
- No experimentally calibrated cable-length noise, mounting uncertainty, or ground-truth system has been established.
- The Core geometry criterion is currently a **provisional simulation gate**, not a medical or hardware certification standard.

---

## 12. Handoff to B5.4 — Next Research Steps (Not Yet Done)

**B5.4 Lesson 1 — Unified Geometry and Sensing Evaluator:**
- Reproduce all 18 B5.3 screening results using a single callable MATLAB evaluator; regression-test geometry masks, ranks, lengths, cable distances and scaled singular values.
- Save all six Core-eligible configurations: `[2, 4, 6, 8, 12, 17]`.
- Use an exploratory focus set `[2, 4, 12, 17]`, with `[6, 8]` as additional eligible controls.
- Track repair candidates `[5, 11, 15]` **separately**; they do not meet the Core full-pass gate.

**B5.4 Lesson 2 — Minimal Nonlinear Pose Estimator:**
- Generate synthetic cable lengths from independently known test poses, then estimate the unknown pose without passing the ground-truth pose into the solver.
- Report geodesic orientation error, 3D position error, convergence, initialisation dependence and failures.

**B5.4 controlled-variable optimisation:**
- **E1a (t-only):** fix rail IDs, attachment coordinates and pairings; adjust rail travel t_i.
- **E1b (rail reassignment):** adjust rail IDs and t_i while holding attachments/pairing fixed.
- **E2 (attachment-only):** fix anchors and pairing, adjust spherical attachment positions.
- **E3 (pairing-only):** fix both point sets, change one-to-one mapping.
- **E4 (joint):** optimise together under identical numerical Core and mounting constraints.

**Beyond the nominal optimisation:**
- Hold out unseen poses; introduce grounded noise and mounting uncertainty; inspect low-tension/slack feasibility and true carriage/cable clearance; then undertake prototype fabrication/calibration decisions.

**Important:** Do not claim B5.4 has been performed until the new evaluator and estimator have actually been run and verified.

---

## 13. Main MATLAB Files and Provenance

| File | Purpose |
|---|---|
| `B5_3_12rail_geometry_baseline.mat` | Twelve rail segments; 44 unique initial candidate positions; corner memberships |
| `B5_3_mechanical_interface_baseline.mat` | Known vs TBD mechanical interface parameters |
| `B5_3_measurement_requirements.mat` | Fourteen requirements and provisional numerical criteria |
| `B5_3_measurement_requirements.csv` | Inspectable requirements matrix |
| `B5_3_12rail_anchor_families.mat` | Eighteen structured anchor layouts and family assignments |
| `B5_3_initial_six_cable_configurations.mat` | Reference-feasible six-cable designs and pairing-search results |
| `B5_3_early_multipose_screening.mat` | Eighteen Core-189 geometry, Jacobian and cable-length result records |
| `B5_3_Lesson5_Visualization_S1_S2_S3_2026_11_11.m` | Repeatable reference-pose comparison figure for Configs 2, 12 and 17 |
| `B3_1_segment_distance_3d_2026_11_02.m` | Previously verified finite 3D segment-distance routine |

---

## 14. Research Decisions to Preserve

- **Do not restart B1–B5.2**: preserve historical simulation results and mark their difference from the new rail-constrained designs.
- **Do not discard Config 4**: it passes the Core numerical criteria and has the largest ideal cable–cable distance among the six currently eligible configurations.
- **Do not select the final prototype yet**: configuration, sensing accuracy, mounting uncertainty, true clearance and low-tension feasibility must still be considered.
- **Do not attribute t-effects to the old paired-layout comparisons**: Lesson 4 changed attachment/pairing as well.
- **Do not silently replace TBD hardware parameters with fabricated numbers.**

**Next action after GitHub log update:** begin B5.4 Lesson 1 only when the user chooses to resume that phase.
