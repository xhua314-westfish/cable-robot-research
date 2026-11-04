
# Current Research State

**Version:** 0.6
**Last Updated:** 2026-11-04
**Current Phase:** Phase B — Balloon-Specific Cable Sensing Design
**Current Task:** B5.1 — Configuration Audit and Candidate Expansion
**Primary Tool:** MATLAB

**Current Priority:** Select an adjustable six-cable Prototype V1.0, verify initial flexible-balloon compatibility, and prepare for experimental prototyping.

**Planning Window:** November 4–17, 2026.

---

## 1. Research Direction

### 1.1 Long-Term Goal

Develop a cable-based measurement system to estimate the position, orientation and eventually deformation or shape of a passively moving balloon-like object.

The application is motivated by a simplified intragastric-balloon sensing environment.

The system is intended for measurement and state estimation, not active trajectory control.

Motors may maintain low positive cable tension while tracking passive balloon motion. This architecture remains experimentally unverified.

### 1.2 Cable Number Research Objective

The long-term research objective includes comparing:

- Six-cable sensing.
- Seven-cable sensing.
- Eight-cable sensing.

The comparison will consider pose estimation, measurement redundancy, sensing workspace, geometric feasibility and mechanical complexity.

Six cables provide the initial experimental reference.

Seven- and eight-cable theory and simulation may proceed in parallel with six-cable hardware development.

### 1.3 Two Research Workstreams

**Workstream A — Six-Cable Prototype and Experimental Validation**

Immediate priority:

1. Select Prototype Configuration V1.0.
2. Check rigid-to-flexible compatibility.
3. Calculate cable length, tension and motor requirements.
4. Build an adjustable six-cable test rig.
5. Validate rigid and flexible balloon sensing experimentally.
6. Refine the system using measured results.

**Workstream B — Seven-/Eight-Cable Theory and Simulation**

Parallel research:

1. Extend the measurement Jacobian.
2. Investigate measurement redundancy.
3. Evaluate local sensing quality and uncertainty.
4. Investigate cable interference and workspace.
5. Compare six-, seven- and eight-cable systems under consistent assumptions.

Theoretical research may proceed before completion of six-cable experiments.

Hardware expansion requires separate engineering justification.

---

## 2. Established Engineering Baseline

| Parameter | Current Value |
|---|---|
| Engineering boundary | 280 × 300 × 320 mm |
| Coordinate mapping | X = Length, Y = Width, Z = Height |
| Balloon volume | 550 mL |
| Initial balloon model | Rigid sphere |
| Equivalent balloon radius | Approximately 50.83 mm |
| Initial cable number | 6 |
| Initial anchor candidates | 26 |
| Initial attachment candidates | 40 |
| Measurement | Cable length |
| Motion | Passive and unknown |
| Reference position | [0, 0, 0] mm |
| Reference orientation | Identity matrix |

The rectangular boundary is an engineering approximation, not a clinically validated gastric lumen.

Anchor coordinates are fixed in the world frame.

Rigid-body attachment coordinates are fixed in the balloon body frame.

For a flexible balloon, material attachment positions may change relative to the reference configuration.

### 2.1 Evaluation Pose Set

The current common pose set contains:

- 27 centre positions.
- Seven orientation cases.
- 189 combined poses.

Centre positions:

\[
P_x,P_y,P_z\in\{-50,0,50\}\ \mathrm{mm}
\]

Orientations:

- Zero rotation.
- Roll ±10°.
- Pitch ±10°.
- Yaw ±10°.

These are discrete engineering evaluation samples, not clinically measured motion trajectories.

---

## 3. Completed Research

### 3.1 Phase A — Method Reproduction

**Status: Completed.**

| Task | Completed Method |
|---|---|
| A1 | RREF, Tension Factor and WCC |
| A2 | Single-pose feasible anchor-region analysis |
| A3 | Multi-pose feasible-region intersection |
| A4 | Forward kinematics, covariance and Monte Carlo |
| A5 | Three-dimensional workspace sampling |

These methods provide the theoretical and numerical foundation for balloon-specific research.

Their reference-model results do not directly validate the proposed balloon sensing system.

### 3.2 B1 — Geometry Definition

**Status: Completed.**

Established:

- Engineering boundary.
- Rigid spherical balloon model.
- Geometrically feasible centre region.
- Anchor candidate regions.
- Attachment candidate regions.
- Initial MATLAB geometry dataset.

**Main limitation:** Candidate sampling is coarse and physical mounting constraints remain unverified.

### 3.3 B2 — Initial Six-Cable Configuration Comparison

**Status: Completed.**

| Metric | Baseline | Experiment A | Experiment B |
|---|---:|---:|---:|
| Jacobian rank | 6 | 6 | 6 |
| Scaled minimum singular value | 0.004393 | 0.535345 | 0.533600 |
| Scaled condition number | 490.956 | 3.5759 | 3.2365 |

Experiment A:

- Six fixed face-centre anchors.
- Variable attachment selection.
- 20,000 random trials.

Experiment B:

- Variable anchor and attachment selection.
- 20,000 random trials.
- Five selected anchors on the positive-Z boundary.

**Conclusion:** Anchor and attachment positions strongly affect local sensing performance.

The configurations were initially selected using reference-pose metrics and do not establish global optimality.

### 3.4 B3 — Multi-Pose Geometric Feasibility

**Status: Completed.**

A common set of 189 poses was evaluated.

| Metric | Experiment A | Experiment B |
|---|---:|---:|
| Cable–sphere pass | 40/189 | 186/189 |
| Cable–cable pass | 189/189 | 108/189 |
| Combined geometric pass | 40/189 | 105/189 |
| Combined pass rate | 21.2% | 55.6% |

**Main findings:**

- Experiment A is mainly limited by cable–sphere interference.
- Experiment B has 81 contact cases involving Cable Pair 5–6.
- Experiment B achieves higher sampled geometric coverage.
- Neither configuration is ready for final hardware selection.

The analysis used ideal straight, zero-thickness cable segments.

Physical cable clearance and continuous-workspace feasibility remain unverified.

### 3.5 B4.1 — Jacobian and Sensing Quality

**Status: Completed.**

Sensing metrics were evaluated on each configuration's geometrically feasible sampled poses.

| Metric | Experiment A | Experiment B |
|---|---:|---:|
| Median scaled minimum singular value | 0.1826 | 0.4162 |
| Median scaled condition number | 11.1157 | 4.4673 |
| Median predicted position uncertainty | 0.3860 mm | 0.1657 mm |
| Median predicted orientation uncertainty | 0.5663° | 0.2913° |

**Assumed cable-length noise:** Independent Gaussian noise with standard deviation 0.1 mm.

These uncertainties are local theoretical predictions, not experimentally measured estimation errors.

Nineteen poses were geometrically feasible for both configurations.

Experiment B generally demonstrated stronger local sensing performance on these common poses.

**Research conclusion:**

Experiment B is a useful comparison baseline, but its cable interference prevents direct adoption as Prototype V1.0.

The next task is to search for alternative anchor–attachment arrangements.

---

## 4. Established Mathematical Framework

Detailed derivations are maintained in the technical design documents.

### 4.1 Rigid-Body Measurement Model

For cable \(i\):

\[
B_i=P+Rr_i
\]

\[
L_i=\|A_i-B_i\|
\]

where:

- \(A_i\): Fixed anchor.
- \(r_i\): Body-frame attachment.
- \(P\): Balloon position.
- \(R\): Balloon orientation.

### 4.2 Measurement Jacobian

For small rigid-body perturbations:

\[
\delta L\approx H\delta q
\]

For six cables:

\[
H\in\mathbb{R}^{6\times6}
\]

Full rank is necessary for unconstrained local first-order 6-DOF identifiability.

It does not guarantee globally unique reconstruction or positive-tension feasibility.

### 4.3 Local Pose Covariance

Under appropriate full-rank and noise assumptions:

\[
\Sigma_q\approx
(H^T\Sigma_L^{-1}H)^{-1}
\]

Predicted covariance must not be presented as experimentally validated accuracy.

### 4.4 Flexible-Balloon Measurement Model

An initial deformation-aware model is:

\[
B_i=P+R[r_{i0}+d_i(\eta)]
\]

where \(\eta\) describes selected deformation parameters.

The combined local measurement relationship is:

\[
\delta L\approx
H_{\mathrm{rigid}}\delta q+
H_{\mathrm{def}}\delta\eta
\]

Six scalar cable-length measurements cannot generically identify six independent rigid-body pose components plus additional independent deformation variables without further information or constraints.

### 4.5 Mechanical Tension Model

For a specified quasi-static support and loading model:

\[
W(q)T+w_{\mathrm{external}}=0
\]

Tension feasibility must be evaluated separately from sensing identifiability.

---

## 5. Current Research — B5

**Status: Active.**

**Objective:** Select a numerically justified, adjustable and practically implementable six-cable Prototype Configuration V1.0.

| Task | Research Focus | Status |
|---|---|---|
| B5.1 | Configuration audit and candidate expansion | Current |
| B5.2 | Multi-pose geometric screening | Planned |
| B5.3 | Multi-pose sensing evaluation | Planned |
| B5.4 | Refinement and Prototype V1.0 selection | Planned |

### Prototype V1.0 Requirements

The selected configuration should include:

- Six anchor coordinates.
- Six body-frame attachment coordinates.
- Explicit cable pairing.
- Defined initial experimental pose region.
- Geometric clearance evaluation.
- Local sensing-quality evaluation.
- Preliminary cable-length ranges.
- Adjustable mechanical interfaces.
- Documented assumptions and limitations.

Global optimality is not required.

A configuration with unresolved critical interference must not be labelled fully build-ready.

---

## 6. B5.5 — Rigid-to-Flexible Balloon Transition

**Status: Planned.**

| Task | Research Focus |
|---|---|
| B5.5.1 | Reduced-order flexible balloon model |
| B5.5.2 | Attachment migration |
| B5.5.3 | Flexible cable routing |
| B5.5.4 | Rigid–deformation observability |
| B5.5.5 | Hardware compatibility |

### Primary Research Question

Can the selected rigid-body cable configuration remain useful when the balloon deforms?

The initial flexible study will assess:

- Whether external anchor positions can be retained.
- Whether attachment positions require modification.
- Whether deformation introduces additional cable interference.
- Whether additional measurements are needed.
- Whether the test rig can accommodate future configuration changes.

Full nonlinear membrane modelling and complete shape reconstruction are not prerequisites for initial test-rig development.

---

## 7. Planned Engineering and Experimental Research

| Phase | Main Objective | Status |
|---|---|---|
| B6 | Cable length, tension, motor and sensor sizing | Planned |
| B7 | Adjustable six-cable prototype | Planned |
| B8 | Rigid and flexible balloon experiments | Planned |
| B9 | Configuration refinement and deformation estimation | Planned |

### Engineering Priority

Prototype development should begin as early as practical, using a configuration with documented feasibility and adjustment requirements.

The physical system should allow:

- Anchor repositioning.
- Attachment replacement.
- Cable routing adjustments.
- Sensor calibration.
- Additional cable channels where practical.

---

## 8. Open Research Questions

1. Which six-cable configuration provides acceptable geometric and sensing performance over the initial experimental pose set?
2. What physical cable clearance and mounting constraints are necessary?
3. How accurately can nonlinear forward kinematics reconstruct balloon pose?
4. What cable tensions are required for low-disturbance passive tracking?
5. How do balloon deformation and attachment migration affect measurements?
6. Can rigid pose and selected deformation parameters be estimated independently?
7. What improvements are obtained from seven and eight cables?
8. Which configuration changes are supported by experimental evidence?

---

## 9. Current Execution Plan

**Planning Window:** November 4–17, 2026.

**Immediate Task:** B5.1 — Configuration Audit and Candidate Expansion.

The first two-week plan focuses on:

1. Reviewing existing Experiment A/B coordinates and pairing.
2. Expanding candidate anchor and attachment regions.
3. Screening geometric feasibility.
4. Evaluating multi-pose sensing quality.
5. Refining promising configurations.
6. Selecting a provisional six-cable Prototype V1.0.
7. Performing initial rigid-to-flexible compatibility checks.
8. Preparing engineering sizing inputs.

November 4 is allocated half a research day.

Other weekdays are planned at approximately 4–5 hours per research day.

Detailed tasks and deadlines belong in the active November Weekly Plan, not this state document.

---

## 10. Repository References

### Research Management

- `AGENTS2.md` — Stable AI and research rules.
- `08_Project_Management/Roadmap.md` — Long-term milestones.
- `08_Project_Management/November/current_november_todo_updated_2026_11_04.md` — Active November tasks.
- `08_Project_Management/November/weekly_plan_nov_04_17_2026.md` — Active two-week schedule.

### Technical Design

- `05_My_Research/Rigid_Body_Sensing_Design.md`
- `05_My_Research/Prototype_V1_Rigid_to_Flexible_Design_2026_11_04.md`
- `05_My_Research/Sensing_Objective_v0.2_updated_2026_11_04.md`

### Research Evidence

- `03_Simulation/MATLAB/workspace definition/` — Balloon-specific MATLAB models and datasets.
- `04_Code_Exercises/MATLAB/` — Reference-method implementations.
- `06_Research_Log/2026-11/` — Experiment results and verification records.
- `02_Paper_Reading/Literature_Review/` — Literature evidence and method selection.

---

## 11. Immediate Next Action

**B5.1 — Configuration Audit and Candidate Expansion**

1. Load the saved Experiment A/B configurations.
2. Extract the exact anchor and attachment coordinate tables.
3. Verify the cable-pairing relationships.
4. Identify the existing geometric failure mechanisms.
5. Define the initial Prototype V1.0 design constraints.
6. Expand candidate anchor and attachment regions.

**Expected Output:**

A reproducible candidate configuration set and documented requirements for subsequent geometric screening.

---

**Current Milestone:** Establish an adjustable six-cable Prototype V1.0 while preserving the long-term six-/seven-/eight-cable comparison.

**Guiding Principle:** Research questions determine the methods. Numerical evidence supports design decisions. Experiments validate the physical system.
