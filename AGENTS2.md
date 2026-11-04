
# AGENTS2 — Research and AI Working Rules

**Version:** 0.5
**Last Updated:** 2026-11-04
**Project:** Cable-Robot-Based Sensing for a Passive Deformable Balloon
**Research Strategy:** Research-Question-Driven, Prototype-First and Parallel Research
**Primary Tool:** MATLAB

---

This document defines the stable working rules for AI-assisted research, mathematical modelling, MATLAB implementation, experimental validation, literature selection, and GitHub/Codex collaboration.

**Core Principle:**

> Research questions determine the methods. Numerical evidence supports design decisions. Experiments validate the physical system.

This file contains long-term working rules, not daily task schedules or frequently changing numerical results.

The latest research progress and active tasks must be obtained from `CURRENT_STATE2.md` and the active November research plans.


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


### Research Scope and Development Priorities

**Long-Term Research Goal**

Develop and compare six-, seven-, and eight-cable measurement systems for estimating the position, orientation and eventually deformation of a passively moving balloon-like object.

The long-term comparison of six-, seven- and eight-cable configurations remains a central research objective.

**Immediate Engineering Priority**

Establish an adjustable six-cable experimental sensing system as early as reasonably possible.

The six-cable system serves as:

- A reference for sensing-performance evaluation.
- A platform for cable-length and tension measurements.
- An experimental baseline for calibration and pose estimation.
- A foundation for deformable-balloon experiments.
- A reference for future seven-/eight-cable comparisons.

Global configuration optimality is not required before building the first prototype.

**Parallel Theoretical Priority**

Seven- and eight-cable theory and simulation may proceed while the six-cable test rig is being designed, assembled or experimentally validated.

Their investigation must not unnecessarily delay the six-cable prototype.

**Deformable-Balloon Priority**

Before finalising hardware, evaluate whether the selected rigid-body configuration can accommodate a deformable balloon.

Anchor locations may be retained when justified by geometric and mechanical verification.

Attachment locations and cable routing must be re-evaluated under deformation.

**Physical Architecture**

- Passive balloon motion.
- Cable-length-based sensing.
- Motor-assisted low-tension tracking.
- Adjustable external anchors.
- Replaceable balloon attachment interfaces.
- Modular sensing and motor hardware.
- Provision for additional cable channels.

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


### Phase B and Prototype Development Rules

The research follows two parallel workstreams.

#### Workstream A — Six-Cable Prototype and Experimental Validation

**Priority: Immediate**

1. Complete six-cable geometric and sensing evaluation.
2. Search for a practical and adjustable Prototype Configuration V1.0.
3. Verify initial rigid-to-flexible balloon compatibility.
4. Calculate cable length, tension and motor requirements.
5. Build an adjustable six-cable test rig.
6. Perform calibration and rigid-body pose estimation experiments.
7. Extend experiments to a deformable balloon.
8. Refine the system using measured results.

The purpose is to establish a working experimental platform, not to prove global configuration optimality.

#### Workstream B — Seven- and Eight-Cable Theory and Simulation

**Priority: Parallel**

1. Extend the measurement Jacobian to seven and eight cables.
2. Investigate measurement redundancy and observability.
3. Evaluate scaled singular values and condition numbers.
4. Calculate predicted pose covariance.
5. Investigate geometric workspace and cable interference.
6. Evaluate positive-tension feasibility where mechanically relevant.
7. Compare six-, seven- and eight-cable systems under consistent assumptions.

Theoretical and simulation studies may begin before six-cable experimental validation is fully completed.

Physical expansion beyond six cables requires separate engineering justification.

#### Workstream Integration

Both workstreams must use comparable:

- Balloon geometry.
- Target pose samples.
- Measurement-noise assumptions.
- Geometric feasibility criteria.
- Jacobian scaling.
- Pose estimation metrics.
- Mechanical constraints.

Do not assume that adding cables automatically improves overall system performance.

#### Flexible-Balloon Transition

Between six-cable configuration selection and engineering sizing, conduct an initial rigid-to-flexible compatibility assessment.

The assessment must include:

- Reduced-order deformation modelling.
- Attachment migration.
- Cable–deformed-surface interference.
- Combined rigid-pose and deformation observability.
- Hardware compatibility and adjustment requirements.

Do not assume that six cable-length measurements can uniquely recover six rigid-body degrees of freedom plus arbitrary additional deformation parameters.

#### Prototype Decision Gate

A six-cable Prototype V1.0 may be selected when:

1. Anchor and attachment coordinates are explicit.
2. Cable pairing is documented.
3. The initial experimental pose region is defined.
4. Essential geometric interference checks are passed.
5. Local sensing quality is evaluated.
6. Remaining physical uncertainties are documented.
7. Mechanical adjustment and future expansion are considered.

Global optimisation and complete deformable shape reconstruction are not prerequisites for initial prototype construction.

However, critical geometric, mechanical and safety issues must not be ignored to accelerate development.

---

## 4. Research Context Loading Rules

Before beginning a research task, read the minimum relevant repository context.


### Recommended Loading Order

Before starting a research task, load the minimum relevant repository context in the following order:

1. `AGENTS2.md` — Stable AI and research rules.
2. `CURRENT_STATE2.md` — Current research state and verified progress.
3. Active TODO in `08_Project_Management/November/`.
4. Active weekly plan in `08_Project_Management/November/`.
5. `08_Project_Management/Roadmap.md` — Long-term milestones and parallel workstreams.
6. Relevant technical models in `05_My_Research/`.
7. Relevant MATLAB scripts, saved configuration datasets and research logs.

The active November plan currently begins with:

`08_Project_Management/November/weekly_plan_nov_04_17_2026.md`

When a new weekly plan is created, use the newest explicitly active plan rather than automatically selecting an old schedule.

Historical plans should be consulted only when needed.

### Context Loading Principles

- Read only the files relevant to the current task.
- Preserve verified research results across sessions.
- Distinguish completed, ongoing and planned tasks.
- Do not infer completion from dates alone.
- Do not invent missing numerical results.
- Do not silently change the active research workstream.
- Identify and explain conflicting repository information.
- Prefer verified experimental or numerical evidence over outdated planning statements.


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


### Research-Driven Teaching Rules

When assisting with a new research task:

1. State the research question.
2. Explain why the task is required for the current research.
3. Identify relevant published methods and theoretical equations.
4. Distinguish literature-supported methods from engineering assumptions.
5. Explain the mathematical model and physical meaning.
6. Provide incremental MATLAB implementation.
7. Let the user run and inspect numerical results.
8. Interpret actual outputs before continuing.
9. Include short research reflection questions when useful.
10. Summarise findings and limitations before archiving.

Do not introduce multiple advanced algorithms simultaneously unless explicitly requested.

Do not skip numerical verification or interpretation to accelerate lesson progression.

### Parallel Workstream Management

At the beginning of a task, identify its workstream:

- Workstream A: Six-cable prototype and experiments.
- Workstream B: Seven-/eight-cable theory and simulation.
- Shared: Mathematical methods, deformation modelling, sensing evaluation and literature research.

The AI should:

1. Prioritise the active task selected by the user.
2. Keep Workstream A moving toward an adjustable prototype.
3. Support Workstream B without unnecessarily delaying Workstream A.
4. Reuse validated mathematical and MATLAB methods across workstreams.
5. Maintain a consistent basis for six-/seven-/eight-cable comparisons.
6. Record dependencies between the workstreams.
7. Avoid restarting completed lessons when switching workstreams.
8. Recommend schedule changes only when justified by progress or unresolved constraints.

If the user explicitly selects a task in one workstream, do not redirect to another without explaining a necessary dependency.


---

## 12. Repository Maintenance Rules

Each file has one primary responsibility.

| File | Responsibility |
|---|---|
| `README.md` | Project overview |
| `AGENTS2.md` | Stable research and AI rules |
| `CURRENT_STATE2.md` | Current progress and findings |
| `08_Project_Management/Roadmap.md` | Long-term milestones and parallel workstreams |
| `08_Project_Management/November/` | Active November TODO and weekly plans |
| `08_Project_Management/weekly_plan_02.md` | Historical Phase A plan |
| `08_Project_Management/weekly_plan_03.md` | Historical Phase B planning record |
| `05_My_Research/` | Technical models, sensing objectives and prototype design decisions |
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

### User-Preferred Manual Update Format

When updating research documents:

1. Inspect the existing GitHub file first.
2. Identify outdated, duplicated or conflicting content.
3. Explain which sections should be retained, replaced or removed.
4. Provide the updated content directly as copyable Markdown text.
5. Prefer precise replacement sections over rewriting a large file when only limited changes are required.
6. Update only one GitHub file at a time.
7. Do not edit, commit or push changes without explicit user approval.
8. Wait for the user's confirmation before preparing the next file.
9. Preserve verified results and existing references.
10. Verify the updated repository file when the user requests a final check.

When a complete rewritten file is necessary, provide it as directly reviewable text unless the user explicitly requests a downloadable artifact.

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


## 14. Guiding Principles

> Research questions determine the methods. Numerical evidence supports design decisions. Experiments validate the physical system.

### Research Priorities

**Immediate Priority**

Select and build an adjustable six-cable prototype that supports early experimental validation.

**Parallel Priority**

Investigate seven- and eight-cable sensing theory and simulation without unnecessarily delaying prototype development.

**Flexible-Balloon Priority**

Evaluate rigid-to-flexible compatibility before final hardware selection, while reserving detailed deformation reconstruction for later research.

**Long-Term Priority**

Compare six-, seven- and eight-cable systems in terms of pose-estimation accuracy, sensing workspace, measurement redundancy, mechanical feasibility and implementation complexity.

### Engineering Principles

- Prototype early, but do not ignore essential constraints.
- Preserve the ability to adjust anchor and attachment locations.
- Keep hardware modular where practical.
- Use experimental calibration to refine simulation assumptions.
- Distinguish numerical predictions from experimentally validated performance.
- Do not claim global optimality without appropriate evidence.
- Do not assume additional cables guarantee better sensing.
- Maintain the long-term objective of deformable balloon sensing and shape reconstruction.

### AI Collaboration Principle

The AI should work as a research assistant that supports problem definition, literature interpretation, mathematical modelling, MATLAB implementation, numerical verification, experimental planning and documentation.

The AI must not silently change research priorities or overwrite established design decisions.

Current tasks and completion status must always be read from the latest active research documents.

