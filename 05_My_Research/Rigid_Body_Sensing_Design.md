# Rigid-Body Cable Sensing Design

**Version:** 0.4  
**Original Definition:** 2026-10-19  
**Last Updated:** 2026-11-02  
**Research Phase:** Phase B — Balloon-Specific Cable Sensing Design  
**Current Focus:** Six-Cable Workspace Validation and Optimisation  
**Current Task:** B3.1 — Multi-Position Geometric Feasibility  
**Primary Tool:** MATLAB

**Document Purpose:** Define the engineering geometry, cable measurement model, feasibility constraints, sensing metrics, and optimisation framework for rigid-body balloon pose sensing.

Research progress is maintained in [CURRENT_STATE2.md](../CURRENT_STATE2.md). Active tasks are maintained in [current_october_november_todo.md](../08_Project_Management/current_october_november_todo.md) and [weekly_plan_03.md](../08_Project_Management/weekly_plan_03.md).

---

## 1. Research Objective

### 1.1 Long-Term Objective

Develop a cable-based sensing system capable of estimating the position, orientation, and eventually deformation of a passively moving balloon-like object.

The application is motivated by intragastric balloon monitoring within a simplified gastric environment.

The system is intended for **measurement and state estimation**, not prescribed motion control.

### 1.2 Current Technical Objective

Design and evaluate a six-cable measurement system capable of estimating the full six-degree-of-freedom pose of a rigid spherical balloon.

**Main Research Question:**

> How should six cable anchor–attachment pairs be selected to provide accurate, feasible, and robust 6-DOF pose sensing across the required balloon workspace?

The initial design must consider:

1. Geometric feasibility.
2. Cable interference.
3. Local pose identifiability.
4. Measurement sensitivity.
5. Pose-estimation uncertainty.
6. Configuration optimisation.

### 1.3 Research Sequence

The research follows:

**Geometry → Configuration → Feasibility → Sensing Quality → Optimisation → Validation**

The current study focuses on six cables.

Seven- and eight-cable systems will be investigated after establishing a numerically justified six-cable reference configuration.

The reference configuration does not need to be globally optimal before extension, but its performance and limitations must be documented.

---

## 2. Simplified Physical and Geometric Model

### 2.1 Engineering Boundary

The engineering boundary is an axis-aligned cuboid centred at the world-frame origin.

Following supervisor feedback, the initial dimensions are:

| Axis | Parameter | Value |
|---|---|---:|
| X — Length | Lg | 280 mm |
| Y — Width | Wg | 300 mm |
| Z — Height | Hg | 320 mm |

The engineering envelope is:

\[
\Omega_g=
\left\{
P\in\mathbb R^3:
|P_x|\leq140,\quad
|P_y|\leq150,\quad
|P_z|\leq160
\right\}
\]

All coordinates use millimetres.

**Interpretation:**

The selected boundary is a simplified engineering assumption.

It is not a clinically validated patient-specific gastric lumen or physiological balloon-motion envelope.

The boundary must not be described as an experimentally established gastric workspace.

### 2.2 Rigid Spherical Balloon

The initial balloon has a selected volume of:

\[
V_b=550\ \mathrm{mL}
=550000\ \mathrm{mm^3}
\]

The equivalent sphere radius is:

\[
r_b=
\left(
\frac{3V_b}{4\pi}
\right)^{1/3}
\]

Therefore:

\[
r_b\approx50.83\ \mathrm{mm}
\]

\[
D_b=2r_b\approx101.65\ \mathrm{mm}
\]

The initial model assumes:

- Rigid spherical geometry.
- Constant volume.
- No deformation.
- Passive motion.
- Fixed attachment coordinates relative to the balloon.
- Ideal straight and taut cables.

The rigid sphere is an engineering proxy rather than a complete physical model of a deformable intragastric balloon.

### 2.3 Geometrically Feasible Balloon-Centre Region

The entire sphere must remain inside the engineering boundary.

With nonnegative clearance \(c\), full containment requires:

\[
|P_x|\leq\frac{L_g}{2}-r_b-c
\]

\[
|P_y|\leq\frac{W_g}{2}-r_b-c
\]

\[
|P_z|\leq\frac{H_g}{2}-r_b-c
\]

The initial study adopts:

\[
c=0\ \mathrm{mm}
\]

This is a geometrical modelling assumption, not a clinically established safety clearance.

The resulting centre limits are:

| Axis | Feasible Centre Range |
|---|---|
| X | ±89.17 mm |
| Y | ±99.17 mm |
| Z | ±109.17 mm |

Thus:

\[
\Omega_{\mathrm{centre}}=
[-89.17,89.17]\times
[-99.17,99.17]\times
[-109.17,109.17]
\]

This defines a three-dimensional centre-position domain.

The full rigid-body pose space is six-dimensional because orientation must also be considered.

For an ideal sphere, containment is independent of orientation. However, cable lengths, interference, and sensing performance depend on orientation.

### 2.4 Initial Geometry Verification

The B1 MATLAB implementation generated:

| Metric | Verified Result |
|---|---:|
| Total sampled centre positions | 29,667 |
| Geometrically feasible positions | 6,783 |
| Infeasible positions | 22,884 |

The sampling interval was 10 mm.

These values describe the selected discretisation, not the exact continuous workspace volume.

---

## 3. Coordinate Frames and Cable Geometry

### 3.1 World and Body Frames

The world frame is fixed relative to the engineering boundary.

The balloon body frame moves with the balloon.

Define:

\[
P=
\begin{bmatrix}
P_x\\P_y\\P_z
\end{bmatrix}
\]

as the balloon-centre position in the world frame.

Define:

\[
R\in SO(3)
\]

as the rotation matrix from body coordinates to world coordinates.

The rigid-body pose is represented by:

\[
q=(P,R)
\]

Euler angles may be used for visualisation and reporting.

The core model should use rotation matrices or a suitable local rotation representation.

### 3.2 Anchor Points

For cable \(i\):

\[
A_i\in\mathbb R^3
\]

is a fixed world-frame anchor point.

The initial candidate region consists of the six faces of the engineering boundary:

\[
\Omega_A=
\bigcup_{k=1}^{6}\Omega_{A,k}
\]

The first coarse sampling generated 26 unique candidate locations.

The six faces are continuous candidate regions. The 26 points are only an initial discrete approximation.

**Physical limitation:**

Using the engineering boundary as an ideal anchor-mounting reference does not establish that cables can be installed or routed through a real gastric wall.

### 3.3 Attachment Points

For cable \(i\):

\[
r_i\in\mathbb R^3
\]

is the attachment coordinate in the balloon body frame.

The initial attachment region is the sphere surface:

\[
\Omega_B=
\{r\in\mathbb R^3:\|r\|=r_b\}
\]

The first coarse spherical sampling generated 40 unique attachment candidates.

The local attachment coordinates remain fixed during rigid-body motion.

### 3.4 World-Frame Attachment Position

The attachment position in the world frame is:

\[
\boxed{B_i=P+Rr_i}
\]

Define:

\[
s_i=Rr_i
\]

so that:

\[
B_i=P+s_i
\]

### 3.5 Cable Vector and Length

Use the following convention throughout the sensing model:

\[
\boxed{d_i=A_i-B_i}
\]

The ideal cable length is:

\[
\boxed{L_i=\|d_i\|}
\]

The unit cable direction from attachment to anchor is:

\[
\boxed{u_i=\frac{d_i}{L_i}}
\]

This convention must remain consistent in the MATLAB code.

Paper 3's unnormalised wrench representation uses a different cable-vector convention in the reproduced example. Its equations must not be mixed with the measurement Jacobian without checking signs and definitions.

### 3.6 Complete Cable Configuration

For \(n\) cables, define:

\[
\mathcal C_n=
\{(A_i,r_i)\}_{i=1}^{n}
\]

For the current six-cable system:

\[
\mathcal C_6=
\{(A_i,r_i)\}_{i=1}^{6}
\]

The correspondence between anchors and attachments is part of the design.

Changing the pairing can alter the measurement Jacobian even if the selected point sets remain unchanged.

---

## 4. Cable-Length Measurement Model

### 4.1 Ideal Measurement Model

For \(n\) cables:

\[
L=h(P,R;\mathcal C_n)
\]

where:

\[
h_i(P,R)=
\|A_i-(P+Rr_i)\|
\]

The function \(h\) maps the rigid-body pose to ideal cable lengths.

### 4.2 Sensor Measurement Model

The measured cable-length vector is:

\[
\boxed{y=h(P,R;\mathcal C_n)+\varepsilon}
\]

where:

- \(y\in\mathbb R^n\): measured cable lengths.
- \(h(P,R)\in\mathbb R^n\): predicted lengths.
- \(\varepsilon\in\mathbb R^n\): measurement error.

The initial model assumes ideal straight, taut, inextensible cables.

The following are not yet included:

- Cable elasticity.
- Cable sagging.
- Pulley and spool geometry.
- Encoder calibration offsets.
- Friction.
- Cable wrapping.
- Attachment deformation.
- Variable cable tension effects.

These effects must be considered when moving toward hardware validation.

---

## 5. Geometric Feasibility and Interference

### 5.1 Purpose

Geometric feasibility must be evaluated before treating a configuration as an admissible sensing arrangement.

A full-rank Jacobian is insufficient if a cable physically passes through the balloon.

The initial feasibility analysis includes:

1. Sphere containment.
2. Positive cable lengths.
3. Cable–sphere interference.
4. Cable–cable interference.
5. Future routing and hardware constraints.

### 5.2 Cable–Sphere Interference

For cable \(i\), define the ideal straight segment:

\[
C_i(t)=B_i+t(A_i-B_i)
\]

with:

\[
0\leq t\leq1
\]

The attachment point \(B_i\) lies on the sphere surface:

\[
\|B_i-P\|=r_b
\]

Define:

\[
s_i=B_i-P
\]

and:

\[
d_i=A_i-B_i
\]

The squared distance from a point on the cable to the sphere centre is:

\[
\|C_i(t)-P\|^2
=
r_b^2+2t(s_i^Td_i)+t^2\|d_i\|^2
\]

For an ideal straight cable beginning exactly on the spherical surface, a nonzero cable segment does not enter the sphere interior when:

\[
\boxed{s_i^Td_i\geq0}
\]

If:

\[
s_i^Td_i<0
\]

the cable initially enters the sphere interior.

This provides a simple and computationally efficient interference test.

**Important limitations:**

- This condition is exact for the ideal sphere and centreline segment under the stated assumptions.
- It does not model physical cable thickness.
- It does not validate attachment hardware clearance.
- A tangent cable has zero first-order clearance at the attachment.
- It does not establish feasibility of real routing through the surrounding environment.

The MATLAB implementation should independently verify this criterion using point-to-segment or segment-to-sphere geometry.

### 5.3 Cable–Cable Interference

Each cable is represented as a finite three-dimensional line segment.

For cables \(i\) and \(j\):

\[
C_i(t)=B_i+t(A_i-B_i)
\]

\[
C_j(v)=B_j+v(A_j-B_j)
\]

where:

\[
t,v\in[0,1]
\]

Define the minimum centreline distance:

\[
\boxed{
d_{ij}^{\min}=
\min_{t,v\in[0,1]}
\|C_i(t)-C_j(v)\|
}
\]

For six cables, the number of distinct cable pairs is:

\[
\binom{6}{2}=15
\]

The initial MATLAB implementation must evaluate all 15 pairs at every sampled pose.

### 5.4 Physical Cable Clearance

If the two cables have physical radii \(a_i,a_j\), a simplified non-contact condition is:

\[
d_{ij}^{\min}>a_i+a_j
\]

If an additional safety clearance \(c_{ij}\) is imposed:

\[
d_{ij}^{\min}\geq
a_i+a_j+c_{ij}
\]

The actual cable diameters and required clearance have not yet been selected.

Therefore, initial simulations should report raw centreline distances and exact intersections.

Any assumed finite clearance must be labelled as an engineering sensitivity scenario.

### 5.5 Numerical Verification of Segment Distance

The segment-distance function must be tested using known geometric cases:

1. Intersecting segments.
2. Parallel separated segments.
3. Skew segments.
4. Endpoint-to-segment nearest distances.
5. Nearly parallel segments.
6. Degenerate or nearly zero-length segments.

The implementation must constrain both segment parameters to:

\[
[0,1]
\]

Infinite-line distance alone is insufficient for finite cable-segment interference.

### 5.6 Cable-Length Constraints

At minimum, all cables must satisfy:

\[
L_i>0
\]

When hardware parameters are available, additional bounds may be imposed:

\[
L_{i,\min}\leq L_i\leq L_{i,\max}
\]

At present, physical cable payout limits have not been established.

Do not introduce hardware-validated length limits without evidence.

### 5.7 Mechanical Tension Feasibility

The proposed system uses motors to maintain modest positive cable tension while following passive balloon motion.

Mechanical feasibility must be distinguished from geometric identifiability.

Possible future constraints include:

- Tension positivity.
- Tension upper and lower bounds.
- Cable slack.
- Cable-induced forces and torques.
- Motor tracking performance.
- Disturbance of balloon motion.

Wrench closure is not automatically imposed as a mandatory sensing criterion.

In particular, the seven-cable strict positive self-stress method reproduced from Paper 3 must not be directly transferred to a six-cable measurement Jacobian.

---

## 6. Six-DOF Measurement Jacobian

### 6.1 Local Pose Perturbation

Consider a small world-frame translation:

\[
\delta P
\]

and a small world-frame rotation vector:

\[
\delta\alpha
\]

The local pose increment is:

\[
\delta q=
\begin{bmatrix}
\delta P\\
\delta\alpha
\end{bmatrix}
\]

The rotation perturbation is expressed in radians.

### 6.2 Jacobian Derivation

Recall:

\[
L_i=\|A_i-(P+Rr_i)\|
\]

Using:

\[
u_i=\frac{A_i-B_i}{L_i}
\]

and:

\[
s_i=Rr_i
\]

the first-order cable-length change is:

\[
\delta L_i
\approx
-u_i^T\delta P
+
(u_i\times s_i)^T\delta\alpha
\]

Therefore:

\[
\boxed{
H_i=
\begin{bmatrix}
-u_i^T&(u_i\times s_i)^T
\end{bmatrix}
}
\]

For six cables:

\[
\boxed{H\in\mathbb R^{6\times6}}
\]

The local measurement relationship is:

\[
\delta L\approx H\delta q
\]

### 6.3 Local Identifiability

For local six-degree-of-freedom pose reconstruction:

\[
\boxed{\operatorname{rank}(H)=6}
\]

This means the first-order measurement model has six independent pose directions.

However, full rank does not guarantee:

- Globally unique forward kinematics.
- Low measurement uncertainty.
- Numerical robustness.
- Collision-free cables.
- Mechanical tension feasibility.
- Accurate hardware measurements.

### 6.4 Numerical Jacobian Verification

The analytical Jacobian must be compared against finite-difference derivatives.

For translation:

\[
\frac{\partial L}{\partial P_j}
\approx
\frac{L(P+\epsilon e_j,R)-L(P-\epsilon e_j,R)}
{2\epsilon}
\]

For world-frame rotation perturbations, use:

\[
R_+=\exp([\epsilon e_j]_\times)R
\]

\[
R_-=\exp(-[\epsilon e_j]_\times)R
\]

Then calculate the central difference.

The same world-frame rotation convention must be used in the analytical and numerical calculations.

### 6.5 Characteristic-Length Scaling

Translation is measured in millimetres.

Rotation is measured in radians.

To compare translational and rotational sensitivity, define the characteristic length:

\[
l_c=r_b
\]

The scaled Jacobian is:

\[
\boxed{
H_s=H
\operatorname{diag}
\left(
1,1,1,\frac1{l_c},\frac1{l_c},\frac1{l_c}
\right)
}
\]

This corresponds to expressing rotational pose increments as characteristic surface displacements.

The chosen characteristic length must remain fixed across compared configurations.

Different characteristic lengths can change the condition number and singular values.

### 6.6 Singular Values and Condition Number

For the scaled measurement Jacobian:

\[
H_s=U\Sigma V^T
\]

Define:

\[
\sigma_{\min}=\min_i\sigma_i
\]

and:

\[
\boxed{
\kappa(H_s)=
\frac{\sigma_{\max}}{\sigma_{\min}}
}
\]

when the Jacobian has full rank.

Interpretation:

- Small minimum singular value: weak local sensitivity in at least one normalised pose direction.
- Large condition number: unequal measurement sensitivity between pose directions.
- Rank deficiency: at least one locally unobservable first-order pose direction.

A smaller condition number does not necessarily imply a larger minimum singular value.

Neither metric directly equals pose RMSE.

---

## 7. Pose Estimation and Measurement Accuracy

### 7.1 Forward Kinematics

The goal is to estimate the balloon pose from cable-length measurements.

Define:

\[
(\hat P,\hat R)=
\arg\min_{P,R}
\left[
y-h(P,R)
\right]^T
\Sigma_L^{-1}
\left[
y-h(P,R)
\right]
\]

where:

\[
\Sigma_L
\]

is the cable-length measurement covariance matrix.

For independent, equal-variance noise, ordinary least squares may be used.

The nonlinear estimator must be tested with different initial guesses.

The true pose must not be supplied as a known solution during the estimation procedure.

### 7.2 Local Pose Covariance

For:

\[
\delta y\approx H\delta q+\varepsilon
\]

with:

\[
\operatorname{Cov}(\varepsilon)=\Sigma_L
\]

the local pose covariance may be approximated by:

\[
\boxed{
\Sigma_q\approx
(H^T\Sigma_L^{-1}H)^{-1}
}
\]

provided:

- The measurement model is locally valid.
- The Jacobian has full column rank.
- The measurement covariance model is appropriate.
- Relevant model errors are negligible or separately represented.

For numerically robust implementation, avoid explicitly inverting poorly conditioned matrices without checking rank and conditioning.

### 7.3 Measurement Noise

The initial simulation uses:

\[
\varepsilon_i\sim\mathcal N(0,\sigma_L^2)
\]

with the illustrative assumption:

\[
\sigma_L=1\ \mathrm{mm}
\]

This follows the previous Phase A test setup.

It is not an experimentally calibrated sensor specification.

Future sensitivity studies should compare multiple noise levels and non-identical cable uncertainties.

### 7.4 Position Error

For true position \(P\) and estimated position \(\hat P\):

\[
e_P=\|\hat P-P\|
\]

For \(N\) successful estimates:

\[
\mathrm{RMSE}_{P}=
\sqrt{
\frac1N
\sum_{k=1}^{N}
\|\hat P_k-P_k\|^2
}
\]

Report position errors in millimetres.

Estimator failures must be reported separately rather than silently excluded.

### 7.5 Orientation Error

For true orientation \(R\) and estimated orientation \(\hat R\), define:

\[
e_R=
\cos^{-1}
\left(
\frac{\operatorname{tr}(\hat R^TR)-1}{2}
\right)
\]

The inverse-cosine argument must be clamped to the valid numerical interval \([-1,1]\).

Orientation errors may be reported in degrees.

The orientation RMSE is calculated from squared orientation-angle errors over the evaluated samples.

### 7.6 Estimator Reliability

In addition to RMSE, report:

- Convergence rate.
- Iteration count.
- Residual measurement error.
- Failed convergence.
- Sensitivity to initialisation.
- Potentially ambiguous pose solutions.

These results are important because a locally full-rank Jacobian does not guarantee a globally unique or reliably convergent solution.

---

## 8. Geometric and Sensor-Error Sensitivity

### 8.1 Main Error Sources

Potential uncertainties include:

| Error Source | Parameter |
|---|---|
| Anchor installation error | \(\delta A_i\) |
| Attachment placement error | \(\delta r_i\) |
| Cable-length noise | \(\varepsilon_i\) |
| Cable-length offset | \(b_i\) |
| Balloon radius uncertainty | \(\delta r_b\) |
| Cable elasticity | Model-dependent |
| Pulley and encoder errors | Model-dependent |

### 8.2 Anchor and Attachment Sensitivity

Cable length depends on:

\[
L_i=
\|A_i-(P+Rr_i)\|
\]

The first-order change due to coordinate errors is:

\[
\delta L_i
\approx
u_i^T\delta A_i
-
u_i^TR\delta r_i
\]

This relation can be used to understand how geometric calibration errors affect predicted cable lengths.

The resulting pose bias or uncertainty must then be evaluated through the pose-estimation model.

### 8.3 Proposed Sensitivity Experiment

For a selected configuration:

1. Define a reference geometry.
2. Introduce controlled anchor-coordinate perturbations.
3. Introduce controlled attachment-coordinate perturbations.
4. Generate measurements using the perturbed physical geometry.
5. Estimate pose using the assumed calibrated model.
6. Calculate position and orientation errors.
7. Repeat across multiple feasible poses.

This tests the effect of geometric model mismatch.

It should be distinguished from adding independent random cable-length measurement noise.

### 8.4 Literature Application

Use the geometric calibration and error-compensation literature to identify error sources and suitable sensitivity tests.

The methods must be adapted to the six-degree-of-freedom sensing model.

Neural-network error compensation is not required during the current initial study.

---

## 9. Workspace-Level Evaluation

### 9.1 Full Pose Domain

Define the tested pose domain as:

\[
Q_{\mathrm{test}}=
\{(P_k,R_k)\}_{k=1}^{N}
\]

The test set represents selected positions and orientations.

It does not assume that the passive balloon follows a prescribed trajectory.

### 9.2 Initial Position Samples

The first B3.1 study uses:

\[
P_x,P_y,P_z\in\{-50,0,50\}\ \mathrm{mm}
\]

Total:

\[
N_P=27
\]

Initial orientation:

\[
R=I
\]

### 9.3 Initial Orientation Samples

The B3.2 study uses seven orientation cases:

- Zero rotation.
- Roll +10° and −10°.
- Pitch +10° and −10°.
- Yaw +10° and −10°.

Therefore:

\[
N_Q=27\times7=189
\]

These are engineering test values rather than clinically validated rotation limits.

### 9.4 Feasibility Masks

For each pose, store separate results for:

- Sphere containment.
- Cable-length validity.
- Cable–sphere interference.
- Cable–cable interference.
- Local Jacobian rank.
- Sensing conditioning.

Do not combine these categories without documenting the exact criteria.

### 9.5 Workspace Coverage

For a declared sample set:

\[
\mathrm{Coverage}=
\frac{N_{\mathrm{accepted}}}
{N_{\mathrm{tested}}}
\]

The acceptance criteria must be explicitly defined.

Coverage calculated from finite samples is a discrete approximation.

It is not proof of continuous workspace feasibility.

### 9.6 Independent Validation Poses

Optimisation poses and final validation poses must be separated.

The selected configuration should be tested at additional positions and orientations that were not used to improve its coordinates.

If the validation results are used to redesign the configuration, a new independent validation set is required.

---

## 10. Configuration Optimisation Framework

### 10.1 Design Variables

For six cables:

\[
\mathcal C_6=
\{(A_i,r_i)\}_{i=1}^{6}
\]

Design variables may include:

- Anchor coordinates.
- Attachment coordinates.
- Anchor–attachment correspondence.

Initially, optimisation can use the 26 and 40 discrete candidate sets.

Later, local refinement may use the continuous six-face anchor region and spherical attachment surface.

### 10.2 Initial Design Constraints

A candidate configuration should satisfy explicitly selected constraints, including:

1. Anchor-region membership.
2. Attachment-surface membership.
3. Unique or sufficiently separated connection points.
4. Positive cable lengths.
5. Required cable–sphere clearance.
6. Required cable–cable clearance.
7. Local Jacobian full-rank conditions across the declared pose set.
8. Future hardware routing and tension requirements.

If physical cable diameter or clearance remains unknown, treat those requirements as parameterised sensitivity studies rather than validated fixed limits.

### 10.3 Optimisation Objectives

Possible objectives include:

**Objective A — Improve weakest sensing direction**

\[
\max_{\mathcal C_6}
\min_{q\in Q_{\mathrm{train}}}
\sigma_{\min}(H_s(q,\mathcal C_6))
\]

**Objective B — Improve worst-case conditioning**

\[
\min_{\mathcal C_6}
\max_{q\in Q_{\mathrm{train}}}
\kappa(H_s(q,\mathcal C_6))
\]

**Objective C — Reduce predicted uncertainty**

For example:

\[
\min_{\mathcal C_6}
\max_{q\in Q_{\mathrm{train}}}
\operatorname{tr}
\left(
W\Sigma_q(q,\mathcal C_6)
\right)
\]

where \(W\) is a declared nonnegative weighting matrix used to normalise or prioritise pose components.

The uncertainty objective requires full-rank measurement geometry and an explicitly defined noise model.

### 10.4 Feasibility Before Optimisation

The optimisation method must avoid rewarding physically invalid configurations.

A practical strategy is:

1. Generate a candidate.
2. Evaluate geometric constraints.
3. Reject invalid candidates.
4. Evaluate local sensing rank.
5. Evaluate sensing-quality metrics.
6. Retain admissible candidates.
7. Compare objective values.

The criteria should remain consistent across all compared configurations.

### 10.5 Search Methods

Potential methods include:

- Constraint-aware random search.
- Local candidate refinement.
- Multistart continuous optimisation.
- Genetic algorithms.
- Multi-objective evolutionary algorithms such as NSGA-II.
- Surrogate-assisted optimisation when evaluations become expensive.

The initial priority is to establish a correct and reproducible evaluation function.

A more complicated optimiser is not automatically a better research result.

### 10.6 Multi-Objective Trade-Offs

Optimisation may involve conflicting objectives:

- High sensing sensitivity.
- Large feasible workspace.
- Low pose uncertainty.
- Simple routing and mounting.
- Low physical interference.

A Pareto-based analysis may be useful.

However, the number of objectives should remain manageable, and their definitions must be justified.

### 10.7 Meaning of Optimality

The current random-search results identify the best configurations found among the sampled candidates.

They do not establish global optimality.

Future claims must distinguish:

- Best sampled configuration.
- Locally optimised configuration.
- Best validated candidate.
- Proven global optimum, if ever established.

---

## 11. Existing Six-Cable Reference Candidates

Three configurations have been investigated at the initial pose.

| Metric | Initial Baseline | Experiment A | Experiment B |
|---|---:|---:|---:|
| Number of cables | 6 | 6 | 6 |
| Jacobian rank | 6 | 6 | 6 |
| Scaled minimum singular value | 0.004393 | 0.535345 | 0.533600 |
| Scaled condition number | 490.956 | 3.5759 | 3.2365 |

Experiment A holds six face-centre anchor locations fixed and changes the attachment selection.

Experiment B varies both anchor and attachment selection.

**Current interpretation:**

- Experiment A substantially improved local conditioning.
- Experiment B provided a further modest improvement in the observed condition number.
- The minimum singular value did not improve from A to B.
- Neither configuration has been validated across the full target pose set.

The selected six-cable configuration remains undecided.

Detailed numerical evidence and final coordinate datasets should be stored in the Research Log and MATLAB data files.

---

## 12. Research Method Selection

The following literature methods are relevant to the current design.

| Method | Source Category | Intended Use |
|---|---|---|
| Pointwise workspace sampling | Paper 1 | Multi-pose feasibility |
| Configuration constraints and optimisation | Paper 2 | Six-cable placement improvement |
| WCC feasible anchor regions | Paper 3 | Future seven-cable mechanical analysis |
| Forward kinematics and pose covariance | Paper 4 | Measurement accuracy |
| Cable–cable distance analysis | New interference literature | B3 |
| Geometric calibration and error analysis | New sensitivity literature | B4 |
| Multi-objective configuration optimisation | New optimisation literature | B5 |

The full literature classification is maintained separately in `02_Paper_Reading/Literature_Review/Phase_B_Method_Selection_2026-11-02.md` when available in the repository.

Do not duplicate full literature reviews in this technical model file.

### Main Research Principle

**Use published methods when they address the current research question.**

Do not directly apply active robot wrench-feasibility conditions as substitutes for passive sensing accuracy.

---

## 13. Phase B Simulation and Validation Sequence

### B1 — Geometry Definition

**Status:** Completed.

Established:

- Engineering boundary.
- Rigid spherical balloon.
- Geometrically feasible centre region.
- Anchor candidate regions.
- Attachment candidate regions.
- Integrated MATLAB geometry.

### B2 — Initial Configuration Comparison

**Status:** Completed for single-pose exploratory comparison.

Established:

- Six-cable baseline.
- Experiment A.
- Experiment B.
- Initial Jacobian conditioning comparisons.

The final six-cable configuration has not been selected.

### B3 — Geometric Feasibility

**Current priority.**

Evaluate:

- Multi-position geometry.
- Multi-pose geometry.
- Cable–sphere interference.
- Cable–cable interference.
- Explicit geometric feasibility coverage.

### B4 — Sensing Quality and Accuracy

Evaluate:

- Measurement Jacobian rank.
- Scaled singular values.
- Condition number.
- Local pose covariance.
- Forward kinematics.
- Monte Carlo estimation errors.
- Noise and calibration sensitivity.

### B5 — Configuration Optimisation and Selection

Evaluate and improve:

- Workspace-level sensing performance.
- Geometric feasibility.
- Pose-estimation uncertainty.
- Configuration robustness.
- Physical implementation complexity.

Select a six-cable reference configuration only after sufficient numerical verification.

---

## 14. Future Seven- and Eight-Cable Extension

### 14.1 Seven-Cable Design

After selecting a six-cable reference:

- Introduce a seventh cable.
- Evaluate geometric routing.
- Evaluate sensing redundancy.
- Evaluate uncertainty changes.
- Investigate applicable mechanical tension conditions.
- Use Paper 3 Algorithm 1 and Algorithm 2 when their assumptions are relevant.

If the additional cable cannot achieve the required design objectives, joint re-optimisation of all seven cables may be necessary.

### 14.2 Eight-Cable Design

Extend the measurement Jacobian to:

\[
H\in\mathbb R^{8\times6}
\]

Evaluate:

- Rank and singular values.
- Measurement information and covariance.
- Robustness to selected cable measurement failures.
- Geometric and mechanical complexity.
- Workspace coverage.

Additional independent cable measurements can increase local Fisher information under fixed geometry and suitable independent noise assumptions.

However, changing the physical layout, adding interference, or introducing new model errors may offset these benefits.

Additional cable count does not automatically guarantee better overall sensing performance.

---

## 15. Validation and Acceptance Requirements

A six-cable reference configuration should be selected only after completing the relevant checks.

### Geometry

- [ ] All selected coordinates are reproducible.
- [ ] Anchor–attachment correspondence is defined.
- [ ] Sphere containment is verified.
- [ ] Cable–sphere interference is evaluated.
- [ ] Cable–cable interference is evaluated.
- [ ] Hardware assumptions and unresolved constraints are stated.

### Sensing

- [ ] The measurement Jacobian is verified numerically.
- [ ] Local rank is evaluated across sampled poses.
- [ ] Scaled singular values are calculated.
- [ ] Weak sensing directions are identified.
- [ ] Local pose uncertainty is predicted.

### Pose Estimation

- [ ] Forward kinematics is verified at multiple poses.
- [ ] Position RMSE is reported.
- [ ] Orientation RMSE is reported.
- [ ] Estimator convergence and failures are recorded.
- [ ] Noise and calibration assumptions are explicit.

### Optimisation

- [ ] Objective functions and constraints are documented.
- [ ] Existing reference configurations are included in comparisons.
- [ ] Training and validation poses are separated.
- [ ] Selected candidate performance is reproduced.
- [ ] Global-optimality claims are avoided unless supported.

### Research Interpretation

- [ ] Simulation results are distinguished from physical experiments.
- [ ] Limitations are recorded.
- [ ] Configuration trade-offs are justified.
- [ ] Remaining research questions are identified.

---

## 16. Current Technical Priority

**B3.1 — Six-Cable Multi-Position Geometric Feasibility**

The next numerical experiment should:

1. Load the existing Experiment A and B configurations.
2. Generate the 27-position test set.
3. Recalculate attachment positions and cable lengths.
4. Verify sphere containment.
5. Evaluate cable–sphere interference.
6. Calculate minimum distances between cable segments.
7. Record geometric feasibility and failure cases.
8. Compare the two configurations under identical conditions.

**Important:**

Do not change anchor or attachment coordinates during the initial B3.1 evaluation.

The purpose is to identify limitations of the current configurations before conducting workspace-level optimisation.

---

## Related Documents

### Research State and Planning

- [Current Research State](../CURRENT_STATE2.md)
- [Research Guidelines](../AGENTS2.md)
- [Active Research TODO](../08_Project_Management/current_october_november_todo.md)
- [Weekly Plan 03](../08_Project_Management/weekly_plan_03.md)
- [Research Roadmap](../08_Project_Management/Roadmap.md)

### Research Definition

- [Sensing Objective v0.2](Sensing_Objective_v0.2.md)
- [Workspace Boundary v0.2](Workspace_Boundary_v0.2_2026-10-20.md)

### Code and Research Evidence

- [MATLAB Code](../04_Code_Exercises/MATLAB/)
- [October Research Log](../06_Research_Log/2026-10/)
- `06_Research_Log/2026-11/` — current Phase B experiment results.

---

**Current Research Goal:** Establish a reproducible six-cable reference configuration with quantified geometric feasibility, sensing sensitivity and pose-estimation accuracy.

**Guiding Principle:** Select the configuration based on verified sensing performance and physical constraints, rather than single-pose conditioning alone.
