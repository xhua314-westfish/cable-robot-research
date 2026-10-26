# Paper 3 — Algorithm 2: Multi-Pose WCC Feasible Anchor Region

**Research milestone:** A3 (core reproduction)  
**Recorded:** 2026-10-26  
**Source:** Cheng, Lau & Hughes (2025), *Determining Feasible Cable Attachment Locations for Cable-Driven-Parallel Robot*, DOI: [10.1007/978-3-031-94608-0_21](https://doi.org/10.1007/978-3-031-94608-0_21).  
**Companion MATLAB file:** `paper3_algorithm2.m`  
**Figure:** `paper3_fig3_iterations.png` (generated in the user's MATLAB session; store that original figure separately)

## 1. Objective

Find candidate **world-frame base anchor coordinates** for a chosen cable that satisfy the wrench-closure condition (WCC) **at all sampled platform poses**. The other six base anchors and all body-frame attachments remain fixed. The algorithm does **not** move an anchor successively through eight positions: it intersects eight feasible-anchor sets evaluated for eight different platform poses.

## 2. Three-step algorithm

1. **Specify poses** `q_1, ..., q_K`, a fixed robot configuration, and a shared 3D candidate-anchor grid `U`.
2. **At each pose**, update world-frame platform attachment points, construct the unnormalized wrench matrix, solve `h(u,q_k) = J_fixed(q_k) \ j(u,q_k)`, and keep a candidate point only if all six entries are strictly negative.
3. **Intersect masks**: `mask_all = mask_all & mask_pose`. The result is `W_all = ⋂_{k=1}^K W(q_k)` restricted to the tested grid.

### Mathematical foundation

For each cable `i`, with global anchor `A_i`, body attachment `r_i`, platform center `P`, and rotation `R`:

```text
B_i = P + R*r_i
D_i = B_i - A_i                % Paper 3 direction convention
j_i = [D_i; cross(R*r_i,D_i)]  % unnormalized 6×1 wrench column
```

The first six columns form `J_fixed ∈ R^(6×6)`; the variable seventh column is `j(u)`. Provided `rank(J_fixed)=6`, the unique relative self-stress vector normalized at coefficient 7 is

```text
h(u,q) = J_fixed(q) \ j(u,q)
f = [-h;1],   Jbar*f = 0.
```

All seven **unnormalized force coefficients** are strictly positive iff `h_i(u,q)<0` for all six components. This is the paper's `m=n+1` WCC test for this selected six-column basis. The coefficients are not physical tension values in N; normalized wrench columns use cable lengths, so physical tension ratios differ.

For sampled poses:

```text
W^(0) = candidate grid U
W^(k) = W^(k-1) ∩ W(q_k)
W^(k+1) ⊆ W^(k)
```

## 3. Reproduced configuration and parameters

Use the exact Table 1 coordinates in the companion MATLAB file. The eight translation-only poses are the corners of

```text
P_center = [0.5;0.5;0.5]
P_xyz ∈ {0.4,0.6} × {0.4,0.6} × {0.4,0.6}
R = eye(3)
```

Sampled world-frame target-anchor grid:

```text
ux, uy, uz = -0.5:0.05:1.5
41³ = 68,921 candidate points
Target: seventh base anchor (A7); A1–A6 remain fixed.
```

**Caution:** This candidate grid is a numerical experiment region, not a gastric anatomical boundary or an exact match to all plotting parameters of the paper.

## 4. Actual MATLAB observations (2026-10-26)

| Evaluated pose count | Remaining feasible grid points | Newly removed |
|---:|---:|---:|
| 0 | 68,921 | — |
| 1 | 3,621 | 65,300 |
| 2 | 3,334 | 287 |
| 3 | 1,838 | 1,496 |
| 4 | 1,005 | 833 |
| 5 | 1,005 | 0 |
| 6 | 1,005 | 0 |
| 7 | 1,005 | 0 |
| 8 | 1,005 | 0 |

Final grid retention: `1005/68921 ≈ 1.46%` (fraction of candidate **grid points**, not full physical workspace coverage or an exact continuous volume ratio).

### Checks run

- Eight platform poses generated and evaluated.
- Counts are non-increasing (`all(diff(counts)<=0)`).
- Sequential mask intersection equals the all-at-once logical intersection: `Mask mismatches = 0`.
- Fresh wrench calculations for 20 randomly sampled final grid points over all eight poses: `Maximum tested h = -0.002273`, `Independent WCC checks passed.`
- Iteration point clouds were plotted; shapes shrink from pose 1 through pose 4 and appear unchanged at the sampled resolution from pose 5 through pose 8.

**Interpretation:** The last four poses remove no *additional sampled grid points* under the chosen test. Do not infer that their continuous inequalities are redundant or that a denser sampling cannot differ.

## 5. Reproduction status and limitations

**VERIFIED for core Algorithm 2:** eight-pose sampling, 6×7 wrench construction, WCC feasibility masks, repeated intersection, monotonic count check, and sampled-point re-evaluation.

**Not claimed:** exact numerical replication of every paper figure, full continuous-region proof, collision-free routing, bounded positive tensions, sensor observability, balloon-specific mechanical feasibility, or workspace-wide sensing accuracy.

Potential improvements:

1. Save an **Iteration 0** view of the original grid, then pose 1 through pose 8 with identical axis scales and view angles.
2. For each pose, independently test representative candidates near `max(h)=0`, where threshold/rounding sensitivity is highest.
3. Repeat at a finer grid resolution to assess convergence of the sampled feasible fraction.
4. For each additional target anchor, **reorder columns so that the other six are the fixed basis**; verify rank 6 at every pose. Do not merely replace column `k` while assuming columns 1–6 remain unchanged.
5. Compare against the paper's stated sample region, pose ordering and plotted figure configuration before claiming exact visual reproduction.

## 6. Meaning for passive balloon sensing

The transferable idea is to enforce a **shared fixed anchor arrangement over many possible passive-balloon poses**. The constraints must be adapted: paper WCC tests **force feasibility**, not cable-length **sensing identifiability or accuracy**. The balloon study also needs collision/interference checks, cable routing, low-tension tracking considerations, measurement Jacobian rank/conditioning (with appropriately scaled rotations), and noise-aware pose-estimation uncertainty.

## 7. Reusable concise explanation

> Algorithm 2 evaluates the WCC-feasible base-anchor region at multiple platform poses and intersects those regions to identify anchor locations that remain feasible across all sampled poses. The retained region cannot expand as additional pose constraints are added.

## 8. Next actions

- Commit this note and the verified MATLAB script to the existing GitHub repository.
- Save `paper3_fig3_iterations.png` exported from MATLAB and show Iteration 0 if matching the paper.
- Extend the procedure to another target base anchor, checking the choice and rank of the six-column fixed basis.
- After Phase A, transfer the multi-pose mask concept to a sensing-feasibility screen for a simplified rigid balloon.
