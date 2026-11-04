
# Cable-Robot-Based Sensing for a Passive Deformable Balloon

**Master's Research Project**  
**Last Updated:** 2026-11-04  
**Research Phase:** Balloon-Specific Cable Sensing Design  
**Primary Tool:** MATLAB

---

## 1. Research Overview

This project investigates a cable-based measurement system for estimating the position, orientation, and eventually deformation or shape of a passively moving balloon-like object.

The application is motivated by intragastric balloon monitoring within a simplified stomach-like environment.

### Main Research Question

> Can cable measurements be used to estimate the motion and deformation of a passive balloon, and how do cable number and cable configuration affect sensing performance?

The system focuses on **measurement and state estimation**, rather than active trajectory control.

A motor-assisted low-tension tracking architecture is proposed to follow passive balloon motion while minimising cable-induced disturbance.

---

## 2. Research Objectives

### Long-Term Objective

Develop and compare six-, seven-, and eight-cable sensing systems in terms of:

- Pose estimation accuracy.
- Measurement identifiability.
- Sensing workspace.
- Measurement redundancy.
- Geometric and mechanical feasibility.
- System complexity.

The research will progressively extend from rigid-body pose sensing toward deformable-balloon sensing.

### Current Engineering Objective

Develop an adjustable six-cable prototype for numerical and experimental validation.

The initial prototype provides an experimental reference for future seven-/eight-cable comparisons.

---

## 3. Research Strategy

The project follows a research-question-driven and prototype-first approach.

Two research workstreams may proceed in parallel.

### Workstream A — Six-Cable Prototype and Experiments

**Primary engineering priority**

1. Select an adjustable six-cable configuration.
2. Assess rigid-to-flexible balloon compatibility.
3. Determine cable, motor and sensor requirements.
4. Build an experimental test rig.
5. Validate pose estimation experimentally.
6. Investigate flexible-balloon measurement.
7. Refine the system using experimental results.

### Workstream B — Seven-/Eight-Cable Theory and Simulation

**Parallel theoretical priority**

Investigate:

- Measurement Jacobians and redundancy.
- Sensing quality and pose uncertainty.
- Geometric workspace.
- Cable interference and tension feasibility.
- Configuration optimisation.
- Performance comparison with six cables.

Theoretical seven-/eight-cable research may proceed while the six-cable prototype is being developed.

Physical expansion will depend on numerical and experimental evidence.

---

## 4. Initial Engineering Model

| Parameter | Definition |
|---|---|
| Application | Passive balloon sensing |
| Engineering boundary | 280 × 300 × 320 mm |
| Coordinate axes | X = Length, Y = Width, Z = Height |
| Nominal balloon volume | 550 mL |
| Initial balloon model | Rigid sphere |
| Equivalent sphere radius | Approximately 50.83 mm |
| Initial measurement state | Six-degree-of-freedom pose |
| Primary measurements | Cable lengths |
| Initial cable number | 6 |
| Long-term comparison | 6, 7 and 8 cables |
| Motion | Passive and unknown |
| Tracking | Proposed low-tension cable following |

The balloon and gastric boundary are engineering approximations.

They are not clinically validated representations of gastric anatomy or physiological motion.

---

## 5. Research Development

| Stage | Research Focus | Status |
|---|---|---|
| Phase 0 | Application and clinical evidence | Initial synthesis completed |
| Phase A | Literature method reproduction | Core methods completed |
| B1 | Geometry and candidate regions | Completed |
| B2 | Initial six-cable configurations | Completed |
| B3 | Multi-pose geometric feasibility | Completed |
| B4.1 | Jacobian and local sensing quality | Completed |
| B4.2 | Nonlinear pose estimation validation | Pending |
| B5 | Prototype configuration selection | Current work package |
| B5.5 | Rigid-to-flexible compatibility | Planned |
| B6 | Engineering sizing | Planned |
| B7 | Adjustable prototype | Planned |
| B8 | Experimental validation | Planned |
| B9 | Experimental refinement | Future |

Seven-/eight-cable theory and simulation form a parallel research workstream.

For the authoritative latest status, see `CURRENT_STATE2.md` and the active November research plan.

---

## 6. Repository Structure

| Directory | Responsibility |
|---|---|
| [01_Learning](01_Learning/) | Foundational learning and tutorials |
| [02_Paper_Reading](02_Paper_Reading/) | Literature review and evidence |
| [03_Simulation](03_Simulation/) | MATLAB simulation and datasets |
| [04_Code_Exercises](04_Code_Exercises/) | Mathematical and algorithm exercises |
| [05_My_Research](05_My_Research/) | Research models and engineering design |
| [06_Research_Log](06_Research_Log/) | Numerical and experimental results |
| [07_Resources](07_Resources/) | Supporting resources |
| [08_Project_Management](08_Project_Management/) | Roadmap, TODO and weekly plans |

---

## 7. Start Here

### Research Management

1. [AGENTS2.md](AGENTS2.md) — Research and AI working rules.
2. [CURRENT_STATE2.md](CURRENT_STATE2.md) — Research progress and current task.
3. [Research Roadmap](08_Project_Management/Roadmap.md) — Long-term milestones.
4. [November Research TODO](08_Project_Management/November/current_november_todo_updated_2026_11_04.md) — Research tasks and acceptance criteria.
5. [November Weekly Plan](08_Project_Management/November/weekly_plan_nov_04_17_2026.md) — Daily execution plan.

### Technical Research Documents

- [Sensing Objective](05_My_Research/Sensing_Objective_v0.2.md)
- [Rigid-Body Sensing Design](05_My_Research/Rigid_Body_Sensing_Design.md)
- [Prototype V1.0 and Flexible Transition](05_My_Research/Prototype_V1_Rigid_to_Flexible_Design_2026_11_04.md)
- [Workspace Boundary](05_My_Research/Workspace_Boundary_v0.2_2026-10-20.md)

### Research Evidence

- [MATLAB Simulations](03_Simulation/MATLAB/)
- [MATLAB Code Exercises](04_Code_Exercises/MATLAB/)
- [Research Logs](06_Research_Log/)
- [Literature Review](02_Paper_Reading/Literature_Review/)

---

## 8. Current Research Priority

**Work Package:** B5 — Rapid Six-Cable Prototype Configuration Selection.

**Initial Task:** B5.1 — Configuration Audit and Candidate Expansion.

The current objective is to identify a geometrically feasible, numerically justified and adjustable six-cable configuration suitable for initial prototype development.

The selection does not require proof of global optimality.

The selected configuration will subsequently undergo rigid-to-flexible compatibility assessment and engineering sizing.

Detailed daily activities belong in the active Weekly Plan.

---

## 9. Research Principles

1. Research questions determine the methods.
2. Passive balloon motion must not be confused with active trajectory control.
3. Simulation results must be distinguished from experimental validation.
4. Geometric feasibility and sensing accuracy are separate requirements.
5. The initial prototype should support mechanical adjustment.
6. Seven-/eight-cable theory may progress in parallel.
7. Additional cables do not automatically guarantee better sensing.
8. Experimental evidence should guide subsequent configuration refinement.
9. The long-term goal includes deformation and shape estimation.

---

**Research Direction:** Six-cable experimental reference, parallel seven-/eight-cable theoretical investigation, and eventual deformable-balloon sensing.
