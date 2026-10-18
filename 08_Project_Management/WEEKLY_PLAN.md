# Weekly Research Plan

**Last Updated:** 2026-10-19  
**Current Phase:** Phase 2 — 3D Rigid-Body Sensing Foundation  
**Research Focus:** 6-DOF Pose Estimation and Cable Configuration Design

---

## Week 1 — 19–25 October 2026

### Weekly Objective

<!-- UPDATED: Changed from planar sensing to 3D 6-DOF measurement. -->

**Establish and verify the initial 3D rigid-body sensing model.**

Research focus:

- 550 mL rigid spherical object.
- Simplified 3D gastric boundary.
- 6-DOF rigid-body pose.
- Three-dimensional cable geometry.
- Cable-length measurement Jacobian.
- Initial 6-DOF pose estimation.

**Related TODO:** Tasks 2.1–2.4

### Daily Plan

- [x] **Monday, 19 Oct — Sensing Objective (Task 2.1)**  
  Define the 3D 6-DOF sensing state, passive-motion assumptions, measurement principle, and cable-number study range.  
  **Output:** `Sensing_Objective_v0.2.md`  
  **Status:** Research scope defined; validation pending.

- [ ] **Tuesday, 20 Oct — 3D Gastric Geometry (Task 2.2)**  
  Review gastric length, width, and height evidence. Select preliminary dimensions or explicitly documented assumptions. Construct the simplified 3D boundary and rigid sphere.  
  **Output:** Gastric dimension evidence table and initial 3D geometry figure.

- [ ] **Wednesday, 21 Oct — 3D Cable Geometry (Tasks 2.2–2.3)**  
  Define a preliminary six-cable reference layout with 3D anchor and attachment points. Calculate cable lengths and visualise the configuration.  
  **Output:** `rigid_geometry_3D_v01.m`

- [ ] **Thursday, 22 Oct — 6-DOF Jacobian (Task 2.3)**  
  Implement the analytical cable-length Jacobian for three translations and three rotations. Verify simple single-axis motions.  
  **Output:** `jacobian_6DOF_v01.m`

- [ ] **Friday, 23 Oct — Initial Pose Estimation (Task 2.4)**  
  Implement an initial nonlinear estimator to recover 3D position and orientation from simulated cable-length measurements. Begin with noise-free reference poses.  
  **Output:** `pose_estimation_6DOF_v01.m`

- [ ] **Saturday, 24 Oct — Model Verification (Tasks 2.3–2.4)**  
  Compare analytical and numerical Jacobians. Test multiple reference poses and initial estimates. Record estimation errors and failures.  
  **Output:** Week 1 MATLAB verification results.

- [ ] **Sunday, 25 Oct — Weekly Review**  
  Review completed work, record unresolved problems, and update research documents.  
  **Output:** Week 1 research summary.

### Weekly Completion Criteria

- The 3D 6-DOF sensing objective is documented.
- A simplified gastric boundary and rigid-sphere model are available.
- Initial 3D anchor and attachment coordinates are defined.
- Cable-length calculations are implemented.
- The 6-DOF Jacobian has been numerically checked.
- An initial pose-estimation attempt is documented.
- Remaining geometry, identifiability, and estimation problems are recorded.

A working pose estimator is a target, not a prerequisite for reporting partial progress. Failed or ambiguous estimation cases should be retained for analysis.

### Weekly Review

**Completed:** Pending

**Main Findings:** Pending

**Problems / Limitations:** Pending

**Next Research Decision:** Pending

---

## Week 2 — 26 October–1 November 2026

### Weekly Objective

<!-- UPDATED: Focused on preliminary 7/8-cable comparison with a 6-cable baseline. -->

**Investigate preliminary 3D cable configurations and sensing performance.**

Research focus:

- Six-cable reference baseline.
- Seven- and eight-cable primary candidates.
- 3D anchor placement.
- 3D attachment placement.
- Pose-estimation accuracy.
- Sensing workspace coverage.
- Initial physical-feasibility constraints.

**Related TODO:** Tasks 3.1–3.5

### Daily Plan

- [ ] **Monday, 26 Oct — Cable Number Comparison (Task 3.1)**  
  Construct preliminary six-, seven-, and eight-cable layouts using consistent geometric rules. Compare Jacobian rank and scaled conditioning at selected reference poses.  
  **Output:** Initial cable-number comparison table and plots.

- [ ] **Tuesday, 27 Oct — 3D Anchor Placement (Task 3.2)**  
  Compare selected symmetric and asymmetric 3D anchor arrangements for seven- and eight-cable configurations. Evaluate measurement sensitivity and rank.  
  **Output:** Anchor-placement comparison plots.

- [ ] **Wednesday, 28 Oct — 3D Attachment Placement (Task 3.3)**  
  Compare different attachment distributions on the sphere. Investigate rotational sensitivity, translation–rotation coupling, and pose ambiguity.  
  **Output:** Attachment-placement comparison results.

- [ ] **Thursday, 29 Oct — Sensing Workspace (Task 3.4)**  
  Sample feasible 3D object positions and orientations. Evaluate Jacobian rank and conditioning over the selected pose domain.  
  **Output:** Preliminary sensing-quality and workspace visualisations.

- [ ] **Friday, 30 Oct — Measurement Accuracy (Task 3.4)**  
  Introduce a common simulated cable-length noise model. Evaluate position RMSE, orientation RMSE, and estimation reliability for selected configurations.  
  **Output:** Pose-estimation error comparison plots.

- [ ] **Saturday, 31 Oct — Configuration Evaluation (Tasks 3.4–3.5)**  
  Compare promising seven- and eight-cable layouts. Perform preliminary checks of cable routing, tension feasibility, and potential passive-motion disturbance.  
  **Output:** `Cable_Configuration_Study_v0.1.md`

- [ ] **Sunday, 1 Nov — Weekly Review**  
  Summarise results, update GitHub research documents, and identify priorities for deeper configuration optimisation and physical validation.  
  **Output:** Week 2 research summary.

### Weekly Completion Criteria

- Six-, seven-, and eight-cable reference layouts are available.
- Initial cable-number effects have been compared.
- Selected 3D anchor and attachment configurations have been evaluated.
- Jacobian-based sensing quality has been mapped over a defined pose domain.
- Preliminary pose-estimation errors have been quantified where feasible.
- Mechanical constraints and unresolved physical-feasibility issues have been documented.
- Promising seven- and eight-cable configurations have been identified for further investigation.

**Scope Note:** The objective is a preliminary configuration study, not final global optimisation or experimental proof of an optimal design.

### Weekly Review

**Completed:** Pending

**Main Findings:** Pending

**Problems / Limitations:** Pending

**Next Research Decision:** Pending

---

## Weekly Planning Rules

1. Each day should focus on one main research task.
2. Each task should produce a measurable or reviewable output.
3. Mark tasks complete only after checking results.
4. Record unfinished tasks and adjust the following week.
5. Preserve previous weekly plans.
6. Update research progress and decisions after each week.
7. Distinguish analytical, simulated, and experimentally validated results.
8. Adjust the schedule when 3D modelling or verification requires additional time.

Detailed task definitions are maintained in [TODO.md](TODO.md).

Research milestones are maintained in [Roadmap.md](Roadmap.md).

---

## Future Weekly Plan Template

### Week X — Date Range

**Weekly Objective:** To be defined.  
**Related TODO:** To be defined.

### Daily Plan

- [ ] **Monday — Task:** Description. **Output:** Deliverable.
- [ ] **Tuesday — Task:** Description. **Output:** Deliverable.
- [ ] **Wednesday — Task:** Description. **Output:** Deliverable.
- [ ] **Thursday — Task:** Description. **Output:** Deliverable.
- [ ] **Friday — Task:** Description. **Output:** Deliverable.
- [ ] **Saturday — Task:** Description. **Output:** Deliverable.
- [ ] **Sunday — Weekly Review:** Summary and GitHub update.

### Weekly Review

**Completed:**

**Main Findings:**

**Problems / Limitations:**

**Next Research Decision:**

---
