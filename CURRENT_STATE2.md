# Current Research State

**Last Updated:** 2026-10-19  
**Research Phase:** 3D Rigid-Body Sensing and Cable Configuration Design  
**Primary Tool:** MATLAB  
**Status:** Research scope defined; 3D modelling and sensing validation pending

---

## 1. Current Research Direction

### Long-Term Goal

Develop a cable-based sensing system to estimate the position, orientation, and eventually deformation or shape of a passively moving balloon-like object.

The research focuses on measurement and state estimation rather than active trajectory control.

### Current Research Objective

<!-- UPDATED: Changed from planar position sensing to full 3D pose sensing. -->

Investigate how cable number and three-dimensional anchor and attachment placements affect rigid-body pose-estimation performance.

**Current Research Question:**

> How do seven- and eight-cable configurations affect the accuracy, identifiability, and feasible sensing workspace of a passively moving 6-DOF rigid spherical object?

A six-cable configuration will be used as a reference baseline.

---

## 2. Simplified Research Baseline

<!-- UPDATED: Replaced the proposed planar model with the selected 3D model. -->

| Parameter | Current Definition | Status |
|---|---|---|
| Application | Intragastric balloon sensing | Research context |
| Population | Adult female reference, prioritising obesity-related evidence | Initial focus |
| Environment | Simplified 3D gastric boundary | Proposed model |
| Gastric dimensions | Length × Width × Height | Evidence pending |
| Measurement object | Rigid spherical balloon proxy | Engineering assumption |
| Balloon volume | 550 mL | Commercial product reference |
| Equivalent diameter | Approximately 101.7 mm | Calculated |
| Initial model | 3D rigid-body sensing | Confirmed direction |
| State | x, y, z, φ, θ, ψ | 6-DOF |
| Object motion | Passive and unknown | Research assumption |
| Cable number | 6 baseline; 7 and 8 primary candidates | Selected study range |
| Anchor positions | 3D fixed mounting points | To be investigated |
| Attachment positions | 3D positions on rigid sphere | To be investigated |
| Cable tracking | Motor-assisted low-tension tracking | Proposed architecture |
| Accuracy requirements | Not yet established | Pending evidence |

### Key Assumptions

<!-- UPDATED: Removed the initial planar-position assumption. -->

- The gastric environment is used only to constrain object movement.
- Detailed stomach anatomy and deformation are excluded initially.
- The 550 mL rigid sphere is an engineering approximation, not an exact gastric balloon geometry.
- The equivalent diameter is calculated from volume rather than clinically measured.
- The object can translate and rotate in three dimensions.
- The object trajectory is unknown to the estimator.
- Cable lengths are the primary measurements for pose estimation.
- Motors maintain low positive cable tension rather than prescribe object motion.
- Cable-induced motion disturbance must eventually be evaluated.
- Two-dimensional models may be reused for mathematical verification, but not as a separate optimisation stage.

The anatomical dimensions, cable configuration, and measurement performance have not yet been validated.

---

## 3. Completed Work

### 3.1 Clinical Evidence Review

Four evidence areas have been investigated:

| Evidence | Main Finding |
|---|---|
| A — Monitoring | Clinical assessment is intermittent; continuous state measurements are not routinely established |
| B — Volume and Morphology | Nominal filling volumes and abnormal expansion cases provide preliminary size references |
| C — Position and Migration | Migration is documented, but normal movement trajectories remain uncertain |
| D — Dimensions | Volume and selected imaging data provide partial geometric information |

**Main conclusion:**

Clinical evidence supports an initial balloon-size reference and motivates position sensing, but does not define a complete gastric motion workspace.

For the current rigid-body study, simplified anatomical boundaries are sufficient as an initial engineering model, provided assumptions are documented.

### 3.2 MATLAB and Cable-Robot Foundation

Previously explored or implemented:

- Coordinate transformations.
- Anchor and attachment geometry.
- Cable vectors and lengths.
- Measurement Jacobian.
- Cable-length velocity and acceleration.
- Rigid-body kinematics and dynamics.
- Cable tension and wrench feasibility.
- Geometric and tension-feasible workspace.
- Measurement sensitivity and pattern similarity.
- Forward kinematics.
- Planar CASPR reference models.

<!-- UPDATED: Clarified the role of previous planar work. -->

The existing four-cable planar MATLAB model will be retained as a mathematical and numerical verification reference.

It is not considered the final sensing configuration.

### 3.3 Research Scope Decisions — 19 October 2026

<!-- NEW: Records the confirmed Monday research decisions. -->

The current research direction was refined through literature review and design discussion.

**Confirmed decisions:**

1. Directly investigate three-dimensional 6-DOF rigid-body pose sensing.
2. Use a 550 mL rigid spherical object as the initial reference.
3. Treat object motion as passive and unknown.
4. Use cable-length measurements to estimate position and orientation.
5. Adopt motor-assisted low-tension cable tracking as the proposed architecture.
6. Use six cables as the minimum-count measurement baseline.
7. Compare seven and eight cables as primary design candidates.
8. Investigate three-dimensional anchor and attachment configurations.
9. Evaluate sensing performance before defining final accuracy requirements.
10. Extend to deformable-balloon sensing only after rigid-body measurement validation.

Detailed definitions and literature justification are maintained in `05_My_Research/Sensing_Objective_v0.2.md`.

---

## 4. Current Technical Findings

### 4.1 Cable Measurement Model

<!-- UPDATED: Generalised the model to 3D position and orientation. -->

For cable i:

\[
B_i=P+Rr_i
\]

\[
L_i=\|A_i-B_i\|
\]

where:

- \(P\): 3D object-centre position.
- \(R\): 3D orientation matrix.
- \(A_i\): fixed anchor point.
- \(r_i\): attachment point in the body frame.
- \(B_i\): attachment point in the world frame.

The measurement relationship is:

\[
y=h(P,R)+\varepsilon
\]

The objective is to estimate the unknown pose \((P,R)\) from cable-length measurements.

### 4.2 Measurement Identifiability

<!-- UPDATED: Changed the Jacobian requirement to 6-DOF. -->

For n cables:

\[
H\in\mathbb{R}^{n\times6}
\]

Local full-pose identifiability requires:

\[
\operatorname{rank}(H)=6
\]

Six independent scalar cable-length measurements are necessary for local identification of an unconstrained six-degree-of-freedom pose.

However:

- Full rank does not guarantee globally unique pose estimation.
- Additional cables do not automatically improve accuracy.
- Jacobian conditioning depends on geometry and coordinate scaling.
- Measurement identifiability does not guarantee physical tension feasibility.

Previous planar simulations indicated measurement coupling between translation and rotation. This motivates a more systematic identifiability analysis in the 3D model.

### 4.3 Workspace Interpretation

Three different regions must be distinguished:

1. **Gastric boundary:** Simplified anatomical environment.
2. **Geometrically feasible workspace:** Poses where the entire rigid sphere fits within the boundary.
3. **Sensing workspace:** Feasible poses satisfying the selected measurement and physical requirements.

The gastric boundary is not automatically the sensing workspace.

For the 3D study, the sensing workspace must account for both position and orientation.

### 4.4 Motor-Assisted Cable Tracking

<!-- NEW: Records the newly selected physical sensing architecture. -->

The proposed system combines passive object motion with motor-assisted cable tracking.

Motors adjust cable payout and retrieval to maintain low positive cable tension.

Their purpose is to reduce slack and support reliable measurement, not to control the balloon trajectory.

Potential limitations include:

- Cable-induced force and torque.
- Cable slack.
- Cable friction and elasticity.
- Motor tracking and calibration errors.
- Cable routing and interference.
- Disturbance of passive object motion.

The tracking architecture is proposed and has not yet been experimentally validated.

---

## 5. Open Research Questions

<!-- UPDATED: Replaced planar questions with 3D sensing and physical feasibility questions. -->

| Priority | Question | Current Status |
|---|---|---|
| High | What 3D gastric dimensions should define the geometric boundary? | Evidence pending |
| High | What is the feasible movement region for the rigid sphere? | Not established |
| High | Where should 3D anchors be located? | Not evaluated |
| High | Where should sphere attachments be located? | Not evaluated |
| High | Can seven and eight cables accurately estimate full 6-DOF pose? | Not validated |
| High | Which configurations avoid poorly conditioned or ambiguous measurements? | Not evaluated |
| Medium | How should cable-length noise and calibration errors be modelled? | Not finalised |
| Medium | How can low cable tension be maintained? | Not validated |
| Medium | How strongly do cables disturb passive motion? | Not evaluated |
| Medium | How should independent 6-DOF ground truth be obtained? | Not designed |
| Future | Can the method extend to balloon deformation sensing? | Not started |

---

## 6. Immediate Next Step

<!-- UPDATED: Changed from planar sensing definition to simplified 3D geometry. -->

**Task 2.2 — Define Simplified 3D Gastric Geometry**

Planned date: Tuesday, 20 October 2026.

The next research tasks are:

1. Review anatomical studies reporting gastric dimensions.
2. Prioritise adult female and obesity-related evidence where available.
3. Define preliminary gastric length, width, and height.
4. Separate literature-supported dimensions from engineering assumptions.
5. Construct a simplified 3D gastric boundary.
6. Determine the geometrically feasible region for the 550 mL rigid sphere.
7. Produce a MATLAB geometry visualisation.

**Expected Outcome:**

A documented 3D geometric boundary and feasible sphere-centre region that can be used for subsequent cable-configuration design.

---

## Related Documents

- [Research Guidelines](AGENTS2.md)
- [Sensing Objective](05_My_Research/Sensing_Objective_v0.2.md)
- [Rigid-Body Sensing Design](05_My_Research/Rigid_Body_Sensing_Design.md)
- [Research Roadmap](08_Project_Management/Roadmap.md)
- [Research TODO](08_Project_Management/TODO.md)
- [Weekly Plan](08_Project_Management/WEEKLY_PLAN.md)
- [Research Log](06_Research_Log/)

---

**Next Milestone:** Establish the simplified 3D geometric workspace before comparing seven- and eight-cable sensing configurations.
