# Weekly Research Plan

**Last Updated:** 2026-10-16  
**Current Phase:** Phase 2 — Simplified Model and Sensing Objective  
**Research Focus:** Rigid-Body Position Sensing

---

## Week 1 — 19–25 October 2026

### Weekly Objective

**Define and verify the simplified gastric sensing model.**

Research focus:

- 550 mL rigid spherical object
- Simplified gastric movement boundary
- Initial position sensing objective
- Cable measurement model and state estimation

**Related TODO:** Tasks 2.1–2.4

### Daily Plan

- [ ] **Monday, 19 Oct — Sensing Objective (Task 2.1)**  
  Define the initial position state, orientation constraints, and preliminary accuracy requirements.  
  **Output:** `Sensing_Objective_v0.1.md`

- [ ] **Tuesday, 20 Oct — Simplified Geometry (Task 2.2)**  
  Model the 550 mL rigid sphere and a simplified gastric boundary using sourced dimensions or clearly labelled assumptions. Identify a feasible planar test region.  
  **Output:** MATLAB geometry model and figure.

- [ ] **Wednesday, 21 Oct — Cable Geometry (Task 2.2)**  
  Adapt the existing four-cable reference model to the selected object and test region. Calculate cable lengths and visualise the arrangement.  
  **Output:** `rigid_geometry_v01.m`

- [ ] **Thursday, 22 Oct — Measurement Jacobian (Task 2.3)**  
  Calculate and numerically verify the Jacobian. Check rank, sensitivity, and measurement coupling.  
  **Output:** `jacobian_verification_v01.m`

- [ ] **Friday, 23 Oct — State Estimation (Task 2.4)**  
  Estimate object position from simulated cable measurements and compare estimates with reference positions.  
  **Output:** `rigid_state_estimation_v01.m`

- [ ] **Saturday, 24 Oct — Simulation Validation (Task 2.4)**  
  Test different positions and initial guesses. Record estimation errors, ambiguities, and limitations.  
  **Output:** Week 1 simulation results.

- [ ] **Sunday, 25 Oct — Weekly Review**  
  Review results, update TODO and Current State, and record the next research decision.  
  **Output:** Week 1 research summary.

### Weekly Completion Criteria

- Initial measurement state and constraints are defined.
- Simplified gastric and rigid-sphere geometry are established.
- Cable-length and Jacobian calculations are verified.
- Initial position-estimation results are available.
- Unresolved modelling and estimation problems are recorded.

### Weekly Review

**Completed:** Pending

**Main Findings:** Pending

**Problems / Limitations:** Pending

**Next Research Decision:** Pending

---

## Week 2 — 26 October–1 November 2026

### Weekly Objective

**Investigate cable configuration and measurement performance.**

Research focus:

- Cable number
- Anchor placement
- Attachment placement
- Sensing accuracy and workspace coverage

**Related TODO:** Tasks 3.1–3.4

### Daily Plan

- [ ] **Monday, 26 Oct — Cable Number (Task 3.1)**  
  Compare candidate cable numbers using Jacobian rank and state-estimation performance.  
  **Output:** Cable-number comparison results.

- [ ] **Tuesday, 27 Oct — Anchor Placement (Task 3.2)**  
  Compare symmetric and asymmetric anchor arrangements under common evaluation conditions.  
  **Output:** Anchor-placement comparison plots.

- [ ] **Wednesday, 28 Oct — Attachment Placement (Task 3.3)**  
  Investigate how attachment locations affect measurement sensitivity and coupling.  
  **Output:** Attachment-placement comparison results.

- [ ] **Thursday, 29 Oct — Sensing Workspace (Task 3.4)**  
  Evaluate sensing quality over the geometrically feasible test region.  
  **Output:** MATLAB sensing workspace maps.

- [ ] **Friday, 30 Oct — Measurement Accuracy (Task 3.4)**  
  Introduce a common cable-measurement noise model. Compare position RMSE and robustness across configurations.  
  **Output:** Estimation-error comparison plots.

- [ ] **Saturday, 31 Oct — Configuration Evaluation**  
  Compare cable number, placement, accuracy, workspace coverage, and practical limitations. Identify promising candidate configurations.  
  **Output:** `Cable_Configuration_Study_v0.1.md`

- [ ] **Sunday, 1 Nov — Weekly Review**  
  Summarise findings, update GitHub documents, and identify requirements for the next experimental stage.  
  **Output:** Week 2 research summary.

### Weekly Completion Criteria

- Candidate cable numbers have been compared.
- Anchor and attachment layouts have been evaluated.
- Poorly observable configurations have been identified.
- Estimation accuracy and sensing workspace coverage have been assessed.
- Preliminary configuration recommendations and limitations are documented.

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
