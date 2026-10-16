# Research Roadmap

**Last Updated:** 2026-10-16  
**Current Phase:** Phase 2 — Simplified Model and Sensing Objective  
**Research Focus:** Cable Configuration and Position Measurement

---

## 1. Research Goal

Develop a cable-based sensing system to estimate the position and eventually deformation or shape of a passively moving balloon-like object.

### Current Research Question

> How do cable number and placement affect the accuracy and reliability of position estimation for a 550 mL rigid spherical object moving within a simplified gastric workspace?

The immediate focus is rigid-body position measurement, rather than complex balloon dynamics or shape reconstruction.

---

## 2. Research Development Phases

### Phase 1 — Application Definition and Clinical Evidence

**Status:** Initial synthesis completed.

**Research Question**

What application evidence and physical references are needed to define the initial sensing problem?

**Deliverables**

- Clinical evidence summary (A–D)
- Adult female target-population rationale
- 550 mL balloon-volume reference
- Preliminary workspace assumptions

**Completion Criteria**

- The application and initial object size are justified.
- Reported measurements and engineering assumptions are distinguished.
- Missing anatomical and motion data are identified.

**Remaining Limitation:** Gastric outline dimensions still require evidence or explicit engineering assumptions.

---

### Phase 2 — Simplified Model and Sensing Objective

**Status:** Current priority.

**Research Question**

How should the rigid-body object, gastric boundary, and estimated state be defined?

**Model Baseline**

- Simplified gastric outline based on length, width, and height
- 550 mL rigid spherical object
- Equivalent spherical diameter: approximately 10.17 cm
- Initial planar position model: proposed
- Orientation constraints: to be specified

**Deliverables**

- Simplified gastric workspace model
- Rigid-sphere geometry
- Selected state variables
- Cable-length measurement model
- Verified measurement Jacobian

**Completion Criteria**

- Model assumptions and physical units are documented.
- The rigid object fits within the defined geometric test region.
- The initial state and orientation assumptions are justified.
- The measurement model is numerically verified.

---

### Phase 3 — Cable Configuration and Sensing Quality

**Status:** Next phase.

**Research Question**

How many cables are required, and where should anchors and attachment points be placed?

**Design Variables**

- Cable number
- Anchor-point positions
- Attachment-point positions

**Evaluation Metrics**

- Jacobian rank
- Measurement sensitivity and conditioning
- Position-estimation uncertainty
- Measurement accuracy
- Sensing workspace coverage
- Mechanical feasibility

**Deliverables**

- Candidate cable configurations
- MATLAB configuration comparison
- Sensing-quality and workspace maps
- Preferred candidate configuration

**Completion Criteria**

- Candidate configurations are compared under common conditions.
- Measurement ambiguity and poorly conditioned regions are identified.
- The selected configuration is justified by quantitative results.
- Physical limitations are documented.

---

### Phase 4 — Rigid-Body Measurement Validation

**Status:** Planned.

**Research Question**

Can the selected cable configuration accurately estimate rigid-body position from cable measurements?

**Validation Scenarios**

- Known static positions
- Straight-line motion
- Different movement speeds
- Additional motion cases where required

**Deliverables**

- MATLAB state estimator
- Measurement-noise analysis
- Rigid-body experimental setup, if feasible
- Ground-truth comparison
- Measurement accuracy and repeatability results

**Completion Criteria**

- Object position is estimated without using the true trajectory as estimator input.
- Estimation errors are quantified against ground truth.
- Measurement uncertainty and repeatability are evaluated.
- Performance is compared against defined accuracy requirements.

---

### Phase 5 — Deformable-Balloon Extension

**Status:** Future.

**Research Question**

Can the validated rigid-body sensing method be extended to measure balloon deformation?

**Deliverables**

- Simplified deformation representation
- Deformable-balloon attachment concept
- Extended measurement model
- Preliminary deformation-estimation results

**Completion Criteria**

- Deformation variables are explicitly defined.
- Their identifiability is investigated.
- Deformation estimates are compared with independent reference measurements.

---

### Phase 6 — Integrated System Evaluation

**Status:** Future.

**Research Question**

How reliably can the sensing system estimate object states under more complex passive motion and deformation?

**Deliverables**

- Integrated sensing-system evaluation
- Accuracy and robustness analysis
- Workspace and physical limitation assessment
- Final research conclusions

**Completion Criteria**

- Major research objectives are evaluated quantitatively.
- Experimental and modelling limitations are documented.
- Research contributions and future work are identified.

---

## 3. Research Milestones

| Milestone | Expected Outcome | Status |
|---|---|---|
| M1 | Clinical evidence synthesis | Initial synthesis completed |
| M2 | 550 mL rigid-object reference | Defined |
| M3 | Simplified gastric boundary | Pending |
| M4 | Initial sensing objective and measurement model | In progress |
| M5 | Cable configuration comparison | Planned |
| M6 | Sensing workspace and accuracy evaluation | Planned |
| M7 | Rigid-body experimental validation | Planned |
| M8 | Deformable-balloon sensing | Future |
| M9 | Integrated evaluation | Future |

Milestones should be marked complete only when their stated criteria have been met.

---

## 4. Current Research Priority

**Focus: Phase 2 → Phase 3**

The next research decisions are:

1. Define the initial position state and orientation constraints.
2. Establish a simplified gastric boundary.
3. Verify the rigid-body cable measurement model.
4. Compare candidate cable numbers and placements.
5. Evaluate estimation accuracy across the feasible region.

The initial planar model will reuse previous MATLAB work. Three-dimensional position sensing may be introduced after the initial measurement principle is validated.

---

## 5. Related Documents

- [Current Research State](../CURRENT_STATE2.md) — Progress and unresolved questions
- [Research Guidelines](../AGENTS2.md) — Modelling and validation rules
- [Research TODO](TODO.md) — Actionable research tasks
- [Weekly Plan](WEEKLY_PLAN.md) — Daily research schedule
- [Rigid-Body Sensing Design](../05_My_Research/Rigid_Body_Sensing_Design_v0.1.md) — Technical model and methods

---

**Guiding Principle:** Validate accurate rigid-body position sensing before extending the system to deformable-balloon reconstruction.
