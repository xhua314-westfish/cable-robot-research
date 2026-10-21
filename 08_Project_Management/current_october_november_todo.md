# October–November Research TODO

> **Period:** 2026-10-22 → 2026-11-18 (4 weeks)  
> **Main goal:** Reproduce the essential methods from four papers, producing reusable and verified MATLAB modules.  
> **Workload:** 4–5 hours/day; allow tasks to move forward when debugging requires more time.  
> **Detailed schedule:** [weekly_plan_02.md](weekly_plan_02.md)

## 1. Focus this month

**Phase A — Paper Reproduction (A1–A5).** Learn the mathematical principle, implement a small MATLAB example, validate against the paper, and save the evidence. **Do not start full balloon anchor/attachment optimization yet.**

| ID | Direction | Source | Main deliverable | Status |
|---|---|---|---|---|
| A1 | Consolidate Figure 3: Jacobian, RREF, positive self-stress, TF | Paper 2 (Cheng & Lau, 2023) | Verified `paper2_fig3_TF.m` and brief result note | [ ] |
| A2 | Reproduce Algorithm 1: WCC half-space boundary equations | Paper 3 (Cheng, Lau & Hughes, 2025) | `paper3_algorithm1.m` + Figure 2-style plot | [ ] |
| A3 | Reproduce Algorithm 2: intersect feasible anchor regions over poses | Paper 3 (2025) | `paper3_algorithm2.m` + Figure 3 iteration plot | [ ] |
| A4 | Reproduce cable-length-based forward kinematics, covariance, Monte Carlo | Paper 4 (Patel et al., 2023) | `paper4_forward_kinematics.m` + `paper4_monte_carlo.m` | [ ] |
| A5 | Build a pointwise workspace-sampling tool from the review | Paper 1 (Tho & Thinh, 2022) | `paper1_workspace_sampling.m` + feasible-point plot | [ ] |

**Status note:** The 2D TF calculation for A1 has already been run and produced TF ≈ 0.6671; this month A1 means **check, document, and archive**, not redo from zero. Mark it completed only after the code and verification notes are saved.

## 2. Definition of Done (DoD)

- [ ] **A1:** Explain why `J_cs*f ≈ 0`; verify RREF, positive force ratios, and TF ≈ 0.6671 against the rounded Jacobian. State clearly: **TF is not a sensing metric**.
- [ ] **A2:** From the paper's Table 1 and specified pose, obtain the six `h_i(u) < 0` inequalities, check numerical residuals and plot a feasible candidate point cloud. The paper rounds example coefficients.
- [ ] **A3:** For sampled poses, repeatedly intersect candidate regions; plot successive iterations and verify `W_(k+1) ⊆ W_k`. Optional: extend to all seven anchors/PRI.
- [ ] **A4:** Reproduce **Method 2 (cable-length loop closure)** first: pose from noisy lengths, Jacobian, local covariance, and Monte Carlo RMSE / ±3σ. NEES if time permits. Method 1 (squared lengths) and quaternion/DCM are **extensions**, not required for minimum completion.
- [ ] **A5:** Implement pose-grid sampling and a clear feasibility mask/visualization. Paper 1 is a **review**, so this is a method-inspired implementation, not reproduction of an original Figure/Algorithm.
- [ ] **Documentation:** For every task, record parameters, equations, script name, expected vs. actual results, limitations, and a saved plot.

## 3. Core scientific boundaries

1. **Paper 2/3 WCC ≠ sensing quality.** Paper 3 assumes an `m = n + 1` WCC setup (e.g., six DOF, seven cables) and varies a **base anchor** while other points are fixed. Do not apply its strict WCC inequality unchanged to the initial six-cable 6-DOF sensing system.
2. **Paper 4 estimates pose for known geometry.** It does not optimize anchor/attachment coordinates. The covariance relationship is a **local, noise-model-dependent approximation**, requiring a full-column-rank measurement Jacobian.
3. **Six cables may be sufficient for locally full-rank pose sensing**, but this does not guarantee positive-tension wrench closure or mechanically valid cable tracking.
4. Keep fixed anchors `A_i` (world frame) distinct from fixed-on-balloon attachments `r_i` (body frame): `B_i = P + R*r_i` moves in world coordinates as the balloon moves.
5. Reproduction results must be labeled **verified**, **partial**, or **not yet reproduced**; never invent paper agreement.

## 4. After Phase A — Next research phase (not this month's workload)

- **B1 — Initial balloon baseline:** 550 mL rigid sphere; simplified 140 × 150 × 160 mm bounding envelope; 6 cables; define anchor surfaces and spherical attachment locations; calculate lengths and scaled Jacobian.
- **B2 — Anchor region screening:** with balloon attachments fixed, sample physically mountable anchor positions; check geometry, interference, rank, and sensing thresholds over sampled poses.
- **B3 — Attachment region screening:** with anchors fixed, sample spherical attachment coordinates; check cable–sphere interference, spacing, and sensing feasibility.
- **B4 — Configuration optimization:** optimize attachment only → anchor only → alternate/joint refinement, using noise-aware pose-uncertainty metrics (not TF as the primary objective).
- **B5 — Final validation:** independent workspace poses; compare 6/7/8 cables, covariance, position/orientation RMSE, and physically valid low-tension tracking.

**Important:** Feasible regions found with other connection points held fixed are conditional. Changing several points together requires renewed feasibility checks. The proposed stomach box is an engineering approximation, not a measured patient-specific motion boundary.

## 5. Research output convention

For each milestone, save: `*.m` script/function, `*.png` figure, and a short `*_notes.md` (objective → setup → math → result → discrepancy → next action). Reuse the repository's existing folder structure when filing work; avoid creating duplicate current-state files.

### Paper references

- **Paper 1:** Tho & Thinh (2022), *An Overview of Cable-Driven Parallel Robots: Workspace, Tension Distribution, and Cable Sagging*.
- **Paper 2:** Cheng & Lau (2023), *Cable Attachment Optimization for Reconfigurable Cable-Driven Parallel Robots Based on Various Workspace Conditions*. [DOI](https://doi.org/10.1109/TRO.2023.3288838)
- **Paper 3:** Cheng, Lau & Hughes (2025), *Determining Feasible Cable Attachment Locations for Cable-Driven Parallel Robot*. [DOI](https://doi.org/10.1007/978-3-031-94608-0_21)
- **Paper 4:** Patel, Nguyen & Caverly (2023), *Forward kinematics of a cable-driven parallel robot with pose estimation error covariance bounds*. [DOI](https://doi.org/10.1016/j.mechmachtheory.2023.105231)
