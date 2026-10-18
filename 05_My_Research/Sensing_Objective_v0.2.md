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

\
