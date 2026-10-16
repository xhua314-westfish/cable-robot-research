# Weekly Research Plan

**Research Topic:** Cable-Robot-Based Sensing for a Passive Deformable Balloon

**Current Phase:** Phase 2 — Sensing Objective and Rigid-Body Model

**Last Updated:** 2026-10-16

---

# Week 1 — 19–25 October 2026

## Weekly Objective

**Define and verify the initial rigid-body sensing model.**

Research Questions:

- What state variables should the first sensing system estimate?
- How do rigid-body movements affect cable lengths?
- Can cable measurements be used to recover the unknown object state?

**Related Tasks:** 2.1, 2.2, 2.3, 2.4

## Daily Plan

### Monday — 19 October

**Task 2.1: Define Sensing Objective**

- [ ] Compare position-only `[x, y]` and planar-pose `[x, y, theta]` models.
- [ ] Identify unknown state variables and measured quantities.
- [ ] Define orientation constraints and preliminary accuracy targets.
- [ ] Select and justify the initial state model.

**Deliverable:** `Sensing_Objective_v0.1.md`

### Tuesday — 20 October

**Task 2.2: Rigid-Body Geometry**

- [ ] Reproduce the existing four-cable planar model in MATLAB.
- [ ] Verify anchor and attachment coordinates.
- [ ] Calculate cable vectors and cable lengths.
- [ ] Visualise the rigid body and cable configuration.

**Deliverable:** `rigid_geometry_v01.m` and geometry figure.

### Wednesday — 21 October

**Task 2.3: Measurement Jacobian**

- [ ] Derive the measurement Jacobian.
- [ ] Verify Jacobian dimensions and sign conventions.
- [ ] Compare analytical and numerical derivatives.
- [ ] Reproduce the observed x–theta measurement coupling.

**Deliverable:** `jacobian_verification_v01.m`

### Thursday — 22 October

**Task 2.3: Local Identifiability**

- [ ] Calculate Jacobian rank.
- [ ] Calculate singular values.
- [ ] Compare 2-DOF and 3-DOF identifiability.
- [ ] Test sensitivity under small orientation changes.
- [ ] Record degenerate or poorly conditioned configurations.

**Deliverable:** `identifiability_test_v01.m` and result plots.

### Friday — 23 October

**Task 2.4: Initial State Estimation**

- [ ] Define the noisy cable measurement model.
- [ ] Implement an initial state estimator.
- [ ] Estimate states using simulated cable lengths.
- [ ] Compare estimated and true states.
- [ ] Calculate initial position and orientation errors.

**Deliverable:** `rigid_state_estimation_v01.m`

### Saturday — 24 October

**Simulation Review**

- [ ] Repeat estimation from different positions.
- [ ] Investigate sensitivity to initial guesses.
- [ ] Identify unsuccessful or ambiguous solutions.
- [ ] Summarise limitations and remaining questions.

**Deliverable:** `Week_1_Results.md`

### Sunday — 25 October

**Weekly Review and GitHub Update**

- [ ] Review completed tasks and simulation results.
- [ ] Update `TODO.md`.
- [ ] Update `CURRENT_STATE2.md`.
- [ ] Record research findings in `06_Research_Log/`.
- [ ] Commit verified MATLAB code and documents.
- [ ] Prepare the reference model for Week 2.

## Expected Weekly Deliverables

- [ ] Selected sensing objective and state model
- [ ] Verified rigid-body geometry model
- [ ] Numerically verified measurement Jacobian
- [ ] Initial identifiability analysis
- [ ] Basic state-estimation results
- [ ] Week 1 research summary

## Weekly Review

**Completed:**

_To be updated._

**Main Findings:**

_To be updated._

**Problems / Limitations:**

_To be updated._

**Next Research Decision:**

_To be updated._

---

# Week 2 — 26 October–1 November 2026

## Weekly Objective

**Investigate cable number, anchor placement, attachment placement, and sensing quality.**

Research Questions:

- How many cables are required?
- How should external anchors be arranged?
- Where should cables attach to the rigid object?
- How does geometry influence measurement accuracy?
- Which regions support reliable state estimation?

**Related Tasks:** 3.1, 3.2, 3.3, 3.4

## Daily Plan

### Monday — 26 October

**Task 3.1: Cable Number Investigation**

- [ ] Define candidate two-, three-, and four-cable configurations.
- [ ] Calculate the measurement Jacobian for each configuration.
- [ ] Compare rank and independent measurement information.
- [ ] Identify insufficient or redundant configurations.
- [ ] Distinguish local identifiability from global uniqueness.

**Deliverable:** `cable_number_comparison_v01.m`

### Tuesday — 27 October

**Task 3.2: Anchor Placement**

- [ ] Define symmetric and asymmetric anchor configurations.
- [ ] Calculate Jacobians for each candidate.
- [ ] Compare sensing sensitivity and conditioning.
- [ ] Consider state scaling and measurement noise.
- [ ] Identify potentially better anchor arrangements.

**Deliverable:** `anchor_layout_comparison_v01.m`

### Wednesday — 28 October

**Task 3.3: Attachment Placement**

- [ ] Define different attachment-point arrangements.
- [ ] Compare symmetric and asymmetric configurations.
- [ ] Evaluate translation and rotation sensitivity.
- [ ] Investigate x–theta measurement coupling.
- [ ] Record physical attachment constraints.

**Deliverable:** `attachment_layout_comparison_v01.m`

### Thursday — 29 October

**Task 3.4: Sensing Workspace**

- [ ] Define an engineering test region.
- [ ] Sample positions and orientations.
- [ ] Evaluate Jacobian rank throughout the region.
- [ ] Calculate scaled/noise-aware sensing metrics.
- [ ] Define and visualise sensing-feasible regions.

**Deliverable:** `sensing_workspace_v01.m` and workspace plots.

### Friday — 30 October

**Measurement Noise and Accuracy**

- [ ] Introduce a common cable-measurement noise model.
- [ ] Compare estimation errors across configurations.
- [ ] Calculate position-estimation RMSE.
- [ ] Evaluate redundancy and noise sensitivity.
- [ ] Identify important trade-offs.

**Deliverable:** `configuration_noise_test_v01.m`

### Saturday — 31 October

**Configuration Comparison and Initial Selection**

- [ ] Summarise cable-number comparison.
- [ ] Summarise anchor-placement comparison.
- [ ] Summarise attachment-placement comparison.
- [ ] Compare identifiability, accuracy, and sensing workspace.
- [ ] Propose a preferred and an alternative configuration.

**Deliverable:** `Cable_Configuration_Study_v0.1.md`

### Sunday — 1 November

**Weekly Review and Next-Phase Preparation**

- [ ] Review simulation results.
- [ ] Update `TODO.md` and `CURRENT_STATE2.md`.
- [ ] Record key findings in the Research Log.
- [ ] Document sensor-resolution requirements.
- [ ] Identify preliminary hardware and ground-truth requirements.
- [ ] Define unresolved issues for experimental validation.

**Deliverable:** Week 2 research summary and preliminary experimental requirements.

## Expected Weekly Deliverables

- [ ] Cable-number comparison results
- [ ] Anchor-placement analysis
- [ ] Attachment-placement analysis
- [ ] Initial sensing workspace maps
- [ ] Estimation-error and noise comparison
- [ ] Preliminary candidate configuration recommendation
- [ ] Week 2 research summary

## Weekly Review

**Completed:**

_To be updated._

**Main Findings:**

_To be updated._

**Problems / Limitations:**

_To be updated._

**Next Research Decision:**

_To be updated._

---

# Weekly Planning Rules

1. Each weekly plan must have a clear research objective.
2. Every daily task should address a specific research question.
3. Each technical task should produce a verifiable result.
4. MATLAB simulations should include numerical or analytical checks.
5. Distinguish completed work from planned work.
6. If a task is not completed, record the reason and reschedule it.
7. Do not mark a task complete solely because code runs.
8. Update the Research Log with significant findings and decisions.
9. Preserve previous weekly plans for research traceability.
10. Use weekly results to determine the next research priority.

---

# Future Weekly Plan Template

## Week X — Date Range

### Weekly Objective

**Main Research Goal:**

_To be defined._

**Related Roadmap Phase / TODO Tasks:**

_To be defined._

### Daily Plan

| Day | Research Task | Expected Deliverable | Status |
|---|---|---|---|
| Monday | | | Not started |
| Tuesday | | | Not started |
| Wednesday | | | Not started |
| Thursday | | | Not started |
| Friday | | | Not started |
| Saturday | | | Not started |
| Sunday | Weekly review | Research summary | Not started |

### Weekly Deliverables

- [ ] Deliverable 1
- [ ] Deliverable 2
- [ ] Deliverable 3

### Weekly Review

**Completed:**

**Main Findings:**

**Problems / Limitations:**

**Next Research Question:**

---
