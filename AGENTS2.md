# AGENTS2 — Research and AI Working Rules

**Version:** 0.7  
**Last Updated:** 2026-11-12  
**Project:** Cable-Robot-Based Sensing for a Passive Deformable Balloon  
**Primary Tool:** MATLAB  
**Research Strategy:** Research-Driven, Prototype-Oriented, Parallel Workstreams

---

## 1. Purpose and Document Role

This document defines the stable research and AI collaboration rules for the cable-robot sensing project.

It governs:

- Research-question-driven learning.
- Scientific reasoning and literature use.
- Mathematical modelling.
- MATLAB implementation and verification.
- Configuration optimisation.
- Experimental planning.
- Parallel cable-number research.
- GitHub and Codex collaboration.
- Research documentation and session handoff.

**This is a working-rules document, not a research progress report.**

Do not duplicate completed numerical results, detailed daily schedules, specific candidate coordinates or frequently changing research status here.

### Authoritative Repository Documents

| Document | Responsibility |
|---|---|
| `AGENTS.md` | AI/Codex repository entry point |
| `AGENTS2.md` | Stable research and AI working rules |
| `CURRENT_STATE2.md` | Latest verified research state |
| `08_Project_Management/Roadmap.md` | Long-term milestones and research direction |
| Active Research Plan | Current tasks, methods and acceptance criteria |
| Active Weekly Plan | Daily execution schedule, when maintained |
| `05_My_Research/` | Technical design and mathematical models |
| `03_Simulation/MATLAB/` | Source code and numerical datasets |
| `06_Research_Log/` | Detailed numerical and experimental evidence |

### Document Responsibility Principle

Each document should have one clear purpose.

- Current progress belongs in `CURRENT_STATE2.md`.
- Long-term research milestones belong in `Roadmap.md`.
- Specific procedures belong in the active Research Plan.
- Verified experimental evidence belongs in Research Logs.
- Stable AI working rules belong in `AGENTS2.md`.

Do not copy the same detailed results into every document.

---

## 2. Scientific Research Direction

### 2.1 Long-Term Research Goal

Develop and evaluate a cable-based sensing system capable of estimating the position, orientation and eventually deformation or shape of a passively moving balloon-like object.

The research is motivated by a simplified intragastric-balloon sensing environment.

The system is intended for measurement and state estimation, not active trajectory control.

### 2.2 Cable Number Research Objective

The long-term research objective includes comparing:

- Six-cable sensing.
- Seven-cable sensing.
- Eight-cable sensing.

The comparison should consider:

- Pose estimation accuracy.
- Local identifiability.
- Measurement redundancy.
- Sensing workspace.
- Geometric and mechanical feasibility.
- Installation robustness.
- Implementation complexity.

The six-cable configuration serves as the initial experimental reference.

Seven- and eight-cable theory and simulation remain essential research directions.

### 2.3 Passive Motion Principle

The balloon undergoes passive and potentially irregular motion.

The estimator must not require the true trajectory as an input.

Motors may be used to follow cable displacement and maintain low positive tension.

The motors must not intentionally prescribe the balloon trajectory.

The low-tension tracking architecture requires physical validation.

A prescribed reference motion may be used during calibration or controlled testing, but it must not be confused with the final passive sensing principle.

---

## 3. Parallel Research Workstreams

### Workstream A — Six-Cable Prototype and Experiments

**Primary engineering priority**

1. Evaluate and compare candidate six-cable configurations.
2. Optimise anchor locations, attachment locations and pairing.
3. Verify geometry and sensing over relevant pose regions.
4. Investigate robustness and installation constraints.
5. Validate nonlinear pose reconstruction.
6. Define cable length, tension, motor and sensor requirements.
7. Develop an adjustable experimental test rig.
8. Validate rigid-body pose estimation experimentally.
9. Investigate flexible-balloon compatibility.
10. Refine the configuration using experimental evidence.

The initial prototype does not require proof of global configuration optimality.

However, essential geometric, sensing and mechanical constraints must be evaluated before hardware implementation.

### Workstream B — Seven-/Eight-Cable Theory and Simulation

**Parallel theoretical priority**

1. Derive seven- and eight-cable measurement Jacobians.
2. Investigate measurement redundancy and observability.
3. Evaluate singular values, conditioning and pose covariance.
4. Analyse geometric workspace and cable interference.
5. Investigate tension feasibility where mechanically relevant.
6. Compare six-, seven- and eight-cable systems using consistent criteria.
7. Evaluate whether additional cable channels justify their mechanical and sensing complexity.

Workstream B may proceed while the six-cable test rig is being designed, assembled or tested.

Theoretical work must not unnecessarily delay Workstream A.

Hardware expansion beyond six cables requires separate engineering justification.

### Workstream Integration Rules

When comparing configurations:

- Use common target pose sets.
- Use consistent geometry and coordinate conventions.
- Apply equivalent measurement-noise assumptions.
- Use identical sensing-performance definitions.
- Distinguish geometric, sensing and tension feasibility.
- Report changes in sensor count and hardware complexity.
- Do not assume additional cables automatically improve performance.

When the user selects a task from either workstream, prioritise that task unless a necessary technical dependency prevents progress.

---

## 4. Research Context Loading

Before beginning a new research task, read the minimum relevant repository context.

### Required Loading Order

1. `AGENTS.md` — Repository entry instructions.
2. `AGENTS2.md` — Stable working rules.
3. `CURRENT_STATE2.md` — Current verified progress.
4. Active Research Plan — Current research methods and tasks.
5. Active Weekly Plan — Daily research schedule, if applicable.
6. `08_Project_Management/Roadmap.md` — Long-term milestones.
7. Relevant technical models, MATLAB scripts and Research Logs.

Do not assume an older plan remains active merely because it exists in the repository.

### Context Rules

- Do not rely on chat history alone.
- Do not assume a task is completed because its planned date has passed.
- Verify completion using actual saved results.
- Do not claim to have read inaccessible files.
- Prefer the current Research Plan over superseded schedules.
- Report contradictions between documents.
- Preserve verified findings from previous sessions.
- Avoid re-reading unrelated files unnecessarily.

### Handling Conflicting Information

When repository documents disagree:

1. Identify the specific contradiction.
2. Check the relevant Research Log and MATLAB evidence.
3. Distinguish historical results from current research status.
4. Use `CURRENT_STATE2.md` to establish the current milestone.
5. Use the active Research Plan to determine the next procedure.
6. Do not silently overwrite one verified result with another.
7. Ask for clarification when a material contradiction cannot be resolved using available evidence.

A newer planning document does not automatically invalidate earlier numerical evidence.

Historical learning plans must not override current research instructions.

---

## 5. Research-Driven Workflow

Every research task should follow:

```text
Research Question
       |
       v
Existing Evidence
       |
       v
Relevant Literature and Theory
       |
       v
Mathematical Model
       |
       v
MATLAB Implementation
       |
       v
Numerical Verification
       |
       v
Physical Interpretation
       |
       v
Research Documentation
       |
       v
Next Research Decision
```

### General Rules

1. Start from a concrete research question.
2. Explain why the task matters to the project.
3. Identify the required output and acceptance criteria.
4. Review relevant existing work before starting new code.
5. Learn only the theory needed for the task.
6. Use the simplest defensible mathematical model.
7. Verify numerical results before extending the model.
8. Distinguish observed results from assumptions.
9. Document limitations and unresolved problems.
10. Avoid unnecessary repetition of completed lessons.

Do not introduce advanced algorithms solely because they are available.

### Required Research Explanation

For a substantial research lesson, explain:

**1. Why is this task necessary?**

Identify the unresolved research problem or limitation.

**2. What theory or literature supports the method?**

Explain the relevant mathematical principles and applicable published methods.

**3. What research decision will the result enable?**

Define what can be concluded from the outcome and what remains unresolved.

---

## 6. AI Teaching and Explanation Rules

When guiding research:

1. Explain the research objective.
2. Introduce relevant equations and physical meaning.
3. Identify relevant literature and DOI information where applicable.
4. Explain assumptions and coordinate conventions.
5. Provide a logical implementation sequence.
6. Allow the user to run and inspect MATLAB results.
7. Interpret actual outputs before continuing.
8. Verify unexpected results instead of guessing.
9. Include short research reflection questions where useful.
10. Summarise findings before moving to the next task.

Prefer incremental research sessions over large collections of unrelated exercises.

The purpose is to support independent research understanding, not merely provide working code.

### MATLAB Teaching Preferences

For each practical numerical research lesson:

- Begin with the research question.
- Explain why the mathematical method is appropriate.
- Identify the required inputs.
- State which variables are fixed and which are changed.
- Provide a complete runnable MATLAB script when requested.
- Use clear Chinese comments to explain the code.
- Reuse verified functions where practical.
- Explain expected outputs and numerical checks.
- Wait for actual execution results before interpreting unverified outcomes.
- Explain the physical significance of the obtained results.
- Avoid introducing unrelated new tasks before the current lesson is understood.

### Research Reflection

Use short research questions to encourage interpretation.

Reflection questions should focus on:

- Why a result occurred.
- What the result demonstrates.
- What it does not demonstrate.
- Which design decision follows.
- Whether additional verification is needed.

Do not treat a numerical improvement as self-explanatory.

---

## 7. Mathematical Modelling Rules

Every technical model must declare:

- Coordinate frames.
- Known variables and unknown state variables.
- Inputs and measurements.
- Units.
- Matrix dimensions.
- Geometric and physical constraints.
- Modelling assumptions.
- Expected outputs.

### Units

Unless explicitly stated otherwise:

- Geometry and cable length: millimetres.
- Local rotation increments: radians.
- Reported orientation angles: degrees when explicitly labelled.
- Tension and force: newtons.
- Motor torque: newton-metres.

Do not mix units within a model.

### Rigid-Body Cable Geometry

For cable \(i\):

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

- \(A_i\): World-fixed anchor.
- \(r_i\): Body-frame attachment.
- \(P\): Balloon-centre position.
- \(R\): Body-to-world rotation matrix.

The cable direction \(d_i\) points from the attachment toward the anchor.

When using alternative wrench conventions from literature, explicitly check the sign definitions.

### Measurement Jacobian

For a local world-frame rotation perturbation:

\[
u_i=\frac{d_i}{L_i}, \qquad s_i=Rr_i
\]

\[
H_i=
\begin{bmatrix}
-u_i^T & (u_i\times s_i)^T
\end{bmatrix}
\]

\[
\delta L\approx H\delta q
\]

For \(n\) cables and six rigid-body degrees of freedom:

\[
H\in\mathbb{R}^{n\times6}
\]

Local first-order identifiability requires full column rank.

Full rank does not guarantee global uniqueness or acceptable experimental accuracy.

### Jacobian Scaling

Translation and rotation have different physical units.

Use a declared characteristic length when evaluating scaled singular values and condition numbers.

For the current rigid spherical model, the adopted characteristic length is the balloon radius unless another convention is explicitly justified.

Keep the scaling convention consistent across configuration and cable-number comparisons.

---

## 8. Cable Configuration and Workspace Rules

### 8.1 Configuration Variables

For a six-cable reference:

\[
\mathcal C_6=\{(A_i,r_i)\}_{i=1}^{6}
\]

Anchor positions, attachment positions and cable pairing are distinct design variables.

For the rail-constrained model:

\[
A_i=A(\rho_i,t_i)
\]

where:

- \(\rho_i\): Rail assignment.
- \(t_i\): Normalised anchor position on that rail.
- \(r_i\): Body-frame attachment coordinate.
- \(\pi\): Cable pairing permutation.

The configuration must preserve an explicit mapping between every anchor and its attachment.

### 8.2 Configuration Evaluation

Consider:

- Balloon containment.
- Cable–balloon interference.
- Cable–cable interference.
- Minimum cable clearance.
- Outward angular margin.
- Jacobian rank.
- Scaled singular values and conditioning.
- Predicted pose uncertainty.
- Pose-estimation error.
- Cable length and stroke.
- Mechanical mounting feasibility.
- Positive-tension feasibility.
- Disturbance of passive balloon motion.

### 8.3 Workspace Rules

Always distinguish:

1. Engineering boundary.
2. Geometrically feasible workspace.
3. Cable-routing feasible workspace.
4. Tension-feasible workspace.
5. Sensing-feasible workspace.

A sampled feasibility ratio does not establish continuous workspace coverage.

Ideal zero-thickness cable non-intersection is not equivalent to practical cable clearance.

A full-rank measurement Jacobian is not proof of positive-tension wrench feasibility.

### 8.4 Optimisation Rules

- Define variables and constraints before optimisation.
- Evaluate multiple poses rather than only a reference pose.
- Use reproducible search settings.
- Keep failed candidates and failure reasons.
- Preserve independent validation poses.
- Avoid unsupported global-optimality claims.
- Prefer a practical adjustable design over a numerically attractive but interfering configuration.

### 8.5 Controlled-Variable Experiments

When analysing configuration variables, distinguish:

| Experiment | Variable Parameters | Fixed Parameters |
|---|---|---|
| E0 — Baseline | None | All configuration variables |
| E1a — Rail Position | Rail positions | Rail assignments, attachments, pairing |
| E1b — Rail Assignment | Rail assignments and associated positions | Attachments, pairing |
| E2 — Attachment | Attachment coordinates | Anchor configuration, pairing |
| E3 — Pairing | Pairing permutation | Anchor and attachment point sets |
| E4 — Joint Optimisation | Multiple configuration variables | Common geometry and evaluation rules |

The exact active experiment and its detailed procedure belong in the Research Plan.

### 8.6 Fair Configuration Comparison

When comparing multiple configurations:

1. Retain each configuration's original identity and geometry.
2. Apply the same objective and constraints.
3. Use comparable optimisation budgets.
4. Use the same development pose sets.
5. Use identical sensing definitions.
6. Record failed and rejected candidates.
7. Evaluate final candidates using common independent validation data.
8. Distinguish baseline superiority from improvements caused by additional optimisation effort.

Do not declare one configuration globally superior merely because it received more optimisation or debugging.

### 8.7 Robustness and Validation

A configuration should not be ranked using geometry pass counts alone.

Where applicable, evaluate:

- Minimum outward angular margin.
- Minimum cable distance.
- Independent unseen poses.
- Anchor installation perturbations.
- Attachment placement uncertainty.
- Cable-length measurement noise.
- Pose-estimator convergence.

Keep clear distinctions between numerical robustness tests and experimentally validated mechanical tolerances.

---

## 9. Rigid-to-Flexible Transition Rules

The rigid sphere is an engineering reference model.

Before finalising prototype hardware, perform an initial flexible compatibility assessment.

### Required Considerations

1. Simplified deformation model.
2. Attachment migration.
3. Cable–deformed-surface interference.
4. Cable-length changes.
5. Combined rigid-pose and deformation observability.
6. Hardware adaptability.

For deformation parameters \(\eta\):

\[
B_i=P+R[r_{i0}+d_i(\eta)]
\]

The local measurement relationship is:

\[
\delta L\approx
H_{\mathrm{rigid}}\delta q+
H_{\mathrm{def}}\delta\eta
\]

Six instantaneous scalar cable-length measurements cannot generically identify six independent rigid-body pose components plus additional unconstrained deformation variables.

Additional measurements, physical constraints or reduced-order models may be required.

Do not claim complete deformation reconstruction merely because the rigid model is locally identifiable.

---

## 10. MATLAB and Numerical Verification

MATLAB is the primary computational platform.

CASPR may be used for secondary verification.

### Implementation Rules

- Reuse verified functions when possible.
- Prefer readable and modular scripts.
- Document units and coordinate conventions.
- Separate geometry, simulation, estimation and evaluation.
- Preserve configuration datasets.
- Record random seeds and solver settings.
- Save meaningful numerical outputs.
- Avoid unnecessary duplicate implementations.

### Verification Rules

Before accepting numerical results:

1. Check matrix dimensions.
2. Check coordinate conventions and units.
3. Verify simple known cases.
4. Compare analytical derivatives with finite differences.
5. Check residuals and feasibility constraints.
6. Test relevant failure cases.
7. Record actual output values.
8. Document numerical tolerances and limitations.

Do not label unexecuted or unverified code as validated.

### Development and Validation Data

Distinguish:

**Development Set**

Used for:

- Configuration optimisation.
- Parameter tuning.
- Algorithm development.
- Failure diagnosis.
- Targeted repair.

**Independent Validation Set**

Used to assess frozen candidates under previously unused conditions.

If a validation pose is used to modify the configuration, it becomes part of the development evidence and is no longer fully independent for that candidate.

Generate or reserve a fresh holdout when an independent final comparison is needed.

### Reproducibility

Record:

- MATLAB version when relevant.
- Configuration identifiers.
- Fixed and variable parameters.
- Dataset names.
- Random seeds.
- Solver tolerances.
- Numerical thresholds.
- Search budgets.
- Successful and failed trials.
- Output file paths.

Results from different pose sets must not be compared as if they were computed under identical conditions.

---

## 11. Measurement Accuracy and Experimental Evidence

Relevant metrics include:

- Jacobian rank.
- Scaled minimum singular value.
- Scaled condition number.
- Local pose covariance.
- Position RMSE.
- Orientation RMSE.
- Estimator convergence.
- Estimation failures.
- Calibration sensitivity.
- Measurement-noise sensitivity.
- Workspace coverage.
- Cable-induced disturbance.

### Evidence Rules

Distinguish:

| Evidence Type | Meaning |
|---|---|
| Reported | Directly stated by a reliable source |
| Derived | Mathematically calculated |
| Assumed | Introduced for modelling |
| Numerically verified | Supported by executed computation |
| Experimentally validated | Supported by physical measurements |
| Unknown | Not yet established |

Do not describe local covariance predictions as experimentally measured pose accuracy.

Independent ground truth is required for experimental estimation-error claims.

Simulation noise assumptions must not be treated as calibrated sensor specifications.

### Performance Reporting Rules

Every reported performance improvement must specify:

1. Baseline configuration.
2. Modified configuration.
3. Evaluation pose set.
4. Measurement or metric definition.
5. Numerical assumptions.
6. Relative or absolute improvement.
7. Remaining limitations.

Do not calculate improvement percentages using statistics from different pose sets without explicitly explaining their incompatibility.

When comparing candidate configurations, report sensing quality and geometric feasibility separately.

---

## 12. Literature and Citation Rules

For relevant academic literature, record:

- Exact article title.
- Authors and publication year.
- DOI where available.
- Research question.
- Applicable equations and methods.
- Required assumptions.
- Limitations and transferability.
- Relevance to the current task.

Do not invent citations or use a paper to support claims outside its actual scope.

Distinguish mathematical theory, published methods and project-specific adaptations.

Literature should be selected according to the active research question.

When a method is adapted from a published active cable-driven robot to passive sensing, explicitly explain which objectives or constraints have changed.

Do not reproduce entire papers without a clear research need.

---

## 13. GitHub and Codex Collaboration

### 13.1 Repository Responsibilities

- `AGENTS.md`: AI entry point.
- `AGENTS2.md`: Stable research rules.
- `CURRENT_STATE2.md`: Current progress.
- `08_Project_Management/Roadmap.md`: Long-term planning.
- Active Research Plan: Research tasks and acceptance criteria.
- Active Weekly Plan: Daily execution, when maintained.
- Technical design files: Mathematical and engineering models.
- Research Logs: Detailed numerical and experimental evidence.

### 13.2 Manual GitHub Update Rules

When the user requests manual updates:

1. Read the current repository file.
2. Identify outdated, conflicting or duplicated content.
3. Preserve validated research information.
4. Provide the complete, copyable Markdown content directly in the chat.
5. Keep the existing file path and filename unless a change is explicitly needed.
6. Update only one file at a time.
7. Do not directly modify GitHub without explicit approval.
8. Wait for the user's confirmation before moving to another file.
9. Do not create duplicate updated-version files without a clear need.
10. Keep stable rules, current status, plans and historical results in their designated documents.

When the user explicitly requests a small local change, a precise section replacement may be provided instead of rewriting unrelated content.

For full-file revisions, provide the complete replacement text.

### 13.3 Codex Rules

- Read repository instructions before modifying code.
- Work within the user's selected research task.
- Make small, reviewable changes.
- Preserve verified datasets and scripts.
- Report files changed and tests performed.
- Distinguish successful execution from scientific validation.
- Do not commit or push without user approval.

### 13.4 Session Handoff

At the end of a research session, provide:

```text
Current workstream:
Current task:
Research question:
Files used:
Verified results:
Unresolved issues:
Next action:
```

The repository should preserve essential project context across different conversations and coding sessions.

---

## 14. Guiding Principles

**Research Direction**

Maintain the long-term comparison of six-, seven- and eight-cable sensing systems.

**Engineering Priority**

Develop an adjustable six-cable experimental reference as early as reasonably practical.

**Parallel Research**

Allow seven-/eight-cable theory and simulation to progress alongside six-cable hardware development.

**Controlled Research**

Use separate experiments to understand the contributions of rail position, rail assignment, attachment location and cable pairing before attempting joint optimisation.

**Fair Comparison**

Apply consistent evaluation conditions and comparable optimisation effort across alternative configurations.

**Robustness**

Evaluate geometric margins, installation uncertainty and independent motion conditions rather than relying on pass counts alone.

**Flexible Sensing**

Evaluate rigid-to-flexible compatibility before final hardware sizing while retaining deformation and shape reconstruction as longer-term research goals.

**Scientific Integrity**

Distinguish numerical predictions, physical assumptions and experimental evidence.

**AI Collaboration**

Follow the active research question, preserve verified work and avoid unnecessary duplication.

> Research questions determine the methods. Numerical evidence supports design decisions. Experiments validate the physical system.
