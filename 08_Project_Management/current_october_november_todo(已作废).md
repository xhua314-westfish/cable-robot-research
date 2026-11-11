# 已作废
# 作为历史文件

# October–November Research TODO

**Last Updated:** 2026-11-03  
**Research Phase:** Phase B — Balloon-Specific Cable Sensing Design  
**Current Focus:** Six-Cable Sensing Quality and Configuration Optimisation  
**Next Task:** B4.1 — Jacobian and Sensitivity Evaluation  
**Workload:** 4–5 hours per research day
---

## 1. Purpose

This document tracks the current research tasks, their completion status, expected outputs, and acceptance criteria.

The research follows a problem-driven approach:

**Define geometry → Generate configurations → Evaluate feasibility → Evaluate sensing accuracy → Optimise placement → Select a reference configuration.**

### Current Research Priority

The immediate priority is to develop and validate a reliable **six-cable reference configuration**.

Seven- and eight-cable configurations will be investigated after the six-cable system has undergone sufficient geometric and sensing-performance validation.

Literature methods will be selected according to the research question, rather than reproduced without a specific purpose.

---

## 2. Research Baseline

| Parameter | Current Definition | Status |
|---|---|---|
| Application | Passive balloon pose sensing | Defined |
| Engineering boundary | 280 × 300 × 320 mm | Selected engineering baseline |
| Balloon volume | 550 mL | Selected |
| Balloon model | Rigid sphere | Initial simplification |
| Balloon radius | Approximately 50.83 mm | Derived |
| Motion | Passive and unknown | Assumed |
| Estimated state | 6-DOF pose | Defined |
| Initial cable number | 6 | Current |
| Future cable number | 7 and 8 | Deferred |
| Anchor region | Six boundary faces | Initial candidate region |
| Attachment region | Spherical surface | Initial candidate region |
| Anchor candidates | 26 discrete points | Generated |
| Attachment candidates | 40 discrete points | Generated |
| Primary measurements | Cable lengths | Selected |
| Primary software | MATLAB | Selected |

### Important Assumptions

1. The engineering boundary is not a clinically validated gastric lumen.
2. The initial sphere is rigid and has constant volume.
3. The boundary faces also serve as idealised anchor-mounting surfaces in the current simulation.
4. Actual anchor installation and cable routing remain unverified.
5. The proposed motors maintain low cable tension without prescribing balloon motion.
6. The estimator must not use the true balloon trajectory as an input.
7. Physical sensor resolution and calibration errors have not yet been established experimentally.

---

## 3. Phase A — Literature Method Reproduction

**Status: Core scope completed.**

| Task | Method | Outcome | Status |
|---|---|---|---|
| A1 | Paper 2 — RREF, TF and WCC | Cable force feasibility analysis | Completed |
| A2 | Paper 3 — Algorithm 1 | Single-pose feasible anchor region | Completed |
| A3 | Paper 3 — Algorithm 2 | Multi-pose feasible-region intersection | Completed |
| A4 | Paper 4 — Forward Kinematics | Jacobian, covariance, Monte Carlo and NEES | Completed |
| A5 | Paper 1 — Workspace Sampling | Three-dimensional feasibility sampling | Completed |

### Available Methods

- Cable-length measurement model.
- Six-degree-of-freedom measurement Jacobian.
- Jacobian rank and singular-value analysis.
- Wrench-closure feasibility analysis.
- Multi-pose feasible-region intersection.
- Forward kinematics using Gauss–Newton.
- Local pose-estimation covariance.
- Monte Carlo validation.
- Workspace sampling.

### Important Limitation

Phase A demonstrated selected methods using reference geometries.

It did not validate the final balloon-specific sensing system.

These methods should be reused and adapted when relevant.

---

## 4. Phase B1 — Geometry and Candidate Region Definition

**Status: Completed — Initial engineering geometry.**

### B1.1 — Engineering Boundary

- [x] Review existing gastric geometry evidence.
- [x] Distinguish literature dimensions from engineering assumptions.
- [x] Adopt the supervisor-recommended enlarged boundary.
- [x] Define consistent X/Y/Z coordinate conventions.

**Selected boundary:**

- X — Length: 280 mm.
- Y — Width: 300 mm.
- Z — Height: 320 mm.

The boundary is an engineering simulation envelope rather than a measured anatomical workspace.

### B1.2 — Balloon Geometry

- [x] Define a 550 mL rigid spherical balloon.
- [x] Calculate equivalent radius and diameter.
- [x] Implement the MATLAB sphere model.
- [x] Verify volume numerically.

**Result:**

- Radius ≈ 50.83 mm.
- Diameter ≈ 101.65 mm.

### B1.3 — Geometrically Feasible Centre Region

- [x] Define full sphere-containment constraints.
- [x] Calculate feasible balloon-centre limits.
- [x] Generate three-dimensional centre samples.
- [x] Visualise feasible and infeasible centres.
- [x] Verify sampled results.

**Results:**

| Metric | Result |
|---|---:|
| X centre limit | ±89.17 mm |
| Y centre limit | ±99.17 mm |
| Z centre limit | ±109.17 mm |
| Total sampled centres | 29,667 |
| Feasible centres | 6,783 |
| Infeasible centres | 22,884 |

The results assume zero additional clearance and the selected rectangular boundary.

### B1.4 — Candidate Anchor Regions

- [x] Define six continuous boundary-face regions.
- [x] Implement an initial 3 × 3 face-sampling scheme.
- [x] Remove duplicate candidate coordinates.
- [x] Verify candidate points lie on the boundary.
- [x] Produce a three-dimensional visualisation.

**Result:** 26 unique anchor candidates.

The discrete points are an initial sampling set, not a final design restriction.

Physical mounting feasibility remains unresolved.

### B1.5 — Candidate Attachment Regions

- [x] Define body-frame attachment coordinates.
- [x] Parameterise the spherical surface.
- [x] Generate 40 candidate attachment points.
- [x] Verify the surface-radius condition.
- [x] Produce the MATLAB visualisation.

**Result:** 40 attachment candidates.

Maximum recorded radius error: approximately 7.105 × 10⁻¹⁵ mm.

### B1.6 — Geometry Integration

- [x] Combine boundary, balloon, anchor and attachment geometry.
- [x] Verify coordinate transformations.
- [x] Verify numerical geometry constraints.
- [x] Generate the integrated three-dimensional figure.
- [x] Generate the MATLAB geometry dataset locally.

**Result:** Geometry verification passed.

### B1 Completion Statement

The initial simulation geometry is complete.

The following issues are intentionally deferred:

- Physical anchor mounting.
- Attachment mechanism design.
- Cable–sphere and cable–cable interference.
- Cable tension and passive-motion disturbance.
- Hardware feasibility.

These are not considered solved by the B1 geometry verification.

---

## 5. Phase B2 — Six-Cable Configuration Generation

**Status: Initial configuration comparison completed; final configuration not yet selected.**

### B2.1 — Initial Six-Cable Baseline

- [x] Define six face-centre anchors.
- [x] Select six initial attachment points.
- [x] Establish anchor–attachment correspondence.
- [x] Calculate cable lengths.
- [x] Calculate the 6 × 6 measurement Jacobian.
- [x] Evaluate rank and scaled conditioning.

**Recorded results:**

| Metric | Value |
|---|---:|
| Jacobian rank | 6 |
| Scaled minimum singular value | 0.004393 |
| Scaled condition number | 490.956 |

**Finding:** Full rank does not guarantee good sensing conditioning.

### B2.2 — Anchor–Attachment Configuration Comparison

**Status: Completed — Single-pose exploratory comparison.**

#### Experiment A — Fixed Anchors, Variable Attachments

- [x] Keep six face-centre anchors fixed.
- [x] Perform 20,000 random configuration trials.
- [x] Check initial routing constraints.
- [x] Check Jacobian rank.
- [x] Record the best observed scaled condition number.

**Results:**

- Valid random configurations: 46.
- Scaled minimum singular value: 0.535345.
- Best scaled condition number: 3.5759.

#### Experiment B — Variable Anchors and Attachments

- [x] Select six unique anchors from 26 candidates.
- [x] Select six unique attachments from 40 candidates.
- [x] Perform 20,000 random configuration trials.
- [x] Check initial routing constraints.
- [x] Check Jacobian rank.
- [x] Record the best observed configuration.
- [x] Generate a three-configuration MATLAB comparison figure.

**Results:**

- Routing passed: 75.
- Rank passed: 75.
- Scaled minimum singular value: 0.533600.
- Best scaled condition number: 3.2365.

### B2.2 Comparison

| Metric | Baseline | Experiment A | Experiment B |
|---|---:|---:|---:|
| Rank | 6 | 6 | 6 |
| Scaled minimum singular value | 0.004393 | 0.535345 | 0.533600 |
| Scaled condition number | 490.956 | 3.5759 | 3.2365 |
| Random trials | — | 20,000 | 20,000 |
| Valid random samples | — | 46 | 75 |

### B2.2 Key Findings

1. Attachment placement significantly influences local sensing performance.
2. Joint anchor–attachment selection can provide further improvement.
3. Experiment B reduced the observed condition number by approximately 9.49% relative to Experiment A.
4. Experiment B's minimum singular value was slightly lower than Experiment A's.
5. Single-pose random search does not establish workspace-wide performance.
6. The observed best configuration is not necessarily globally optimal.

### Outstanding B2 Tasks

- [ ] Archive the MATLAB comparison figure and configuration datasets in GitHub.
- [ ] Verify both selected configurations over multiple poses.
- [ ] Investigate installation and geometric perturbation sensitivity.
- [ ] Improve the six-cable configuration using workspace-level objectives.
- [ ] Select a validated six-cable reference configuration.

### B2.3 — Seven-Cable Extension

**Status: Deferred.**

Do not begin the seven-cable extension until the six-cable reference configuration has been validated.

Paper 3 Algorithm 1 and Algorithm 2 may be considered at that stage if their WCC assumptions are relevant to the proposed low-tension tracking mechanism.

---


## 6. Phase B3 — Six-Cable Geometric Feasibility Evaluation

**Status: Completed — Initial discrete multi-pose evaluation.**

### Research Question

Which sampled balloon poses are geometrically feasible for the existing Experiment A and Experiment B six-cable configurations?

### B3.1 — Multi-Position Feasibility

**Status: Completed.**

**Test conditions:**

- Balloon-centre coordinates: Px, Py, Pz ∈ {-50, 0, 50} mm.
- Number of positions: 27.
- Orientation: R = I.
- Configurations: Experiment A and Experiment B.
- Cable model: Ideal straight, zero-thickness segments.

**Completed tasks:**

- [x] Load the two six-cable configurations.
- [x] Generate 27 common test positions.
- [x] Verify full balloon containment.
- [x] Calculate cable lengths.
- [x] Evaluate cable–sphere interference.
- [x] Implement and test finite-segment cable–cable distance calculations.
- [x] Calculate geometric feasibility.
- [x] Generate a 3D feasibility comparison.
- [x] Archive code, datasets and research notes.

**Results:**

| Metric | Experiment A | Experiment B |
|---|---:|---:|
| Balloon containment | 27/27 | 27/27 |
| Cable–sphere pass | 8/27 | 27/27 |
| Cable–cable pass | 27/27 | 0/27 |
| Combined geometric pass | 8/27 | 0/27 |
| Minimum cable–cable distance | 10.697497 mm | Approximately 0 mm |

**Findings:**

1. Experiment A is mainly limited by cable–sphere interference involving Cables 2, 4 and 6.
2. Experiment B exhibits contact between Cables 5 and 6 at all 27 zero-rotation positions.
3. Good single-pose Jacobian conditioning does not guarantee multi-position geometric feasibility.

**Research record:**

`06_Research_Log/2026-11/B3_1_feasibility_notes.md`

### B3.2 — Multi-Pose Feasibility

**Status: Completed.**

**Test conditions:**

- The same 27 centre positions as B3.1.
- Seven orientation cases: zero rotation, ±10° roll, ±10° pitch and ±10° yaw.
- Total combined poses: 189.
- Fixed anchor and body-frame attachment coordinates.
- Ideal straight, zero-thickness cables.

**Completed tasks:**

- [x] Define and verify rotation matrices.
- [x] Generate 189 combined translation–rotation poses.
- [x] Recalculate cable lengths at every pose.
- [x] Verify consistency with B3.1 zero-rotation results.
- [x] Evaluate cable–sphere interference.
- [x] Evaluate cable–cable interference.
- [x] Diagnose the principal failure mechanisms.
- [x] Generate orientation-dependent 3D feasibility maps.
- [x] Save MATLAB results and research notes.

**Results:**

| Metric | Experiment A | Experiment B |
|---|---:|---:|
| Cable–sphere pass | 40/189 | 186/189 |
| Cable–cable pass | 189/189 | 108/189 |
| Combined geometric pass | 40/189 | 105/189 |
| Combined sampled pass rate | 21.2% | 55.6% |
| Minimum cable–cable distance | 6.090818 mm | Approximately 0 mm |

**Combined feasibility by orientation:**

| Orientation | Experiment A | Experiment B |
|---|---:|---:|
| Zero rotation | 8/27 | 0/27 |
| Roll +10° | 11/27 | 0/27 |
| Roll -10° | 2/27 | 0/27 |
| Pitch +10° | 4/27 | 25/27 |
| Pitch -10° | 5/27 | 27/27 |
| Yaw +10° | 5/27 | 27/27 |
| Yaw -10° | 5/27 | 26/27 |

**Findings:**

1. Experiment A remains primarily limited by cable–sphere interference, especially Cable 4.
2. Experiment B has 81 cable–cable contact poses, all associated with Cable Pair 5–6.
3. Experiment B's Cable 5–6 contact occurs for all tested centre positions at zero rotation and roll ±10°.
4. No Cable 5–6 numerical contacts were detected for the tested pitch or yaw ±10° cases.
5. Experiment B achieves higher combined geometric feasibility on the declared 189-pose test set.
6. Neither configuration is suitable for final selection without additional sensing and mechanical evaluation.

**Numerical verification:**

- Rotation matrix orthogonality and determinant checks passed.
- Zero-rotation cable-length consistency checks passed.
- Zero-rotation cable-distance consistency checks passed.
- The results remain based on discrete sampling.

**Research record:**

`06_Research_Log/2026-11/B3_2_feasibility_notes.md`

### B3 Completion Statement

The initial six-cable discrete geometric feasibility study is complete.

**Important limitations:**

- No continuous workspace guarantee.
- No simultaneous multi-axis rotation sampling.
- No experimentally validated cable diameter or clearance.
- No physical routing or hardware validation.
- No tension-feasibility or passive-motion disturbance analysis.
- No workspace-wide Jacobian or pose-accuracy evaluation.

**Research Decision:**

Retain Experiment A and Experiment B as reference candidates for B4.

Proceed to workspace-level sensing analysis before undertaking B5 anchor–attachment optimisation.

Do not select a final six-cable configuration based on geometric pass rate alone.

---

## 7. Phase B4 — Six-Cable Sensing Quality

**Status: Planned.**

### Research Question

How accurately and reliably can feasible six-cable configurations reconstruct balloon position and orientation?

### B4.1 — Jacobian and Sensitivity Evaluation

Tasks:

- [ ] Calculate the measurement Jacobian at every sampled pose.
- [ ] Numerically verify the analytical Jacobian for the balloon geometry.
- [ ] Evaluate Jacobian rank.
- [ ] Apply characteristic-length scaling.
- [ ] Calculate scaled singular values.
- [ ] Calculate scaled condition numbers.
- [ ] Identify poorly conditioned pose regions.
- [ ] Calculate local pose covariance under a stated noise model.
- [ ] Compare Experiment A and Experiment B.
- [ ] Investigate sensitivity to selected geometric parameter perturbations.

**Relevant literature:** Paper 4 and N5 — Geometric Calibration and Error Compensation.

**Deliverables:**

- Rank map.
- Singular-value distribution.
- Condition-number distribution.
- Local covariance maps.
- Sensitivity comparison.

**Acceptance criteria:**

- [ ] Measurement and wrench Jacobians are not confused.
- [ ] Translation and rotation scaling is documented.
- [ ] Singular or poorly conditioned poses are identified.
- [ ] Covariance is only calculated or interpreted under its valid assumptions.
- [ ] Local sensitivity is not presented as experimental measurement accuracy.

### B4.2 — Forward Kinematics and Monte Carlo

Tasks:

- [ ] Adapt the existing Phase A4 forward-kinematics code.
- [ ] Reconstruct six-degree-of-freedom poses from simulated cable lengths.
- [ ] Introduce explicitly defined measurement noise.
- [ ] Perform Monte Carlo tests at multiple feasible poses.
- [ ] Calculate position RMSE.
- [ ] Calculate orientation RMSE.
- [ ] Investigate estimator initialisation and convergence.
- [ ] Investigate selected anchor and attachment calibration errors.
- [ ] Compare measured simulation errors with local covariance predictions.
- [ ] Report failed estimates and ambiguous solutions.

**Relevant literature:** Paper 4, N5 and N6 — Direct Cable Length Measurement.

**Initial noise reference:** Independent 1 mm cable-length standard deviation, retained from Phase A as an illustrative simulation assumption.

**Deliverables:**

- Forward-kinematics evaluation script.
- Position and orientation RMSE.
- Estimator convergence statistics.
- Noise and geometry sensitivity results.

**Acceptance criteria:**

- [ ] True poses are not supplied to the estimator as known solutions.
- [ ] Multiple poses are evaluated.
- [ ] Error statistics are reported independently for position and orientation.
- [ ] Failed convergence is documented.
- [ ] Simulation noise is not described as validated hardware accuracy.

---

## 8. Phase B5 — Six-Cable Optimisation and Selection

**Status: Planned.**

### Research Question

Which six-cable arrangement provides the best trade-off between sensing performance, feasible workspace coverage, and implementation complexity?

### B5.1 — Multi-Pose Configuration Improvement

Tasks:

- [ ] Define configuration design variables.
- [ ] Define explicit geometric and sensing constraints.
- [ ] Establish a workspace-based optimisation objective.
- [ ] Compare candidate-search methods.
- [ ] Use the existing A/B configurations as reference solutions.
- [ ] Improve anchor and attachment placement across sampled poses.
- [ ] Record objective-function values and feasibility.
- [ ] Retain multiple promising configurations.
- [ ] Avoid claiming global optimality from random search alone.

**Relevant literature:** Paper 2 and N3 — Multi-Objective Configuration Optimisation.

**Optional later method:** N4 — Response Surface Optimisation.

**Candidate optimisation objectives:**

- Maximise feasible workspace coverage.
- Improve worst-case scaled minimum singular value.
- Minimise worst-case scaled condition number.
- Reduce predicted pose uncertainty.
- Consider physical implementation complexity.

Not every metric must be combined into one weighted objective immediately.

The initial method should remain understandable and reproducible.

**Deliverables:**

- Configuration optimisation script.
- Candidate ranking table.
- Optimisation history.
- Selected promising configurations.

**Acceptance criteria:**

- [ ] Optimisation constraints are explicit.
- [ ] All candidates are evaluated under common pose samples.
- [ ] Invalid configurations are excluded or explicitly penalised.
- [ ] Performance improvements are supported by numerical results.
- [ ] No unverified global-optimality claim is made.

### B5.2 — Six-Cable Reference Selection

Tasks:

- [ ] Compare feasible workspace coverage.
- [ ] Compare Jacobian conditioning.
- [ ] Compare local pose covariance.
- [ ] Compare position and orientation RMSE.
- [ ] Compare geometric and mounting complexity.
- [ ] Evaluate selected configurations on independent validation poses.
- [ ] Record limitations and unresolved constraints.
- [ ] Select a preferred six-cable reference configuration.
- [ ] Save coordinates and cable correspondence.

**Deliverables:**

- Six-Cable Reference Configuration v1.0.
- Configuration comparison table.
- MATLAB parameter dataset.
- Research conclusion and limitations.

**Acceptance criteria:**

- [ ] The selected configuration is numerically reproducible.
- [ ] Multiple feasible poses are evaluated.
- [ ] The selected geometry and performance trade-offs are justified.
- [ ] Independent validation results are documented.
- [ ] Remaining physical uncertainties are stated.

**Important:** A six-cable reference configuration is a validated research baseline, not a guaranteed global optimum.

If the acceptance criteria are not met, continue six-cable investigation instead of prematurely extending the system.

---

## 9. Future Seven- and Eight-Cable Extension

**Status: Deferred until six-cable reference selection.**

### Seven-Cable Study

- [ ] Start from the selected six-cable reference.
- [ ] Introduce the seventh cable as an additional design variable.
- [ ] Evaluate sensing redundancy.
- [ ] Evaluate changes in uncertainty and workspace coverage.
- [ ] Investigate WCC only under explicitly justified mechanical assumptions.
- [ ] Adapt Paper 3 Algorithm 1 and Algorithm 2 when applicable.
- [ ] Consider joint re-optimisation if adding a cable to the fixed six-cable geometry is inadequate.

### Eight-Cable Study

- [ ] Extend the system to eight cable measurements.
- [ ] Compare measurement Jacobian singular values and covariance.
- [ ] Quantify pose-estimation robustness under consistent noise assumptions.
- [ ] Investigate additional mechanical and routing constraints.
- [ ] Compare against the six- and seven-cable configurations.

**Relevant future literature:** Paper 3 and N7 — Overconstrained CDPR Design.

Do not equate additional cables with guaranteed improvement.

The benefit must be established quantitatively.

---


## 10. Seven-Research-Day Execution Plan

**Planning period:** 2026-11-02 to 2026-11-10.

| Date | Task | Expected Output | Status |
|---|---|---|---|
| Nov 2 | B2.2 — Configuration comparison | Initial A/B comparison | Completed |
| Nov 3 | B3.1 — Multi-position feasibility | 27-position geometric evaluation | Completed |
| Nov 3 | B3.2 — Multi-pose feasibility | 189-pose geometric evaluation | Completed |
| Next | B4.1 — Jacobian and sensing sensitivity | Rank, singular values, conditioning, covariance | Next |
| Planned | B5.1 — Multi-pose configuration improvement | Improved six-cable candidates | Planned |
| Planned | B4.2 — FK and Monte Carlo | Pose RMSE and convergence statistics | Planned |
| Planned | B5.2 — Reference configuration selection | Six-cable reference configuration v1.0 | Planned |

**Daily workload:** Approximately 4–5 hours.

Dates for remaining tasks are provisional and may be adjusted according to numerical validation progress.

### Daily Research Workflow

1. State the research question.
2. Identify the minimum required theory or literature method.
3. Implement the MATLAB experiment.
4. Verify numerical results.
5. Explain the physical meaning and limitations.
6. Answer research reflection questions.
7. Archive code, results and research notes.

---

## 11. Current Priority Queue

| Priority | Task | Status |
|---|---|---|
| 1 | B4.1 — Jacobian and sensing quality | Next |
| 2 | B5.1 — Six-cable configuration optimisation | Planned |
| 3 | B4.2 — Pose-estimation accuracy | Planned |
| 4 | B5.2 — Six-cable reference selection | Planned |
| 5 | Seven-/eight-cable extension | Deferred |

**Completed milestones:** B1, B2 initial comparison, B3.1 and B3.2.

---

## 12. Scientific and Modelling Rules

1. Prioritise six-cable validation before adding redundant cables.
2. Treat passive balloon motion as unknown to the estimator.
3. Distinguish anatomical assumptions from engineering model dimensions.
4. Keep world-frame anchors separate from body-frame attachments.
5. Keep the measurement Jacobian distinct from the wrench matrix.
6. Distinguish geometric feasibility, tension feasibility and sensing quality.
7. Do not require WCC without a mechanically justified reason.
8. Use Jacobian rank six as a local identifiability condition only.
9. Apply consistent translation/rotation scaling when comparing Jacobian condition numbers.
10. Use common pose samples, geometric rules and noise models for fair configuration comparisons.
11. Evaluate estimation accuracy rather than relying on condition numbers alone.
12. Treat the predicted covariance as local and model-dependent.
13. Record failed poses, invalid routing and estimator failures.
14. Document numerical thresholds and modelling assumptions.
15. Do not claim global optimality without appropriate evidence.
16. Use literature methods when they solve the current research question.

---

## 13. Research Output Convention

Use the existing repository structure.

| Output | Location |
|---|---|
| MATLAB scripts | `04_Code_Exercises/MATLAB/` |
| Research models and configuration definitions | `05_My_Research/` |
| Experiment results and explanations | `06_Research_Log/2026-11/` |
| Research task planning | `08_Project_Management/` |
| Literature method selection | `02_Paper_Reading/Literature_Review/` |

### Recommended Outputs per Task

- MATLAB `.m` script.
- Relevant `.png` figure.
- Numerical summary or `.mat` dataset.
- Short `.md` research note.
- Explicit assumptions, limitations and next action.

Avoid duplicating the same detailed experimental results across multiple project files.

Update `CURRENT_STATE2.md` only when a meaningful research milestone is reached.

---

## 14. Related Files

### Project Management

- [Research Roadmap](Roadmap.md)
- [Previous Phase A Plan](weekly_plan_02.md)
- [Current Research State](../CURRENT_STATE2.md)

### Research Models

- [Rigid-Body Sensing Design](../05_My_Research/Rigid_Body_Sensing_Design.md)
- [Sensing Objective](../05_My_Research/Sensing_Objective_v0.2.md)
- [Workspace Boundary](../05_My_Research/Workspace_Boundary_v0.2_2026-10-20.md)

### Literature

- [Phase A Methods](../02_Paper_Reading/Literature_Review/workspace%20definition/anchor%20point%20and%20attachment%20point%20define.md)
- `02_Paper_Reading/Literature_Review/Phase_B_Method_Selection_2026-11-02.md` — companion literature method-selection document, to be linked once committed.

### Research Logs

- [October Research Log](../06_Research_Log/2026-10/)
- `06_Research_Log/2026-11/` — current experiment logs, to be archived.

---


## 15. Immediate Next Action

**B4.1 — Six-Cable Jacobian and Sensing Quality Evaluation**

### Research Question

Can the existing Experiment A and Experiment B configurations provide locally identifiable and sufficiently sensitive 6-DOF pose measurements across their geometrically feasible sampled poses?

### Planned Evaluation

1. Load the saved 189-pose B3.2 dataset.
2. Reuse the fixed Experiment A/B anchor–attachment configurations.
3. Calculate the measurement Jacobian at every sampled pose.
4. Verify the analytical Jacobian numerically.
5. Evaluate rank and characteristic-length-scaled singular values.
6. Calculate condition numbers.
7. Evaluate local pose covariance using an explicitly defined cable-length noise model.
8. Compare sensing quality over geometrically feasible poses.
9. Record singular and poorly conditioned poses separately.
10. Prepare evidence for the B5 optimisation objectives.

### Important Evaluation Rules

- Do not modify the selected anchor or attachment coordinates during B4.1.
- Preserve results for all 189 poses, including geometrically infeasible poses, for diagnostic purposes.
- Report sensing metrics for geometrically feasible subsets separately.
- Compare Experiment A and Experiment B using common criteria.
- Do not interpret assumed sensor noise as experimentally calibrated accuracy.
- Do not interpret Jacobian rank six as proof of globally unique pose reconstruction.
- Do not treat geometric feasibility as proof of tension feasibility.

### Expected Deliverables

- MATLAB Jacobian and sensitivity evaluation script.
- Pose-level sensing quality results.
- Jacobian rank and singular-value distributions.
- Condition-number comparison.
- Local pose covariance analysis.
- B4.1 research notes.

### Research Decision

Complete B4.1 before selecting new anchor–attachment configurations.

Use the combined B3 and B4 findings to define the constraints and objectives for B5.

---

**Current Milestone:** Establish a numerically justified six-cable reference configuration before expanding to seven or eight cables.


---

**Current Milestone:** Establish a numerically justified six-cable reference configuration before expanding to seven or eight cables.
