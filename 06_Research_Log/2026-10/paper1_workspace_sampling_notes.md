# A5 — Pointwise Platform Workspace Sampling

**Status:** Core numerical exercise verified from prior MATLAB command-window outputs and figures; consolidated script awaits a clean MATLAB run.  
**Study period:** October 2026  
**Source/method:** Paper 1, Tho & Thinh (2022), review of CDPR workspace concepts; **method-inspired implementation**, not a reproduction of an original figure from the review.  
**Geometry:** Seven-cable example from Paper 3, Cheng, Lau & Hughes (2025), Table 1; **not** a gastric-balloon design.

## 1. Research question

For fixed base anchors and fixed body-frame attachment points, which sampled platform positions satisfy (i) a specific seven-cable WCC test and (ii) illustrative cable-length limits? How does requiring multiple discrete roll orientations reduce the shared position workspace?

## 2. Geometry, frames and assumptions

- Fixed anchors: `A` is 3×7 in the world frame.
- Local attachment points: `r` is 3×7 in the moving-platform frame.
- Platform translation: `P = [x;y;z]` is world-frame.
- Platform rotation: `R = eye(3)` at baseline; `R_x(roll)` for roll samples.
- World attachment points: `B_world = P + R*r`.
- Cable vectors follow Paper 3's sign convention: `D = B_world - A`.
- Unnormalized wrench matrix: `Jbar = [D; cross(R*r,D,1)]` (6×7).
- Cable lengths: `L = vecnorm(D,2,1)`.
- Model treats cables as straight, taut segments, without pulley offsets, cable sag, tension limits, cable–cable or cable–platform interference.
- Baseline orientation is zero; roll samples are `[-10,0,10]` degrees. Pitch/yaw are not sampled.
- Translation grid: each of x/y/z spans 0.2 to 0.8 inclusive, step 0.05 (13³ = 2,197 points).
- Illustrative cable-length bounds: `0.3 <= L_i <= 1.0`, all seven cables. These are **not motor or anatomical specifications**.

## 3. Methods

### 3.1 Wrench-closure screening

At each pose, form `J_fixed = Jbar(:,1:6)` and `j7 = Jbar(:,7)`. If `rank(J_fixed) == 6`, solve `h = J_fixed \ j7`. The chosen **seven-cable, six-independent-column** positive-null-vector WCC test accepts the pose if `h_i < -1e-9` for all six coefficients. It does not by itself ensure finite allowable tensions, no collisions, or accurate sensing. The entries of `[-h;1]` are relative coefficients for the **unnormalized** wrench matrix, not physical tensions in newtons.

### 3.2 Cable-length screening

All seven cable lengths must satisfy the illustrative lower and upper bounds. Independent masks are retained:

```matlab
mask_combined = mask_wcc & mask_length;
```

### 3.3 Orientation robustness

Recalculate both WCC and length feasibility for each sampled roll angle, keeping the same 2,197 platform translations and fixed geometry. The common position mask is:

```matlab
mask_all_roll = all(roll_masks,2);
```

This is a **three-angle discrete intersection**, not proof of feasibility at all intermediate angles or over all six degrees of freedom.

## 4. Verified MATLAB results (prior lesson runs)

| Metric | Observed |
|---|---:|
| Candidate platform positions | 2,197 |
| WCC feasible at 0° | 861 (39.19%) |
| WCC infeasible at 0° | 1,336 |
| First-six-column rank-deficient samples at 0° | 0 |
| Length feasible at 0° | 1,381 |
| WCC ∩ Length at 0° | 765 (34.82%) |
| Common combined feasibility across −10°, 0°, +10° | 95 (4.32%) |

| Roll angle | WCC feasible | Length feasible | Combined feasible |
|---:|---:|---:|---:|
| −10° | 827 | 1,387 | 623 |
| 0° | 861 | 1,381 | 765 |
| +10° | 189 | 1,343 | 175 |

At +10°, the WCC-feasible count falls much more than the length-feasible count relative to 0°: this **supports WCC as the main contributor to the count reduction** under these assumptions. The 0° combined mask is independently reproduced by the roll loop.

The intersection removes 670 of the 765 positions accepted at 0° alone; only 95 positions are shared by all three sampled rolls. These numbers are **discrete grid counts** and change with sampling density, geometry, chosen roll angles, and thresholds. They are not a clinical stomach-motion coverage estimate.

## 5. Artifacts

- `paper1_workspace_sampling.m` — consolidated, commented MATLAB script with regression assertions.
- `a5_01_sampled_positions.png` — candidate grid.
- `a5_02_wcc_workspace.png` — WCC-only partition.
- `a5_03_combined_workspace.png` — WCC and cable-length intersection.
- `a5_04_roll_intersection.png` — zero roll versus three-roll common positions.
- `a5_roll_constraint_counts.csv` — per-angle counts.

**Reproduction check:** Execute the consolidated script in a clean MATLAB session. Confirm all assertions pass and all expected outputs are exported. Those consolidated-script outputs have not yet been verified in this chat.

## 6. Limitations and transfer to balloon sensing

1. This is a **platform translation workspace**, conditioned on sampled orientations. It is not a full continuous 6-DOF workspace.
2. WCC is a **wrench-force feasibility** criterion, not a cable-length sensing accuracy criterion. A passive balloon might need low-tension cable tracking rather than full wrench-closure actuation.
3. Real balloon implementation needs anatomy-constrained position/orientation sampling, realistic anchor installation regions, attachments on a deformable surface, cable–balloon interference, tension/slack feasibility and finite sensor ranges.
4. For sensing performance, add a properly unit-scaled cable-length measurement Jacobian, rank/conditioning, assumed noise covariance, pose-estimation errors and Monte Carlo validation (planned A4).
5. A mechanically feasible pose can still be poorly observable; never equate WCC coverage with sensing coverage.

## 7. Completion and next task

**A5 technical Definition of Done:** achieved in the documented lesson runs: sampled pose grid, explicit constraints, feasibility masks, counts and plots; roll extension exceeds minimum scope. **Archival closure pending:** run cleaned script and push `.m`, `.md`, and exported plots to GitHub.

**Next research milestone:** A4, Paper 4 — forward kinematics from cable lengths, measurement Jacobian, covariance, pose estimation and uncertainty.
