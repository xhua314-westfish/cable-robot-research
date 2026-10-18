# Rigid-Body Cable Sensing Design

**Version:** 0.3  
**Last Updated:** 2026-10-19  
**Research Phase:** 3D Rigid-Body Sensing and Cable Configuration Design  
**Primary Tool:** MATLAB  
**Status:** Proposed 3D model; sensing validation pending

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

The initial environment is represented by a simplified three-dimensional gastric boundary.

**Reference population:** Adult female, prioritising obesity-related anatomical evidence.  
**Geometric representation:** Ellipsoidal approximation.  
**Required dimensions:** Length, width, and height.

The gastric boundary is defined as:

\[
\Omega_g=
\left\{(x,y,z):
\frac{x^2}{a^2}+
\frac{y^2}{b^2}+
\frac{z^2}{c^2}\leq1
\right\}
\]

where:

- \(a=L_g/2\): Half-length.
- \(b=W_g/2\): Half-width.
- \(c=H_g/2\): Half-height.

\(L_g\), \(W_g\), and \(H_g\) represent literature-supported or assumed internal gastric dimensions under specified conditions.

The ellipsoid is centred at the world-frame origin in the initial model.

**Purpose:** Constrain rigid-body movement rather than reproduce detailed gastric anatomy or physiology.

Numerical dimensions remain to be selected and justified.

### 2.2 Rigid Spherical Object

The initial measurement object is a rigid spherical approximation of a commercial intragastric balloon.

| Parameter | Value | Status |
|---|---|---|
| Volume | 550 mL | Commercial reference |
| Shape | Sphere | Engineering assumption |
| Equivalent diameter | Approximately 101.7 mm | Derived |
| Equivalent radius | Approximately 50.9 mm | Derived |
| Deformation | Excluded | Initial model |

The equivalent spherical diameter is:

\[
D=\left(\frac{6V}{\pi}\right)^{1/3}
\]

where \(V\) is expressed in cubic millimetres and \(D\) in millimetres.

The equivalent diameter is not a directly measured external balloon diameter.

### 2.3 Geometric Feasibility

<!-- UPDATED: Clarified the 3D feasible centre region and pose space. -->

The rigid sphere must remain entirely inside the simplified gastric boundary.

Define the feasible sphere-centre region:

\[
W_{\mathrm{centre}}=
\{P\in\mathbb R^3:
B(P,r_s)\subseteq\Omega_g\}
\]

where:

- \(P\): Sphere-centre position.
- \(r_s\): Sphere radius.
- \(B(P,r_s)\): Solid sphere centred at \(P\).
- \(W_{\mathrm{centre}}\): Geometrically feasible centre region.

For the ideal rigid sphere, geometric containment does not depend on orientation.

The complete geometric pose space is:

\[
W_{\mathrm{geo}}
=
W_{\mathrm{centre}}\times SO(3)
\]

This relationship applies to the ideal sphere without considering cables, attachment protrusions, or other mechanical components.

MATLAB will evaluate candidate centre positions and verify that the complete sphere remains inside the boundary.

The geometric workspace must not be determined from the sphere centre alone.

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

## 5. Simulation and Validation

### 5.1 MATLAB Study

<!-- UPDATED: Reorganised simulations around 3D 6-DOF measurement. -->

**A — 3D Geometry Verification**

- Construct the simplified gastric boundary.
- Construct the 550 mL rigid sphere.
- Identify feasible centre positions.
- Define candidate anchor and attachment positions.
- Calculate and visualise cable lengths.

**B — Measurement Model Verification**

- Implement 3D rigid-body transformations.
- Calculate the analytical 6-DOF Jacobian.
- Verify translation and rotation derivatives numerically.
- Investigate rank and conditioning.

**C — 6-DOF Pose Estimation**

- Generate simulated cable-length measurements.
- Estimate unknown position and orientation.
- Investigate multiple initial guesses.
- Identify ambiguous solutions and convergence failures.

**D — Cable Configuration Comparison**

- Compare 6, 7 and 8 cables.
- Investigate anchor placements.
- Investigate attachment placements.
- Compare measurement performance under consistent conditions.

**E — Measurement Uncertainty and Workspace**

- Introduce cable-length noise.
- Calculate position and orientation RMSE.
- Investigate measurement robustness.
- Evaluate sensing workspace coverage.

**F — Physical Feasibility**

- Investigate cable routing and interference.
- Introduce low-tension tracking assumptions.
- Evaluate cable-induced forces and torques.
- Identify practical sensor and motor requirements.

### 5.2 Initial Test Scenarios

| Test | Objective |
|---|---|
| Static reference poses | Verify 6-DOF estimation |
| Single-axis translations | Verify translational response |
| Single-axis rotations | Verify rotational response |
| Combined translations and rotations | Test full pose reconstruction |
| Irregular passive-motion sequences | Evaluate measurement tracking |
| Alternative cable configurations | Compare sensing performance |

Known test trajectories may provide ground truth but must not be supplied to the estimator as known motion.

### 5.3 Validation Criteria

A candidate configuration is considered numerically supported only when:

1. Geometry and cable-length calculations are verified.
2. Analytical and numerical Jacobians agree within a documented tolerance.
3. Local identifiability is evaluated.
4. Global pose ambiguity and estimator convergence are investigated.
5. Position and orientation errors are quantified.
6. Measurement noise and uncertainty are considered.
7. Workspace coverage is evaluated over a defined pose domain.
8. Physical assumptions and limitations are recorded.

Numerical simulation does not replace experimental validation using calibrated measurements and independent ground truth.

---

## 6. Current Assumptions and Open Questions

<!-- UPDATED: Removed the outdated planar measurement scope. -->

| Parameter | Current Status |
|---|---|
| 550 mL rigid sphere | Defined approximation |
| Simplified 3D gastric boundary | Proposed |
| Gastric length, width, height | Evidence pending |
| Initial state | Full 3D 6-DOF pose |
| Cable number | 6 baseline; 7 and 8 primary |
| Anchor and attachment locations | To be investigated |
| Cable-length noise and calibration | To be defined |
| Low-tension tracking | Proposed, not validated |
| Cable interference and physical feasibility | Not validated |
| 6-DOF pose-estimation accuracy | Not evaluated |
| Balloon deformation sensing | Future extension |

### Immediate Technical Priority

1. Establish a simplified 3D gastric geometric boundary.
2. Define the feasible rigid-sphere centre region.
3. Implement the 3D cable-length model.
4. Verify the 6-DOF measurement Jacobian.
5. Begin the six-, seven- and eight-cable comparison.

---

## Related Documents

- [Current Research State](../CURRENT_STATE2.md)
- [Sensing Objective v0.2](Sensing_Objective_v0.2.md)
- [Research Guidelines](../AGENTS2.md)
- [Research Roadmap](../08_Project_Management/Roadmap.md)
- [Research TODO](../08_Project_Management/TODO.md)
- [Weekly Plan](../08_Project_Management/WEEKLY_PLAN.md)

---

**Current Research Priority:** Develop and verify a 3D 6-DOF cable-length measurement model, then determine whether seven or eight cables provide better sensing performance under consistent geometric and mechanical constraints.
