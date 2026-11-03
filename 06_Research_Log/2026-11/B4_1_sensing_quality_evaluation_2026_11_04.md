# B4.1 — Six-Cable Jacobian and Sensing Quality Evaluation

**Date:** 2026-11-04  
**Research phase:** Phase B — Balloon-Specific Cable Sensing Design  
**Stage:** B4.1 — Jacobian, Sensitivity, and Local Pose Covariance  
**Status:** Lessons 1–4 numerically verified; Lesson 5 synthesis code and plots prepared; final Lesson 5 command-window assertions pending confirmation  
**Configurations:** Experiment A and Experiment B (unchanged from B2)

---

## 1. Research Question

Can the two existing six-cable configurations locally distinguish the six rigid-body pose degrees of freedom, and how do their geometric feasibility, measurement sensitivity, and predicted pose uncertainty compare across a common sampled pose set?

The long-term objective is **passive balloon state sensing**, not prescribed trajectory control. The current model treats the balloon as rigid; deformation estimation is deferred.

## 2. Experimental Model

| Item | Definition |
|---|---|
| Engineering boundary | 280 × 300 × 320 mm (X = length, Y = width, Z = height) |
| Balloon | Rigid sphere, nominal volume 550 mL |
| Balloon radius | Approximately 50.83 mm |
| Cable count | Six per configuration |
| Anchor and attachment selection | Fixed B2 Experiment A and B configurations |
| Pose sampling | 27 centre positions × 7 orientation cases = 189 poses |
| Centre coordinates | Each of X, Y, Z in {-50, 0, 50} mm |
| Orientations | Identity; ±10° roll; ±10° pitch; ±10° yaw, individually |
| Geometric feasibility | B3.2 straight-segment cable–sphere and cable–cable checks |
| Hypothetical cable-length noise | Independent, zero-mean, Gaussian, standard deviation 0.1 mm per cable |
| Characteristic length | Balloon radius r_b |

The 189 cases are **engineering samples**, not observed patient motion trajectories or a continuous six-dimensional workspace. The model assumes ideal straight, zero-thickness cables; the interference criterion used a numerical near-zero distance threshold, not a validated mechanical clearance.

## 3. Measurement Model and Jacobian

For cable i, with a fixed world-frame anchor A_i, balloon centre P, body-frame attachment r_i, and body-to-world rotation R:

\[
B_i=P+Rr_i, \qquad L_i=\|A_i-B_i\|.
\]

Define the world-frame attachment offset and unit cable direction:

\[
s_i=Rr_i,\qquad u_i=\frac{A_i-B_i}{L_i}.
\]

For a local *world-frame* small rotation vector \(\delta\theta\) (left-multiplicative rotation perturbation), the cable-length measurement Jacobian row is

\[
H_i=\begin{bmatrix}-u_i^T&(u_i\times s_i)^T\end{bmatrix}.
\]

The local pose increment is \(\delta q=[\delta P^T,\delta\theta^T]^T\), where translations are in mm and rotations in rad. The characteristic-length-scaled Jacobian is

\[
H_s=H\,\mathrm{diag}(1,1,1,1/r_b,1/r_b,1/r_b).
\]

Its input represents \(\delta q_s=[\delta P^T,(r_b\delta\theta)^T]^T\), with all six components in mm. Scaled singular values and condition numbers depend on this chosen characteristic length.

## 4. Lesson 1 — Analytical Jacobian Verification

Central finite differences were used at the reference pose \(P=[0,0,0]^T\), \(R=I\), corresponding to sample index 92. Translation step: \(10^{-4}\) mm; rotation step: \(10^{-6}\) rad. Rotation derivatives used \(R_\pm=\exp(\pm h[e_j]_\times)R\), consistent with the analytical world-frame convention.

| Metric | Experiment A | Experiment B |
|---|---:|---:|
| Maximum absolute analytical–numerical Jacobian error | 1.329 × 10^-8 | 1.831 × 10^-8 |
| Reference Jacobian rank | 6 | 6 |
| Reference scaled minimum singular value | 0.535345 | 0.533600 |
| Reference scaled condition number | 3.5759 | 3.2365 |

**Result:** Both analytical Jacobians matched independent central finite differences at the reference pose; the original B2 local metrics were reproduced.

## 5. Lesson 2 — Workspace-Sampled Jacobian Evaluation

Both configurations had full-rank Jacobians at all 189 sampled poses. However, rank six establishes local first-order identifiability, not noise robustness or global uniqueness.

### 5.1 All 189 sampled poses (diagnostic only)

| Metric | Experiment A | Experiment B |
|---|---:|---:|
| Full rank | 189/189 | 189/189 |
| Minimum scaled sigma_min | 0.000491 | 0.169924 |
| Median scaled sigma_min | 0.187570 | 0.415161 |
| Maximum scaled condition number | 3492.1276 | 11.3888 |
| Median scaled condition number | 10.6621 | 4.4843 |

Jacobian values at geometrically infeasible poses are useful for diagnosing the underlying measurement mapping, but do not establish physically usable sensing states.

### 5.2 Each configuration's geometrically feasible subset

| Metric | Experiment A | Experiment B |
|---|---:|---:|
| Geometrically feasible poses | 40/189 | 105/189 |
| Feasible sample percentage | 21.2% | 55.6% |
| Full-rank feasible poses | 40/40 | 105/105 |
| Minimum scaled sigma_min | 0.012226 | 0.204807 |
| Median scaled sigma_min | 0.182628 | 0.416239 |
| Maximum scaled condition number | 166.1761 | 9.1591 |
| Median scaled condition number | 11.1157 | 4.4673 |

The feasible subsets are not identical; their unpaired medians describe performance within different sampled pose sets, not a controlled same-pose comparison.

## 6. Lesson 3 — Weakest Sensing Direction and Common Poses

The worst geometrically feasible pose for each configuration was selected using the smallest scaled singular value.

| Metric | Experiment A | Experiment B |
|---|---|---|
| Worst feasible pose index | 39 | 145 |
| Centre position (mm) | (50, 0, -50) | (50, -50, 50) |
| Orientation | Pitch +10° | Pitch -10° |
| Scaled sigma_min | 0.012226 | 0.204807 |
| Scaled condition number | 166.1761 | 9.1591 |
| Weakest scaled right-singular vector | (-0.5666, 0.3689, 0.1803, -0.5073, -0.1789, -0.4702) | (0.5327, -0.0074, -0.3621, -0.2296, -0.6760, -0.2746) |

The weakest right-singular vector describes a **local coupled translation-and-rotation perturbation direction** that produces the smallest cable-length response per unit scaled pose perturbation. It is neither a measured motion nor a prescribed trajectory. The sign of an SVD direction is arbitrary.

### 6.1 Identical-pose comparison

The two configurations share **19 geometrically feasible poses**. Among these:

| Metric | Experiment A | Experiment B | B better count |
|---|---:|---:|---:|
| Median scaled sigma_min | 0.187570 | 0.416239 | 18/19 (higher) |
| Median scaled condition number | 10.9230 | 4.8678 | 18/19 (lower) |

These comparisons control for the pose location and orientation; they remain limited to the 19 sampled common feasible cases.

## 7. Lesson 4 — Local Pose Covariance

Assume independent Gaussian cable-length noise, with \(\Sigma_L=(0.1\ \mathrm{mm})^2 I_6\). Under a locally linearised, full-rank measurement model and known geometry:

\[
\Sigma_q=(H^T\Sigma_L^{-1}H)^{-1}.
\]

The implementation computes covariance using the SVD of \(H_s\) and then converts to the physical coordinates \([\delta P;\delta\theta]\). The predicted 3D error-norm RMS indicators are

\[
U_P=\sqrt{\operatorname{tr}(\Sigma_P)}\quad\text{(mm)},
\qquad
U_\theta=\frac{180}{\pi}\sqrt{\operatorname{tr}(\Sigma_\theta)}\quad\text{(degrees)}.
\]

These are aggregate local uncertainty predictions, not per-axis standard deviations or nonlinear-estimator Monte Carlo RMSE.

| Metric on each feasible subset | Experiment A | Experiment B |
|---|---:|---:|
| Feasible poses | 40 | 105 |
| Median position uncertainty | 0.3860 mm | 0.1657 mm |
| Worst position uncertainty | 5.7243 mm | 0.3347 mm |
| Median orientation uncertainty | 0.5663° | 0.2913° |
| Worst orientation uncertainty | 6.5895° | 0.4626° |

### 7.1 Identical-pose uncertainty comparison

| Metric across 19 common feasible poses | A | B | B lower count |
|---|---:|---:|---:|
| Median position uncertainty | 0.3981 mm | 0.1759 mm | 19/19 |
| Median orientation uncertainty | 0.5680° | 0.2913° | 18/19 |

At the reference pose, algebraic consistency checks gave \(\|H\Sigma_qH^T-\Sigma_L\|_F\) of 2.521 × 10^-17 (A) and 8.140 × 10^-17 (B). These are **numerical covariance identity checks**, not experimental validation.

### 7.2 Lesson 4 research conclusion

Under the *assumed* 0.1 mm cable-length noise standard deviation, Experiment B exhibits lower and more consistent **predicted local pose uncertainty** than Experiment A, both on its own geometrically feasible subset and on the same 19 feasible poses. Real pose accuracy remains unverified because calibration errors, model bias, cable mechanics, and nonlinear estimation are not included.

## 8. Lesson 5 — Integrated Synthesis and Visualisation

The final synthesis MATLAB section combines:

1. An integrated geometric-feasibility and sensing-quality table.
2. A paired metrics table on the 19 common feasible poses.
3. A geometric-failure breakdown using the unchanged B3.2 masks.
4. Boxcharts of the four sensing metrics on each configuration's feasible subset.
5. Log-log paired scatter plots for position and orientation uncertainty, with the \(y=x\) line signifying equality.
6. Consistency assertions and export of results to a MATLAB MAT-file.

The user confirmed that the final figures have the same content as the previously inspected revised plots. The supplied final script includes expected assertions, but a final command-window transcript for all Lesson 5 checks has not been provided; consequently **the synthesis assertions are not independently confirmed in the final script version**.

### 8.1 Failure mechanisms inherited from B3.2

| Failure metric among 189 poses | Experiment A | Experiment B |
|---|---:|---:|
| Cable–sphere failing poses | 149 | 3 |
| Cable–cable contact poses | 0 | 81 |
| Combined geometrically failing poses | 149 | 84 |

For Experiment B, all 81 numerically detected cable–cable contacts were associated with Cable Pair 5–6: 27 zero-rotation cases and 54 roll ±10° cases. Contact was not detected for that pair in the sampled ±10° pitch and yaw cases under the current threshold. Actual cable thickness and required clearance have not been tested.

### 8.2 Figure interpretation

- **Figure 1:** Descriptive distribution on *different* feasible subsets (A: 40, B: 105); lower condition numbers and lower predicted uncertainty are preferable, while higher sigma_min is preferable.
- **Figure 2:** Paired comparison on 19 *identical* feasible poses; each point has X = A uncertainty, Y = B uncertainty. Points below the equality line indicate lower predicted uncertainty in B. The figures show sampled poses, not a time sequence or trajectory.

Expected output filenames from the final Lesson 5 section:

- `B4_1_sensing_quality_final.png`
- `B4_1_common_pose_uncertainty_final.png`
- `B4_1_results.mat`

## 9. Scientific Interpretation and Limitations

1. **Geometric feasibility is necessary but not sufficient.** Neither configuration has been shown to satisfy continuous-workspace cable clearance or realistic routing.
2. **Full Jacobian rank is not accuracy.** Experiment A is full rank at every sampled pose but has severe weak-direction sensitivity in some cases.
3. **Singular values and conditioning depend on scaling.** The balloon radius is the declared characteristic length.
4. **The uncertainty model is hypothetical and local.** The 0.1 mm value is an assumed cable-length standard deviation, not measured sensor performance.
5. **No tension feasibility is established.** The proposed low-tension tracking system must be assessed for positive tension, motor tracking, and disturbance to passive balloon motion.
6. **No global uniqueness is established.** A full-rank local Jacobian does not guarantee globally unique cable-length inverse solutions.
7. **No nonlinear FK accuracy is established.** Forward kinematics and Monte Carlo simulation remain to be performed.
8. **Sample and optimisation dependence remains.** These results compare two candidates generated by a limited random search; neither is globally optimal.
9. **Clinical interpretation is limited.** The simplified cuboid, position samples, and orientations are engineering assumptions rather than patient-derived physiological motion limits.

## 10. Research Decision

Experiment B is the **stronger current candidate for further investigation** because it achieves higher geometric pass counts, generally stronger minimum singular values, lower condition numbers, and smaller predicted pose uncertainty in the declared sampling model. It is **not** selected as the final six-cable configuration.

Experiment A remains a useful baseline for comparison and for diagnosing sphere-interference and weak-sensing failures.

## 11. Transition to B5 and B4.2

**B5.1 — Planned constraint-aware six-cable configuration optimisation**

- Preserve a fixed target pose set across candidates; never improve a reported median merely by discarding difficult poses.
- Treat cable–sphere routing and cable–cable clearance as explicit geometric constraints, with a physically justified clearance to be introduced separately.
- Prioritise fixing Experiment B's Cable 5–6 numerical contact, especially at zero rotation and roll ±10°.
- Maintain useful sigma_min and local uncertainty while improving geometric feasibility.
- Include candidate robustness and an independent validation pose set, not just the tuning samples.
- Do not assert tension feasibility without a force model and appropriate external wrench assumptions.

**B4.2 — Planned nonlinear pose estimation / Monte Carlo**

- Use cable lengths generated at known simulated ground-truth poses.
- Solve for estimated pose without providing true pose to the estimator.
- Apply explicitly defined sensor-noise scenarios and geometry perturbations.
- Report position/orientation RMSE, solver convergence/failures, and consistency with local covariance predictions.

**Decision gate:** Confirm the final Lesson 5 command-window assertions and archive the MATLAB script, figures, and MAT data before closing B4.1. Then proceed to a clearly defined B5.1 objective/constraint formulation, with B4.2 remaining a required validation stage before final selection.

---

## 12. Reproducibility and Repository Files

Suggested archive location for this report:

`06_Research_Log/2026-11/B4_1_sensing_quality_evaluation_2026_11_04.md`

Current MATLAB directory:

`03_Simulation/MATLAB/workspace definition/`

Supporting MATLAB inputs:

- `B1_geometry_baseline.mat`
- `B2_6cable_experiment_A.mat`
- `B2_experiment_B_results.mat`
- `B3_2_results.mat`

Primary outputs:

- `B4_1_jacobian_verification_2026_11_03.m` (or the verified final local script name)
- `B4_1_results.mat`
- `B4_1_sensing_quality_final.png`
- `B4_1_common_pose_uncertainty_final.png`

The report records numerical outputs supplied from the MATLAB runs and avoids presenting the final synthesis code as independently executed by the assistant.
