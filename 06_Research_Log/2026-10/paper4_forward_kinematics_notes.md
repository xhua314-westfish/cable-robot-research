# A4 — Paper 4 Forward Kinematics and Pose Covariance: Research Notes

**Status:** Core method validated in MATLAB; educational reconstruction, not full paper reproduction.  
**Reference:** Patel, Nguyen & Caverly (2023), *Forward kinematics of a cable-driven parallel robot with pose estimation error covariance bounds*, *Mechanism and Machine Theory*, 183, 105231. DOI: 10.1016/j.mechmachtheory.2023.105231.

## 1. Research purpose

Determine whether cable-length measurements can recover six-degree-of-freedom pose and quantify local sensing uncertainty in a cable-driven metrology system. The long-term application is a **passively moving deformable balloon**; this A4 experiment uses a **rigid platform**, known anchor/attachment geometry, and fixed, taut, straight, inextensible cable assumptions.

## 2. Model and simulation setup

- **Geometry:** Paper 4 Table 1; eight anchors and eight body-fixed attachment points (all converted from cm to m).
- **True pose:** `P_true = [0.15; 0.15; 0.465] m`, `R_true = eye(3)`.
- **Length function:** `D_i=P+R*r_i-A_i`, `g_i(P,R)=norm(D_i)`.
- **Noise:** Independent Gaussian cable-length noise with standard deviation `sigma_L=0.001 m` per cable.
- **Analytical length Jacobian:** Row `H_i = [e_i^T, (R*r_i cross e_i)^T]`, where `e_i=D_i/norm(D_i)`. Rotation increment refers to a **world-frame small rotation vector**.
- **Estimator:** Educational 6-DOF Gauss–Newton least squares, `delta_q=H\(L_measured-g(P,R))`, `P <- P+delta_P`, `R <- exp([delta_omega]x)*R`. This is *not* the paper's full Levenberg–Marquardt implementation.
- **Local covariance:** `P_cov=(H^T*V^{-1}*H)^{-1}`, `V=sigma_L^2*I_8`. Use consistent pose parameterization.
- **Monte Carlo:** 100 independent noise realizations, true pose held fixed, initial estimate reset per trial.

## 3. Verified output (user's recorded MATLAB run)

| Test | Recorded result |
|---|---|
| Jacobian dimension and rank | 8×6, rank 6 |
| Maximum analytic–numerical Jacobian difference | 4.102e-11 |
| Combined small translation and rotation prediction | Maximum cable-length linearization error 0.009630 mm |
| Noise-free FK | 4 iterations, position/rotation error effectively zero at displayed precision |
| One noisy FK realization | 0.796307 mm position error, 0.726363 deg rotation error, 1.265 mm final measurement residual, 5 iterations |
| 100 Monte Carlo runs | Mean final length residual 1.2934 mm; mean iteration count 6.00 |
| Position predicted standard deviations (mm) | X 0.50179, Y 0.94619, Z 0.63404 |
| Position empirical standard deviations (mm) | X 0.51699, Y 0.97314, Z 0.67534 |
| Rotation predicted standard deviations (deg) | RotX 0.44562, RotY 0.42287, RotZ 0.63990 |
| Rotation empirical standard deviations (deg) | RotX 0.48409, RotY 0.42616, RotZ 0.69790 |
| Per-axis position 3σ coverage | X 100%, Y 100%, Z 99% |
| Per-axis rotation 3σ coverage | RotX 99%, RotY 100%, RotZ 99% |
| Average NEES | 6.6459 |
| 95% ANEES acceptance interval (N=100, six dimensions) | [5.3402, 6.6977] — **pass**, close to upper bound |

**Important:** These values are from the user's *original recorded MATLAB run*. The consolidated script is independently reorganized and must be executed before marking its new output as revalidated. Small numerical differences can arise if predicted covariance is evaluated at the known true pose rather than the noisy final estimated pose, or from RNG ordering.

### Position results

| Axis | Bias (mm) | RMSE (mm) | MC Std (mm) | 3σ Bound (mm) | Coverage |
|---|---:|---:|---:|---:|---:|
| X | +0.0078802 | 0.51446 | 0.51699 | 1.5054 | 100% |
| Y | −0.0114250 | 0.96833 | 0.97314 | 2.8386 | 100% |
| Z | +0.0021883 | 0.67195 | 0.67534 | 1.9021 | 99% |

### Rotation results

| Axis | Bias (deg) | RMSE (deg) | MC Std (deg) | 3σ Bound (deg) | Coverage |
|---|---:|---:|---:|---:|---:|
| RotX | −0.078184 | 0.48797 | 0.48409 | 1.3369 | 99% |
| RotY | +0.0035593 | 0.42404 | 0.42616 | 1.2686 | 100% |
| RotZ | +0.123680 | 0.70533 | 0.69790 | 1.9197 | 99% |

## 4. Interpretation

- Full rank (6) supports **local first-order identifiability**, not guaranteed global uniqueness.
- The largest position uncertainty in the tested pose is along Y; the largest rotation uncertainty is along world-frame Z.
- The empirical standard deviations are close to the linearized covariance prediction at the same fixed pose.
- 100-trial ANEES is inside the nominal 95% interval, **but near its upper edge**. The consistency test does not prove the estimator is perfect.
- Length fitting residual is **not** the same as pose estimation error.
- Covariance and RMSE are pose-dependent: a single fixed-pose result does not characterize whole-workspace sensing quality.

## 5. Limitations and next research questions

1. Rigid attachment geometry is not valid for a deforming balloon without a more elaborate shape or deformation state.
2. Cable sag, compliance, pulley effects, calibration uncertainty and correlated sensor errors are omitted.
3. Positive tension / WCC feasibility must be checked separately. Jacobian full rank does not establish tautness or positive self-stress.
4. Gauss–Newton can depend on initial guesses; the reference paper also investigates Levenberg–Marquardt and alternative attitude parameterizations.
5. ANEES nominal chi-square bounds rely on independent trials, approximately Gaussian/unbiased errors, and a correct covariance model.
6. Use more pose samples, orientation samples, independent seeds and failure/convergence diagnostics before making performance claims.
7. For fair 6/7/8 comparisons, hold pose grid, per-cable noise specification and estimation settings constant, and evaluate both deletion baselines and individually optimized layouts.

## 6. Planned deliverables / archiving

- `paper4_forward_kinematics.m` (integrated educational reproduction)
- `paper4_covariance_vs_monte_carlo.png` (created by MATLAB when the script runs)
- `paper4_nees_histogram.png` (created by MATLAB when the script runs)
- `paper4_position_statistics.csv`, `paper4_rotation_statistics.csv`, `paper4_nees_bins.csv` (created by MATLAB)
- This markdown note
- Record exact MATLAB version/toolboxes and random seed in the final research log.
