# WEEKLY_PLAN.md — Archived Research Schedule

> **ARCHIVED — Superseded Weekly Plan**
>
> **Original Planning Period:** 2026-10-19 to 2026-11-01  
> **Archived On:** 2026-10-30  
> **Status:** Historical planning reference only
>
> This file records an earlier weekly research schedule created before the Phase A method-reproduction sprint.
>
> **Do not use this document to determine current daily research tasks.**

---

## 1. Purpose

This document preserves the original planning direction and explains how it relates to the research work subsequently completed.

The original schedule focused on moving directly from planar cable-robot learning to 3D rigid-body sensing and cable configuration design.

The research strategy was subsequently refined to reproduce and verify essential literature-based methods before beginning balloon-specific configuration design.

The active research phase is now:

**Phase B — Balloon-Specific Cable Sensing Design.**

For current information, use:

- [Current Research State](../CURRENT_STATE2.md)
- [Active Research TODO](current_october_november_todo.md)
- [Research Roadmap](Roadmap.md)
- [Research Guidelines](../AGENTS2.md)

---

## 2. Original Weekly Plan

### Original Week 1 — October 19–25, 2026

**Objective:** Establish the initial 3D rigid-body sensing foundation.

Planned activities included:

- Define the 3D six-degree-of-freedom sensing objective.
- Review the simplified gastric boundary.
- Define a 550 mL rigid spherical reference object.
- Establish preliminary anchor and attachment geometry.
- Implement the cable-length measurement model.
- Develop a 6-DOF Jacobian.
- Begin pose-estimation verification.

**Historical outcome:**

The research objective and passive-motion assumptions were defined.

Initial gastric boundary evidence was investigated.

Rather than completing all application-specific modelling steps in the original schedule, the research progressed toward a literature-based method-reproduction sprint.

### Original Week 2 — October 26–November 1, 2026

**Objective:** Investigate preliminary 6-, 7-, and 8-cable configurations and sensing performance.

Planned activities included:

- Cable-number comparison.
- Anchor-placement comparison.
- Attachment-placement comparison.
- Sensing workspace analysis.
- Pose-estimation accuracy evaluation.
- Preliminary physical-feasibility assessment.

**Historical outcome as of October 30, 2026:**

The core Phase A methods had been implemented and documented.

However, the original balloon-specific 6/7/8-cable comparison was not completed as described in this schedule.

Those application-specific tasks were transferred to Phase B.

---

## 3. Revised Research Execution

The subsequent research plan was:

[Weekly Plan 02 — Phase A Method Reproduction](weekly_plan_02.md)

This sprint focused on:

| Task | Research Focus | Status |
|---|---|---|
| A1 | RREF, Tension Factor and WCC | Core scope completed |
| A2 | Algorithm 1 — Feasible Regions | Core scope completed |
| A3 | Algorithm 2 — Multi-Pose Intersection | Core scope completed |
| A4 | Forward Kinematics and Covariance | Core scope completed |
| A5 | 3D Workspace Sampling | Core scope completed |

The results established reusable MATLAB methods for geometry, feasibility, workspace analysis, pose estimation and sensing uncertainty.

Completion refers to the selected numerical scope, not full physical experimental validation.

---

## 4. Transition to Phase B

The research now applies the completed methods to a 550 mL rigid spherical balloon within a simplified gastric environment.

### Current Work Packages

| Task | Focus |
|---|---|
| B1 | Geometry and Candidate Region Definition |
| B2 | Cable Configuration Generation |
| B3 | Feasibility Screening |
| B4 | Sensing Quality Evaluation |
| B5 | Configuration Selection |

**Current task:** B1 — Geometry and Candidate Region Definition.

**Immediate subtask:** B1.1 — Review Existing Geometry Evidence.

The current actionable task list is maintained in:

[current_october_november_todo.md](current_october_november_todo.md)

Future detailed schedules should be stored in new dated weekly-plan files rather than appended to this historical document.

---

## 5. Weekly Planning Principles Retained

The following working principles remain applicable:

1. Prioritise research questions over isolated learning exercises.
2. Focus each research day on one manageable primary objective.
3. Identify a measurable deliverable for each task.
4. Verify results before marking tasks complete.
5. Record assumptions, limitations and unresolved issues.
6. Preserve completed research records.
7. Carry unfinished work forward explicitly.
8. Avoid repeated tasks already completed in earlier stages.

Detailed working rules are maintained in [AGENTS2.md](../AGENTS2.md).

---

## 6. Historical Planning Decision

The original October 19–November 1 schedule has been superseded by the completed Phase A method-reproduction sprint and the current Phase B research roadmap.

This file is retained to document the evolution of the research planning process.

It is no longer an active weekly schedule.

---

## 7. Related Documents

- [CURRENT_STATE2.md](../CURRENT_STATE2.md) — Current research progress.
- [Roadmap.md](Roadmap.md) — Long-term research milestones.
- [Active TODO](current_october_november_todo.md) — Current B1–B5 tasks.
- [Weekly Plan 02](weekly_plan_02.md) — Phase A sprint record.
- [AGENTS2.md](../AGENTS2.md) — Research and AI working rules.

---

**Next Research Action:** Continue with B1.1 — Review and consolidate existing gastric boundary evidence before defining candidate balloon-specific cable geometry.
