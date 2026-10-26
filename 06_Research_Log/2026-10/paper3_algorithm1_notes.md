# Paper 3 — Algorithm 1: WCC Boundary Equations and Feasible Anchor Region

**Research phase:** A2 — Paper reproduction  
**Study date:** 2026-10-26  
**Status:** Core MATLAB reproduction verified; final paper-figure comparison and broader validation pending  
**Reference:** Cheng, H. H., Lau, D., & Hughes, J. (2025), *Determining Feasible Cable Attachment Locations for Cable-Driven-Parallel Robot*, CableCon 2025, pp. 261–273. DOI: [10.1007/978-3-031-94608-0_21](https://doi.org/10.1007/978-3-031-94608-0_21).

## 1. Research question and scope

**Question:** For a fixed robot pose, where can one base anchor be placed while maintaining the paper's wrench-closure condition (WCC), with the other six cables fixed?

- Example: 6-DoF platform, 7 cables, with the seventh base anchor varied: `u = [ux; uy; uz]`.
- This is **force/wrench feasibility**, not sensing accuracy, pose reconstruction, or balloon attachment optimization.
- For this paper's 7-cable formulation, assume the six fixed wrench columns form a nonsingular `6 x 6` matrix and each cable can exert strictly positive *tensile* force.

## 2. Geometry and conventions

Use the paper's Table 1 geometry and Section 3.1 pose:

```matlab
A = [0 1 1 0 0.5 1 0;
     0 0 1 1 0   1 1;
     1 1 1 1 0   0 0];

r = [-0.15  0.15  0.15 -0.15  0     0.15 -0.15;
     -0.10 -0.10  0.10  0.10 -0.10  0.10  0.10;
      0.05  0.05  0.05  0.05 -0.05 -0.05 -0.05];

P = [0.65; 0.5; 0.6];
R = eye(3);
```

- `A(:,i)`: base anchor in world frame.
- `r(:,i)`: platform attachment in body frame.
- `B_world(:,i) = P + R*r(:,i)`: attachment in world frame.
- **Paper 3 sign convention:** `D = B_world - A` (opposite to some earlier personal scripts that used `A - B`; do not mix conventions).
- Moment arm: `r_world = R*r`; column `M_i = cross(r_world(:,i), D(:,i))`.
- Unnormalized wrench matrix: `Jbar = [D; M]`, size `6 x 7`. This uses unnormalized cable vectors to preserve affine dependence on a free 3D anchor.
- The numbers in Table 1 are the paper's example geometry, **not** the gastric-balloon workspace dimensions.

## 3. Algorithm 1 in three steps

### Step 1 — Derive the relationship between six fixed cables and the seventh cable

Partition the wrench matrix:

\[
\bar J(u) = [\,J_{\mathrm{fixed}}\mid j_7(u)\,],\qquad
J_{\mathrm{fixed}}\in\mathbb{R}^{6\times6}.
\]

Provided `rank(J_fixed) == 6`, compute

\[
h(u)=J_{\mathrm{fixed}}^{-1}j_7(u),
\qquad \operatorname{rref}(\bar J)=[I_6\mid h(u)].
\]

In MATLAB **use a linear solve, not an explicit inverse**: `h = J_fixed \ j7`.

The wrench balance vector satisfies

\[
\bar J(u)\begin{bmatrix}-h(u)\\1\end{bmatrix}=0.
\]

The vector `[-h; 1]` describes **relative coefficients for the unnormalized wrench columns**, not physical cable tensions in newtons. Because physical cables pull rather than push, strict positivity of these coefficients requires

\[
\boxed{h_i(u)<0\quad\text{for all }i=1,\ldots,6.}
\]

Positive rescaling by cable lengths connects these coefficients to positive tensions of the normalized wrench matrix. This criterion relies on the 7-cable/6-DoF, full-rank-six-column setup; it must not be transplanted unchanged to a six-cable measurement system or a general `m>n+1` configuration.

### Step 2 — Fit explicit boundary functions

Sample candidate base-anchor coordinates `u^(k) = [ux,uy,uz]'`, evaluate `h(u^(k))` directly, and build

\[
U=\begin{bmatrix}1&u_x^{(1)}&u_y^{(1)}&u_z^{(1)}\\\vdots&\vdots&\vdots&\vdots\\1&u_x^{(N)}&u_y^{(N)}&u_z^{(N)}\end{bmatrix},
\quad H=\begin{bmatrix}h(u^{(1)})^T\\\vdots\\h(u^{(N)})^T\end{bmatrix}.
\]

Solve `C = U \ H` (`C` is `4 x 6`). The six inequalities are

\[
h_i(u)=C_{1i}+C_{2i}u_x+C_{3i}u_y+C_{4i}u_z<0.
\]

For one freely varying world-frame anchor, fixed pose and fixed platform attachment, `j7(u)` and thus `h(u)` are **affine** in `u`. Polynomial fitting recovers explicit coefficients; fitting is a convenient implementation, not mathematically necessary for pointwise WCC testing. Other reconfiguration paths can produce higher-degree functions.

### Step 3 — Apply all six inequalities to candidate points

For a candidate matrix `points` (`N x 3`):

```matlab
H_grid = [ones(size(points,1),1), points] * C;
feasible_mask = all(H_grid < -1e-9, 2);
feasible_points = points(feasible_mask,:);
```

The feasible region is the intersection of six *strict open half-spaces* with the user-defined search box. Its sampled fraction depends on the box and resolution; it is not the balloon sensing workspace.

## 4. Compact MATLAB reference implementation

```matlab
% Inputs A (3x7), r (3x7), P (3x1), R (3x3) from Section 2
B_world = P + R*r;
r_world = R*r;
D = B_world - A;
Jbar = [D; cross(r_world,D,1)];
J_fixed = Jbar(:,1:6);
assert(rank(J_fixed)==6, 'Fixed columns must be independent');

% Test initial seventh anchor
h0 = J_fixed \ Jbar(:,7);
assert(norm(Jbar*[-h0;1]) < 1e-10);
is_wcc_initial = all(h0 < -1e-9);

% Sample for affine boundary fit
[UX,UY,UZ] = ndgrid(-0.2:0.1:0.2, 0.8:0.1:1.2, -0.2:0.1:0.2);
samples = [UX(:),UY(:),UZ(:)];
N = size(samples,1);
H = zeros(N,6);
for k = 1:N
    u = samples(k,:)';
    d7 = B_world(:,7)-u;
    j7 = [d7;cross(r_world(:,7),d7)];
    H(k,:) = (J_fixed\j7)';
end
U = [ones(N,1),samples];
assert(rank(U)==4);
C = U\H; % first coefficient row is constant
fit_error = max(abs(U*C-H),[],'all');

% Wider grid for Figure 2-style point cloud
[UX,UY,UZ] = ndgrid(-0.5:0.05:1.5,-0.5:0.05:1.5,-0.5:0.05:1.5);
points = [UX(:),UY(:),UZ(:)];
H_grid = [ones(size(points,1),1),points]*C;
feasible_mask = all(H_grid < -1e-9,2);
feasible_points = points(feasible_mask,:);
figure;
scatter3(feasible_points(:,1),feasible_points(:,2),feasible_points(:,3),5,'filled');
xlabel('u_x'); ylabel('u_y'); zlabel('u_z');
title('Paper 3: WCC-feasible seventh-anchor point cloud');
axis equal; grid on; view(3);
```

## 5. Observed results (user's MATLAB run)

| Check | Recorded result |
|---|---:|
| `size(Jbar)` | `6 x 7` |
| `rank(J_fixed)` | `6` |
| `h0 = J_fixed \ j7` | `[-3.2857; -18.7143; -12.7143; -9.2857; -14.0000; -13.0000]` |
| `norm(h0 - rref(Jbar)(:,7))` (conceptual comparison) | `2.110e-14` |
| `norm(Jbar*[-h0;1])` | `1.454e-15` |
| Initial strict WCC | `true` |
| 1D seventh-anchor scan (`ux=-0.5:0.05:0.5`, `uy=1, uz=0`) | `21 / 21` feasible |
| Affine fit samples | `125` |
| `rank(U)` | `4` |
| Maximum in-sample fit error | `2.132e-14` |
| 3D grid points | `68,921` |
| 3D feasible grid points | `29,291` |
| Feasible fraction *within selected grid box* | `42.50%` |
| Largest inequality value among *already selected* points | `-0.001786` |
| Independent test anchor | `[0.3; 0.7; 0.2]` |
| Independent test infinity-norm prediction error | `7.105e-15` |

Fitted boundary functions (full displayed precision from the run):

```text
h1 = -0.892857 ux -2.357143 uy + 5.071429 uz - 0.928571
h2 =  6.392857 ux +2.357143 uy +29.928571 uz -21.071429
h3 =  2.642857 ux -0.392857 uy +20.428571 uz -12.321429
h4 =  2.857143 ux +3.142857 uy +16.571429 uz -12.428571
h5 =  3.500000 ux +1.000000 uy +23.000000 uz -15.000000
h6 =  3.500000 ux +0.750000 uy +21.000000 uz -13.750000
```

**Paper comparison note:** The rounded Section 3.1 printed equations are proportional approximately to the computed equations (rather than identical coefficient-by-coefficient), and give the same inequality orientation when the proportionality factor is positive. For example, the paper's `h1 ≈ -0.026*(25ux+66uy-142uz+26)` is approximately 0.728 times the direct `h1` above. Check plane location and signs rather than insisting that rounded/scaled coefficient values match literally. Do not claim exact equality to the paper's displayed numbers without a consistent normalization check.

## 6. Important verification distinction

**Weak/redundant check:** `max(H_grid(feasible_mask,:)) < 0` recomputes the same inequality already used to define `feasible_mask`. It confirms bookkeeping but **cannot independently validate** the fitted formula.

**More meaningful independent test:** At an anchor location not included in the fit, compute `h_direct = J_fixed \ j7(u_test)` and `h_fit = [1,u_test']*C`, then compare `norm(h_direct-h_fit',inf)` and both WCC classifications. The observed error at `[0.3;0.7;0.2]` was `7.105e-15`.

**Further recommended checks:** multiple held-out anchor points, particularly near `h_i=0`; numerical conditioning of `J_fixed`; strict/near-zero boundary tolerance; comparing all six half-space orientations; and checking cases classified as infeasible.

## 7. Scientific limitations and transfer to balloon research

1. **Single pose:** Algorithm 1 constrains one platform pose only; **Algorithm 2** intersects the regions across many poses.
2. **Not a sensing metric:** WCC, positive-force feasibility and force-ratio balance do not measure 6-DoF pose identifiability, noise amplification or reconstruction RMSE.
3. **Configuration dependence:** Region is conditional on the fixed six anchor/attachment pairs; changing other locations requires recalculation.
4. **Physical constraints omitted:** no balloon/cable interference, stomach collision, cable sag, actuator/tension bounds, or motion disturbance checks.
5. **Normalized vs unnormalized:** `[-h;1]` is a kernel vector for `Jbar`; it should not be reported as physical cable tensions in N.
6. **Search region vs anatomy:** sample box is an engineering visualization choice and does not define a gastric or sensing workspace.

## 8. Next task — A3, Algorithm 2

- Select eight translational poses at corners of the paper's stated range: `q_center=[0.5;0.5;0.5]`, offsets `±[0.1;0.1;0.1]`; orientation remains zero.
- For each pose, recompute `J_fixed`, the sixth-dimensional boundary functions, and a feasibility mask for the **same candidate anchor grid**.
- Accumulate `mask_all = mask_all & mask_pose`.
- Verify feasible counts never increase as poses are added. Plot iteration 0 to 7 point clouds.
- Anchor points do **not** physically move during pose intersection: it is a search for one fixed anchor position feasible at all sampled robot poses.

**Completion note:** This file documents an independently checked core implementation and observed output; it is not proof of exact paper figure reproduction or a validated hardware design.
