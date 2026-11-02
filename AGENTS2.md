# AGENTS2 — Research and AI Working Rules

**Version:** 0.4  
**Last Updated:** 2026-11-02  
**Project:** Cable-Robot-Based Sensing for a Passive Deformable Balloon  
**Research Strategy:** Research-Question-Driven Learning and Numerical Validation  
**Primary Tool:** MATLAB

---

## 1. Purpose

This document defines the stable working rules for:

- Research planning.
- Mathematical modelling.
- MATLAB implementation.
- Numerical validation.
- Literature selection.
- AI-assisted research.
- GitHub and Codex collaboration.

**Core Principle:**

> Every learning activity, mathematical model, simulation, and experiment must address a clearly defined research question.

This file contains long-term working rules. It should not duplicate daily schedules, experimental results, or frequently changing task statuses.

For the latest research progress, always consult `CURRENT_STATE2.md` and the active research plan.

---

## 2. Research Scope and Scientific Principles

### Long-Term Goal

Develop a cable-based measurement system capable of estimating the position, orientation, and eventually deformation or shape of a passively moving balloon-like object.

The application is motivated by intragastric balloon sensing within a simplified gastric environment.

### Initial Technical Scope

- Three-dimensional rigid-body pose estimation.
- Six-degree-of-freedom position and orientation.
- Simplified gastric engineering boundary.
- 550 mL rigid spherical balloon proxy.
- Six-cable reference configuration.
- Cable-length-based sensing.
- Fixed world-frame anchors.
- Body-frame attachment coordinates.
- Passive and unknown balloon motion.
- Proposed motor-assisted low-tension cable tracking.

Seven- and eight-cable systems are subsequent research extensions.

### Fundamental Rules

1. The balloon moves passively due to external environmental influences.
2. The estimator must not require the true motion trajectory as an input.
3. The system is intended for sensing and estimation, not active trajectory control.
4. Motors may track cable displacement and maintain low tension, but should not prescribe balloon motion.
5. The rigid sphere is an engineering approximation, not a complete deformable-balloon model.
6. The simplified gastric boundary is a geometric assumption, not a validated physiological motion range.
7. Prioritise rigid-body sensing before deformation reconstruction.
8. Distinguish simulated feasibility from experimentally demonstrated capability.
9. Introduce additional cables only when their benefits can be evaluated meaningfully.
10. Select literature methods according to the research question rather than reproducing papers without a specific purpose.

### Important Geometric Consideration

An ideal sphere has rotational symmetry.

The six-degree-of-freedom orientation estimate is meaningful because the selected physical attachment locations are labelled and assumed fixed relative to the rigid balloon body.

If attachments can move or slip on the balloon surface, the rigid-body measurement model must be revised.

---

## 3. Research Phase Rules

The authoritative research roadmap is:

`08_Project_Management/Roadmap.md`

The project follows five phases:

| Phase | Focus |
|---|---|
| Phase 0 | Application and clinical evidence |
| Phase A | Literature-based method reproduction |
| Phase B | Balloon-specific cable sensing design |
| Phase C | Rigid-body sensing validation |
| Phase D | Deformable-balloon sensing |

Current completion status must be obtained from `CURRENT_STATE2.md`, not inferred from this file.

### Phase A Protection

The A1–A5 core methods have been implemented and recorded.

Do not automatically repeat completed Phase A exercises.

Reuse existing scripts and mathematical methods when relevant.

Reopen Phase A only when:

- A verified error affects the current research.
- The selected application requires additional method validation.
- A new research question requires an extension.
- The user explicitly requests further reproduction.

A completed reference-method implementation does not establish validation of the balloon-specific system.

### Phase B Working Order

The overall task structure remains:

B1 — Geometry Definition  
B2 — Initial Configuration Generation  
B3 — Geometric Feasibility  
B4 — Sensing Quality and Accuracy  
B5 — Configuration Optimisation and Selection

For the current six-cable research strategy:

1. Establish an initial geometry and configuration.
2. Evaluate geometric feasibility across multiple positions and orientations.
3. Evaluate measurement sensitivity and uncertainty.
4. Optimise anchor and attachment placement across the required pose set.
5. Validate pose estimation and select a six-cable reference.
6. Extend to seven and eight cables.

The detailed B3–B5 order may alternate between evaluation and optimisation as needed.

**Decision Gate:**

Do not begin seven-/eight-cable design solely because six scalar cable measurements can produce a full-rank Jacobian at one pose.

First establish a numerically justified six-cable reference with documented feasibility and sensing performance.

Global optimality is not required for the reference design, but unsupported optimality claims are prohibited.

---

## 4. Research Context Loading Rules

Before beginning a research task, read the minimum relevant repository context.

### Recommended Loading Order

1. `AGENTS2.md` — Stable AI and research rules.
2. `CURRENT_STATE2.md` — Verified progress and current task.
3. `08_Project_Management/current_october_november_todo.md` — Active tasks and acceptance criteria.
4. `08_Project_Management/weekly_plan_03.md` — Current daily execution plan, while it remains active.
5. `08_Project_Management/Roadmap.md` — Research phases and milestones.
6. Relevant technical files in `05_My_Research/`.
7. Relevant MATLAB scripts and records in `04_Code_Exercises/` and `06_Research_Log/`.

Use the most recent active weekly plan when future plans replace `weekly_plan_03.md`.

Read `weekly_plan_02.md` only when historical Phase A scheduling information is relevant.

### Context Loading Principles

- Read the smallest relevant set of files.
- Prioritise current research state over historical plans.
- Preserve important verified decisions across sessions.
- Do not infer task completion from a checklist alone.
- Do not claim to have read inaccessible files.
- Check whether numerical evidence exists before treating a task as completed.
- Resolve contradictions explicitly.

When files disagree, identify the conflicting statements and use verified experiment records and the current state to determine the correct interpretation.

---

## 5. Standard Research Workflow

Every research task follows:

```text
Research Question
       ↓
Existing Evidence and Assumptions
       ↓
Required Literature / Theory
       ↓
Mathematical Model
       ↓
MATLAB Implementation
       ↓
Numerical Verification
       ↓
Research Interpretation
       ↓
Documentation and Next Decision
```

### Working Rules

1. Define one research question at a time.
2. Identify the expected output and acceptance criteria.
3. Review existing work before creating new code.
4. Learn only the theory necessary for the task.
5. Use the simplest defensible implementation.
6. Verify dimensions, units, equations and results.
7. Explain the physical meaning of the numerical findings.
8. Record limitations and unresolved issues.
9. Do not skip validation to meet a planned date.
10. Do not move to a more advanced method without a demonstrated need.

Avoid unrelated textbook exercises and unnecessary full-paper reproductions.

---

## 6. Mathematical Modelling Rules

Every technical model must identify:

- Coordinate frames.
- State variables and unknowns.
- Inputs and outputs.
- Physical quantities and sensor measurements.
- Units and matrix dimensions.
- Geometric constraints.
- Measurement assumptions.
- Model limitations.

### Units

The current balloon geometry implementation uses:

- Position and distance: millimetres.
- Cable length: millimetres.
- Local rotation increments: radians.
- Forces and tensions, when modelled: newtons.

Any imported formulation using metres must be converted consistently before numerical evaluation.

Do not mix millimetres and metres within a single geometry or Jacobian calculation.

### Cable Geometry Convention

For cable i:

\[
B_i=P+Rr_i
\]

\[
d_i=A_i-B_i
\]

\[
L_i=\|d_i\|
\]

where:

- \(A_i\): Fixed world-frame anchor.
- \(r_i\): Body-frame attachment.
- \(B_i\): World-frame attachment.
- \(P\): Balloon-centre position.
- \(R\): Body-to-world rotation matrix.

The positive direction of \(d_i\) is from the attachment to the anchor.

Maintain this convention in the sensing model.

When reusing wrench matrices from other papers, verify their signs and definitions separately.

### Rigid-Body State

The physical pose is:

\[
P\in\mathbb{R}^3,\qquad R\in SO(3)
\]

A local six-dimensional perturbation is:

\[
\delta q=
\begin{bmatrix}
\delta P\\
\delta\alpha
\end{bmatrix}
\]

where:

- \(\delta P\): Millimetres.
- \(\delta\alpha\): Radians.

Do not confuse a local rotation vector with direct subtraction of global Euler angles.

### Measurement Jacobian

For small pose perturbations:

\[
\delta L\approx H\delta q
\]

with:

\[
H\in\mathbb R^{n\times6}
\]

For the selected cable convention:

\[
u_i=\frac{d_i}{L_i}
\]

\[
s_i=Rr_i
\]

The measurement Jacobian row is:

\[
H_i=
\begin{bmatrix}
-u_i^T&(u_i\times s_i)^T
\end{bmatrix}
\]

The analytical Jacobian must be verified using numerical finite differences for new geometry configurations.

### Jacobian Scaling

Translation and rotation have different physical units.

Use a clearly defined characteristic length when computing scaled condition numbers.

The initial model uses the balloon radius as the characteristic length.

Keep the scaling convention fixed when comparing configurations.

Do not compare unscaled and scaled condition numbers as if they represent the same metric.

---

## 7. Cable Configuration Rules

Cable count and placement must be justified using:

- Local measurement identifiability.
- Jacobian rank and singular values.
- Pose-estimation uncertainty.
- Workspace coverage.
- Interference.
- Sensor and calibration errors.
- Tension feasibility.
- Physical complexity.

### Connection Definitions

**Anchor:** A fixed cable connection or routing point in the world frame.

**Attachment:** A point fixed relative to the balloon body in the rigid-body model.

**Attachment mechanism:** The physical device used to connect the cable to the balloon.

These concepts must remain distinct.

### Six-Cable Reference Rule

Six independent scalar measurements are necessary for unconstrained local 6-DOF length-only sensing.

However:

- Six cables do not guarantee rank six.
- Rank six does not guarantee global uniqueness.
- Good conditioning at one pose does not guarantee good workspace performance.
- Measurement identifiability does not guarantee wrench closure.
- A numerically optimised configuration is not necessarily physically feasible.

### Seven-/Eight-Cable Rule

Additional cables may provide:

- Measurement redundancy.
- Improved estimation conditioning.
- Reduced predicted uncertainty.
- Better coverage in selected configurations.

However, they may also introduce:

- Additional interference.
- Routing complexity.
- Mounting constraints.
- Cable-induced disturbances.
- Increased hardware complexity.

Evaluate benefits and costs under consistent assumptions.

Do not assume that increasing cable count automatically improves the overall design.

---

## 8. Workspace and Feasibility Rules

Keep the following concepts separate:

| Concept | Meaning |
|---|---|
| Engineering boundary | Simplified environment envelope |
| Geometric workspace | Poses satisfying balloon containment |
| Cable-feasible workspace | Poses satisfying defined cable geometry and routing constraints |
| Tension-feasible workspace | Poses satisfying stated mechanical force/tension conditions |
| Sensing-feasible workspace | Poses satisfying specified identifiability and measurement-quality conditions |

The final usable sensing workspace may require the intersection of multiple constraint sets.

### Geometric Evaluation

Evaluate as appropriate:

1. Balloon containment.
2. Cable-length validity.
3. Cable–sphere interference.
4. Cable–cable interference.
5. Anchor and attachment spacing.
6. Mounting and routing constraints.

For initial straight-cable models, distinguish ideal centreline intersections from physical cable clearance.

Do not invent validated cable diameters or safety distances.

### Workspace Evaluation Rules

- Declare the tested position and orientation set.
- Use consistent coordinate frames.
- Define every feasibility condition.
- Record numerical tolerances.
- Record failed poses and causes.
- Distinguish sampled coverage from continuous workspace guarantees.
- Apply identical test sets for configuration comparisons.
- Do not treat tension feasibility as equivalent to sensing accuracy.

### WCC Application Rule

Paper 3's reproduced seven-cable WCC method concerns a positive-tension wrench-feasibility condition.

It is not a universal requirement for passive six-cable pose measurement.

Use WCC only after establishing a physical model in which the relevant tension conditions are meaningful.

---

## 9. Sensing Accuracy and Statistical Validation Rules

Relevant evaluation metrics include:

- Jacobian rank.
- Scaled singular values.
- Scaled condition number.
- Predicted pose covariance.
- Position RMSE.
- Orientation RMSE.
- Estimator convergence rate.
- Bias and standard deviation.
- Measurement-noise sensitivity.
- Geometric calibration sensitivity.
- Monte Carlo validation.
- Statistical consistency tests where appropriate.

### Validation Principles

1. Distinguish true pose, sensor outputs and estimated pose.
2. Verify analytical Jacobians against finite differences.
3. Test noiseless pose estimation before introducing noise.
4. Use documented random seeds and noise assumptions.
5. Compare configurations using common pose sets and noise models.
6. Report convergence failures and ambiguous solutions.
7. Distinguish local covariance predictions from global pose-estimation errors.
8. Evaluate anchor and attachment calibration errors separately from measurement noise.
9. Use independent validation poses after configuration optimisation.
10. Never claim experimentally validated accuracy from simulation results alone.

A prescribed motion may generate synthetic ground truth, but the estimator must not receive the true trajectory or true pose as privileged information.

---

## 10. MATLAB and Code Development Rules

MATLAB is the primary simulation platform.

CASPR may be used for secondary verification when relevant.

### Code Quality

- Prefer readable and modular scripts.
- Use descriptive variable names.
- Record geometry conventions and units.
- Verify matrix dimensions.
- Avoid duplicate geometry and Jacobian implementations.
- Separate parameter definitions, simulation, estimation and evaluation.
- Preserve configuration datasets.
- Use reproducible random seeds.
- Save meaningful numerical outputs.

### Numerical Verification

Before accepting an implementation:

1. Check dimensions and units.
2. Test simple known cases.
3. Verify analytical equations numerically.
4. Evaluate relevant residuals.
5. Check physical and geometric constraints.
6. Record actual output values.
7. Preserve failures.
8. Document limitations.

For geometric interference functions, include tests for intersections, separated segments, near-parallel segments and endpoints.

Do not label unexecuted code as verified.

### Optimisation Rules

Before using an optimiser:

- Define the design variables.
- Define the objective function.
- Define constraints.
- Define training poses.
- Define validation poses.
- Identify the computational budget.
- Preserve the best feasible reference configuration.

Random search may establish an initial candidate, but does not establish global optimality.

Use more complex optimisation methods only when the evaluation model has been verified.

---

## 11. AI-Assisted Daily Research Workflow

The AI should assist with manageable, verifiable research tasks rather than introducing a large number of unrelated concepts at once.

### At the Start of a Research Session

1. Read `CURRENT_STATE2.md`.
2. Read the active TODO and weekly plan.
3. Identify the highest-priority unfinished task.
4. Review relevant mathematical models and existing code.
5. Define the research question.
6. Propose a manageable sequence of work.

### During the Research Session

- Explain mathematical equations and physical meaning.
- Introduce MATLAB code in understandable sections.
- Verify results before extending the model.
- Avoid introducing new algorithms without a specific need.
- Distinguish published methods from new adaptations.
- Interpret numerical outputs carefully.
- Avoid repeating completed lessons without justification.

### At the End of a Research Session

Record:

- Task ID.
- Research question.
- Completed work.
- MATLAB scripts.
- Figures and numerical results.
- Verification status.
- Remaining uncertainty.
- Next research action.

### Session Handoff

When switching to another chat or coding environment, preserve:

```text
Current phase:
Current task:
Research question:
Relevant files:
Verified results:
Unresolved issues:
Next action:
```

Do not rely on chat history alone to preserve project progress.

---

## 12. Repository Maintenance Rules

Each file has one primary responsibility.

| File | Responsibility |
|---|---|
| `README.md` | Project overview |
| `AGENTS2.md` | Stable research and AI rules |
| `CURRENT_STATE2.md` | Current progress and findings |
| `08_Project_Management/Roadmap.md` | Long-term research milestones |
| `08_Project_Management/current_october_november_todo.md` | Active tasks and acceptance criteria |
| `08_Project_Management/weekly_plan_02.md` | Historical Phase A plan |
| `08_Project_Management/weekly_plan_03.md` | Current daily research plan |
| `05_My_Research/` | Technical models and design decisions |
| `04_Code_Exercises/MATLAB/` | MATLAB implementations |
| `06_Research_Log/` | Experimental results |
| `02_Paper_Reading/` | Literature and method selection |

### Update Rules

- Update `CURRENT_STATE2.md` after verified research milestones.
- Update the active TODO when tasks are completed or changed.
- Update the weekly plan during planning and review.
- Update `Roadmap.md` when milestones change.
- Update `AGENTS2.md` only when the working rules change.
- Preserve existing verified results.
- Avoid copying the same numerical results into multiple files.
- Keep obsolete plans as historical records when appropriate.

### Manual GitHub Update Rules

When the user requests manual updates:

1. Read the current repository file.
2. Identify required changes.
3. Provide a complete revised Markdown file or precise replacement sections.
4. Do not modify GitHub directly unless explicitly requested.
5. Update only one file at a time.
6. Verify the updated repository file before continuing.

### Codex Collaboration Rules

When using Codex or another coding agent:

- Read repository instructions and current task context first.
- Work within the active research task.
- Prefer small and reviewable changes.
- Preserve verified results before modifying code.
- Distinguish code execution success from scientific validation.
- Report changed files, tests, actual numerical outputs and unresolved issues.
- Do not automatically commit, push or modify project-wide plans without user approval.

---

## 13. Literature and Evidence Rules

For academic sources, record:

- Exact title.
- Authors and publication year.
- DOI where available.
- Research objective.
- Relevant methodology.
- Applicable equations or algorithms.
- Key assumptions and limitations.
- Relevance to the current research task.

Distinguish the following evidence categories:

| Category | Meaning |
|---|---|
| Reported | Directly stated in a source |
| Derived | Mathematically calculated |
| Assumed | Introduced for modelling |
| Numerically verified | Tested using a specified computation |
| Experimentally validated | Supported by physical measurements |
| Unknown | Not established |

### Literature Selection Rule

Before applying a published algorithm:

1. Identify the research problem it solves.
2. Confirm its main assumptions.
3. Determine whether those assumptions apply to passive sensing.
4. Identify which equations and methods can be reused.
5. Identify which parts require adaptation.
6. Define a numerical verification experiment.

Do not transfer active CDPR control objectives directly into passive measurement optimisation without justification.

The current Phase B literature method catalogue is stored under:

`02_Paper_Reading/Literature_Review/workspace definition/Phase_B_Method_Selection_2026-11-02.md`

Do not invent citations, model parameters, simulation results or experimental accuracy claims.

---

## 14. Guiding Principle

> Use the simplest defensible model that answers the current research question. Verify its numerical behaviour and physical assumptions before proceeding to the next design decision.

### Research Priority Rule

**First:** Validate and improve the six-cable sensing configuration.

**Then:** Compare seven- and eight-cable extensions using consistent criteria.

**Finally:** Extend the validated rigid-body measurement approach toward passive deformable-balloon shape sensing.

The exact active task, completion status and next action must always be read from `CURRENT_STATE2.md` and the latest active research plan, rather than being hard-coded into this file.
