# AGENTS2 — Research and AI Working Rules

**Version:** 0.8  
**Last Updated:** 2026-11-12  
**Project:** Cable-Robot-Based Sensing for a Passive Deformable Balloon  
**Primary Tool:** MATLAB  
**Document Type:** Stable Research and AI Collaboration Rules

---

## 1. Purpose

This document defines the stable scientific, technical and collaboration rules for the cable-robot research project.

It should be used by ChatGPT, Codex and other AI research assistants.

**AGENTS2.md is a working-rules document. It is not a research progress report, task list or experimental log.**

Do not duplicate current task descriptions, detailed numerical results or completed experiment histories here.

### Authoritative Documents

| Document | Responsibility |
|---|---|
| `README.md` | Project overview and navigation |
| `AGENTS2.md` | Stable scientific and AI collaboration rules |
| `CURRENT_STATE2.md` | Latest verified research progress |
| `08_Project_Management/Roadmap.md` | Long-term milestones |
| Active Research Plan | Current tasks, methods and acceptance criteria |
| `03_Simulation/MATLAB/` | Simulation code and numerical datasets |
| `05_My_Research/` | Technical models and research designs |
| `06_Research_Log/` | Completed research methods, results and decisions |

**Current Active Research Plan:**

`08_Project_Management/November/B5_3_B5_6_Active_Research_Plan_Six_Cable_Sensing.md`

If this plan is replaced, the new active path must be updated in the repository navigation documents.

Historical or explicitly superseded plans are for reference only.

---

## 2. Research Direction

### Main Research Goal

Develop a cable-length-based sensing system to estimate the position, orientation and eventually deformation of a passively moving balloon-like object.

The application is motivated by a simplified intragastric balloon environment.

### Passive Measurement Principle

The system is intended for **measurement and estimation, not active trajectory control**.

- Balloon motion is passive and potentially irregular.
- Cable-length changes provide measurement information.
- The estimator must not require the true trajectory as an input.
- Motors may follow cable displacement to maintain low positive tension.
- Cable-induced disturbance must be assessed experimentally.

Controlled motion may be used for testing and calibration, but should not be confused with the final passive sensing principle.

### Parallel Research Workstreams

**Workstream A — Six-Cable Prototype and Experimental Validation**

Primary research priority:

- Configuration optimisation.
- Geometry and sensing verification.
- Nonlinear pose estimation.
- Mechanical design and calibration.
- Low-tension measurement.
- Experimental validation.
- Initial rigid-to-flexible compatibility.

**Workstream B — Seven-/Eight-Cable Theory and Simulation**

Parallel research priority:

- Measurement redundancy.
- Observability.
- Sensing uncertainty.
- Workspace and interference.
- Tension feasibility.
- Comparative configuration performance.

Seven- and eight-cable research should not be abandoned merely because the six-cable prototype is the current engineering priority.

However, adding cables does not automatically guarantee improved sensing quality.

Detailed milestones belong in `Roadmap.md`.

---

## 3. Research-Question-Driven Workflow

Every substantial research task should follow:

```text
Research Question
        |
        v
Existing Evidence
        |
        v
Literature and Theory
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
Research Decision
        |
        v
Research Log
```

### Three Required Questions

For each research step, explain:

**1. Why is this task necessary?**

Identify the existing problem, limitation or research uncertainty.

**2. What theory or literature supports the method?**

Explain the mathematical basis, relevant references and their applicability.

**3. What research decision will the result enable?**

Define the expected output and the criteria for continuing, changing or rejecting the approach.

### General Requirements

- Start from the research problem, not an isolated learning exercise.
- Review existing work before implementing a new method.
- Use the simplest defensible model.
- Explain important assumptions.
- Define outputs and acceptance criteria.
- Verify results before interpreting them.
- Record unexpected outcomes and limitations.
- Avoid unnecessary repetition of completed work.

Do not introduce advanced algorithms without identifying the research problem they solve.

---

## 4. AI Teaching and Explanation Rules

Research discussions may be conducted in Chinese.

Use English for academic slides, technical document sections or other outputs when requested.

When explaining a new technical topic:

1. State the research question.
2. Explain why the topic matters.
3. Introduce the necessary theory.
4. Explain equations and physical meaning.
5. Identify assumptions and variable definitions.
6. Describe the MATLAB implementation logic.
7. Provide numerical verification methods.
8. Interpret actual results.
9. Explain limitations.
10. State the research decision and next step.

### MATLAB Learning Preferences

- Prefer incremental lessons.
- Use clear Chinese comments when preparing teaching scripts.
- Provide complete runnable code when requested.
- Explain inputs, outputs and important variables.
- Reuse verified code where possible.
- Encourage the researcher to run MATLAB and inspect the outputs.
- Do not invent execution results.
- Diagnose errors using actual code and output.
- Complete the current research question before introducing unrelated tasks.

The objective is to develop independent scientific understanding, not merely generate functioning code.

---

## 5. Mathematical Modelling Conventions

Every mathematical model must specify:

- Coordinate frames.
- State variables.
- Known parameters.
- Measurements.
- Units.
- Matrix dimensions.
- Assumptions.
- Constraints.
- Expected outputs.

### Default Units

| Quantity | Unit |
|---|---|
| Position and cable length | mm |
| Rotation increments in Jacobian models | rad |
| Displayed orientation angles | degrees, when labelled |
| Force and cable tension | N |
| Motor torque | N·m |

Avoid mixing units or silently changing coordinate conventions.

### Rigid-Body Cable Geometry

For cable \(i\):

\[
B_i=P+Rr_i
\]

\[
D_i=A_i-B_i
\]

\[
L_i=\|D_i\|
\]

where:

- \(P\): Balloon-centre position.
- \(R\): Body-to-world rotation matrix.
- \(r_i\): Body-frame attachment point.
- \(A_i\): World-frame anchor point.
- \(B_i\): World-frame attachment point.
- \(D_i\): Cable vector from attachment to anchor.
- \(L_i\): Cable length.

### Measurement Jacobian

Define:

\[
u_i=\frac{D_i}{L_i},\qquad s_i=Rr_i
\]

For local world-frame rotation increments:

\[
H_i=
\begin{bmatrix}
-u_i^T & (u_i\times s_i)^T
\end{bmatrix}
\]

The local measurement relation is:

\[
\delta L\approx H\delta q
\]

For \(n\) cables and six rigid-body degrees of freedom:

\[
H\in\mathbb{R}^{n\times6}
\]

Local first-order identifiability requires full column rank.

**Full rank does not prove globally unique pose reconstruction, high accuracy or physical feasibility.**

### Jacobian Scaling

Translation and rotation have different units.

Use a declared characteristic length when calculating scaled singular values and condition numbers.

For the current rigid spherical model, the established characteristic length is the nominal balloon radius.

Do not compare Jacobian metrics calculated using different scaling conventions without explicitly accounting for that difference.

---

## 6. Configuration and Workspace Rules

### Configuration Variables

For the rail-constrained six-cable model:

\[
A_i=A(\rho_i,t_i)
\]

where:

- \(\rho_i\): Rail assignment.
- \(t_i\): Normalised position along the assigned rail.
- \(r_i\): Body-frame attachment point.
- \(\pi\): Anchor–attachment pairing.

Each cable must have an explicit and reproducible anchor-to-attachment assignment.

### Distinguish Different Feasibility Concepts

1. **Geometric containment:** Is the balloon inside the required boundary?
2. **Cable routing:** Do cable paths avoid prohibited interference?
3. **Physical clearance:** Are there adequate margins for actual cables and connectors?
4. **Tension feasibility:** Can cables remain taut under appropriate force conditions?
5. **Sensing feasibility:** Can measurements provide sufficient pose information?
6. **Estimation performance:** Can an estimator reliably reconstruct the required state?

These are separate requirements.

A configuration may satisfy one but fail another.

### Workspace Interpretation

- A sampled pose set is not a continuous workspace proof.
- Zero-thickness cable non-intersection is not physical clearance.
- Jacobian rank does not establish positive-tension feasibility.
- Good reference-pose sensing does not establish multi-pose sensing quality.
- Low predicted covariance does not establish experimentally measured accuracy.

---

## 7. Configuration Optimisation Rules

Before any optimisation, define:

- Research question.
- Design variables.
- Fixed parameters.
- Objective function.
- Hard constraints.
- Evaluation pose set.
- Numerical tolerances.
- Search algorithm.
- Random seed and computational budget.
- Acceptance criteria.

### Controlled Experiments

Study the effects of:

- Anchor rail position.
- Rail assignment.
- Attachment position.
- Cable pairing.
- Joint configuration changes.

The exact experiment sequence belongs in the Active Research Plan.

### Fair Comparison

When comparing different configurations:

1. Preserve each original baseline.
2. Use common evaluation definitions.
3. Apply equivalent optimisation budgets.
4. Use compatible pose datasets.
5. Maintain consistent Jacobian scaling.
6. Record failed candidates.
7. Evaluate robustness and interference.
8. Use independent holdout tests for final comparison.
9. Report implementation complexity.
10. Avoid unsupported claims of global optimality.

A candidate that received more optimisation or manual repair should not be declared intrinsically superior without a fair comparison.

### Robustness

Where relevant, evaluate:

- Cable clearance.
- Outward angular margin.
- Anchor installation errors.
- Attachment errors.
- Measurement noise and bias.
- Independent unseen poses.
- Pose-estimation convergence.

Report all assumptions used for numerical robustness tests.

---

## 8. MATLAB and Numerical Verification

MATLAB is the primary computational environment.

CASPR may be used as a supplementary verification tool.

### Implementation Requirements

- Reuse existing verified functions.
- Prefer readable and modular code.
- Separate geometry, estimation, optimisation and evaluation where practical.
- Preserve original configuration datasets.
- Record all significant parameters.
- Avoid duplicate implementations with conflicting conventions.
- Do not overwrite verified historical outputs without a clear reason.

### Verification Checklist

Before accepting a numerical result:

1. Confirm matrix dimensions.
2. Check units and coordinate systems.
3. Verify known test cases.
4. Check analytical derivatives using numerical differentiation where appropriate.
5. Check constraints and numerical residuals.
6. Examine failure cases.
7. Reproduce important baseline results.
8. Record actual MATLAB outputs.
9. Document numerical limitations.

### Reproducibility

Record:

- Script and dataset names.
- Configuration IDs.
- Parameter values.
- Random seeds.
- Numerical tolerances.
- Solver settings.
- Search budgets.
- Pose evaluation sets.
- Successful and failed cases.

A script running without errors does not automatically establish scientific validation.

---

## 9. Development Data and Independent Validation

Always distinguish development data from independent validation data.

### Development Data

May be used for:

- Optimisation.
- Parameter tuning.
- Algorithm development.
- Failure diagnosis.
- Targeted configuration repair.

### Independent Validation Data

Must evaluate frozen candidates under conditions not previously used to tune those candidates.

If a validation sample causes a configuration change, that sample becomes development evidence for the modified configuration.

A new independent test is then required for an untouched final validation claim.

Do not compare statistics from different pose sets as if they used identical conditions.

---

## 10. Scientific Evidence and Accuracy

Use explicit evidence categories.

| Category | Meaning |
|---|---|
| Reported | Directly stated in a source |
| Derived | Obtained mathematically |
| Assumed | Introduced as a modelling choice |
| Numerically verified | Supported by executed computation |
| Experimentally validated | Supported by physical measurements |
| Unknown | Not yet established |

### Measurement Accuracy

Distinguish:

- Jacobian sensitivity.
- Theoretical local covariance.
- Simulated pose-estimation RMSE.
- Calibrated sensor accuracy.
- Experimentally measured pose-estimation error.

Simulation assumptions must not be presented as hardware specifications.

Experimental pose-error claims require an independent ground-truth reference.

### Numerical Result Reporting

For comparisons, identify:

1. Baseline and modified configurations.
2. Evaluation dataset.
3. Metric and units.
4. Assumptions.
5. Observed results.
6. Interpretation.
7. Remaining limitations.

Do not calculate improvement percentages by mixing statistics from incompatible evaluation sets.

---

## 11. Rigid-to-Flexible Research Rules

The rigid spherical balloon is an initial engineering model.

Future deformable-balloon research must consider:

- Deformation representation.
- Attachment migration.
- Cable–surface interference.
- Changes in cable length.
- Pose/deformation identifiability.
- Additional measurement requirements.
- Prototype adaptability.

For deformation parameters \(\eta\):

\[
\delta L\approx H_{\mathrm{rigid}}\delta q+
H_{\mathrm{def}}\delta\eta
\]

Six instantaneous scalar cable-length measurements cannot generally recover six unconstrained rigid-body pose variables together with additional independent deformation variables.

A deformation model must therefore introduce justified constraints, reduced-order states or additional measurements.

Do not claim full flexible shape reconstruction from rigid-body Jacobian verification alone.

---

## 12. Literature and Citation Rules

For papers used to support research methods, record:

- Exact title.
- Authors and year.
- DOI, when available.
- Main research question.
- Relevant methods and equations.
- Assumptions.
- Applicability to the balloon sensing system.
- Limitations of transferring the method.

Do not invent literature information or treat methods from active cable-driven robots as automatically validated for passive sensing.

Differentiate:

1. Published theory.
2. Published numerical or experimental results.
3. Project-specific mathematical adaptations.
4. Project-specific MATLAB verification.

Select literature according to the research problem, rather than collecting references without a clear purpose.

---

## 13. GitHub and Codex Collaboration

### Context Loading

At the beginning of a new research task:

1. Read `AGENTS2.md`.
2. Read `CURRENT_STATE2.md`.
3. Read the Active Research Plan.
4. Consult `Roadmap.md` if long-term context is needed.
5. Read relevant MATLAB scripts and Research Logs.

Do not rely only on previous chat context.

Do not treat archived plans as active instructions.

When evidence conflicts, identify the disagreement and check original numerical records before changing conclusions.

### Manual GitHub Updates

When the user requests manual repository updates:

1. Inspect the current file.
2. Identify outdated and duplicated content.
3. Preserve validated evidence.
4. Provide complete, copyable Markdown directly in chat.
5. Keep the original path unless renaming is explicitly requested.
6. Modify one file at a time.
7. Let the user manually commit changes.
8. Continue to another file only after confirmation.
9. Do not create duplicate versions unnecessarily.

For a small requested correction, a targeted replacement may be more appropriate than rewriting a whole file.

### Codex Coding Rules

- Work on the selected research task only.
- Read relevant files before writing code.
- Make changes that are easy to review.
- Preserve historical scripts and data.
- Report modified files and verification results.
- Separate code execution from scientific validation.
- Do not commit or push without authorisation.

### Session Handoff

Summarise important work using:

```text
Current workstream:
Current task:
Research question:
Files used:
Verified results:
Remaining limitations:
Next action:
```

The repository should allow a new ChatGPT or Codex session to resume the research without reconstructing the entire chat history.

---

## 14. Guiding Principles

**Research-driven learning:** The research problem determines what needs to be learned.

**Scientific integrity:** Distinguish assumptions, numerical evidence and experimental validation.

**Controlled optimisation:** Understand individual design variables before drawing conclusions about joint configuration changes.

**Fair comparison:** Use compatible evaluation sets and optimisation effort.

**Practical implementation:** Consider physical routing, tension, installation and calibration.

**Parallel research:** Maintain six-cable experimental development and seven-/eight-cable theoretical investigation.

**Clear documentation:** Store each type of information in its designated file and avoid duplication.

**AI collaboration:** Preserve verified results, explain scientific reasoning and support independent research decisions.

---

**Core Principle:** Research questions determine methods. Numerical evidence informs design. Independent validation and physical experiments establish practical performance.
