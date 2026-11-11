# Cable-Robot-Based Sensing for a Passive Deformable Balloon

**Master's Research Project**  
**Last Updated:** 2026-11-12  
**Current Phase:** B5.4 — Six-Cable Configuration Optimisation  
**Primary Tool:** MATLAB

---

## 1. Research Overview

This project investigates a cable-length-based sensing system for estimating the position, orientation and eventually deformation of a passively moving balloon-like object.

The application is motivated by intragastric balloon monitoring within a simplified stomach-inspired environment.

### Main Research Question

> Can cable-length measurements reconstruct the pose of a passively moving balloon, and how should cable configurations be designed to achieve reliable sensing while satisfying geometric and mechanical constraints?

The system focuses on **measurement and estimation**, not active trajectory control.

Motors may follow passive balloon displacement to maintain low cable tension without prescribing the balloon's trajectory.

---

## 2. Research Objectives

### Workstream A — Six-Cable Sensing Prototype

The primary objective is to develop and experimentally validate a six-degree-of-freedom pose sensing system.

Research activities include:

- Cable configuration design.
- Geometric feasibility and sensing optimisation.
- Nonlinear pose estimation.
- Robustness and calibration.
- Low-tension mechanical implementation.
- Experimental validation.
- Future deformable-balloon sensing.

### Workstream B — Seven-/Eight-Cable Research

A parallel theoretical workstream investigates:

- Measurement redundancy.
- Local observability.
- Pose-estimation uncertainty.
- Geometric and sensing workspace.
- Cable routing and tension feasibility.
- Hardware complexity.

Additional cables are not assumed to improve sensing automatically.

---

## 3. Initial Engineering Model

| Parameter | Definition |
|---|---|
| Engineering boundary | 280 × 300 × 320 mm |
| Coordinate axes | X = Length, Y = Width, Z = Height |
| Nominal balloon volume | 550 mL |
| Balloon model | Rigid sphere |
| Balloon radius | 50.8266 mm |
| Initial cable number | 6 |
| Estimated state | 6-DOF rigid-body pose |
| Primary measurement | Cable length |
| Anchor installation model | Twelve frame-edge rails |
| Attachment region | Balloon surface |
| Motion | Passive and unknown |

The model is an engineering approximation, not a clinically validated gastric workspace.

---

## 4. Research Progress

| Stage | Research Focus | Status |
|---|---|---|
| Phase 0 | Application and requirements | Initial synthesis completed |
| Phase A | Literature method reproduction | Core scope completed |
| B1–B2 | Geometry and initial configurations | Completed |
| B3–B4 | Geometric feasibility and sensing analysis | Initial scope completed |
| B5.1–B5.2 | Configuration diagnosis and screening | Completed |
| B5.3 | Twelve-rail structured configuration design | Completed |
| B5.4 E1a-A | Config 2 rail-position optimisation | Completed |
| B5.4 E1a-B | Fair comparison across six configurations | **Next** |
| B5.4 E1b–E4 | Further configuration optimisation | Planned |
| B5.5 | Measurement validation and calibration | Planned |
| B5.6 | Prototype engineering and experiments | Planned |

### Current Numerical Reference

`E1a_Robust_Config2_v1`

This configuration has passed the specified sampled geometry and rank checks, but it is **not a final optimal or experimentally validated prototype**.

Six initial Core-eligible configurations remain candidates for fair comparison:

`[2, 4, 6, 8, 12, 17]`

For detailed numerical results, see [CURRENT_STATE2.md](CURRENT_STATE2.md) and the Research Logs.

---

## 5. Repository Structure

| Directory | Purpose |
|---|---|
| [01_Learning](01_Learning/) | Learning and foundational methods |
| [02_Paper_Reading](02_Paper_Reading/) | Literature and research evidence |
| [03_Simulation](03_Simulation/) | MATLAB code and simulation data |
| [04_Code_Exercises](04_Code_Exercises/) | Coding and mathematical exercises |
| [05_My_Research](05_My_Research/) | Technical research models |
| [06_Research_Log](06_Research_Log/) | Verified research records |
| [07_Resources](07_Resources/) | Supporting resources |
| [08_Project_Management](08_Project_Management/) | Research planning and presentation |

---

## 6. Start Here

### Research Management

| Document | Purpose |
|---|---|
| [AGENTS2.md](AGENTS2.md) | Stable research and AI working rules |
| [CURRENT_STATE2.md](CURRENT_STATE2.md) | Current research progress |
| [Roadmap.md](08_Project_Management/Roadmap.md) | Long-term research milestones |
| [Active Research Plan](08_Project_Management/November/B5_3_B5_6_Active_Research_Plan_Six_Cable_Sensing.md) | Current research tasks and methods |
| [Weekly Presentation Template](08_Project_Management/Weekly_Presentation_Template.md) | PPT preparation workflow |

### Research Evidence

- [MATLAB Simulations](03_Simulation/MATLAB/)
- [Research Logs](06_Research_Log/)
- [Literature Review](02_Paper_Reading/Literature_Review/)

Historical and superseded plans are not active research instructions.

---

## 7. Current Research Priority

**B5.4 E1a-B — Six-Configuration Fair Comparison**

The next technical task is to apply equivalent anchor rail-position optimisation to the six Core-eligible configurations.

The comparison will consider:

- Geometric feasibility.
- Worst-case sensing quality.
- Cable clearance and outward margin.
- Installation robustness.
- Pose-estimation performance.

The objective is to identify a defensible shortlist for subsequent optimisation and experimental development.

Detailed procedures are maintained exclusively in the Active Research Plan.

---

## 8. Research Principles

1. Research questions determine the methods.
2. Geometric feasibility and sensing quality are separate requirements.
3. Configuration comparisons must use consistent evaluation criteria.
4. Numerical predictions are not experimental measurements.
5. Independent validation is required for robust conclusions.
6. Physical implementation must consider cable tension and mechanical constraints.
7. Historical numerical evidence should be preserved.

---

**Research Direction:** Six-cable experimental sensing, parallel seven-/eight-cable research, and eventual deformable-balloon measurement.
