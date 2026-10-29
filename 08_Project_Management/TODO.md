# Research TODO — Historical Task Map

> **ARCHIVED — Superseded Task List**
>
> **Original Last Updated:** 2026-10-19  
> **Archived On:** 2026-10-30  
> **Status:** Historical reference only
>
> This document preserves the previous task structure used before the transition to Phase B.
>
> **The active research tasks are maintained in [current_october_november_todo.md](current_october_november_todo.md).**

---

## 1. Purpose

This file records how the previous research tasks relate to the current Phase B work packages.

It must not be used to generate new daily research plans.

The project has moved from a general 3D sensing foundation to balloon-specific cable configuration design.

For current research information, use:

- [Current Research State](../CURRENT_STATE2.md)
- [Active Research TODO](current_october_november_todo.md)
- [Research Roadmap](Roadmap.md)
- [Research Guidelines](../AGENTS2.md)

---

## 2. Previous Task Structure

The earlier research plan contained two major stages.

### Previous Phase 2 — 3D Measurement Foundation

| Original Task | Previous Objective | Current Status or Equivalent |
|---|---|---|
| 2.1 | Define 3D sensing objectives | Completed |
| 2.2 | Define simplified 3D geometry | Continued in B1 |
| 2.3 | Verify the 6-DOF measurement model | Reference implementation completed in A4; balloon-specific work remains |
| 2.4 | Establish 6-DOF pose estimation | Core implementation completed in A4; broader validation remains |

### Previous Phase 3 — Cable Configuration and Sensing Quality

| Original Task | Previous Objective | Current Equivalent |
|---|---|---|
| 3.1 | Compare cable number | B2, B4 and B5 |
| 3.2 | Compare anchor placement | B1, B2 and B4 |
| 3.3 | Compare attachment placement | B1, B2 and B4 |
| 3.4 | Evaluate sensing workspace and accuracy | B3 and B4 |
| 3.5 | Assess low-tension physical feasibility | B3, B5 and Phase C |

These mappings describe the relationship between previous and current tasks. They do not imply that the corresponding Phase B work has been completed.

---

## 3. Why the Task Structure Changed

The original plan combined general mathematical learning, model development, and application-specific configuration design.

The updated research workflow separates these activities:

**Phase A — Method Reproduction**

- Cable tension feasibility.
- Anchor-region feasibility.
- Multi-pose region intersection.
- Forward kinematics and covariance.
- Workspace sampling.

**Phase B — Balloon-Specific Design**

- B1: Geometry and Candidate Regions.
- B2: Configuration Generation.
- B3: Feasibility Screening.
- B4: Sensing Quality Evaluation.
- B5: Configuration Selection.

This separation allows previously verified methods to be reused without repeating the same foundational learning tasks.

---

## 4. Current Research Direction

**Current Phase:** Phase B — Balloon-Specific Cable Sensing Design.

**Current Task:** B1 — Geometry and Candidate Region Definition.

**Immediate Subtask:** B1.1 — Review Existing Geometry Evidence.

The current baseline is:

- Simplified 3D gastric boundary.
- 550 mL rigid spherical balloon proxy.
- Passive and unknown object motion.
- Six-degree-of-freedom pose estimation.
- Six-, seven-, and eight-cable comparison.
- Cable-length-based measurements.
- Proposed motor-assisted low-tension tracking.

The geometry model must be documented before detailed cable configuration optimisation begins.

---

## 5. Instructions for AI and Codex

Do not treat this file as the active research task list.

When planning or implementing research work:

1. Read `AGENTS.md` and `AGENTS2.md`.
2. Read `CURRENT_STATE2.md`.
3. Read `current_october_november_todo.md`.
4. Use `Roadmap.md` for milestone context.
5. Reuse previous MATLAB implementations where relevant.

Do not schedule the historical Task 2.2–3.5 sequence as a separate active plan.

Do not reopen completed A1–A5 methods unless a specific research question requires additional verification.

---

## 6. Historical Note

The previous task structure was useful for defining the transition from 2D learning to 3D rigid-body sensing.

The core mathematical and numerical methods have since been investigated through the A1–A5 reproduction sprint.

The current research now focuses on applying those methods to balloon-specific geometry, cable configuration, feasibility, and sensing performance.

---

**Active Task Source:** [current_october_november_todo.md](current_october_november_todo.md)

**Current Milestone:** B1 — Geometry and Candidate Region Definition.
