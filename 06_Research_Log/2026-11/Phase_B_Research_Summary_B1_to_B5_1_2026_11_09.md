# Phase B Research Summary — B1 to B5.1

**Updated:** 2026-11-09  
**Research stream:** Six-cable prototype for passive balloon pose sensing  
**Status:** B1–B4 methods established; B5.1 candidate generation and reference-pose screening completed; B5.2 multi-pose screening pending  
**Purpose:** Single handoff record of completed work, measured results, limitations, and their implications for the next stage.

---

## 1. Research question and scope

**Main question:** Can changes in the lengths of six low-tension cables be used to estimate the six-degree-of-freedom (6-DOF) pose of a passively moving balloon-like object?

- The balloon is **passively moved** by its environment; the cables are intended primarily for **measurement**, not motion control.
- The initial model is a **rigid sphere**; deformable-balloon reconstruction is a later stage.
- Pose: \(q=[x,y,z,\theta_x,\theta_y,\theta_z]^T\).
- The current workspace is a **simplified engineering boundary**, not a clinically measured complete gastric workspace.
- Prototype, sensing-noise, low-positive-tension, hardware dimensions, and actual pose-estimation accuracy are **not yet experimentally verified**.

**Reference geometry**

| Parameter | Value | Status |
|---|---:|---|
| Engineering boundary, X × Y × Z | 280 × 300 × 320 mm | Working B1 geometry |
| Axis convention | X = length; Y = width; Z = height | Fixed |
| Nominal balloon volume | 550 mL | Design assumption |
| Balloon radius | 50.8266 mm | B1 model |
| Number of cables | 6 | Current prototype stream |
| Reference pose | \(P=[0,0,0]\), \(R=I\) | Used for local comparisons |

**Measurement model**

\[
B_i=P+Rr_i,\qquad D_i=A_i-B_i,\qquad L_i=\|D_i\|.
\]

\[
\delta L\approx H\delta q,\qquad
H_i=\begin{bmatrix}-u_i^T&(u_i\times Rr_i)^T\end{bmatrix},
\qquad u_i=D_i/\|D_i\|.
\]

Use the **same B4 characteristic-length scaling** for all configuration comparisons:

\[
H_s=H\operatorname{diag}(1,1,1,1/r_b,1/r_b,1/r_b).
\]

The sign convention must stay consistent across programs. Geometry, Jacobian, and noise results must not be compared across different conventions or pose sets without an explicit conversion.

---

## 2. Completion list — B1 to B4

| Stage | What was completed | Verified result / evidence | Guidance for subsequent research |
|---|---|---|---|
| B1 — Geometry | Simplified box/sphere model; candidate anchors and attachments | 26 unique anchors and 40 sphere attachments; spherical radius check passed | Keep geometry fixed for controlled comparison; later check physical mounting |
| B2.1 — Baseline | Symmetric six-anchor baseline and Jacobian | Scaled \(\sigma_{\min}=0.004393\); \(\kappa=490.956\) | Simple symmetric layout does **not** guarantee robust 6-DOF sensing |
| B2.2 — Search | Experiment A: variable attachments; B: variable anchors + attachments | B reference pose: \(\sigma_{\min}=0.533600\); \(\kappa=3.2365\) | Keep B as the reference-pose sensing baseline |
| B3.1 — Cable lengths | 27 translations | A range 39.173–215.857 mm; B 92.332–322.392 mm | Cable stroke, sensor range, and compact packaging need future checks |
| B3.2 — Geometric poses | 27 positions × 7 single-axis rotation cases = 189 benchmark poses | A: 40/189 geometry feasible; B: 105/189 | Reference-pose quality is insufficient to establish usable workspace |
| B4.1 — Jacobian method | Analytic/numerical Jacobian agreement; rank, singular values, conditioning, assumed noise propagation | Errors ~\(10^{-8}\); B common-pose performance generally better than A | Reuse validated sensing analysis on identical pose sets |

**B4.1 note:** The earlier 0.1 mm noise standard deviation was a **simulation assumption**, not measured sensor noise. Local Jacobian rank and noise propagation do not establish global uniqueness or experimentally achieved pose-reconstruction accuracy.

---

## 3. B5.1 Lesson 1 — Existing configuration audit (2026-11-09)

### 3.1 B versus Modified B′

B′ keeps the same anchor and attachment **point sets** as B and swaps only the pairing of Cable 5 and Cable 6:

\[
C'_5=(A_5,r_6),\qquad C'_6=(A_6,r_5).
\]

| Metric | Original B | Modified B′ | Scope |
|---|---:|---:|---|
| Reference \(\sigma_{\min}\) | 0.533600 | 0.075854 | Reference pose |
| Reference \(\kappa\) | 3.2365 | 23.575 | Reference pose |
| Minimum anchor spacing | 140.0000 mm | 140.0000 mm | Same point set |
| Minimum attachment spacing | 35.9399 mm | 35.9399 mm | Same point set |
| Maximum cable direction similarity | 0.824441 | 0.875150 | Reference pose |
| Geometry-passing poses | 105/189 | 189/189 | **Original wide benchmark** |
| Worst \(\kappa\) | ~11.39 | ~67,070 | **Original wide benchmark** |

**Finding:** A pairing change can remove idealized geometric interference at tested poses yet severely degrade sensing. B′ is a **valuable controlled comparison**, not a final recommended design. The wide-benchmark numbers must not be reported as results for the newer Core Workspace.

### 3.2 Anchor and direction audit

Original B anchors (mm):

| Cable | Anchor X | Anchor Y | Anchor Z |
|---|---:|---:|---:|
| 1 | 140 | 0 | -160 |
| 2 | 140 | 150 | 160 |
| 3 | 140 | -150 | 160 |
| 4 | 0 | -150 | 160 |
| 5 | -140 | 150 | 160 |
| 6 | 0 | 150 | 160 |

Five of the six anchors lie on **+Z** (some are shared edges/corners). This is a motivation to test alternative anchor families, **not** evidence by itself of low sensing quality.

### 3.3 Core Workspace set up

- **Core positions:** \(x,y,z\in\{-20,0,20\}\) mm = 27 centres.
- **Core orientations:** identity plus single-axis roll/pitch/yaw ±5° = 7 cases.
- **Total sampled Core poses:** \(27\times7=189\).
- **Containment:** 27/27 sampled centres fit the simplified rigid spherical balloon inside the box; generation and uniqueness assertions passed.
- **Original benchmark retained:** \(x,y,z\in\{-50,0,50\}\) mm with identity and single-axis ±10° = 189 sampled poses.

**Important:** The Core extent is a provisional experimental engineering choice, **not clinical evidence**. Core 189-pose cable–sphere, cable–cable, and sensing checks are **still pending**. The sampled pose set does not establish continuous workspace feasibility.

### 3.4 Acceptance criteria established

1. **Hard geometric constraints:** balloon containment; no unacceptable cable–sphere penetration; cable–cable physical clearance when cable diameter is known.
2. **Hard sensing constraint:** full local Jacobian rank at required poses.
3. **Primary sensing objectives:** improve worst-case scaled \(\sigma_{\min}\), limit worst-case scaled \(\kappa\), and ultimately check pose estimation under noise.
4. **Engineering / auxiliary metrics:** anchor spacing; attachment spacing; max direction similarity; face distribution; cable stroke; mounting accessibility.

Thresholds for physical cable clearance, connectors, and acceptable measurement error are **not calibrated yet**. Avoid treating visual crossing in a 2-D projection as 3-D physical contact.

---

## 4. B5.1 Lesson 2 — Candidate region expansion and configuration families

### 4.1 Candidate sets — verified MATLAB output

| Item | Old | Expanded | Verification |
|---|---:|---:|---|
| Anchor candidates | 26 | 98 | 5×5 per face, 98 unique surface points, original 26 included |
| Attachment candidates | 40 | 100 | Fibonacci sphere, max radial error \(1.421\times10^{-14}\) mm |
| Attachment-candidate minimum pairwise distance | 19.4505 mm | 15.7073 mm | Smaller due to higher density; **not** worse by itself |

The 100-point Fibonacci set is not guaranteed to include the exact original 40 attachments. Store both sets independently for controlled experiments.

### 4.2 Three representative families (only one random anchor set per family)

| Family | Face allocation | Minimum anchor spacing (mm) |
|---|---|---:|
| F1 — Six-Face Distributed | +X, −X, +Y, −Y, +Z, −Z | 102.5914 |
| F2 — Opposite / Layered | +Z×2, −Z×2, +X, −X | 130.0961 |
| F3 — Asymmetric | +Z×3, +Y×2, −X | 70.0000 |

Candidate positions were selected by a fixed-seed reproducible process. These are **representative instances**, not optimized family-wide designs. Neither uniformity nor minimum spacing establishes high sensing quality.

### 4.3 Initial six-cable sensing (reference pose)

| Family | Initial \(\sigma_{\min}\) | Initial \(\kappa\) |
|---|---:|---:|
| F1 | 0.039051 | 60.825515 |
| F2 | 0.165045 | 12.761140 |
| F3 | 0.375288 | 5.416895 |

**Finding:** Six-face coverage alone does not guarantee good sensing; F1's poor initial result could be caused by its specific attachment selection/pairing, not necessarily the F1 family itself.

### 4.4 Geometry-constrained 720-pairing enumeration (reference pose)

Each family held its six anchors and six attachment locations fixed; only the one-to-one pairing was changed. For each of the 720 permutations, the script checked idealized cable–sphere outward routing, ideal zero-thickness cable–cable contact (15 segment pairs), and Jacobian rank; it then selected the feasible permutation maximizing scaled \(\sigma_{\min}\).

| Metric | F1 | F2 | F3 |
|---|---:|---:|---:|
| Total permutations | 720 | 720 | 720 |
| Sphere passing | 8 | 2 | 14 |
| Full geometry passing | 8 | 2 | 14 |
| Full-rank geometry passing | 8 | 2 | 14 |
| Best pairing (original attachment indices) | 4 3 2 6 5 1 | 1 2 3 4 5 6 | 1 2 3 4 5 6 |
| Best \(\sigma_{\min}\) | 0.153511 | 0.165045 | 0.375288 |
| Best \(\kappa\) | 15.130220 | 12.761140 | 5.416895 |
| Best-pairing min cable–cable distance | 8.004738 mm | 47.987403 mm | 23.299113 mm |

**Findings:**

- F1 improved in reference-pose \(\sigma_{\min}\) by ~3.93× through pairing alone (0.039051 → 0.153511).
- F2 and F3 selected the original [1,2,3,4,5,6] pairing under this specific objective and geometry test.
- At the reference pose, the cable–cable zero-thickness test rejected **no additional** permutation beyond the sphere-outward check, for these particular candidate sets.
- F3 has the best **reference-pose** sensing among the three family examples; Original B still has a higher reference-pose \(\sigma_{\min}\).
- The final F1/F2/F3 paired configurations were visualized with A1–A6 anchors, B1–B6 actual attachment endpoints, C1–C6 cables, and original r-index mapping.

**Limitations:** All pairing results above are **reference pose only**. The clearance is ideal-segment distance, not physical cable safety clearance. A zero-thickness model and numerical contact threshold (\(10^{-6}\) mm) cannot establish real hardware feasibility. The fact that 8/2/14 pairings passed at a single pose is **not** a multi-pose workspace coverage measure.

---

## 5. Central research conclusions

1. The key outcome so far is a **reproducible evaluation workflow**, not a final six-cable layout.
2. **Anchor placement, attachment placement, and pairing** must be considered together; a change in pairing changes both translational and rotational length sensitivity.
3. **Sensing and geometry can conflict.** High performance at one pose is not proof of reliable sensing over motion.
4. **Distributing points evenly is a design hypothesis, not an optimality theorem.** Face coverage and direction diversity are useful design features, but not substitutes for Jacobian evaluation.
5. Early optimization of a **complete six-cable configuration** should include geometry and sensing; isolated candidate-point generation does not define a 6×6 Jacobian.
6. Structured design families should be investigated using research literature, while retaining B and B′ as controlled reference cases.
7. **All five configurations need the same Core Workspace test before any final redesign decisions.**

---

## 6. Open issues and next-stage implications

| Open issue | What to test / decide next | Planned stage |
|---|---|---|
| Do current configurations survive Core motion? | Same 189 Core poses for B, B′, F1–F3 | B5.2 |
| Which cable or cable pair fails first? | Per-cable sphere checks, per-pair segment distances, worst pose | B5.2 |
| Are current F1/F2/F3 geometry families inherently weak? | Multiple family samples and literature-informed structures | B5.3 |
| How to jointly choose \(A_i,r_i,\pi\)? | Constrained multi-pose optimization with consistent scaling | B5.4 |
| Can lengths recover unknown pose? | Nonlinear estimation, noise studies, held-out poses | B5.5 |
| Is the design physically implementable? | Cable thickness, connector clearance, cable stroke, low-tension effects | B5.6 / existing B6 and hardware stream |

**Do not call any configuration “final” or “globally optimal” yet.** The current results do not include Core multi-pose geometry, continuous motion, calibrated sensing noise, real tension feasibility, or hardware validation.

---

## 7. Files and session handoff

**Known/generated inputs:**

- `B2_experiment_B_results.mat` — Experiment B baseline.
- `B5_1_anchor_candidates.mat` — A26, A98.
- `B5_1_attachment_candidates.mat` — original 40 and Fibonacci 100.
- `B5_1_configuration_families.mat` — F1/F2/F3 anchors.
- `B5_1_initial_6cable_configurations.mat` — initial complete layouts.
- `B5_1_geometry_constrained_pairing.mat` — reference-pose best pairings, metrics, summary.
- `B5_1_best_pairing_comparison.png` — visualized best pairings.
- Existing B3 finite-segment minimum-distance function; B4 Jacobian method.

**Source of numbers:** User-run MATLAB outputs in the B1–B5.1 research sessions, including the latest pairing results. Numbers have not been replaced with inferred or literature-derived values.

**Next action:** Run **B5.2 Lesson 1**, holding five configurations fixed and screening the same 189 Core poses. Preserve B/B′ as baselines and F1/F2/F3 as provisional candidates; **do not refine their geometry before this comparison**.

---

## 8. Literature grounding (not a claim of reproduced numerical results)

- Cheng, H. H., & Lau, D. (2023). *Cable Attachment Optimization for Reconfigurable Cable-Driven Parallel Robots Based on Various Workspace Conditions*. IEEE Transactions on Robotics, 39(5), 3759–3775. DOI: https://doi.org/10.1109/TRO.2023.3288838
- Cheng, H. H., & Lau, D. (2022). *Ray-based cable and obstacle interference-free workspace for cable-driven parallel robots*. Mechanism and Machine Theory, 172, 104782. DOI: https://doi.org/10.1016/j.mechmachtheory.2022.104782
- Abbasnejad, G., & Tale-Masouleh, M. (2021). *Optimal wrench-closure configuration of spatial reconfigurable cable-driven parallel robots*. Proceedings of the Institution of Mechanical Engineers, Part C. DOI: https://doi.org/10.1177/0954406220976166
- Khoshbin, E., Youssef, K., Meziane, R., & Otis, M. J.-D. (2022). *Reconfigurable fully constrained cable-driven parallel mechanism for avoiding collision between cables with human*. Robotica, 40(12), 4405–4430. DOI: https://doi.org/10.1017/S0263574722000996

These papers concern predominantly **actuation, wrench feasibility, collision avoidance, and reconfigurable geometry**. Their techniques inform the project; their objective functions and configuration figures are **not** proof of optimal performance for passive balloon sensing.
