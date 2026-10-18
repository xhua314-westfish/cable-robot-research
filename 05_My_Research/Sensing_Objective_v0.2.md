# Sensing Objective v0.2

**Date:** 2026-10-19  
**Research Phase:** Phase 2 — 3D Rigid-Body Sensing Definition  
**Status:** Research scope defined; modelling and validation pending

---

## 1. Research Objective

### Main Research Question

> How do seven- and eight-cable configurations affect the accuracy, identifiability, and feasible sensing workspace of a passively moving 6-DOF rigid spherical object?

### Research Goal

Develop and evaluate a cable-based sensing system capable of estimating the three-dimensional position and orientation of a passively moving rigid spherical object using cable-length measurements.

The research focuses on **pose measurement and state estimation**, rather than active motion control.

A six-cable configuration will serve as a reference baseline.

---

## 2. Physical System

### 2.1 Measurement Object

| Parameter | Definition | Status |
|---|---|---|
| Object | Rigid spherical balloon proxy | Engineering approximation |
| Volume | 550 mL | Commercial balloon reference |
| Equivalent diameter | Approximately 101.7 mm | Calculated |
| Equivalent radius | Approximately 50.9 mm | Calculated |
| Motion | Passive and potentially irregular | Research assumption |
| Deformation | Excluded initially | Model simplification |

The rigid sphere is a simplified representation of an intragastric balloon.

The equivalent diameter is derived from volume and is not a directly measured external balloon diameter.

### 2.2 Measurement Environment

The object moves within a simplified three-dimensional gastric boundary.

**Reference population:** Adult women, prioritising obesity-related anatomical studies where available.

**Required dimensions:**

- Gastric length.
- Gastric width.
- Gastric height.

The initial environment will be represented by a simplified geometric boundary, such as an ellipsoid.

The gastric model is used to constrain object movement rather than reproduce detailed stomach anatomy or physiological motion.

Numerical dimensions remain to be established through literature evidence or clearly documented engineering assumptions.

---

## 3. Three-Dimensional Sensing State

### 3.1 Initial State

The initial sensing model estimates the full rigid-body pose:

\[
q=[x,y,z,\phi,\theta,\psi]^T
\]

**Degrees of freedom: 6.**

The rigid-body pose consists of:

\[
P\in\mathbb{R}^3,\qquad R\in SO(3)
\]

where:

- \(P\): Three-dimensional centre position.
- \(R\): Three-dimensional orientation.

The object can translate and rotate without following a prescribed trajectory.

The estimator must recover position and orientation without knowing the true motion trajectory.

### 3.2 Pose Representation

Rotation matrices or other suitable rotation representations will be used for numerical estimation.

Euler angles may be used for interpretation and visualisation.

Two-dimensional examples may be retained for verifying mathematical implementations, but not as a separate optimisation stage.

---

## 4. Cable Measurement Model

### 4.1 Cable Geometry

For cable \(i\):

\[
B_i=P+Rr_i
\]

\[
L_i=\|A_i-B_i\|
\]

where:

- \(A_i\in\mathbb{R}^3\): Fixed anchor point.
- \(r_i\in\mathbb{R}^3\): Attachment point in the body frame.
- \(B_i\in\mathbb{R}^3\): Attachment point in the world frame.
- \(P\in\mathbb{R}^3\): Object centre.
- \(R\in SO(3)\): Object orientation.
- \(L_i\): Ideal geometric cable length.

### 4.2 Measurement Relationship

\[
y=h(P,R)+\varepsilon
\]

where:

- \(y\): Measured cable-length vector.
- \(h(P,R)\): Predicted cable lengths.
- \(\varepsilon\): Measurement error.

The sensing objective is:

\[
[L_1,L_2,\ldots,L_n]^T
\rightarrow
(\hat P,\hat R)
\]

The estimator must not use the true pose as an input.

### 4.3 Measurement Jacobian

The measurement Jacobian describes how cable lengths change with small rigid-body translations and rotations.

\[
\Delta L\approx H\Delta q
\]

For \(n\) cables and 6-DOF pose sensing:

\[
H\in\mathbb{R}^{n\times6}
\]

Local pose identifiability requires:

\[
\operatorname{rank}(H)=6
\]

Full rank does not guarantee global uniqueness or acceptable measurement accuracy.

Translational and rotational quantities must be scaled consistently when evaluating numerical conditioning.

---

## 5. Motor-Assisted Low-Tension Cable Tracking

### 5.1 System Concept

**Passive Object Motion + Motor-Assisted Low-Tension Cable Tracking**

The object moves passively under external disturbances.

Motors adjust cable payout and retrieval to maintain low positive cable tension.

The motors do not prescribe the object's position or trajectory.

### 5.2 Control Objective

The motor system aims to:

- Maintain positive cable tension.
- Prevent cable slack.
- Track cable-length changes.
- Minimise cable-induced forces and torques.
- Reduce interference with passive object motion.

### 5.3 Physical Limitations

Future analysis must consider:

- Cable slack.
- Cable elasticity and friction.
- Motor response and tracking errors.
- Cable interference and routing.
- Attachment feasibility.
- Sensor calibration.
- Motion disturbance caused by cable tension.

The low-tension tracking mechanism is a proposed architecture and has not yet been experimentally validated.

---

## 6. Cable Number Selection

### 6.1 Six Cables — Reference Baseline

For a six-degree-of-freedom rigid body:

\[
H\in\mathbb{R}^{n\times6}
\]

With independent scalar cable-length measurements and no additional state constraints, local identifiability requires:

\[
n\geq6
\]

Six cables represent the minimum-count reference configuration.

However, six cable lengths do not automatically guarantee unique pose reconstruction or positive-tension feasibility.

### 6.2 Seven Cables — Primary Candidate A

Seven cables provide one additional scalar measurement beyond the six pose degrees of freedom.

Gouttefarde and Gosselin (2005) investigated the wrench-closure workspace of 6-DOF parallel mechanisms driven by seven cables.

**Research motivation:**

- Additional measurement redundancy.
- Potential improvement in estimation robustness.
- Additional flexibility for tension feasibility.
- Balance between sensing information and mechanical complexity.

Wrench-closure theory provides mechanical background but does not directly establish pose-estimation accuracy.

### 6.3 Eight Cables — Primary Candidate B

Eight cables provide two additional scalar measurements beyond the six pose degrees of freedom.

The IPAnema system family (Pott et al., 2013) provides an engineering reference for multi-cable CDPR architectures.

**Research motivation:**

- Increased measurement redundancy.
- Additional configuration flexibility.
- Potential improvement in sensing robustness.
- Investigation of the cost and interference associated with additional cables.

Eight cables are not assumed to outperform seven cables.

### 6.4 Selected Study Range

**Reference baseline:**

\[
n=6
\]

**Primary configurations:**

\[
\boxed{n\in\{7,8\}}
\]

The preferred configuration will be selected through quantitative evaluation.

---

## 7. Cable Configuration Comparison

### Stage A — Cable Number

Compare six-, seven-, and eight-cable configurations using consistent geometric constraints, measurement-noise assumptions, pose samples, and layout-generation rules.

**Research question:** Does additional cable redundancy improve pose-estimation performance?

### Stage B — Anchor Placement

Investigate alternative three-dimensional anchor arrangements.

Evaluate their influence on:

- Jacobian rank and conditioning.
- Position and orientation estimation.
- Sensing workspace coverage.
- Physical mounting feasibility.

### Stage C — Attachment Placement

Investigate alternative attachment distributions on the rigid sphere.

Evaluate:

- Translational sensitivity.
- Rotational sensitivity.
- Pose ambiguity.
- Cable routing and interference.

### Stage D — Configuration Selection

Compare promising seven- and eight-cable configurations under common sensing and physical constraints.

**Research question:** Which configuration offers the better balance between measurement performance and mechanical complexity?

---

## 8. Measurement Performance

No fixed position or orientation accuracy threshold is imposed at this stage.

### Primary Metrics

| Metric | Purpose |
|---|---|
| Jacobian rank | Local pose identifiability |
| Singular values and conditioning | Measurement sensitivity |
| Position RMSE | Translational estimation accuracy |
| Orientation RMSE | Rotational estimation accuracy |
| Maximum estimation error | Worst-case performance |
| Estimation success rate | Estimation reliability |
| Noise sensitivity | Measurement robustness |
| Sensing workspace coverage | Region satisfying defined measurement criteria |
| Motion disturbance | Influence of cables on passive motion |

### Position Error

\[
e_p=\|\hat P-P\|_2
\]

Position estimation error will be reported in millimetres.

### Orientation Error

\[
e_R=
\cos^{-1}
\left(
\frac{\operatorname{tr}(\hat R^TR)-1}{2}
\right)
\]

Orientation error will be evaluated using the relative rotation angle and reported in degrees.

The inverse-cosine argument must be clamped to the valid numerical interval.

Measurement requirements will be refined using sensor specifications, application needs, and validated results.

---

## 9. Workspace Definition

Three regions must be distinguished.

### 9.1 Gastric Boundary

The simplified anatomical envelope defining the available physical space.

### 9.2 Geometrically Feasible Workspace

The set of rigid-body poses for which the complete sphere remains inside the gastric boundary.

### 9.3 Sensing Workspace

The subset of geometrically feasible poses that satisfy measurement identifiability, estimation-performance, and selected mechanical-feasibility requirements.

\[
W_{\mathrm{sensing}}\subseteq W_{\mathrm{geo}}
\]

The complete sensing workspace includes both position and orientation.

For a perfect rigid sphere, geometric containment is orientation-independent, but attachment geometry and cable routing can restrict feasible orientations.

Workspace coverage must be evaluated using clearly defined sampling and acceptance criteria.

---

## 10. Research Validation Strategy

### Stage 1 — 3D Geometry

- Define the simplified gastric boundary.
- Define the rigid sphere.
- Determine geometrically feasible positions.
- Establish candidate 3D cable geometry.

### Stage 2 — Measurement Model

- Calculate cable lengths.
- Derive the 6-DOF measurement Jacobian.
- Verify the Jacobian using numerical finite differences.
- Evaluate rank and measurement sensitivity.

### Stage 3 — Pose Estimation

- Generate simulated cable measurements.
- Estimate unknown position and orientation.
- Investigate different initial guesses.
- Identify ambiguous solutions.

### Stage 4 — Configuration Comparison

- Compare six-, seven-, and eight-cable configurations.
- Optimise anchor placement.
- Optimise attachment placement.
- Evaluate estimation accuracy and workspace coverage.

### Stage 5 — Physical Feasibility

- Investigate low-tension cable tracking.
- Evaluate cable routing and interference.
- Analyse cable-induced forces and torques.
- Assess disturbance of passive motion.

### Stage 6 — Experimental Validation

Where feasible:

- Construct a rigid-body sensing prototype.
- Calibrate cable-length measurements.
- Obtain independent 6-DOF ground truth.
- Compare reference and estimated pose.
- Quantify measurement accuracy and repeatability.

---

## 11. Research Scope

### Included

- 3D rigid-body pose sensing.
- Six-degree-of-freedom state estimation.
- Six-cable baseline.
- Seven- and eight-cable configuration studies.
- 3D anchor and attachment optimisation.
- Measurement uncertainty analysis.
- Sensing workspace evaluation.
- Mechanical feasibility and low-tension tracking.

### Excluded from the Initial Model

- Balloon deformation and shape reconstruction.
- Detailed stomach dynamics.
- Clinical validation.
- Implantable device development.
- Active balloon trajectory control.

These topics may guide future design constraints but are not initial modelling objectives.

---

## 12. Open Research Questions

1. What anatomical dimensions should define the simplified gastric boundary?
2. Where can fixed anchors be physically installed?
3. What attachment layouts allow reliable orientation estimation?
4. Which cable configurations avoid pose ambiguity?
5. How sensitive are pose estimates to cable-length noise?
6. Can low positive tension be maintained without excessive motion disturbance?
7. How should cable lengths be measured and calibrated?
8. Which seven- or eight-cable design offers the best practical sensing performance?
9. What independent 6-DOF ground-truth system is feasible?

---

## 13. Next Research Task

**Task 2.2 — Simplified 3D Gastric Geometry**

**Planned Date:** Tuesday, 20 October 2026

**Objectives:**

1. Review gastric anatomical dimension studies.
2. Prioritise adult female and obesity-related evidence.
3. Define preliminary gastric length, width, and height.
4. Separate reported measurements from engineering assumptions.
5. Construct a simplified 3D gastric boundary.
6. Calculate geometrically feasible sphere-centre positions.
7. Produce an initial MATLAB 3D geometry visualisation.

**Expected Deliverables:**

- Gastric dimension evidence summary.
- Simplified 3D geometric boundary.
- Feasible rigid-sphere movement region.
- MATLAB geometry model and figure.
- Documented assumptions and limitations.

---

## 14. Key References

1. Thomas, F., & Ros, L. (2005). *Revisiting trilateration for robot localization.* IEEE Transactions on Robotics, 21(1), 93–101. DOI: 10.1109/TRO.2004.833793. Distance geometry background.

2. Gabaldo, S., Idà, E., & Carricato, M. (2023). *Pose-Estimation Methods for Planar Underactuated Cable-Driven Parallel Robots.* DOI: 10.1007/978-3-031-32322-5_1. Planar pose-estimation reference.

3. Pott, A. (2018). *Cable-Driven Parallel Robots: Theory and Application.* Springer. DOI: 10.1007/978-3-319-76138-1. General CDPR theory and design.

4. Gouttefarde, M., Daney, D., & Merlet, J.-P. (2011). *Interval-Analysis-Based Determination of the Wrench-Feasible Workspace of Parallel Cable-Driven Robots.* IEEE Transactions on Robotics, 27(1), 1–13. DOI: 10.1109/TRO.2010.2089531.

5. Gouttefarde, M., & Gosselin, C. M. (2005). *Wrench-Closure Workspace of Six-DOF Parallel Mechanisms Driven by 7 Cables.* Transactions of the Canadian Society for Mechanical Engineering, 29(4), 541–552. DOI: 10.1139/tcsme-2005-0034.

6. Gouttefarde, M., & Gosselin, C. M. (2006). *Analysis of the Wrench-Closure Workspace of Planar Parallel Cable-Driven Mechanisms.* IEEE Transactions on Robotics, 22(3), 434–445. DOI: 10.1109/TRO.2006.870638.

7. Pott, A., et al. (2013). *Cable-driven parallel robots for industrial applications: The IPAnema system family.* IEEE ISR. DOI: 10.1109/ISR.2013.6695742.

8. Song, D., et al. (2024). *A novel real-time tension distribution method for cable-driven parallel robots.* Robotica, 42(11), 3692–3708. DOI: 10.1017/S0263574724001590. Supporting reference for tension distribution, not direct evidence of eight-cable superiority.

---

**Guiding Principle**

Compare seven- and eight-cable 3D pose-sensing designs against a six-cable reference, focusing on estimation accuracy, identifiability, workspace coverage, mechanical feasibility, and minimal interference with passive object motion.
