# Current Research State

**Version:** 0.8  
**Last Updated:** 2026-11-12  
**Project:** Cable-Robot-Based Sensing for a Passive Deformable Balloon  
**Current Phase:** B5.4 — Six-Cable Configuration Optimisation  
**Latest Completed Task:** E1a-A — Config 2 Rail-Position Optimisation  
**Next Technical Task:** E1a-B — Six-Configuration Fair Comparison  
**Primary Tool:** MATLAB

---

## 1. Research Objective

Develop a cable-length-based measurement system for estimating the position, orientation and eventually deformation of a passively moving balloon-like object.

The application is motivated by a simplified intragastric balloon environment.

### Main Research Question

> Can cable-length measurements reconstruct the pose of a passively moving balloon, and which cable configuration provides reliable sensing while satisfying geometric and mechanical constraints?

The system is intended for **measurement and estimation**, not trajectory control.

Motors may maintain low positive cable tension while following passive balloon displacement. Physical tension feasibility and possible disturbance of the balloon remain unverified.

### Research Workstreams

| Workstream | Focus | Priority |
|---|---|---|
| A | Six-cable configuration, sensing and prototype validation | Primary |
| B | Seven-/eight-cable observability, redundancy and simulation | Parallel |

The initial scope is six-degree-of-freedom rigid-body pose estimation.

Deformation sensing and cable-number expansion remain longer-term research objectives.

---

## 2. Current Engineering Model

| Parameter | Current Definition |
|---|---|
| Engineering boundary | 280 × 300 × 320 mm |
| Axes | X = Length, Y = Width, Z = Height |
| Nominal balloon volume | 550 mL |
| Initial balloon model | Rigid sphere |
| Balloon radius | 50.8266 mm |
| Estimated state | 6-DOF pose |
| Primary measurement | Cable length |
| Initial cable number | 6 |
| Anchor installation model | Twelve frame-edge rails |
| Attachment region | Balloon surface |
| Balloon motion | Passive and unknown |

The engineering box is not a clinically validated continuous gastric workspace.

Current cable geometry assumes ideal straight, zero-thickness segments.

Actual pulley exit points, cable diameter and connector dimensions are not yet incorporated into the validated model.

### Cable Geometry

For each cable:

\[
B_i=P+Rr_i
\]

\[
D_i=A_i-B_i
\]

\[
L_i=\|D_i\|
\]

where:

- \(P\): balloon centre position.
- \(R\): body-to-world rotation matrix.
- \(r_i\): body-frame attachment coordinate.
- \(B_i\): world-frame attachment position.
- \(A_i\): world-frame anchor position.
- \(L_i\): cable length.

The measurement Jacobian and characteristic-length scaling are documented in `AGENTS2.md` and the relevant Research Logs.

---

## 3. Important Evaluation Definitions

### Geometric Feasibility

Current numerical checks include:

1. Cable–sphere outward departure.
2. Minimum finite-segment distance for all 15 cable pairs.
3. Positive cable lengths.
4. Jacobian rank and sensing indicators.

The current idealised Cable–cable numerical contact threshold is:

\[
d_{ij}>10^{-6}\ \mathrm{mm}
\]

This does not establish adequate clearance for real cables.

### Sensing Quality

Primary numerical indicators:

- Jacobian rank.
- Scaled minimum singular value \(\sigma_{\min}\).
- Scaled condition number \(\kappa\).
- Pose-estimation RMSE.
- Estimator convergence rate.

A full-rank Jacobian establishes local first-order sensitivity, not guaranteed global pose uniqueness or experimental accuracy.

### Evaluation Pose Sets

**These datasets must not be confused.**

| Dataset | Translation Range | Orientation | Poses |
|---|---|---|---:|
| Historical wider benchmark | `{-50,0,50}` mm per axis | Identity and single-axis ±10° | 189 |
| Core development set | `{-20,0,20}` mm per axis | Identity and single-axis ±5° | 189 |
| First off-grid set | Random within ±20 mm | Combined RPY within ±5° | 150 |
| Additional off-grid set | Random within ±20 mm | Combined RPY within ±5° | 200 |
| E1a combined development set | Core + off-grid samples | Mixed | 539 |

The 539-pose collection was used during E1a development and repair.

**It is not an untouched final validation set.**

Passing all sampled poses does not prove feasibility throughout a continuous workspace.

---

## 4. Research Progress Summary

| Task | Main Achievement | Status |
|---|---|---|
| Phase 0 | Application and measurement objective | Initial synthesis completed |
| Phase A | Literature method reproduction | Core scope completed |
| B1 | Geometry and candidate regions | Completed |
| B2 | Initial six-cable configurations | Completed |
| B3 | Multi-pose geometric feasibility | Completed |
| B4 | Jacobian and initial sensing evaluation | Initial scope completed |
| B5.1 | Configuration diagnosis and candidate expansion | Completed |
| B5.2 | Multi-pose configuration screening | Completed |
| B5.3 | Twelve-rail structured configurations | Completed |
| B5.4 Lesson 1 | Unified evaluation procedure | Completed |
| B5.4 Lesson 2 | Preliminary nonlinear pose-estimation simulation | Completed |
| B5.4 E1a-A | Config 2 rail-position optimisation and repair | Completed |
| B5.4 E1a-B | Fair six-configuration optimisation | Next |
| E1b–E4 | Further configuration optimisation | Planned |
| B5.5 | Measurement validation and calibration | Planned |
| B5.6 | Prototype engineering and experiments | Planned |

Detailed implementation and experimental history belong in the Research Logs.

---

## 5. Important Completed Research Findings

### B1–B2 — Initial Geometry and Configuration Search

The original candidate sets contained:

- 26 anchor points.
- 40 balloon-surface attachment points.

Reference-pose sensing results:

| Configuration | Scaled \(\sigma_{\min}\) | Scaled \(\kappa\) |
|---|---:|---:|
| Baseline | 0.004393 | 490.956 |
| Experiment A | 0.535345 | 3.5759 |
| Experiment B | 0.533600 | 3.2365 |

**Conclusion:** Configuration geometry strongly influences local sensing quality.

### B3–B4 — Multi-Pose Feasibility and Sensing

Historical wider 189-pose geometric results:

| Configuration | Geometrically Feasible |
|---|---:|
| Experiment A | 40/189 |
| Experiment B | 105/189 |

Experiment B showed better sampled sensing performance than Experiment A across comparable geometrically feasible poses.

**Conclusion:** Good reference-pose sensing does not guarantee broad geometric feasibility.

Initial local uncertainty studies used assumed cable-length noise:

\[
\sigma_L=0.1\ \mathrm{mm}
\]

These results are model predictions, not experimental accuracy measurements.

### B5.1–B5.2 — Configuration Redesign

Candidate regions were expanded:

- Anchors: 26 → 98.
- Attachments: 40 → 100.

Modified B′ was obtained by changing the C5–C6 attachment pairing.

Its historical wider-benchmark geometry improved from 105/189 to 189/189, but its reference-pose sensing quality deteriorated.

**Conclusion:** Pairing, geometric feasibility and sensing sensitivity must be assessed together.

### B5.3 — Twelve-Rail Structured Configurations

B5.3 introduced three structured layout families:

| Family | Description |
|---|---|
| S1 | Structured layered |
| S2 | Distributed |
| S3 | Asymmetric |

Six configurations were generated per family, for 18 configurations in total.

Six configurations passed all 189 Core geometric and rank checks.

### Six Core-Eligible Configurations

| Config | Family | Core Geometry and Rank | Worst-Core \(\sigma_{\min}\) | Min. Ideal Cable Distance |
|---|---|---|---:|---:|
| 2 | S1 | 189/189 | 0.396711 | 4.6508 mm |
| 4 | S1 | 189/189 | 0.202621 | 34.2128 mm |
| 6 | S1 | 189/189 | 0.268443 | 18.1059 mm |
| 8 | S2 | 189/189 | 0.226512 | 9.5408 mm |
| 12 | S2 | 189/189 | 0.366266 | 9.3165 mm |
| 17 | S3 | 189/189 | 0.278687 | 15.2926 mm |

Eligible configuration IDs:

```matlab
eligible_config_ids = [2 4 6 8 12 17];
```

Config 2 was initially selected for detailed optimisation because of its relatively strong worst-Core sensing performance.

It has not been established as globally optimal.

### B5.4 — Initial Pose Estimation

A preliminary nonlinear pose estimator was tested on the six Core-eligible configurations.

Under assumed independent cable-length noise of 0.1 mm standard deviation:

- Total synthetic trials: 2,160.
- Simulated convergence: 2,160/2,160.
- Best observed position RMSE: Config 12, 0.16779 mm.
- Best observed orientation RMSE: Config 2, 0.21444°.

These are simulated results under defined assumptions, not physically calibrated measurements.

---

## 6. Current Preferred Numerical Configuration

### E1a_Robust_Config2_v1

**Origin:** B5.3 Config 2  
**Family:** S1  
**Status:** Preferred numerical reference candidate; not final prototype.

E1a-A optimised only the anchor positions along their existing rails.

The rail identities, attachment coordinates and cable pairing remained fixed.

### Rail Assignment

```matlab
rho = [5 6 7 8 1 4];
```

### Final Rail Parameters

```matlab
t = [ ...
    0.375000 0.446898 0.304465 ...
    0.470000 0.754805 0.314867 ];
```

### Selected Anchor Coordinates

| Cable | Rail | Anchor Coordinates (mm) |
|---|---|---|
| C1 | R5 | `[-35, -150, -160]` |
| C2 | R6 | `[-14.8686, 150, -160]` |
| C3 | R7 | `[-54.7498, -150, 160]` |
| C4 | R8 | `[-8.4, 150, 160]` |
| C5 | R1 | `[-140, -150, 81.5376]` |
| C6 | R4 | `[140, 150, -59.2426]` |

The original B5.3 Config 2 attachment coordinates and pairing must be loaded from the saved MATLAB dataset.

### Current Numerical Evidence

| Indicator | Result |
|---|---:|
| Combined sampled geometric feasibility | 539/539 |
| Full-rank Jacobian | 539/539 |
| Worst scaled \(\sigma_{\min}\) over 539 poses | 0.508750 |
| Minimum ideal cable distance | 6.1055 mm |
| Minimum nominal outward angle | +1.545778° |
| Single-anchor installation perturbation cases | 12/12 |
| Worst perturbed outward angle | +1.1734° |
| Worst perturbed ideal cable distance | 6.0597 mm |

Installation perturbations used the assumed range:

\[
\Delta t_i=\pm0.005
\]

Each anchor was perturbed separately.

### Research Interpretation

The E1a-A study identified and repaired observed C1 and C4 Cable–sphere failures in the sampled development data.

The resulting configuration passed the specified combined 539-pose geometry and rank checks.

However:

- The 539 poses were used during development.
- The installation tests used assumed perturbations.
- Real cable clearance has not been validated.
- Tension feasibility has not been established.
- Experimental sensing accuracy is unknown.
- Only Config 2 has received detailed E1a-A optimisation.

**Decision:** Retain this configuration as a numerical reference for future comparison.

Do not declare it the final Prototype V1.0.

For complete optimisation history, see the E1a Research Log.

---

## 7. Current Scientific Limitations

| Area | Outstanding Limitation |
|---|---|
| Configuration selection | Five other eligible configurations have not received equivalent E1a optimisation |
| Generalisation | Fresh independent holdout poses are needed |
| Workspace | Continuous feasibility is not established |
| Cable geometry | Physical diameter, connectors and guides are not represented |
| Installation | Actual manufacturing and calibration tolerances are unknown |
| Estimation | Simulated estimator performance requires broader validation |
| Measurement | Sensor noise, bias and resolution have not been calibrated |
| Tension | Positive tension and passive-motion disturbance remain unverified |
| Flexible balloon | Deformation and attachment migration are not yet included |
| Cable count | Seven-/eight-cable comparison remains future work |

These limitations should remain visible when discussing sensing performance or prototype readiness.

---

## 8. Next Research Priority

### B5.4 E1a-B — Six-Configuration Fair Comparison

**Status:** Next.

### Main Research Question

> Which of the six Core-eligible configurations performs best after equivalent rail-position optimisation?

### Immediate Task

**E1a-B.1 — Baseline Verification**

1. Load original Configs 2, 4, 6, 8, 12 and 17.
2. Verify their saved rail IDs, rail positions, attachments and pairing.
3. Reproduce the original Core 189-pose screening results.
4. Establish common development and validation protocols.
5. Preserve original configurations as comparison baselines.

### Research Decision Required

Determine which candidates warrant further optimisation using:

- Common geometric criteria.
- Common sensing indicators.
- Equivalent search effort.
- Installation robustness.
- Independent validation.
- Pose-estimation performance.

Detailed E1a-B procedures and completion criteria are maintained in the Active Research Plan.

### Subsequent Research

| Task | Focus |
|---|---|
| E1b | Rail assignment optimisation |
| E2 | Attachment point optimisation |
| E3 | Cable pairing optimisation |
| E4 | Joint configuration optimisation |
| B5.5 | Measurement validation and calibration |
| B5.6 | Prototype engineering and experiments |

---

## 9. Authoritative Repository References

### Current Research Management

- [README.md](README.md) — Project overview.
- [AGENTS2.md](AGENTS2.md) — Stable research and AI working rules.
- [Roadmap.md](08_Project_Management/Roadmap.md) — Long-term milestones.
- [Active Research Plan](08_Project_Management/November/B5_3_B5_6_Active_Research_Plan_Six_Cable_Sensing.md) — Detailed current research tasks.

### Research Evidence

- [B5.1 Candidate Expansion and Pairing](06_Research_Log/2026-11/B5_1_Lesson2_Candidate_Expansion_and_Pairing_2026_11_10.md)
- [B5.2 Multi-Pose Screening](06_Research_Log/2026-11/B5_2_Multi_Pose_Geometric_Screening_2026_11_10.md)
- [B5.3 Twelve-Rail Configuration Research](06_Research_Log/2026-11/B5_3_Twelve_Rail_Structured_Configuration_Research_Log_2026_11_11.md)
- [B5.4 E1a Research Log](06_Research_Log/2026-11/B5_4_E1a_Anchor_Rail_Position_Optimisation_Research_Log_2026_11_12.md)

Source code and numerical datasets are maintained in `03_Simulation/MATLAB/`.

Historical research documents are reference material, not active execution instructions.

---

## 10. Current Research Decision

**Completed:** B5.3 structured configuration screening and B5.4 E1a-A Config 2 optimisation.

**Current numerical reference:** `E1a_Robust_Config2_v1`.

**Next technical priority:** E1a-B fair optimisation of six Core-eligible configurations.

**Not yet established:** Final configuration, continuous workspace feasibility, real cable clearance, physical tension feasibility or experimental sensing accuracy.

The current research direction remains:

**Configuration feasibility → Sensing optimisation → Independent validation → Measurement calibration → Prototype experiments → Cable-number and deformation extensions.**

---

**Guiding Principle:** Keep this document as a concise snapshot of the current research state. Store detailed experimental methods, figures, failures and results in Research Logs, and store future implementation procedures in the Active Research Plan.
