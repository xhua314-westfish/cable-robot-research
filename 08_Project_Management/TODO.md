# Research TODO

**Last Updated:** 2026-10-16  
**Current Phase:** Phase 2 — Simplified Model and Sensing Objective  
**Next Phase:** Phase 3 — Cable Configuration and Sensing Quality

---

## 1. Current Research Objective

**Research Question:**

> How do cable number and placement affect the accuracy and reliability of position estimation for a 550 mL rigid spherical object moving within a simplified gastric workspace?

**Research Baseline:**

- Target environment: Simplified adult female gastric outline
- Object: 550 mL rigid sphere (equivalent diameter ≈ 10.17 cm)
- Initial objective: Planar position estimation
- Main variables: Cable number, anchors, attachments
- Evaluation: Identifiability, position error, workspace coverage

The planar state model is provisional until orientation constraints are defined.

---

## 2. Phase 2 — Measurement Foundation

### Task 2.1 — Define Sensing Objective

- [ ] Confirm the initial state variables and orientation constraints.
- [ ] Define measured and estimated quantities.
- [ ] Establish preliminary position-accuracy requirements.

**Output:** Defined state model and measurement objective.

**Done when:** Unknown variables, constraints, and accuracy requirements are documented.

### Task 2.2 — Define Simplified Geometry

- [ ] Select gastric length, width, and height references or labelled assumptions.
- [ ] Build the simplified boundary and 550 mL rigid-sphere model.
- [ ] Define the feasible object-centre region.
- [ ] Reuse and adapt the existing MATLAB cable geometry.

**Output:** Simplified workspace and cable geometry model.

**Done when:** Geometry, units, assumptions, and collision constraints are verified.

### Task 2.3 — Verify Measurement Jacobian

- [ ] Derive the Jacobian for the selected state model.
- [ ] Verify analytical results using finite differences.
- [ ] Check Jacobian rank and measurement coupling.

**Output:** MATLAB Jacobian verification and sensitivity results.

**Done when:** Derivative errors are checked and local identifiability limitations are documented.

### Task 2.4 — Establish State Estimation

- [ ] Implement estimation from simulated cable-length measurements.
- [ ] Test different object positions and initial guesses.
- [ ] Calculate position-estimation errors.

**Output:** Initial MATLAB state estimator and error results.

**Done when:** Estimated states are compared with reference states without supplying the true trajectory to the estimator.

---

## 3. Phase 3 — Cable Configuration

### Task 3.1 — Compare Cable Number

- [ ] Define candidate cable numbers.
- [ ] Evaluate independent measurement information and rank.
- [ ] Compare estimation performance under common conditions.

**Output:** Cable-number comparison.

**Done when:** Feasible candidate counts and their limitations are identified.

### Task 3.2 — Compare Anchor Placement

- [ ] Define alternative anchor arrangements.
- [ ] Compare sensing quality and estimation uncertainty.
- [ ] Identify favourable and poorly conditioned configurations.

**Output:** Anchor-placement comparison.

**Done when:** Candidate anchor arrangements are quantitatively evaluated.

### Task 3.3 — Compare Attachment Placement

- [ ] Define alternative attachment arrangements on the rigid sphere.
- [ ] Investigate measurement sensitivity and coupling.
- [ ] Consider attachment and cable-routing feasibility.

**Output:** Attachment-placement comparison.

**Done when:** Candidate attachment layouts are evaluated and their limitations recorded.

### Task 3.4 — Evaluate Sensing Workspace and Accuracy

- [ ] Evaluate candidate configurations across the feasible region.
- [ ] Include a consistent cable-measurement noise model.
- [ ] Compare position RMSE and sensing workspace coverage.
- [ ] Recommend a preliminary cable configuration.

**Output:** Sensing workspace maps and configuration recommendation.

**Done when:** A candidate configuration is justified using explicit measurement-performance criteria.

---

## 4. Current Priority

Complete tasks in this order:

**2.1 → 2.2 → 2.3 → 2.4 → 3.1 → 3.2 → 3.3 → 3.4**

Reuse existing MATLAB work where possible.

Detailed daily scheduling is maintained in [WEEKLY_PLAN.md](WEEKLY_PLAN.md).

Future research stages are documented in [Roadmap.md](Roadmap.md).

---

## 5. Task Completion Rules

Mark a task complete only when:

1. The required model, code, or analysis is available.
2. Results have been checked.
3. Assumptions and limitations are documented.
4. The result supports a research or design decision.

Update [CURRENT_STATE2.md](../CURRENT_STATE2.md) after significant progress.

Record important results and decisions in [06_Research_Log](../06_Research_Log/).

**Next Task:** 2.1 — Define the initial sensing objective and orientation constraints.
