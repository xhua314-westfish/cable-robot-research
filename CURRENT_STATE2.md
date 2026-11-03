
# Current Research State

**Last Updated:** 2026-11-03  
**Current Phase:** Phase B — Balloon-Specific Cable Sensing Design  
**Current Focus:** Six-Cable Sensing Quality and Configuration Optimisation  
**Current Task:** B4.1 — Jacobian, Sensitivity and Covariance  
**Primary Tool:** MATLAB

**Overall Status:** Phase A core method reproduction completed. B1 geometry definition, B2 initial six-cable configuration comparison, and B3 discrete geometric feasibility evaluation completed. B4.1 is the next research task.

---

## 1. Research Direction

### 1.1 Long-Term Goal

Develop a cable-based measurement system to estimate the position, orientation, and eventually deformation or shape of a passively moving balloon-like object.

The application is motivated by intragastric balloon monitoring within a simplified gastric environment.

The system is intended for **measurement and state estimation**, not active motion control.

### 1.2 Main Research Question

> Can cable-length measurements be used to accurately estimate the 6-DOF pose of a passively moving balloon, and how do cable number, anchor placement, and attachment placement affect sensing performance?

### 1.3 Current Research Priority

The immediate objective is to establish a numerically justified six-cable sensing configuration.

The current research sequence is:

1. Evaluate six-cable geometric feasibility.
2. Evaluate sensing sensitivity across multiple poses.
3. Evaluate pose estimation accuracy.
4. Improve anchor–attachment placement.
5. Select a six-cable reference configuration.
6. Investigate seven- and eight-cable extensions.

The six-cable reference should be validated before additional cables are introduced.

However, selecting a six-cable reference does not require proof of global optimality.

### 1.4 Current Research Scope

- Three-dimensional rigid-body sensing.
- Six-degree-of-freedom pose estimation.
- Simplified rectangular engineering boundary.
- 550 mL rigid spherical balloon.
- Fixed world-frame cable anchors.
- Body-frame attachment coordinates.
- Cable-length measurements.
- Passive and unknown balloon motion.
- Motor-assisted low-tension tracking as a proposed physical architecture.

**Future extensions:**

- Seven-/eight-cable redundancy.
- Sensor and hardware validation.
- Deformable balloon modelling.
- Shape and deformation estimation.

---

## 2. Established Engineering Baseline

### 2.1 Geometry

| Parameter | Current Value | Status |
|---|---|---|
| Engineering boundary X | 280 mm | Selected |
| Engineering boundary Y | 300 mm | Selected |
| Engineering boundary Z | 320 mm | Selected |
| Balloon volume | 550 mL | Selected |
| Balloon geometry | Rigid sphere | Engineering approximation |
| Balloon radius | Approximately 50.83 mm | Calculated |
| Balloon diameter | Approximately 101.65 mm | Calculated |
| Initial balloon centre | [0, 0, 0] mm | Reference pose |
| Initial rotation | Identity matrix | Reference pose |
| Cable number | Six | Current baseline |
| Anchor region | Six boundary faces | Initial geometric model |
| Attachment region | Entire sphere surface | Initial geometric model |
| Primary measurement | Cable length | Selected |

The boundary dimensions were increased following supervisor feedback and are used as a fixed initial engineering baseline.

They are not clinically validated gastric lumen dimensions.

### 2.2 Coordinate Convention

The current MATLAB model uses:

- X — Length.
- Y — Width.
- Z — Height.

All geometry coordinates are expressed in millimetres.

**World frame:**

- Cable anchor locations.
- Balloon centre position.
- World-frame attachment coordinates.

**Body frame:**

- Attachment locations fixed relative to the rigid balloon.

### 2.3 Balloon Motion Assumptions

The balloon:

- Moves passively.
- Does not follow a predefined trajectory.
- May translate and rotate.
- Has constant volume and no deformation in the initial model.

Its true pose may be used to generate simulated measurements and evaluate estimation errors, but must not be provided to the estimator as a known solution.

### 2.4 Proposed Physical Architecture

Motors may maintain low positive cable tension while tracking passive balloon motion.

The following remain unverified:

- Motor and sensor selection.
- Cable diameter and compliance.
- Cable friction and routing.
- Anchor and attachment hardware.
- Low-tension force range.
- Disturbance forces on passive balloon motion.

---

## 3. Completed Research — Phase A

**Status:** Core A1–A5 method reproduction completed.

Phase A established the numerical methods required for balloon-specific design.

### 3.1 A1 — Tension Factor and Wrench Feasibility

**Reference:** Paper 2 — RREF, Tension Factor and WCC.

Completed:

- Reproduced a planar cable tension example.
- Applied RREF to obtain relative cable-force coefficients.
- Verified equilibrium residuals.
- Calculated the Tension Factor.

**Verified result:**

TF ≈ 0.6671.

**Potential application:**

Mechanical tension feasibility and relative cable-force analysis.

**Limitation:**

Tension Factor is not a direct sensing accuracy metric.

### 3.2 A2 — Feasible Cable Anchor Regions

**Reference:** Paper 3 — Algorithm 1.

Completed:

- Constructed a seven-cable wrench matrix.
- Derived relative coefficient relationships.
- Evaluated WCC feasibility inequalities.
- Implemented a single-pose feasible anchor-region calculation.
- Verified affine boundary-function fitting.

**Verified result:**

29,291 feasible points from 68,921 candidate locations in the selected reference example.

**Potential application:**

Mechanically feasible candidate-anchor-region screening when the corresponding WCC assumptions are justified.

### 3.3 A3 — Multi-Pose Feasible Region Intersection

**Reference:** Paper 3 — Algorithm 2.

Completed:

- Generated eight reference platform positions.
- Evaluated WCC conditions at each pose.
- Intersected feasible anchor regions.
- Verified that cumulative feasible counts were non-increasing.
- Extended the analysis to individual cable anchors.

**Verified result:**

1,005 candidate locations remained in the selected eight-pose seventh-anchor WCC experiment.

**Potential application:**

Multi-pose constraint intersection.

**Limitation:**

Paper 3's seven-cable WCC criterion is not automatically applicable to a six-cable sensing system.

### 3.4 A4 — Forward Kinematics and Pose Estimation Uncertainty

**Reference:** Paper 4 — Forward Kinematics and Covariance Bounds.

Completed:

- Implemented an eight-cable 3D length-measurement model.
- Derived and verified the 8 × 6 measurement Jacobian.
- Tested analytical and finite-difference derivatives.
- Implemented a Gauss–Newton 6-DOF estimator.
- Verified noiseless pose reconstruction.
- Added Gaussian cable-length noise.
- Calculated local pose covariance.
- Performed a 100-trial Monte Carlo experiment.
- Evaluated RMSE, standard deviation, coverage and NEES.

**Selected results:**

| Metric | Recorded Result |
|---|---|
| Jacobian rank | 6 |
| Maximum numerical Jacobian discrepancy | 4.102 × 10⁻¹¹ |
| Noiseless reconstruction | Near-zero error, 4 iterations |
| Assumed cable-length noise SD | 1 mm |
| Predicted position SD (X/Y/Z) | 0.5018 / 0.9462 / 0.6340 mm |
| Monte Carlo position SD (X/Y/Z) | 0.5170 / 0.9731 / 0.6753 mm |
| Average NEES | 6.6459 |
| 95% ANEES acceptance interval | [5.3402, 6.6977] |
| Consistency result | Passed |

**Potential application:**

- Balloon pose estimation.
- Jacobian verification.
- Local uncertainty prediction.
- Multi-pose Monte Carlo validation.

**Limitations:**

The reference model is not the current six-cable balloon configuration.

The principal Monte Carlo experiment used one true pose and an assumed measurement-noise model.

The implemented solver does not reproduce every algorithm in the source paper.

### 3.5 A5 — Three-Dimensional Workspace Sampling

**Reference:** Paper 1 — Workspace Review.

Completed:

- Implemented three-dimensional position sampling.
- Evaluated selected wrench and cable-length conditions.
- Compared roll orientations.
- Visualised feasible regions.
- Calculated discrete multi-orientation intersections.

**Selected results:**

| Metric | Recorded Result |
|---|---:|
| Sampled positions | 2,197 |
| WCC-feasible positions at zero roll | 861 |
| WCC and length feasible at zero roll | 765 |
| Combined feasible at −10° roll | 623 |
| Combined feasible at +10° roll | 175 |
| Common feasible positions at three roll angles | 95 |

**Potential application:**

Workspace sampling and pointwise constraint evaluation.

**Limitation:**

These values belong to the reference model, not the balloon geometry.

### Phase A Conclusion

Phase A provided transferable mathematical and numerical methods.

It did not establish the feasibility, sensing accuracy, or optimal configuration of the balloon-specific system.

Completed Phase A exercises should not be repeated unless a specific error, limitation, or new research question requires it.

---

## 4. Completed Research — Phase B1

**Status:** Completed — Initial Geometry Definition.

### 4.1 B1.1 — Engineering Boundary

The supervisor-recommended enlarged boundary was adopted:

\[
L_g=280\ \mathrm{mm}
\]

\[
W_g=300\ \mathrm{mm}
\]

\[
H_g=320\ \mathrm{mm}
\]

This is an engineering baseline rather than a clinically measured boundary.

### 4.2 B1.2 — Balloon Geometry

The rigid balloon model was implemented using:

\[
V_b=550000\ \mathrm{mm^3}
\]

\[
r_b=\left(\frac{3V_b}{4\pi}\right)^{1/3}
\]

**Result:**

\[
r_b\approx50.83\ \mathrm{mm}
\]

MATLAB sphere visualisation and volume calculations were completed.

### 4.3 B1.3 — Geometrically Feasible Centre Region

With zero additional clearance:

\[
|P_x|\leq89.17\ \mathrm{mm}
\]

\[
|P_y|\leq99.17\ \mathrm{mm}
\]

\[
|P_z|\leq109.17\ \mathrm{mm}
\]

**Verified MATLAB results:**

| Metric | Result |
|---|---:|
| Total sampled centres | 29,667 |
| Feasible centres | 6,783 |
| Infeasible centres | 22,884 |

These results establish geometric sphere containment within the rectangular engineering model.

They do not establish actual physiological balloon motion limits.

### 4.4 B1.4 — Candidate Anchor Regions

Six continuous boundary-face regions were defined.

An initial 3 × 3 sampling scheme generated:

**26 unique anchor candidates.**

The candidate coordinates were numerically verified and visualised in MATLAB.

### 4.5 B1.5 — Candidate Attachment Regions

The spherical balloon surface was defined as the initial attachment candidate region.

A coarse spherical-coordinate sampling scheme generated:

**40 attachment candidates.**

Maximum recorded radius error:

\[
7.105\times10^{-15}\ \mathrm{mm}
\]

All attachment coordinates are defined in the balloon body frame.

### 4.6 B1.6 — Integrated Geometry

Completed:

- Boundary and sphere integration.
- Anchor and attachment visualisation.
- Coordinate-frame transformation verification.
- Candidate geometry validation.
- MATLAB geometry dataset generation.

**MATLAB result: Geometry verification passed.**

### B1 Conclusion

The initial geometry model is sufficiently defined for cable configuration research.

Remaining physical mounting and interference constraints must be evaluated separately.

---

## 5. Completed Research — Phase B2.1 and B2.2

**Status:** Initial single-pose six-cable configuration comparison completed.

### 5.1 Research Question

How do anchor and attachment positions affect the local 6-DOF sensing performance of the balloon?

### 5.2 B2.1 — Initial Six-Cable Baseline

The original reference configuration used six face-centre anchors and an initial set of attachment locations.

**Results:**

| Metric | Value |
|---|---:|
| Cable count | 6 |
| Jacobian rank | 6 |
| Scaled minimum singular value | 0.004393 |
| Scaled condition number | 490.956 |

**Finding:**

The Jacobian was full rank but poorly conditioned.

This demonstrates that local full rank alone does not imply well-balanced sensing sensitivity.

### 5.3 B2.2 Experiment A — Fixed Anchors, Variable Attachments

Six face-centre anchors were held fixed.

Attachment locations and pairings were varied using random search.

**Results:**

| Metric | Value |
|---|---:|
| Random trials | 20,000 |
| Valid sampled configurations | 46 |
| Scaled minimum singular value | 0.535345 |
| Best observed condition number | 3.5759 |

**Finding:**

Attachment placement produced a substantial improvement in local sensing conditioning.

The selected configuration is a reference candidate, not a globally optimal design.

### 5.4 B2.2 Experiment B — Variable Anchors and Attachments

Both anchor and attachment locations were varied.

Six unique anchor and attachment positions were selected per random trial.

**Results:**

| Metric | Value |
|---|---:|
| Random trials | 20,000 |
| Routing checks passed | 75 |
| Rank checks passed | 75 |
| Scaled minimum singular value | 0.533600 |
| Best observed condition number | 3.2365 |

**Finding:**

Joint anchor–attachment selection further reduced the observed condition number by approximately 9.49% compared with Experiment A.

However, the minimum singular value decreased slightly.

The selected Experiment B configuration was spatially asymmetric, with five of six anchors on the positive-Z boundary.

### 5.5 Comparison Summary

| Metric | Baseline | Experiment A | Experiment B |
|---|---:|---:|---:|
| Jacobian rank | 6 | 6 | 6 |
| Scaled minimum singular value | 0.004393 | 0.535345 | 0.533600 |
| Scaled condition number | 490.956 | 3.5759 | 3.2365 |
| Valid random samples | Not consistently screened | 46 | 75 |

A three-configuration MATLAB visual comparison was generated.

### 5.6 Main B2.2 Conclusions

1. Attachment placement strongly affects local sensing geometry.
2. Joint anchor–attachment selection can further improve the best observed condition number.
3. Better condition number does not necessarily imply better minimum singular value.
4. Random search does not guarantee a globally optimal configuration.
5. A configuration that performs well at the initial pose may perform poorly elsewhere.
6. The current results are insufficient to select a final six-cable arrangement.

### 5.7 B2.2 Limitations

- Only the reference pose was evaluated.
- No full workspace feasibility evaluation was performed.
- Cable–cable interference was not evaluated systematically.
- Initial straight-cable outward routing does not establish complete physical routing feasibility.
- Physical cable diameter and minimum clearance remain unknown.
- Experimental cable-length noise has not been calibrated.
- Estimator RMSE was not evaluated for these balloon-specific configurations.
- Global optimality remains unproven.

The original baseline did not undergo exactly the same geometry screening as Experiments A and B.

### B2 Conclusion

The initial six-cable configuration comparison is complete.

The next task is to determine whether Experiment A and Experiment B remain geometrically feasible and sufficiently informative across multiple balloon poses.

**Do not begin seven-/eight-cable optimisation at this stage.**

---

## 6. Established Mathematical Framework

### 6.1 Cable-Length Measurement Model

For cable i:

\[
B_i=P+Rr_i
\]

\[
L_i=\|A_i-B_i\|
\]

where:

- \(A_i\): world-frame anchor.
- \(r_i\): body-frame attachment.
- \(P\): balloon-centre position.
- \(R\): balloon orientation.
- \(B_i\): world-frame attachment.

The measured cable length is:

\[
L_{i,\mathrm{meas}}=L_i+\varepsilon_i
\]

### 6.2 Measurement Jacobian

For small pose perturbations:

\[
\delta L\approx H\delta q
\]

For six cables:

\[
H\in\mathbb R^{6\times6}
\]

Local six-degree-of-freedom identifiability requires:

\[
\operatorname{rank}(H)=6
\]

This condition is necessary for local first-order pose reconstruction, but does not establish global uniqueness or sufficient measurement accuracy.

### 6.3 Sensing Quality Metrics

Current metrics include:

- Jacobian rank.
- Scaled singular values.
- Scaled minimum singular value.
- Scaled condition number.
- Predicted pose covariance.
- Position and orientation RMSE.
- Estimator convergence and failure rate.

Translation and rotation must be scaled consistently when comparing Jacobian conditioning.

### 6.4 Pose Estimation

The pose estimator is based on nonlinear cable-length equations.

A basic formulation is:

\[
(\hat P,\hat R)=
\arg\min_{P,R}
\|L_{\mathrm{meas}}-g(P,R)\|^2
\]

The weighted form should be used when the measurement-noise covariance is known and appropriate.

### 6.5 Local Pose Covariance

For a full-column-rank measurement Jacobian and suitable noise assumptions:

\[
\Sigma_q\approx
(H^T\Sigma_L^{-1}H)^{-1}
\]

Covariance is a local linearised uncertainty prediction.

It does not establish experimentally measured system accuracy.

### 6.6 Geometric and Mechanical Feasibility

Evaluate separately:

1. Balloon containment.
2. Cable-length constraints.
3. Cable–sphere interference.
4. Cable–cable interference.
5. Mounting and routing feasibility.
6. Tension feasibility under a specified mechanical model.
7. Measurement identifiability.
8. Estimation accuracy.

Do not substitute wrench closure or force-related workspace metrics for sensing quality.

---

## 7. Current Research — Six-Cable Validation

**Current Task:** B3.1 — Multi-Position Geometric Feasibility.

The current objective is to test the existing six-cable configurations before modifying their geometry.

### 7.1 B3.1 — Multi-Position Feasibility

Initial position samples:

\[
P_x,P_y,P_z\in\{-50,0,50\}\ \mathrm{mm}
\]

Total:

\[
N=27
\]

Initial orientation:

\[
R=I
\]

Evaluate:

- Full balloon containment.
- Cable lengths.
- Cable–sphere interference.
- Cable–cable minimum distances.
- Geometric feasibility coverage.

**Input configurations:**

- Experiment A.
- Experiment B.

**Expected outputs:**

- Geometric feasibility maps.
- Minimum cable-distance results.
- Pose failure classification.
- A/B feasibility comparison.

### 7.2 B3.2 — Multi-Pose Feasibility

Extend the position samples to include:

- Zero rotation.
- Roll ±10°.
- Pitch ±10°.
- Yaw ±10°.

These are illustrative initial engineering rotations, not measured physiological motion limits.

The first combined set contains 189 poses.

### 7.3 B4.1 — Sensing Quality

Evaluate:

- Jacobian rank across poses.
- Scaled singular values.
- Condition-number distributions.
- Local pose covariance.
- Weak sensing directions.
- Sensitivity to selected geometric perturbations.

### 7.4 B5.1 — Six-Cable Configuration Improvement

Use workspace-level evaluation criteria to improve anchor–attachment placement.

The initial optimisation study should:

- Reuse Experiment A and B as references.
- Use consistent geometric constraints.
- Evaluate common training poses.
- Preserve infeasible results.
- Retain multiple promising configurations.
- Avoid unsupported global-optimality claims.

### 7.5 B4.2 — Pose Estimation Accuracy

Adapt the Phase A4 forward-kinematics implementation.

Evaluate multiple feasible poses under explicitly defined measurement noise.

Report:

- Position RMSE.
- Orientation RMSE.
- Estimator convergence.
- Local covariance consistency.
- Geometric calibration sensitivity.

### 7.6 B5.2 — Six-Cable Reference Selection

Select a reproducible six-cable reference configuration using:

- Geometric feasibility.
- Workspace-level sensing quality.
- Estimated pose accuracy.
- Robustness.
- Implementation complexity.

The selected reference is a research baseline, not a guaranteed global optimum.

---

## 8. Literature and Method Selection

### Existing Phase A Methods

| Literature | Available Method | Application Stage |
|---|---|---|
| Paper 1 | Workspace sampling | B3 |
| Paper 2 | Configuration optimisation framework | B5 |
| Paper 3 | WCC anchor regions and multi-pose intersection | Future 7-cable study |
| Paper 4 | Forward kinematics and covariance | B4 |

### Additional Method Categories

The literature extension focuses on:

| Category | Main Use | Stage |
|---|---|---|
| Cable–cable interference | Minimum distance between cable segments | B3 |
| Cable–object interaction | Collision and potential wrapping | B3 / Future |
| Multi-objective optimisation | Configuration selection | B5 |
| Geometric calibration | Installation error sensitivity | B4 |
| Cable-length measurement | Sensor noise and calibration | B4 / Hardware |
| Redundant cable systems | Seven-/eight-cable extension | Future |

**Research Rule:**

Apply published methods only when they address the current research question.

Do not reproduce additional algorithms solely because they appear in the literature.

---

## 9. Open Research Questions

| Priority | Research Question | Planned Stage |
|---|---|---|
| Critical | Are Experiments A and B geometrically feasible across multiple poses? | B3 |
| Critical | How should cable–sphere interference be calculated? | B3 |
| Critical | How should cable–cable interference be calculated? | B3 |
| High | Does Experiment B remain better than A across the workspace? | B4 |
| High | Which six-cable geometries retain local rank six? | B4 |
| High | What are the weakest sensing directions? | B4 |
| High | How does cable-length noise affect pose uncertainty? | B4 |
| High | How sensitive is pose estimation to anchor and attachment errors? | B4 |
| High | Which configuration provides the best observed workspace-level trade-off? | B5 |
| Medium | What is the physically appropriate cable-tension range? | Hardware |
| Medium | What measurement resolution can the proposed sensors achieve? | Hardware |
| Medium | How should ground-truth pose be measured experimentally? | Phase C |
| Future | Does a seventh or eighth cable improve sensing accuracy and robustness? | 7/8-cable stage |
| Future | Can balloon deformation and shape be estimated? | Phase D |

---

## 10. Immediate Next Action

### Start B3.1 — Six-Cable Multi-Position Geometric Feasibility

**Research Question:**

> Can the existing six-cable configurations remain geometrically feasible when the balloon moves to different positions?

The initial investigation must:

1. Load Experiment A and B geometry.
2. Generate the same 27 balloon-centre positions.
3. Verify sphere containment.
4. Calculate cable lengths.
5. Test cable–sphere interference.
6. Test cable–cable minimum distances.
7. Compare sampled geometric feasibility.
8. Record failures and limitations.

**Important:**

Do not modify anchor or attachment positions during this first feasibility experiment.

The purpose is to identify limitations of the existing configurations before performing further optimisation.

### Expected Files

- `B3_1_multi_position_feasibility.m`
- `B3_1_segment_distance_3d.m`
- `B3_1_results.mat`
- `B3_1_feasibility_notes.md`

The complete daily execution plan is maintained in `weekly_plan_03.md`.

---

## 11. Main Repository References

### Research Guidance

- [AGENTS2.md](AGENTS2.md)
- [README.md](README.md)

### Project Management

- [Research Roadmap](08_Project_Management/Roadmap.md)
- [Current TODO](08_Project_Management/current_october_november_todo.md)
- [Weekly Plan 03](08_Project_Management/weekly_plan_03.md)
- [Previous Weekly Plan](08_Project_Management/weekly_plan_02.md)

### Research Models

- [Sensing Objective](05_My_Research/Sensing_Objective_v0.2.md)
- [Rigid-Body Sensing Design](05_My_Research/Rigid_Body_Sensing_Design.md)
- [Workspace Boundary](05_My_Research/Workspace_Boundary_v0.2_2026-10-20.md)

### Literature

- [Existing Literature Review](02_Paper_Reading/Literature_Review/workspace%20definition/anchor%20point%20and%20attachment%20point%20define.md)
- `02_Paper_Reading/Literature_Review/Phase_B_Method_Selection_2026-11-02.md` — companion literature file; check repository upload status.

### Research Code and Logs

- [MATLAB Code](04_Code_Exercises/MATLAB/)
- [October Research Log](06_Research_Log/2026-10/)
- `06_Research_Log/2026-11/` — current Phase B experiment records.

---

## 12. Research Milestone

**Current Milestone: Establish a validated six-cable reference configuration.**

The next milestone requires:

- Multi-pose geometry evaluation.
- Sensing Jacobian and uncertainty evaluation.
- Pose-estimation accuracy evaluation.
- Workspace-level configuration improvement.
- Independent validation.

Seven- and eight-cable extensions will follow after sufficient six-cable reference validation.

**Guiding Principle:**

> Research questions determine the methods. Numerical evidence determines the configuration. Additional cables are introduced only when their benefits and requirements can be evaluated meaningfully.
