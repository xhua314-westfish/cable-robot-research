# Research Roadmap

**Last Updated:** 2026-10-19  
**Current Phase:** Phase 2 — 3D Rigid-Body Sensing Model  
**Research Focus:** 6-DOF Pose Estimation and Cable Configuration Design

---

## 1. Research Goal

<!-- UPDATED: Changed position-only sensing to full 3D pose sensing. -->

Develop a cable-based sensing system to estimate the three-dimensional position and orientation of a passively moving rigid spherical object.

The long-term research direction is to extend the validated measurement method to a deformable balloon-like object.

### Current Research Question

> How do seven- and eight-cable configurations affect the accuracy, identifiability, and feasible sensing workspace of a passively moving 6-DOF rigid spherical object?

**Research Baseline**

- 550 mL rigid spherical object.
- Simplified 3D gastric environment.
- Passive and unknown object motion.
- Six-cable reference configuration.
- Seven- and eight-cable primary configurations.
- Motor-assisted low-tension cable tracking.

The immediate focus is **3D rigid-body pose sensing**, not balloon deformation reconstruction.

---

## 2. Research Development Phases

### Phase 1 — Application Definition and Clinical Evidence

**Status:** Initial synthesis completed.

**Research Question**

What clinical and physical evidence is required to define the initial sensing application?

**Deliverables**

- Clinical evidence summary (A–D).
- Adult female target-population rationale.
- 550 mL balloon-volume reference.
- Preliminary gastric geometry assumptions.

**Completion Criteria**

- The application and object-size reference are justified.
- Reported measurements and engineering assumptions are distinguished.
- Missing anatomical and motion data are identified.

**Remaining Limitation:** Gastric length, width, and height require additional evidence or explicitly documented engineering assumptions.

---

### Phase 2 — 3D Rigid-Body Model and Sensing Foundation

<!-- UPDATED: Replaced the proposed planar position model. -->

**Status:** Current priority.

**Research Question**

How should the simplified 3D gastric boundary, rigid spherical object, and 6-DOF measurement model be defined?

**Model Baseline**

- Simplified 3D gastric boundary.
- 550 mL rigid sphere.
- Equivalent diameter: approximately 101.7 mm.
- Full 6-DOF rigid-body pose.
- Cable-length measurement model.
- Unknown passive motion.

**Deliverables**

- Confirmed sensing objective.
- Simplified 3D gastric geometry.
- Geometrically feasible sphere-centre region.
- Three-dimensional cable geometry model.
- Verified 6-DOF measurement Jacobian.
- Initial 6-DOF pose estimator.

**Completion Criteria**

- Physical dimensions, coordinate systems, and assumptions are documented.
- The rigid sphere fits within the selected geometric boundary.
- The measurement model is implemented and numerically verified.
- Local pose identifiability is evaluated.
- Initial position and orientation estimation results are available.

**Current Progress:** Sensing scope defined; gastric dimensions and 3D model verification pending.

---

### Phase 3 — Cable Configuration and Sensing Quality

<!-- UPDATED: Defined the 6/7/8 cable comparison strategy. -->

**Status:** Planned next phase.

**Research Question**

How do cable number and three-dimensional anchor and attachment placements influence 6-DOF sensing performance?

**Design Variables**

- Cable number: 6, 7, and 8.
- Three-dimensional anchor positions.
- Three-dimensional attachment positions.

**Configuration Strategy**

- Six cables: reference baseline.
- Seven cables: primary candidate A.
- Eight cables: primary candidate B.

**Evaluation Metrics**

- Jacobian rank and conditioning.
- Position-estimation error.
- Orientation-estimation error.
- Measurement-noise sensitivity.
- Pose-estimation reliability.
- Sensing workspace coverage.
- Cable-routing and attachment feasibility.
- Mechanical complexity.

**Deliverables**

- Candidate 3D cable configurations.
- MATLAB configuration-comparison results.
- Pose-estimation error analysis.
- Sensing workspace maps.
- Seven- versus eight-cable comparison.
- Preliminary preferred configuration.

**Completion Criteria**

- Candidate configurations are compared under consistent conditions.
- Anchor and attachment effects are evaluated.
- Poorly conditioned or ambiguous pose regions are identified.
- Measurement accuracy and workspace coverage are quantified.
- The preferred configuration is justified by quantitative results.
- Major physical limitations are documented.

---

### Phase 4 — Rigid-Body Sensing Validation

<!-- UPDATED: Added 6-DOF validation and low-tension feasibility. -->

**Status:** Planned.

**Research Question**

Can the selected cable configuration reliably estimate the position and orientation of a passively moving rigid sphere?

**Validation Scenarios**

- Known static poses.
- Single-axis translations.
- Single-axis rotations.
- Combined 3D translation and rotation.
- Irregular passive-motion sequences.
- Different measurement-noise conditions.

**Deliverables**

- Verified 6-DOF pose estimator.
- Position and orientation error results.
- Measurement-noise and calibration analysis.
- Low-tension tracking feasibility assessment.
- Cable-induced motion disturbance assessment.
- Experimental sensing setup, if feasible.
- Independent ground-truth comparison.

**Completion Criteria**

- The object pose is estimated without supplying the true trajectory to the estimator.
- Position and orientation errors are quantified.
- Estimation reliability and ambiguity are evaluated.
- Low-tension tracking limitations are investigated.
- Experimental accuracy and repeatability are reported if a prototype is available.
- Numerical results are clearly distinguished from physical experimental validation.

---

### Phase 5 — Deformable-Balloon Extension

**Status:** Future research extension.

**Research Question**

Can the validated rigid-body sensing method be extended to estimate deformation of a balloon-like object?

**Potential Deliverables**

- Simplified deformation representation.
- Flexible attachment concept.
- Extended measurement model.
- Preliminary deformation-identifiability analysis.
- Initial deformation-estimation results.

**Completion Criteria**

- Deformation variables are defined.
- Measurement identifiability is investigated.
- Deformation estimates are compared with independent reference measurements.

**Scope Note:** This phase is not required to complete the initial 3D rigid-body sensing study.

---

### Phase 6 — Integrated System Evaluation

**Status:** Future research extension.

**Research Question**

How reliably can an integrated cable-based sensing system estimate position, orientation, and deformation under complex passive motion?

**Potential Deliverables**

- Integrated sensing-system evaluation.
- Accuracy and robustness analysis.
- Physical limitations and workspace assessment.
- Extended experimental validation.
- Final integration conclusions.

**Completion Criteria**

- Integrated sensing objectives are quantitatively evaluated.
- Modelling and experimental limitations are documented.
- Research contributions and future developments are identified.

**Scope Note:** Integration with deformable-body sensing remains a long-term research objective.

---

## 3. Research Milestones

<!-- UPDATED: Refined milestones to reflect 3D 6-DOF sensing. -->

| Milestone | Expected Outcome | Status |
|---|---|---|
| M1 | Clinical evidence synthesis | Initial synthesis completed |
| M2 | 550 mL rigid-sphere reference | Defined |
| M3 | 3D 6-DOF sensing objective | Defined — 19 Oct 2026 |
| M4 | Simplified 3D gastric geometry | Pending |
| M5 | Verified 3D cable model and Jacobian | Pending |
| M6 | Initial 6-DOF pose estimator | Planned |
| M7 | 6/7/8-cable configuration comparison | Planned |
| M8 | Sensing workspace and pose-accuracy evaluation | Planned |
| M9 | Low-tension and physical feasibility assessment | Planned |
| M10 | Rigid-body experimental validation | Planned |
| M11 | Deformable-balloon sensing | Future |
| M12 | Integrated sensing evaluation | Future |

Milestones are marked complete only after their stated criteria have been satisfied.

---

## 4. Current Research Priority

<!-- UPDATED: Replaced the planar-to-3D progression with direct 3D development. -->

**Current Focus: Phase 2 → Phase 3**

The immediate research sequence is:

1. Establish literature-supported or explicitly assumed gastric dimensions.
2. Construct the simplified 3D gastric boundary.
3. Determine the feasible rigid-sphere centre region.
4. Implement the 3D cable-length measurement model.
5. Verify the 6-DOF measurement Jacobian.
6. Establish an initial pose estimator.
7. Compare six-, seven-, and eight-cable configurations.
8. Evaluate measurement performance and physical feasibility.

Two-dimensional models may be reused for mathematical verification but are not a separate optimisation stage.

The primary research priority is validating **3D rigid-body pose sensing** before investigating flexible-body deformation.

---

## 5. Related Documents

- [Current Research State](../CURRENT_STATE2.md) — Current progress and unresolved questions.
- [Sensing Objective](../05_My_Research/Sensing_Objective_v0.2.md) — Research scope and cable-number rationale.
- [Rigid-Body Sensing Design](../05_My_Research/Rigid_Body_Sensing_Design.md) — Technical model and evaluation methods.
- [Research Guidelines](../AGENTS2.md) — Modelling and validation rules.
- [Research TODO](TODO.md) — Actionable research tasks.
- [Weekly Plan](WEEKLY_PLAN.md) — Daily research schedule.

---

**Guiding Principle:** Validate full 3D rigid-body pose sensing, compare seven- and eight-cable designs against a six-cable baseline, and assess measurement performance and physical feasibility before extending to deformable-balloon sensing.
