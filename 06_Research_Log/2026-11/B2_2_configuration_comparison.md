# B2.2 — Anchor–Attachment Configuration Comparison

**Date:** 2026-11-02  
**Phase:** B — Balloon-Specific Cable Sensing Design  
**Status:** Completed — Initial single-pose configuration comparison

---

## 1. Research Question

How do anchor and attachment placements influence the local 6-DOF sensing performance of a passive rigid spherical balloon?

## 2. Model and Method

- Engineering boundary: 280 × 300 × 320 mm
- Balloon: rigid sphere, 550 mL
- Number of cables: 6
- Initial pose: P = [0, 0, 0] mm, R = I
- Anchor candidates: 26 discrete boundary points
- Attachment candidates: 40 discrete spherical-surface points
- Search: 20,000 random trials per experiment, seed 42
- Objective: minimise the condition number of the characteristic-length-scaled measurement Jacobian
- Constraints: unique anchor/attachment coordinates, full Jacobian rank, positive cable length, and initial straight-cable outward routing

Three configurations were investigated:

1. **Baseline:** Fixed face-centre anchors and initially selected attachments.
2. **Experiment A:** Fixed face-centre anchors with variable attachments.
3. **Experiment B:** Variable anchors and variable attachments.

## 3. Numerical Results

| Metric | Baseline | Experiment A | Experiment B |
|---|---:|---:|---:|
| Jacobian rank | 6 | 6 | 6 |
| Scaled minimum singular value | 0.004393 | 0.535345 | 0.533600 |
| Scaled condition number | 490.956 | 3.5759 | 3.2365 |
| Valid random samples | Not evaluated consistently | 46 | 75 |

Experiment A achieved a substantial improvement compared with the original baseline.

Experiment B further reduced the condition number by approximately 9.49% relative to Experiment A, while the minimum singular value decreased slightly.

## 4. Key Findings

1. Attachment placement and cable pairing strongly influence local sensing performance.
2. Joint anchor–attachment selection provided a modest further improvement in the best observed condition number.
3. The selected Experiment B anchors were spatially asymmetric, with five of six anchors on the positive-Z boundary.
4. A better condition number does not necessarily imply a higher minimum singular value or lower pose-estimation RMSE.
5. Random search identified improved candidates, not globally optimal configurations.

## 5. Limitations

- Results were evaluated at only one pose.
- Random search did not exhaust the candidate design space.
- The original baseline was not screened under exactly the same interference constraints.
- Initial outward routing does not establish collision-free operation over the workspace.
- Cable tension feasibility was not evaluated.
- Hardware mounting, cable friction, compliance, and motor tracking were not evaluated.
- Pose-estimation accuracy under sensor noise remains unverified.
- The 280 × 300 × 320 mm boundary is an engineering assumption, not a clinically validated gastric lumen.

## 6. Conclusion

The experiments demonstrate that anchor–attachment configuration substantially affects the local conditioning of a six-cable balloon pose-sensing system.

Experiment B produced the lowest observed scaled condition number (3.2365) at the reference pose. However, this is not sufficient to establish workspace-wide sensing quality or global optimality.

**Research Decision:**

The initial six-cable configuration comparison is complete, but the final anchor and attachment coordinates have not been selected.

Experiment A and Experiment B will be retained as candidate configurations for further workspace-level validation.

---

## 7. Next Research Task — B3.1

**B3.1 — Six-Cable Multi-Position Geometric Feasibility**

### Research Question

Can the existing Experiment A and Experiment B six-cable configurations remain geometrically feasible when the balloon moves to different positions?

### Initial Evaluation Setup

Use the same 27 balloon-centre positions for both configurations:

\[
P_x,P_y,P_z\in\{-50,0,50\}\ \mathrm{mm}
\]

Initial orientation:

\[
R=I
\]

### Planned Evaluation

1. Verify balloon containment.
2. Calculate cable lengths at all 27 positions.
3. Check cable–sphere interference.
4. Calculate minimum cable–cable distances.
5. Identify failed poses and failure mechanisms.
6. Calculate geometric feasibility coverage.
7. Compare Experiment A and Experiment B.

### Important Constraint

Do not modify the selected anchor or attachment coordinates during this initial validation.

The purpose is to identify the limitations of the existing configurations before further optimisation.

### Expected Outputs

- `B3_1_multi_position_feasibility.m`
- `B3_1_segment_distance_3d.m`
- `B3_1_results.mat`
- `B3_1_feasibility_notes.md`

## 8. Subsequent Research Direction

After B3.1:

**B3.2 — Multi-Pose Feasibility**

Extend geometric evaluation to multiple orientations.

**B4 — Sensing Quality and Pose Accuracy**

Evaluate Jacobian rank, scaled singular values, condition number, pose covariance, forward kinematics, and Monte Carlo RMSE.

**B5 — Six-Cable Configuration Optimisation**

Improve anchor–attachment placement using workspace-level objectives and select a numerically justified six-cable reference configuration.

**Future — Seven- and Eight-Cable Extension**

Investigate additional cables only after the six-cable reference configuration has undergone sufficient validation.

Paper 3 Algorithms 1 and 2 may be reused when mechanically appropriate, but they are not the immediate next research task.

---

**Current Research Priority:** Validate the existing six-cable configurations across multiple balloon poses before changing the cable count.
