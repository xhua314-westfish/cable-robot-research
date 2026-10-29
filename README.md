# Cable-Robot-Based Sensing for a Passive Deformable Balloon

**Master's Research Project**  
**Last Updated:** 2026-10-30  
**Current Phase:** Phase B — Balloon-Specific Cable Sensing Design  
**Current Task:** B1 — Geometry and Candidate Region Definition  
**Primary Tool:** MATLAB

---

## 1. Research Overview

This project investigates a cable-based sensing system for estimating the position, orientation, and eventually deformation or shape of a passively moving balloon-like object.

The application is motivated by intragastric balloon monitoring within a simplified gastric environment.

The central research question is:

> How can cable measurements be used to estimate the state of a balloon undergoing unknown passive motion and deformation?

The system is designed for **measurement and state estimation**, rather than active trajectory control.

A motor-assisted low-tension cable tracking architecture is proposed to maintain cable engagement while minimising disturbance to the balloon's passive motion.

---

## 2. Current Research Scope

The initial study focuses on rigid-body pose sensing before investigating balloon deformation.

| Parameter | Current Definition |
|---|---|
| Application | Intragastric balloon sensing |
| Environment | Simplified 3D gastric boundary |
| Population reference | Adult female |
| Balloon model | 550 mL rigid spherical proxy |
| Equivalent sphere diameter | Approximately 101.7 mm |
| Measurement objective | 3D position and orientation (6-DOF) |
| Primary measurements | Cable lengths |
| Motion assumption | Passive and unknown |
| Cable configurations | 6, 7 and 8 cables |
| Design variables | Anchor and attachment placements |
| Tracking architecture | Proposed motor-assisted low-tension tracking |
| Evaluation | Feasibility, identifiability, uncertainty and pose accuracy |

The simplified gastric environment and rigid balloon are engineering approximations. They are not validated representations of real gastric movement or balloon deformation.

---

## 3. Research Development

The project follows a research-question-driven workflow:

Research Question → Evidence and Assumptions → Mathematical Model → MATLAB Implementation → Verification → Research Conclusion

### Research Phases

| Phase | Focus | Status |
|---|---|---|
| Phase 0 | Application and Clinical Evidence | Initial synthesis completed |
| Phase A | Literature-Based Method Reproduction | Core scope completed |
| Phase B | Balloon-Specific Configuration Design | Current |
| Phase C | Rigid-Body Sensing Validation | Planned |
| Phase D | Deformable-Balloon Extension | Future |

### Phase A — Completed Foundation

The core computational methods from four reference papers have been implemented and investigated.

| Task | Method | Outcome |
|---|---|---|
| A1 | RREF and Tension Factor | Cable tension feasibility analysis |
| A2 | Algorithm 1 | Feasible anchor-region calculation |
| A3 | Algorithm 2 | Multi-pose region intersection |
| A4 | Forward Kinematics | Pose estimation, Jacobian, covariance and Monte Carlo |
| A5 | Workspace Sampling | Sampled 3D feasibility evaluation |

These implementations establish the computational foundation for subsequent balloon-specific configuration design.

The results were obtained using selected reference geometries and simulation assumptions. They do not constitute complete reproduction of every published method or physical experimental validation.

### Phase B — Current Research

The current phase applies the established methods to the 550 mL spherical balloon model.

| Task | Research Focus | Status |
|---|---|---|
| B1 | Geometry and Candidate Region Definition | Current |
| B2 | Cable Configuration Generation | Planned |
| B3 | Feasibility Screening | Planned |
| B4 | Sensing Quality Evaluation | Planned |
| B5 | Configuration Selection | Planned |

The primary comparison will evaluate **six-, seven-, and eight-cable configurations** under consistent geometry and measurement assumptions.

---

## 4. Main Technical Methods

The research uses:

- Three-dimensional cable geometry and length models.
- Six-degree-of-freedom measurement Jacobians.
- Local measurement identifiability analysis.
- Wrench and cable-tension feasibility checks.
- Geometric and sampled workspace evaluation.
- Nonlinear least-squares forward kinematics.
- Pose covariance and uncertainty prediction.
- Monte Carlo simulation.
- Position and orientation error analysis.

**Key distinction:** A configuration with satisfactory mechanical feasibility does not necessarily provide accurate or identifiable measurements. Feasibility and sensing quality must be evaluated separately.

---

## 5. Repository Structure

| Directory | Purpose |
|---|---|
| [01_Learning](01_Learning/) | Supporting theory and foundational learning |
| [02_Paper_Reading](02_Paper_Reading/) | Academic literature and clinical evidence |
| [03_Simulation](03_Simulation/) | Simulation models and environments |
| [04_Code_Exercises](04_Code_Exercises/) | MATLAB implementations and numerical exercises |
| [05_My_Research](05_My_Research/) | Research models, design decisions and methods |
| [06_Research_Log](06_Research_Log/) | Experiment records and research progress |
| [07_Resources](07_Resources/) | Supporting resources |
| [08_Project_Management](08_Project_Management/) | Research planning and task management |

---

## 6. Key Project Documents

### Start Here

- [AGENTS2.md](AGENTS2.md) — Research and AI working rules.
- [CURRENT_STATE2.md](CURRENT_STATE2.md) — Current research state and verified progress.
- [Research Roadmap](08_Project_Management/Roadmap.md) — Research phases and milestones.
- [Active Research TODO](08_Project_Management/current_october_november_todo.md) — Active research tasks and completion criteria.

### Research Models

- [Sensing Objective](05_My_Research/Sensing_Objective_v0.2.md) — Measurement objectives and research assumptions.
- [Rigid-Body Sensing Design](05_My_Research/Rigid_Body_Sensing_Design.md) — Measurement geometry and estimation methods.
- [Workspace Boundary](05_My_Research/Workspace_Boundary_v0.2_2026-10-20.md) — Initial gastric boundary evidence and modelling assumptions.

### Code and Research Records

- [MATLAB Scripts](04_Code_Exercises/MATLAB/) — Numerical implementations.
- [October Research Logs](06_Research_Log/2026-10/) — Phase A research results and verification notes.
- [Phase A Historical Plan](08_Project_Management/weekly_plan_02.md) — Original reproduction schedule and closeout.

---

## 7. Current Research Priority

**Active Task: B1 — Geometry and Candidate Region Definition**

The next objectives are:

1. Consolidate existing gastric boundary evidence and engineering assumptions.
2. Define the 550 mL spherical balloon geometry.
3. Establish a geometrically feasible balloon-centre region.
4. Define preliminary fixed anchor regions.
5. Define candidate attachment regions on the balloon surface.
6. Implement and verify the combined MATLAB geometry model.

The geometry baseline must be established before optimising cable configurations.

---

## 8. Long-Term Research Direction

Following the selection and validation of an initial rigid-body sensing configuration, the research may extend to:

- Passive-motion sensing under more complex measurement conditions.
- Cable tension tracking and mechanical disturbance evaluation.
- Sensor calibration and experimental ground-truth comparison.
- Balloon deformation modelling.
- Shape estimation and reconstruction.

The long-term objective is to investigate whether cable measurements can provide useful quantitative information about a passively moving and deforming balloon.

---

**Current Milestone:** B1 — Establish a balloon-specific 3D geometry baseline and candidate anchor/attachment regions for subsequent 6/7/8-cable configuration evaluation.
