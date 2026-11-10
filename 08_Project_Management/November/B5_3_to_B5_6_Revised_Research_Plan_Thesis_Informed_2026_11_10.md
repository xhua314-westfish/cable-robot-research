# B5.3–B5.6 Revised Research Plan — Thesis-Informed, Twelve-Rail Six-Cable Sensing

**Updated:** 2026-11-10  
**Project:** Cable-Robot-Based Sensing for a Passive Balloon-Like Object  
**Track:** Six-cable sensing prototype; seven/eight-cable theory remains parallel  
**Status:** Research plan — NOT an experimental result  
**Supersedes:** `B5_3_Updated_Research_Plan_12_Rail_Constraint_2026_11_10.md` **for future B5.3–B5.6 execution only**  
**Suggested GitHub location:** `08_Project_Management/November/B5_3_to_B5_6_Revised_Research_Plan_Thesis_Informed_2026_11_10.md`

---

## 1. Reason for Revision

The completed B5.2 study established multi-pose geometric behavior for five historical configurations. Reviewing doctoral research on configuration optimization, experimental robustness, model calibration, sensor-based pose estimation, and prototype design suggests five important refinements to our next stages:

1. **Translate the sensing task into explicit requirements before selecting a configuration.** Maximal Jacobian singular values alone do not specify acceptable pose-estimation error.
2. **Model real installation constraints before optimization.** The frame has **12 usable edge rails**, but an ideal anchor point is not automatically the effective cable exit point of a real pulley/guide.
3. **Build a minimal nonlinear pose estimator before final configuration optimization.** Geometric observability and local Jacobian conditioning must be connected to actual reconstruction behavior.
4. **Test parameter uncertainty, untested poses, and finite-sized hardware before selecting a prototype.** A nominal numerical optimum can be fragile.
5. **Design the mechanical prototype in parallel with simulation.** Final assembly and calibration remain downstream, but mounting, sensors, stroke, and low-tension feasibility should influence the design space early.

The primary research question remains:

> Can six low-tension, instrumented cables reliably reconstruct the six-degree-of-freedom pose of a passively moving balloon-like body over a specified region, using physically installable anchor, attachment, and pairing arrangements?

**This is a passive measurement system.** The cable-following mechanism must not prescribe the balloon trajectory. Deformation estimation and seven/eight-cable comparison are separate future workstreams, not claims already validated by the six-cable rigid-body model.

---

## 2. Fixed Model, Evidence and Open Engineering Requirements

### 2.1 Verified or adopted starting conditions

| Item | Value / convention | Evidence status |
|---|---|---|
| Engineering frame | X/Length = 280, Y/Width = 300, Z/Height = 320 mm | B1 engineering approximation, **not clinical continuous-workspace evidence** |
| Spherical balloon radius | `rb = 50.8266 mm` | Rigid-sphere 550 mL nominal model |
| Cable number | 6 | Current prototype baseline |
| Allowed anchor regions | **All 12 rectangular-box edges** | New mechanical design constraint |
| Rail directions | 4 X rails, 4 Y rails, 4 Z rails | Geometry definition |
| Initial rail sampling | 5 points/rail = 60 records; **44 unique points**, 8 corners shared by 3 rails | To be verified numerically in B5.3 Lesson 2.1 |
| Core sampled positions | Each of X,Y,Z ∈ {-20, 0, +20} mm | Existing provisional engineering evaluation set |
| Core sampled rotations | Identity + single-axis ±5° roll/pitch/yaw | 7 orientations × 27 positions = 189 poses |
| Larger benchmark | Each of X,Y,Z ∈ {-50, 0, +50} mm; identity + single-axis ±10° | 189 poses; separate sample set, **not a strict superset of Core** |
| Straight cable model | `B_i = P + R*r_i`, `D_i = A_i - B_i`, `L_i = norm(D_i)` | Ideal initial geometry |
| Sphere-outward test | `(R*r_i)·D_i >= -1e-9 mm²` | Ideal rigid sphere / straight cable |
| Cable–cable contact | Finite-segment distance `d_ij > 1e-6 mm` | **Numerical zero-thickness contact test**, not a hardware clearance requirement |
| Sensing Jacobian | `H_i = [-u_i^T, (u_i × R*r_i)^T]` | Same convention as B4, `u_i=D_i/L_i` |
| Jacobian scaling | `H_s = H*diag(1,1,1,1/rb,1/rb,1/rb)` | Retain and document consistently |

### 2.2 Historical B5.2 reference results — do not overwrite

| Historical configuration | Core geometry /189 | Larger benchmark /189 | Reference scaled sigma_min | Reference kappa | Main lesson |
|---|---:|---:|---:|---:|---|
| Original B | 108 | 105 | 0.533600 | 3.2365 | Core cable 5–6 contact in 81 poses |
| Modified B′ | 189 | 189 | 0.075854 | 23.575 | Geometry improvement may severely hurt sensing |
| F1 (best reference pairing) | 74 | 54 | 0.153511 | 15.1302 | Sphere failures involving cables 1, 3, 4 |
| F2 layered | 189 | 178 | 0.165045 | 12.7611 | Useful geometry-layout inspiration |
| F3 asymmetric | 189 | 157 | 0.375288 | 5.4169 | Useful reference sensing-layout inspiration |

**Historical configurations are diagnostic baselines, not automatically twelve-rail compliant.** No previously reported multi-pose estimation accuracy should be inferred from these reference-pose Jacobian numbers.

### 2.3 Required open inputs (must be recorded; do not invent)

- Rail profile, rail-end dead zones, sliding-carriage envelope, cable-guide/pulley placement and effective cable exit point.
- Whether one rail may host multiple independent anchor carriages; mounting collisions at shared frame corners.
- Cable diameter, connector and attachment footprint, allowable minimum physical clearance.
- Cable length sensor resolution, repeatability, zero-point calibration, sampling rate, and expected stroke.
- Tension sensing or slack-detection capability, feasible low positive tension and permissible disturbance of balloon motion.
- Required position/orientation accuracy, allowed dropout/convergence failure rate, intended update rate and sensing workspace.
- Independent ground-truth method for rigid-body pose and any future deformable-balloon tests.

**Policy:** For unknown quantities, record `TBD / assumed for sensitivity test` with provenance; never present assumed noise, stroke, tolerances or tension thresholds as measured hardware specifications.

---

## 3. End-to-End Research Sequence and Gates

```text
B5.2 verified historical comparisons (completed)
                 |
                 v
B5.3 Requirements + twelve-rail geometry + mounting interfaces
                 |
                 v
B5.3 Structured families S1/S2/S3 + feasible initial candidates
                 |
                 v
B5.4 Common evaluator + minimal nonlinear pose estimator
                 |
                 v
B5.4 E0 / E1a / E1b / E2 / E3 / E4 controlled optimization
                 |
                 v
B5.4 Robustness / held-out test / Pareto shortlist
                 |
                 v
B5.5 Pose reconstruction, noise, calibration & validation protocol
                 |
                 v
B5.6 Hardware integration, calibration & experiments
                 |
                 v
Prototype configuration decision (requirements + evidence)
                 |
                 +----> Feedback to mounting model / config optimization
```

**Execution principle:** One research lesson at a time. Each lesson must answer **why needed, theory/evidence, precise inputs, MATLAB implementation, numerical verification, physical meaning, and the decision it enables**. Create GitHub research logs from observed outputs, not predictions.

---

## 4. B5.3 — Design Requirements and Twelve-Rail Structured Configurations

**Phase objective:** Produce multiple clearly traceable, physically installable six-cable starting configurations, rather than selecting a nominal winner.

### Lesson 2.1 — Twelve-Rail Anchor Geometry (NEXT TASK)

**Research question:** How can every anchor be restricted to one of the 12 actual frame edges while retaining movable rail-position parameters?

**Method:** Parameterize all 12 rail segments by their end points `E0_j, E1_j` and rail index `rho_i`. Define `A_i = E0_(rho_i) + t_i*(E1_(rho_i)-E0_(rho_i))` with `0<=t_i<=1` for ideal geometry. Sample five points per rail *only for the initial discrete candidate visualization*. Retain duplicate rail membership metadata at physical corners.

**Acceptance / tests:** 12 distinct full edges; 4/4/4 X/Y/Z rails; 60 rail-sample records; 44 unique 3D points; 8 corners with exactly three rail memberships; no off-edge anchor candidates. Use a single named twelve-rail `.mat` data source and exclude the obsolete eight-rail `.mat` from downstream scripts.

**Deliverables:** Chinese-commented MATLAB script; rail coordinate table; labelled 3D rail plot; `B5_3_12rail_geometry_baseline.mat`.

**Decision:** The permitted *ideal* anchor location region is established. No actual six-cable arrangement is chosen yet.

### Lesson 2.2 — Early Mechanical Interface Definition (**NEW**)

**Research question:** Does an anchor point on a rail correspond to a physically realizable cable exit location?

**Method:** Draft a simple mechanical-interface representation with rail, mounting carriage, pulley/guide, outgoing cable segment, frame and balloon attachment. Distinguish **rail carriage position** from **effective fixed cable exit point**; if a rotating pulley makes the exit direction/point pose-dependent, first declare the simplifying approximation and plan its calibration or geometry update. Add placeholder parameter fields for mounting offsets, rail-end exclusion, carriage sizes and collision envelopes. Use 3D conceptual geometry or simple CAD; no unsupported dimensions.

**Acceptance / tests:** Coordinate frames and units are explicit; anchor effective-point convention is consistent; each missing mechanical dimension is marked `TBD`; rail constraints, duplicate-corner exclusion and multiple-carriage policies are stated.

**Deliverables:** `B5_3_Mechanical_Interface_Assumptions.md`, parameter dictionary, schematic / simplified CAD concept.

**Decision:** Which constraints can be modeled now, which require hardware specifications, and whether the ideal point-anchor model remains adequate for preliminary search.

### Lesson 2.3 — Measurement Requirements and Decision Criteria (**NEW**)

**Research question:** What must the six-cable sensor demonstrably measure to justify a prototype?

**Method:** Formulate measurable requirements for (i) rigid-body position/orientation range, (ii) noise and bias assumptions, (iii) expected pose-estimation RMSE/maximum error, (iv) reconstruction failure and update rate, (v) cable stroke, (vi) physical clearance, (vii) low-tension disturbance. Separate **must-have** requirements from **aspirational** targets; mark provisional thresholds until grounded in sensor datasheets, task needs, or calibration experiments.

**Acceptance / tests:** Every major metric has units, evaluation method, data provenance/status and an acceptance rule. Core hard geometry and practical mountability cannot be traded away just to improve condition number.

**Deliverable:** `B5_3_Measurement_Requirements_and_Acceptance.md`.

**Decision:** A traceable optimization objective, constraint set, and later prototype gate.

### Lesson 3 — Structured Twelve-Rail Families (S1/S2/S3)

**Research question:** Which rail allocations provide physically interpretable spatial coverage and attachment-direction diversity?

**Candidate families are hypotheses, NOT previously proven optimal structures:**

- **S1 — Rail-Constrained Layered:** upper/lower rail allocation inspired by F2, with separation and allowed local movement.
- **S2 — Distributed / Controlled Cross-Pairing:** diverse rails and explicitly tested crossed pairings; visual projected crossing is not proof of 3D contact.
- **S3 — Rail-Constrained Asymmetric:** constrained asymmetry inspired by F3 and Original B, not an attempt to copy their face-interior anchors.

**Method:** Define allowed rail IDs, occupancy policies, `t` ranges and multiple deterministic initial layouts for each family. Use common mounting rules. Retain rail ID even when two rails intersect at the same corner. Do not infer family superiority from one randomly generated example.

**Acceptance:** Multiple distinct, reproducible initial layouts per family; all anchor placements on permitted rails; no physically duplicated anchors; seeds and design rules logged.

**Deliverable:** `B5_3_12rail_configuration_families.mat` plus families/rules Markdown.

### Lesson 4 — Attachments, Pairings and Initial Candidate Screening

**Research question:** Can the six selected anchors be paired with six separated sphere attachments so that the reference pose and sampled Core satisfy preliminary geometry?

**Method:** Retain candidate provenance (original 40 / Fibonacci 100 / permitted refinement). Enforce attachment surface constraint and justified minimum spacing. Enumerate or structured-search pairing permutations (at most `6! = 720` for each fixed point set). Evaluate outward geometry, all 15 finite cable segment distances, finite cable lengths, and scaled Jacobian rank. Progress from reference-pose check to the Core 189-pose test. **Do not enforce arbitrary clearance in millimeters as a hardware fact.**

**Acceptance:** Coordinates, pairing indices, rail assignment and `t` values reproducible; feasible candidates carry complete failure diagnostics; infeasible candidates not silently discarded without counts.

**Deliverables:** Candidate configurations `.mat`, geometry screening tables, six-cable labelled plots.

### Lesson 5 — Early Geometry / Sensing / Mechanical Screening (**NEW**)

**Research question:** Which initial candidates merit B5.4 optimization without violating known engineering constraints?

**Method:** Evaluate reference pose and Core geometry, preliminary `sigma_min(H_s)` and `kappa(H_s)`, cable length range, anchor/attachment spacing, and mounting placeholders. Use a fixed short-list policy with diversity across S1/S2/S3; keep Original B/B′/F1–F3 as historical reference, not rail-compliant candidates.

**Acceptance:** A justified shortlist of *multiple* starting configurations and an explicit log of missing mechanical parameters.

**Gate B5.3 → B5.4:** Twelve-rail region and mounting convention documented; measurable evaluation criteria written; reproducible candidate set and baseline archived.

---

## 5. B5.4 — Sensing-Oriented Optimization and Robustness

**Phase objective:** Demonstrate how anchor choice, rail position, sphere attachments and pairing individually and jointly influence geometry and *actual pose sensing*, using fair, repeatable tests.

### Lesson 1 — Common Geometry and Sensing Evaluator

**Research question:** Can every configuration be scored using the same pose samples, geometric checks, measurement conventions and numerical tolerances?

**Method:** Modular evaluation taking `{rail IDs, t, anchors, attachments, pairing}` and pose set; returns per-pose/per-cable sphere test, 15 pair clearances, lengths, full-rank status, scaled singular values, condition numbers, and parameterized uncertainty estimates. Maintain the B4 Jacobian sign/scaling convention. Use Core as development set, larger benchmark as stress evaluation; do not incorrectly interpret benchmark as the sampled Core's strict superset.

**Outputs:** Shared MATLAB evaluator, test fixtures that reproduce B5.2 historical results, evaluation-table schema, named geometry tolerances.

**Acceptance:** Regression tests match preserved B5.2 counts; any difference is diagnosed rather than overwritten.

### Lesson 2 — Minimal Nonlinear Forward Pose Estimator (**MOVED EARLIER**)

**Research question:** Can six modeled cable lengths recover rigid-body `P` and `R` without access to the true pose at estimation time?

**Method:** Solve `min_q ||W^(1/2)(L_meas - L(q))||²` via iterative nonlinear least squares with a documented 6D pose parametrization and Jacobian. Ground-truth pose is used **only to generate synthetic measurements and score the output**, not as a hidden estimator input. Test convergence on small known pose changes, multiple initial guesses, and configurations with contrasting `sigma_min`. Distinguish measurement noise, model bias and solver failure.

**Outputs:** Minimal reusable estimator, synthetic controlled tests, reference-pose and Core reconstruction errors, convergence diagnostics.

**Acceptance:** Correctness against noise-free synthetic known poses; solver convergence and failure cases explicitly reported; pose errors computed against withheld-from-estimator truth.

### Lesson 3 — E0 Baseline + E1a/E1b Anchor-Controlled Experiments

**Research question:** How much improvement is caused by sliding on existing rails versus selecting different rails?

- **E0:** Freeze rail assignment, `t`, attachments, pairing.
- **E1a:** Freeze rail assignment, attachments and pairing; vary **only** continuous rail position `t`.
- **E1b:** Allow rail reassignment `rho` plus `t`; hold attachment coordinates and pairing fixed.

**Method:** Compare matched Core performance, worst-case `sigma_min(H_s)`, worst-case `kappa`, estimated measurement uncertainty, geometric pass count and clearance. Record hard constraint violations. Keep baseline for paired comparisons.

**Acceptance:** Fixed/changed variables, candidate counts, initialization, seeds, runtime budget and final configurations fully logged.

### Lesson 4 — E2 Attachment-Only Experiment

**Research question:** What part of performance changes can be attributed to the six sphere attachment locations?

Fix rail IDs, anchor `t`, and pairing; optimize or search **only** six spherical attachment coordinates, maintaining minimum separation, surface membership, and geometry constraints.

**Acceptance:** Same evaluation sets and acceptance criteria; report sensing/geometry trade-offs versus E0 and E1.

### Lesson 5 — E3 Pairing-Only Experiment

**Research question:** What improvement is possible without physically moving either anchor or attachment set?

Freeze the two six-point sets; compare up to 720 attachment permutations with reference and Core geometry. Diagnose why improved clearance may hurt sensing, using Original B vs B′ as a methodological example.

**Acceptance:** Report pass counts per filter, best feasible pairing, Core worst-case sensing, and reproducibility.

### Lesson 6 — E4 Joint Rail/Attachment/Pairing Optimization

**Research question:** Does combined tuning outperform E1–E3 under the same real constraints, and what interactions matter?

**Primary candidate objective, conditional on full Core geometric feasibility and local rank:**

\[
\max_{\mathcal C_6}\;\min_{q\in Q_{\mathrm{core}}}\sigma_{\min}(H_s(q;\mathcal C_6)).
\]

Variables: categorical rail assignment, continuous rail position, sphere attachment positions and pairing permutation. Use staged or multi-start discrete/continuous search and record the computational budget. Compare secondary objectives rather than blindly combining arbitrary weights: worst-case condition number, position/orientation predicted uncertainty, clearance, assembly complexity, cable stroke, and prototype feasibility.

**Acceptance:** Hard geometry/mounting conditions are maintained; gains are compared to best E0/E1/E2/E3; stochastic sensitivity and unsuccessful searches are reported. **Do not claim a global optimum** without supporting proof.

### Lesson 7 — Robustness and Independent-Set Validation (**EXPANDED**)

**Research question:** Is the candidate still acceptable when the nominal geometry, measured lengths and target poses are imperfect?

**Tests:**

1. **Held-out poses** distinct from the 189 Core samples, including interpolated translations and combined roll/pitch/yaw, plus relevant motion paths. Do not use the held-out set to tune the winner repeatedly.
2. **Installation and calibration uncertainty:** perturb effective anchor location, sphere attachment location, rail carriage settings and cable zero points, with declared hypothetical bounds until hardware data exist.
3. **Measurement errors:** noise, systematic bias, missing/slack cable scenarios, estimator initial-guess sensitivity.
4. **Clearance margin:** finite cable/connector/pulley geometry when specified; distinguish ideal `1e-6 mm` contact from real minimum safe clearance.
5. **Search stability:** multiple initial seeds and families; verify worst-case versus median metrics and failure rate.

**Acceptance:** Worst-case and distributional results supplied, uncertainty provenance stated, failed pose IDs preserved. Passing finite samples never counts as a continuous-workspace theorem.

### Lesson 8 — Pareto Shortlist and Design Freeze Candidate

**Research question:** Which two or three candidates achieve the most credible sensing/geometry/manufacturability balance for a first prototype?

**Decision framework (thresholds TBD until B5.3 requirements):**

- **Hard gates:** permitted rail installation, no modeled cable–sphere penetration in required Core, physical cable clearance after dimensions are known, plausible stroke, local sensing rank, feasible low-tension measurement concept.
- **Primary measured performance:** held-out pose RMSE, failure rate, sensitivity to parameter error.
- **Trade-off indicators:** worst-case scaled sigma_min, condition number, predicted covariance, benchmark pass count, minimum clearance, ease of calibration and reconfiguration, complexity/cost.

**Outputs:** Pareto table, 2–3 candidate coordinate/rail/pairing configurations, outstanding-risk register and selection rationale.

**Gate B5.4 → B5.5:** The shortlist is geometrically defensible and estimable in simulation; no premature declaration of hardware-ready accuracy.

---

## 6. B5.5 — Measurement Validation, Calibration and Protocol

**Phase objective:** Establish independent evidence that cable length measurements recover passive **rigid-body pose** accurately, while identifying model mismatch and failure modes.

### Lesson 1 — Noise/Bias Measurement Model

Define `L_meas = L_true + b + epsilon`, document units, zero-point bias, possible correlation, and whether noise varies with tension. Separate **hypothetical sensitivity sweeps** from later **sensor-calibrated values**. Report predicted pose covariance when assumptions justify it: `Sigma_q ≈ (H' Sigma_L^{-1} H)^(-1)` for locally full-rank linearized models.

### Lesson 2 — Pose Reconstruction Validation

Test nonlinear least squares on independent synthetic poses, perturbations and initial guesses. Evaluate translation RMSE/max error in mm, orientation geodesic error in degrees, convergence failures and runtimes. Compare predicted Jacobian indicators to actual estimation errors. Never provide true pose as an estimator input.

### Lesson 3 — Calibration and Model Selection

Compare ideal point-anchor/straight cable geometry with a hardware-informed model including effective guide point or pulley geometry, cable zero offsets, and optional elastic corrections when supported. Design identifiable calibration maneuvers and document which parameters can be independently estimated. Do not overfit calibration to the evaluation trajectories.

### Lesson 4 — Independent Motion and Fault Tests

Test unseen combined rotations, intermediate positions, smooth trajectories and selected slack/noisy-cable cases. Report which tests are valid under the passive measurement hypothesis and which require a laboratory-driven reference motion for calibration.

### Lesson 5 — Ground-Truth and Experimental Protocol

Choose an independent reference pose measurement (e.g. optical tracker or suitable calibrated visual tracking) based on accuracy and cost. Define synchronization, sample count, repeatability, calibration/test separation and how uncertainty will be reported. Clarify that applying prescribed test motion to calibrate a sensor is not the claimed operating principle of the final passive system.

### Lesson 6 — Validation Report / Update Requirements

Record whether accuracy and stability meet the B5.3 provisional requirements, replace assumed sensor specifications with measured ones when available, and feed any major discrepancy back to B5.4.

**Gate B5.5 → B5.6:** A documented estimation algorithm and independent validation protocol exist; uncertainty and remaining calibration parameters are explicit.

---

## 7. B5.6 — Prototype Engineering, Low-Tension Feasibility and Decision

**Phase objective:** Build and test a first-generation **measurement** apparatus; avoid treating a mechanically assembled frame as proof of sensing performance.

### Lesson 1 — Detailed Prototype Mechanical Review

CAD/layout of 12-rail frame, selectable anchor carriages, guide/pulley, cable routing, connector footprints, assembly access, end stops, fastener clearances, collision margins and actual effective anchor positions. Verify that shortlisted configurations can be assembled and readjusted repeatably.

### Lesson 2 — Measurement Hardware and Travel

Select/justify encoder or displacement sensing, cable spooling and guide mechanism, travel range from modeled cable extrema plus justified reserve, sampling and synchronization, power and safety. Separate required sensing precision from nominal component resolution; plan in-situ calibration.

### Lesson 3 — Low-Tension/Non-Intrusive Measurement Feasibility

Assess positive tension required to avoid slack and the disturbance imposed on passive balloon motion. Model or measure resultant cable forces/torques and low-tension control or compliant follower behavior. **Do not transplant active CDPR wrench-closure constraints as the sensing objective.** Quantify or explicitly flag unknown allowable balloon disturbance and force limits.

### Lesson 4 — Assembly, Registration and Calibration

Record real rail IDs and carriage positions, measure effective anchor/attachment locations, calibrate cable length zero points and guide geometry, log mechanical errors; update the estimation model from measured parameters rather than silently redefining simulation geometry.

### Lesson 5 — Prototype Measurement Experiments

With independent ground truth, evaluate static poses, repeated changes, slow passive motion, repeatability, noise and loss-of-tension events. Compare predicted and measured error, report failure cases, and distinguish rigid from deformable-balloon results.

### Lesson 6 — Prototype V1.0 Configuration Decision

Use a requirements-traceability and Pareto matrix to select, modify or reject a candidate. Report measured accuracy/clearance/tension/hardware limitations, assembly costs and remaining uncertainty. A negative result should lead to a documented design revision, not an unsupported claim of optimality.

**Gate B5.6 complete:** Reproducible built configuration and measurement protocol, defensible results, explicit decision and next revision path. If hardware is not yet available, report **prototype-ready design status** only, not experimental validation.

---

## 8. Controlled-Variable Comparison Matrix

| Experiment | Rail ID `rho` | Position `t` | Attachments `r` | Pairing `pi` | Purpose |
|---|---|---|---|---|---|
| E0 | Fixed | Fixed | Fixed | Fixed | Common rail-compliant baseline |
| E1a | Fixed | **Variable** | Fixed | Fixed | Effect of sliding on existing rails |
| E1b | **Variable** | **Variable** | Fixed | Fixed | Added effect of rail reassignment |
| E2 | Fixed | Fixed | **Variable** | Fixed | Attachment-only effect |
| E3 | Fixed | Fixed | Fixed | **Variable** | Pairing-only effect |
| E4 | **Variable** | **Variable** | **Variable** | **Variable** | Coupled and interaction effects |

**Fairness:** Keep common baseline, coordinate frames, pose samples, units, criteria and geometry tolerances; record optimizer, sample budgets/seeds, runtime, rejected candidates, successful solutions and sensitivity to initialization. E1–E3 reveal conditional interventions, **not globally independent physical effects**; E4 checks coupling.

---

## 9. Traceability and Acceptance Register

| Requirement ID | Requirement to define | Test / evidence | Current status |
|---|---|---|---|
| R-GEO-01 | All six anchors on valid 12-rail mounting locations | Rail membership + actual guide-point check | Rail model pending Lesson 2.1; mechanical offsets TBD |
| R-GEO-02 | Required Core cable–sphere clearance | 189-pose + held-out tests | Existing ideal criterion; new rail candidates pending |
| R-GEO-03 | Cable–cable physical clearance | Finite segments, then cable/connector envelopes | Contact logic exists; physical threshold TBD |
| R-SEN-01 | Required full-rank local rigid-body sensing | Jacobian rank and scaled sigma_min | Evaluation method exists |
| R-SEN-02 | Pose-estimation accuracy | RMSE / max error vs independent reference | Target and measured result TBD |
| R-SEN-03 | Robustness to geometry/noise/initialization | Perturbation + held-out tests | Planned |
| R-MECH-01 | Rail/slider/pulley installability | CAD + physical dimensions | TBD |
| R-MECH-02 | Cable travel, length measurement reliability | Modeled extrema + sensor bench test | TBD |
| R-MECH-03 | Minimal disturbance under positive tension | Force/torque/tension validation | TBD |
| R-VAL-01 | Independent ground truth and calibration | Protocol and repeated experiments | TBD |

**Requirement management rule:** Each TBD receives a responsible source (datasheet, fixture specification, derived bound, measured prototype result) before it becomes a pass/fail threshold. Hypothetical values must remain explicitly labelled.

---

## 10. File Organization and Workflow

### Reuse, do not overwrite

- Existing B1–B5.2 source scripts, `.mat` datasets, comparison plots and research logs.
- `B5_2_Multi_Pose_Geometric_Screening_2026_11_10.md` as the geometry-screening record.
- Historical Original B, B′, F1, F2, F3 as non-rail-compliance-guaranteed comparison baselines.

### Planned deliverables

```text
08_Project_Management/November/
  B5_3_to_B5_6_Revised_Research_Plan_Thesis_Informed_2026_11_10.md

05_My_Research/
  B5_3_Mechanical_Interface_Assumptions.md            (planned)
  B5_3_Measurement_Requirements_and_Acceptance.md      (planned)

03_Simulation/MATLAB/workspace definition/
  B5_3_12rail_geometry_baseline.mat                    (planned)
  B5_3_12rail_configuration_families.mat               (planned)
  B5_4_common_evaluator.m                              (planned)
  B5_4_pose_estimator.m                                (planned)
  B5_4_optimized_candidates.mat                        (planned)

06_Research_Log/2026-11/
  B5_3_*.md / B5_4_*.md / B5_5_*.md / B5_6_*.md         (planned)
```

Paths under `03_Simulation`, `05_My_Research` and `06_Research_Log` are suggested targets; match actual repository conventions during manual upload. Planned entries are **not assertions that files already exist**.

**Collaboration rule:** Work one lesson at a time. Explain why, theory/literature (including verifiable sections/equations where available), decision, and one complete Chinese-commented MATLAB script. User runs it and supplies actual output. Interpret results before marking a lesson completed; only then prepare a `.md` research log and proceed. GitHub updates remain **manual, file by file**.

---

## 11. Priority, Dependencies and Estimated Effort

Use estimates for planning, not a promise of completion. At a research pace of approximately **4–5 focused hours/day**, a practical sequence is:

| Block | Approximate research days | Critical dependency |
|---|---:|---|
| B5.3 2.1–2.3: rails, interface, requirements | 3–5 | Confirm hardware assumptions without fabricating dimensions |
| B5.3 3–5: families, pairing, early screening | 4–6 | Repeatable rail-constrained starting designs |
| B5.4 1–2: evaluator and minimal estimator | 3–4 | Numerical regression and noise-free reconstruction checks |
| B5.4 3–6: controlled + joint search | 6–9 | Clear objective, constraints and computational budget |
| B5.4 7–8: robustness + shortlist | 3–4 | Held-out tests and uncertainty assumptions |
| B5.5 1–6: validation/calibration protocol and simulation | 4–7 | Ground-truth plan and estimator |
| B5.6 1–3: hardware design and low-tension assessment | 3–6 | Supplier/dimension availability |
| B5.6 4–6: assembly/calibration/experiments/decision | Hardware-dependent | Equipment, materials and laboratory access |

**Parallelization:** While B5.3/B5.4 simulation progresses, investigate rail/slider/pulley dimensions, possible ground-truth systems and length/tension sensors. Do not delay every simulation until hardware is purchased, but do not freeze an impossible mechanical layout.

---

## 12. Doctoral-Research Sources Informing This Plan

The following theses motivated **research-process choices**, not direct claims that their active-drive optimization goals are optimal for passive sensing:

1. **Joshua T. Bryson (2016), *The Optimal Design of Cable-Driven Robots*, University of Delaware.** Configuration design, workspace/performance optimization, experiments, and robustness to configuration variation. University repository: <https://udspace.udel.edu/items/0ab52ba8-088d-4c14-ba90-359fe846357a>.
2. **Philipp Miermeister (2020; publication 2021), *Model Selection and Parameter Optimization for Cable-Driven Parallel Robots*, University of Stuttgart.** Model fidelity, parameter identification and calibration. DOI: <https://doi.org/10.18419/opus-11732>.
3. **Sara Gabaldo (2026), *Pose Estimation for Underactuated Cable-Driven Parallel Robots*, University of Bologna.** Cable-related sensor measurements and nonlinear pose estimation. DOI: <https://doi.org/10.48676/unibo/amsdottorato/13196>.
4. **Ruobing Wang (2023), *Prototype Design and Time-Optimal Control of a Lower-Mobility Cable-Driven Parallel Robot*, Hong Kong Polytechnic University.** Design optimization, workspace screening and implementation. Repository: <https://ira.lib.polyu.edu.hk/handle/10397/103800>.
5. **Valentina Mattioni (2023), *Mechanical Design and Hybrid Control Strategies for Overconstrained Cable-Driven Parallel Robots*, University of Bologna.** Guide/pulley systems, sensing and tension-related hardware. DOI: <https://doi.org/10.48676/unibo/amsdottorato/10738>.
6. **Damiano Zanotto (2011), *Analysis and Development of Cable-Driven Robotic Devices*, University of Padua.** Task-linked performance metrics, design methodology and prototype evidence. Repository: <https://www.research.unipd.it/handle/11577/3427530>.

**Citation discipline:** Use these as literature-navigation links; when drafting a formal thesis literature review, separately verify original sections/pages/figures and exact claims. Do not invent quantitative outcomes, equations or chapter locations not checked against the source.

---

## 13. Immediate Next Action — B5.3 Lesson 2.1

1. Use the twelve-rail geometry definition: 4 X, 4 Y, 4 Z full frame edges.
2. Verify 60 raw samples, 44 unique points and corner-to-rail memberships, and clearly label all 12 rails.
3. Save `B5_3_12rail_geometry_baseline.mat` with reliable variable naming.
4. **Before generating S1/S2/S3**, complete Lesson 2.2's minimal mechanical interface assumptions and Lesson 2.3's provisional measurement acceptance register.
5. Present MATLAB numerical results, identify problems, then log completed evidence to GitHub.

**Do not advance to B5.3 Lesson 3 merely because this plan was written.** Actual geometry verification and required design decisions must be completed first.
