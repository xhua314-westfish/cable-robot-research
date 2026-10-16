# AGENTS2 — Research Working Rules

**Last Updated:** 2026-10-16

**Project:** Cable-Robot-Based Sensing for a Passive Deformable Balloon

---

## 1. Purpose

This file defines the working rules for research, mathematical modelling, MATLAB simulation, validation, and repository maintenance.

The project follows a **research-question-driven approach**.

Core principle:

> Learn, model, simulate, and experiment only when they help answer a defined research question.

Detailed research progress, schedules, and technical designs are maintained in their respective documents.

---

## 2. Current Research Scope

The current study investigates cable-based position sensing using:

- A simplified gastric workspace based on an adult female anatomical reference.
- A 550 mL rigid spherical object (equivalent diameter approximately 10.17 cm).
- Cable length or displacement measurements.
- Candidate cable numbers, anchor locations, and attachment locations.
- Measurement accuracy, identifiability, and workspace coverage.

### Scope Rules

1. Use the gastric outline as a spatial constraint, not as a detailed physiological model.
2. Treat the rigid sphere as an engineering approximation of a gastric balloon.
3. Label any unsupported gastric dimensions as assumptions.
4. Start with a simple planar sensing model before introducing additional degrees of freedom.
5. Do not assume the object trajectory is known by the estimator.
6. Prioritise position estimation before deformation or shape reconstruction.

**Important:** The rigid-body model is the initial validation platform, not the final deformable-balloon model.

---

## 3. Research Workflow

Follow this sequence:

```text
Research Question
       ↓
Assumptions and Evidence
       ↓
Mathematical Model
       ↓
MATLAB Simulation
       ↓
Measurement / Estimation
       ↓
Validation
       ↓
Research Conclusion
```

For each research task:

- Define one clear research question.
- Identify the minimum theory required.
- Reuse previous MATLAB work where appropriate.
- Define a measurable output.
- Validate the result before drawing conclusions.
- Record limitations and the next research decision.

Avoid isolated textbook exercises unless they directly support the current research.

---

## 4. Mathematical Modeling Rules

Every model must specify:

- Coordinate systems
- State variables and degrees of freedom
- Inputs, outputs, and unknowns
- Physical units and matrix dimensions
- Assumptions and constraints
- Measurement relationships
- Model limitations

### Coordinate and Geometry Rules

Clearly distinguish world and body coordinate frames.

For cable \(i\):

\[
B_i=P+R(\theta)r_i
\]

\[
L_i=\|A_i-B_i\|
\]

where:

- \(A_i\): fixed anchor point
- \(r_i\): body-frame attachment point
- \(B_i\): world-frame attachment point
- \(P\): object position

Never mix local and world coordinates without an explicit transformation.

### State Definition

Define the estimated state before selecting cable number.

For example:

- Planar position: \(q=[x,y]^T\)
- Planar pose: \(q=[x,y,\theta]^T\)

A position-only model must explicitly constrain or account for object orientation.

The number of unknown state variables determines the required independent measurement information.

---

## 5. Cable Measurement and Configuration Rules

### Measurement Model

The general measurement relationship is:

\[
y=h(q)+\varepsilon
\]

where \(y\) is the measurement vector, \(q\) is the unknown state, and \(\varepsilon\) represents measurement error.

For cable-length measurements:

\[
\Delta L\approx H(q)\Delta q
\]

\[
H(q)=\frac{\partial h(q)}{\partial q}
\]

In the existing MATLAB convention, \(H=J^T\).

### Cable Configuration

Never select cable number solely from a previous example.

Evaluate candidate configurations using:

- Number of independent measurements
- Jacobian rank
- Measurement sensitivity
- Estimation accuracy
- Sensing workspace coverage
- Cable attachment and routing feasibility
- Redundancy, where needed

Distinguish:

**Anchor placement:** Cable connection locations on the fixed structure.

**Attachment placement:** Cable connection locations on the measured object.

**Attachment mechanism:** The physical method used to connect the cable.

More cables do not automatically guarantee better measurement accuracy.

Full Jacobian rank is a local condition; it does not guarantee global uniqueness.

---

## 6. Workspace and Sensing Quality Rules

Always distinguish three regions:

| Region | Definition |
|---|---|
| Gastric boundary | Simplified spatial envelope |
| Geometric feasibility | Positions where the rigid object fits inside the boundary |
| Sensing workspace | Feasible states meeting measurement requirements |

The gastric boundary must not automatically be treated as the sensing workspace.

### Evaluation Metrics

Use appropriate metrics such as:

- Jacobian rank
- Singular values
- Condition number
- Estimation uncertainty
- Position RMSE
- Workspace coverage
- Noise sensitivity

Interpret metrics physically.

Account for state-variable units, scaling, and measurement noise when comparing conditioning and singular values.

A configuration is acceptable only if it satisfies explicitly defined sensing requirements.

---

## 7. Simulation and Validation Rules

MATLAB is the primary simulation platform.

CASPR is a secondary reference or verification tool.

### Simulation

- Start with simple, reproducible models.
- Verify geometry and equations numerically.
- Check analytical Jacobians using finite differences.
- Test multiple positions and configurations.
- Investigate singular or ambiguous cases.
- Include measurement noise when evaluating accuracy.

### Validation

Distinguish:

- True or reference state
- Simulated or sensor measurement
- Estimated state

Use independent ground truth for experimental validation.

Prescribed motion may generate a test case but must not be supplied directly as the true trajectory to the estimator.

Report errors, failed cases, and model limitations.

**A successful simulation is not automatically proof of measurement accuracy.**

---

## 8. Hardware and Experimental Rules

Hardware selection must follow measurement requirements.

Before choosing sensors, motors, or attachment mechanisms, define:

- Measured physical quantity
- Expected measurement range
- Required resolution and accuracy
- Sampling rate
- Calibration method
- Mechanical constraints
- Ground-truth method

Distinguish physical cable response, raw sensor output, calibrated measurements, and estimated object state.

Investigate cable slack, tension, routing, and friction where relevant.

Do not assume that a conventional cable-driven actuation design is automatically suitable for passive sensing.

---

## 9. Literature and Evidence Rules

Use literature to justify research assumptions and engineering decisions.

For relevant papers, record:

- Title, authors, year, and DOI
- Research objective and method
- Relevant measured data
- Study population and conditions
- Engineering relevance
- Limitations

Always distinguish:

1. **Reported:** Directly supported by a source.
2. **Derived:** Calculated from reported information.
3. **Assumed:** Introduced for engineering simplification.
4. **Validated:** Supported by simulation checks or experimental results within a stated scope.
5. **Unknown:** Not established by current evidence.

Do not represent equivalent spherical diameter as a directly measured balloon diameter.

Do not claim that a simplified stomach model reproduces real gastric motion.

Do not invent literature values or simulation results.

---

## 10. Coding and AI Working Rules

When developing MATLAB code or working with AI:

1. Read `CURRENT_STATE2.md` before starting a new research task.
2. Identify the research question and expected deliverable.
3. Reuse existing verified models and code.
4. Explain the physical meaning of equations and variables.
5. Check matrix dimensions and coordinate conventions.
6. Prefer small, readable, reusable MATLAB functions.
7. Include verification steps and error calculations.
8. Separate assumptions from confirmed results.
9. Preserve original code and important research records.
10. Do not claim unperformed simulations or experiments are complete.

When editing the repository:

- Modify only files relevant to the current task.
- Avoid duplicating content across documents.
- Do not overwrite original research results without review.
- Describe significant changes clearly.
- Keep GitHub updates reviewable and traceable.

---

## 11. Repository Documentation Rules

Each main file has one responsibility.

| File | Responsibility |
|---|---|
| `README.md` | Project overview and navigation |
| `CURRENT_STATE2.md` | Current progress, findings, and open questions |
| `AGENTS2.md` | Research and coding rules |
| `Roadmap.md` | Research phases and milestones |
| `TODO.md` | Current actionable tasks |
| `WEEKLY_PLAN.md` | Weekly and daily research schedule |
| `05_My_Research/` | Research models, methods, and results |
| `06_Research_Log/` | Dated experiments, decisions, and reflections |

### Update Rules

- Update `CURRENT_STATE2.md` after significant research progress.
- Update `TODO.md` when tasks are completed or changed.
- Update `WEEKLY_PLAN.md` during weekly planning and review.
- Update `Roadmap.md` only when major milestones change.
- Update `AGENTS2.md` only when research working rules change.
- Record important findings and decisions in `06_Research_Log/`.

Do not repeatedly copy the same background, roadmap, or task lists into multiple files.

---

## 12. Current Guiding Principle

> Develop the simplest cable-based measurement model that can answer the current research question, validate its accuracy, and use the results to guide the next design decision.

The current priority is rigid-body position sensing.

Deformation and shape reconstruction remain future research extensions.
