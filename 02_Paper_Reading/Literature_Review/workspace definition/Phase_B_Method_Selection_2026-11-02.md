# Phase B — Literature-Based Method Selection

**Date:** 2026-11-02  
**Project:** Cable-Robot-Based Sensing for a Passive Balloon  
**Current Focus:** Six-Cable Workspace Validation and Configuration Optimisation  
**Status:** Literature method selection completed; balloon-specific implementations pending

---

## 1. Research Objective

The current research aims to design a cable-based measurement system for estimating the six-degree-of-freedom (6-DOF) pose of a passively moving spherical balloon.

### Engineering Baseline

| Parameter | Definition |
|---|---|
| Engineering boundary | 280 × 300 × 320 mm |
| Balloon volume | 550 mL |
| Balloon model | Rigid sphere |
| Balloon radius | Approximately 50.83 mm |
| Initial cable number | 6 |
| Anchor candidates | 26 discrete locations |
| Attachment candidates | 40 discrete locations |
| Primary measurement | Cable length |
| Balloon motion | Passive and unknown |
| Main software | MATLAB |

The engineering boundary is a simplified simulation envelope, not a clinically validated gastric lumen.

### Main Research Question

**How can six cable anchor–attachment pairs be selected to provide accurate, robust, and geometrically feasible 6-DOF pose sensing across the target balloon workspace?**

The six-cable configuration will be investigated before considering additional cables.

---

## 2. Current Research Progress

### B1 — Geometry Definition

The initial geometry model has been completed and numerically verified.

Completed outcomes:

- Three-dimensional engineering boundary.
- Equivalent 550 mL rigid spherical balloon.
- Balloon-centre geometric containment.
- Candidate anchor regions on six boundary faces.
- Candidate attachment regions on the sphere surface.
- Integrated MATLAB geometry model.

The 10 mm sampling experiment retained 6,783 geometrically feasible balloon-centre positions.

### B2.2 — Initial Six-Cable Configuration Comparison

Three configurations were investigated.

| Metric | Baseline | Experiment A | Experiment B |
|---|---:|---:|---:|
| Cable number | 6 | 6 | 6 |
| Jacobian rank at reference pose | 6 | 6 | 6 |
| Scaled minimum singular value | 0.004393 | 0.535345 | 0.533600 |
| Scaled condition number | 490.956 | 3.5759 | 3.2365 |
| Random trials | — | 20,000 | 20,000 |
| Valid random samples | — | 46 | 75 |

Experiment A varied the attachment locations while keeping six face-centre anchors fixed.

Experiment B varied both anchor and attachment locations.

**Main finding:** Anchor–attachment placement has a substantial influence on local measurement Jacobian conditioning.

**Important limitation:** These results are based on one reference pose and discrete random search. They do not establish global optimality, workspace-wide sensing performance, or experimental accuracy.

The original baseline was not evaluated under exactly the same routing constraints as Experiments A and B.

---

## 3. Method Requirements

Five methodological categories are required for the next research stage.

| ID | Method category | Main research question |
|---|---|---|
| M1 | Geometric and interference analysis | Can each cable be routed without invalid intersections? |
| M2 | Workspace evaluation | Which balloon poses satisfy the required constraints? |
| M3 | Sensing sensitivity | Can six-degree-of-freedom pose changes be distinguished from cable-length measurements? |
| M4 | Pose estimation and uncertainty | How accurate is the reconstructed pose under measurement and model errors? |
| M5 | Configuration optimisation | Which anchor–attachment arrangement offers the best trade-offs? |

These categories must remain distinct.

In particular:

- Geometric feasibility does not imply accurate sensing.
- Jacobian rank six does not guarantee acceptable measurement accuracy.
- Wrench closure does not imply sensing identifiability.
- A low condition number does not guarantee a low pose-estimation RMSE.
- Numerical optimisation does not automatically establish global optimality.

---

## 4. Existing Literature — Methods Available from Phase A

### P1 — Workspace Review

**Authors:** Tho & Thinh (2022)

**Title:** An Overview of Cable-Driven Parallel Robots: Workspace, Tension Distribution, and Cable Sagging

**DOI:** https://doi.org/10.1155/2022/2199748

**Reusable methods:**

- Pointwise workspace evaluation.
- Workspace feasibility classification.
- Constraint-based workspace sampling.

**Application to this research:**

Sample balloon positions and orientations and classify each pose according to geometric and sensing feasibility.

**Limitation:**

The paper is a review and does not provide a complete configuration optimisation algorithm tailored to passive cable sensing.

**Application stage:** B3.

### P2 — Attachment Configuration Optimisation

**Authors:** Cheng & Lau (2023)

**Title:** Cable Attachment Optimization for Reconfigurable Cable-Driven Parallel Robots Based on Various Workspace Conditions

**DOI:** https://doi.org/10.1109/TRO.2023.3288838

**Reusable methods:**

- Configuration design variables.
- Constraint-based optimisation.
- Wrench-closure and wrench-feasible conditions.
- Interference-free conditions.
- Polynomial optimisation formulation.

**Application to this research:**

Use anchor and attachment coordinates as design variables while replacing force-oriented objective functions with sensing-oriented metrics.

Potential objectives include measurement uncertainty, scaled Jacobian conditioning, and feasible workspace coverage.

**Limitation:**

The original paper focuses on reconfigurable CDPRs and force-related performance. Its optimisation objectives cannot be transferred unchanged.

**Application stage:** B5.

### P3 — Feasible Anchor Region Algorithms

**Authors:** Cheng, Lau & Hughes (2025)

**Title:** Determining Feasible Cable Attachment Locations for Cable-Driven-Parallel Robot

**DOI:** https://doi.org/10.1007/978-3-031-94608-0_21

**Reusable methods:**

- Algorithm 1: single-pose WCC feasible region.
- Algorithm 2: multi-pose feasible-region intersection.
- Feasible-region visualisation.

**Application to this research:**

Potentially evaluate mechanically feasible seventh-cable anchor positions after obtaining a validated six-cable reference configuration.

**Limitation:**

The reproduced strict positive-coefficient test applies to a specific seven-cable, six-DOF wrench matrix structure.

It cannot be used unchanged as a six-cable sensing accuracy condition.

**Application stage:** Future seven-cable extension.

### P4 — Forward Kinematics and Uncertainty

**Authors:** Patel, Nguyen & Caverly (2023)

**Title:** Forward Kinematics of a Cable-Driven Parallel Robot with Pose Estimation Error Covariance Bounds

**DOI:** https://doi.org/10.1016/j.mechmachtheory.2023.105231

**Reusable methods:**

- Six-degree-of-freedom forward kinematics.
- Iterative nonlinear pose estimation.
- Pose estimation error covariance.
- Monte Carlo validation.

**Application to this research:**

Evaluate the pose-estimation accuracy of feasible six-cable configurations under consistent measurement-noise assumptions.

**Limitation:**

The original study concerns an overconstrained CDPR. The previous Phase A implementation used a simplified Gauss–Newton estimator and did not reproduce every published solver.

The method must be revalidated for the new six-cable balloon geometry.

**Application stage:** B4.

---

## 5. Additional Literature — New Method Selection

### Category M1 — Interference and Cable Routing

#### N1 — Cable–Cable Interference

**Authors:** Youssef & Otis (2020)

**Title:** Reconfigurable Fully Constrained Cable Driven Parallel Mechanism for Avoiding Interference Between Cables

**Journal:** Mechanism and Machine Theory, 148, 103781

**DOI:** https://doi.org/10.1016/j.mechmachtheory.2020.103781

**Methods identified:**

- Detect cable–cable interference using shortest physical distances.
- Modify cable geometry to avoid interference.
- Evaluate interference during robot motion.

**Methods selected for this research:**

1. Model each straight cable as a finite 3D line segment.
2. Calculate minimum segment-to-segment distances.
3. Compare minimum distances with explicitly defined cable radius and clearance assumptions.
4. Evaluate interference at every sampled balloon pose.
5. Report the percentage of poses passing the interference constraints.

**Required adaptation:**

The original system uses online reconfiguration of cable exit points. Our anchor locations are fixed during operation.

Only the geometric interference checking principle is directly applicable.

**Priority:** High — B3.1 and B3.2.

#### N2 — Cable–Object Contact and Wrapping

**Authors:** Bhattacharya, Cheung, Wang & Lau (2025)

**Title:** Kinematic and Dynamic Modeling of Cable-Object Interference and Wrapping in Complex Geometrical-Shaped Cable-Driven Parallel Robots

**Journal:** Mechanism and Machine Theory, 214, 106092

**DOI:** https://doi.org/10.1016/j.mechmachtheory.2025.106092

**Methods identified:**

- Cable–object contact detection.
- Cable wrapping along complex surfaces.
- Kinematic and dynamic modelling of wrapped cable paths.
- Friction-aware cable modelling.

**Methods selected for this research:**

Initially implement a straight-segment–sphere intersection or minimum-distance test.

Retain the published wrapping model as a possible future extension if the physical system allows cable contact or wrapping.

**Required adaptation:**

The current balloon model assumes straight, taut cables without wrapping.

A complete wrapping model would require a different cable-length and contact model.

**Priority:** Low for the current rigid-sphere stage.

---

### Category M5 — Configuration Optimisation

#### N3 — Multi-Objective Configuration Optimisation

**Authors:** Zhou, Wu, Zi & Zhu (2024)

**Title:** Design and Optimization of a Cable-Driven Parallel Polishing Robot With Kinematic Error Modeling

**Journal:** Journal of Mechanical Design, 147(1), 013304

**DOI:** https://doi.org/10.1115/1.4065915

**Methods identified:**

- Kinematic error modelling.
- Workspace and stiffness performance indices.
- Multi-objective configuration optimisation.
- Improved NSGA-II optimisation.

**Methods selected for this research:**

Construct a multi-objective six-cable configuration design problem.

Possible objectives:

1. Maximise feasible sensing workspace coverage.
2. Minimise predicted pose-estimation uncertainty.
3. Improve worst-case scaled Jacobian conditioning.
4. Reduce geometric sensitivity to installation errors.

Potential design variables:

- Anchor coordinates.
- Attachment coordinates.
- Anchor–attachment pairing.

**Required adaptation:**

The paper focuses on a polishing robot and combines workspace, stiffness and kinematic error objectives.

Our system should replace these with sensing-oriented objectives and evaluate passive balloon poses.

NSGA-II is a candidate optimisation method, not a requirement.

**Priority:** High — B5.1.

#### N4 — Response Surface Optimisation

**Authors:** Cui, Du, Jin, Song, Li & Sun (2026)

**Title:** Multi-Objective Dimension and Shape Optimization Design of the Cable-Driven Parallel Robot Based on the Response Surface

**Journal:** Electronics, 15(2), 315

**DOI:** https://doi.org/10.3390/electronics15020315

**Methods identified:**

- Latin Hypercube Sampling.
- Response surface modelling.
- Parameter coupling analysis.
- Dimension and shape optimisation.

**Methods selected for this research:**

Use design-of-experiments sampling and a response surface when full multi-pose configuration evaluations become computationally expensive.

Potential surrogate outputs include:

- Workspace coverage.
- Worst-case scaled condition number.
- Estimated pose uncertainty.

**Required adaptation:**

The original objectives relate to CDPR workspace volumes and structural dimensions.

The surrogate model must be trained using sensing-performance results calculated from our own geometry.

**Priority:** Medium — optional B5 extension.

---

### Category M3/M4 — Measurement Sensitivity and Accuracy

#### N5 — Geometric Calibration and Error Compensation

**Title:** Calibration of Geometric Parameters and Error Compensation of Non-Geometric Parameters for Cable-Driven Parallel Robots

**Journal:** Mechatronics, 77, 102595 (2021)

**DOI:** https://doi.org/10.1016/j.mechatronics.2021.102595

**Methods identified:**

- Iterative geometric parameter calibration.
- Separation of geometric and non-geometric error sources.
- Residual error compensation using an artificial neural network.
- Experimental accuracy evaluation on a 3-DOF CDPR.

**Methods selected for this research:**

Investigate how errors in the following parameters affect reconstructed pose:

- Anchor coordinates.
- Attachment coordinates.
- Cable-length measurements.
- Balloon radius.
- Calibration offsets.

A first-stage sensitivity experiment should introduce controlled parameter perturbations and recalculate pose-estimation error.

**Required adaptation:**

The original experimental setup is a 3-DOF CDPR.

Our 6-DOF measurement model and error propagation must be derived separately.

Neural-network compensation is not required during the initial simulation stage.

**Priority:** High — B4.

#### N6 — Direct Cable Length Measurement

**Authors:** Martin, Fabritius, Stoll & Pott (2021)

**Title:** A Laser-Based Direct Cable Length Measurement Sensor for CDPRs

**Journal:** Robotics, 10(2), 60

**DOI:** https://doi.org/10.3390/robotics10020060

**Methods identified:**

- Direct cable-length measurement.
- Experimental comparison against winch-encoder-based cable-length estimates.
- Cable-length error evaluation.
- Effects of cable elongation and measurement deviations.

**Methods selected for this research:**

Use the paper to guide future sensor-error modelling and hardware measurement-chain analysis.

Compare simulated noise scenarios with experimentally measured error characteristics where appropriate.

**Required adaptation:**

Published sensor accuracy values belong to the paper's test conditions.

They must not be assumed to represent the precision of our proposed balloon measurement hardware.

**Priority:** Medium — B4.2 and future hardware development.

---

### Category M2/M5 — Redundant Cable Systems

#### N7 — Redundancy and Error-Insensitive Workspace

**Authors:** Zoffoli, Idà & Carricato (2025)

**Title:** Design and Control Optimization for Hybrid-Controlled Overconstrained Cable-Driven Parallel Robots

**Journal:** Mechanism and Machine Theory, 209, 105998

**DOI:** https://doi.org/10.1016/j.mechmachtheory.2025.105998

**Methods identified:**

- Wrench-Feasible Error-Insensitive Workspace (WFEIW).
- Length-controlled and force-controlled cable grouping.
- Control-error sensitivity analysis.
- Geometry optimisation of overconstrained cable systems.

**Methods selected for this research:**

Investigate the implications of cable redundancy once a six-cable reference configuration has been validated.

Potential future questions:

- Does an additional cable improve measurement uncertainty?
- Does redundancy increase feasible sensing coverage?
- How does redundant cable tracking influence disturbance forces?
- Is a hybrid length/tension tracking architecture appropriate?

**Required adaptation:**

WFEIW is a force/control-related workspace concept.

It must not be treated as a direct measure of passive balloon pose-sensing accuracy.

**Priority:** Deferred — 7/8-cable extension.

---

## 6. Method Mapping to the Seven Research Days

The literature should support the current tasks rather than create another standalone paper-reproduction phase.

| Research day | Task | Literature | Expected implementation |
|---|---|---|---|
| Nov 2 | B2.2 review and closure | Existing B2 results | Save baseline and A/B comparison |
| Nov 3 | B3.1: Multi-position feasibility | P1, N1 | Cable–sphere and cable–cable interference |
| Nov 4 | B3.2: Multi-pose feasibility | P1, N1 | Include rotations and evaluate feasible pose coverage |
| Nov 5 | B4.1: Sensing quality | P4, N5 | Jacobian rank, singular values and covariance |
| Nov 6 | B5.1: Configuration improvement | P2, N3 | Constrained multi-pose configuration search |
| Nov 9 | B4.2: FK and Monte Carlo | P4, N5, N6 | Position/orientation RMSE and error sensitivity |
| Nov 10 | B5.2: Six-cable reference selection | N3, optionally N4 | Compare and validate candidate designs |

The dates are provisional planning targets. Scientific verification takes priority over schedule completion.

### Literature Reading Priority

**Immediate reading:**

- N1 — Cable–Cable interference.
- N3 — Multi-objective configuration optimisation.
- N5 — Geometric parameter error modelling.

**Reuse without full reproduction:**

- P1 — Workspace sampling.
- P4 — Forward kinematics and covariance.

**Read when required:**

- N2 — Contact and wrapping.
- N4 — Response surface optimisation.
- N6 — Measurement hardware errors.
- N7 — Redundant cable systems.

---

## 7. Proposed Six-Cable Evaluation Framework

### 7.1 Geometry

For cable i:

\[
B_i=P+Rr_i
\]

\[
L_i=\|A_i-B_i\|
\]

Here:

- \(A_i\) is fixed in the world frame.
- \(r_i\) is fixed in the balloon body frame.
- \(P,R\) describe the balloon pose.

### 7.2 Geometric Feasibility

The evaluation must distinguish:

1. Full sphere containment.
2. Positive and valid cable lengths.
3. Cable–sphere intersection.
4. Cable–cable minimum distance.
5. Future mounting and routing restrictions.

The initial straight-cable model does not establish physical feasibility through the stomach wall.

### 7.3 Sensing Sensitivity

For the measurement Jacobian:

\[
H(q,\mathcal C)\in\mathbb R^{6\times6}
\]

Local six-degree-of-freedom identifiability requires:

\[
\operatorname{rank}(H)=6
\]

Conditioning should be evaluated using a clearly specified characteristic-length scaling.

A high scaled minimum singular value indicates stronger sensitivity in the weakest normalised measurement direction.

However, singular values alone do not establish actual pose-estimation accuracy.

### 7.4 Measurement Uncertainty

For the local measurement model:

\[
\delta y\approx H\delta q+\varepsilon
\]

and cable-length noise covariance \(\Sigma_y\), local pose covariance may be approximated by:

\[
\Sigma_q\approx
(H^T\Sigma_y^{-1}H)^{-1}
\]

provided the Jacobian has full column rank and the noise and local linearisation assumptions hold.

For the final evaluation, translation and rotation uncertainties must be reported separately.

### 7.5 Configuration Optimisation

Let the configuration be:

\[
\mathcal C=\{(A_i,r_i)\}_{i=1}^{6}
\]

A possible optimisation formulation is:

\[
\min_{\mathcal C}F(\mathcal C)
\]

subject to:

- Candidate-region constraints.
- Attachment surface constraints.
- Cable spacing and interference constraints.
- Required local identifiability.
- Explicit pose-sampling requirements.

Potential objectives include:

- Worst-case pose covariance.
- Worst-case scaled condition number.
- Feasible sensing coverage.

The final objective function and constraints must be selected before claiming an optimal design.

The initial approach should use constrained discrete candidate search.

A more advanced optimiser may be introduced after verifying the evaluation model.

---

## 8. Six-Cable Reference Configuration — Exit Criteria

A six-cable reference configuration can be selected when:

- [ ] Anchor and attachment coordinates are documented.
- [ ] The anchor–attachment pairing is reproducible.
- [ ] Cable geometry is checked across sampled poses.
- [ ] Cable–sphere interference is evaluated.
- [ ] Cable–cable interference is evaluated.
- [ ] Local Jacobian rank and conditioning are mapped.
- [ ] Pose covariance is evaluated.
- [ ] Forward kinematics is tested at multiple poses.
- [ ] Position and orientation RMSE are reported.
- [ ] Estimator convergence and failure cases are documented.
- [ ] Selected configurations are tested on independent validation poses.
- [ ] Modelling assumptions and physical limitations are recorded.

These requirements establish a numerically justified reference configuration, not a guaranteed global optimum or hardware-validated system.

---

## 9. Future Seven- and Eight-Cable Extension

The seven- and eight-cable study will begin after selecting the six-cable reference configuration.

### Seven-Cable Stage

- Retain a validated six-cable reference as the initial baseline.
- Introduce a seventh cable as a new design variable.
- Evaluate redundancy-related sensing improvements.
- Investigate Paper 3 WCC feasible-region methods only when the associated mechanical assumptions are relevant.
- Compare pose uncertainty and feasible sensing coverage.

### Eight-Cable Stage

- Extend the measurement Jacobian to an 8 × 6 structure.
- Compare covariance and estimation robustness.
- Investigate redundant sensing and physical complexity.
- Consider N7 for force/length tracking implications.

A further joint optimisation of all seven or eight cables may be required after extension.

The six-cable reference is a starting point, not an immutable final geometry.

---

## 10. Evidence and Implementation Rules

1. A verified DOI confirms bibliographic identification, not that an algorithm has been implemented.
2. Distinguish methods described in a paper from methods proposed for adaptation.
3. Re-derive measurement-specific equations whenever the original paper studies force control or actuation.
4. Do not use WCC as a substitute for sensing accuracy.
5. Do not assume a condition-number improvement guarantees a corresponding RMSE improvement.
6. Preserve failed configurations and numerical singularities.
7. Record all geometric units, pose samples and sensor-noise assumptions.
8. Separate training/optimisation pose samples from validation samples.
9. Do not interpret engineering boundary dimensions as clinical motion limits.
10. Select algorithms according to research questions rather than reproducing papers without a specific purpose.

---

## 11. References — DOI Index

### Existing Papers

**P1.** Tho & Thinh (2022).  
https://doi.org/10.1155/2022/2199748

**P2.** Cheng & Lau (2023).  
https://doi.org/10.1109/TRO.2023.3288838

**P3.** Cheng, Lau & Hughes (2025).  
https://doi.org/10.1007/978-3-031-94608-0_21

**P4.** Patel, Nguyen & Caverly (2023).  
https://doi.org/10.1016/j.mechmachtheory.2023.105231

### Additional Papers

**N1.** Youssef & Otis (2020).  
https://doi.org/10.1016/j.mechmachtheory.2020.103781

**N2.** Bhattacharya et al. (2025).  
https://doi.org/10.1016/j.mechmachtheory.2025.106092

**N3.** Zhou et al. (2024).  
https://doi.org/10.1115/1.4065915

**N4.** Cui et al. (2026).  
https://doi.org/10.3390/electronics15020315

**N5.** Calibration of Geometric Parameters and Error Compensation of Non-Geometric Parameters for Cable-Driven Parallel Robots (2021).  
https://doi.org/10.1016/j.mechatronics.2021.102595

**N6.** Martin et al. (2021).  
https://doi.org/10.3390/robotics10020060

**N7.** Zoffoli, Idà & Carricato (2025).  
https://doi.org/10.1016/j.mechmachtheory.2025.105998

---

## 12. Immediate Next Action

**B3.1 — Six-Cable Multi-Position Geometric Feasibility**

Use the existing Experiment A and Experiment B six-cable configurations.

Start with 27 balloon-centre positions:

\[
P_x,P_y,P_z\in\{-50,0,50\}\ \mathrm{mm}
\]

Keep \(R=I\) during the first test.

Implement and verify:

- Sphere containment.
- Cable lengths.
- Cable–sphere interference.
- Cable–cable interference.

Then extend the evaluation to rotated poses and sensing-quality metrics.

**Do not begin seven-/eight-cable extension until the six-cable reference configuration has undergone multi-pose sensing validation.**
