# Research TODO

Last updated: 2026-10-16

**Current Phase:** Phase 2 — Sensing Objective and Rigid-Body Model

**Next Phase:** Phase 3 — Cable Configuration and Sensing Quality

**Primary Platform:** MATLAB

---

# 1. Current Research Priority

## Main Research Question

> For a simplified rigid object, how many cables are needed, and where should anchors and attachment points be located to achieve a specified measurement accuracy?

## Current Strategy

- Begin with a simplified rigid-body model.
- Define the sensing objective before selecting cable number.
- Use simple, repeatable motion scenarios.
- Estimate object states from cable measurements.
- Compare estimated states with independent ground truth.
- Extend to deformable-balloon sensing after rigid-body validation.

---

# 2. Completed or Previously Explored Work

## Cable-Robot Fundamentals

- [x] Define anchor and attachment points.
- [x] Implement coordinate transformations.
- [x] Calculate cable vectors and lengths.
- [x] Derive and implement the measurement Jacobian.
- [x] Study cable-length velocity and acceleration.
- [x] Develop planar rigid-body dynamics simulations.
- [x] Investigate tension and wrench feasibility.
- [x] Explore geometric and tension-feasible workspace.
- [x] Investigate sensing sensitivity and measurement-pattern similarity.
- [x] Explore forward kinematics.
- [x] Set up and investigate planar CASPR examples.

These activities provide the mathematical foundation for the new research tasks. They do not imply that the final measurement system has been validated.

## Clinical Evidence

- [x] Review clinical monitoring practices.
- [x] Investigate balloon volume and morphology.
- [x] Investigate migration and position-related complications.
- [x] Collect reported and derived physical size references.
- [x] Prepare Evidence A–D synthesis.
- [x] Establish Workspace Definition — Draft 1.0.

**Remaining limitation:** Normal gastric motion, collapse dimensions, and complete three-dimensional shape boundaries are not yet established.

---

# 3. Phase 2 — Sensing Objective and Rigid-Body Measurement Model

**Status: Current Priority**

## Task 2.1 — Define the Initial Measurement Objective

Research Question:

> What rigid-body state must the first cable sensing system estimate?

- [ ] Compare position-only and planar-pose estimation objectives.
- [ ] Select the initial state vector.
- [ ] Determine the required degrees of freedom.
- [ ] Define which variables are measured and which are estimated.
- [ ] Define the assumptions required to constrain unmeasured motion.
- [ ] Specify the initial measurement accuracy requirements.

Candidate state models:

Position-only:

\[
q=[x,y]^T
\]

Planar pose:

\[
q=[x,y,\theta]^T
\]

**Deliverable:**

- Selected state vector
- Measurement objective
- Assumptions and justification

**Completion criterion:** The initial estimated variables and acceptable estimation errors are explicitly defined.

---

## Task 2.2 — Define the Rigid-Body Geometry

Research Question:

> How does rigid-body position and orientation affect cable lengths?

- [ ] Select a simplified rigid-body test object.
- [ ] Define the world coordinate system.
- [ ] Define the body coordinate system.
- [ ] Define candidate external anchor locations.
- [ ] Define object attachment locations.
- [ ] Calculate world-frame attachment coordinates.
- [ ] Calculate cable vectors.
- [ ] Calculate cable lengths.
- [ ] Create a MATLAB geometry visualization.

Initial geometry model:

\[
B_i=P+R(\theta)r_i
\]

\[
L_i=\|A_i-B_i\|
\]

**Deliverable:**

- Geometry diagram
- MATLAB measurement-geometry model
- Documented coordinate definitions

**Completion criterion:** Given a rigid-body state, the model calculates and visualizes all cable lengths correctly.

---

## Task 2.3 — Verify the Measurement Jacobian

Research Question:

> How sensitive are cable-length measurements to changes in the object state?

- [ ] Derive the Jacobian for the selected state model.
- [ ] Verify Jacobian dimensions and sign convention.
- [ ] Calculate cable-length sensitivity.
- [ ] Compare numerical and analytical derivatives.
- [ ] Test the local linear measurement relationship.
- [ ] Identify configurations with insufficient independent measurement information.

Local measurement relationship:

\[
\Delta L \approx H(q)\Delta q
\]

where:

\[
H(q)=\frac{\partial L}{\partial q}
\]

For the existing MATLAB convention:

\[
H(q)=J(q)^T
\]

**Deliverable:**

- Verified measurement Jacobian
- MATLAB sensitivity test
- Numerical error comparison

**Completion criterion:** Analytical sensitivity agrees with finite-difference calculations within a documented numerical tolerance.

---

## Task 2.4 — Establish State Estimation

Research Question:

> Can the unknown rigid-body state be estimated from cable-length measurements?

- [ ] Define simulated cable measurements.
- [ ] Implement the forward measurement model.
- [ ] Implement a numerical state-estimation method.
- [ ] Test estimation from known static positions.
- [ ] Investigate dependence on initial guesses.
- [ ] Compare estimated and true states.
- [ ] Document ambiguous or non-unique solutions.

Measurement model:

\[
y=h(q)+\varepsilon
\]

where:

- \(y\): measured cable lengths
- \(h(q)\): predicted cable lengths
- \(\varepsilon\): measurement noise

**Deliverable:**

- MATLAB forward measurement function
- MATLAB state estimator
- Initial estimation-error results

**Completion criterion:** The estimator reconstructs selected test states without using their true values as estimator inputs.

---

# 4. Phase 3 — Cable Configuration and Sensing Quality

**Status: Next Priority**

## Task 3.1 — Investigate Cable Number

Research Question:

> What is the minimum number of independent cable measurements required for the selected state?

- [ ] Define candidate cable numbers.
- [ ] Derive the measurement matrix for each configuration.
- [ ] Calculate matrix rank.
- [ ] Identify rank-deficient configurations.
- [ ] Evaluate redundancy.
- [ ] Distinguish local identifiability from global uniqueness.
- [ ] Compare results across a specified test region.

**Deliverable:**

- Cable-number comparison table
- Rank and identifiability analysis
- MATLAB simulation results

**Completion criterion:** Candidate cable numbers are justified using the selected state dimension and measurement information.

---

## Task 3.2 — Investigate Anchor-Point Placement

Research Question:

> How does external anchor placement affect state-estimation quality?

- [ ] Define candidate anchor arrangements.
- [ ] Calculate Jacobians for each arrangement.
- [ ] Compare measurement sensitivity.
- [ ] Calculate singular values.
- [ ] Calculate condition numbers.
- [ ] Investigate poorly observable regions.
- [ ] Compare estimation uncertainty under a common noise model.

**Deliverable:**

- Anchor-configuration diagrams
- Sensing-quality comparison
- Preliminary preferred anchor layout

**Completion criterion:** Anchor-layout differences are supported by quantitative results.

---

## Task 3.3 — Investigate Attachment-Point Placement

Research Question:

> Where should cables connect to the measured object?

- [ ] Define candidate rigid-body attachment locations.
- [ ] Compare symmetric and asymmetric attachment arrangements.
- [ ] Investigate translational sensitivity.
- [ ] Investigate rotational sensitivity, if applicable.
- [ ] Identify coupled measurement patterns.
- [ ] Evaluate attachment feasibility.
- [ ] Document implications for a later deformable balloon.

**Deliverable:**

- Attachment-layout comparison
- MATLAB sensitivity results
- Preliminary attachment recommendation

**Completion criterion:** The selected layout supports the required state measurements over the target region.

---

## Task 3.4 — Define Preliminary Sensing Workspace

Research Question:

> In which regions can the selected cable configuration estimate object states reliably?

- [ ] Define the candidate test region.
- [ ] Sample object positions and orientations.
- [ ] Calculate Jacobian rank throughout the region.
- [ ] Evaluate singular values and conditioning.
- [ ] Include measurement-noise assumptions.
- [ ] Define an explicit sensing-quality acceptance criterion.
- [ ] Visualize sensing-feasible regions.
- [ ] Compare sensing feasibility with mechanical constraints.

**Deliverable:**

- MATLAB sensing workspace map
- Feasible-region comparison
- Documented sensing thresholds

**Completion criterion:** The usable sensing region is defined using explicit, justified evaluation criteria.

---

# 5. Phase 4 — Rigid-Body Measurement Validation

**Status: Planned**

## Task 4.1 — Reference Platform and Hardware

- [ ] Review the reference robot previously demonstrated by Peter.
- [ ] Identify its relevant geometry and sensing components.
- [ ] Decide whether reproduction or adaptation is appropriate.
- [ ] Select candidate cable-length sensors.
- [ ] Evaluate required sensor resolution.
- [ ] Investigate cable attachment hardware.
- [ ] Design an independent ground-truth measurement method.

**Deliverable:** Preliminary experimental system specification.

## Task 4.2 — Static Measurement Experiments

- [ ] Measure cable lengths at known rigid-body positions.
- [ ] Calibrate sensors.
- [ ] Estimate object state.
- [ ] Calculate estimation error.
- [ ] Evaluate measurement repeatability.

**Deliverable:** Static state-estimation validation results.

## Task 4.3 — Simple Motion Experiments

- [ ] Generate repeatable straight-line motion.
- [ ] Test different motion directions.
- [ ] Test different velocities.
- [ ] Acquire cable measurements.
- [ ] Estimate position and, if applicable, orientation.
- [ ] Compare estimates with ground truth.
- [ ] Calculate RMSE, maximum error, and bias.

**Deliverable:** Rigid-body motion-measurement validation report.

---

# 6. Phase 5 — Deformable-Balloon Extension

**Status: Future**

- [ ] Define simplified deformation scenarios.
- [ ] Investigate balloon materials and attachment mechanisms.
- [ ] Define deformation state variables.
- [ ] Determine whether additional measurements are required.
- [ ] Extend the measurement model.
- [ ] Investigate existing reconstruction information from Siqi.
- [ ] Perform simplified inflation and deflation tests.
- [ ] Investigate asymmetric deformation.
- [ ] Compare reconstructed states with independent measurements.
- [ ] Quantify deformation-estimation error.

---

# 7. Phase 6 — Integrated Evaluation

**Status: Future**

- [ ] Combine rigid-body motion and deformation estimation.
- [ ] Introduce irregular passive-motion scenarios.
- [ ] Investigate measurement uncertainty.
- [ ] Evaluate sensing-workspace limitations.
- [ ] Investigate repeatability and robustness.
- [ ] Identify failure cases.
- [ ] Summarize research contributions and limitations.

---

# 8. Immediate Next Actions

Work on these tasks in order:

1. **Task 2.1:** Select the initial state model and measurement objective.
2. **Task 2.2:** Establish and verify the rigid-body geometry.
3. **Task 2.3:** Verify the corresponding measurement Jacobian.
4. **Task 2.4:** Implement and test rigid-body state estimation.
5. **Task 3.1:** Begin the cable-number and configuration comparison.

Do not begin with motor selection or full balloon shape reconstruction before the relevant sensing requirements are established.

---

# 9. Previous Learning Tasks

The original TODO included:

- Complete Lesson 1.3
- Finish MATLAB wrench matrix exercise
- Understand CASPR trajectory generation
- Build square trajectory in CASPR
- Study cable robot kinematics

These tasks are retained as historical learning references rather than current high-priority tasks.

Any incomplete item can be revisited when required by a specific research question.

---

# 10. Task Completion Rules

A task should be marked complete only when:

- Its research question has been answered to the intended scope.
- The assumptions and mathematical model are documented.
- The required MATLAB implementation or analysis exists.
- Results have been checked against a reference or independent validation method.
- Limitations and unresolved problems are recorded.
- The next research decision is identified.

**Research rule:**

> Every completed task should produce a result that supports a concrete research or engineering decision.

---
