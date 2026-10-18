# Research TODO

**Last Updated:** 2026-10-19  
**Current Phase:** Phase 2 — 3D Rigid-Body Sensing Foundation  
**Next Phase:** Phase 3 — Cable Configuration and Sensing Quality

---

## 1. Current Research Objective

<!-- UPDATED: 3D 6-DOF pose sensing replaces planar position-only sensing. -->

**Research Question:**

> How do seven- and eight-cable configurations affect the accuracy, identifiability, and feasible sensing workspace of a passively moving 6-DOF rigid spherical object?

**Research Baseline:**

- Environment: Simplified 3D adult female gastric boundary.
- Object: 550 mL rigid sphere (equivalent diameter ≈ 101.7 mm).
- State: 3D position and orientation (6-DOF).
- Motion: Passive and unknown.
- Measurements: Cable lengths.
- Cable number: 6 baseline; 7 and 8 primary candidates.
- Tracking: Motor-assisted low-tension cable tracking.
- Evaluation: Pose identifiability, accuracy, workspace coverage, and physical feasibility.

Detailed research decisions and literature justification are recorded in [Sensing Objective v0.2](../05_My_Research/Sensing_Objective_v0.2.md).

---

## 2. Phase 2 — 3D Measurement Foundation

### Task 2.1 — Define Sensing Objective

<!-- UPDATED: Monday research decisions confirmed. -->

- [x] Define the 3D 6-DOF rigid-body state.
- [x] Identify measured and estimated quantities.
- [x] Establish passive-motion and low-tension tracking assumptions.
- [x] Select cable-number study range: 6 baseline, 7 and 8 primary.
- [x] Define measurement evaluation metrics without unsupported accuracy thresholds.
- [x] Document research scope and limitations.

**Output:** `Sensing_Objective_v0.2.md`

**Status:** Research definition completed; model and performance validation pending.

**Done when:** The sensing objective, state variables, design scope, assumptions, and initial evaluation metrics are documented.

---

### Task 2.2 — Define Simplified 3D Geometry

<!-- UPDATED: Direct 3D workspace development. -->

- [ ] Review adult female gastric dimension studies, prioritising obesity-related evidence.
- [ ] Select gastric length, width, and height references or documented engineering assumptions.
- [ ] Construct the simplified 3D gastric boundary.
- [ ] Construct the 550 mL rigid sphere.
- [ ] Calculate the feasible sphere-centre region.
- [ ] Verify sphere containment and physical units.
- [ ] Visualise the geometric model in MATLAB.

**Output:** Gastric geometry evidence table, MATLAB 3D model, and geometry figure.

**Done when:** The boundary, sphere dimensions, feasible centre region, and modelling assumptions are documented and checked.

---

### Task 2.3 — Verify 6-DOF Measurement Model

<!-- UPDATED: 6-DOF Jacobian replaces the planar Jacobian. -->

- [ ] Define initial 3D anchor and attachment coordinates.
- [ ] Calculate cable vectors and lengths.
- [ ] Derive the 6-DOF measurement Jacobian.
- [ ] Verify analytical derivatives using finite differences.
- [ ] Check Jacobian rank and scaled conditioning.
- [ ] Investigate translation–rotation measurement coupling.

**Output:** MATLAB cable geometry and Jacobian verification.

**Done when:** Analytical and numerical Jacobians agree within a documented tolerance, and local identifiability limitations are recorded.

---

### Task 2.4 — Establish 6-DOF Pose Estimation

<!-- UPDATED: Position and orientation estimation. -->

- [ ] Implement an initial nonlinear pose estimator.
- [ ] Estimate 3D position and orientation from simulated cable lengths.
- [ ] Test multiple reference poses and initial guesses.
- [ ] Investigate ambiguous solutions and convergence failures.
- [ ] Calculate position and orientation errors.
- [ ] Record model limitations.

**Output:** Initial MATLAB 6-DOF pose estimator and verification results.

**Done when:** Estimated poses are compared with reference poses without supplying the true pose or trajectory to the estimator.

---

## 3. Phase 3 — Cable Configuration and Sensing Quality

### Task 3.1 — Compare Cable Number

<!-- UPDATED: Six-cable baseline; seven- and eight-cable primary comparison. -->

- [ ] Establish a six-cable baseline configuration.
- [ ] Generate candidate seven- and eight-cable configurations.
- [ ] Use consistent pose samples, sensor-noise assumptions, and layout rules.
- [ ] Compare Jacobian rank, conditioning, and pose-estimation performance.
- [ ] Assess the benefit of measurement redundancy.
- [ ] Document limitations of each cable count.

**Output:** Six-, seven-, and eight-cable comparison results.

**Done when:** The effect of cable number on sensing performance has been quantitatively evaluated under comparable conditions.

---

### Task 3.2 — Compare 3D Anchor Placement

<!-- UPDATED: Three-dimensional anchor arrangements. -->

- [ ] Define feasible 3D anchor mounting regions.
- [ ] Generate alternative anchor arrangements.
- [ ] Evaluate pose-estimation accuracy and measurement conditioning.
- [ ] Identify poorly conditioned configurations.
- [ ] Assess geometric and mounting constraints.

**Output:** Anchor-placement comparison and sensing-quality plots.

**Done when:** Candidate anchor arrangements are quantitatively evaluated and their limitations recorded.

---

### Task 3.3 — Compare 3D Attachment Placement

<!-- UPDATED: Three-dimensional attachment distributions. -->

- [ ] Define candidate attachment locations on the rigid sphere.
- [ ] Generate symmetric and asymmetric attachment arrangements.
- [ ] Evaluate translational and rotational measurement sensitivity.
- [ ] Investigate pose ambiguities.
- [ ] Check attachment and cable-routing feasibility.

**Output:** Attachment-placement comparison results.

**Done when:** Attachment layouts are evaluated for pose identifiability, measurement performance, and physical constraints.

---

### Task 3.4 — Evaluate Sensing Workspace and Accuracy

<!-- UPDATED: Full pose-space evaluation. -->

- [ ] Define the sampled 6-DOF pose domain.
- [ ] Evaluate candidate configurations throughout the feasible domain.
- [ ] Apply consistent cable-length noise models.
- [ ] Calculate position and orientation RMSE.
- [ ] Evaluate estimation success rate and ambiguity.
- [ ] Calculate sensing workspace coverage using explicit criteria.
- [ ] Compare the best seven- and eight-cable configurations.

**Output:** 3D sensing-quality maps, pose-error results, and preliminary configuration recommendation.

**Done when:** Candidate configurations are compared using documented measurement and workspace metrics.

---

### Task 3.5 — Assess Low-Tension Physical Feasibility

<!-- NEW: Motor-assisted tracking and passive-motion constraints. -->

- [ ] Define preliminary cable-tension requirements.
- [ ] Investigate slack prevention and cable payout.
- [ ] Check cable routing and interference.
- [ ] Evaluate cable-induced forces and torques.
- [ ] Identify motor and sensor requirements.
- [ ] Investigate disturbance to passive object motion.

**Output:** Preliminary low-tension tracking and mechanical-feasibility assessment.

**Done when:** Major physical limitations and their implications for the preferred cable configuration are documented.

---

## 4. Current Priority

<!-- UPDATED: New 3D research execution sequence. -->

**Current Task: 2.2 — Define Simplified 3D Geometry**

Task 2.1 has established the research scope.

Continue in the following order:

**2.2 → 2.3 → 2.4 → 3.1 → 3.2 → 3.3 → 3.4 → 3.5**

The initial MATLAB model should prioritise simple, reproducible 3D geometry and pose-estimation verification.

Mechanical feasibility should be considered during configuration design and evaluated more systematically in Task 3.5.

Reuse previous MATLAB kinematics and Jacobian code where appropriate.

Detailed scheduling is maintained in [WEEKLY_PLAN.md](WEEKLY_PLAN.md).

Research phases and milestones are maintained in [Roadmap.md](Roadmap.md).

---

## 5. Task Completion Rules

Mark a task complete only when:

1. The required document, model, code, or analysis is available.
2. Results have been checked.
3. Assumptions and limitations are documented.
4. The output supports a research or design decision.

Update [CURRENT_STATE2.md](../CURRENT_STATE2.md) after significant progress.

Record important research decisions and results in [06_Research_Log](../06_Research_Log/).

Do not mark simulation or experimental validation complete without verified results.

---

**Next Task:** 2.2 — Define the simplified 3D gastric boundary and geometrically feasible rigid-sphere movement region.
