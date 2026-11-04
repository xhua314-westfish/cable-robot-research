# October–November Research TODO — Prototype-First Roadmap

**Last updated:** 2026-11-04  
**Research phase:** Phase B — Balloon-Specific Cable Sensing Design  
**Current task:** B5.1 — Configuration Audit and Prototype-Oriented Design-Space Expansion  
**Working pace:** approximately 4–5 hours per research day  
**Priority:** Select a practical adjustable six-cable prototype (V1.0), begin engineering sizing and experiments, then refine using measured data.

---

## 1. Research Objective and Decision

**Long-term question:** Can cable-length measurements estimate rigid-body motion and eventually deformation/shape of a passively moving balloon, without prescribing its trajectory?

**Near-term question:** Can we select a reproducible, interference-aware six-cable configuration sufficient to design an adjustable experiment, without waiting for proof of global optimality or complete soft-body shape reconstruction?

**Approved research sequence:**

**B5 — Rapid Configuration Selection → B5.5 — Rigid-to-Flexible Compatibility Gate → B6 — Engineering Sizing → B7 — Adjustable Prototype → B8 — Rigid/Flexible Experiments → B9 — Data-Driven Refinement.**

B4.2 (nonlinear forward kinematics and Monte Carlo validation) is a **parallel validation task**, not a prerequisite for starting preliminary frame design; it **must** be completed before making quantified pose-accuracy claims.

**Principles:** (1) sensing rather than trajectory control; (2) low-tension passive-motion tracking; (3) preserve mechanical adjustability; (4) distinguish geometric, sensing and static/tension feasibility; (5) record assumed versus measured quantities; (6) defer seven/eight cables unless an identified observability or mechanical requirement justifies them.

## 2. Engineering Baseline and Established Results

| Item | Baseline / status |
|---|---|
| Engineering box | X = 280 mm (length), Y = 300 mm (width), Z = 320 mm (height); **not** a clinically validated gastric boundary |
| Balloon | 550 mL rigid sphere for initial simulation; radius approximately 50.83 mm |
| Cable number | Six; world-fixed anchors, balloon-body attachment coordinates |
| Candidate regions | Six box faces; initial 26 anchors from 3×3 face sampling; 40 spherical attachments from latitude/longitude sampling |
| Comparison baselines | Experiment A: six face-centre anchors + optimised attachments; Experiment B: jointly random-selected anchors and attachments |
| Initial search limitation | 20,000 random trials per experiment; single reference pose, condition-number objective; no global-optimality evidence |
| Geometry test | 27 centre positions × 7 single-axis orientations = 189 discrete poses; ideal straight, zero-thickness cables |
| B3 geometry pass | A: 40/189; B: 105/189 |
| Dominant failures | A: cable–sphere; B: cable pair 5–6 contact (81 sampled poses) |
| B4.1 sensing | Completed: analytical/numerical Jacobian, SVD, worst directions, covariance, paired comparisons and figures |
| B4.1 median predicted position uncertainty | A: 0.3860 mm; B: 0.1657 mm on **their respective feasible subsets**, with assumed independent cable-length noise SD = 0.1 mm |
| B4.1 shared feasible poses | 19; B lower predicted position uncertainty in 19/19, orientation uncertainty in 18/19 |

**Interpretation:** B is a stronger existing *sensing baseline*, not a prototype-ready final geometry. Its zero-rotation cable-pair collision must be addressed. None of these results establishes continuous workspace coverage, practical clearance, actual sensor accuracy or positive-tension equilibrium.

**Completed milestones:** Phase A methods; B1 geometry; B2 A/B search; B3.1–B3.2; B4.1 Lessons 1–4 and Lesson 5 synthesis/figures (final integrated-script assertions awaiting the latest Command Window log).  
**Open:** B4.2 nonlinear estimation, physical system assumptions, candidate optimisation, flexible adaptation, hardware sizing.

---

## 3. B5 — Rapid Six-Cable Prototype Configuration Selection

**Goal:** Freeze an **adjustable Prototype Configuration V1.0**: six anchor coordinates, six attachment coordinates and correspondence, a declared initial test-pose envelope, predicted cable lengths/strokes and recorded limitations. Do **not** require global optimum or 189/189 coverage; do require interference-free **declared core test poses**, a mechanically implementable mounting concept and acceptable, explicitly reported sensing indicators.

### B5.1 — Audit Existing Layout and Expand the Candidate Space

**Question:** Are the 26/40 candidates and random pairing obscuring practical layouts?

- [ ] Print exact 6×3 anchor/attachment coordinates and pairing for A and B; identify faces, clustering, minimum point separation, cable directions and mechanical mounting access.
- [ ] Keep A/B only as **comparison baselines**, not centres of compulsory local optimisation.
- [ ] Compare original 26 face candidates with a denser 5×5 surface grid (98 unique points for the current cuboid); allow continuous face-local adjustment *later*.
- [ ] Compare original 40 latitude/longitude attachment points with a near-uniform Fibonacci-sphere sample (e.g. 80–120 trial points). These sample counts are **proposed engineering choices**, not paper-prescribed optima.
- [ ] Treat cable-to-attachment pairing as an explicit design variable. Require distinct points and leave hardware-size-based minimum separation as a parameter.
- [ ] Sample several layout families: six-face-distributed, layered/opposite-face and asymmetric; preserve multiple families during screening.

**Theory:** \(\mathcal C=\{(A_i,r_i)\}_{i=1}^{6}\), \(A_i\in\Omega_A\), \(\|r_i\|=r_b\), optional spacing \(\|r_i-r_j\|\ge d_{r,\min}\). The pairing permutation changes cable segments and Jacobian even if the two point sets stay unchanged.

**Literature:** [R1] reconfigurable attachment optimisation and workspace constraints; [R3] Fibonacci spherical sampling (numerical distribution argument, **not** proof of better sensing); [R9] manufacturable sensing-layout optimisation (methodological analogy, different sensor technology).

**Deliverables:** configuration audit table/figure; expanded candidate `.mat`; search-family definition; random seeds.  
**Acceptance:** candidate locations and pairing reproducible; A/B baseline coordinates untouched.

### B5.2 — Fast Multi-Pose Geometry and Routing Screening

**Question:** Can a configuration operate through a specified *core* experimental pose set without passing through the balloon or contacting another cable?

- [ ] Define **core experiment poses** (required) and **expanded 189-pose comparison set** (benchmark); explicitly report performance on both, not only poses already feasible for B.
- [ ] Reuse verified B3 cable–sphere and segment–segment tests to reject obviously invalid layouts early.
- [ ] Report every failure mode separately; prioritise non-contact at the zero-rotation reference and nearby passive-motion poses.
- [ ] Add cable radius, attachment hardware envelope and clearance allowance as **parametric** inputs; do not equate numerical intersection tolerance with physical clearance.
- [ ] Keep cable routing and attachment-point mounting physically accessible; avoid ambiguous endpoint/contact rules.

**Theory:** \(B_i(q)=P+Rr_i\), \(C_i(q)=\overline{B_i(q)A_i}\); clearance for two non-connecting cables requires \(d(C_i,C_j)>\tfrac12 d_i+\tfrac12 d_j+c_{\mathrm{safety}}\) when diameters and clearance are specified. Check segment/deformed-surface intersection separately.

**Literature:** [R2] cable–cable/cable–obstacle interference-free workspace analysis; [R1] interference-free inequalities under different workspace conditions.

**Deliverables:** pose-wise feasibility masks, minimum separations, failure table, shortlist.  
**Acceptance:** no known cable penetration/contact in the *declared* core test poses under the current geometric model; unresolved hardware clearances explicitly flagged.

### B5.3 — Multi-Pose Local Sensing Evaluation

**Question:** Which geometrically admissible layouts avoid poorly identifiable motion directions?

- [ ] Compute the 6×6 measurement Jacobian and characteristic-length-scaled \(H_s\) at the *same* poses for every configuration.
- [ ] Record rank, worst feasible \(\sigma_{\min}(H_s)\), condition number, predicted position/orientation covariance; identify weak modes.
- [ ] Compare configurations on fixed test-set coverage; do not reward a layout for excluding difficult poses.
- [ ] Use \(\sigma_{\min}\) and predicted pose uncertainty as key sensing diagnostics; retain \(\kappa\) as a supplementary conditioning metric.
- [ ] Report noise sensitivity under *assumed* \(\sigma_L\), never label it calibrated accuracy.

**Theory:** \(\delta L\simeq H_s\delta q_s\); \(\Sigma_{q_s}\simeq(H_s^T\Sigma_L^{-1}H_s)^{-1}\) where full rank and the linear-noise assumptions hold; \(\lambda_{\min}(H_s^TH_s)=\sigma_{\min}(H_s)^2\) links worst-direction sensitivity to Fisher information.

**Literature/theory:** standard Jacobian/SVD/least-squares covariance theory; [R4] CDPR workspace and performance review; existing Phase A4 and B4.1 verified derivations. This is a **mathematical basis**, not a claimed experimental result of [R4].

**Deliverables:** candidate ranking and sensing statistics; poor-pose table.  
**Acceptance:** common conventions, units, pose set and noise assumptions for all candidates.

### B5.4 — Bounded Search, Shortlist and Local Adjustment

**Question:** Can we obtain an implementable layout quickly without overfitting to Experiment B?

- [ ] Use a reproducible **multi-family, staged random/discrete search**: inexpensive configuration checks → reduced-pose geometry screen → full 189-pose screen → sensing diagnostics.
- [ ] Keep multiple non-dominated or structurally distinct candidates; refine only the promising candidates by local face/attachment displacement or pairing changes.
- [ ] Rank first by satisfying *all required core poses*, then consider expanded-set coverage, worst-direction sensitivity, uncertainty, assembly complexity and adjustability.
- [ ] Log search budget, random seed, candidate history and rejected designs. Do not claim global optimality.
- [ ] Prefer a feasible, maintainable arrangement over a tiny condition-number improvement with cable collisions.

**Basis:** constrained design-space search and multi-criteria engineering selection; [R1] optimisation under workspace/IFC constraints. The particular search sequence and ranking policy are **project decisions**, not an algorithm directly prescribed by [R1].

**Deliverables:** candidate ranking `.csv`, search `.mat`, comparison figures, shortlist of 2–3 configurations.

### B5.4b — Freeze Prototype Configuration V1.0 (Rigid Reference)

- [ ] Select one six-cable arrangement for initial prototype design; keep up to two backups.
- [ ] Save exact \(A_{V1}\in\mathbb R^{6\times3}\), \(r_{V1}\in\mathbb R^{6\times3}\), pairing, frame coordinates and reference pose.
- [ ] Report core-pose clearance, expanded-set geometry pass, Jacobian properties, covariance under specified noise and known failure modes.
- [ ] Calculate nominal cable segment lengths and preliminary min/max length across *specified poses*, not an unsupported continuous-range claim.
- [ ] Define adjustment slots, replaceable attachments and unused mounting channels for possible future 7/8-cable studies.
- [ ] Mark **V1.0 provisional for flexible adaptation and engineering loads**; do not purchase final motors solely from rigid-only data.

**Decision gate:** A clearly documented, buildable **rigid V1.0** with verified numerical core-pose behaviour. Full shape observability and global optimality are **not prerequisites** for proceeding.

---

## 4. B5.5 — Rigid-to-Flexible Balloon Compatibility Gate (NEW)

**Goal:** Determine whether rigid V1.0 can be carried into the flexible-balloon prototype, with particular attention to attachment migration, material loading, interference and identifiability. This is a **limited pre-sizing design gate**, not a complete soft-body FEM or shape-reconstruction project.

### B5.5.1 — Select a Minimal Flexible-Balloon Model and Assumptions

**Question:** Which deformation modes are sufficient to test whether the cable configuration needs redesign?

- [ ] State physical assumptions: balloon wall material, shell thickness, inflation/pressure state, approximate volume behaviour, small/moderate shape changes, and whether deformation is prescribed or force-derived; mark unknown values.
- [ ] Start with a **kinematic affine/ellipsoidal test model**: \(x_b(X,\eta)=F(\eta)X\), \(F=\mathrm{diag}(\lambda_x,\lambda_y,\lambda_z)\); \(r_i(\eta)=Fr_{i0}\). Treat this as a simple *screening surrogate*, **not** a validated balloon constitutive law.
- [ ] When approximately constant enclosed volume is justified, use \(\det F=\lambda_x\lambda_y\lambda_z\approx1\); otherwise allow volume changes and document pressure/volume assumptions.
- [ ] Define a small, labelled parameter sweep (e.g. chosen stretch ranges) as an **illustrative test** until material tests establish realistic bounds.
- [ ] If the simple model cannot explain physical behaviour, identify later shell/membrane material models and pressure-loaded finite-element analysis; do not implement complex FEM before the compatibility gate unless required.

**Core formula:**

\[
B_i=P+R\,F(\eta)r_{i0},\qquad L_i=\|A_i-B_i\|.
\]

**Literature:** [R5] *Gent models for the inflation of spherical balloons* (nonlinear rubber spherical thin-shell inflation; directly relevant mechanical modelling, but **not** a derivation of our affine ellipsoid); [R6] *Model-Based 3D Shape Reconstruction of Soft Robots via Distributed Strain Sensing* (model-constrained shape estimation, different soft body/sensors). Use [R5] for membrane-law upgrade, [R6] for reduced-model/measurement-plus-mechanics motivation.

**Output:** one-page model assumption sheet; \(F(\eta)\) MATLAB function; deformation sweep; clearly labelled unknown material parameters.  
**Acceptance:** model versus physical evidence explicitly distinguished; volume condition and attachment-material mapping stated.

### B5.5.2 — Attachment Migration and Local Load Compatibility

**Question:** How far do attachment sites move and does cable pretension significantly distort them?

- [ ] Compute \(\Delta r_i=(F-I)r_{i0}\), local normal/direction changes and minimum distance between attachment sites.
- [ ] Examine load spreading, adhesion/attachment mechanism, local reinforcement and sealing/leakage risks qualitatively before hardware trials.
- [ ] Compare several replacement/mounting concepts without prematurely assuming point loads on thin membrane are safe.

**Theory:** material attachment tracking and membrane traction/strain; \(\Delta B_i=R(F-I)r_{i0}\).  
**Literature:** [R5] membrane deformation under inflation; [R6] soft surface deformation and sensor/mechanics co-design; [R9] manufacturability-aware placement (methodological analogy).

**Output:** per-cable migration table; attachment-interface design requirements; provisional allowable shape/attachment motion.

### B5.5.3 — Flexible-Surface Cable Routing and Stroke Recheck

- [ ] Evaluate cable paths for undeformed and selected deformed configurations at the same core poses.
- [ ] Replace the rigid cable–sphere collision test with cable–deformed-surface intersection or a suitable triangulated-shell check; also rerun cable–cable distances.
- [ ] Recalculate \(L_{i,\min},L_{i,\max}\) and compare with rigid strokes and frame-mount accessibility.

**Theory:** \(C_i(q,\eta)=\overline{A_i\,B_i(q,\eta)}\); collision against \(\partial\mathcal B(\eta)\), accounting for allowed contact at the attachment endpoint.  
**Literature:** [R2] cable interference-free workspace methodology (robot/obstacle geometry, **requires adaptation** to deformed balloon surfaces); [R5] deformation geometry.

**Output:** deformation–pose interference matrix; updated segment-stroke envelope and design margins.

### B5.5.4 — Rigid-Pose/Deformation Observability Check

**Question:** Can six cable lengths distinguish rigid motion from deformation?

- [ ] Define \(q=[P^T,\delta\theta^T]^T\) and a small deformation vector \(\eta\).
- [ ] Derive/finite-difference the combined measurement Jacobian \(H_{\mathrm{full}}=[H_{\mathrm{rigid}}\;H_{\eta}]\in\mathbb R^{6\times(6+m)}\).
- [ ] Report rank and null space for the selected deformation parametrisation; document indistinguishable motion/deformation directions.
- [ ] Do **not** claim simultaneous free estimation of 6 rigid DOF plus \(m>0\) independent shape parameters from six instantaneous length measurements alone: \(\mathrm{rank}(H_{\mathrm{full}})\le6\).
- [ ] Consider physically justified constraints, time-dependent dynamics/prior information, independent sensors or future seventh/eighth cables only if a specific identification goal requires them. More cables alone do not guarantee full freeform-shape reconstruction.

**Theory:** \(\delta L\approx H_{\mathrm{rigid}}\delta q+H_{\eta}\delta\eta\); local identifiability requires full column rank for the independent unknowns absent additional constraints.  
**Literature:** [R6] model-based shape estimation with mechanical constraints; [R9] sensor placement and deformation estimation; Jacobian rank/null-space linear algebra.

**Output:** extended Jacobian check, unobservable direction examples, explicit list of measurable versus not-yet-measurable states.

### B5.5.5 — Compatibility Decision and Hardware Gate

- [ ] **Retain** frame/anchors if routing, uncertainty and mechanical margin remain acceptable under the declared flexible test cases.
- [ ] **Adjust attachments/pairing** if failures are local; **revise anchors/frame** only when necessary.
- [ ] Reserve modular connection points and spare sensor/controller channels if future observability tests support adding cables.
- [ ] Pass a documented rigid/flexible length-and-clearance envelope into B6; flag unknown loads and material values as sizing risks.

**Decision:** `retain V1.0` / `modify attachments` / `modify anchors` / `additional sensing needed`.  
**Gate requirement:** hardware dimensions and interfaces are compatible with a **plausible documented flexible test envelope**; full shape reconstruction is deferred.

---

## 5. B6 — Engineering Sizing (Prototype V1.0)

**Goal:** Convert V1.0 and its rigid/flexible envelopes into preliminary specifications; do not confuse numerical cable segment length with purchased cable length.

### B6.1 — Cable Length, Stroke, Drum and Routing

- [ ] Compute \(L_i(q,\eta)=\|A_i-P-Rr_i(\eta)\|\) over explicitly stated pose/deformation samples.
- [ ] Report \(L_{i,\min}\), \(L_{i,\max}\), \(\Delta L_i=L_{i,\max}-L_{i,\min}\), with independently specified margins for routing, wraps, installation and uncertainty.
- [ ] Estimate drum radius, drum capacity, guided cable path, motor shaft rotation and speed limits; consider effective drum-radius change with layers.

**Basis:** cable-length inverse kinematics and drum kinematics \(\Delta\varphi\simeq\Delta L/r_d\) for constant effective drum radius; [R4] CDPR kinematic/design overview.

### B6.2 — Mass, External Wrench and Tension Feasibility

- [ ] Estimate mass, centre of gravity, inertia, buoyancy/experimental support, acceleration bounds and environmental disturbances; do **not** determine tension from mass alone.
- [ ] At selected quasi-static poses test \(W(q,\eta)T+w_{\mathrm{ext}}=0\), with \(T_{\min}\le T_i\le T_{\max}\).
- [ ] Distinguish: positive-tension static equilibrium, active force control, and **low-tension passive tracking**. Quantify whether cable tension would substantially disturb spontaneous balloon motion.
- [ ] If six cables cannot meet intended loads under positive tension, reconsider mechanical support/compliance, operating envelope, extra cables or sensing architecture **before** buying motors.

**Basis:** unilateral cable forces and CDPR wrench equilibrium; [R7] minimum tension analysis; [R4] workspace/tension overview. The conventional CDPR static model must be adapted for passive sensing rather than assumed automatically applicable.

### B6.3 — Motor, Transmission and Sensor Preliminary Selection

- [ ] Calculate candidate design tension and speed; estimate \(\tau_m\simeq Tr_d/\eta_{\mathrm{drive}}\), \(\omega_m\simeq v/r_d\) before considering acceleration, friction, drum layers and margin.
- [ ] Define motor mode: backdrivable/passive tracking or closed-loop force-limited retraction; include independent tension feedback, slack detection and safe limits.
- [ ] Choose cable-length sensor resolution based on a declared **pose-accuracy target** plus noise/condition sensitivity, not assumed 0.1 mm simulation noise.
- [ ] Produce preliminary BOM and document measured/calibrated parameters needed for final sizing.

**Basis:** mechanical torque/power kinematics, sensor error propagation \(\Sigma_q\simeq(H^T\Sigma_L^{-1}H)^{-1}\); [R4], [R7].

**B6 gate:** preliminary cable, tension, motor, drum and sensing specs including assumptions, uncertainties and safe operational limits.

---

## 6. B7 — Adjustable Prototype and Calibration Architecture

- [ ] Design adjustable frame mounts (slots/rails or replaceable brackets) so B5 results are not permanently hard-coded.
- [ ] Develop replaceable rigid-body and flexible-balloon attachment carriers; assess local membrane loading and waterproof/air-tight design as applicable.
- [ ] Integrate cable-length measurement, tension measurement, emergency release/limit mechanisms and timestamping.
- [ ] Provide an independent reference measurement of known pose/deformation during validation (e.g. calibrated camera or tracked markers); do not give that reference to the estimator as an input.
- [ ] Reserve future auxiliary sensing / extra-cable mounting options if justified.

**Basis:** experimental design and calibration; [R4] CDPR mechanical overview; [R6] independent deformation sensing as a possible validation/augmentation approach.

**Deliverables:** mechanical drawings, wiring/BOM, reference calibration procedure, initial safety check.

## 7. B8 — Experimental Validation (Rigid First, Then Flexible)

### B8.1 — Rigid Reference Validation

- [ ] Calibrate cable-length and tension sensing; measure repeatability, bias, hysteresis and routing effects.
- [ ] Estimate unknown 6-DOF pose from cable lengths using nonlinear forward kinematics, with no leakage of reference ground truth into the estimation step.
- [ ] Report position/orientation RMSE, convergence rate, failure cases and comparison with B4.1 covariance forecasts.

### B8.2 — Flexible Balloon Validation

- [ ] Repeat matched tests with flexible balloon; record inflation/volume/pressure/material state.
- [ ] Distinguish apparent rigid-pose bias from surface deformation and attachment migration.
- [ ] Test a small number of defined deformation cases against an external reference; assess whether additional sensing or model constraints are needed.
- [ ] Quantify cable-induced motion/deformation disturbance under different low-tension settings.

**Basis:** nonlinear least-squares forward kinematics and covariance/Monte Carlo validation from Phase A4/B4.1; [R6] model-based shape estimation with mechanical constraints.

## 8. B9 — Experiment-Driven Configuration and Deformation Refinement

- [ ] Update actual sensor-noise, cable-stiffness, attachment migration, calibration and tension/disturbance models from B8 evidence.
- [ ] Revise mounting positions/pairing and, only when required, add sensing redundancy.
- [ ] Compare V1.0 versus V2.0 on identical physical experiments and independent test poses.
- [ ] Develop a reduced-order shape estimator or a mechanics-assisted model only after the targeted deformation states and sensing observability are justified.

**Basis:** [R6] mechanics-informed shape reconstruction; [R9] sensor-layout/deformation co-optimisation (method transfer, **not** identical to cable-length balloon measurement).

---

## 9. Parallel Task — B4.2 Nonlinear Pose Estimation

**Status:** Pending. May proceed alongside B5/B6 frame design.

- [ ] Adapt existing six-DOF nonlinear forward-kinematics solver to the selected V1.0 geometry.
- [ ] Test independent withheld poses and realistic initialisation, report multiple-solution/convergence issues.
- [ ] Run Monte Carlo studies with declared noise and calibration perturbations; calculate position/rotation RMSE.
- [ ] Compare nonlinear error with B4.1 local covariance; revise accuracy claims accordingly.

**Important:** B5/B6 may proceed on geometric and local-sensitivity evidence; **validated pose-accuracy claims and final sensor sizing** require these tests and later calibration.

---

## 10. Suggested Execution Order and Short Deliverables

| Order | Work | Release / decision |
|---|---|---|
| 1 | B5.1–B5.2 | Expanded points; A/B audit; shortlisted collision-screened configurations |
| 2 | B5.3–B5.4b | **Rigid Prototype V1.0 coordinates + pairing + core test envelope** |
| 3 | B5.5.1–B5.5.5 | **Flexible compatibility decision + design margins** (limited screening) |
| 4 | B6.1–B6.3 | Stroke, load/tension analysis, motor/drum/sensor preliminary sizing and BOM |
| 5 | B7 | Adjustable rig and independent calibration/reference measurements |
| 6 | B8 | Rigid then flexible experiments, quantitative error and disturbance results |
| 7 | B9 | Evidence-based redesign / optional additional measurement channels |

**Recommended cadence:** work in 4–5-hour research days; keep the daily plan in `weekly_plan_03.md` (to be revised after this document), not in this high-level file. Do not let a long soft-body modelling phase block modular frame design.

## 11. Research Rules and Definition of Done

1. Prototype V1.0 is a **documented, adjustable engineering baseline**, not a globally optimal configuration.
2. Every retained configuration must have an explicit 6×3 anchor array, 6×3 attachment array, pairing and fixed-coordinate convention.
3. Do not use B's feasible-only sample subset to optimise away hard poses; compare designs on common declared test sets.
4. B3 zero-thickness cable non-intersection is **not** proof of mechanical clearance; use diameter and mounting-envelope margins once available.
5. Six rigid-body measurements do **not** automatically identify six rigid DOFs plus arbitrary independent deformation parameters.
6. External anchors may remain physically fixed across rigid-to-flexible conversion, but their **optimality and safety are not guaranteed**; attachment-site movement and load transfer require re-evaluation.
7. Static tension models are conditional on specified external forces, buoyancy/support and actuation mode. Low-tension tracking must not unintentionally drive balloon motion.
8. All claimed DOI links should point to the actual cited work. Distinguish published method, mathematical consequence and project-specific engineering choice.
9. Update one GitHub file per user confirmation. Keep completed B1–B4 numerical details in their existing logs instead of duplicating them here.

---

## 12. Verified References and Method Mapping

**[R1]** Cheng, H. H., & Lau, D. (2023). *Cable Attachment Optimization for Reconfigurable Cable-Driven Parallel Robots Based on Various Workspace Conditions.* IEEE Transactions on Robotics, 39(5), 3759–3775. **DOI:** https://doi.org/10.1109/TRO.2023.3288838  
**Use:** B5.1, B5.2, B5.4; variables/constraints and interference-aware optimisation. **Transfer limitation:** their force/tension objectives are not direct sensing objectives.

**[R2]** Cheng, H. H., & Lau, D. (2022). *Ray-based cable and obstacle interference-free workspace for cable-driven parallel robots.* Mechanism and Machine Theory, 172, 104782. **DOI:** https://doi.org/10.1016/j.mechmachtheory.2022.104782  
**Use:** B5.2 and B5.5.3; cable–cable and cable–obstacle geometry checks. **Transfer limitation:** adapt obstacle representation to the deforming balloon.

**[R3]** Hannay, J. H., & Nye, J. F. (2004). *Fibonacci numerical integration on a sphere.* Journal of Physics A: Mathematical and General, 37, 11591. **DOI:** https://doi.org/10.1088/0305-4470/37/48/005  
**Use:** B5.1; support avoiding conventional latitude/longitude sampling anisotropy. **Transfer limitation:** numerical quadrature sampling is not an attachment-layout optimisation theorem.

**[R4]** *An Overview of Cable-Driven Parallel Robots: Workspace, Tension Distribution, and Cable Sagging* (2022). Mathematical Problems in Engineering, Article 2199748. **DOI:** https://doi.org/10.1155/2022/2199748  
**Use:** B5.3, B6, B7; workspace, tension distribution and mechanical sizing context. **Transfer limitation:** conventional CDPR operation differs from passive sensing.

**[R5]** *Gent models for the inflation of spherical balloons* (2015). International Journal of Non-Linear Mechanics, 68, 52–58. **DOI:** https://doi.org/10.1016/j.ijnonlinmec.2014.05.016  
**Use:** B5.5.1–B5.5.3; nonlinear inflation of rubber spherical thin shells and constitutive-law upgrade. **Transfer limitation:** no claim that the paper derives the chosen affine ellipsoid surrogate or a constrained gastric balloon.

**[R6]** Liu, L., et al. (2025). *Model-Based 3D Shape Reconstruction of Soft Robots via Distributed Strain Sensing.* Soft Robotics, 12(6), 721–731. **DOI:** https://doi.org/10.1089/soro.2024.0158  
**Use:** B5.5.1, B5.5.2, B5.5.4, B8, B9; model-plus-measurement reconstruction and mechanical constraints. **Transfer limitation:** strain sensors on soft robots differ from externally routed cable lengths on a balloon.

**[R7]** *On the Minimum Cable Tensions for the Cable-Based Parallel Robots* (2014). Journal of Applied Mathematics, Article 350492. **DOI:** https://doi.org/10.1155/2014/350492  
**Use:** B6.2–B6.3; minimum positive cable tensions and wrench/force constraints. **Transfer limitation:** actuator-force analysis requires the correct external-wrench and passive-following model.

**[R9]** *Model-Free Co-Optimization of Manufacturable Sensor Layouts and Deformation Proprioception* (2026). IEEE Transactions on Robotics, 42, 1662–1679. **DOI:** https://doi.org/10.1109/TRO.2026.3677076  
**Use:** B5.1, B5.5.2, B5.5.4, B9; reason to treat sensor/attachment layout and manufacturability as coupled design variables. **Transfer limitation:** method uses flexible strain/length sensing and data-driven learning; not direct evidence for the proposed six-cable balloon.

**Publication note:** The formula \(F=\mathrm{diag}(\lambda_x,\lambda_y,\lambda_z)\) is a project-level **kinematic deformation hypothesis**. \(\det F\approx1\) is the familiar volume-ratio determinant constraint if enclosed volume is approximately preserved. The paper [R5] motivates future nonlinear membrane physics; it does not establish this low-dimensional hypothesis as experimentally accurate.

---

## 13. Repository Follow-up Updates (One File at a Time)

After this TODO is manually committed, update in order:

1. `08_Project_Management/weekly_plan_03.md` — replace outdated seven-day schedule with actionable B5 → B5.5 → B6 tasks (4–5 hours/day).
2. `CURRENT_STATE2.md` — correct current milestone to B4.1 complete; set prototype-first priority, new flexible compatibility gate and deferred B4.2 accuracy validation.
3. Relevant `05_My_Research/` design notes — only where necessary to add flexible attachment model and V1.0 hardware requirements; do not duplicate entire TODO.
4. Later create dedicated B5 and B5.5 Research Logs once experiments run and results exist.

**Immediate next action:** B5.1 configuration audit. Do not start numerical optimization until the design variables, installation constraints and minimum required core test poses are declared.
