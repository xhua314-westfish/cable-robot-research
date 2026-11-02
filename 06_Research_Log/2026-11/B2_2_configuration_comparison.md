# B2.2 — Anchor–Attachment Configuration Comparison

**Date:** 2026-11-02  
**Phase:** B — Balloon-Specific Cable Sensing Design  
**Status:** Completed — Initial single-pose configuration comparison

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

1. **Baseline:** fixed face-centre anchors and initially selected attachments.
2. **Experiment A:** fixed face-centre anchors with variable attachments.
3. **Experiment B:** variable anchors and variable attachments.

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

## 7. Next Research Task

**B2.3 — Adapt Paper 3 Algorithms 1 and 2.**

Investigate whether a seventh cable can be added to the existing six-cable reference geometry to satisfy the specified positive-tension wrench-closure condition, initially at one pose and subsequently across multiple poses.

Keep wrench feasibility separate from sensing accuracy.

Future work will evaluate multi-pose sensing performance, physical feasibility, pose uncertainty, and six-/seven-/eight-cable comparisons.
