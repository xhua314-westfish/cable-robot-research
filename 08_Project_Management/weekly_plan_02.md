# Weekly Plan 02 — Four-Week Paper Reproduction Sprint

> **Dates:** 2026-10-22 (Thu) → 2026-11-18 (Wed)  
> **Daily time:** 4–5 hours; 28 days, approximately 112–140 planned hours.  
> **Scope:** A1–A5 only. The balloon-design phase (B1–B5) starts afterward.  
> **Milestone overview:** [current_october_november_todo.md](current_october_november_todo.md)

## Working routine

Each day follows the same **4–5 h** structure: **1 h** read paper/equations → **2–2.5 h** MATLAB implementation → **1–1.5 h** testing, plotting, and concise notes. If debugging exceeds the day, write the blocker and move the unfinished item into the nearest buffer/review day. Avoid starting a new algorithm before the current basic version runs.

**Daily record (copy when needed):** `Date | Goal | Code/figure | Verified result | Blocker | Tomorrow`.

---

## Week 1 — Paper 2 wrap-up + Paper 3 fundamentals (Oct 22–28)

**Weekly result:** A1 archived; A2 boundary equations/figure working; A3 first multi-pose prototype.

### Day 01 · Thu, Oct 22 — A1: Finish TF reproduction
- [ ] Re-open Paper 2 Figure 3 and the existing 2×4 Jacobian/RREF script; annotate matrix dimensions, `J_cs`, force ratios and TF.
- [ ] Verify `norm(J*f)` near zero and TF ≈ **0.6671** (rounded source data); save the command-window result.
- [ ] Save `paper2_fig3_TF.m` and `paper2_TF_notes.md`; explicitly distinguish TF/WCC from sensing quality.

### Day 02 · Fri, Oct 23 — A2: Read and set up Paper 3
- [ ] Re-read Paper 3 Sections 2.1–2.2 and Algorithm 1; identify known `A`, `B`, pose `q`, and variable anchor `u`.
- [ ] Enter Table 1's seven `A_i/B_i` coordinates and the example pose into MATLAB; verify units/frames.
- [ ] Create `paper3_algorithm1.m`: calculate `B_world`, cable vectors and unnormalized wrench matrix `Jbar`.

### Day 03 · Sat, Oct 24 — A2: Reproduce RREF boundary functions
- [ ] Separate the six fixed columns `Jbar_fixed` from the variable seventh column `j(u)`; check `rank(Jbar_fixed)==6`.
- [ ] Compute `h(u)=Jbar_fixed\j(u)` and cross-check with `rref([Jbar_fixed,j(u)])` at test points.
- [ ] Record why six negative `h_i` coefficients implement this paper's seven-cable WCC test.

### Day 04 · Sun, Oct 25 — A2: Fit inequalities
- [ ] Sample a small 3D set of candidate anchor coordinates `u` around the initial point.
- [ ] Fit each boundary `h_i(u)=c_ix*u_x+c_iy*u_y+c_iz*u_z+c_i0` with `U\D`.
- [ ] Compare fit predictions against direct Jacobian/RREF results and the rounded Section 3.1 equations; record discrepancies.

### Day 05 · Mon, Oct 26 — A2: Figure 2-style visualization
- [ ] Build a candidate 3D point cloud in the same selected coordinate range.
- [ ] Apply all six inequalities to generate feasible/infeasible masks and plot the feasible region.
- [ ] Save `paper3_fig2_boundary.png` and short A2 notes; mark A2 complete only if residual checks pass.

### Day 06 · Tue, Oct 27 — A3: Implement multi-pose intersection
- [ ] Read Algorithm 2 line by line; distinguish **pose sampling** from **anchor candidate sampling**.
- [ ] Generate the eight translational poses described for Figure 3 (using the paper's stated range/corners).
- [ ] Compute the feasible anchor mask for each pose and implement `mask_all = mask_all & mask_pose`.

### Day 07 · Wed, Oct 28 — A3: Plot successive iterations
- [ ] Plot Iteration 0 to Iteration 7 feasible point clouds and save `paper3_fig3_iterations.png`.
- [ ] Check feasible point counts are non-increasing; debug any unexpected increase.
- [ ] Write one-paragraph explanation: these iterations **do not mean anchors move over time**.

---

## Week 2 — Paper 3 finish + workspace sampling + Paper 4 setup (Oct 29–Nov 4)

**Weekly result:** A3 and A5 working; Paper 4 cable-length and analytic measurement Jacobian implemented.

### Day 08 · Thu, Oct 29 — A3: All-cable extension
- [ ] Adapt Algorithm 2 to analyze a different target anchor with all other coordinates held fixed.
- [ ] If stable, loop over all seven target anchors and visualize distinct feasible regions.
- [ ] Calculate simple candidate-point fractions; label them as **discrete approximations** to region-volume ratios (PRI).

### Day 09 · Fri, Oct 30 — A3: Verification and buffer
- [ ] Compare Figure 3 region shapes/trends with the original paper; explain differences from sampling density or plotting.
- [ ] Verify each kept point satisfies the corresponding inequalities for all sampled poses.
- [ ] Refactor common geometry/function code and write `paper3_algorithm2_notes.md`.

### Day 10 · Sat, Oct 31 — A5: Workspace sampling first version
- [ ] Revisit Paper 1's distinctions between geometric, wrench and interference constraints.
- [ ] Write `paper1_workspace_sampling.m` to generate a small position grid (initially fixed orientation).
- [ ] Assign each pose a feasible/infeasible flag using an **explicitly named** simple test; visualize both sets.

### Day 11 · Sun, Nov 1 — A5: Test, document, close
- [ ] Add orientation samples or a second clear constraint to the workspace grid, while keeping runtime manageable.
- [ ] Count feasible poses and calculate the sampled coverage fraction.
- [ ] Save `paper1_workspace_plot.png` and a note that Paper 1 is a **review**, not a claim of exact figure reproduction.

### Day 12 · Mon, Nov 2 — A4: Understand Paper 4 geometry
- [ ] Read Paper 4 Sections 2.1–2.2 and Figure 1; map paper symbols to `A_i`, `r_i`, `P`, `R`.
- [ ] Enter Paper 4 Table 1's eight-cable geometry, keeping units consistent.
- [ ] Implement `cable_lengths(A,r,P,R)` and test known poses without noise.

### Day 13 · Tue, Nov 3 — A4: Noisy measurement model
- [ ] Read Paper 4 Eq. (3)–(6); distinguish length and squared-length residuals.
- [ ] Generate `l_meas = l_true + sigma*randn(m,1)` with fixed random seed for reproducibility.
- [ ] Plot and check the measurement residuals; document units and assumed noise standard deviation.

### Day 14 · Wed, Nov 4 — A4: Measurement Jacobian
- [ ] Read Paper 4 Section 3.2, especially Eq. (12)–(15).
- [ ] Derive the 8×6 cable-length Jacobian for **small world-frame rotations** and verify its sign convention.
- [ ] Compare analytic Jacobian against small finite differences for x/y/z and 3 rotation components; save max errors.

---

## Week 3 — Paper 4 pose estimation and uncertainty (Nov 5–11)

**Weekly result:** A4 baseline pose estimator, covariance, Monte Carlo RMSE and 3σ plots.

### Day 15 · Thu, Nov 5 — A4: Nonlinear least squares
- [ ] Read Paper 4 Algorithm 1 and the Levenberg–Marquardt update (Method 2).
- [ ] Implement a first pose estimator with `lsqnonlin` (or a manually coded damped least-squares step).
- [ ] Make residual vectors consistent with the selected pose/rotation parameterization.

### Day 16 · Fri, Nov 6 — A4: Noiseless correctness tests
- [ ] Test recovery of a known 6-DOF pose from exact cable lengths.
- [ ] Check translation error in mm and rotation error in degrees, not only optimizer residual.
- [ ] Test more than one initial guess; record local convergence/failure instead of assuming unique forward kinematics.

### Day 17 · Sat, Nov 7 — A4: Weighted estimation with noise
- [ ] Add diagonal cable-length noise covariance `V` and the weighted least-squares residual.
- [ ] Run several noise realizations at one pose; inspect errors and solver diagnostics.
- [ ] Keep noise modeling separate from the true geometry and solver state.

### Day 18 · Sun, Nov 8 — A4: Covariance estimation
- [ ] Compute local covariance `P_cov = inv(H'*inv(V)*H)` conceptually; in MATLAB use linear solves rather than `inv`.
- [ ] Inspect rank and conditioning before inversion; mark singular/poorly conditioned cases as invalid.
- [ ] Extract positional standard deviations and appropriately represented orientation uncertainty; document linearization limits.

### Day 19 · Mon, Nov 9 — A4: Monte Carlo loop
- [ ] Implement `paper4_monte_carlo.m` over many independent noise realizations, using fixed true poses.
- [ ] Start at 20 runs for debugging, then increase toward 100 as runtime allows.
- [ ] Store estimated pose, true pose, solver success, and covariance for each run.

### Day 20 · Tue, Nov 10 — A4: RMSE metrics
- [ ] Compute position RMSE (mm) and orientation RMSE (degrees) from reconstructed poses.
- [ ] Compare results with covariance-based predicted uncertainty; investigate discrepancies.
- [ ] Save `paper4_rmse.png` and the sampling/noise configuration.

### Day 21 · Wed, Nov 11 — A4: ±3σ visualization
- [ ] Plot individual pose-coordinate errors against predicted ±3σ bounds on a selected trajectory or sequence of poses.
- [ ] Check whether axes, angle units and covariance parameterization are consistent.
- [ ] Record cases where bounds are misleading due to initialization, nonlinearity or rank issues.

---

## Week 4 — Paper 4 results, integration and clean handoff (Nov 12–18)

**Weekly result:** A4 completed to minimum scope, A1–A5 verified, organized, and ready for Phase B.

### Day 22 · Thu, Nov 12 — A4: NEES consistency check
- [ ] Read Paper 4 Section 5's NEES definition and confidence-interval interpretation.
- [ ] Compute NEES on the six-dimensional local pose-error representation (not a raw 7D quaternion difference).
- [ ] If enough independent runs are available, compare mean NEES against the appropriate chi-square bounds; label results preliminary if sample count is low.

### Day 23 · Fri, Nov 13 — A4: Method comparison / buffer
- [ ] Re-check Paper 4 reported **Method 1 = squared length**, **Method 2 = direct length**.
- [ ] Compare convergence at different initial guesses/iteration limits for Method 2.
- [ ] **Optional only:** implement a minimal squared-length residual to compare convergence; otherwise use time for debugging.

### Day 24 · Sat, Nov 14 — A4: Finish documentation
- [ ] Save `paper4_forward_kinematics.m`, `paper4_monte_carlo.m`, all key plots, and `paper4_notes.md`.
- [ ] Compare your results with paper trends; avoid claiming exact reproduction if geometry, attitude updates, or solver differ.
- [ ] Summarize what covariance means and what it does **not** prove about real hardware accuracy.

### Day 25 · Sun, Nov 15 — Shared-code cleanup
- [ ] Remove duplicate cable geometry / Jacobian functions between reproduced papers where practical.
- [ ] Give all scripts clear inputs, coordinate-frame comments, units, and reproducible random seeds.
- [ ] Run A1–A5 once from clean MATLAB sessions or documented working directories.

### Day 26 · Mon, Nov 16 — Transfer check (no full B-stage yet)
- [ ] Write a one-page mapping: Paper 3 WCC region vs. **future sensing-feasible** region.
- [ ] Note future sphere constraints: `||r_i|| = 50.83 mm`, fixed anchors, cable–sphere intersection, rank and covariance.
- [ ] Do **not** start multi-variable balloon optimization. List unresolved modeling decisions for B1.

### Day 27 · Tue, Nov 17 — Verification and catch-up
- [ ] Finish the most important incomplete A2/A3/A4 milestone or repair broken scripts.
- [ ] Check outputs against each task's Definition of Done in the TODO document.
- [ ] Create a short issue log: what reproduces well, what differs from the paper, and why.

### Day 28 · Wed, Nov 18 — Sprint closeout
- [ ] Update A1–A5 checkboxes in `current_october_november_todo.md` based on **actual** evidence.
- [ ] Commit/push code, notes, and figures into appropriate existing repository folders.
- [ ] Write a concise handoff for next sprint: **B1 first**, then B2/B3 feasible regions; list 2–3 concrete starting tasks.

---

## End-of-week review (10–15 minutes within Day 7/14/21/28)

| Week | Main check | Planned status |
|---|---|---|
| W1 | A1 archived; A2 Figure 2; A3 iteration prototype | [ ] |
| W2 | A3 region intersection done; A5 sampling done; A4 length/Jacobian ready | [ ] |
| W3 | A4 pose estimate, covariance, Monte Carlo and RMSE | [ ] |
| W4 | A4 consistency checks; all scripts documented; next sprint defined | [ ] |

## Priority if time slips

**Must finish:** A1, A2, A3, A4 Method 2/noiseless + basic noise/covariance, A5 minimal sampler.  
**Can simplify:** all-anchor PRI, NEES statistical analysis, Method 1 squared-length comparison, advanced quaternion/DCM, high-density plots.  
**Do not compromise:** coordinate-frame correctness, matrix dimensions, reproducible results, and clear distinction between WCC and sensing accuracy.

**Success criterion for this month:** Verified MATLAB modules and concise notes, **not** an optimized balloon configuration. That becomes the goal of the next phase.
