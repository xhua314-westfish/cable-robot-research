# B4.1 Lesson 4 — Local Pose Covariance and Predicted Uncertainty

**Date:** 2026-11-04  
**Phase:** B — Six-Cable Sensing Quality  
**Status:** Completed — numerical evaluation and reference-pose covariance consistency verified  
**Scope:** Lesson 4 only; final Lesson 5 visualization is not yet signed off.

---

## 1. Research Question

How does assumed cable-length sensor noise propagate through the six-cable measurement Jacobian into **local** uncertainty in the estimated balloon position and orientation?

## 2. Inputs and Assumptions

- Balloon: rigid sphere, nominal volume 550 mL, radius approximately 50.83 mm.
- Six cable lengths are the measurement outputs; pose has six local coordinates (three translations and a world-frame small rotation vector).
- Experiment A: fixed six face-centre anchors; selected attachments.
- Experiment B: jointly selected anchors and attachments.
- Discrete test set from B3.2: 27 centre positions × 7 orientation cases = **189 poses**.
- B3.2 zero-thickness, straight-cable geometric feasibility masks are reused without modification.
- Each cable-length sensor has an **assumed** independent zero-mean Gaussian error with standard deviation `sigma_L = 0.1 mm`.
- Cable geometry is treated as exactly known. Cable friction, elasticity, routing clearance, tension and calibration error are not modelled.

**This is a hypothetical noise setting for simulation, not experimentally calibrated sensor performance.**

## 3. Mathematical Method

For a small world-frame pose perturbation, the six measured length increments satisfy

\[
\delta L \approx H(q)\,\delta q + \varepsilon, \qquad
\delta q = [\delta P^T,\delta\theta^T]^T.
\]

Each row of the measurement Jacobian is

\[
H_i=[-u_i^T,(u_i\times s_i)^T],\quad
u_i=\frac{A_i-(P+Rr_i)}{L_i},\quad s_i=Rr_i.
\]

The locally linearized covariance under the declared independent equal-variance noise model is

\[
\Sigma_L = \sigma_L^2 I_6,\qquad
\Sigma_q=(H^T\Sigma_L^{-1}H)^{-1}.
\]

To handle mixed units, calculate the scaled Jacobian

\[
H_s=HS,\qquad S=\mathrm{diag}(1,1,1,1/r_b,1/r_b,1/r_b),
\]

where the scaled pose perturbation is `delta_q_s = [delta_P; r_b * delta_theta]` (all six components expressed in millimetres, **not** dimensionless). For `H_s = U diag(s_j) V^T`:

\[
\Sigma_{q_s}=V\,\mathrm{diag}(\sigma_L^2/s_j^2)\,V^T,
\qquad
\Sigma_q=S\Sigma_{q_s}S^T.
\]

Report the predicted RMS magnitude of the local 3D position and small-angle rotation error vectors:

\[
U_P=\sqrt{\mathrm{tr}(\Sigma_q[1:3,1:3])}\quad (\mathrm{mm}),
\]

\[
U_\theta=\frac{180}{\pi}\sqrt{\mathrm{tr}(\Sigma_q[4:6,4:6])}\quad (\mathrm{degrees}).
\]

These are **predicted RMS error norms** from a local covariance model, not directly observed pose errors or individual-axis standard deviations.

## 4. Numerical Results

### 4.1 Each Configuration's Geometrically Feasible Subset

| Metric | Experiment A | Experiment B |
|---|---:|---:|
| Feasible poses (out of 189) | 40 | 105 |
| Median predicted 3D position uncertainty | **0.3860 mm** | **0.1657 mm** |
| Maximum predicted 3D position uncertainty | 5.7243 mm | 0.3347 mm |
| Median predicted 3D orientation uncertainty | **0.5663°** | **0.2913°** |
| Maximum predicted 3D orientation uncertainty | 6.5895° | 0.4626° |

Experiment A exhibits several high-uncertainty poses. This is consistent with its weak minimum singular values in B4.1 Lessons 2–3. Experiment B yields smaller and more consistent predicted uncertainty in its feasible sample set.

### 4.2 Paired Comparison on Identical Feasible Poses

There are **19 poses** for which both configurations pass the B3.2 geometric checks.

| Paired metric | Experiment A | Experiment B |
|---|---:|---:|
| Median predicted position uncertainty | 0.3981 mm | 0.1759 mm |
| Median predicted orientation uncertainty | 0.5680° | 0.2913° |

- B has lower predicted position uncertainty for **19/19** paired poses.
- B has lower predicted orientation uncertainty for **18/19** paired poses.

The paired subset is the appropriate basis for a direct same-pose comparison. The 40- versus 105-pose distributions describe different feasible domains and should not be presented as a perfectly controlled paired test.

### 4.3 Numerical Consistency Verification

At the common reference pose (`P = [0,0,0] mm`, `R = I`, pose index 92), the calculated covariance satisfies the square-Jacobian identity `H * Sigma_q * H' ≈ Sigma_L`:

| Configuration | Frobenius residual |
|---|---:|
| Experiment A | 2.521 × 10^-17 |
| Experiment B | 8.140 × 10^-17 |

Both are below the implemented threshold `1e-8`, establishing numerical algebraic consistency for this check. They do **not** validate the sensor noise model or physical measurement accuracy.

## 5. Interpretation

1. Full Jacobian rank alone does not prevent high pose uncertainty; sufficiently small singular values lead to large local noise amplification.
2. Experiment B provides lower predicted uncertainty than Experiment A on nearly all 19 identically feasible tested poses.
3. Experiment A's worst-case predicted uncertainty makes it a useful diagnostic reference but a weaker candidate under the current assumptions.
4. The predicted results are contingent on the assumed 0.1 mm independent length-noise SD and exact rigid geometry.
5. No final six-cable configuration should be selected solely from local covariance.

## 6. Limitations

- Linearization validity at poorly conditioned poses has not been established against a nonlinear forward-kinematics estimator.
- The test poses are discrete engineering samples, not a time trajectory or clinical motion distribution.
- The idealized geometric feasibility masks exclude real cable radius, clearance and collision with hardware.
- Systematic geometry calibration error, correlated noise, cable stretch, friction and motor-induced force are excluded.
- The six-cable mechanical tension feasibility and passive-motion disturbance are unverified.
- Generalization outside sampled poses is not established.

## 7. Research Decision and Next Step

**Lesson 4 is complete.** Retain both A and B for comparison, with B provisionally favored for local sensing quality on the sampled feasible poses.

Before closing **B4.1 Lesson 5**, fix the MATLAB figure-generation code and check the paired comparison graphics. In the paired scatter plot, each point represents one identical geometric pose for A and B; `x = A uncertainty`, `y = B uncertainty`, and the diagonal `y = x` denotes equal uncertainty. A point **below** the diagonal favors B. These are not consecutive time samples.

After plot validation, summarize B4.1 Lessons 1–5 and archive the final code, `.mat` output, and figures. Then proceed with the planned optimization / nonlinear estimation stages according to the research schedule.

## 8. Relevant Reproducibility Files

- MATLAB code: `03_Simulation/MATLAB/workspace definition/B4_1_jacobian_verification_2026_11_03.m`
- Prior geometric data: `03_Simulation/MATLAB/workspace definition/B3_2_results.mat`
- Local output: `B4_1_results.mat` (generated by the MATLAB script)
- Research log destination: `06_Research_Log/2026-11/B4_1_Lesson4_local_pose_covariance.md`

---

**Summary:** For assumed independent cable-length noise with a 0.1 mm standard deviation, Experiment B predicts lower local pose uncertainty than Experiment A in the sampled comparison, including 19/19 paired positions and 18/19 paired orientations. The result is theoretical, local, and model-dependent; it is not an experimentally measured pose-estimation accuracy.
