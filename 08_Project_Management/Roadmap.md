# Research Roadmap

**Version:** 0.5
**Last Updated:** 2026-11-04
**Project:** Cable-Robot-Based Sensing for a Passive Deformable Balloon
**Current Phase:** Phase B — Balloon-Specific Cable Sensing Design
**Current Milestone:** B5 — Rapid Six-Cable Prototype Configuration Selection
**Current Task:** B5.1 — Configuration Audit and Candidate Expansion
**Primary Tool:** MATLAB

**Research Strategy:** Prototype-first development with parallel theoretical investigation of six-, seven-, and eight-cable sensing systems.

---

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

The project follows a research-driven and prototype-first development strategy.

The long-term objective remains to investigate and compare six-, seven-, and eight-cable measurement systems for passive balloon pose sensing, with eventual extension to deformable balloon sensing.

### 2.1 Two Parallel Research Workstreams

**Workstream A — Six-Cable Prototype and Experimental Validation**

Priority: High

1. Complete six-cable configuration evaluation.
2. Select an adjustable Prototype Configuration V1.0.
3. Verify initial compatibility with a deformable balloon.
4. Calculate cable length, tension and motor requirements.
5. Build an adjustable six-cable test rig.
6. Validate measurement accuracy and calibration experimentally.
7. Refine the configuration based on measured results.

**Workstream B — Seven- and Eight-Cable Theory and Simulation**

Priority: Parallel, without delaying Workstream A

1. Extend the measurement Jacobian from 6 × 6 to 7 × 6 and 8 × 6.
2. Investigate measurement redundancy and observability.
3. Compare singular values, conditioning and pose covariance.
4. Investigate additional cable routing and interference.
5. Evaluate tension feasibility under justified mechanical assumptions.
6. Compare six-, seven- and eight-cable systems using common pose samples and evaluation criteria.
7. Determine whether additional experimental cable channels are justified.

### 2.2 Workstream Integration

Both workstreams will use consistent:

- Engineering workspace assumptions.
- Balloon geometry and motion models.
- Pose evaluation sets.
- Cable-length noise assumptions.
- Sensing quality metrics.
- Geometric and mechanical constraints.

The six-cable experimental system will provide a physical baseline for interpreting the theoretical benefits of additional cables.

Seven- and eight-cable theory and simulation may begin while the six-cable test rig is being designed or assembled.

Hardware expansion will be considered after reviewing numerical and experimental evidence.

### 2.3 Development Priorities

The immediate priority is not to prove global optimality.

Instead, the project aims to establish a numerically justified, mechanically adjustable and experimentally testable six-cable configuration.

The initial prototype will support iterative improvement of cable geometry, sensing accuracy and low-tension tracking.

**Guiding Principle:**

Prototype early, validate experimentally, refine systematically, and preserve the long-term six-/seven-/eight-cable comparison.


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


### B3 — Six-Cable Geometric Feasibility

**Status:** Completed — 2026-11-03.

The existing Experiment A and B configurations were evaluated at:

- 27 sampled balloon-centre positions.
- Seven orientation cases.
- 189 combined poses.

| Metric | Experiment A | Experiment B |
|---|---:|---:|
| Geometrically feasible poses | 40/189 | 105/189 |
| Sampled feasibility rate | 21.2% | 55.6% |
| Main limitation | Cable–sphere interference | Cable 5–6 contact |

**Outcome:**

The initial geometric feasibility evaluation is complete.

Experiment B provides greater sampled geometric coverage, but neither configuration is ready for final prototype selection.

### B4 — Six-Cable Sensing Quality

**B4.1 Status:** Completed — November 2026.

**B4.2 Status:** Planned; may proceed in parallel with prototype development.

B4.1 evaluated the analytical measurement Jacobian, local identifiability, singular values, condition numbers and predicted pose covariance.

| Metric | Experiment A | Experiment B |
|---|---:|---:|
| Median scaled sigma_min | 0.1826 | 0.4162 |
| Median condition number | 11.1157 | 4.4673 |
| Median position uncertainty | 0.3860 mm | 0.1657 mm |
| Median orientation uncertainty | 0.5663 deg | 0.2913 deg |

The uncertainty results assume independent cable-length noise with a standard deviation of 0.1 mm.

These are local theoretical predictions, not experimentally measured pose-estimation errors.

**B4.2 — Forward Kinematics and Monte Carlo**

Remaining tasks:

- Validate nonlinear six-degree-of-freedom pose estimation.
- Evaluate position and orientation RMSE.
- Investigate estimator convergence and ambiguity.
- Evaluate sensitivity to cable-length noise and geometric calibration errors.
- Compare estimated errors with B4.1 covariance predictions.

B4.2 should be completed before making validated pose-accuracy claims, but it does not need to block preliminary mechanical-frame design.

### B5 — Rapid Six-Cable Configuration Selection

**Status:** Current.

**Main Objective:**

Select an adjustable and practically implementable six-cable Prototype Configuration V1.0 without requiring proof of global optimality.

**B5.1 — Configuration Audit and Candidate Expansion**

- Review Experiment A and B anchor–attachment coordinates.
- Identify existing geometric limitations.
- Expand candidate anchor and attachment regions.
- Explore different cable-pairing arrangements.
- Define initial manufacturing and adjustment requirements.

**B5.2 — Fast Geometric Screening**

- Evaluate balloon containment.
- Evaluate cable–sphere interference.
- Evaluate cable–cable interference.
- Introduce parameterised physical cable clearances.
- Identify promising geometrically feasible configurations.

**B5.3 — Multi-Pose Sensing Evaluation**

- Evaluate Jacobian rank and scaled singular values.
- Evaluate condition numbers.
- Predict local position and orientation uncertainty.
- Compare candidates using common target poses.
- Identify weak sensing directions and unacceptable configurations.

**B5.4 — Shortlist and Local Refinement**

- Retain multiple promising configuration families.
- Improve anchor–attachment placement and cable pairing.
- Evaluate independent validation poses.
- Compare geometric feasibility, sensing quality and implementation complexity.
- Avoid unsupported claims of global optimality.

**B5.5 — Prototype Configuration V1.0 Selection**

- Select six anchor coordinates.
- Select six body-frame attachment coordinates.
- Record the cable-pairing relationship.
- Define the initial experimental pose region.
- Record geometric clearance and sensing quality.
- Calculate preliminary cable-length ranges.
- Identify adjustable mechanical interfaces.

**Expected Outcome:**

A reproducible six-cable Prototype Configuration V1.0 suitable for preliminary engineering sizing.

### B5.5 — Rigid-to-Flexible Balloon Transition

**Status:** Planned immediately after B5.

This work package is distinct from the B5.5 subtask above.

To avoid numbering ambiguity in the active task plan, use:

- B5.1–B5.5 for configuration selection subtasks.
- B5F.1–B5F.5 for flexible compatibility subtasks.

**B5F.1 — Initial Flexible Balloon Model**

Define a reduced-order deformation model and document its assumptions.

**B5F.2 — Attachment Migration**

Estimate how attachment locations move relative to the balloon body during deformation.

**B5F.3 — Flexible Cable Geometry**

Re-evaluate cable lengths and interference using the deformed balloon surface.

**B5F.4 — Rigid–Deformation Observability**

Investigate whether cable-length measurements can distinguish rigid-body motion and deformation.

**B5F.5 — Hardware Compatibility**

Decide whether the selected anchors, attachments and cable-routing arrangement can be retained or require modification.

**Expected Outcome:**

An initial flexible compatibility assessment and documented requirements for an adjustable test rig.

### Phase B Decision Rule

Select a prototype-ready six-cable configuration based on explicit geometric, sensing and mechanical requirements.

Do not treat good Jacobian conditioning as proof of physical feasibility.

Do not delay all prototype development until global optimisation is completed.

Retain the six-cable configuration as the experimental baseline for later seven-/eight-cable comparisons.

---


## 6. Parallel Seven- and Eight-Cable Research

**Status:** Planned parallel theoretical and simulation workstream.

The long-term goal remains the quantitative comparison of six-, seven- and eight-cable sensing systems.

The seven-/eight-cable study does not have to wait until all six-cable experiments are completed.

### 6.1 Seven-Cable Theory

Investigate:

- The 7 × 6 measurement Jacobian.
- Local identifiability and measurement redundancy.
- Scaled singular values and condition number.
- Predicted pose covariance.
- Cable routing and interference.
- Positive-tension feasibility under justified mechanical assumptions.

### 6.2 Eight-Cable Theory

Investigate:

- The 8 × 6 measurement Jacobian.
- Additional measurement redundancy.
- Pose uncertainty and robustness.
- Alternative anchor–attachment configurations.
- Additional routing and mechanical complexity.

### 6.3 Fair Configuration Comparison

Compare six-, seven- and eight-cable systems using:

1. Common target pose sets.
2. Consistent geometry assumptions.
3. Comparable sensor-noise assumptions.
4. The same interference and clearance definitions.
5. Identical pose-estimation metrics.
6. Explicitly stated mechanical constraints.

Additional cables do not automatically guarantee better geometric feasibility or sensing accuracy.

### 6.4 Scheduling Principle

Seven-/eight-cable theoretical studies may proceed during six-cable test-rig design, assembly and experimental validation.

Experimental expansion beyond six cables will be decided using the combined simulation and hardware evidence.

The immediate November 4–17 plan remains focused on B5 and B5.5.

---


## 7. B6 — Engineering Sizing

**Status:** Planned.

**Objective:** Translate Prototype Configuration V1.0 into preliminary hardware requirements.

Main tasks:

- Calculate cable-length ranges across selected poses.
- Estimate required cable payout and retrieval stroke.
- Define balloon mass, inertia and external load assumptions.
- Analyse quasi-static cable tensions and positive-tension feasibility.
- Assess low-tension tracking and passive-motion disturbance.
- Calculate motor torque, speed and drum requirements.
- Establish preliminary sensor specifications.

Core equations:

\[
L_i(q)=\|A_i-(P+Rr_i)\|
\]

\[
\Delta L_i=L_{i,\max}-L_{i,\min}
\]

\[
W(q)T+w_{\mathrm{external}}=0
\]

\[
\tau_{\mathrm{motor}}\approx
\frac{Tr_{\mathrm{drum}}}{\eta}
\]

**Expected Outcome:** Preliminary hardware-sizing calculations and component requirements.

Mass alone is insufficient to determine all cable tensions. The external loads, support conditions and tracking mechanism must also be specified.

---

## 8. B7 — Adjustable Prototype

**Status:** Planned.

**Objective:** Build an adjustable six-cable experimental sensing system.

Design principles:

- Adjustable anchor mounting locations.
- Replaceable balloon attachment interfaces.
- Modular cable winding and routing.
- Measurable cable length and tension.
- Independent ground-truth measurement.
- Provision for additional cable channels.
- Mechanical compatibility with rigid and flexible balloons.

**Expected Outcome:** An operational six-cable test rig capable of supporting repeatable experiments and configuration adjustments.

---

## 9. B8 — Experimental Validation

**Status:** Planned.

### 9.1 Rigid-Balloon Validation

- Cable-length sensor calibration.
- Static pose estimation.
- Combined translation and rotation.
- Position and orientation RMSE.
- Estimator convergence and ambiguity.
- Cable tension and motion disturbance.
- Comparison with B4 numerical predictions.

### 9.2 Flexible-Balloon Validation

- Replace the rigid reference object with a deformable balloon.
- Measure attachment displacement under deformation.
- Evaluate flexible cable routing.
- Compare rigid-model estimates against independent reference measurements.
- Investigate deformation-related estimation errors.
- Evaluate the need for additional measurement information.

**Expected Outcome:** Experimental evidence of sensing performance and limitations.

---

## 10. B9 — Configuration Refinement and Final Comparison

**Status:** Future.

### 10.1 Experimental Configuration Refinement

Use experimental findings to improve:

- Anchor coordinates.
- Attachment coordinates.
- Cable pairing.
- Cable routing.
- Calibration.
- Low-tension tracking.

### 10.2 Deformation Estimation

Investigate reduced-order deformation models, additional sensing information and shape-reconstruction approaches.

### 10.3 Six-/Seven-/Eight-Cable Comparison

Integrate simulation and available experimental results to investigate:

- Measurement redundancy.
- Pose estimation accuracy.
- Local observability and conditioning.
- Geometric sensing workspace.
- Tension and routing constraints.
- System complexity.

The final conclusions must distinguish theoretical predictions, numerical simulation results and experimentally validated findings.

---

## 11. Current Research Milestone

**Date:** 2026-11-04

**Current Task:** B5.1 — Configuration Audit and Candidate Expansion.

**Immediate Objective:**

Select an initial six-cable Prototype Configuration V1.0 that supports early engineering sizing and adjustable prototype development.

### Two-Week Execution Plan

**Planning period:** November 4–17, 2026.

Week 1:

- Review existing A/B configurations.
- Expand anchor and attachment candidate regions.
- Explore configuration families and cable pairing.
- Perform geometric screening.
- Evaluate multi-pose sensing quality.

Week 2:

- Refine promising configurations.
- Select Prototype V1.0.
- Establish a simplified flexible balloon model.
- Evaluate attachment migration.
- Verify initial rigid-to-flexible compatibility.
- Prepare the B6 engineering handoff.

**Daily workload:** Approximately 4–5 hours on research days, with November 4 treated as a half-day.

Detailed tasks are maintained in:

`08_Project_Management/November/weekly_plan_nov_04_17_2026.md`

Research priorities are maintained in:

`08_Project_Management/November/`

**Current Milestone:**

Establish a six-cable prototype-ready configuration while preserving the long-term six-/seven-/eight-cable sensing comparison.

---

## 12. Related Documents

- [Current Research State](../CURRENT_STATE2.md)
- [Research Guidelines](../AGENTS2.md)
- [Active TODO](current_november_todo.md)
- [Weekly Plan 03](weekly_plan_03.md)
- [Rigid-Body Sensing Design](../05_My_Research/Rigid_Body_Sensing_Design.md)
- [Phase B Literature Method Selection](../02_Paper_Reading/Literature_Review/workspace%20definition/Phase_B_Method_Selection_2026-11-02.md)
- [Research Log](../06_Research_Log/)

---

**Next Milestone:** Establish the geometric feasibility and sensing performance of the six-cable configurations before beginning additional cable design.

**Guiding Principle:** Select methods according to research questions and validate results before making design decisions.
