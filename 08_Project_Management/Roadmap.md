# Research Roadmap

**Last Updated:** 2026-10-30  
**Current Phase:** Phase B — Balloon-Specific Cable Sensing Design  
**Current Task:** B1 — Geometry and Candidate Region Definition  
**Primary Tool:** MATLAB

---

## 1. Research Goal

Develop a cable-based measurement and sensing system to estimate the position, orientation, and eventually deformation of a passively moving balloon-like object.

The application is motivated by intragastric balloon monitoring in a simplified gastric environment.

**Core Research Principle:**

> Estimate the balloon state from cable measurements without prescribing or controlling the balloon's motion trajectory.

The current focus is 3D rigid-body pose sensing, followed by cable configuration evaluation and subsequent deformable-balloon extensions.

### Main Research Question

> How do cable number, anchor placement, and attachment placement affect the feasibility, identifiability, and pose-estimation accuracy of a passively moving balloon-like object?

### Research Baseline

- Simplified 3D gastric boundary.
- 550 mL rigid spherical balloon proxy.
- Six-degree-of-freedom position and orientation.
- Six-, seven-, and eight-cable candidate configurations.
- Cable-length-based pose estimation.
- Motor-assisted low-tension cable tracking as a proposed architecture.
- Unknown and passive balloon motion.

The rigid spherical balloon is an engineering approximation, not a validated deformable gastric-balloon model.

---

## 2. Research Development Strategy

The research follows five main stages:

| Stage | Focus | Status |
|---|---|---|
| Phase 0 | Application Definition and Clinical Evidence | Initial synthesis completed |
| Phase A | Literature-Based Method Reproduction | Core scope completed |
| Phase B | Balloon-Specific Configuration Design | Current |
| Phase C | Rigid-Body Sensing Validation | Planned |
| Phase D | Deformable-Balloon Extension | Future |

The stages are sequential in their main objectives, but findings may require revisiting earlier assumptions.

---

## 3. Phase 0 — Application Definition and Clinical Evidence

**Status:** Initial synthesis completed.

### Research Objective

Establish the application motivation and preliminary physical modelling requirements for intragastric balloon sensing.

### Completed Work

- Clinical monitoring evidence review.
- Balloon volume and morphology evidence review.
- Balloon position and migration evidence review.
- Balloon dimension evidence review.
- Initial gastric geometry literature review.
- Selection of a 550 mL engineering balloon reference.

### Remaining Limitations

- Real gastric movement trajectories are not fully characterised.
- A clinically validated complete 3D sensing workspace is unavailable.
- The simplified gastric boundary requires clearly documented engineering assumptions.

### Completion Outcome

An initial research application and geometry baseline have been established, with uncertainties identified for future refinement.

---

## 4. Phase A — Literature-Based Method Reproduction

**Status:** Core scope completed — October 2026.

### Research Objective

Understand, implement, and verify existing cable-robot methods before applying them to the balloon-specific design.

### Completed Tasks

| Task | Method | Main Outcome |
|---|---|---|
| A1 | RREF, Tension Factor, WCC | Cable tension feasibility analysis |
| A2 | Paper 3 Algorithm 1 | Feasible anchor-region calculation |
| A3 | Paper 3 Algorithm 2 | Multi-pose feasible-region intersection |
| A4 | Paper 4 Forward Kinematics | Jacobian, pose estimation, covariance and Monte Carlo |
| A5 | Paper 1 Workspace Sampling | 3D feasibility sampling and orientation constraints |

### Methods Available for Reuse

- Cable geometry and length computation.
- Six-degree-of-freedom measurement Jacobian.
- Local rank and identifiability evaluation.
- Wrench-closure feasibility tests.
- Feasible-region intersection.
- Workspace sampling.
- Nonlinear least-squares pose estimation.
- Measurement-noise simulation.
- Pose covariance prediction.
- Bias, RMSE and standard-deviation analysis.
- 3σ coverage and NEES consistency evaluation.

### Scope of Completion

The core computational methods were implemented and verified using selected reference geometries and simulation assumptions.

This does not imply exact reproduction of every published algorithm or experimental result.

### Phase A Exit Criteria

- [x] Main A1–A5 computational methods implemented.
- [x] Numerical verification results obtained.
- [x] Important model assumptions and limitations documented.
- [x] MATLAB scripts and research notes archived.
- [x] Transferable methods identified for Phase B.

---

## 5. Phase B — Balloon-Specific Cable Sensing Design

**Status:** Current research phase.

### Main Objective

Design and evaluate 6-, 7-, and 8-cable sensing configurations for a passive 550 mL rigid spherical balloon within a simplified gastric boundary.

Phase B is divided into five work packages.

### B1 — Geometry and Candidate Region Definition

**Status:** Current task.

**Research Question:**

> How should the gastric boundary, balloon geometry, anchor regions, and attachment regions be defined for a realistic but manageable sensing model?

**Main Activities:**

1. Review existing gastric boundary evidence and modelling assumptions.
2. Confirm the X/Y/Z coordinate system and dimensions.
3. Construct the 550 mL rigid spherical balloon model.
4. Calculate the geometrically feasible balloon-centre region.
5. Define candidate external anchor regions.
6. Define candidate balloon-surface attachment regions.
7. Document physical constraints and unresolved assumptions.

**Deliverables:**

- B1 geometry definition document.
- MATLAB geometry model.
- Gastric boundary and balloon visualisation.
- Candidate anchor/attachment region definitions.
- Initial geometric constraint list.

**Completion Criteria:**

- [ ] Gastric and balloon dimensions are explicitly defined.
- [ ] Reported, derived and assumed values are distinguished.
- [ ] The sphere-centre containment constraint is implemented.
- [ ] Anchor and attachment candidate regions are documented.
- [ ] The geometry model is reproducible and visually verified.

### B2 — Cable Configuration Generation

**Status:** Planned.

**Research Question:**

> How can comparable 6-, 7-, and 8-cable configurations be generated from the defined candidate regions?

**Main Activities:**

1. Generate candidate anchor and attachment point sets.
2. Define cable-to-attachment correspondence.
3. Construct six-cable reference configurations.
4. Construct seven- and eight-cable configurations.
5. Check basic geometric validity.
6. Save candidate configurations in a reproducible format.

**Deliverables:**

- Candidate configuration dataset.
- MATLAB configuration-generation scripts.
- Geometry visualisations for each cable count.

**Completion Criteria:**

- [ ] Candidate 6-, 7-, and 8-cable systems are generated.
- [ ] All candidates use consistent geometric conventions.
- [ ] Basic mounting and routing constraints are identified.
- [ ] Candidate configurations are reproducible.

### B3 — Feasibility Screening

**Status:** Planned.

**Research Question:**

> Which candidate configurations satisfy geometric, cable-length, routing, and tension-feasibility requirements across the sampled workspace?

**Main Activities:**

1. Sample candidate balloon positions and orientations.
2. Apply balloon containment constraints.
3. Check cable length limits.
4. Check cable–balloon and cable–cable interference.
5. Evaluate tension / wrench feasibility where applicable.
6. Compute multi-pose feasible-region intersections.
7. Estimate sampled workspace coverage.

**Deliverables:**

- Feasibility evaluation scripts.
- Feasible / infeasible pose maps.
- Coverage statistics for candidate configurations.
- Explicit records of the constraints applied.

**Completion Criteria:**

- [ ] Geometric feasibility is evaluated.
- [ ] Cable-length and routing constraints are applied.
- [ ] Tension feasibility is assessed under stated assumptions.
- [ ] Feasible coverage is quantified using common pose samples.
- [ ] Physically infeasible configurations are identified.

**Important:** Wrench feasibility and measurement identifiability are separate conditions.

### B4 — Sensing Quality Evaluation

**Status:** Planned.

**Research Question:**

> How accurately and reliably can each feasible cable configuration estimate the balloon's six-degree-of-freedom pose?

**Main Activities:**

1. Evaluate the measurement Jacobian over sampled poses.
2. Check rank and local identifiability.
3. Evaluate appropriately scaled singular values and conditioning.
4. Predict pose covariance under specified noise models.
5. Perform Monte Carlo forward-kinematics experiments.
6. Calculate position and orientation RMSE.
7. Evaluate estimator convergence and ambiguity.
8. Compare sensing quality across six-, seven-, and eight-cable candidates.

**Deliverables:**

- Sensing-quality maps.
- Covariance and accuracy comparisons.
- Position and orientation RMSE results.
- Configuration comparison tables.
- Identified weak or unobservable pose regions.

**Completion Criteria:**

- [ ] Candidate configurations are compared under consistent noise and pose assumptions.
- [ ] Rank-deficient cases are identified.
- [ ] Pose uncertainty is quantified.
- [ ] Monte Carlo results support the analytical comparisons.
- [ ] Poor convergence and ambiguous solutions are documented.

### B5 — Configuration Selection

**Status:** Planned.

**Research Question:**

> Which cable configuration provides the most suitable balance between feasible workspace, pose-estimation accuracy, and physical complexity?

**Main Activities:**

1. Compare feasible workspace coverage.
2. Compare pose estimation accuracy and uncertainty.
3. Evaluate cable routing and interference limitations.
4. Assess potential low-tension tracking requirements.
5. Identify trade-offs between cable number and performance.
6. Select a justified initial configuration.
7. Document limitations and alternative candidates.

**Deliverables:**

- Final candidate comparison.
- Selected initial cable configuration.
- Research justification and sensitivity analysis.
- Recommendations for subsequent validation.

**Completion Criteria:**

- [ ] Cable count selection is supported by quantitative results.
- [ ] Anchor and attachment placement decisions are documented.
- [ ] The selected configuration meets explicitly stated evaluation criteria.
- [ ] Remaining physical and modelling uncertainties are reported.

---

## 6. Phase C — Rigid-Body Sensing Validation

**Status:** Planned.

### Research Objective

Evaluate the selected cable configuration under a wider range of rigid-body poses, noise conditions, and passive-motion scenarios.

### Planned Validation

- Multiple static poses.
- Combined translation and rotation.
- Irregular passive-motion trajectories.
- Different sensor-noise conditions.
- Calibration and model uncertainty.
- Estimator initialisation sensitivity.
- Cable tension tracking and motion disturbance.
- Independent ground-truth comparison, if hardware is available.

### Expected Deliverables

- Robustness evaluation.
- Pose-estimation accuracy assessment.
- Model and calibration sensitivity analysis.
- Preliminary hardware or experimental validation where feasible.

### Completion Criteria

- The estimator does not require the true trajectory as an input.
- Pose-estimation performance is quantified over relevant test conditions.
- Failure cases and uncertainty are documented.
- Simulation results and physical validation are clearly distinguished.

---

## 7. Phase D — Deformable-Balloon Extension

**Status:** Future research direction.

### Research Objective

Extend the rigid-body measurement model to investigate balloon deformation and shape estimation.

### Potential Research Tasks

- Define a reduced-order deformation model.
- Investigate attachment displacement under deformation.
- Extend the cable measurement equations.
- Evaluate combined pose/deformation identifiability.
- Compare deformation estimates against independent references.
- Investigate measurement-system limitations under shape changes.

### Scope Note

Deformable-balloon sensing remains the long-term research goal.

Its detailed implementation depends on the outcomes of the rigid-body configuration and sensing validation stages.

---

## 8. Research Milestones

| Milestone | Target Outcome | Status |
|---|---|---|
| M1 | Application and clinical evidence synthesis | Initial synthesis completed |
| M2 | 550 mL rigid spherical reference model | Defined |
| M3 | 3D 6-DOF sensing objective | Defined |
| M4 | Literature-based feasibility methods | Completed — Phase A |
| M5 | Reference-geometry Jacobian and FK verification | Completed — Phase A |
| M6 | Reference-geometry covariance and Monte Carlo validation | Completed — Phase A |
| M7 | Balloon-specific geometry and candidate regions | Current — B1 |
| M8 | 6/7/8-cable candidate generation | Planned — B2 |
| M9 | Feasibility and workspace evaluation | Planned — B3 |
| M10 | Sensing accuracy and robustness comparison | Planned — B4 |
| M11 | Preferred cable configuration | Planned — B5 |
| M12 | Rigid-body sensing validation | Planned — Phase C |
| M13 | Deformable-balloon extension | Future — Phase D |

A milestone is complete only within its documented scope and validation assumptions.

---

## 9. Current Research Priority

**Current milestone: M7 — Balloon-Specific Geometry and Candidate Regions.**

Immediate work sequence:

1. Confirm the existing gastric geometry evidence and candidate boundary.
2. Define the 550 mL rigid spherical object.
3. Establish the geometrically feasible balloon-centre region.
4. Define candidate fixed anchor regions.
5. Define candidate attachment regions on the balloon surface.
6. Implement and verify the B1 MATLAB geometry model.

**Research rule:** Do not begin cable configuration optimisation before the geometry baseline and physical constraints are documented.

---

## 10. Related Documents

- [Current Research State](../CURRENT_STATE2.md) — Current progress and findings.
- [Research Guidelines](../AGENTS2.md) — Research and coding rules.
- [Sensing Objective](../05_My_Research/Sensing_Objective_v0.2.md) — Research scope and sensing assumptions.
- [Rigid-Body Sensing Design](../05_My_Research/Rigid_Body_Sensing_Design.md) — Mathematical model and sensing methods.
- [Workspace Boundary](../05_My_Research/Workspace_Boundary_v0.2_2026-10-20.md) — Gastric geometry evidence and initial assumptions.
- [October–November TODO](current_october_november_todo.md) — Detailed task and completion tracking.
- [Weekly Plan 02](weekly_plan_02.md) — Historical Phase A schedule and results.
- [Research Log](../06_Research_Log/) — Experiment records and research notes.

---

**Next Milestone:** Complete B1 geometry and candidate-region definition before generating and comparing 6-, 7-, and 8-cable configurations.
