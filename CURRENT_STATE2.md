
# Current Research State

**Version:** 0.6  
**Last Updated:** 2026-11-04  
**Current Phase:** Phase B — Balloon-Specific Cable Sensing Design  
**Current Task:** B5.1 — Configuration Audit and Candidate Expansion  
**Primary Tool:** MATLAB

---

## 1. Current Research Direction

### Long-Term Goal

Develop a cable-based measurement system capable of estimating the position, orientation and eventually deformation or shape of a passively moving balloon-like object.

The system focuses on measurement and state estimation rather than active trajectory control.

### Two Parallel Workstreams

**Workstream A — Six-Cable Prototype and Experiments**

Current engineering priority:

1. Select an adjustable six-cable Prototype V1.0.
2. Evaluate rigid-to-flexible compatibility.
3. Complete engineering sizing.
4. Build an adjustable test rig.
5. Validate rigid and flexible balloon sensing experimentally.
6. Refine the system using experimental results.

**Workstream B — Seven-/Eight-Cable Theory and Simulation**

Parallel research includes:

- Measurement redundancy.
- Jacobian and observability analysis.
- Sensing uncertainty.
- Workspace and interference.
- Cable-number performance comparison.

Seven-/eight-cable theory may proceed while the six-cable experimental system is developed.

The long-term comparison of six-, seven- and eight-cable systems remains a central research objective.

---

## 2. Established Engineering Baseline

| Parameter | Current Definition |
|---|---|
| Engineering boundary | 280 × 300 × 320 mm |
| Coordinate system | X = Length, Y = Width, Z = Height |
| Balloon volume | 550 mL |
| Initial balloon model | Rigid sphere |
| Equivalent radius | Approximately 50.83 mm |
| Initial cable number | 6 |
| Anchor candidate samples | 26 |
| Attachment candidate samples | 40 |
| Primary measurement | Cable length |
| Motion | Passive and unknown |
| Tracking concept | Motor-assisted low-tension following |

The simplified engineering boundary is not a clinically validated gastric workspace.

### Current Evaluation Pose Set

- 27 centre positions.
- Seven orientation cases.
- 189 combined poses.

Position samples:

\[
P_x,P_y,P_z\in\{-50,0,50\}\ \mathrm{mm}
\]

Orientation samples:

- Zero rotation.
- Roll ±10°.
- Pitch ±10°.
- Yaw ±10°.

These are discrete engineering samples, not measured gastric motion trajectories.

---

## 3. Completed Research

### Phase A — Reference Method Reproduction

**Status:** Completed.

| Task | Method |
|---|---|
| A1 | RREF, Tension Factor and WCC |
| A2 | Single-pose anchor-region analysis |
| A3 | Multi-pose feasible-region intersection |
| A4 | Forward kinematics, Jacobian and uncertainty |
| A5 | Three-dimensional workspace sampling |

These methods provide the numerical foundation for Phase B.

Their reference-model results do not directly validate the balloon sensing system.

### B1 — Geometry and Candidate Regions

**Status:** Completed.

Established:

- Engineering boundary.
- Rigid spherical balloon model.
- Feasible centre region.
- Anchor and attachment candidate sets.
- MATLAB geometry baseline.

### B2 — Initial Six-Cable Configuration Comparison

**Status:** Completed.

| Metric | Baseline | Experiment A | Experiment B |
|---|---:|---:|---:|
| Jacobian rank | 6 | 6 | 6 |
| Scaled minimum singular value | 0.004393 | 0.535345 | 0.533600 |
| Scaled condition number | 490.956 | 3.5759 | 3.2365 |

Experiment A used fixed face-centre anchors and variable attachments.

Experiment B used variable anchors and attachments.

Both initial searches used 20,000 random trials at the reference pose.

These results do not establish global optimality.

### B3 — Multi-Pose Geometric Feasibility

**Status:** Completed.

| Metric | Experiment A | Experiment B |
|---|---:|---:|
| Cable–sphere pass | 40/189 | 186/189 |
| Cable–cable pass | 189/189 | 108/189 |
| Combined geometric pass | 40/189 | 105/189 |
| Combined pass rate | 21.2% | 55.6% |

Main findings:

- Experiment A is mainly limited by cable–sphere interference.
- Experiment B has 81 cable-contact cases involving Cable Pair 5–6.
- Experiment B provides higher sampled geometric coverage.
- Neither candidate is ready for final hardware selection.

The tests used ideal straight cable segments without validated physical clearance margins.

### B4.1 — Jacobian and Sensing Quality

**Status:** Completed.

| Metric | Experiment A | Experiment B |
|---|---:|---:|
| Median scaled minimum singular value | 0.1826 | 0.4162 |
| Median scaled condition number | 11.1157 | 4.4673 |
| Median predicted position uncertainty | 0.3860 mm | 0.1657 mm |
| Median predicted orientation uncertainty | 0.5663° | 0.2913° |

The statistics above use each configuration's own geometrically feasible pose subset.

The predicted uncertainties assume independent cable-length noise with standard deviation 0.1 mm.

These are local theoretical predictions, not experimentally measured pose-estimation errors.

Nineteen sampled poses were geometrically feasible for both configurations.

**Conclusion:** Experiment B is a useful sensing comparison baseline, but its cable interference prevents direct adoption as Prototype V1.0.

### B4.2 — Nonlinear Pose Estimation

**Status:** Pending.

Remaining work:

- Nonlinear forward kinematics for the selected balloon geometry.
- Estimator convergence and pose ambiguity.
- Monte Carlo noise evaluation.
- Position and orientation RMSE.
- Comparison with B4.1 covariance predictions.

B4.2 may proceed in parallel with preliminary prototype design.

---

## 4. Current Research Task — B5

**Current Task:** B5.1 — Configuration Audit and Candidate Expansion.

**Objective:** Select a practical adjustable six-cable configuration without requiring proof of global optimality.

| Task | Research Activity | Status |
|---|---|---|
| B5.1 | Audit existing configurations and expand candidate regions | Current |
| B5.2 | Multi-pose geometric screening | Planned |
| B5.3 | Multi-pose sensing evaluation | Planned |
| B5.4 | Refinement and Prototype V1.0 selection | Planned |

### Prototype V1.0 Requirements

The provisional configuration should define:

- Six world-frame anchor coordinates.
- Six body-frame attachment coordinates.
- Explicit cable pairing.
- Initial experimental pose region.
- Geometric feasibility and clearance.
- Local sensing-quality metrics.
- Preliminary cable-length ranges.
- Adjustable mounting requirements.
- Remaining physical uncertainties.

A configuration with known critical interference must not be declared fully build-ready.

---

## 5. Next Research Stages

### B5.5 — Rigid-to-Flexible Compatibility

**Status:** Planned.

| Task | Focus |
|---|---|
| B5.5.1 | Reduced-order flexible balloon model |
| B5.5.2 | Attachment migration |
| B5.5.3 | Flexible cable routing |
| B5.5.4 | Rigid–deformation observability |
| B5.5.5 | Hardware compatibility |

The objective is to assess whether the rigid-body configuration can support initial flexible-balloon experiments.

Full deformation reconstruction is not required before preliminary hardware design.

### B6–B9 — Engineering and Experiments

| Stage | Objective |
|---|---|
| B6 | Cable length, tension, motor and sensor sizing |
| B7 | Adjustable six-cable experimental prototype |
| B8 | Rigid and flexible balloon validation |
| B9 | Configuration refinement and deformation estimation |

Seven-/eight-cable theoretical studies may proceed alongside these stages.

---

## 6. Open Research Issues

The main unresolved questions are:

1. Which six-cable configuration meets the geometric and sensing requirements of the initial experimental pose region?
2. What physical cable clearance and mounting geometry are required?
3. How reliably can nonlinear forward kinematics estimate pose?
4. Can low positive cable tension be maintained without excessive disturbance?
5. How does deformation affect attachment locations and cable lengths?
6. Which rigid-body and deformation parameters are observable?
7. What additional information can seven or eight cables provide?
8. Which configuration changes are supported by experimental results?

The distinction between numerical feasibility, physical feasibility and experimentally validated accuracy must be maintained.

---

## 7. Repository References

### Research Rules and Planning

- [Research and AI Rules](AGENTS2.md)
- [Research Roadmap](08_Project_Management/Roadmap.md)
- [November TODO](08_Project_Management/November/current_november_todo_updated_2026_11_04.md)
- [November Weekly Plan](08_Project_Management/November/weekly_plan_nov_04_17_2026.md)

### Technical Design

- [Sensing Objective](05_My_Research/Sensing_Objective_v0.2.md)
- [Rigid-Body Sensing Design](05_My_Research/Rigid_Body_Sensing_Design.md)
- [Prototype V1.0 and Flexible Transition](05_My_Research/Prototype_V1_Rigid_to_Flexible_Design_2026_11_04.md)

### Research Evidence

- [MATLAB Simulations](03_Simulation/MATLAB/)
- [Research Logs](06_Research_Log/)
- [Literature Review](02_Paper_Reading/Literature_Review/)

---

## 8. Immediate Next Action

**B5.1 — Configuration Audit and Candidate Expansion**

1. Load Experiment A and Experiment B datasets.
2. Extract six anchor and attachment coordinate pairs for each configuration.
3. Verify cable-pairing relationships.
4. Identify geometric failure mechanisms.
5. Define Prototype V1.0 design requirements.
6. Expand candidate anchor and attachment regions.

**Expected Output:** A reproducible candidate configuration set and documented requirements for B5.2 geometric screening.

---

**Current Milestone:** Establish an adjustable six-cable Prototype V1.0 while preserving the long-term six-/seven-/eight-cable sensing comparison.

**Guiding Principle:** Research questions determine the methods. Numerical evidence supports design decisions. Experiments validate the physical system.
