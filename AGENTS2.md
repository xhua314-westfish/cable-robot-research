# AGENTS2 — Research and AI Working Rules

**Last Updated:** 2026-10-30  
**Project:** Cable-Robot-Based Sensing for a Passive Deformable Balloon  
**Current Phase:** Phase B — Balloon-Specific Cable Sensing Design

---

## 1. Purpose

This document defines the working rules for research planning, mathematical modelling, MATLAB implementation, numerical validation, AI collaboration, and repository maintenance.

The project follows a **research-question-driven approach**.

**Core Principle:**

> Every learning activity, mathematical model, simulation, and experiment should help answer a defined research question.

This document defines stable working rules. It should not duplicate detailed research progress, daily schedules, or numerical results.

---

## 2. Research Scope and Scientific Principles

### Long-Term Goal

Develop a cable-based measurement system to estimate the position, orientation, and eventually deformation or shape of a passively moving balloon-like object.

The research is motivated by intragastric balloon sensing within a simplified gastric environment.

### Current Research Scope

- Three-dimensional rigid-body pose estimation.
- Six-degree-of-freedom position and orientation.
- Simplified 3D gastric boundary.
- 550 mL rigid spherical balloon proxy.
- Six-, seven-, and eight-cable configurations.
- Cable-length-based measurements.
- Three-dimensional anchor and attachment placement.
- Passive and unknown balloon motion.
- Proposed motor-assisted low-tension cable tracking.

### Fundamental Rules

1. The balloon moves passively due to external environmental influences.
2. The estimator must not require the true motion trajectory as an input.
3. The system is intended for measurement and sensing, not active trajectory control.
4. Motors may track cable displacement and maintain low tension, but should not prescribe balloon motion.
5. The rigid sphere is an engineering approximation, not the final deformable-balloon model.
6. Use the simplified gastric boundary as a geometric constraint, not as a validated physiological motion model.
7. Prioritise rigid-body sensing before investigating shape reconstruction.
8. Clearly distinguish simulated feasibility from experimentally demonstrated capability.

---

## 3. Research Phase Rules

The project follows the phases defined in `08_Project_Management/Roadmap.md`.

| Phase | Focus | Current Status |
|---|---|---|
| Phase 0 | Application and clinical evidence | Initial synthesis completed |
| Phase A | Literature-based method reproduction | Core scope completed |
| Phase B | Balloon-specific configuration design | Current |
| Phase C | Rigid-body sensing validation | Planned |
| Phase D | Deformable-balloon extension | Future |

### Phase A Protection

The A1–A5 core research methods have already been implemented and documented.

Do not automatically schedule the completed Phase A exercises again.

Reuse existing MATLAB scripts and research notes.

Reopen a completed task only when:

- A verified error or unresolved limitation affects current research.
- A new research question explicitly requires further verification.
- The user requests further reproduction or analysis.

Distinguish a completed core method from optional extensions that remain unimplemented.

### Phase B Working Order

Follow the current research sequence:

B1 — Geometry and Candidate Region Definition  
B2 — Cable Configuration Generation  
B3 — Feasibility Screening  
B4 — Sensing Quality Evaluation  
B5 — Configuration Selection

Do not perform full configuration optimisation before defining the necessary geometry, constraints, and evaluation criteria.

---

## 4. Research Context Loading Rules

Before starting a new research task or creating a detailed research plan, read the relevant repository files in this order:

1. `AGENTS2.md` — Research and AI working rules.
2. `CURRENT_STATE2.md` — Current research state and verified progress.
3. `08_Project_Management/current_october_november_todo.md` — Active tasks and completion status.
4. `08_Project_Management/Roadmap.md` — Research phases and milestones.
5. The relevant technical files in `05_My_Research/`.
6. The relevant MATLAB scripts and research notes in `04_Code_Exercises/` and `06_Research_Log/`.

Read `weekly_plan_02.md` only when historical Phase A scheduling information is needed.

For future phases, use the latest active weekly-plan file.

### Context Loading Principles

- Read the smallest relevant set of files needed to answer the current question.
- Do not repeatedly load unrelated historical files.
- Prioritise current state and active tasks over outdated schedules.
- Preserve important constraints and decisions across sessions.
- Do not infer task completion from a plan alone.
- Do not claim to have read files that were not actually accessed.

When files disagree, identify the inconsistency rather than silently selecting one version.

Use the current task record and verified research evidence to resolve discrepancies.

---

## 5. Standard Research Workflow

Use the following sequence:

```text
Research Question
       ↓
Existing Evidence and Assumptions
       ↓
Required Theory and Method
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

For each research task:

1. Define one clear research question.
2. Identify the expected deliverable.
3. Review existing work before adding new code.
4. Learn only the theory necessary for the task.
5. Implement the simplest suitable model.
6. Verify dimensions, units, equations, and numerical results.
7. Explain what the results do and do not demonstrate.
8. Record limitations and the next research decision.

Avoid unrelated textbook exercises or unnecessary algorithm extensions.

---

## 6. Mathematical Modelling Rules

Every technical model must specify:

- Coordinate systems.
- State variables and degrees of freedom.
- Inputs, outputs, and unknowns.
- Physical units and matrix dimensions.
- Geometry and physical constraints.
- Measurement assumptions.
- Model limitations.

### Cable Geometry Convention

For cable i:

\[
B_i=P+Rr_i
\]

\[
L_i=\|B_i-A_i\|
\]

where:

- \(A_i\): Fixed anchor point in the world frame.
- \(r_i\): Attachment point in the balloon body frame.
- \(B_i\): Attachment point in the world frame.
- \(P\): Balloon-centre position.
- \(R\): Rotation matrix from body to world frame.

Use a consistent sign convention for cable vectors and length derivatives.

### Rigid-Body State

The rigid-body pose consists of:

\[
P\in\mathbb{R}^3
\]

\[
R\in SO(3)
\]

A local six-dimensional pose perturbation may be represented as:

\[
\delta q=
\begin{bmatrix}
\delta P\\
\delta\omega
\end{bmatrix}
\]

with position increments in metres and rotation increments in radians.

Do not confuse this local perturbation representation with a particular global Euler-angle parameterisation.

### Measurement Jacobian

For small perturbations:

\[
\delta L\approx H\delta q
\]

where:

\[
H\in\mathbb{R}^{n\times6}
\]

Do not assume the symbol \(J\) has identical dimensions or sign conventions across different papers.

Explicitly define every Jacobian used in code and verify its relationship to the selected measurement or wrench model.

---

## 7. Cable Configuration Rules

The number and placement of cables must be justified through analysis.

Evaluate:

- Local measurement identifiability.
- Jacobian rank.
- Noise sensitivity.
- Pose-estimation uncertainty.
- Geometric workspace coverage.
- Cable routing and interference.
- Tension feasibility.
- Mechanical complexity.

### Physical Connection Definitions

**Anchor:** A fixed cable connection or routing point in the world frame.

**Attachment:** A cable connection point fixed in the balloon body frame for the initial rigid-body model.

**Attachment mechanism:** The physical structure used to attach the cable to the balloon.

Do not treat these three concepts as interchangeable.

Six independent scalar cable-length measurements are necessary for unconstrained local six-degree-of-freedom identification.

However:

- Six cables do not guarantee rank 6.
- Rank 6 does not guarantee global pose uniqueness.
- Measurement identifiability does not guarantee positive-tension wrench closure.
- Seven or eight cables do not automatically guarantee superior accuracy.
- Candidate configurations must be compared under consistent assumptions.

---

## 8. Workspace and Feasibility Rules

Distinguish the following:

| Concept | Meaning |
|---|---|
| Gastric boundary | Simplified anatomical envelope |
| Geometric workspace | Balloon poses satisfying containment constraints |
| Cable-feasible workspace | Poses satisfying cable geometry and routing constraints |
| Tension-feasible workspace | Poses meeting specified force/tension conditions |
| Sensing-feasible workspace | Poses meeting defined identifiability and measurement-quality requirements |

The final feasible sensing region may require the intersection of multiple constraint sets.

### Evaluation Rules

- State the constraints before computing feasibility.
- Use explicit units and numerical tolerances.
- Verify sampled feasible points against the defining equations.
- Report the sampling grid and orientation assumptions.
- Distinguish sampled coverage from continuous workspace coverage.
- Check physical routing and cable–balloon interference when relevant.
- Do not use Tension Factor as the primary metric for sensing accuracy.

---

## 9. Sensing Accuracy and Statistical Validation Rules

Use appropriate metrics, including:

- Jacobian rank.
- Scale-aware singular values and conditioning.
- Position and orientation RMSE.
- Bias and standard deviation.
- Local pose covariance.
- Measurement-noise sensitivity.
- Monte Carlo validation.
- 3σ coverage.
- NEES or ANEES consistency tests where appropriate.

### Validation Principles

1. Distinguish true state, measured cable lengths, and estimated state.
2. Verify analytical Jacobians against finite differences.
3. Test noiseless cases before adding measurement noise.
4. Record random seeds and noise assumptions.
5. Use consistent pose samples and noise models for configuration comparisons.
6. Report convergence failures and ambiguous solutions.
7. Interpret covariance as a local, model-dependent uncertainty prediction.
8. Avoid claiming experimental accuracy from numerical simulations alone.

Prescribed motion may be used to generate simulation ground truth, but it must not be supplied as the true motion trajectory to the estimator.

---

## 10. MATLAB and Code Development Rules

MATLAB is the primary simulation platform.

CASPR may be used for secondary verification.

### Code Quality

- Prefer readable scripts and reusable functions.
- Use descriptive variable names.
- State coordinate conventions and units.
- Check matrix dimensions before implementing equations.
- Avoid unnecessary duplicate geometry or Jacobian implementations.
- Separate model parameters, simulation, estimation, and evaluation.
- Save reproducible outputs and numerical verification results.

### Verification

Before treating a new implementation as validated:

1. Confirm the expected physical and matrix dimensions.
2. Check simple analytical or known test cases.
3. Compare analytical results with numerical approximations when appropriate.
4. Evaluate relevant residuals and constraints.
5. Record actual output values.
6. Document limitations and failure cases.

Do not label unexecuted code as verified.

---

## 11. AI-Assisted Daily Research Workflow

The research should progress through small, verifiable tasks rather than large uninterrupted explanations.

### At the Start of a Research Session

1. Read the current research state and active TODO.
2. Identify the highest-priority unfinished task.
3. Review only the relevant previous methods and files.
4. Confirm the research question and expected deliverable.
5. Propose a manageable sequence of MATLAB or analytical steps.

### During a Research Session

- Explain equations and their physical meanings.
- Introduce code in manageable sections when teaching.
- Allow numerical results to be checked before major extensions.
- Adapt explanations to the user's demonstrated understanding.
- Separate theory, simulation, results, and interpretation.
- Avoid skipping verification steps.
- Do not repeat already completed lessons without a clear reason.

### At the End of a Research Session

Summarise:

- Task ID.
- Research question.
- Work completed.
- Relevant script or figure.
- Verified numerical findings.
- Outstanding problems.
- Next concrete action.

Update the active TODO only when task completion is supported by evidence.

### Session Handoff

Before switching to a new chat or AI coding environment, preserve the essential working context in repository files.

A handoff should identify:

```text
Current phase:
Current task:
Research question:
Relevant files:
Verified results:
Unresolved issues:
Next action:
```

Do not rely on chat history alone as the research record.

---

## 12. Repository Maintenance Rules

Each document has one primary responsibility.

| File | Responsibility |
|---|---|
| `README.md` | Project overview and navigation |
| `AGENTS2.md` | Stable research and AI working rules |
| `CURRENT_STATE2.md` | Current state and verified progress |
| `08_Project_Management/Roadmap.md` | Research phases and milestones |
| `08_Project_Management/current_october_november_todo.md` | Active actionable tasks |
| `08_Project_Management/weekly_plan_02.md` | Historical Phase A plan and closeout |
| Future active weekly plans | Daily research schedule |
| `05_My_Research/` | Research models, methods and designs |
| `04_Code_Exercises/MATLAB/` | MATLAB scripts and implementations |
| `06_Research_Log/` | Experiment records and dated research notes |

### Update Rules

- Update `CURRENT_STATE2.md` after major verified progress or a change of active task.
- Update the active TODO when specific tasks are completed or revised.
- Create or update the current weekly plan during weekly planning and review.
- Update `Roadmap.md` when research milestones or phases change.
- Update `AGENTS2.md` only when working rules change.
- Preserve previous simulation outputs and research records.
- Avoid unnecessary duplication of the same information across files.

### Manual GitHub Update Rules

When the user requests manual repository updates:

1. Inspect the current repository file before proposing changes.
2. Explain why the file needs updating.
3. Provide the complete revised Markdown or precise replacement sections.
4. Do not modify GitHub directly unless explicitly requested.
5. Update only one file at a time when using the file-by-file workflow.
6. After the user updates a file, verify its current repository content before continuing.

### Codex Collaboration Rules

When using Codex or other coding agents:

- Read repository instructions and current task context before editing.
- Work within the active research task unless explicitly authorised to expand scope.
- Prefer small, reviewable changes.
- Do not overwrite verified results without preserving the previous version.
- Do not infer that passing code execution proves scientific validity.
- Report changed files, tests performed, numerical outputs, and unresolved issues.
- Do not automatically commit, push, or alter project-wide plans without user approval.

---

## 13. Literature and Evidence Rules

For relevant academic sources, record:

- Title, authors, year, and DOI where available.
- Research objective.
- Relevant mathematical or experimental methods.
- Reported measurements.
- Assumptions and limitations.
- Relevance to the current research task.

Distinguish:

- **Reported:** Directly supported by a source.
- **Derived:** Calculated from reported information.
- **Assumed:** Introduced for engineering modelling.
- **Verified:** Checked through a specified numerical procedure.
- **Experimentally validated:** Supported by physical measurements.
- **Unknown:** Not established by available evidence.

Do not invent citations, physical dimensions, or simulation results.

Do not interpret equivalent spherical diameter as a directly measured balloon diameter.

---

## 14. Guiding Principle

> Use the simplest defensible measurement and feasibility model to answer the current research question; verify the result before using it to make the next design decision.

**Current research focus:** B1 — Define the balloon-specific geometry and candidate anchor/attachment regions.

**Next stage:** Compare six-, seven-, and eight-cable sensing configurations using consistent feasibility and accuracy criteria.

**Long-term direction:** Extend the validated rigid-body measurement approach toward passive deformable-balloon shape sensing.
