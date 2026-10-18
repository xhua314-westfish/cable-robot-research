# Rigid-Body Cable Sensing Design

**Version:** 0.2  
**Last Updated:** 2026-10-16  
**Research Phase:** Simplified Model and Cable Configuration Design  
**Primary Tool:** MATLAB  
**Status:** Proposed model; sensing validation pending

---

## 1. Research Objective

This study investigates cable-based position measurement of a rigid spherical object moving within a simplified gastric workspace.

The main research question is:

> How do cable number and placement affect the accuracy and reliability of position estimation for a 550 mL rigid spherical object?

The study focuses on:

- Cable number
- Anchor-point placement
- Attachment-point placement
- Measurement identifiability
- Position-estimation accuracy
- Sensing workspace coverage

The long-term goal is to extend the measurement system to a deformable balloon.

---

## 2. Simplified Physical Model

### 2.1 Gastric Environment

The initial environment is represented by a simplified gastric boundary.

**Reference population:** Adult female  
**Geometric representation:** Ellipsoidal approximation  
**Required dimensions:** Length, width, and height

The adult female reference is motivated by female-majority cohorts reported in selected intragastric balloon studies.

Female patient prevalence does not establish sex-specific gastric dimensions.

The gastric boundary is defined as:

$$
\Omega_g=
\left\{(x,y,z):
\frac{x^2}{a^2}+
\frac{y^2}{b^2}+
\frac{z^2}{c^2}\leq1
\right\}
$$

where:

- \(a=L_g/2\): Half-length
- \(b=W_g/2\): Half-width
- \(c=H_g/2\): Half-height

\(L_g\), \(W_g\), and \(H_g\) represent the assumed or literature-supported internal gastric dimensions under a specified filling condition.

**Purpose:** Constrain the rigid object's movement, not reproduce detailed gastric anatomy or physiology.

Numerical dimensions remain to be selected and justified.

### 2.2 Rigid Spherical Object

The initial measurement object is a rigid spherical approximation of a commercial intragastric balloon.

| Parameter | Value | Status |
|---|---|---|
| Volume | 550 mL | Commercial product reference |
| Shape | Sphere | Engineering assumption |
| Equivalent diameter | Approximately 10.17 cm | Derived |
| Equivalent radius | Approximately 5.09 cm | Derived |
| Deformation | Excluded | Initial model assumption |

The equivalent spherical diameter is:

$$
D=\left(\frac{6V}{\pi}\right)^{1/3}
$$

where \(V\) is expressed in cm³ and \(D\) in cm.

The equivalent diameter is not a clinically measured external diameter.

### 2.3 Geometric Feasibility

The rigid sphere must remain completely inside the simplified gastric boundary.

Define:

$$
W_{\mathrm{geo}}=
\{p:B(p,r)\subseteq\Omega_g\}
$$

where:

- \(p\): Sphere-centre position
- \(B(p,r)\): Sphere of radius \(r\), centred at \(p\)
- \(W_{\mathrm{geo}}\): Geometrically feasible centre positions

MATLAB will evaluate candidate centre positions and check whether the complete sphere remains inside the boundary.

The workspace must not be determined from the sphere centre alone.

If the chosen gastric boundary cannot accommodate the rigid sphere, the configuration is infeasible under the stated assumptions.

---

## 3. Cable Measurement Model

### 3.1 Initial State

The proposed first sensing model estimates planar position:

$$
q=[x,y]^T
$$

For this initial model:

- The sphere centre moves in a specified plane.
- Its out-of-plane position is fixed.
- Object orientation is mechanically constrained or independently known.

These conditions must be specified before validating position estimation.

The planar model is an initial sensing test, not the complete three-dimensional gastric motion model.

### 3.2 Cable Geometry

For cable \(i\), define:

- \(A_i\): Fixed anchor point
- \(r_i\): Body-frame attachment point
- \(B_i\): World-frame attachment point
- \(p\): Sphere-centre position
- \(R_0\): Fixed or known orientation

The attachment-point position is:

$$
B_i=p+R_0r_i
$$

The ideal cable length is:

$$
L_i=\|A_i-B_i\|
$$

All coordinates and lengths must use consistent physical units.

The previous four-cable MATLAB geometry is retained as a mathematical reference, but its original coordinates must not be interpreted as validated physical dimensions of the 550 mL sphere.

Initial attachment positions should be defined consistently with the sphere's surface and the assumed mechanical connection.

### 3.3 Measurement Relationship

The forward measurement model is:

$$
L=h(q)
$$

The sensor measurement model is:

$$
y=h(q)+\varepsilon
$$

where:

- \(y\): Measured cable lengths
- \(q\): Unknown object position
- \(h(q)\): Predicted cable lengths
- \(\varepsilon\): Measurement noise

Initially, cables are assumed taut and straight, with fixed anchor and attachment geometry.

Cable slack, routing, friction, and deformation-related effects require separate consideration during physical validation.

### 3.4 Measurement Jacobian

The measurement Jacobian is:

$$
H(q)=\frac{\partial h(q)}{\partial q}
$$

For \(n\) cable measurements and planar position estimation:

$$
H\in\mathbb{R}^{n\times2}
$$

The local measurement relationship is:

$$
\Delta L\approx H(q)\Delta q
$$

The existing MATLAB convention uses:

$$
H=J^T
$$

The analytical Jacobian must be checked against numerical finite differences.

---

## 4. Cable Configuration and Measurement Evaluation

### 4.1 Design Variables

The study compares:

| Variable | Investigation |
|---|---|
| Cable number | Number of independent length measurements |
| Anchor placement | Fixed cable locations |
| Attachment placement | Connection locations on the rigid sphere |

The previous four-cable planar model is the starting reference, not the final configuration.

### 4.2 Identifiability

The Jacobian must contain sufficient independent measurement information for the selected state.

For local planar position estimation, the target condition is:

$$
\operatorname{rank}(H)=2
$$

Rank deficiency indicates that some small position changes cannot be independently distinguished from cable-length changes.

Full rank alone does not guarantee global uniqueness or acceptable accuracy.

Previous MATLAB results showed strong coupling between x-translation and rotation in a particular planar four-cable configuration.

This observation should be rechecked when extending the measurement model or relaxing the fixed-orientation assumption.

### 4.3 State Estimation

Estimate position from cable measurements using a constrained optimisation method:

$$
\hat q=
\arg\min_{q\in W}
\|y-h(q)\|^2
$$

where \(W\) is the selected feasible test region.

The estimator must not use the true object position as an input.

Different initial guesses should be evaluated to identify ambiguous solutions and convergence limitations.

### 4.4 Evaluation Metrics

| Metric | Purpose |
|---|---|
| Jacobian rank | Local measurement independence |
| Singular values | Measurement sensitivity |
| Condition number | Sensitivity to poorly conditioned geometry |
| Position RMSE | State-estimation accuracy |
| Workspace coverage | Region meeting sensing criteria |
| Noise sensitivity | Measurement robustness |

Configuration comparisons must use consistent physical scales, test regions, and sensor-noise assumptions.

Measurement accuracy requirements must be defined before claiming that a configuration is acceptable.

### 4.5 Sensing Workspace

The sensing workspace is a subset of the geometrically feasible region:

$$
W_{\mathrm{sensing}}
\subseteq W_{\mathrm{geo}}
$$

A position is included only when the selected cable configuration satisfies the required measurement and physical-feasibility criteria.

The gastric boundary, geometric feasibility region, and sensing workspace must remain distinct.

---

## 5. Simulation and Validation

### 5.1 MATLAB Study

The initial study consists of four analyses.

**A — Geometry Verification**

- Construct the simplified gastric boundary.
- Construct the 550 mL rigid sphere.
- Identify feasible centre positions.
- Calculate and visualise cable lengths.

**B — Measurement Model Verification**

- Derive the analytical Jacobian.
- Check against finite differences.
- Investigate local identifiability and measurement coupling.

**C — Cable Configuration Comparison**

- Compare candidate cable numbers.
- Compare anchor placements.
- Compare attachment placements.
- Identify poorly conditioned configurations.

**D — State Estimation and Accuracy**

- Generate simulated cable measurements.
- Estimate object position.
- Introduce measurement noise.
- Compare estimated positions with ground truth.
- Evaluate RMSE and workspace coverage.

### 5.2 Initial Test Scenarios

| Test | Objective |
|---|---|
| Static positions | Verify geometric state estimation |
| Straight-line motion | Verify position tracking |
| Different velocities | Investigate sampling and measurement response |
| Multiple configurations | Compare sensing performance |

Prescribed motion provides reference ground truth but must not be supplied as a known trajectory to the estimator.

### 5.3 Validation Criteria

A candidate configuration is considered numerically supported only when:

1. The geometric and measurement models are verified.
2. Local identifiability is evaluated.
3. Position-estimation error is quantified.
4. Measurement noise and uncertainty are considered.
5. Sensing performance is evaluated over the test region.
6. Physical assumptions and limitations are documented.

Numerical simulation does not replace experimental validation with calibrated sensors and independent ground truth.

---

## 6. Current Assumptions and Open Questions

| Parameter | Current Status |
|---|---|
| 550 mL rigid sphere | Defined approximation |
| Simplified ellipsoidal stomach | Proposed |
| Gastric length, width, height | Evidence or assumption pending |
| Initial state | Planar position proposed |
| Orientation constraint | Not finalised |
| Cable number | To be investigated |
| Anchor and attachment locations | To be investigated |
| Sensor noise and accuracy | To be defined |
| Physical cable routing and tension | Not validated |
| Three-dimensional position measurement | Future extension |
| Balloon deformation sensing | Future extension |

### Immediate Technical Decision

Confirm the initial planar state, object-orientation constraint, geometric boundary parameters, and preliminary measurement-accuracy target.

Then verify the cable-length model and Jacobian before comparing candidate configurations.

---

## Related Documents

- [Current Research State](../CURRENT_STATE2.md)
- [Research Guidelines](../AGENTS2.md)
- [Research Roadmap](../08_Project_Management/Roadmap.md)
- [Research TODO](../08_Project_Management/TODO.md)
- [Weekly Plan](../08_Project_Management/WEEKLY_PLAN.md)

---

**Current Research Priority:** Determine which cable configurations can estimate the position of a 550 mL rigid spherical object accurately and reliably within a simplified constrained workspace.
