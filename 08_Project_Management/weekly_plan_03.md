# Weekly Plan 03 — Six-Cable Workspace Validation and Optimisation


**Created:** 2026-11-02  
**Last Updated:** 2026-11-03  
**Planning Period:** 2026-11-02 to 2026-11-10  
**Research Phase:** Phase B — Balloon-Specific Cable Sensing Design  
**Current Task:** B4.1 — Jacobian, Sensitivity and Covariance  
**Workload:** 4–5 hours per research day  
**Primary Software:** MATLAB

**Status:** Active — B3 completed; B4.1 next


---

## 1. Purpose

This plan provides the detailed daily research workflow for validating and improving a six-cable pose-sensing configuration.

The immediate objective is:

> Develop a numerically justified six-cable reference configuration that provides feasible and accurate 6-DOF pose sensing across a predefined balloon workspace.

The seven-/eight-cable extension is temporarily deferred.

### Research Strategy

The study follows five steps:

1. Verify existing six-cable configurations.
2. Evaluate geometric feasibility across multiple poses.
3. Evaluate sensing quality and uncertainty.
4. Improve anchor–attachment placement.
5. Select and validate a six-cable reference configuration.

Literature methods should be introduced only when they directly support the current research question.

**Scientific priority:** Numerical verification and interpretation take precedence over completing tasks on the planned dates.

---

## 2. Starting Research State

### 2.1 Geometry Baseline

| Parameter | Value |
|---|---|
| Engineering boundary | 280 × 300 × 320 mm |
| Balloon volume | 550 mL |
| Balloon radius | Approximately 50.83 mm |
| Balloon model | Rigid sphere |
| Degrees of freedom | 6 |
| Cable number | 6 |
| Candidate anchors | 26 |
| Candidate attachments | 40 |
| Initial position | [0, 0, 0] mm |
| Initial orientation | Identity matrix |

### 2.2 Completed Results

B1.1–B1.6 have established the initial balloon geometry and candidate regions.

B2.1–B2.2 have produced three six-cable configurations.

| Metric | Baseline | Experiment A | Experiment B |
|---|---:|---:|---:|
| Jacobian rank | 6 | 6 | 6 |
| Scaled minimum singular value | 0.004393 | 0.535345 | 0.533600 |
| Scaled condition number | 490.956 | 3.5759 | 3.2365 |

Experiment A:

- Six fixed face-centre anchors.
- Variable attachment locations.
- 20,000 random trials.
- 46 valid sampled configurations.

Experiment B:

- Variable anchor and attachment locations.
- 20,000 random trials.
- 75 valid sampled configurations.

**Limitation:** These are single-pose exploratory results.

### 2.3 Required Input Data

The following datasets were generated in the user's MATLAB workflow:

- `B1_geometry_baseline.mat`
- `B2_6cable_experiment_A.mat`
- `B2_experiment_B_results.mat`

Before beginning new experiments:

- Confirm that the files exist.
- Confirm the saved variable names and dimensions.
- Confirm that all coordinates use millimetres.
- Confirm that each row represents one anchor or attachment coordinate.
- Confirm that the saved configurations reproduce the previously reported condition numbers.

The files are not assumed to have been uploaded to GitHub unless explicitly committed.

---

## 3. Seven-Research-Day Overview

| Day | Date | Task | Primary Output |
|---|---|---|---|
| 1 | Nov 2 | B2.2 closeout | Validated A/B configuration records |
| 2 | Nov 3 | B3.1 — Multi-position feasibility | Position feasibility maps |
| 3 | Nov 4 | B3.2 — Multi-pose feasibility | Orientation-dependent feasibility maps |
| 4 | Nov 5 | B4.1 — Sensing quality | Jacobian and covariance distributions |
| 5 | Nov 6 | B5.1 — Configuration improvement | Improved six-cable candidates |
| 6 | Nov 9 | B4.2 — FK and Monte Carlo | Pose RMSE and convergence statistics |
| 7 | Nov 10 | B5.2 — Reference selection | Six-Cable Reference Configuration v1.0 |

The plan may extend beyond November 10 if numerical problems require additional investigation.

---

# Day 1 — November 2

## B2.2 Closeout and Reproducibility

**Research Question:**

What has been demonstrated by the initial six-cable configuration comparison, and what remains unverified?

**Status:** Numerical experiments completed; documentation and repository archiving may remain pending.

### Task 1.1 — Verify Existing Results (45 min)

- [x] Complete Experiment A.
- [x] Complete Experiment B.
- [x] Compare scaled condition numbers and minimum singular values.
- [x] Generate the three-configuration visual comparison.
- [ ] Verify saved datasets and their exact configurations.

### Task 1.2 — Record Design Variables (45 min)

- [ ] Save all six anchor coordinates for Experiment A.
- [ ] Save all six attachment coordinates for Experiment A.
- [ ] Save all six anchor coordinates for Experiment B.
- [ ] Save all six attachment coordinates for Experiment B.
- [ ] Preserve anchor-to-attachment cable correspondence.

### Task 1.3 — Numerical Regression Checks (60 min)

- [ ] Reconstruct the two configurations from saved data.
- [ ] Recalculate cable lengths.
- [ ] Recalculate measurement Jacobians.
- [ ] Confirm Jacobian rank six at the reference pose.
- [ ] Reproduce condition numbers approximately 3.5759 and 3.2365.
- [ ] Verify all attachment coordinates lie on the sphere.

### Task 1.4 — Research Interpretation (60 min)

Record:

- What changed between Baseline, A and B?
- Why did Experiment A improve substantially?
- Why did Experiment B improve only modestly?
- Why is a single-pose condition number insufficient?
- Why does random search not establish global optimality?

### Task 1.5 — Save Research Files (30 min)

Suggested files:

- `06_Research_Log/2026-11/B2_2_configuration_comparison.md`
- `04_Code_Exercises/MATLAB/B2_configuration_comparison.m`
- Existing A/B `.mat` datasets.
- Three-configuration comparison figure.

### Day 1 Acceptance Criteria

- [ ] Both A/B configurations can be reconstructed.
- [ ] Results are reproducible.
- [ ] Limitations are recorded.
- [ ] Configuration datasets are available for B3.

**Completion Rule:** Do not redesign the anchor locations during this closeout.

---

# Day 2 — November 3

**Status: Completed — 2026-11-03**

**Final Result:**

- 27 sampled centre positions evaluated.
- Experiment A: 8/27 combined geometrically feasible positions.
- Experiment B: 0/27 combined geometrically feasible positions.
- Main failure mechanisms identified.
- Code, results and research notes archived.

**Research Log:** [B3.1 Feasibility Notes](../06_Research_Log/2026-11/B3_1_feasibility_notes.md)

## B3.1 — Six-Cable Multi-Position Geometric Feasibility

**Research Question:**

Can the existing six-cable configurations remain geometrically feasible when the balloon moves to different positions?

**Literature:**

- P1 — Workspace sampling and feasibility classification.
- N1 — Cable–Cable interference detection.

**Expected Time:** 4–4.5 hours.

### Task 2.1 — Understand Geometric Constraints (30 min)

Review:

1. Full sphere containment.
2. Cable-length calculation.
3. Cable–sphere interference.
4. Cable–cable minimum distance.

The anchor points remain fixed in the world frame.

Attachment points move with the balloon.

### Task 2.2 — Generate Position Samples (45 min)

Initial sample set:

\[
P_x,P_y,P_z\in\{-50,0,50\}\ \mathrm{mm}
\]

Total:

\[
N=3^3=27
\]

Initial orientation:

\[
R=I
\]

Tasks:

- [ ] Generate 27 centre positions with `ndgrid`.
- [ ] Verify every position satisfies the selected sphere-containment condition.
- [ ] Recalculate all six world-frame attachment positions.
- [ ] Recalculate all six cable lengths.

### Task 2.3 — Cable–Sphere Interference (75 min)

For each cable:

\[
B_i=P+Rr_i
\]

\[
D_i=A_i-B_i
\]

The straight cable segment starts at the sphere surface.

A first outward-direction criterion is:

\[
D_i^T(Rr_i)\geq0
\]

For a spherical obstacle and an ideal straight segment beginning at its surface, a non-negative outward directional derivative prevents immediate penetration into the sphere interior.

Tasks:

- [ ] Calculate the outward-direction condition.
- [ ] Verify the result using independent segment–sphere geometry tests.
- [ ] Identify cables that enter the sphere.
- [ ] Store cable-specific failure labels.
- [ ] Verify at least one deliberately constructed inward-pointing cable is rejected.

### Task 2.4 — Cable–Cable Interference (75 min)

Represent each cable as a finite line segment:

\[
C_i(t)=B_i+t(A_i-B_i)
\]

\[
0\leq t\leq1
\]

Tasks:

- [ ] Implement minimum distance between two finite 3D segments.
- [ ] Evaluate all 15 distinct cable pairs.
- [ ] Verify the function using intersecting, parallel and separated test segments.
- [ ] Record the minimum inter-cable distance for each pose.
- [ ] Distinguish zero-clearance geometric intersections from finite-thickness cable collisions.

Cable diameter and required clearance are currently unknown.

Report distances independently of any provisional clearance threshold.

### Task 2.5 — Results and Verification (45 min)

- [ ] Evaluate both Experiment A and Experiment B.
- [ ] Calculate the number of geometrically admissible sampled positions under explicitly stated constraints.
- [ ] Identify the poses and cable pairs that fail.
- [ ] Generate a 3D feasibility map.
- [ ] Explain configuration differences.

### Deliverables

- `B3_1_multi_position_feasibility.m`
- `B3_1_segment_distance_3d.m`
- `B3_1_position_feasibility.png`
- `B3_1_results.mat`
- `B3_1_feasibility_notes.md`

### Day 2 Acceptance Criteria

- [ ] All 27 positions are evaluated.
- [ ] Segment distance calculations pass numerical test cases.
- [ ] Cable–sphere interference is correctly classified.
- [ ] Failure reasons are preserved.
- [ ] The same tests are applied to A and B.
- [ ] No unsupported physical clearance threshold is treated as validated.

**If no pose is fully feasible:** Report the result, identify the dominant failed constraint, and diagnose the geometry before changing the configurations.

---

# Day 3 — November 4


**Status: Completed Early — 2026-11-03**

**Final Result:**

- 189 combined translation–rotation poses evaluated.
- Experiment A: 40/189 geometrically feasible poses.
- Experiment B: 105/189 geometrically feasible poses.
- Experiment B Cable Pair 5–6 contact identified in 81 poses.
- Zero-rotation consistency checks passed.
- Orientation-dependent feasibility figures generated.
- Code, results and research notes archived.

**Research Log:** [B3.2 Feasibility Notes](../06_Research_Log/2026-11/B3_2_feasibility_notes.md)

## B3.2 — Multi-Pose Feasibility Including Rotation

**Research Question:**

How does balloon rotation influence cable lengths, routing, and geometric workspace feasibility?

**Literature:**

- P1 — Workspace sampling.
- N1 — Cable interference analysis.

**Expected Time:** 4–4.5 hours.

### Task 3.1 — Review Rotation Model (30 min)

Use a consistent world-frame rotation convention.

Verify:

\[
B_i=P+Rr_i
\]

Check:

\[
R^TR=I,\qquad \det R=1
\]

### Task 3.2 — Generate Orientation Samples (45 min)

Use seven initial orientation cases:

1. Zero rotation.
2. Roll = +10°.
3. Roll = −10°.
4. Pitch = +10°.
5. Pitch = −10°.
6. Yaw = +10°.
7. Yaw = −10°.

These are independent single-axis test rotations, not all possible combinations.

Combining 27 positions and seven orientation cases gives:

\[
N_{\mathrm{poses}}=189
\]

### Task 3.3 — Multi-Pose Geometry Evaluation (90 min)

For each configuration and sampled pose:

- [ ] Calculate world-frame attachments.
- [ ] Calculate cable vectors.
- [ ] Calculate cable lengths.
- [ ] Recheck balloon containment.
- [ ] Recheck cable–sphere interference.
- [ ] Recheck cable–cable distances.
- [ ] Store feasibility masks.

### Task 3.4 — Compare A and B (60 min)

Calculate:

- Geometric feasibility count.
- Feasibility fraction for each stated constraint scenario.
- Minimum inter-cable distance.
- Cable-length range.
- Number of failed poses by orientation.
- Dominant failure mechanisms.

Generate consistent A/B comparison figures.

### Task 3.5 — Research Interpretation (35 min)

Questions:

- Does rotation create new interference?
- Which configuration has more geometrically admissible poses?
- Which Cable pairs are more likely to collide?
- Are failures concentrated near certain positions or orientations?

### Deliverables

- `B3_2_multi_pose_feasibility.m`
- `B3_2_multi_pose_feasibility.png`
- `B3_2_results.mat`
- `B3_2_feasibility_notes.md`

### Day 3 Acceptance Criteria

- [ ] All 189 poses are evaluated.
- [ ] Rotation matrices are numerically verified.
- [ ] Failed poses and reasons are retained.
- [ ] Geometric coverage is explicitly distinguished from sensing coverage.
- [ ] The results are reproducible.

---

# Day 4 — November 5

## B4.1 — Jacobian, Sensitivity and Covariance

**Research Question:**

Which geometrically feasible poses can be locally distinguished from cable-length measurements, and how sensitive are they to measurement noise?

**Literature:**

- P4 — Forward kinematics and pose covariance.
- N5 — Geometric parameter calibration and error sensitivity.

**Expected Time:** 4–4.5 hours.

### Task 4.1 — Verify Measurement Jacobian (35 min)

For every cable:

\[
L_i=\|A_i-(P+Rr_i)\|
\]

Using the selected cable-direction convention, construct the 6 × 6 measurement Jacobian.

- [ ] Confirm the translation derivative signs.
- [ ] Confirm the rotation perturbation convention.
- [ ] Verify representative Jacobian rows using finite differences.
- [ ] Check agreement between analytical and numerical derivatives.

### Task 4.2 — Workspace Jacobian Evaluation (75 min)

For each sampled pose:

- [ ] Calculate the measurement Jacobian.
- [ ] Calculate numerical rank.
- [ ] Apply the same characteristic-length scaling.
- [ ] Calculate all six singular values.
- [ ] Calculate the minimum scaled singular value.
- [ ] Calculate the scaled condition number.
- [ ] Record rank-deficient or poorly conditioned poses.

The characteristic length must remain consistent across all configurations.

### Task 4.3 — Predicted Pose Covariance (60 min)

For a local linear measurement model:

\[
\delta y\approx H\delta q+\varepsilon
\]

with cable-length noise covariance \(\Sigma_y\):

\[
\Sigma_q\approx
(H^T\Sigma_y^{-1}H)^{-1}
\]

when the matrix is nonsingular and the statistical assumptions hold.

Tasks:

- [ ] Define a common illustrative cable-length noise model.
- [ ] Calculate local pose covariance at valid full-rank poses.
- [ ] Record position standard deviations.
- [ ] Record orientation standard deviations.
- [ ] Identify poses with high predicted uncertainty.
- [ ] Avoid interpreting local covariance as proof of global estimator accuracy.

### Task 4.4 — Compare A and B (60 min)

Generate:

- Rank distributions.
- Minimum singular-value distributions.
- Condition-number distributions.
- Position uncertainty maps.
- Orientation uncertainty maps.

Use identical pose sets and noise assumptions.

Report geometrically invalid poses separately rather than silently removing them from coverage statistics.

### Task 4.5 — Interpretation (30 min)

Research questions:

- Does Experiment B remain better away from the origin?
- Which poses have the weakest measurement sensitivity?
- Does good conditioning imply small absolute uncertainty?
- Are rotation estimates less reliable than position estimates?

### Deliverables

- `B4_1_workspace_jacobian.m`
- `B4_1_sensing_quality.png`
- `B4_1_covariance_results.mat`
- `B4_1_sensitivity_notes.md`

### Day 4 Acceptance Criteria

- [ ] Analytical Jacobian is numerically verified.
- [ ] Full-rank and singular poses are separated.
- [ ] Condition number is calculated using consistent scaling.
- [ ] Covariance results use an explicitly declared noise model.
- [ ] Position and orientation uncertainty are reported separately.

---

# Day 5 — November 6

## B5.1 — Six-Cable Multi-Pose Configuration Improvement

**Research Question:**

Can anchor–attachment selection be improved using workspace-level sensing criteria rather than a single-pose condition number?

**Literature:**

- P2 — Cable attachment optimisation framework.
- N3 — Multi-objective configuration optimisation.

**Expected Time:** 4–4.5 hours.

### Task 5.1 — Define the Optimisation Problem (45 min)

Design variables:

\[
\mathcal C=\{(A_i,r_i)\}_{i=1}^{6}
\]

Candidate sources:

- Anchor surface region.
- Attachment sphere surface.
- Initial discrete candidate sets.

Specify:

- Geometric constraints.
- Attachment and anchor uniqueness or spacing.
- Cable-routing assumptions.
- Workspace pose samples.
- Local identifiability requirements.

### Task 5.2 — Select Performance Metrics (60 min)

Investigate:

1. Geometric feasibility coverage.
2. Worst-case scaled condition number.
3. Worst-case scaled minimum singular value.
4. Predicted pose uncertainty.

Do not assume that minimising condition number alone produces the best estimator.

Choose a simple initial optimisation objective and record the rationale.

### Task 5.3 — Implement a Constrained Candidate Search (90 min)

- [ ] Reuse the existing A and B configurations.
- [ ] Generate additional six-cable candidates.
- [ ] Apply inexpensive geometry constraints first.
- [ ] Evaluate Jacobian properties over the selected training poses.
- [ ] Rank valid candidates using documented metrics.
- [ ] Save the best candidates and complete evaluation results.
- [ ] Record random seeds and computation budget.

Possible future methods include multistart local optimisation and NSGA-II.

Do not introduce a more complex algorithm until the constraint and evaluation models are verified.

### Task 5.4 — Evaluate Improvements (40 min)

Compare:

- Baseline A.
- Baseline B.
- Newly found candidates.

Use common training poses.

Retain multiple promising configurations rather than only one.

### Task 5.5 — Record Findings (25 min)

Questions:

- Does multi-pose optimisation favour more spatially distributed anchors?
- Does the single-pose winner remain competitive?
- Which constraints eliminate the most candidates?
- Does improving conditioning compromise geometric coverage?

### Deliverables

- `B5_1_multipose_configuration_search.m`
- `B5_1_candidate_ranking.csv`
- `B5_1_search_results.mat`
- `B5_1_optimisation_notes.md`

### Day 5 Acceptance Criteria

- [ ] The objective function is explicitly defined.
- [ ] Constraints are independently verified.
- [ ] A/B candidates are included as references.
- [ ] All compared candidates use the same evaluation settings.
- [ ] Search results are reproducible.
- [ ] No claim of global optimality is made.

---

# Day 6 — November 9

## B4.2 — Forward Kinematics and Monte Carlo

**Research Question:**

How accurately can the selected six-cable configurations reconstruct balloon pose from noisy cable-length measurements?

**Literature:**

- P4 — Forward kinematics and covariance.
- N5 — Calibration-error sensitivity.
- N6 — Cable-length measurement uncertainty.

**Expected Time:** 4–4.5 hours.

### Task 6.1 — Reuse Phase A4 Estimator (40 min)

- [ ] Load the existing Gauss–Newton forward-kinematics implementation.
- [ ] Adapt it to the six-cable balloon geometry.
- [ ] Verify noiseless reconstruction at selected feasible poses.
- [ ] Check numerical convergence and initialisation behaviour.

### Task 6.2 — Define Measurement Noise (50 min)

Initial illustrative model:

\[
\varepsilon_i\sim\mathcal N(0,\sigma_L^2)
\]

with:

\[
\sigma_L=1\ \mathrm{mm}
\]

This is a simulation assumption, not measured sensor accuracy.

Potential later scenarios:

- Smaller and larger length noise.
- Unequal cable noise.
- Anchor-location perturbations.
- Attachment-location perturbations.
- Cable calibration offsets.

### Task 6.3 — Monte Carlo Evaluation (100 min)

For selected test poses:

- [ ] Generate true cable lengths.
- [ ] Add simulated measurement noise.
- [ ] Estimate the pose without supplying the true pose as the estimator initial guess.
- [ ] Record estimated position.
- [ ] Record estimated orientation.
- [ ] Repeat using a reproducible random seed.
- [ ] Calculate position RMSE.
- [ ] Calculate orientation RMSE.
- [ ] Record convergence failures.
- [ ] Compare error statistics with local covariance predictions.

True poses are used to generate synthetic observations and calculate evaluation errors, not as privileged estimator inputs.

### Task 6.4 — Sensitivity Evaluation (45 min)

Test selected model perturbations:

- Anchor coordinate errors.
- Attachment coordinate errors.
- Measurement offsets.

Keep geometric parameter errors separate from random cable-length noise.

### Task 6.5 — Interpret Results (25 min)

Questions:

- Does Experiment B actually reduce pose RMSE?
- Which motion components are hardest to estimate?
- Does the estimator converge from realistic initial guesses?
- Are covariance predictions consistent with observed simulation errors?
- Do geometric calibration errors dominate length noise?

### Deliverables

- `B4_2_balloon_forward_kinematics.m`
- `B4_2_monte_carlo_results.mat`
- `B4_2_pose_rmse.png`
- `B4_2_estimation_notes.md`

### Day 6 Acceptance Criteria

- [ ] Noiseless pose reconstruction is verified.
- [ ] Multiple feasible poses are tested.
- [ ] Position and orientation RMSE are calculated separately.
- [ ] Convergence failures are recorded.
- [ ] Noise and geometric error assumptions are explicit.
- [ ] Covariance predictions are not overinterpreted.

---

# Day 7 — November 10

## B5.2 — Six-Cable Reference Configuration Selection

**Research Question:**

Which six-cable candidate offers the most appropriate balance of geometric feasibility, local sensing quality, estimated accuracy, and implementation complexity?

**Expected Time:** 4–4.5 hours.

### Task 7.1 — Consolidate Results (30 min)

Collect results from:

- B3.1 — Multi-position feasibility.
- B3.2 — Multi-pose feasibility.
- B4.1 — Jacobian and covariance.
- B5.1 — Configuration search.
- B4.2 — Forward kinematics and Monte Carlo.

### Task 7.2 — Independent Validation (100 min)

Construct or select held-out poses not used during optimisation.

- [ ] Re-evaluate geometry constraints.
- [ ] Recalculate Jacobian rank and conditioning.
- [ ] Recalculate local uncertainty.
- [ ] Test forward-kinematics reconstruction.
- [ ] Record any previously undetected failure modes.

Do not optimise candidate coordinates using the held-out validation results without declaring a new optimisation cycle.

### Task 7.3 — Configuration Comparison (55 min)

Compare candidate configurations using:

| Criterion | Main Metric |
|---|---|
| Geometry | Sampled feasible-pose fraction |
| Interference | Minimum clearances |
| Identifiability | Jacobian rank |
| Conditioning | Scaled singular values and condition number |
| Local uncertainty | Pose covariance |
| Estimation accuracy | Position and orientation RMSE |
| Reliability | Estimator convergence rate |
| Implementation | Routing and mounting complexity |

If no candidate satisfies the stated engineering requirements, select candidates for further investigation instead of claiming the reference design is complete.

### Task 7.4 — Reference Configuration Selection (45 min)

For the preferred candidate:

- [ ] Save six anchor coordinates.
- [ ] Save six attachment coordinates.
- [ ] Save cable-to-cable correspondence.
- [ ] Record optimisation objectives and constraints.
- [ ] Record performance across training and validation poses.
- [ ] Record limitations and remaining physical design questions.

### Task 7.5 — Research Summary (30 min)

Answer:

1. What limits the six-cable sensing workspace?
2. How does configuration affect measurement sensitivity?
3. How accurate is the reconstructed pose under simulated noise?
4. Which configuration offers the best observed trade-off?
5. What uncertainties remain before adding a seventh cable?

### Deliverables

- `Six_Cable_Reference_Configuration_v1.0.md`
- `B5_2_reference_configuration.mat`
- `B5_2_configuration_comparison.png`
- `B5_2_selection_notes.md`

### Day 7 Acceptance Criteria

- [ ] The selected configuration is reproducible.
- [ ] Independent validation is documented.
- [ ] Geometric and sensing constraints are reported separately.
- [ ] All reported error metrics use declared assumptions.
- [ ] Selection trade-offs are justified.
- [ ] No unsupported global-optimality or hardware-accuracy claims are made.

---

## 4. MATLAB Development Rules

### Common Coordinate Convention

- World-frame anchor coordinates: \(A_i\).
- Body-frame attachment coordinates: \(r_i\).
- Balloon-centre position: \(P\).
- Body-to-world rotation matrix: \(R\).
- World-frame attachment: \(B_i=P+Rr_i\).
- Cable length: \(L_i=\|A_i-B_i\|\).

All geometric coordinates use millimetres.

### Common Verification Rules

1. Verify array dimensions before calculations.
2. Verify pose and rotation conventions.
3. Verify the analytical Jacobian against finite differences.
4. Test geometric collision functions on known cases.
5. Use reproducible random seeds.
6. Preserve invalid and failed samples.
7. Distinguish simulation assumptions from measured parameters.
8. Use common pose sets for fair configuration comparisons.
9. Keep optimisation and independent validation poses separate.
10. Save configuration parameters with numerical results.

### Physical Constraint Limitations

The initial cable model assumes ideal straight-line paths.

The following physical parameters are not yet established:

- Cable diameter.
- Required cable–cable clearance.
- Motor cable-length range.
- Attachment hardware dimensions.
- Actual anchor installation positions.
- Cable bending and friction effects.
- Required low-tension force range.

Do not invent validated values for these parameters.

Where appropriate, report raw geometric results and perform explicitly labelled sensitivity studies.

---

## 5. Weekly Research Presentation

The weekly presentation should focus on the research question and evidence rather than displaying all MATLAB implementation details.

### Suggested Friday Presentation Structure

1. **Research Objective:** Why do we need to evaluate the six-cable configuration across multiple poses?
2. **Current Baseline:** Experiment A versus Experiment B.
3. **Geometric Feasibility:** Cable–sphere and cable–cable interference.
4. **Workspace Results:** Valid and invalid poses.
5. **Sensing Quality:** Jacobian, singular values and covariance.
6. **Configuration Improvement:** Initial multi-pose optimisation results.
7. **Limitations and Next Steps:** FK validation and reference configuration selection.

Use concise English text, large readable figures, and clear numerical comparisons.

Do not include unverified results as completed findings.

---

## 6. Literature-to-Task Mapping

| Literature | Main Method | Application |
|---|---|---|
| P1 — Workspace Review | Pointwise workspace analysis | B3 |
| P2 — Attachment Optimisation | Configuration constraints and optimisation | B5 |
| P4 — Forward Kinematics | Pose estimation and covariance | B4 |
| N1 — Cable Interference | Minimum cable–cable distance | B3 |
| N3 — Multi-Objective Optimisation | Configuration search framework | B5 |
| N5 — Calibration and Error Compensation | Geometric error sensitivity | B4 |
| N6 — Direct Cable Measurement | Sensor-error analysis | B4, future hardware |

Additional literature:

- N2 — Contact and wrapping: future if straight-cable assumptions fail.
- N4 — Response surface optimisation: future if full workspace evaluation is expensive.
- N7 — Overconstrained CDPR optimisation: future seven-/eight-cable study.

**Paper 3 Algorithms 1 and 2 are deferred until the seven-cable extension, subject to mechanical relevance.**

---

## 7. Research Decision Gates


### Gate 1 — After B3.2

**Status: Completed — Proceed with documented limitations.**

**Question:** Are there enough geometrically admissible sampled poses to justify sensing analysis?

**Evidence:**

- Experiment A: 40/189 combined geometrically feasible poses.
- Experiment B: 105/189 combined geometrically feasible poses.
- Both configurations exhibit distinct geometric limitations.
- No configuration has established complete workspace feasibility.

**Decision:**

Proceed to B4.1 using the existing configurations.

Evaluate the measurement Jacobian at all 189 poses for diagnosis, and report sensing-quality statistics on geometrically feasible subsets separately.

Do not modify anchor or attachment positions until the B4 analysis provides evidence for optimisation.

---

### Gate 2 — After B4.1

**Question:** Does either existing six-cable configuration provide acceptable local identifiability and conditioning across the evaluated pose set?

If yes:

Use it as an optimisation reference.

If no:

Investigate the main weak sensing directions and revise configuration search constraints.

### Gate 3 — After B5.1

**Question:** Has configuration search identified candidates that improve workspace-level performance?

If yes:

Proceed with independent estimator evaluation.

If no:

Review the design space, sampling method, constraints and objective functions.

### Gate 4 — After B5.2

**Question:** Is there sufficient numerical evidence to select a six-cable reference configuration?

If yes:

Freeze the reference dataset as version 1.0 and begin the seven-cable extension.

If no:

Continue six-cable validation or optimisation.

A reference design may later be revised when physical experiments provide new evidence.

---

## 8. Daily Record Template

At the end of each research day, record:

**Date:** YYYY-MM-DD

**Research Question:**

What specific question was investigated?

**Literature Method:**

Which paper or numerical method was used?

**Implementation:**

Which MATLAB file or function was developed?

**Results:**

What numerical results and figures were produced?

**Verification:**

Which checks passed? Which failed?

**Interpretation:**

What do the results mean for passive balloon sensing?

**Limitations:**

Which assumptions or uncertainties remain?

**Next Action:**

What is the next research question?

Only update the main research state file when there is a meaningful milestone.

---

## 9. Related Repository Files

### Project Management

- [Current TODO](current_october_november_todo.md)
- [Research Roadmap](Roadmap.md)
- [Previous Weekly Plan](weekly_plan_02.md)
- [Current Research State](../CURRENT_STATE2.md)

### Research Models

- [Rigid Body Sensing Design](../05_My_Research/Rigid_Body_Sensing_Design.md)
- [Workspace Boundary](../05_My_Research/Workspace_Boundary_v0.2_2026-10-20.md)

### MATLAB

- `04_Code_Exercises/MATLAB/`

### Literature

- `02_Paper_Reading/Literature_Review/Phase_B_Method_Selection_2026-11-02.md` — companion file; confirm it has been committed before linking directly.

### Research Logs

- `06_Research_Log/2026-11/`

---


## 10. Immediate Next Action

**B4.1 — Six-Cable Jacobian, Sensitivity and Covariance**

### Research Question

Can Experiment A and Experiment B provide sufficiently informative and robust 6-DOF pose measurements across their geometrically feasible sampled poses?

### Required Inputs

- B1_geometry_baseline.mat
- B2_6cable_experiment_A.mat
- B2_experiment_B_results.mat
- B3_2_results.mat

MATLAB data directory:

`03_Simulation/MATLAB/workspace definition/`

### Planned Steps

1. Load the saved 189-pose dataset.
2. Reconstruct the six-cable measurement Jacobian.
3. Verify the analytical Jacobian against numerical derivatives.
4. Evaluate Jacobian rank at each pose.
5. Apply consistent characteristic-length scaling.
6. Calculate minimum singular values and condition numbers.
7. Calculate local pose covariance under a declared noise model.
8. Compare Experiment A and Experiment B on their geometrically feasible subsets.
9. Identify weak sensing directions and poorly conditioned poses.
10. Record findings for B5 configuration optimisation.

### Acceptance Criteria

- [ ] Analytical Jacobian verification passed.
- [ ] All 189 poses evaluated.
- [ ] Geometrically infeasible poses retained for diagnosis.
- [ ] Rank-deficient poses identified.
- [ ] Scaled singular values and condition numbers calculated.
- [ ] Covariance assumptions documented.
- [ ] Position and orientation uncertainties reported separately.
- [ ] Experiment A/B comparison completed.
- [ ] Research notes and MATLAB outputs archived.

### Research Rules

- Do not change the existing anchor or attachment coordinates.
- Do not treat full Jacobian rank as proof of global pose identifiability.
- Do not claim experimentally validated accuracy from assumed noise.
- Do not claim tension feasibility from geometric feasibility.
- Preserve the original B3.2 results for reproducibility.

---

**Research Principle:** Validate geometric feasibility and sensing quality before six-cable configuration optimisation. Extend to seven and eight cables only after a sufficiently justified six-cable reference configuration has been established.

---

