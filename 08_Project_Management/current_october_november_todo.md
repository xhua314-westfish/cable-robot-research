# October–November Research TODO

**Last Updated:** 2026-10-30  
**Original Planning Period:** 2026-10-22 to 2026-11-18  
**Current Phase:** Phase B — Balloon-Specific Cable Sensing Design  
**Current Task:** B1 — Geometry and Candidate Region Definition  
**Workload Reference:** 4–5 hours per research day

---

## 1. Purpose

This document tracks actionable research tasks, their completion criteria, and required outputs.

The original October–November plan focused on reproducing cable-robot methods from four papers.

The core Phase A methods were completed ahead of the original schedule.

The research now moves to Phase B, where these methods will be applied to balloon-specific cable sensing configurations.

For long-term milestones, see [Roadmap.md](Roadmap.md).

For detailed current findings, see [CURRENT_STATE2.md](../CURRENT_STATE2.md).

---

## 2. Phase A — Completed Method Reproduction

**Status:** Core scope completed.

| ID | Research Task | Main Outcome | Status |
|---|---|---|---|
| A1 | Paper 2 — RREF, Tension Factor and WCC | Tension feasibility verification | Completed |
| A2 | Paper 3 — Algorithm 1 | Feasible anchor-region calculation | Completed |
| A3 | Paper 3 — Algorithm 2 | Multi-pose feasible-region intersection | Completed |
| A4 | Paper 4 — Forward Kinematics | Jacobian, covariance, Monte Carlo and NEES | Completed |
| A5 | Paper 1 — Workspace Sampling | Sampled 3D feasible workspace | Completed |

### Phase A Completion Checklist

- [x] A1 — Verify RREF and cable force ratios.
- [x] A1 — Reproduce Tension Factor of approximately 0.6671.
- [x] A2 — Implement Algorithm 1 feasibility inequalities.
- [x] A2 — Generate and verify candidate feasible regions.
- [x] A3 — Implement multi-pose region intersection.
- [x] A3 — Extend feasibility evaluation to seven cables.
- [x] A4 — Implement the 8-cable length measurement model.
- [x] A4 — Verify the 6-DOF measurement Jacobian.
- [x] A4 — Implement nonlinear forward kinematics using Gauss–Newton.
- [x] A4 — Evaluate covariance and measurement-noise sensitivity.
- [x] A4 — Run 100-trial Monte Carlo validation.
- [x] A4 — Evaluate Bias, RMSE and 3σ coverage.
- [x] A4 — Perform the 95% ANEES consistency test.
- [x] A5 — Implement 3D position-grid sampling.
- [x] A5 — Evaluate WCC and cable-length feasibility.
- [x] A5 — Evaluate selected roll-angle constraints.
- [x] Document core methods, assumptions and limitations.
- [x] Archive MATLAB code and research notes.

### Important Completion Limitations

The completed work demonstrates selected computational methods, not full experimental system validation.

- Paper 1 is a review; A5 is a method-inspired implementation.
- Paper 3 feasible regions depend on the selected reference geometry and sampled poses.
- Paper 4 used a Gauss–Newton estimator and a simplified measurement-noise model.
- The principal A4 Monte Carlo test used one fixed true pose.
- The previous workspace experiments do not define a clinically validated gastric workspace.

These limitations should be retained when transferring methods to Phase B.

---

## 3. Phase B — Actionable Research Tasks

**Overall Objective:**

Design and evaluate comparable 6-, 7-, and 8-cable sensing configurations for a passive 550 mL rigid spherical balloon within a simplified gastric environment.

### B1 — Geometry and Candidate Region Definition

**Status:** Current.

**Research Question:**

How should the gastric boundary, balloon geometry, anchor regions, and attachment regions be defined?

#### B1.1 — Review Existing Geometry Evidence

- [ ] Review `Workspace_Boundary_v0.2_2026-10-20.md`.
- [ ] Cross-check the existing gastric length, width and height assumptions against supporting evidence.
- [ ] Separate literature-reported dimensions from derived estimates and engineering assumptions.
- [ ] Select and document the initial engineering boundary.

**Deliverable:** B1 geometry parameter table with evidence and assumptions.

**Acceptance Criteria:** Every selected dimension has a value or range, unit, source or assumption label, and explanation.

#### B1.2 — Define the 550 mL Balloon Geometry

- [ ] Convert 550 mL into the equivalent spherical radius and diameter.
- [ ] Define the balloon-centre coordinate and local body frame.
- [ ] Implement the rigid sphere in MATLAB.
- [ ] Distinguish the rigid spherical proxy from a real deformable balloon.

**Deliverable:** MATLAB sphere geometry and model definition.

**Acceptance Criteria:** Balloon volume and geometry are numerically verified.

#### B1.3 — Define the Geometrically Feasible Region

- [ ] Define the gastric envelope mathematically.
- [ ] Implement the full sphere-containment condition.
- [ ] Compute candidate balloon-centre limits.
- [ ] Visualise feasible and infeasible centre positions.
- [ ] Document how the simplified boundary affects the result.

**Deliverable:** MATLAB geometric-feasibility model and visualisation.

**Acceptance Criteria:** Every retained centre position satisfies the selected containment constraints.

#### B1.4 — Define Candidate Anchor Regions

- [ ] Distinguish the anatomical boundary from physically mountable anchor structures.
- [ ] Identify candidate external or fixture-mounted anchor regions.
- [ ] Define anchor locations in the world coordinate frame.
- [ ] Record access, mounting and routing constraints.
- [ ] Produce an initial candidate-region visualisation.

**Deliverable:** Initial anchor-region definition.

**Acceptance Criteria:** All candidate regions have explicit geometric definitions and assumptions.

#### B1.5 — Define Candidate Attachment Regions

- [ ] Define the balloon body coordinate frame.
- [ ] Parameterise attachment locations on the sphere surface.
- [ ] Identify candidate attachment regions.
- [ ] Define minimum spacing and basic interference considerations.
- [ ] Record possible physical attachment mechanisms as unresolved design constraints.

**Deliverable:** Initial attachment-region definition.

**Acceptance Criteria:** Attachment coordinates are expressed consistently in the body frame and lie on the selected sphere surface.

#### B1.6 — Integrate and Verify Geometry

- [ ] Combine the boundary, sphere and candidate regions in one MATLAB model.
- [ ] Verify coordinate conventions and units.
- [ ] Check geometric constraints numerically.
- [ ] Generate a clean 3D configuration figure.
- [ ] Save assumptions, results and unresolved questions.

**Deliverable:** B1 geometry script, figure and research note.

**B1 Definition of Done:**

- [ ] Selected geometry and assumptions are documented.
- [ ] The sphere-containment model is verified.
- [ ] Candidate anchor regions are defined.
- [ ] Candidate attachment regions are defined.
- [ ] MATLAB geometry visualisation is complete.
- [ ] B1 results are archived for B2.

---

### B2 — Cable Configuration Generation

**Status:** Planned.

**Research Question:**

How can comparable six-, seven-, and eight-cable configurations be generated from B1?

- [ ] Define cable number as a configuration parameter.
- [ ] Generate six-cable reference candidates.
- [ ] Generate seven-cable candidates.
- [ ] Generate eight-cable candidates.
- [ ] Define anchor-to-attachment correspondence.
- [ ] Enforce basic geometry and spacing constraints.
- [ ] Store candidate coordinates and identifiers.
- [ ] Produce comparable 3D configuration figures.

**Deliverables:**

- Candidate configuration dataset.
- MATLAB configuration-generation functions.
- 6/7/8-cable visualisations.

**Definition of Done:**

- [ ] All three cable counts are represented.
- [ ] Configurations use common coordinate and unit conventions.
- [ ] Candidate-generation assumptions are documented.
- [ ] Candidates are reproducible from stored parameters.

---

### B3 — Feasibility Screening

**Status:** Planned.

**Research Question:**

Which configurations satisfy geometric and mechanical constraints throughout the sampled workspace?

- [ ] Define a common pose-sampling grid.
- [ ] Apply balloon containment constraints.
- [ ] Evaluate cable-length limits.
- [ ] Implement cable–sphere interference checks.
- [ ] Investigate cable–cable interference.
- [ ] Evaluate WCC or specified tension-feasibility conditions.
- [ ] Apply multi-pose feasible-region intersection.
- [ ] Calculate sampled feasible workspace coverage.
- [ ] Identify infeasible or poorly constrained regions.

**Deliverables:**

- Feasibility evaluation scripts.
- Feasible workspace maps.
- Configuration screening summary.

**Definition of Done:**

- [ ] Feasibility conditions are explicit.
- [ ] The same pose samples are used for comparable configurations.
- [ ] Cable-length and routing constraints are evaluated.
- [ ] Tension feasibility is assessed under stated assumptions.
- [ ] Workspace coverage is reported quantitatively.

**Important:** Local 6-DOF identifiability and positive-tension wrench closure are different requirements.

---

### B4 — Sensing Quality Evaluation

**Status:** Planned.

**Research Question:**

How accurately and reliably can feasible cable configurations reconstruct six-degree-of-freedom pose?

- [ ] Calculate the measurement Jacobian for each configuration.
- [ ] Evaluate Jacobian rank over sampled poses.
- [ ] Apply physically meaningful scaling for conditioning comparisons.
- [ ] Predict local pose covariance.
- [ ] Define common sensor-noise scenarios.
- [ ] Perform Monte Carlo pose-estimation tests.
- [ ] Calculate position and orientation RMSE.
- [ ] Evaluate Bias and uncertainty coverage.
- [ ] Investigate estimator convergence and ambiguous solutions.
- [ ] Compare results across 6-, 7-, and 8-cable candidates.

**Deliverables:**

- Sensing-quality evaluation scripts.
- Covariance and RMSE comparisons.
- Rank and conditioning maps.
- Configuration performance tables.

**Definition of Done:**

- [ ] Candidate systems are evaluated under consistent conditions.
- [ ] Rank-deficient regions are identified.
- [ ] Pose uncertainty is quantified.
- [ ] Monte Carlo evaluation is completed for selected candidates.
- [ ] Poor convergence and limitations are documented.

---

### B5 — Configuration Selection

**Status:** Planned.

**Research Question:**

Which configuration best balances feasible workspace, pose-estimation accuracy, and physical complexity?

- [ ] Compare geometric and mechanical feasibility.
- [ ] Compare sensing workspace coverage.
- [ ] Compare pose-estimation uncertainty and RMSE.
- [ ] Compare cable number and implementation complexity.
- [ ] Investigate the sensitivity of candidate rankings to noise and geometry assumptions.
- [ ] Select a preferred initial configuration.
- [ ] Record alternatives and unresolved physical constraints.

**Deliverables:**

- Final configuration comparison.
- Selected cable configuration.
- Research justification and limitations.
- Phase C validation recommendations.

**Definition of Done:**

- [ ] Configuration selection is supported by quantitative results.
- [ ] Selection criteria and trade-offs are explicit.
- [ ] Preferred anchor and attachment coordinates are documented.
- [ ] The selected configuration is ready for more extensive validation.

---

## 4. Current Priority Queue

**Active task: B1.1 — Review Existing Geometry Evidence.**

Recommended execution order:

| Order | Task | Status |
|---|---|---|
| 1 | B1.1 — Gastric boundary evidence and parameters | Current |
| 2 | B1.2 — 550 mL balloon geometry | Next |
| 3 | B1.3 — Sphere-centre feasible region | Planned |
| 4 | B1.4 — Candidate anchor regions | Planned |
| 5 | B1.5 — Candidate attachment regions | Planned |
| 6 | B1.6 — Geometry integration and verification | Planned |

Do not begin B2–B5 optimisation until the B1 geometry baseline and relevant constraints have been documented.

---

## 5. Scientific and Modelling Rules

1. Treat balloon motion as passive and unknown to the estimator.
2. Keep fixed world-frame anchors separate from body-frame attachments.
3. Distinguish anatomical boundaries from physically mountable structures.
4. Separate geometric feasibility, tension feasibility and sensing quality.
5. Use Jacobian rank 6 as a local identifiability condition, not proof of global uniqueness.
6. Do not treat Tension Factor as the primary sensing-accuracy metric.
7. Use consistent noise assumptions and pose samples when comparing configurations.
8. Treat covariance as a local, model-dependent prediction.
9. Document assumptions before selecting numerical design thresholds.
10. Preserve original simulation evidence and record failed cases.

---

## 6. Research Output Convention

Each completed B-stage task should produce the smallest useful combination of:

- A MATLAB script or function (`.m`).
- A figure (`.png`) when visual evidence is useful.
- A short research note (`.md`).
- Explicit model parameters and units.
- Numerical verification results.
- Limitations and the next action.

Use existing repository folders where possible.

**Suggested locations:**

- MATLAB scripts: `04_Code_Exercises/MATLAB/`
- Research models: `05_My_Research/`
- Experiment records: `06_Research_Log/`
- Project planning: `08_Project_Management/`

Avoid copying identical progress reports into multiple files.

---

## 7. Source Material

### Existing Research Documents

- [Current Research State](../CURRENT_STATE2.md)
- [Research Roadmap](Roadmap.md)
- [Weekly Plan 02](weekly_plan_02.md)
- [Workspace Boundary](../05_My_Research/Workspace_Boundary_v0.2_2026-10-20.md)
- [Research Log](../06_Research_Log/2026-10/)

### Paper References

- **Paper 1:** Tho & Thinh (2022), *An Overview of Cable-Driven Parallel Robots: Workspace, Tension Distribution, and Cable Sagging*.
- **Paper 2:** Cheng & Lau (2023), *Cable Attachment Optimization for Reconfigurable Cable-Driven Parallel Robots Based on Various Workspace Conditions*.
- **Paper 3:** Cheng, Lau & Hughes (2025), *Determining Feasible Cable Attachment Locations for Cable-Driven Parallel Robot*.
- **Paper 4:** Patel, Nguyen & Caverly (2023), *Forward Kinematics of a Cable-Driven Parallel Robot with Pose Estimation Error Covariance Bounds*.

---

**Next Action:** Complete B1.1 by reviewing and consolidating the gastric geometry evidence before implementing the B1 MATLAB balloon model.
