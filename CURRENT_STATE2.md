# Current Research State

**Last Updated:** 2026-10-30  
**Current Phase:** Phase B — Balloon-Specific Cable Sensing Design  
**Current Task:** B1 — Geometry and Configuration Definition  
**Primary Tool:** MATLAB  
**Status:** A1–A5 core method implementations completed; application-specific configuration design pending.

---

## 1. Research Direction

### Long-Term Goal

Develop a cable-based measurement system to estimate the position, orientation, and eventually deformation or shape of a passively moving balloon-like object.

The application is motivated by intragastric balloon monitoring in a simplified gastric environment.

The research focuses on **measurement and state estimation**, rather than active trajectory control.

### Current Research Question

> How do cable number, anchor placement, and attachment placement affect the feasibility, identifiability, and pose-estimation accuracy of a passively moving balloon-like object?

### Current Scope

The current study focuses on:

- Three-dimensional rigid-body pose estimation (6-DOF).
- A simplified gastric boundary.
- A 550 mL rigid spherical balloon proxy.
- Six-, seven-, and eight-cable configurations.
- Cable-length-based measurements.
- Unknown and passive balloon motion.
- Motor-assisted low-tension cable tracking as a proposed physical architecture.

Deformation estimation and shape reconstruction remain future research extensions.

---

## 2. Research Baseline

| Parameter | Current Definition | Status |
|---|---|---|
| Application | Intragastric balloon sensing | Research context |
| Population reference | Adult female | Initial focus |
| Environment | Simplified 3D gastric boundary | Candidate model |
| Coordinate axes | X = Length, Y = Width, Z = Height | Defined |
| Balloon volume | 550 mL | Selected engineering baseline |
| Balloon geometry | Rigid sphere | Initial approximation |
| Equivalent sphere diameter | Approximately 101.7 mm | Derived from volume |
| Estimated state | 3D position and orientation | 6-DOF |
| Object motion | Passive and unknown | Research assumption |
| Cable number | 6 / 7 / 8 | Comparison candidates |
| Anchor points | Fixed in world frame | Design pending |
| Attachment points | Fixed in balloon body frame for rigid study | Design pending |
| Primary measurements | Cable lengths | Selected |
| Tension tracking | Motor-assisted low positive tension | Proposed; not validated |
| Measurement noise | 1 mm standard deviation in Paper 4 tests | Simulation assumption |
| Accuracy requirement | Not yet established | Research gap |

The 550 mL sphere and simplified gastric envelope are engineering approximations. They are not validated anatomical or clinical movement models.

---

## 3. Completed Research — Phase A

The A1–A5 tasks investigated existing methods for cable feasibility, workspace analysis, and pose estimation.

These methods form the computational foundation for Phase B.

### A1 — Tension Factor and Wrench Feasibility

**Reference:** Paper 2 — RREF / Tension Factor method.

Completed:

- Reproduced the planar cable tension example.
- Applied RREF to determine relative cable force ratios.
- Calculated the Tension Factor.
- Verified equilibrium residuals.

**Key result:** The reference planar example produced TF approximately 0.6671.

**Transfer to Phase B:** Cable tension feasibility and relative tension analysis.

### A2 — Feasible Cable Anchor Regions

**Reference:** Paper 3 — Algorithm 1.

Completed:

- Constructed a seven-cable 3D wrench matrix.
- Implemented the RREF-based feasibility formulation.
- Evaluated candidate cable anchor locations.
- Applied strict positive self-stress / wrench-closure conditions.
- Verified linear relationships for the feasibility inequalities.

**Key result:** 29,291 feasible points out of 68,921 candidate locations for the selected single-pose A7 example.

**Transfer to Phase B:** Candidate anchor-region screening.

### A3 — Multi-Pose Feasible Region Intersection

**Reference:** Paper 3 — Algorithm 2.

Completed:

- Implemented the intersection of feasible regions across eight sampled platform positions.
- Compared single-pose and multi-pose feasibility.
- Evaluated all seven cables in the reference configuration.
- Verified retained candidate points against the sampled-pose conditions.

**Key result:** The A7 eight-pose intersection retained 1,005 candidate locations in the selected sampling grid.

**Transfer to Phase B:** Configuration feasibility across multiple balloon poses.

### A4 — Forward Kinematics and Pose Estimation Uncertainty

**Reference:** Paper 4 — Forward Kinematics and Covariance Bounds.

Completed:

- Implemented an eight-cable 3D measurement model.
- Derived the 8×6 measurement Jacobian.
- Verified translation and rotation Jacobians by finite differences.
- Tested combined translation and rotation perturbations.
- Implemented a Gauss–Newton 6-DOF pose estimator.
- Verified noiseless pose recovery.
- Added Gaussian cable-length measurement noise.
- Computed local pose-estimation covariance.
- Performed 100-trial Monte Carlo validation.
- Evaluated Bias, RMSE, Standard Deviation, and 3σ Coverage.
- Computed NEES and the 95% ANEES consistency test.

**Selected validated results:**

| Metric | Result |
|---|---|
| Jacobian rank | 6 |
| Maximum numerical Jacobian error | 4.102 × 10⁻¹¹ |
| Noiseless pose recovery | 4 iterations; near-zero pose error |
| Cable-length noise standard deviation | 1 mm |
| Predicted position standard deviations | X: 0.5018, Y: 0.9462, Z: 0.6340 mm |
| Monte Carlo position standard deviations | X: 0.5170, Y: 0.9731, Z: 0.6753 mm |
| Average NEES | 6.6459 |
| 95% ANEES acceptance interval | [5.3402, 6.6977] |
| Statistical consistency test | Passed |

**Limitations:**

- Results are based on a known rigid-body geometry.
- The principal Monte Carlo experiment uses one fixed true pose.
- Measurement noise and geometry are idealised.
- The implemented estimator uses Gauss–Newton rather than reproducing every published solver.
- Results do not establish actual hardware measurement accuracy or global FK uniqueness.

**Transfer to Phase B:** Pose identifiability, uncertainty prediction, Monte Carlo accuracy evaluation, and statistical validation.

### A5 — 3D Workspace Sampling

**Reference:** Paper 1 — Workspace review and related feasibility concepts.

Completed:

- Created a 3D platform-position sampling grid.
- Evaluated wrench feasibility.
- Added cable-length constraints.
- Compared roll angles of −10°, 0°, and +10°.
- Computed the intersection of feasible positions across sampled orientations.
- Visualised feasible workspace regions.

**Selected results:**

| Metric | Feasible Points |
|---|---:|
| Total sampled positions | 2,197 |
| WCC-feasible positions at 0° | 861 |
| WCC and length feasible at 0° | 765 |
| Combined feasible at −10° roll | 623 |
| Combined feasible at +10° roll | 175 |
| Feasible at all three sampled roll angles | 95 |

**Limitations:**

- The sampling region is an illustrative engineering domain.
- Cable-length limits are assumed.
- Only three discrete roll values were considered.
- Gastric sphere containment, cable–balloon interference, and full 6-DOF orientation coverage were not established.
- The results do not describe the true gastric workspace.

**Transfer to Phase B:** Geometric and sensing-feasible workspace sampling.

---

## 4. Established Mathematical Framework

### 4.1 Cable Measurement Model

For cable i:

\[
B_i=P+Rr_i
\]

\[
L_i=\|B_i-A_i\|
\]

where:

- \(A_i\): Fixed anchor in the world frame.
- \(r_i\): Attachment in the body frame.
- \(P\): Object-centre position.
- \(R\): Object orientation.
- \(B_i\): Attachment in the world frame.

The measurement model is:

\[
L_{\mathrm{meas}}=g(P,R)+v
\]

### 4.2 Measurement Jacobian

For small world-frame pose perturbations:

\[
\delta L\approx H\delta q
\]

\[
H\in\mathbb{R}^{n\times6}
\]

Local full-pose identifiability requires:

\[
\operatorname{rank}(H)=6
\]

Full rank does not guarantee globally unique pose estimation, sufficient precision, or mechanical feasibility.

### 4.3 Pose Estimation and Covariance

Pose estimation can be formulated as nonlinear least squares:

\[
(\hat P,\hat R)=
\arg\min_{P,R}
\|L_{\mathrm{meas}}-g(P,R)\|^2
\]

For a locally linearised, full-rank model with measurement covariance \(V\):

\[
P_{\mathrm{cov}}\approx
(H^TV^{-1}H)^{-1}
\]

This predicts local pose uncertainty under the stated assumptions.

### 4.4 Feasibility and Sensing Quality

The following must be evaluated separately:

1. Geometric feasibility.
2. Cable-length and routing constraints.
3. Cable-tension / wrench feasibility.
4. Local measurement identifiability.
5. Pose-estimation uncertainty and accuracy.

A wrench-feasible configuration is not automatically a high-quality sensing configuration.

---

## 5. Current Phase — Phase B

**Objective:** Apply the validated methods to a balloon-specific cable sensing configuration.

### B1 — Geometry and Candidate Regions

**Current task.**

Define:

- Simplified gastric boundary.
- 550 mL rigid spherical balloon.
- Feasible sphere-centre region.
- Candidate anchor regions.
- Candidate attachment regions.
- Coordinate systems and physical constraints.

**Expected deliverables:**

- A clearly documented 3D geometry baseline.
- MATLAB visualisation of the gastric boundary and balloon.
- Initial candidate anchor/attachment regions.
- A distinction between literature evidence, derived dimensions, and assumptions.

### B2 — Cable Configuration Generation

Construct comparable six-, seven-, and eight-cable configurations.

Preserve consistent geometry assumptions and measurement conditions.

### B3 — Feasibility Screening

Evaluate:

- Object containment.
- Cable length limits.
- Cable routing and interference.
- Positive-tension feasibility.
- Multi-pose workspace coverage.

### B4 — Sensing Quality Evaluation

Evaluate:

- Jacobian rank.
- Scale-aware measurement conditioning.
- Pose covariance.
- Position and orientation RMSE.
- Noise sensitivity.
- Estimator convergence and failure cases.

### B5 — Configuration Selection

Compare candidates using both feasibility and sensing performance.

Select a justified initial configuration for further investigation.

---

## 6. Open Research Questions

| Priority | Research Question | Status |
|---|---|---|
| High | Which gastric boundary parameters should be used for the engineering model? | B1 |
| High | Where can fixed anchors physically be placed? | B1 |
| High | Where can attachments be placed on the spherical balloon? | B1 |
| High | How should cable–balloon interference be modelled? | B1/B3 |
| High | How do 6, 7, and 8 cables compare under identical conditions? | B2–B4 |
| High | Which configurations retain rank 6 over the required workspace? | B4 |
| High | Which feasible configurations minimise pose uncertainty? | B4/B5 |
| Medium | What measurement noise and calibration models are realistic? | Pending |
| Medium | How can low cable tension be maintained without disturbing passive motion? | Pending |
| Medium | How can independent ground truth be measured experimentally? | Pending |
| Future | Can balloon deformation be estimated together with pose? | Future extension |

---

## 7. Immediate Next Action

**Start B1 — Geometry Definition.**

Recommended sequence:

1. Review the existing gastric boundary evidence.
2. Confirm the selected engineering dimensions and coordinate convention.
3. Define the 550 mL rigid sphere and its feasible centre region.
4. Identify candidate anchor and attachment regions.
5. Create a reproducible MATLAB geometry model.

Do not begin cable-placement optimisation before the geometry assumptions and feasibility constraints are explicit.

---

## 8. Main Repository References

### Research Guidance

- [AGENTS2.md](AGENTS2.md)
- [README.md](README.md)

### Planning

- [Research Roadmap](08_Project_Management/Roadmap.md)
- [October–November TODO](08_Project_Management/current_october_november_todo.md)
- [Weekly Plan 02](08_Project_Management/weekly_plan_02.md)

### Research Models

- [Sensing Objective](05_My_Research/Sensing_Objective_v0.2.md)
- [Rigid-Body Sensing Design](05_My_Research/Rigid_Body_Sensing_Design.md)
- [Workspace Boundary](05_My_Research/Workspace_Boundary_v0.2_2026-10-20.md)

### Completed Method Records

- [MATLAB Code](04_Code_Exercises/MATLAB/)
- [October Research Log](06_Research_Log/2026-10/)

---

**Next Milestone:** Establish a balloon-specific 3D geometry baseline and candidate anchor/attachment regions before comparing 6-, 7-, and 8-cable sensing configurations.
