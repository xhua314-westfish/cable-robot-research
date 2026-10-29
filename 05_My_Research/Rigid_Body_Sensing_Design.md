**Version:** 0.3  
**Original Definition:** 2026-10-19  
**Last Reviewed:** 2026-10-30  
**Current Research Phase:** Phase B — Balloon-Specific Cable Sensing Design  
**Current Task:** B1 — Geometry and Candidate Region Definition  
**Primary Tool:** MATLAB  
**Status:** Mathematical framework established; reference-geometry methods verified in Phase A; balloon-specific implementation pending.

> This document defines the technical measurement and sensing model. Current research progress is maintained in [CURRENT_STATE2.md](../CURRENT_STATE2.md), and active tasks are maintained in [current_october_november_todo.md](../08_Project_Management/current_october_november_todo.md).


---

## 1. Research Objective

<!-- UPDATED: Changed from planar position measurement to 3D 6-DOF pose sensing. -->

This study investigates cable-based pose measurement of a rigid spherical object moving passively within a simplified three-dimensional gastric workspace.

The main technical objective is to develop and evaluate a measurement model that estimates the object's **three-dimensional position and orientation** from cable-length measurements.

The configuration study focuses on:

- Six-cable reference configuration.
- Seven- and eight-cable primary configurations.
- Three-dimensional anchor placement.
- Three-dimensional attachment placement.
- Pose identifiability and estimation accuracy.
- Sensing workspace and mechanical feasibility.

The full research scope is defined in [Sensing Objective v0.2](Sensing_Objective_v0.2.md).

---

## 2. Simplified Physical Model

### 2.1 Gastric Environment

The initial sensing environment is represented by a simplified three-dimensional engineering boundary.

**Reference population:** Adult female, prioritising obesity-related evidence where available.

**Primary geometric representation:** Axis-aligned rectangular cavity surrogate.

**Alternative representation:** Ellipsoidal cavity surrogate for later sensitivity analysis.

The selected world-coordinate convention is:

| Axis | Dimension | Meaning |
|---|---|---|
| X | \(L_g\) | Length |
| Y | \(W_g\) | Width |
| Z | \(H_g\) | Height |

All dimensions must be defined consistently in millimetres for the initial geometry model.

The origin is located at the centre of the engineering boundary.

For a cuboid with dimensions \(L_g,W_g,H_g\):

\[
\Omega_g=
\left\{
(x,y,z):
|x|\leq\frac{L_g}{2},
|y|\leq\frac{W_g}{2},
|z|\leq\frac{H_g}{2}
\right\}
\]

The boundary dimensions are engineering model inputs and must not be interpreted as directly measured clinical balloon-motion limits.

**Existing evidence note:**

`Workspace_Boundary_v0.2_2026-10-20.md` contains a provisional engineering boundary based on a different coordinate convention.

Its reported dimensions must be mapped explicitly into the selected coordinate system before reuse.

The provisional source values are:

- Original X / Width: 150 mm.
- Original Y / Anteroposterior depth: 160 mm.
- Original Z / Craniocaudal length: 140 mm.

These values are not automatically equivalent to the new Length, Width and Height definitions.

Their interpretation and suitability must be reviewed in B1.1.

### 2.2 Rigid Spherical Balloon

The initial measurement object is a rigid spherical proxy of a commercial intragastric balloon.

| Parameter | Value | Classification |
|---|---|---|
| Balloon volume | 550 mL | Selected engineering baseline |
| Geometric model | Rigid sphere | Assumed |
| Equivalent radius | Approximately 50.83 mm | Derived |
| Equivalent diameter | Approximately 101.65 mm | Derived |
| Deformation | Excluded | Initial simplification |
| Motion | Passive and unknown | Research assumption |

The equivalent radius is calculated using:

\[
r_s=\left(\frac{3V_b}{4\pi}\right)^{1/3}
\]

where:

\[
V_b=550,000\ \mathrm{mm}^3
\]

The equivalent sphere diameter is:

\[
D_s=2r_s
\]

The equivalent diameter is calculated from the selected volume and is not a directly measured clinical balloon diameter.

### 2.3 Geometric Feasibility

The entire spherical balloon must remain inside the selected gastric boundary.

Define:

\[
W_{\mathrm{centre}}=
\{P\in\mathbb{R}^3:
B(P,r_s)\subseteq\Omega_g\}
\]

where:

- \(P\): Balloon-centre position.
- \(r_s\): Balloon radius.
- \(B(P,r_s)\): Solid sphere centred at \(P\).
- \(\Omega_g\): Simplified gastric cavity surrogate.

For the axis-aligned cuboid with an assumed nonnegative clearance \(c\), full sphere containment requires:

\[
|P_x|\leq \frac{L_g}{2}-r_s-c
\]

\[
|P_y|\leq \frac{W_g}{2}-r_s-c
\]

\[
|P_z|\leq \frac{H_g}{2}-r_s-c
\]

The feasible centre region is empty if any right-hand side is negative.

The clearance value must be explicitly selected and documented.

No fixed clearance is assumed to be clinically validated.

For an ideal spherical object, geometric containment is independent of orientation.

However, the cable routing, attachment geometry, and mechanical constraints can restrict the admissible orientations.

### 2.4 Alternative Boundary Representation

An ellipsoidal surrogate may be used to investigate the sensitivity of the results to the chosen boundary shape.

For the selected coordinate convention:

\[
\Omega_{\mathrm{ellipsoid}}=
\left\{
(x,y,z):
\frac{x^2}{(L_g/2)^2}
+
\frac{y^2}{(W_g/2)^2}
+
\frac{z^2}{(H_g/2)^2}
\leq 1
\right\}
\]

The ellipsoid and cuboid must not be treated as equivalent cavity geometries.

Their volumes and full-sphere containment regions differ.

In particular, cuboid centre-travel equations must not be reused as exact ellipsoid containment conditions.

### 2.5 Geometry Modelling Limitations

The simplified model does not establish:

- A patient-specific gastric lumen.
- A clinically validated three-dimensional balloon-motion range.
- Anatomical wall deformation.
- Physiological gastric motion.
- Physical cable mounting feasibility.
- Actual balloon shape changes.

These limitations must remain explicit when evaluating candidate configurations.

**B1 objective:** Confirm the geometry parameters, implement balloon containment, and define candidate anchor and attachment regions before proceeding to cable configuration generation.

---

## 3. Three-Dimensional Cable Measurement Model

<!-- UPDATED: Replaced the original planar position-only model. -->

### 3.1 Rigid-Body State

The initial sensing model estimates the full six-degree-of-freedom rigid-body pose:

\[
q=[x,y,z,\phi,\theta,\psi]^T
\]

The physical pose is represented by:

\[
P\in\mathbb R^3,\qquad R\in SO(3)
\]

where:

- \(P\): Object-centre position in the world frame.
- \(R\): Rotation from the object frame to the world frame.

The object can translate and rotate without following a prescribed trajectory.

Rotation matrices will be used in the core measurement model.

Euler angles may be used for interpretation and visualisation.

### 3.2 Cable Geometry

For cable \(i\), define:

- \(A_i\in\mathbb R^3\): Fixed anchor point.
- \(r_i\in\mathbb R^3\): Local attachment point.
- \(B_i\in\mathbb R^3\): World-frame attachment point.
- \(P\in\mathbb R^3\): Object-centre position.
- \(R\in SO(3)\): Object orientation.

The world-frame attachment position is:

\[
B_i=P+Rr_i
\]

The vector from the attachment point to the anchor is:

\[
d_i=A_i-B_i
\]

The ideal cable length is:

\[
L_i=\|d_i\|_2
\]

The unit direction from attachment to anchor is:

\[
u_i=\frac{d_i}{L_i}
\]

All coordinates and lengths must use consistent physical units.

For an ideal surface attachment:

\[
\|r_i\|_2=r_s
\]

Any attachment mechanism that offsets the connection point from the spherical surface must be modelled separately.

### 3.3 Measurement Relationship

The ideal forward measurement model is:

\[
L=h(P,R)
\]

The sensor measurement model is:

\[
y=h(P,R)+\varepsilon
\]

where:

- \(y\in\mathbb R^n\): Cable-length measurements.
- \(h(P,R)\in\mathbb R^n\): Predicted cable lengths.
- \(\varepsilon\in\mathbb R^n\): Measurement errors.

Initially, cables are assumed taut, straight, and inextensible.

Fixed anchor and attachment geometries are assumed.

The initial model excludes friction, sagging, spool geometry errors, and elastic deformation.

These effects will be investigated during physical feasibility and calibration analysis.

### 3.4 Six-DOF Measurement Jacobian

<!-- NEW: Explicit analytical Jacobian for the selected 3D model. -->

For a small world-frame translation \(\delta P\) and small world-frame rotation vector \(\delta\alpha\):

\[
\delta L\approx H
\begin{bmatrix}
\delta P\\
\delta\alpha
\end{bmatrix}
\]

Define:

\[
s_i=Rr_i
\]

For the chosen convention \(d_i=A_i-B_i\), the \(i\)-th Jacobian row is:

\[
\boxed{
H_i=
\begin{bmatrix}
-u_i^T & (u_i\times s_i)^T
\end{bmatrix}
}
\]

Therefore:

\[
H\in\mathbb R^{n\times6}
\]

and:

\[
\delta L\approx H\delta q
\]

where \(\delta q=[\delta P^T,\delta\alpha^T]^T\) is a local six-dimensional pose increment, rather than a direct subtraction of global Euler-angle coordinates.

The analytical Jacobian must be verified using numerical finite differences for both translation and rotation.

The rotational increment convention and numerical units must be kept consistent.

### Jacobian Convention and Phase A Verification

For the existing convention:

\[
d_i=A_i-B_i,\qquad u_i=d_i/L_i
\]

and a small world-frame rotational perturbation, the analytical measurement Jacobian is:

\[
H_i=
\begin{bmatrix}
-u_i^T & (u_i\times s_i)^T
\end{bmatrix}
\]

where \(s_i=Rr_i\).

The sign convention must be kept consistent in the MATLAB implementation.

**Phase A verification:**

The eight-cable reference model implemented in A4 was tested using analytical and numerical Jacobians.

The reported maximum Jacobian discrepancy was:

\[
4.102\times10^{-11}
\]

This verifies the selected reference implementation numerically within the tested conditions.

**Phase B requirement:**

The Jacobian must be re-evaluated and numerically verified for each new balloon-specific cable configuration.

The Phase A reference result does not automatically validate a new anchor or attachment geometry.

For conditioning comparisons, translational and rotational variables must be scaled using a clearly defined characteristic length or equivalent physically meaningful normalisation.

---

## 4. Cable Configuration and Measurement Evaluation

### 4.1 Design Variables

<!-- UPDATED: Selected the six-cable baseline and seven/eight primary candidates. -->

| Variable | Investigation |
|---|---|
| Cable number | 6 baseline; 7 and 8 primary candidates |
| Anchor placement | Three-dimensional fixed mounting positions |
| Attachment placement | Three-dimensional positions on the rigid sphere |
| Cable routing | Interference and path feasibility |
| Low-tension mechanism | Cable tracking and motion disturbance |

The previous four-cable planar MATLAB model is retained only as a mathematical verification reference.

It is not a candidate for unconstrained six-degree-of-freedom length-only sensing.

### 4.2 Pose Identifiability

For local 6-DOF pose estimation:

\[
\operatorname{rank}(H)=6
\]

is a necessary condition.

The investigation must also consider:

- Jacobian singularity.
- Poor measurement conditioning.
- Translational and rotational measurement coupling.
- Multiple pose solutions producing similar cable lengths.
- Sensitivity to noise and calibration errors.

Full rank does not guarantee globally unique pose estimation or acceptable accuracy.

### 4.3 State Estimation

<!-- UPDATED: Generalised the estimator from 2D position to full 3D pose. -->

Estimate position and orientation using constrained nonlinear least squares:

\[
(\hat P,\hat R)=
\arg\min_{(P,R)\in W_{\mathrm{test}}}
\left\|
y-h(P,R)
\right\|_{\Sigma^{-1}}^2
\]

where:

- \(W_{\mathrm{test}}\): Selected feasible pose domain.
- \(\Sigma\): Cable-length measurement covariance matrix.
- \(\|v\|_{\Sigma^{-1}}^2=v^T\Sigma^{-1}v\).

When equal independent cable-length noise is assumed, unweighted least squares may be used.

Different initial poses must be tested to investigate solution ambiguity and convergence.

The estimator must not receive the true object pose as an input.

### 4.4 Evaluation Metrics

| Metric | Purpose |
|---|---|
| Jacobian rank | Local pose identifiability |
| Scaled singular values | Measurement sensitivity |
| Scaled condition number | Geometric conditioning |
| Position RMSE | Translational accuracy |
| Orientation RMSE | Rotational accuracy |
| Maximum pose error | Worst-case performance |
| Estimation success rate | Reliability |
| Noise sensitivity | Robustness |
| Workspace coverage | Valid sensing region |
| Motion disturbance | Influence of cables on passive motion |

For position error:

\[
e_p=\|\hat P-P\|_2
\]

For orientation error:

\[
e_R=
\cos^{-1}
\left(
\frac{\operatorname{tr}(\hat R^TR)-1}{2}
\right)
\]

The inverse-cosine argument must be clamped to \([-1,1]\) during numerical evaluation.

Translation and rotation require appropriate scaling before comparing Jacobian conditioning.

No fixed clinical or engineering accuracy threshold has yet been established.

### 4.5 Sensing Workspace

The sensing workspace is a subset of the geometrically feasible pose space:

\[
W_{\mathrm{sensing}}
\subseteq W_{\mathrm{geo}}
\]

A pose is included only when the selected configuration satisfies specified sensing and physical feasibility requirements.

The full sensing workspace is six-dimensional.

For visualisation, MATLAB may present:

- Three-dimensional position coverage.
- Orientation-dependent sensing quality.
- Two-dimensional slices of the position workspace.
- Pose-estimation error distributions.

Coverage must be computed over a specified sampling domain using declared acceptance criteria.

### 4.6 Mechanical Feasibility

<!-- NEW: Supports the selected motor-assisted tracking architecture. -->

Mechanical feasibility will be investigated separately from ideal geometric identifiability.

The evaluation will include:

- Positive low cable tension.
- Cable slack prevention.
- Cable-to-object and cable-to-cable interference.
- Anchor mounting feasibility.
- Attachment geometry and strength.
- Cable elasticity and friction.
- Motor payout and retrieval capability.
- Forces and torques introduced by the cables.

The purpose is to maintain usable measurements while minimising interference with passive object motion.

Wrench closure is not automatically imposed as a requirement for a passive sensing system.

---

## 5. Simulation and Validation Strategy

### 5.1 Completed Reference-Method Verification

**Status:** Phase A core scope completed.

The following methods have been implemented and investigated using selected reference geometries:

- Cable-length calculations.
- Jacobian verification.
- Wrench-closure feasibility.
- Feasible anchor-region calculations.
- Multi-pose feasible-region intersection.
- Three-dimensional workspace sampling.
- Nonlinear six-degree-of-freedom forward kinematics.
- Local pose covariance estimation.
- Monte Carlo pose-estimation validation.
- NEES statistical consistency evaluation.

The Phase A work establishes reusable computational methods.

It does not validate the final balloon-specific configuration.

### 5.2 Phase B — Balloon-Specific Evaluation

**B1 — Geometry Definition**

- Confirm the gastric engineering boundary.
- Define the 550 mL spherical balloon.
- Calculate the feasible balloon-centre region.
- Define candidate anchor and attachment regions.
- Verify coordinate systems and dimensional consistency.

**B2 — Cable Configuration Generation**

- Generate six-, seven-, and eight-cable candidates.
- Define fixed anchors and body-frame attachments.
- Establish reproducible geometry data.
- Check initial spacing and mounting constraints.

**B3 — Feasibility Screening**

- Sample the defined pose domain.
- Apply geometric containment.
- Evaluate cable-length and routing constraints.
- Investigate cable–balloon and cable–cable interference.
- Evaluate cable-tension feasibility under stated assumptions.
- Quantify sampled workspace coverage.

**B4 — Sensing Quality Evaluation**

- Verify the measurement Jacobian for candidate configurations.
- Evaluate local rank and identifiability.
- Compare scale-aware singular values and conditioning.
- Predict local pose covariance.
- Perform Monte Carlo pose estimation.
- Calculate position and orientation RMSE.
- Record estimation failures and ambiguity.

**B5 — Configuration Selection**

- Compare sensing workspace coverage.
- Compare pose-estimation uncertainty and accuracy.
- Evaluate mechanical and routing complexity.
- Identify configuration trade-offs.
- Select a justified initial cable configuration.

### 5.3 Future Rigid-Body Validation

After configuration selection, the model should be evaluated under more comprehensive conditions:

- Multiple static poses.
- Single-axis and combined 3D motions.
- Irregular passive-motion scenarios.
- Alternative sensor-noise and calibration assumptions.
- Multiple estimator initial guesses.
- Cable-induced force and torque disturbance.
- Independent experimental ground truth, if hardware is available.

### 5.4 Validation Requirements

A new balloon-specific configuration must not be considered verified solely because the reference MATLAB scripts run successfully.

Validation must include:

1. Consistent geometry and coordinate definitions.
2. Verified cable-length calculations.
3. Numerical Jacobian verification.
4. Local identifiability assessment.
5. Explicit feasibility constraints.
6. Pose-estimation accuracy and uncertainty evaluation.
7. Convergence and failure analysis.
8. Documented physical and modelling limitations.

Numerical validation must be distinguished from physical experimental validation.

---

## 6. Current Assumptions and Open Questions

| Parameter | Current Status |
|---|---|
| 550 mL rigid sphere | Defined engineering baseline |
| Simplified gastric boundary | Provisional; B1 review required |
| Coordinate convention | X = Length, Y = Width, Z = Height |
| Geometrically feasible centre region | B1 implementation pending |
| 6-DOF measurement model | Defined |
| Reference Jacobian and FK | Verified in Phase A |
| Balloon-specific Jacobian and FK | Pending |
| Cable number | 6, 7 and 8 candidates |
| Anchor regions | B1 definition pending |
| Attachment regions | B1 definition pending |
| Routing and interference | Not yet evaluated for balloon geometry |
| Measurement noise | Reference simulation tested; physical model pending |
| Low-tension tracking | Proposed; not experimentally validated |
| Balloon deformation sensing | Future extension |

### Current Technical Priority

**B1 — Geometry and Candidate Region Definition**

Immediate tasks:

1. Review and reconcile the available gastric geometry evidence.
2. Confirm coordinate axes and engineering dimensions.
3. Construct the 550 mL rigid sphere.
4. Implement the full sphere-containment model.
5. Define candidate anchor regions.
6. Define candidate attachment regions.
7. Generate a reproducible MATLAB geometry visualisation.

No balloon-specific cable configuration has yet been selected or validated.

---

## Related Documents

- [Current Research State](../CURRENT_STATE2.md)
- [Research Guidelines](../AGENTS2.md)
- [Sensing Objective v0.2](Sensing_Objective_v0.2.md)
- [Research Roadmap](../08_Project_Management/Roadmap.md)
- [Active Research TODO](../08_Project_Management/current_october_november_todo.md)
- [Phase A Research Log](../06_Research_Log/2026-10/)
- [Workspace Boundary v0.2](Workspace_Boundary_v0.2_2026-10-20.md)

---

**Current Research Priority:** Establish and verify the balloon-specific 3D geometry baseline before generating, screening, and comparing six-, seven-, and eight-cable sensing configurations.


**Current Research Priority:** Develop and verify a 3D 6-DOF cable-length measurement model, then determine whether seven or eight cables provide better sensing performance under consistent geometric and mechanical constraints.
