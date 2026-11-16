# B5.4 — E2 Attachment-Only Optimisation: Phase Research Summary

**Status:** E2 development-stage evaluation completed; prototype configuration **not yet selected**.  
**Date:** 2026-11-16  
**System:** Six-cable sensing robot; passive rigid spherical balloon surrogate (550 mL, radius 50.8266 mm) in a 280 × 300 × 320 mm engineering envelope.  
**Scope:** Anchors and cable-to-attachment pairing held fixed within each E2 parent design. Six attachment points are optimised on the balloon sphere.

## 1. Research question and significance

**Question:** Once anchor/rail configurations have been selected, can sphere-constrained attachment point optimisation improve six-DOF pose sensing and nonlinear pose reconstruction without introducing unacceptable cable interference or installation sensitivity?

E1 studied anchor and rail arrangements. E2 isolates the complementary design variable: attachment coordinates on the balloon surface. The system is a **measurement system for passive motion**, not a platform commanded to follow a specified trajectory.

## 2. Parent configurations and lineage

| Parent for E2 | E2 candidate evaluated here | Interpretation |
|---|---|---|
| E1b C2-2 | E2 C2-2 **Repaired M** | High-sensing challenger; C4 repaired on 539 development poses; remains sensitive to C6 attachment perturbation |
| E1b C4-1 | E2 C4-1 **M** | Good sensing and geometric margin, **but inherited rail-end anchor issue remains** |
| E1b C8-16 | E2 C8-16 **M** | Eligible on 539 development poses and prescribed perturbations; lower outward-angle margin than C4/C12 |
| E1a C12 | E2 C12 **M** | Geometry-margin reference; the direct parent is **E1a C12, not E1b C12-40** |

All E2 `r` matrices are **already paired by cable row**. Never reapply the stored historical pairing to them.

## 3. E2 methodology and milestones

1. **Lesson 2.1 — Attachment audit:** verified all four parent layouts have sphere radius errors around 1e-14 mm. Minimum attachment chord distances: C2-2 22.3602 mm; C4-1 34.2128 mm; C8-16 20.2422 mm; C12 18.5075 mm.
2. **Lesson 2.2 — Local sensitivity scan:** 4 designs × 6 cables × 2 angular amplitudes (2°, 5°) × 8 tangent directions = **384 trials**. Full-Core-eligible trials: 61, 80, 74, and 80 respectively. Best single-point Core sigma gains: +0.97%, +3.53%, +4.03%, +8.54%.
3. **Lessons 2.3–2.4 — Pareto diagnosis and protocol:** identified sensing–outward-angle trade-offs. Defined two tracks with identical candidate evaluation budgets: **S (sensing-priority)** and **M (margin-preserving sensing)**. The M constraint preserves the parent minimum outward angle on **Core 189**, not necessarily on the 539 development set.
4. **Lesson 2.5 — Sequential coordinate search:** 4 designs × 2 tracks × 192 trials = **1,536 Core evaluations**. Both tracks improved Core worst scaled sigma in all four design families. Fixed anchors and pairing throughout.
5. **Lesson 2.6 — 539 development-pose check:** C4-1, C8-16, and C12 S/M passed 539/539 with common cable clearance floor 4.650751 mm. Initial C2-2 S/M failed at **Pose 503, Cable 4** (minimum outward angle −0.624377°), with 538/539 geometry pass.
6. **Lesson 2.7 — Attachment perturbations:** 0.5° geodesic displacement (~0.4435 mm arc), four tangent directions, one attachment at a time, 24 cases per eligible design. C4-1/C8-16/C12 E2 S/M passed **24/24** full protocol cases. The original C2-2 baseline passed 19/24, including one geometry failure.
7. **Lessons 2.8–2.9 — Targeted C2-2 repair and verification:** restoring original C4 sufficed to repair 539-pose geometry; a 24-point local C4 scan (0.5°, 1°, 2° × 8 directions) produced better repairs. Repaired M: 539/539 nominal, sigma 0.702000. In an additional 12 anchor ±0.005 (one at a time) and 24 attachment ±0.5° test, repaired M passed **12/12 anchor** and **23/24 attachment** full-protocol cases. Failure: C6 attachment β=0°, Pose 48, min angle −0.069352°. Repaired S likewise 23/24, min −0.256597°.
8. **Lesson 2.10 — Matched nonlinear pose estimation:** four baseline/E2 pairs, 36 sampled development poses × 20 independent noise repeats × 8 layouts = **5,760 solver runs**; simulated independent length noise SD 0.100 mm; all solver runs met residual termination criteria.

## 4. Unified E2 results — comparison against matched parent

All sigma values below are **worst scaled sigma_min over the 539 development poses**, not experimental sensor resolution. The C2-2 value is for the **post-repair M** design, not the failed original sequential solution.

| Design lineage | Parent sigma | Final E2 sigma | Improvement in sigma | Parent min outward angle | Final min outward angle | Parent / E2 attachment full-protocol pass |
|---|---:|---:|---:|---:|---:|---|
| C2-2 → Repaired M | 0.617496 | 0.702000 | +13.68% | 0.34953° | 0.42536° | 19/24 → **23/24** |
| C4-1 → E2 M | 0.507186 | 0.582702 | +14.89% | 13.07488° | 13.76062° | 20/24 → **24/24** |
| C8-16 → E2 M | 0.472139 | 0.569039 | +20.52% | 0.40050° | 0.857998° | 20/24 → **24/24** |
| C12 → E2 M | 0.437554 | 0.505817 | +15.60% | 15.89779° | 16.38486° | 20/24 → **24/24** |

**Caveat:** Full-protocol tests combine actual cable geometry/rank/clearance with the conservative *no-decrease-below-original-minimum-attachment-chord* rule; this spacing threshold is not a validated connector envelope. All 24 perturbations are **one attachment at a time**; 24/24 is not a probability of failure-free installation.

### 4.1 Cable geometry and installation limitations

| Final E2 M layout | 539 pose geometry | Nominal min cable distance | Worst outward angle under prescribed attachment perturbations | Important limitation |
|---|---|---:|---:|---|
| C2-2 Repaired M | 539/539 | 5.2958 mm | **−0.06935°** (failed C6 perturbation) | Small cable clearance margin; failed 1/24 attachment perturbations |
| C4-1 M | 539/539 | 39.0163 mm | +13.30279° | Some anchors on rail endpoints (previous anchor ±0.005 test had off-rail outcome); not resolved by E2 |
| C8-16 M | 539/539 | 16.0627 mm | +0.48817° | Relatively small outward-angle margin |
| C12 M | 539/539 | 13.5666 mm | +15.93472° | Sensing lower than C2/C4/C8; maintain as high-margin reference |

The floor **4.650751 mm** is a shared numerical comparison rule, **not an empirically validated safe cable/connector clearance**.

## 5. Matched nonlinear 6-DOF pose estimation

Evaluation setup: 12 Core + 12 Off-grid A + 12 Off-grid B development poses; 20 repeats per pose; six independent simulated cable length errors with SD 0.100 mm; identical noise vectors, initial pose, and damped Gauss–Newton settings across corresponding comparisons. **Total 5,760 runs; 5,760 residual-converged.** Six measurements for six unknowns can yield near-zero length residual without guaranteeing correct pose, so report pose errors separately.

| Design | Parent position RMSE (mm) | Final E2 position RMSE (mm) | Relative reduction | Parent orientation RMSE (°) | Final E2 orientation RMSE (°) | Relative reduction |
|---|---:|---:|---:|---:|---:|---:|
| C2-2 | 0.15628 | **0.15268** | **2.31%** | 0.19240 | **0.18153** | **5.65%** |
| C4-1 | 0.15913 | **0.15348** | **3.55%** | 0.22652 | **0.21433** | **5.38%** |
| C8-16 | 0.16723 | **0.15813** | **5.44%** | 0.23001 | **0.20998** | **8.71%** |
| C12 | 0.16864 | **0.16120** | **4.41%** | 0.24213 | **0.21895** | **9.57%** |

In this sampled development-pose simulation, all four E2 designs showed lower position and orientation RMSE than their matched parents. These are **observed differences** only: no confidence interval, independent holdout, calibration bias, physical sensor model, multi-start/global pose ambiguity analysis, or bench validation was performed.

## 6. Interpretation — what E2 established and what it did not

**Supported:**

- Surface attachment geometry is an independent and consequential sensing design variable even when anchor locations and pairing are fixed.
- Sequential sphere-constrained attachment optimisation improved worst-case Jacobian sensitivity in all four parent families on Core 189; selected/ repaired solutions retained those benefits on the tested 539 development poses.
- The matched nonlinear inverse-pose simulation provided corroborating evidence of reduced error, rather than relying solely on Jacobian sensitivity.
- Preserving outward angle on Core alone was **not sufficient** to protect all 539 poses (C2-2 Pose 503). A subsequent targeted repair recovered nominal feasibility, but residual attachment-placement sensitivity remained.

**Not yet established:**

- Global optimum / exhaustive configuration coverage.
- Continuous clinically representative stomach-motion workspace or a genuinely independent out-of-sample pose set; the 539 poses were used for development and repair.
- Real safe clearance or connector spacing from physical dimensions.
- Robustness to **simultaneous** anchor/attachment perturbations, manufacturing tolerances, cable routing, elasticity, tension, encoder quantisation, systematic length bias, calibration error and noise correlation.
- Actual hardware pose estimation accuracy or unique pose recovery over a larger state domain.

## 7. E2 candidate disposition — freeze for next-stage discussion

- **C4-1 E2 M:** retained as strong high-margin/high-sensing candidate, **subject to rail-end installation redesign or explicit mechanical justification**.
- **C8-16 E2 M:** retained as alternative with 24/24 specified attachment tests, but outward-angle margin remains relatively small.
- **C12 E2 M:** retained as a geometry-margin reference with 24/24 specified attachment tests.
- **C2-2 Repaired M:** retained as highest-sigma and lowest matched-RMSE **challenger**, but does **not** meet strict 24/24 attachment perturbation criterion; require further robustness evidence or a design-specific repair before prototype adoption.

**No single final prototype configuration is declared yet.** A sensible next step is to freeze and archive the exact coordinate matrices (A, paired r, rail IDs, t) and corresponding figure/CSV links, then discuss E3 pairing optimisation eligibility and an independent validation protocol.

## 8. Three-stage geometry figures for research traceability

- C2: Original C2 → E1b C2-2 (anchor-only) → E2 C2-2 Repaired M (attachment-only).
- C4: Original C4 → E1b C4-1 (anchor-only) → E2 C4-1 M (attachment-only).
- C8: Original C8 → E1b C8-16 (anchor-only) → E2 C8-16 M (attachment-only).
- C12: Original C12 → **E1a C12** (anchor-only) → E2 C12 M (attachment-only). **Do not substitute C12-40**, which is a different E1b branch.

For each 3D figure, show the same engineering reference pose P=[0,0,0], R=I, the frame rails, all six cables, and row-consistent anchors A1–A6 / attachments B1–B6. Keep the three axes independently rotatable and prevent plot-box/title overlaps.

## 9. English presentation-ready takeaway

> **E2 demonstrated that sphere-constrained attachment-point optimisation can improve six-cable pose-sensing geometry while holding anchor positions and cable pairing fixed.** Across four matched designs, the final E2 candidates improved the worst scaled Jacobian singular value by approximately 13.7–20.5% over 539 tested development poses. Under an idealised 0.1-mm cable-length noise model, nonlinear pose-estimation position RMSE decreased by 2.3–5.4% and orientation RMSE by 5.4–9.6%. Robustness was configuration-dependent: C4-1 M, C8-16 M and C12 M passed all 24 prescribed one-at-a-time attachment perturbations, whereas the higher-sensing C2-2 Repaired M still failed one C6 perturbation. These findings are simulation-stage evidence, not a proof of hardware accuracy or continuous-workspace feasibility.

## 10. Required artifacts / source files

- `B5_4_E2_attachment_baselines.mat`
- `B5_4_E2_attachment_local_sensitivity.mat`
- `B5_4_E2_attachment_pareto_diagnosis.mat`
- `B5_4_E2_optimisation_protocol.mat`
- `B5_4_E2_sequential_optimisation.mat`
- `B5_4_E2_539pose_verification.mat`
- `B5_4_E2_attachment_installation_robustness.mat`
- `B5_4_E2_C2_C4_targeted_repair.mat`
- `B5_4_E2_C2_repaired_robustness.mat`
- `B5_4_E2_matched_pose_estimation.mat`
- Four three-stage 3D interactive visualisation scripts/figures and output CSV tables.

---

**Next gate:** E3 Pairing Optimisation — **not started**. Discuss its parent set, pairing representation (do not mutate stored paired rows by accident), evaluation budget, development/holdout separation, hard geometry/installation constraints, and stopping rule *after accepting this E2 record*.
