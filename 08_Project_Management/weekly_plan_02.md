# Weekly Plan 02 — Phase A Method Reproduction

**Original Planning Period:** 2026-10-22 to 2026-11-18  
**Last Reviewed:** 2026-10-30  
**Status:** Closed — Core A1–A5 Scope Completed Early  
**Primary Tool:** MATLAB  
**Original Workload:** 4–5 hours per research day

---

## 1. Purpose

This file records the original Phase A research sprint and its actual completion status.

The purpose of Phase A was to understand, implement, and verify selected cable-robot methods before applying them to the balloon-specific research problem.

The original four-week schedule was completed ahead of its planned end date at the core-method level.

This is now a historical research record rather than an active daily task list.

**Current research phase:** Phase B — Balloon-Specific Cable Sensing Design.

For active tasks, see [current_october_november_todo.md](current_october_november_todo.md).

---

## 2. Original Research Objectives

The planned work covered five tasks:

| Task | Original Objective | Actual Status |
|---|---|---|
| A1 | Reproduce RREF, Tension Factor and WCC concepts | Core scope completed |
| A2 | Reproduce Paper 3 Algorithm 1 | Core scope completed |
| A3 | Reproduce Paper 3 Algorithm 2 | Core scope completed |
| A4 | Implement forward kinematics and uncertainty evaluation | Core scope completed |
| A5 | Implement workspace sampling and feasibility checks | Core scope completed |

The main objective was to develop reusable computational methods, not to optimise a gastric-balloon cable configuration during this sprint.

---

## 3. Completed Work and Verified Outcomes

### A1 — Cable Tension Feasibility

**Reference:** Paper 2 — RREF / Tension Factor.

Completed:

- Implemented and verified the planar cable force example.
- Applied RREF to determine cable force relationships.
- Verified equilibrium residuals.
- Calculated Tension Factor.

**Selected result:** TF ≈ 0.6671.

**Transferred method:** Cable force feasibility analysis.

**Limitation:** Tension Factor is not a direct sensing-accuracy metric.

### A2 — Algorithm 1: Feasible Anchor Regions

**Reference:** Paper 3.

Completed:

- Constructed the seven-cable reference geometry.
- Evaluated wrench matrix rank.
- Implemented RREF-based feasibility conditions.
- Sampled candidate anchor locations.
- Evaluated the feasible point cloud.
- Verified the selected numerical inequalities.

**Selected result:** 29,291 feasible candidate points from 68,921 sampled locations for the selected single-pose case.

**Transferred method:** Feasible anchor-region screening.

**Limitation:** Results depend on the reference geometry, target anchor and selected pose.

### A3 — Algorithm 2: Multi-Pose Region Intersection

**Reference:** Paper 3.

Completed:

- Implemented feasibility tests across eight sampled poses.
- Intersected candidate feasible regions.
- Verified the non-increasing feasible-point counts.
- Extended the analysis to all seven cables.
- Saved implementation and explanatory notes.

**Selected result:** 1,005 feasible candidate locations in the selected A7 eight-pose intersection.

**Transferred method:** Multi-pose feasibility evaluation.

**Limitation:** The result represents sampled poses and candidate points, not a continuous or clinically validated workspace.

### A4 — Forward Kinematics and Pose Uncertainty

**Reference:** Paper 4.

Completed:

- Implemented the eight-cable measurement model.
- Derived and numerically checked the 8×6 measurement Jacobian.
- Verified noiseless pose reconstruction.
- Implemented Gauss–Newton forward kinematics with noisy cable lengths.
- Computed local pose covariance.
- Performed 100 independent Monte Carlo trials.
- Evaluated Bias, RMSE, standard deviation and 3σ coverage.
- Computed NEES and the ANEES consistency interval.

**Selected results:**

| Metric | Result |
|---|---|
| Jacobian rank | 6 |
| Maximum numerical Jacobian error | 4.102 × 10⁻¹¹ |
| Noise standard deviation | 1 mm |
| Predicted position std (X/Y/Z) | 0.5018 / 0.9462 / 0.6340 mm |
| Monte Carlo position std (X/Y/Z) | 0.5170 / 0.9731 / 0.6753 mm |
| Average NEES | 6.6459 |
| 95% ANEES interval | [5.3402, 6.6977] |
| ANEES consistency test | Passed |

**Transferred methods:** Six-degree-of-freedom pose estimation and uncertainty evaluation.

**Limitations:**

- Known rigid reference geometry.
- Fixed true pose in the main Monte Carlo test.
- Simplified independent Gaussian measurement noise.
- Gauss–Newton rather than complete reproduction of all published optimisation methods.
- No physical hardware validation.

### A5 — 3D Workspace Sampling

**Reference:** Paper 1 workspace review.

Completed:

- Implemented a 3D position-sampling grid.
- Evaluated WCC feasibility.
- Added cable-length limits.
- Compared three roll-angle cases.
- Calculated combined feasible regions.
- Visualised feasible workspace points.

**Selected results:**

| Metric | Result |
|---|---:|
| Total sampled positions | 2,197 |
| WCC-feasible positions at 0° | 861 |
| WCC and length feasible at 0° | 765 |
| Combined feasible at −10° roll | 623 |
| Combined feasible at +10° roll | 175 |
| Feasible at all three roll angles | 95 |

**Transferred method:** Sampled workspace feasibility analysis.

**Limitation:** This was an illustrative geometry and a method-inspired implementation, not a reconstruction of a real gastric workspace.

---

## 4. Original Schedule Versus Actual Progress

| Original Week | Original Focus | Actual Outcome |
|---|---|---|
| Week 1: Oct 22–28 | A1, A2 and initial A3 | Core methods developed |
| Week 2: Oct 29–Nov 4 | A3, A5 and initial A4 | Core scope completed ahead of schedule |
| Week 3: Nov 5–11 | A4 estimation and covariance | Core tasks completed before planned dates |
| Week 4: Nov 12–18 | A4 validation and documentation | Core validation and handoff completed before planned dates |

The table describes progress against the original schedule. It does not imply that all optional or exploratory subtasks were performed.

---

## 5. Incomplete or Optional Extensions

The following are not required to close the core Phase A scope:

- Full reproduction of every optimisation method in Paper 4.
- Comprehensive FK convergence tests over many initial guesses.
- High-density continuous workspace approximation.
- Complete six-degree-of-freedom orientation coverage.
- Full physical cable-interference modelling.
- Hardware validation and independent experimental ground truth.

These should be revisited only when they directly support a Phase B or Phase C research question.

---

## 6. Lessons Learned

### 6.1 Wrench Feasibility and Sensing Quality Are Different

A cable configuration may be wrench-feasible without providing well-conditioned pose measurements.

Likewise, a locally full-rank measurement Jacobian does not guarantee positive-tension feasibility.

Both must be considered in balloon-specific configuration design.

### 6.2 More Cables Do Not Automatically Guarantee Better Results

The effect of cable count depends on:

- Anchor and attachment geometry.
- Measurement independence.
- Measurement noise.
- Feasible workspace.
- Mechanical constraints.

The six-, seven-, and eight-cable systems must be compared under explicit and consistent conditions.

### 6.3 Pose Covariance Is Local and Model-Dependent

The expression

\[
P_{\mathrm{cov}}\approx(H^TV^{-1}H)^{-1}
\]

provides a local uncertainty approximation.

It does not establish global pose uniqueness or actual hardware accuracy.

### 6.4 Workspace Coverage Must Be Defined Explicitly

Geometric containment, cable-length feasibility, tension feasibility and sensing feasibility should not be combined without clearly stated conditions.

Sampling-based coverage depends on the selected grid and orientation samples.

### 6.5 Research-Driven Learning Is Effective

The completed sprint used a research-question-driven sequence:

Research question → Theory → Mathematical model → MATLAB implementation → Numerical verification → Research note → Next decision.

Future learning should continue to support the application-specific research tasks.

---

## 7. Phase A Research Outputs

### MATLAB Implementations

Stored primarily in:

[04_Code_Exercises/MATLAB](../04_Code_Exercises/MATLAB/)

Main scripts include:

- `paper2__TF_reproduction_2026_10_22.m`
- `paper3_algorithm2_clean.m`
- `paper1_workspace_sampling_final.m`
- `paper4_cable_forward_kinematics_2026_10_27.m`

### Research Notes

Stored primarily in:

[06_Research_Log/2026-10](../06_Research_Log/2026-10/)

Records include:

- `paper2_TF_notes.md`
- `paper3_algorithm1_notes.md`
- `paper3_algorithm2_notes.md`
- `paper3_algorithms_1_and_2_research_summary.md`
- `paper1_workspace_sampling_notes.md`
- `paper4_forward_kinematics_notes.md`
- `A4_to_cable_comparison_plan.md`

The current repository files are the retained evidence of Phase A progress.

---

## 8. Phase A Closeout

### Core Completion Checklist

- [x] A1 core method implemented and documented.
- [x] A2 feasible-region calculation completed.
- [x] A3 multi-pose intersection completed.
- [x] A4 pose estimation and uncertainty evaluation completed.
- [x] A5 workspace-sampling model completed.
- [x] Main research findings recorded.
- [x] Reusable methods identified for Phase B.

### Remaining Research Limitations

- No balloon-specific anchor/attachment optimisation has been completed.
- No clinically validated 3D gastric workspace has been established.
- No physical low-tension tracking system has been validated.
- Deformation and shape estimation remain future research topics.

**Phase A Closeout Decision:**

The core method reproduction sprint is complete.

The next research effort should apply the methods to the selected balloon geometry rather than continue unrelated paper reproduction.

---

## 9. Handoff to Phase B

**Next Task: B1 — Geometry and Candidate Region Definition.**

Immediate priorities:

1. Review and consolidate the existing gastric boundary evidence.
2. Define the 550 mL spherical balloon and feasible centre region.
3. Establish initial anchor and attachment candidate regions.

### References

- [Current Research State](../CURRENT_STATE2.md)
- [Research Roadmap](Roadmap.md)
- [Actionable TODO](current_october_november_todo.md)
- [Research Guidelines](../AGENTS2.md)

---

**Final Status:** Phase A core scope closed; Phase B geometry definition is the next active research task.
