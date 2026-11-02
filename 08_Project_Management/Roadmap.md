# Research Roadmap

**Version:** 0.4  
**Last Updated:** 2026-11-02  
**Project:** Cable-Robot-Based Sensing for a Passive Deformable Balloon  
**Current Phase:** Phase B — Balloon-Specific Cable Sensing Design  
**Current Milestone:** Six-Cable Workspace Validation  
**Current Task:** B3.1 — Multi-Position Geometric Feasibility  
**Primary Tool:** MATLAB

---

## 1. Research Goal

Develop a cable-based measurement and sensing system for estimating the position, orientation, and eventually deformation of a passively moving balloon-like object.

The research is motivated by intragastric balloon monitoring in a simplified gastric environment.

### Main Research Question

> Can cable measurements be used to estimate the pose and eventually deformation of a passively moving balloon, and how should the cable configuration be designed to maximise sensing performance?

### Core Research Principle

**Research questions determine the methods. Numerical evidence determines the configuration.**

The system is intended for measurement and estimation, rather than active trajectory control.

---

## 2. Research Development Strategy

The project is organised into five major phases.

| Phase | Objective | Status |
|---|---|---|
| Phase 0 | Application and clinical evidence | Initial synthesis completed |
| Phase A | Literature-based method reproduction | Core scope completed |
| Phase B | Balloon-specific cable sensing design | Current |
| Phase C | Rigid-body sensing validation | Planned |
| Phase D | Deformable-balloon sensing | Future |

The current priority is to establish a reliable six-cable reference configuration.

Seven- and eight-cable systems will be investigated after sufficient six-cable validation.

---

## 3. Phase 0 — Application Definition

**Status:** Initial synthesis completed.

### Objective

Define the clinical motivation, measurement requirements, and preliminary geometric assumptions.

### Established Outcomes

- Clinical monitoring evidence reviewed.
- Balloon position and morphology evidence reviewed.
- 550 mL balloon volume selected.
- Simplified gastric engineering boundary established.
- Six-degree-of-freedom rigid-body sensing selected as the initial technical objective.

### Remaining Limitations

- True gastric motion ranges are not fully established.
- Patient-specific anatomy is not modelled.
- The engineering boundary is not a clinically validated gastric lumen.
- Real balloon deformation is not included in the initial model.

---

## 4. Phase A — Literature-Based Method Reproduction

**Status:** Core scope completed.

### Objective

Understand and numerically verify selected methods required for cable-based sensing.

### Completed Research

| Task | Main Method | Outcome |
|---|---|---|
| A1 | RREF, Tension Factor, WCC | Force feasibility analysis |
| A2 | Paper 3 Algorithm 1 | Single-pose feasible anchor regions |
| A3 | Paper 3 Algorithm 2 | Multi-pose feasible-region intersection |
| A4 | Forward Kinematics | Jacobian, covariance and Monte Carlo |
| A5 | Workspace Sampling | Three-dimensional feasibility analysis |

### Phase A Outcome

Reusable methods are available for:

- Cable geometry and length measurement.
- Measurement Jacobian analysis.
- Wrench feasibility.
- Workspace sampling.
- Forward kinematics.
- Pose uncertainty prediction.
- Monte Carlo evaluation.

**Limitation:** The methods were reproduced using reference models and do not directly validate the balloon-specific configuration.

---

## 5. Phase B — Balloon-Specific Cable Sensing Design

**Status:** Current research phase.

### Main Objective

Design a geometrically feasible and accurate six-cable pose-sensing system for a passive rigid spherical balloon.

After establishing a suitable six-cable reference, extend the study to seven and eight cables.

### Engineering Baseline

| Parameter | Value |
|---|---|
| Engineering boundary | 280 × 300 × 320 mm |
| Balloon volume | 550 mL |
| Balloon model | Rigid sphere |
| Balloon radius | Approximately 50.83 mm |
| Initial cable number | 6 |
| Anchor candidate region | Six boundary faces |
| Attachment candidate region | Spherical surface |
| Anchor candidate samples | 26 |
| Attachment candidate samples | 40 |
| Motion | Passive, unknown |
| Measurement | Cable length |

The boundary and mounting regions are engineering assumptions rather than clinically or mechanically validated structures.

### B1 — Geometry Definition

**Status:** Completed — Initial engineering model.

Completed:

- [x] Define the engineering boundary.
- [x] Define the rigid spherical balloon.
- [x] Calculate the geometric centre workspace.
- [x] Generate anchor candidates.
- [x] Generate attachment candidates.
- [x] Integrate and verify the MATLAB geometry model.

**Outcome:** A reproducible initial geometry framework is available.

### B2 — Initial Six-Cable Configuration Comparison

**Status:** Completed for exploratory single-pose comparison.

Three configurations were investigated:

| Metric | Baseline | Experiment A | Experiment B |
|---|---:|---:|---:|
| Jacobian rank | 6 | 6 | 6 |
| Scaled minimum singular value | 0.004393 | 0.535345 | 0.533600 |
| Scaled condition number | 490.956 | 3.5759 | 3.2365 |

**Key Findings:**

1. Attachment placement strongly influences sensing conditioning.
2. Joint anchor–attachment selection provided further improvement.
3. Single-pose optimisation is insufficient for selecting the final configuration.
4. Random search did not establish global optimality.

**Outcome:** Experiment A and Experiment B are retained as six-cable candidates for multi-pose evaluation.

### B3 — Six-Cable Feasibility Evaluation

**Status:** Next.

**Research Question:**

Which sampled balloon poses are geometrically feasible for the current six-cable configurations?

Main activities:

- Sphere containment.
- Cable-length calculation.
- Cable–sphere interference.
- Cable–cable minimum distance.
- Multi-position and multi-orientation evaluation.
- Sampled geometric feasibility coverage.

**Expected Outcome:**

Geometric feasibility maps and quantified failure mechanisms.

### B4 — Six-Cable Sensing Quality

**Status:** Planned.

**Research Question:**

How accurately can cable-length measurements reconstruct balloon pose across the feasible workspace?

Main activities:

- Measurement Jacobian verification.
- Local rank and identifiability.
- Scaled singular values and condition number.
- Pose covariance.
- Forward kinematics.
- Monte Carlo pose-estimation accuracy.
- Calibration and measurement-noise sensitivity.

**Expected Outcome:**

Quantified sensing sensitivity, position/orientation RMSE, and estimator reliability.

### B5 — Six-Cable Optimisation and Selection

**Status:** Planned.

**Research Question:**

Which six-cable configuration provides the best supported trade-off between geometric feasibility, sensing accuracy, robustness, and implementation complexity?

Main activities:

- Define optimisation variables.
- Define sensing-oriented objectives.
- Establish geometric and sensing constraints.
- Conduct multi-pose configuration search.
- Compare candidate configurations.
- Validate selected candidates on independent poses.
- Select a six-cable reference configuration.

**Expected Outcome:**

Six-Cable Reference Configuration v1.0.

**Important:** The reference configuration is a numerically justified engineering baseline, not a proven global optimum.

### Phase B Decision Rule

Do not begin seven-/eight-cable design merely because a six-cable configuration has a full-rank Jacobian or a low condition number at the initial pose.

A six-cable reference should first be evaluated across multiple positions and orientations.

---

## 6. Future Seven- and Eight-Cable Extension

**Status:** Deferred.

### Seven-Cable Stage

Start from the selected six-cable reference configuration.

Investigate:

- Additional measurement information.
- Pose uncertainty reduction.
- Feasible sensing workspace.
- Cable redundancy.
- Additional interference and routing complexity.
- Mechanical tension requirements.

Paper 3 Algorithms 1 and 2 may be applied if the relevant positive-tension wrench-closure assumptions are justified.

Joint re-optimisation of all seven cables may be required.

### Eight-Cable Stage

Investigate:

- Measurement redundancy.
- Pose covariance changes.
- Robustness to selected measurement failures.
- Geometric feasibility.
- Physical complexity.
- Comparison with six- and seven-cable designs.

Adding cables does not automatically guarantee better sensing performance.

---

## 7. Phase C — Rigid-Body Sensing Validation

**Status:** Planned.

### Objective

Validate the selected sensing system under more comprehensive and realistic conditions.

Potential activities:

- Wider pose coverage.
- Combined translation and rotation.
- Irregular passive-motion sequences.
- Sensor calibration.
- Geometric parameter uncertainty.
- Estimator initialisation robustness.
- Cable tension tracking.
- Independent ground-truth measurements.
- Hardware validation, if feasible.

### Expected Outcome

A validated understanding of the rigid-body measurement system's accuracy, robustness, and physical limitations.

---

## 8. Phase D — Deformable-Balloon Extension

**Status:** Future research.

### Objective

Extend the rigid-body sensing model toward deformation and shape reconstruction.

Potential activities:

- Reduced-order deformation representation.
- Variable attachment geometry.
- Extended measurement model.
- Combined pose and deformation observability.
- Shape-estimation algorithms.
- Experimental deformation validation.

The detailed approach depends on the results of Phases B and C.

---

## 9. Research Milestones

| Milestone | Outcome | Status |
|---|---|---|
| M1 | Application and clinical evidence | Initial synthesis completed |
| M2 | Rigid-balloon engineering baseline | Completed |
| M3 | 6-DOF sensing objective | Completed |
| M4 | Phase A feasibility methods | Completed |
| M5 | Phase A Jacobian and FK verification | Completed |
| M6 | Phase A covariance and Monte Carlo | Completed |
| M7 | Balloon geometry and candidate regions | Completed — B1 |
| M8 | Initial six-cable configuration comparison | Completed — B2.2 |
| M9 | Six-cable multi-pose feasibility | Current — B3 |
| M10 | Six-cable sensing accuracy | Planned — B4 |
| M11 | Six-cable reference configuration | Planned — B5 |
| M12 | Seven-/eight-cable extension | Deferred |
| M13 | Rigid-body sensing validation | Planned — Phase C |
| M14 | Deformable sensing extension | Future — Phase D |

Milestone completion refers to the documented scope, not complete physical system validation.

---

## 10. Current Research Priority

**Current Milestone: M9 — Six-Cable Multi-Pose Feasibility**

**Immediate Task: B3.1 — Multi-Position Geometric Feasibility**

The first test uses:

\[
P_x,P_y,P_z\in\{-50,0,50\}\ \mathrm{mm}
\]

with:

\[
R=I
\]

Evaluate the existing Experiment A and Experiment B configurations without changing their coordinates.

Required checks:

1. Sphere containment.
2. Cable lengths.
3. Cable–sphere interference.
4. Cable–cable minimum distances.
5. Geometric feasibility rates.
6. Failed-pose analysis.

The detailed daily schedule is maintained in `weekly_plan_03.md`.

---

## 11. Related Documents

- [Current Research State](../CURRENT_STATE2.md)
- [Research Guidelines](../AGENTS2.md)
- [Active TODO](current_october_november_todo.md)
- [Weekly Plan 03](weekly_plan_03.md)
- [Rigid-Body Sensing Design](../05_My_Research/Rigid_Body_Sensing_Design.md)
- [Phase B Literature Method Selection](../02_Paper_Reading/Literature_Review/workspace%20definition/Phase_B_Method_Selection_2026-11-02.md)
- [Research Log](../06_Research_Log/)

---

**Next Milestone:** Establish the geometric feasibility and sensing performance of the six-cable configurations before beginning additional cable design.

**Guiding Principle:** Select methods according to research questions and validate results before making design decisions.
