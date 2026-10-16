# Research Roadmap

Last updated: 2026-10-16

---

# 1. Research Goal

Develop a cable-robot-based measurement and sensing system capable of estimating the position, orientation, and eventually deformation or shape of a passively moving balloon-like object.

The system should use cable measurements to estimate object states without requiring a known motion trajectory as input.

## Long-Term Research Question

> Can cable length, displacement, and/or tension measurements be used to reconstruct the position and shape of a passively moving deformable balloon?

## Current Research Question

> For a simplified rigid object, what cable number and geometric configuration are required to achieve reliable state estimation with a specified measurement accuracy?

The current priority is to validate rigid-body sensing before introducing complex balloon deformation.

---

# 2. Research Development Strategy

The research follows a question-driven workflow:

```text
Research Problem
       ↓
Research Question
       ↓
Sensing Objective
       ↓
System Geometry
       ↓
Measurement Model
       ↓
Simulation
       ↓
Experiment
       ↓
Validation
       ↓
Next Research Question
```

## Research Principles

1. Research questions drive learning and implementation.
2. Begin with the simplest model that can answer the current question.
3. Prioritise measurement and estimation over active trajectory control.
4. Do not assume that passive object motion is known by the estimator.
5. Determine cable number from independent measurement information and sensing requirements.
6. Validate rigid-body measurements before investigating deformable-body reconstruction.
7. Separate clinically reported parameters, derived references, and engineering assumptions.
8. Use MATLAB as the primary simulation platform.
9. Use CASPR as a secondary reference or verification platform when appropriate.
10. Define measurable validation criteria for each development phase.

---

# 3. Research Phases

## Phase 1 — Application Definition and Clinical Evidence

**Status: Initial evidence synthesis completed; further evidence remains necessary.**

### Research Question

What clinically relevant balloon-state changes should the sensing system detect, and what physical references are available?

### Main Tasks

- Investigate current clinical follow-up and monitoring.
- Review balloon volume and morphology.
- Investigate balloon displacement and migration.
- Identify available physical dimensions.
- Distinguish measured parameters from derived values.
- Identify missing motion and deformation information.

### Current Results

Evidence A — Clinical Monitoring:
- Intermittent follow-up
- Symptom-driven investigation
- Imaging provides individual observations
- Continuous quantitative tracking is not routinely established

Evidence B — Volume and Morphology:
- Nominal and adjustable filling volumes
- Abnormal hyperinflation cases
- Limited quantitative collapse information

Evidence C — Position and Migration:
- Documented migration and obstruction events
- Clinical records emphasise diagnosed position and outcomes
- Normal trajectories and velocities remain unknown

Evidence D — Physical Dimensions:
- Product filling volumes
- Selected imaging measurements
- Equivalent spherical diameter calculations
- Incomplete three-dimensional geometry

### Preliminary Engineering Output

Workspace Definition — Draft 1.0

- Nominal filling: approximately 550–700 mL
- Adjustable examples: approximately 380–850 mL
- Reported hyperinflation cases: 1,011 / 1,513 mL
- Nominal equivalent spherical diameter: approximately 10.17–11.02 cm
- Abnormal equivalent spherical diameter: approximately 12.45–14.24 cm
- Selected abnormal CT dimensions: 12.7 × 11.6 × 13.2 cm

These values provide preliminary test references rather than complete workspace boundaries.

### Remaining Questions

- Normal balloon motion range
- Motion velocity and trajectory
- Collapsed balloon dimensions
- Complete deformable shape boundaries
- Three-dimensional gastric anatomical limits

### Deliverables

- Clinical evidence summary
- Evidence A–D comparison
- Workspace Draft 1.0
- List of evidence-supported and unknown parameters

---

## Phase 2 — Sensing Objective and Rigid-Body Model

**Status: Current priority.**

### Research Question

What object state should the first sensing system estimate?

### Main Tasks

1. Select the initial sensing objective.
2. Determine the required degrees of freedom.
3. Define a rigid-body test object.
4. Establish world and body coordinate systems.
5. Define the object state vector.
6. Derive the geometric relationship between cable length and object state.
7. Define measurable outputs and sensor assumptions.
8. Specify how ground truth will be obtained.

### Candidate State Models

Position-only model:

\[
q=[x,y]^T
\]

Planar rigid-body pose model:

\[
q=[x,y,\theta]^T
\]

The first measurement objective must be selected explicitly before determining the final candidate cable configurations.

### Measurement Principle

```text
Rigid-Body Motion
        ↓
Cable Length / Displacement Changes
        ↓
Sensor Measurements
        ↓
Measurement Model
        ↓
State Estimation
        ↓
Estimated Position / Orientation
```

### Deliverables

- Defined sensing objective
- State vector and coordinate definitions
- Rigid-body measurement model
- Initial MATLAB simulation
- Ground-truth and measurement-error definitions

### Completion Criteria

- State variables are explicitly defined.
- Cable lengths can be calculated from rigid-body state.
- Measurement Jacobian is derived and numerically checked.
- A test scenario and independent ground-truth method are specified.

---

## Phase 3 — Cable Configuration and Sensing Quality

**Status: Planned after the initial sensing objective is defined.**

### Research Question

How many cables are required, and where should anchors and attachment points be located?

### Main Tasks

1. Define candidate cable numbers.
2. Define external anchor points.
3. Define body attachment points.
4. Compare alternative geometric configurations.
5. Derive the corresponding measurement Jacobians.
6. Evaluate local identifiability.
7. Investigate measurement sensitivity and conditioning.
8. Include sensor-noise assumptions.
9. Evaluate sensing workspace coverage.
10. Investigate physical cable and attachment constraints.

### Core Evaluation Metrics

- Jacobian rank
- Singular values
- Minimum singular value
- Condition number
- Measurement noise sensitivity
- Estimation error
- Workspace coverage
- Redundancy and robustness

Coordinate scaling and measurement noise must be considered when comparing sensing metrics.

### Important Distinctions

Cable number is not automatically equal to the number of state variables.

A candidate configuration is valid only when the necessary independent measurement information is available over the target operating region.

The geometric sensing workspace must also be distinguished from tension and mechanical feasibility.

### Deliverables

- Candidate cable configurations
- MATLAB configuration comparison
- Jacobian and sensing-quality results
- Preliminary sensing workspace maps
- Selected configuration for experimental validation

### Completion Criteria

- Candidate configurations can be compared using common metrics.
- Rank-deficient or poorly conditioned configurations are identified.
- A preferred test configuration is justified.
- Remaining physical constraints are documented.

---

## Phase 4 — Rigid-Body Measurement and Experimental Validation

**Status: Planned.**

### Research Question

Can the selected cable configuration accurately estimate rigid-body motion from measured cable responses?

### Main Tasks

1. Reproduce or adapt a reference cable-robot platform.
2. Select or construct a rigid-body test object.
3. Implement the chosen cable arrangement.
4. Select and calibrate suitable sensors.
5. Develop data acquisition.
6. Perform static calibration tests.
7. Introduce simplified motion scenarios.
8. Estimate the rigid-body state from measured cable data.
9. Compare estimates against independent ground truth.
10. Investigate repeatability and sensitivity to noise.

### Initial Experimental Scenarios

Test A — Static positions:
- Known object positions
- Cable-length measurements
- Calibration and estimation error

Test B — Straight-line motion:
- Translation along selected directions
- Different displacement amplitudes
- Position estimation

Test C — Different motion speeds:
- Slow motion
- Medium motion
- Fast motion
- Measurement response and estimation error

Test D — Rotation, if required:
- Known angular displacement
- Orientation estimation
- Combined translation and rotation

The trajectories may be prescribed for experimental repeatability, but must not be treated as known inputs to the estimator.

### Evaluation Metrics

- Position estimation RMSE
- Orientation estimation error, if applicable
- Maximum estimation error
- Bias
- Measurement repeatability
- Noise sensitivity
- Valid sensing region

### Deliverables

- Rigid-body experimental platform
- Sensor calibration procedure
- MATLAB state estimator
- Experimental datasets
- Error and repeatability analysis
- Rigid-body measurement validation report

### Completion Criteria

- Cable measurements can be acquired reliably.
- State estimates can be reconstructed from measured data.
- Estimated states are compared with independent ground truth.
- Results are evaluated against pre-defined accuracy requirements.
- Main error sources and limitations are identified.

---

## Phase 5 — Deformable-Balloon Extension

**Status: Future research stage.**

### Research Question

Can a sensing method validated on a rigid body be extended to estimate balloon deformation and shape?

### Main Tasks

1. Define simplified balloon deformation scenarios.
2. Select a suitable deformation representation.
3. Investigate attachment behaviour on a deformable surface.
4. Determine additional state variables.
5. Evaluate whether additional cable measurements are required.
6. Extend the measurement model.
7. Design simplified inflation, deflation, and deformation tests.
8. Investigate available reconstruction data from collaborators.
9. Estimate deformation parameters.
10. Evaluate shape reconstruction accuracy.

### Example Deformation Scenarios

- Approximately spherical baseline
- Uniform expansion
- Uniform contraction
- Asymmetric deformation
- Partial collapse

These are proposed engineering test scenarios, not claims that they represent the full natural balloon
