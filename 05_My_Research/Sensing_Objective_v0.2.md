
# Sensing Objective — Cable-Based Passive Balloon Sensing

**Version:** 0.3
**Original Definition:** 2026-10-19
**Last Updated:** 2026-11-04
**Research Scope:** Six-, Seven-, and Eight-Cable Sensing
**Primary Application:** Passive Deformable Balloon Measurement

---

## 1. Research Objective

### 1.1 Long-Term Goal

Develop and evaluate a cable-based measurement system capable of estimating the position, orientation, and eventually deformation or shape of a passively moving balloon-like object.

The application is motivated by intragastric balloon monitoring in a simplified stomach-like environment.

The system is intended for sensing and state estimation, not active trajectory control.

### 1.2 Main Research Question

> How do cable number, anchor placement and attachment placement affect the accuracy, identifiability, robustness and feasible sensing workspace of a passively moving balloon?

### 1.3 Comparative Research Question

> Can seven- and eight-cable configurations improve sensing performance compared with a six-cable reference, and are the improvements sufficient to justify their additional mechanical complexity?

The long-term objective explicitly includes:

- Six-cable reference sensing.
- Seven-cable theoretical and numerical investigation.
- Eight-cable theoretical and numerical investigation.
- Experimental validation.
- Extension toward deformable-balloon sensing.

---

## 2. Research Architecture

The project follows two complementary research workstreams.

### Workstream A — Six-Cable Prototype and Experiments

**Immediate engineering priority**

Establish an adjustable six-cable sensing system for:

- Rigid-body pose-estimation validation.
- Cable-length sensor calibration.
- Low-tension passive-motion tracking.
- Experimental measurement of position and orientation error.
- Initial flexible-balloon compatibility and experiments.

The first prototype does not require proof of globally optimal anchor–attachment placement.

### Workstream B — Seven-/Eight-Cable Theory and Simulation

**Parallel theoretical priority**

Investigate:

- Measurement redundancy.
- Local identifiability and conditioning.
- Pose covariance and estimation robustness.
- Geometric workspace and interference.
- Tension feasibility under specified mechanical assumptions.
- Additional hardware and routing complexity.

Theoretical research may proceed while the six-cable test rig is being designed or experimentally validated.

Physical expansion to seven or eight cables requires separate engineering justification.

### Integration Principle

Both workstreams must use consistent models and evaluation criteria for meaningful comparison.

---

## 3. Physical System and Assumptions

### 3.1 Measurement Object

The initial model uses a rigid spherical balloon proxy.

| Parameter | Initial Definition |
|---|---|
| Nominal volume | 550 mL |
| Equivalent radius | Approximately 50.83 mm |
| Initial state | Six-degree-of-freedom rigid pose |
| Motion | Passive and potentially irregular |
| Deformation | Excluded from initial rigid model |
| Future extension | Flexible balloon with deformation |

The rigid sphere is an engineering approximation.

### 3.2 Measurement Environment

The initial system uses a simplified three-dimensional engineering boundary.

Coordinate convention:

- X = Length.
- Y = Width.
- Z = Height.

The current engineering boundary is 280 × 300 × 320 mm.

These dimensions do not represent a clinically validated gastric lumen or physiological balloon-motion range.

Detailed geometry assumptions and supporting evidence belong in the workspace and rigid-body design documents.

### 3.3 Cable System

The proposed system contains:

- World-fixed cable anchors.
- Balloon-mounted attachment points.
- Cable-length measurements.
- Motor-assisted low-tension tracking.
- Adjustable mechanical interfaces.

Motors should follow passive balloon motion without prescribing its trajectory.

The tracking mechanism and disturbance forces require experimental validation.

---

## 4. Rigid-Body Measurement Objective

### 4.1 State Definition

The initial state is:

\[
q=[x,y,z,\phi,\theta,\psi]^T
\]

with:

\[
P\in\mathbb{R}^3,\qquad R\in SO(3)
\]

### 4.2 Cable-Length Model

For cable \(i\):

\[
B_i=P+Rr_i
\]

\[
L_i=\|A_i-B_i\|
\]

where:

- \(A_i\): World-fixed anchor.
- \(r_i\): Body-frame attachment.
- \(B_i\): World-frame attachment.
- \(L_i\): Ideal cable length.

The measurement model is:

\[
y=h(q)+\varepsilon
\]

where \(\varepsilon\) represents measurement error.

The sensing objective is to estimate the unknown pose from measured cable lengths.

The true balloon trajectory must not be supplied to the estimator.

### 4.3 Local Measurement Jacobian

For small pose perturbations:

\[
\delta L\approx H\delta q
\]

where:

\[
H\in\mathbb{R}^{n\times6}
\]

Local first-order rigid-pose identifiability requires:

\[
\operatorname{rank}(H)=6
\]

Full rank does not guarantee:

- Globally unique pose reconstruction.
- Acceptable estimation accuracy.
- Collision-free cable routing.
- Positive-tension mechanical feasibility.

---

## 5. Cable Number Comparison

### 5.1 Six Cables — Reference System

\[
H_6\in\mathbb{R}^{6\times6}
\]

Six independent scalar length measurements are the minimum count required for unconstrained local first-order identification of six rigid-body pose variables.

The six-cable system provides the numerical and experimental baseline.

### 5.2 Seven Cables — First Redundant System

\[
H_7\in\mathbb{R}^{7\times6}
\]

The additional measurement may improve sensing information and estimation robustness.

It also introduces additional routing and mechanical constraints.

### 5.3 Eight Cables — Second Redundant System

\[
H_8\in\mathbb{R}^{8\times6}
\]

Eight cables provide two additional scalar measurements relative to the six-dimensional rigid-body state.

Potential benefits and limitations must be evaluated quantitatively.

### 5.4 Comparison Principles

All configurations should be compared using:

1. Common target pose samples.
2. Consistent balloon geometry.
3. Consistent coordinate conventions.
4. Comparable sensor-noise assumptions.
5. Identical performance definitions.
6. Explicit geometric constraints.
7. Documented mechanical assumptions.
8. Comparable optimisation effort or clearly stated differences.

Additional cables do not automatically guarantee better performance.

---

## 6. Measurement Performance Criteria

### 6.1 Local Sensing Quality

Primary measures:

- Jacobian rank.
- Scaled minimum singular value.
- Scaled condition number.
- Weak sensing directions.
- Local pose covariance.

For an appropriate full-column-rank model:

\[
\Sigma_q\approx(H^T\Sigma_L^{-1}H)^{-1}
\]

Local covariance predicts uncertainty under the stated linearisation and noise assumptions.

It is not an experimental accuracy result.

### 6.2 Pose Estimation Accuracy

Position error:

\[
e_P=\|\hat P-P\|_2
\]

Orientation error:

\[
e_R=
\cos^{-1}
\left(
\frac{\operatorname{tr}(\hat R^TR)-1}{2}
\right)
\]

The inverse-cosine input must be numerically clamped to [-1,1].

Evaluation should include:

- Position RMSE.
- Orientation RMSE.
- Maximum estimation error.
- Estimator convergence rate.
- Estimation failure rate.
- Noise and calibration sensitivity.

### 6.3 Workspace and Mechanical Performance

Evaluate:

- Balloon containment.
- Cable–balloon interference.
- Cable–cable clearance.
- Mounting feasibility.
- Cable-length limits.
- Tension feasibility.
- Cable-induced disturbance.

Geometric, sensing and tension feasibility must be distinguished.

### 6.4 Acceptance Criteria

No universal numerical accuracy or clearance threshold is assumed without justification.

Acceptance criteria should be based on:

- Stated experimental objectives.
- Verified numerical models.
- Hardware specifications.
- Calibration measurements.
- Safety and mechanical requirements.

---

## 7. Flexible-Balloon Sensing Objective

The long-term sensing goal includes deformation or shape estimation.

### 7.1 Deformation-Aware Measurement Model

For reference attachment position \(r_{i0}\):

\[
B_i=P+R[r_{i0}+d_i(\eta)]
\]

where \(\eta\) represents selected deformation parameters.

### 7.2 Combined Motion and Deformation

The local measurement relationship becomes:

\[
\delta L\approx
H_{\mathrm{rigid}}\delta q+
H_{\mathrm{deform}}\delta\eta
\]

The identifiability of the combined state depends on the number and independence of measurements, model constraints and selected deformation parameters.

Six cable lengths generally cannot independently determine six rigid-pose variables plus arbitrary additional deformation variables.

Seven or eight cables may provide additional information but do not automatically guarantee full shape reconstruction.

### 7.3 Research Objectives

Investigate:

- Attachment displacement during deformation.
- Rigid-model errors caused by deformation.
- Deformation-dependent cable routing.
- Combined pose/deformation observability.
- Reduced-order deformation estimation.
- Additional sensor information where necessary.

Detailed deformation models and prototype compatibility requirements are maintained in the dedicated rigid-to-flexible design document.

---

## 8. Experimental Validation Objective

Experimental work should establish:

1. Cable-length measurement accuracy.
2. Geometric calibration accuracy.
3. Rigid-body pose-estimation performance.
4. Cable-tension tracking performance.
5. Disturbance of passive balloon motion.
6. Flexible-balloon measurement limitations.
7. The practical value of additional cable measurements.

Independent ground-truth measurements are required when reporting experimental pose-estimation accuracy.

Simulation and physical experiments must be reported separately.

---

## 9. Research Boundaries

### Included

- Three-dimensional cable-based sensing.
- Passive balloon motion.
- Six-degree-of-freedom rigid-body estimation.
- Six-/seven-/eight-cable comparison.
- Anchor and attachment configuration research.
- Geometric feasibility and sensing uncertainty.
- Low-tension tracking.
- Experimental prototyping.
- Initial flexible-balloon modelling and eventual deformation estimation.

### Outside the Initial Experimental Scope

- Detailed patient-specific gastric dynamics.
- Clinical validation.
- Implantable medical device development.
- Active balloon trajectory control.
- Unrestricted three-dimensional shape reconstruction from six lengths alone.

These topics may motivate future research but are not claims of the initial prototype.

---

## 10. Foundational References

1. Thomas, F., & Ros, L. (2005).
   *Revisiting trilateration for robot localization.*
   DOI: 10.1109/TRO.2004.833793.
   Distance geometry and localisation background.

2. Pott, A. (2018).
   *Cable-Driven Parallel Robots: Theory and Application.*
   DOI: 10.1007/978-3-319-76138-1.
   General cable-driven robot theory.

3. Gouttefarde, M., & Gosselin, C. M. (2005).
   *Wrench-Closure Workspace of Six-DOF Parallel Mechanisms Driven by 7 Cables.*
   DOI: 10.1139/tcsme-2005-0034.
   Mechanical wrench feasibility, not direct sensing accuracy evidence.

4. Gouttefarde, M., Daney, D., & Merlet, J.-P. (2011).
   *Interval-Analysis-Based Determination of the Wrench-Feasible Workspace of Parallel Cable-Driven Robots.*
   DOI: 10.1109/TRO.2010.2089531.
   Workspace analysis under mechanical constraints.

5. Pott, A., et al. (2013).
   *Cable-driven parallel robots for industrial applications: The IPAnema system family.*
   DOI: 10.1109/ISR.2013.6695742.
   Multi-cable mechanical architecture.

6. Cheng & Lau (2023).
   *Cable Attachment Optimization for Reconfigurable Cable-Driven Parallel Robots Based on Various Workspace Conditions.*
   DOI: 10.1109/TRO.2023.3288838.
   Configuration optimisation and workspace constraints.

These references support general methods, not the clinical validity or experimental performance of the proposed balloon sensing system.

---

## 11. Related Documents

- [Current Research State](../CURRENT_STATE2.md)
- [Research Roadmap](../08_Project_Management/Roadmap.md)
- [Rigid-Body Sensing Design](Rigid_Body_Sensing_Design.md)
- [Prototype V1.0 and Flexible Transition](Prototype_V1_Rigid_to_Flexible_Design_2026_11_04.md)
- [Workspace Boundary](Workspace_Boundary_v0.2_2026-10-20.md)
- [November Research TODO](../08_Project_Management/November/current_november_todo_updated_2026_11_04.md)
- [November Weekly Plan](../08_Project_Management/November/weekly_plan_nov_04_17_2026.md)

---

**Guiding Principle**

Establish six cables as the experimental sensing reference, investigate seven- and eight-cable systems in parallel through theory and simulation, and progressively extend the measurement framework toward deformable-balloon sensing.
