# Paper 2 — Figure 3 TF reproduction (A1)

**Date:** 2026-10-22  
**Source:** Hung Hon Cheng and Darwin Lau, *Cable Attachment Optimization for Reconfigurable Cable-Driven Parallel Robots Based on Various Workspace Conditions*, IEEE Transactions on Robotics 39(5), 2023, DOI: 10.1109/TRO.2023.3288838.  
**Script:** `paper2_fig3_TF.m`

## Goal and configuration

Reproduce the force-ratio construction and tension factor (TF) for the paper's illustrative **2-DoF / 4-cable** example using its rounded Jacobian entries. This is a wrench/force-closure example, **not** a balloon position-estimation experiment.

```
J = [0.7071  -0.7809  -0.4138   0.3417;
     0.7071   0.6247  -0.9104  -0.9398];  % 2 x 4
```

## Key steps

1. Start with the force-balance equation `J*f = 0`, with `f = [f1; f2; f3; f4]`.
2. Select the special positive-tension family `f3 = f4 = k`. This is an **assumption for one cable-column combination**, not a physical necessity and not an exhaustive search over all tension distributions.
3. Combine the last two Jacobian columns: `J_cs = [J(:,1), J(:,2), J(:,3)+J(:,4)]` (2 x 3). Thus `J_cs*[f1; f2; k] = J*f` when `f3=f4=k`.
4. Apply `R = rref(J_cs)` to obtain `[I | T]`, with approximately `T=[-1.4990; -1.2650]`.
5. From `[I | T]*[f1; f2; k]=0`, get `[f1; f2]=-T*k`. Set `k=1` to normalize *relative* tensions, giving `f≈[1.4990; 1.2650; 1; 1]`. This is **not** claiming actual tensions in newtons.
6. For the paper's force ratio, `TF = max([T;-1])/min([T;-1]) = min(f)/max(f) ≈ 0.6671` with the rounded matrix.
7. Verify both `J_cs*[f1;f2;k]≈0` and `J*f≈0`. Numerical residuals may be at the floating-point round-off level.

## Verification

| Check | Expected/observed |
|---|---|
| `size(J)` | 2 x 4 |
| `size(J_cs)` | 2 x 3 |
| `R(:,end)` | approximately `[-1.4990; -1.2650]` |
| Relative tension `f` | approximately `[1.4990; 1.2650; 1; 1]` |
| `norm(J*f)` | approximately zero (reported as 0.00000000 to 8 decimals) |
| TF | **0.6671** with rounded entries |

The paper may report a slightly different last digit based on unrounded values. A near-zero force residual is evidence of equilibrium for **this geometry and this chosen ratio**; it does not demonstrate full bounded-tension feasibility over a workspace.

## Meaning for my research

- **WCC / TF:** whether cable force directions can support positive-tension balance and how balanced one feasible tension distribution is.
- **Sensing quality:** whether changes in measured cable length are sensitive to and distinguish the balloon state. This needs a **measurement Jacobian**, singular values/rank, a noise model and potentially state-estimation uncertainty.
- A favorable TF does **not** establish accurate balloon pose or deformation estimation.

## Outcome and next step

- [x] Matrix dimensions and cable-column combination understood.
- [x] RREF-derived relative tensions and `J*f≈0` verified.
- [x] TF reproduced to the reported precision of the rounded example.
- [x] TF vs sensing quality distinction documented.
- **Next:** Paper 3, Sections 2.1–2.2 and Algorithm 1: fixed anchors `A`, attachment points `B`, sampled pose `q`, variable anchor `u`, and unnormalized wrench matrix `Jbar`.
