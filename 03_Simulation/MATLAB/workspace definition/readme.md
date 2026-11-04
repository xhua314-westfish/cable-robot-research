
# MATLAB Simulation — Balloon Cable Sensing

**Last Updated:** 2026-11-04  
**Research Phase:** Phase B — Balloon-Specific Cable Sensing Design  
**Current Task:** B5.1 — Configuration Audit and Candidate Expansion

---

## 1. Purpose

This directory contains MATLAB scripts and numerical datasets for the cable-based sensing system.

The current model uses:

- Engineering boundary: 280 × 300 × 320 mm.
- Coordinate axes: X = Length, Y = Width, Z = Height.
- Balloon: 550 mL rigid spherical reference.
- Initial cable number: 6.
- Measurements: Cable lengths.
- Motion assumption: Passive and unknown.

The engineering boundary is a numerical approximation, not a clinically validated gastric workspace.

---

## 2. Completed Simulations

| Task | MATLAB Script | Status |
|---|---|---|
| B1 | `B1_balloon_geometry_2026_10_30.m` | Completed |
| B2.1 | `B2_6cable_baseline_2026_11_02.m` | Completed |
| B2.2 | `B2_configuration_comparison_2026_11_02.m` | Completed |
| B2.2 | `B2_experiment_B_joint_search_2026_11_02.m` | Completed |
| B3.1 | `B3_1_multi_position_feasibility_2026_11_02.m` | Completed |
| B3.1 | `B3_1_segment_distance_3d_2026_11_02.m` | Completed |
| B3.2 | `B3_2_multi_pose_feasibility_2026_11_03.m` | Completed |
| B4.1 | `B4_1_jacobian_verification_2026_11_03.m` | Completed |

"Completed" refers to the documented research task, not experimental validation or exhaustive verification of every possible pose.

---

## 3. Saved MATLAB Datasets

| Dataset | Description |
|---|---|
| `B1_geometry_baseline.mat` | Initial boundary and balloon geometry |
| `B2_6cable_experiment_A.mat` | Experiment A configuration |
| `B2_experiment_B_results.mat` | Experiment B configuration |
| `B3_1_results.mat` | Multi-position geometric feasibility |
| `B3_2_results.mat` | Multi-pose geometric feasibility |
| `B4_1_results.mat` | Local Jacobian and sensing-quality evaluation |

The saved datasets provide reproducible inputs and results for subsequent research.

Preserve original experiment files when generating new configurations.

---

## 4. Current Research — B5

**Current Task:** B5.1 — Configuration Audit and Candidate Expansion.

The next simulation activities include:

1. Load the existing Experiment A and B configurations.
2. Verify anchor and attachment coordinates.
3. Verify cable pairing.
4. Expand anchor and attachment candidate regions.
5. Generate alternative six-cable configuration families.
6. Prepare candidate datasets for geometric screening.

The subsequent tasks are:

| Task | Objective |
|---|---|
| B5.2 | Multi-pose geometric screening |
| B5.3 | Multi-pose sensing evaluation |
| B5.4 | Refinement and Prototype V1.0 selection |
| B5.5 | Rigid-to-flexible balloon compatibility |

Future seven-/eight-cable theoretical studies may proceed in parallel.

---

## 5. Simulation Rules

- Use millimetres for geometric calculations.
- Document all coordinate frames.
- Keep anchor–attachment pairing explicit.
- Verify MATLAB array dimensions.
- Separate geometric feasibility from sensing quality.
- Distinguish ideal cable geometry from physical clearance.
- Use consistent evaluation poses and measurement-noise assumptions.
- Preserve original datasets and configuration versions.
- Do not interpret simulation uncertainty as experimentally validated accuracy.

---

## 6. Related Documents

- [Current Research State](../../../CURRENT_STATE2.md)
- [Rigid-Body Sensing Design](../../../05_My_Research/Rigid_Body_Sensing_Design.md)
- [Prototype V1.0 Design](../../../05_My_Research/Prototype_V1_Rigid_to_Flexible_Design_2026_11_04.md)
- [November Research TODO](../../../08_Project_Management/November/current_november_todo_updated_2026_11_04.md)
- [November Weekly Plan](../../../08_Project_Management/November/weekly_plan_nov_04_17_2026.md)
- [November Research Logs](../../../06_Research_Log/2026-11/)

---

**Current Milestone:** Identify a reproducible, adjustable six-cable configuration suitable for initial prototype development.
