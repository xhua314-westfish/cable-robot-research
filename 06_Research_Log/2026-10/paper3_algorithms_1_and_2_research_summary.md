# Paper 3 — Algorithm 1 & Algorithm 2: Research Summary

**Study:** Cheng, Lau & Hughes (2025), *Determining Feasible Cable Attachment Locations for Cable-Driven-Parallel Robot*, CableCon 2025. DOI: https://doi.org/10.1007/978-3-031-94608-0_21  
**Research context:** Cable-robot-based sensing of a passively moving, initially rigid balloon-like object.  
**Status (27 Oct 2026):** Core numerical methods of Algorithms 1 and 2 reproduced and tested in MATLAB; exact paper-figure rendering, continuous-space guarantees, and hardware/sensing accuracy are *not* established.  
**Companion:** `paper3_algorithm2_complete.m` (consolidated code; rerun locally before treating new exports as verified).

## 1. Questions answered

- **Algorithm 1:** For a *fixed platform pose*, where can **one chosen base anchor** be placed, while the other six anchors and all body-frame attachments remain fixed, to satisfy wrench closure?
- **Algorithm 2:** Which positions for that **same target anchor** satisfy the condition **across multiple sampled platform poses**?
- **All-cable extension:** Repeat either computation with each cable as the target; the resulting feasible regions are *conditional*, not a simultaneous seven-anchor optimization.

## 2. Model, assumptions and notation

| Symbol | Meaning | Shape |
|---|---|---|
| `A(:,i)` | Fixed base anchor in world frame, except selected candidate `u` | 3 × 1 |
| `r(:,i)` | Attachment in platform/body coordinates | 3 × 1 |
| `P`, `R` | Platform translation and body-to-world rotation | 3 × 1; 3 × 3 |
| `B(:,i) = P + R*r(:,i)` | Attachment position in world coordinates | 3 × 1 |
| `D(:,i) = B(:,i) - A(:,i)` | Cable vector **in this reproduction** | 3 × 1 |
| `Jbar(:,i) = [D(:,i); cross(R*r(:,i),D(:,i))]` | Unnormalized wrench column (moment about platform origin) | 6 × 1 |
| `u = [ux;uy;uz]` | Candidate location of one target anchor | 3 × 1 |

**Paper scope:** 6 DoF, 7 cables (`m=n+1`), rigid cables without slack, idealized outlets and known platform geometry. The platform orientation is held at `R=eye(3)` for the example's eight translational poses. This is a **wrench feasibility** study, **not** a pose-estimation accuracy or gastric-anatomy validation.

**Sign convention:** The reproduced paper matrix uses `D=B_world-A`; earlier sensing exercises sometimes used `A-B`. Do not mix the corresponding wrench sign conventions in one computation. Moment arms are `R*r` (relative to platform origin), not the absolute `B_world` position. Length-normalized wrenches produce physically scaled tension ratios; `Jbar` is used for closure because positive per-column length scaling preserves the existence of a positive null vector.

## 3. Algorithm 1 — Single-pose anchor feasible region

### Conceptual steps

1. **Wrench relationship:** For the selected cable (the paper example initially targets cable 7), fix the other six wrench columns, `J_fixed` (6×6), and represent the target wrench by `j(u)` (6×1). Check `rank(J_fixed)==6`.
2. **Compute boundary functions:** `h(u) = J_fixed \ j(u)`. Equivalently, `rref([J_fixed,j(u)]) = [I_6, h(u)]`. From `[J_fixed,j(u)]*[-h(u);1]=0`, the special `m=n+1` positive-tension test requires **all six** `h_i(u)<0`.
3. **Polynomial/affine fit:** Sample candidate `u` values, compute `h(u)` by the direct wrench model, then fit each `h_i(u)=a_i ux + b_i uy + c_i uz + d_i` using `U\H`, where `U=[ones(N,1),ux,uy,uz]` (N×4), `H` (N×6), and coefficients `C` (4×6). Because the other six columns and the platform pose are fixed and the unnormalized target wrench is affine in `u`, these functions are affine in this example.
4. **Classify a 3D candidate grid:** `H_grid=[ones(N,1),points]*C`, then `mask=all(H_grid < -tol,2)`. The intersection of the six strict half-spaces is the feasible **anchor** region at this pose. Fit is a convenient explicit representation, not a required step for direct classification.

### Key equations

\[
\bar J(u)=[\bar J_{\mathrm{fixed}}\; j(u)], \qquad
h(u)=\bar J_{\mathrm{fixed}}^{-1}j(u),
\]
\[
\bar J(u)\begin{bmatrix}-h(u)\\1\end{bmatrix}=0,
\qquad W(q)=\{u : h_i(u,q)<0,\; i=1,\ldots,6\}.
\]

The condition here presumes six independent fixed columns and an all-positive, one-dimensional wrench nullspace; it cannot be copied directly into a six-cable, six-DoF sensing design or a different redundant arrangement.

### Recorded Algorithm 1 results (user MATLAB runs)

- Section 3.1 pose `P=[0.65;0.5;0.6]`, `R=I` and Table 1 geometry.
- `size(Jbar)=6×7`; `rank(Jbar(:,1:6))=6`.
- Cable 7 at its original anchor: `h≈[-3.2857,-18.7143,-12.7143,-9.2857,-14,-13]`, all negative; `norm(Jbar*[-h;1])≈1.454e-15`.
- Direct solve vs. RREF difference `≈2.110e-14`.
- Affine fit with 125 points: `rank(U)=4`, maximum fitting residual `≈2.132e-14`.
- Unused test point `u=[0.3;0.7;0.2]`: direct vs. fitted prediction infinity-norm error `≈7.105e-15`.
- Grid `ux,uy,uz=-0.5:0.05:1.5` (68,921 candidates), target cable 7: **29,291 feasible (42.50%)** at the single pose.

**Validation distinction:** Retesting fitted feasible points with the same fitted `C` is circular. Comparing `C` predictions to independently reassembled wrench columns at held-out points is stronger. Counts/figures describe the *sampled* bounded region, not a continuous-space or anatomical workspace.

## 4. Algorithm 2 — Intersecting regions over platform poses

### Conceptual steps

1. Define one *fixed* grid of possible target anchor positions in the **world** frame.
2. Define the desired platform pose samples; in the paper example these are the eight translation-box corners: `P=(0.4 or 0.6, 0.4 or 0.6, 0.4 or 0.6)`, orientation zero.
3. At each pose, recompute `B=P+R*r`, cable vectors, the six fixed wrench columns, and the target wrench for all anchor candidates. Recompute `h(u,q_k)`; **do not reuse a boundary coefficient matrix derived at a different pose**.
4. Make `mask_pose` from all six strict WCC inequalities. Intersect it with the cumulative mask: `mask_all = mask_all & mask_pose`. Store masks/counts after each pose and plot the decreasing regions.
5. Independently cross-check cumulative versus `all(mask_each,2)` and recompute wrenches at selected retained positions/poses.

\[
W^{(k)}=\bigcap_{j=1}^{k}W(q_j),\qquad
W^{(k+1)}\subseteq W^{(k)}.
\]

**Interpretation:** The robot samples **platform poses**; the anchor *does not move during the iterations*. Each candidate anchor is tested to determine whether it can remain fixed while the platform occupies all eight poses. Equal successive counts are possible and only establish equality on the discrete sampled grid.

### Recorded Algorithm 2 results (target cable 7)

| Cumulative tested poses | Feasible anchor candidates |
|---:|---:|
| 0 (initial grid) | 68,921 |
| 1 | 3,621 |
| 2 | 3,334 |
| 3 | 1,838 |
| 4 | 1,005 |
| 5 | 1,005 |
| 6 | 1,005 |
| 7 | 1,005 |
| 8 | **1,005 (1.4582%)** |

- Count monotonically non-increasing; `Mask mismatches=0`.
- Random independent wrench recalculation for retained candidate anchors and all eight poses: largest tested `h=-0.002273`; all tested inequalities satisfied.
- Original seven-anchor configuration passes the same 7-cable WCC test at all eight sampled poses (`WCC=1` for each).
- This does **not** imply all intermediate poses, arbitrary orientations, collision-free paths, bounded tensions, or accurate sensing.

## 5. All-cable extension and discrete PRI

For each target cable `k=1..7`, use the other six anchors as fixed; run the same candidate anchor grid and, separately, eight-pose intersection. The paper's Prioritized Reconfiguration Index is a **continuous volume ratio**:

\[
\mathrm{PRI}_k=\frac{\mathrm{Volume}(W_{k,\mathrm{feasible}})}{\mathrm{Volume}(W_{k,\mathrm{sampled}})}.
\]

With a shared, uniform grid, use `ApproxPRI = feasible_count / total_count` as a **discrete approximation**. The seven sampled fractions are not simultaneous optima and are not a ranking of sensor performance.

| Cable | One pose: feasible / 68,921 | One pose % | Eight poses: feasible / 68,921 | Eight-pose ApproxPRI |
|---:|---:|---:|---:|---:|
| 1 | 20,200 | 29.31 | 1,434 | 0.020806 |
| 2 | 2,274 | 3.30 | 1,434 | 0.020806 |
| 3 | 3,951 | 5.73 | 1,475 | 0.021401 |
| 4 | 14,153 | 20.54 | 1,475 | 0.021401 |
| 5 | 8,767 | 12.72 | 830 | 0.012043 |
| 6 | 5,798 | 8.41 | 1,005 | 0.014582 |
| 7 | 29,291 | 42.50 | 1,005 | 0.014582 |

**Not a before/after shrinkage comparison:** The one-pose evaluation uses `P=[0.65,0.5,0.6]`, while the eight-pose set has coordinates only 0.4 or 0.6; it does **not include** that initial single pose. Do not claim the difference in percentages measures shrinkage caused only by adding seven poses. For such a comparison, use one of the eight poses as the single-pose baseline or include the original pose in the multi-pose set.

**Additional caution:** Any PRI interpretation depends on a consistent sampling domain that corresponds to physically mountable anchor locations. The current common box `[-0.5,1.5]^3` is a numerical choice, not an anatomically or mechanically validated mount region.

## 6. MATLAB output and verification protocol

The consolidated script `paper3_algorithm2_complete.m` contains:

1. Eight-platform-pose plot.
2. Cable 7 eight-pose intersection, final region, feasible-count convergence.
3. Figure 3-style **initial grid + eight cumulative iterations** plot.
4. **All seven cables' single-pose feasible regions** (the missing Lesson 5.4 figure).
5. All seven cables' eight-pose regions, discrete PRI and CSV output.
6. Original-anchor WCC across eight poses, consistency assertions and random retained-point independent recalculation.

Expected filenames created **upon running MATLAB**:

- `paper3_eight_platform_poses.png`
- `paper3_cable7_multipose_region.png`
- `paper3_counts_by_pose.png`
- `paper3_fig3_iterations_0to8.png`
- `paper3_all_cable_regions_single_pose.png`
- `paper3_all_cable_regions_multi_pose.png`
- `paper3_single_pose_cable_fractions.csv`
- `paper3_multi_pose_approx_pri.csv`

**Regression checkpoints:** `N=68921`, cable 7 `counts=[3621;3334;1838;1005;1005;1005;1005;1005]`, all-cable single-pose counts `[20200;2274;3951;14153;8767;5798;29291]`, all-cable eight-pose counts `[1434;1434;1475;1475;830;1005;1005]`. These are previous **user-reported** outputs, not a claim that the consolidated script has been executed in MATLAB here.

## 7. Transfer to my balloon sensing research

### Reusable method

- Use a 3D geometry model with fixed world-frame anchors `A_i` and body-frame attachments `r_i` that move in world coordinates as `B_i=P+R*r_i`.
- Sample **passive and unknown balloon poses** within a documented gastric engineering envelope; do not assume a controlled motion path.
- For each fixed candidate anchor configuration, check pointwise feasibility, store logical masks and form intersections over a set of plausible poses.
- Screen one candidate anchor/attachment region while holding others fixed; verify the whole system whenever changing several points simultaneously.
- Separate geometric feasibility, cable-sphere/cable-cable interference, positive low-tension feasibility, and actual measurement identifiability/uncertainty.

### Must change for balloon study

- **State / sensing:** Main outcome is estimation of `(x,y,z,roll,pitch,yaw)` from cable-length changes, not WCC region size. Build a length measurement Jacobian `H` (cables × 6), check rank/scaled conditioning, and use noise-aware covariance and Monte Carlo pose RMSE. Paper 4 and subsequent work are more relevant to measurement error.
- **Object:** Initially use the 550 mL rigid-sphere proxy with spherical surface attachments; deformation comes later.
- **Workspace:** Gastric anatomical envelope, balloon-center feasible region and sensing-feasible workspace are distinct. Enforce size and collision constraints, not merely a box around anchor coordinates.
- **Cable number:** Six-cable rigid pose sensing is a minimum-count baseline, but the Paper 3 `m=n+1` WCC test is built for seven cables. Evaluate 6/7/8 candidates with correctly derived feasibility rules.
- **Mechanics:** Motors maintain modest tension to track passive motion; positive wrench closure by itself does not demonstrate non-disturbance of balloon motion. Consider routing, friction, sensor precision and cable tension bounds.
- **Uncertainty:** Random or grid pose samples cannot prove full continuous workspace feasibility; add refinement, validation sets and clearly stated coverage limitations.

## 8. Next tasks and status

- [x] Reproduce 6×7 wrench matrix and positive-nullspace/RREF relationship.
- [x] Fit six affine WCC boundary functions and perform held-out point verification.
- [x] Sample a 3D feasible region for cable 7 at a fixed pose.
- [x] Intersect cable 7's WCC regions over eight translational poses.
- [x] Verify monotonic counts, mask consistency, sampled retained points, and original-anchor WCC at eight poses.
- [x] Extend single-pose and eight-pose studies to seven target cables; compute discrete PRI.
- [ ] Run and visually inspect **consolidated** `paper3_algorithm2_complete.m`; confirm regression counts, rendered figures and CSVs.
- [ ] Add screenshot/caption comparison with the published Figure 2/3/5, noting all sampling differences.
- [ ] Move on to **A5: pointwise platform workspace sampling with fixed anchors and attachments**, then Paper 4 length-based pose estimation and covariance.

**Repository suggestion:** Save this document alongside the Algorithm 1 notes in `06_Research_Log/2026-10/`. The MATLAB script and its PNG/CSV outputs may be stored in the same dated reproduction directory or the existing MATLAB folder with relative links in this note. Do not mark unexecuted exports as verified.
