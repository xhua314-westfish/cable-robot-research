# Rigid-Body Cable Sensing — Research Design v0.1

**Last updated:** 2026-10-16  
**Research phase:** Phase 2 — Sensing Objective and Rigid-Body Model  
**Status:** Initial research design; simulation and experimental validation pending  
**Primary tool:** MATLAB

---

# 1. Research Background

The long-term research aims to develop a cable-based sensing system for estimating the position, orientation, and deformation or shape of a passively moving balloon-like object.

Clinical evidence has provided preliminary balloon size references and identified important uncertainties, including normal motion range and deformation boundaries.

However, a complete natural gastric balloon motion model is not currently available.

The immediate research will therefore use a simplified rigid body and repeatable motion scenarios to establish and validate the cable measurement principle.

**Current research focus:**

- Cable number
- Anchor-point arrangement
- Attachment-point arrangement
- Measurement sensitivity
- State estimation
- Measurement accuracy
- Sensing workspace

---

# 2. Research Questions

## RQ1 — Sensing Objective

What rigid-body state variables should the initial cable sensing system estimate?

Candidate models:

**Position-only model:**

\[
q=[x,y]^T
\]

**Planar pose model:**

\[
q=[x,y,\theta]^T
\]

The initial measurement objective must be selected before finalising the cable configuration.

## RQ2 — Cable Number

What is the minimum number of cables that provides sufficient independent measurement information for the selected state model?

Theoretical measurement count is only a necessary starting point, not proof of global uniqueness or achievable accuracy.

## RQ3 — Cable Geometry

How do anchor-point and attachment-point locations affect measurement quality?

Investigate:

- Jacobian rank
- Singular values
- Condition number
- Measurement sensitivity
- Redundancy
- Sensing workspace coverage

## RQ4 — Measurement Validation

Can the unknown rigid-body state be estimated from measured cable lengths without using its prescribed motion trajectory as an estimator input?

Evaluation should include state-estimation error and noise sensitivity.

---

# 3. Initial Research Scope

## Included in v0.1

- Planar rigid-body geometry
- Existing four-cable reference model
- Forward cable-length calculation
- Measurement Jacobian
- Local identifiability analysis
- Static state-estimation tests
- Simple linear motion scenarios
- Initial candidate configuration comparisons

## Excluded from v0.1

- Full gastric balloon dynamics
- Complex gastric motion trajectories
- Deformable-body mechanics
- Balloon shape reconstruction
- Final motor and hardware selection
- Final three-dimensional workspace specification

These topics remain part of later research phases.

---

# 4. Reference Rigid-Body Model

## 4.1 Coordinate Systems

Define:

- World frame: \(\{W\}\)
- Body frame: \(\{B\}\)
- Rigid-body reference position: \(P=[x,y]^T\)
- Body orientation: \(\theta\)

The planar rigid-body state is:

\[
q=
\begin{bmatrix}
x\\y\\\theta
\end{bmatrix}
\]

This three-degree-of-freedom model is retained as the initial mathematical reference.

A simpler position-only experiment may be introduced by constraining orientation.

## 4.2 Reference Anchor Coordinates

Existing MATLAB reference configuration:

\[
A=
\begin{bmatrix}
-2&2&2&-2\\
3&3&-1&-1
\end{bmatrix}
\]

Each column represents an external cable anchor.

## 4.3 Reference Attachment Coordinates

Body-frame attachment points:

\[
r=
\begin{bmatrix}
-0.5&0.5&0.5&-0.5\\
0.5&0.5&-0.5&-0.5
\end{bmatrix}
\]

Each column represents a rigid-body attachment point.

**Important:** These coordinates are inherited from the previous MATLAB learning model.

They are not experimentally validated balloon dimensions or final robot geometry.

## 4.4 World-Frame Attachment Points

The planar rotation matrix is:

\[
R(\theta)=
\begin{bmatrix}
\cos\theta&-\sin\theta\\
\sin\theta&\cos\theta
\end{bmatrix}
\]

For cable \(i\):

\[
B_i=P+R(\theta)r_i
\]

## 4.5 Cable Vectors and Lengths

Define the cable vector from attachment to anchor:

\[
d_i=A_i-B_i
\]

Cable length:

\[
L_i=\|d_i\|
\]

The complete measurement vector is:

\[
L(q)=
\begin{bmatrix}
L_1(q)\\
L_2(q)\\
L_3(q)\\
L_4(q)
\end{bmatrix}
\]

---

# 5. Cable Measurement Model

## 5.1 Forward Measurement

The ideal geometric measurement model is:

\[
L=h(q)
\]

Given the rigid-body state \(q\), the model predicts the four cable lengths.

This forward calculation has already been explored in previous MATLAB exercises.

## 5.2 Sensor Measurement

Actual measurements are represented by:

\[
y=h(q)+\varepsilon
\]

where:

- \(y\): cable-length measurement vector
- \(h(q)\): predicted ideal lengths
- \(\varepsilon\): measurement error or noise

Sensor offset and calibration errors must be included in later experimental models where relevant.

## 5.3 Measurement Jacobian

Define:

\[
H(q)=\frac{\partial h(q)}{\partial q}
\]

For the planar three-DOF model with four cables:

\[
H\in\mathbb{R}^{4\times3}
\]

The local measurement relationship is:

\[
\Delta L\approx H(q)\Delta q
\]

For the existing MATLAB Jacobian convention:

\[
H(q)=J(q)^T
\]

where:

\[
J\in\mathbb{R}^{3\times4}
\]

## 5.4 Sensitivity and Identifiability

The Jacobian describes how small object-state changes affect cable lengths.

Investigate:

- Independent measurement patterns
- Jacobian rank
- Singular values
- Minimum singular value
- Condition number
- Local measurement ambiguity

A full-column-rank measurement Jacobian is necessary for local first-order recovery of the selected three-dimensional state.

Full rank alone does not guarantee global uniqueness or acceptable measurement accuracy.

Position and orientation have different physical units. State scaling and measurement-noise characteristics must be considered before interpreting singular values and condition numbers as quantitative sensing-quality measures.

---

# 6. Previous Sensitivity Observation

Previous MATLAB simulations used the reference configuration:

\[
q_0=[0,0,0]^T
\]

Reported measurement sensitivity patterns were approximately:

\[
s_x=
\begin{bmatrix}
0.5145\\-0.5145\\-0.9487\\0.9487
\end{bmatrix}
\]

\[
s_y=
\begin{bmatrix}
-0.8575\\-0.8575\\0.3162\\0.3162
\end{bmatrix}
\]

\[
s_\theta=
\begin{bmatrix}
0.1715\\-0.1715\\-0.3162\\0.3162
\end{bmatrix}
\]

An important observation was:

\[
s_\theta\approx\frac{1}{3}s_x
\]

Thus, the translation and rotation measurement patterns can become linearly dependent in this configuration.

This indicates a potential local identifiability problem for the full three-DOF state.

**Research implication:**

Four cable measurements do not automatically guarantee independent information about x, y, and theta.

The configuration must be re-evaluated using accurate Jacobian calculations before it is selected for experimental use.

---

# 7. State Estimation

## 7.1 Estimation Objective

Estimate the unknown state using cable measurements:

\[
\hat q=\arg\min_{q\in\mathcal Q}
\|y-h(q)\|_2^2
\]

where:

- \(y\): measured cable lengths
- \(h(q)\): forward measurement prediction
- \(\hat q\): estimated rigid-body state
- \(\mathcal Q\): allowable state region

For later noise-aware estimation, weighted least squares may be considered.

## 7.2 Initial Estimation Tests

Begin with:

- Known static test positions
- Noise-free simulated cable measurements
- Initial guesses independent of the true test state
- Multiple initial guesses
- Comparison between true and estimated states

Then introduce:

- Cable-length noise
- Different object positions
- Alternative cable configurations
- Repeated trials

## 7.3 Error Metrics

Position error:

\[
e_p=
\sqrt{(\hat x-x)^2+(\hat y-y)^2}
\]

Orientation error:

\[
e_\theta=\operatorname{wrap}(\hat\theta-\theta)
\]

Root mean square position error:

\[
RMSE_p=
\sqrt{\frac{1}{N}\sum_{k=1}^{N}e_{p,k}^{2}}
\]

Orientation error should only be evaluated if orientation is included in the selected estimation objective.

---

# 8. Cable Configuration Investigation

## 8.1 Cable Number

Compare configurations according to the selected state dimension.

Possible candidate counts:

- Two cables
- Three cables
- Four cables
- More than four cables, if justified

Each configuration must be evaluated for measurement independence, physical feasibility, and estimation quality.

## 8.2 Anchor Placement

Investigate alternative anchor geometries:

- Symmetric arrangement
- Asymmetric arrangement
- Different spacing
- Different spatial distributions

## 8.3 Attachment Placement

Investigate:

- Symmetric attachment points
- Asymmetric attachment points
- Different attachment separations
- Translation and rotation measurement coupling
- Practical physical attachment feasibility

## 8.4 Configuration Evaluation

For every candidate configuration, record:

- Cable number
- Anchor coordinates
- Attachment coordinates
- State dimension
- Jacobian rank
- Scaled/noise-aware sensing metrics
- Measurement error
- Sensing workspace coverage
- Physical constraints

The best configuration should be selected according to explicitly defined measurement requirements.

---

# 9. Simplified Motion Validation

Complex balloon motion is not required for the initial sensing investigation.

## Test 1 — Static Positions

Purpose:

Validate the forward measurement model and static state estimation.

Procedure:

1. Define a set of reference positions.
2. Calculate or measure cable lengths.
3. Estimate object state.
4. Compare estimated and reference positions.

## Test 2 — Straight-Line Motion

Purpose:

Evaluate position estimation during simple translation.

Examples:

\[
x(t)=x_0+vt
\]

\[
y(t)=y_0
\]

Test different directions and displacement ranges.

## Test 3 — Different Speeds

Purpose:

Investigate estimation performance under different motion speeds.

Possible scenarios:

- Low speed
- Medium speed
- High speed

Specific numerical velocities should be determined from the selected experimental platform and sensor sampling requirements.

## Test 4 — Rotation

Purpose:

Evaluate orientation estimation, where included in the selected state model.

Possible scenarios:

- Pure rotation
- Small angular displacement
- Combined translation and rotation

**Critical rule:**

Prescribed experimental trajectories are used to generate test cases and ground truth.

They must not be directly supplied to the state estimator as known trajectories.

---

# 10. Preliminary Workspace Definition

Distinguish three concepts.

## Object Geometric Envelope

Defines the physical size and shape of the measured object.

For the rigid-body baseline, dimensions are fixed and specified by the reference geometry.

## Application Motion Envelope

Defines the range of positions and orientations considered in the tests.

Initial bounds are engineering test parameters, not claimed clinical measurements.

## Cable Sensing Workspace

Defines configurations where cable measurements can recover the selected state with acceptable reliability and accuracy.

Evaluate:

- Local identifiability
- Measurement sensitivity
- Estimation uncertainty
- Cable-length limits
- Mechanical feasibility
- Sensor performance

The full usable workspace must not be inferred from geometry alone.

---

# 11. MATLAB Implementation Plan

## Simulation A — Reference Geometry

Inputs:

- Anchor coordinates
- Attachment coordinates
- Object state

Outputs:

- Attachment positions
- Cable vectors
- Cable lengths
- Geometry plot

## Simulation B — Jacobian Verification

Inputs:

- Reference geometry
- Selected state
- Small state perturbations

Outputs:

- Analytical Jacobian
- Finite-difference Jacobian
- Derivative comparison errors

## Simulation C — Local Identifiability

Inputs:

- Candidate cable configurations
- Sampled object states

Outputs:

- Jacobian rank
- Singular values
- Measurement pattern similarity
- Scaled conditioning measures

## Simulation D — State Estimation

Inputs:

- Simulated cable measurements
- Forward measurement model
- Initial guess
- State constraints

Outputs:

- Estimated state
- Position error
- Orientation error, where applicable
- Convergence information

## Simulation E — Configuration Comparison

Inputs:

- Alternative cable numbers
- Alternative anchor locations
- Alternative attachment locations
- Common evaluation region
- Common measurement-noise assumptions

Outputs:

- Sensing-quality comparison
- Estimation-error comparison
- Workspace map
- Preliminary configuration recommendation

---

# 12. Validation Criteria

A configuration cannot be considered validated solely because the forward cable-length simulation runs correctly.

The following conditions should be checked:

1. Geometry and coordinate conventions are consistent.
2. Analytical Jacobian agrees with numerical derivatives.
3. The selected state is locally identifiable in the target region.
4. State estimation succeeds on independently specified test cases.
5. Errors are quantified against reference ground truth.
6. Noise sensitivity is investigated.
7. Mechanical and sensor-related assumptions are documented.
8. The configuration satisfies explicitly defined measurement requirements.

Numerical accuracy thresholds must be specified before claiming that a configuration meets the target performance.

---

# 13. Limitations of v0.1

- The initial model is planar and rigid.
- Reference coordinates originate from previous MATLAB studies.
- A four-cable layout is not assumed to be optimal.
- Sensor requirements have not yet been finalised.
- Clinical balloon motion boundaries remain uncertain.
- Deformation is not included in the initial state model.
- Physical experimental feasibility remains to be verified.
- Existing reconstruction data from collaborators have not yet been evaluated for compatibility.

---

# 14. Immediate Next Research Decision

Before implementing a final cable-number comparison:

**Decide whether the first sensing objective is planar position or planar pose.**

Recommended investigation:

1. Review the existing four-cable Jacobian.
2. Reproduce the local x–theta sensitivity coupling.
3. Determine the rank of the measurement Jacobian.
4. Compare with a simpler position-only model under an explicit orientation constraint.
5. Define the first quantitative measurement-accuracy target.

This decision will determine the scope of the first MATLAB state-estimation experiment.

---

# 15. Long-Term Extension

After successful rigid-body validation:

1. Introduce simplified balloon deformation.
2. Define shape or deformation parameters.
3. Investigate cable attachment to a deformable surface.
4. Extend the measurement model.
5. Re-evaluate cable number and placement.
6. Investigate existing reconstruction data from Siqi.
7. Validate deformation and shape estimates independently.

**Long-term objective:**

Estimate balloon position, orientation, and deformation or shape from cable measurements during passive, potentially irregular motion.

---
