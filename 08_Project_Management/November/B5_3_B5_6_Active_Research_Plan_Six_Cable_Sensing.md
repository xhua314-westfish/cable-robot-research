# B5.3–B5.6 Active Research Plan — Six-Cable Sensing

**Version:** 0.4  
**Last Updated:** 2026-11-12  
**Status:** Active Research Plan  
**Current Phase:** B5.4 — Configuration Optimisation  
**Completed:** B5.3 and E1a-A  
**Next Task:** E1a-B — Six-Configuration Fair Comparison  
**Primary Tool:** MATLAB

---

## 1. Purpose and Scope

This document defines the **remaining research tasks, methods, deliverables and acceptance criteria** for the six-cable sensing project.

It is an execution plan, not a research log or a full project history.

The current research objective is:

> Identify and validate a geometrically feasible, robust and practically implementable six-cable configuration for reconstructing the six-degree-of-freedom pose of a passively moving balloon.

The system measures passive motion rather than prescribing balloon trajectories.

For information that should not be duplicated here:

- [Current Research State](../../CURRENT_STATE2.md) — Verified progress and current numerical reference.
- [Research Roadmap](../Roadmap.md) — Long-term milestones.
- [Research Rules](../../AGENTS2.md) — Mathematical, coding and documentation requirements.
- [Research Logs](../../06_Research_Log/2026-11/) — Completed methods, results and evidence.

---

## 2. Completed Work and Starting Point

### Completed Research

| Task | Outcome | Evidence |
|---|---|---|
| B5.3 | Twelve-rail geometry and S1/S2/S3 structured configurations | [B5.3 Research Log](../../06_Research_Log/2026-11/B5_3_Twelve_Rail_Structured_Configuration_Research_Log_2026_11_11.md) |
| B5.4 Lesson 1 | Unified configuration evaluator | B5.4 MATLAB results |
| B5.4 Lesson 2 | Preliminary nonlinear pose estimator and simulated noise study | B5.4 MATLAB results |
| B5.4 E1a-A | Config 2 rail-position optimisation, failure repair and sampled robustness checks | [E1a Research Log](../../06_Research_Log/2026-11/B5_4_E1a_Anchor_Rail_Position_Optimisation_Research_Log_2026_11_12.md) |

### Current Starting Point

Six initial configurations passed the 189-pose Core geometry and rank screening:

```matlab
eligible_config_ids = [2 4 6 8 12 17];
```

Only Config 2 has undergone detailed E1a rail-position optimisation.

Its current preferred numerical reference is:

`E1a_Robust_Config2_v1`

This is **not** the final prototype or a proven globally optimal configuration.

The other five candidates remain eligible for further optimisation.

Detailed coordinates, numerical results and optimisation history must be retrieved from their Research Logs and saved MATLAB datasets.

---

## 3. Common Research Requirements

These requirements apply to E1a-B, E1b, E2, E3 and E4.

### 3.1 Configuration Representation

For each cable:

\[
A_i=A(\rho_i,t_i)
\]

The design variables are:

| Variable | Meaning |
|---|---|
| \(\rho_i\) | Rail assignment |
| \(t_i\) | Normalised position along the selected rail |
| \(r_i\) | Balloon attachment position |
| \(\pi\) | Anchor–attachment pairing |

Every experiment must explicitly state which variables are fixed and which are optimised.

### 3.2 Geometric Requirements

Evaluate:

- Valid anchor mounting on permitted rails.
- Cable–sphere outward departure.
- All 15 finite-segment Cable–cable distances.
- Cable length and stroke.
- Geometry passing counts.
- Minimum outward angular margin.

Numerical zero-thickness cable non-intersection is not equivalent to physical clearance.

Actual cable diameter, mounting offsets and connector dimensions remain engineering inputs.

### 3.3 Sensing Requirements

Evaluate:

- Jacobian rank.
- Worst-case scaled minimum singular value.
- Maximum scaled condition number.
- Simulated pose-estimation error.
- Estimator convergence and failures.

Use the established Jacobian convention and characteristic-length scaling defined in `AGENTS2.md`.

### 3.4 Fair Comparison

When comparing configurations:

1. Use identical evaluation definitions.
2. Use common pose sets.
3. Apply equivalent optimisation budgets.
4. Record fixed and variable parameters.
5. Preserve initial configurations as baselines.
6. Record failed candidates and failure reasons.
7. Use independent validation poses for final comparison.
8. Report geometric feasibility and sensing quality separately.

### 3.5 Development and Validation Data

The existing Core 189 and combined 539-pose datasets have already contributed to optimisation and failure diagnosis.

The 539-pose set is therefore development evidence, not a fully untouched final holdout.

A new independent validation set must be defined for final configuration comparison.

If validation data are used to repair or retune a candidate, they must be reclassified as development data.

---

## 4. B5.4 E1a-B — Six-Configuration Fair Comparison

**Status:** Next technical research task.

### Research Question

> After equivalent rail-position optimisation, which of the six Core-eligible configurations provides the best balance of sensing quality, geometric feasibility and robustness?

### Why This Task Is Necessary

Config 2 has already received extensive optimisation.

Directly comparing it with five unoptimised configurations would not be a fair design comparison.

E1a-B will apply a standardised procedure to all six candidates before selecting a shortlist.

### Controlled Variables

**Fixed:**

- Original Rail IDs.
- Original attachment coordinates.
- Original pairing.

**Variable:**

- Six rail-position parameters \(t_i\).

Each configuration must retain its own original geometry and identity.

### Lesson E1a-B.1 — Baseline Verification

**Tasks**

1. Load the six original B5.3 configurations.
2. Reproduce their Core screening results.
3. Verify Rail IDs, coordinates and pairings.
4. Record original \(t_i\).
5. Define common development pose samples.
6. Establish a fresh holdout-validation protocol.

**Deliverables**

- Reproducible six-configuration baseline.
- Common evaluation settings.
- Development and validation data definitions.

**Acceptance**

All six original configurations reproduce their saved results before optimisation begins.

### Lesson E1a-B.2 — Optimisation Objective and Budget

**Primary Objective**

\[
\max_t\min_{q\in Q_{\mathrm{dev}}}
\sigma_{\min}(H_s(q;t))
\]

Subject to required geometric and rank feasibility.

**Secondary Indicators**

- Minimum cable distance.
- Minimum outward angular margin.
- Maximum condition number.
- Pose-estimation error.
- Installation robustness.

**Tasks**

1. Define the common objective.
2. Define hard constraints.
3. Choose a reproducible search method.
4. Set comparable evaluation budgets.
5. Specify stopping conditions and numerical tolerances.

**Acceptance**

All configurations will be optimised using a documented and equivalent procedure.

### Lesson E1a-B.3 — Standardised Optimisation

**Tasks**

1. Perform rail-position sensitivity analysis.
2. Identify conditional feasible intervals.
3. Apply sequential or another justified position-only search.
4. Evaluate all candidates using the common development set.
5. Save the best feasible candidates and optimisation history.
6. Record unsuccessful searches.

A standardised run must also be performed for Config 2 so that historical hand-tuning does not create an unfair algorithmic comparison.

**Deliverables**

- Optimised \(t_i\) for each configuration.
- Updated anchor coordinates.
- Optimisation history.
- Before/after performance table.

**Acceptance**

Every configuration receives comparable optimisation effort and satisfies the same declared evaluation rules.

### Lesson E1a-B.4 — Robustness Evaluation

**Tasks**

1. Test combined translation and rotation.
2. Evaluate Cable–sphere departure margins.
3. Evaluate Cable–cable distances.
4. Test assumed installation perturbations.
5. Record geometry and rank failures.
6. Diagnose differences between the six candidates.

If diagnostic tests lead to further repairs, document the additional optimisation effort.

**Deliverables**

- Geometry and robustness comparison.
- Failure diagnosis.
- Robustness-related limitations.

**Acceptance**

All candidates are compared under common tests, with failures and assumptions reported transparently.

### Lesson E1a-B.5 — Pose Estimation and Shortlist

**Tasks**

1. Apply the same nonlinear estimator.
2. Use common synthetic measurement noise.
3. Compare position and orientation RMSE.
4. Record convergence and failure rates.
5. Freeze promising candidates.
6. Evaluate them on fresh independent validation data.
7. Identify Pareto-relevant configurations.

**Deliverables**

- Final E1a-B comparison table.
- Pareto shortlist.
- Selection rationale.
- E1a-B Research Log.

**Completion Gate**

E1a-B is complete when all six configurations have received a fair comparison and the next design candidates have been selected using reproducible evidence.

Do not proceed to a final prototype configuration decision solely on Config 2's current results.

---

## 5. B5.4 E1b — Rail Assignment Optimisation

**Status:** Planned after E1a-B.

### Research Question

> Can selecting different mounting rails improve geometric feasibility, sensing quality or robustness beyond optimisation along fixed rails?

### Variables

**Variable:** Rail assignment \(\rho_i\) and associated position \(t_i\).

**Fixed:** Attachment coordinates and pairing.

### Tasks

1. Define valid Rail Assignment rules.
2. Select configurations from the E1a-B shortlist.
3. Test controlled single-cable rail reassignment.
4. Optimise position on the reassigned rail.
5. Evaluate geometry and sensing.
6. Investigate coordinated reassignment if justified.
7. Compare against matched E1a baselines.

### Deliverables

- Alternative rail assignments.
- Updated anchor positions.
- Multi-pose comparison.
- Mechanical complexity assessment.

### Completion Gate

Determine whether rail reassignment provides meaningful benefits that justify the additional mounting complexity.

---

## 6. B5.4 E2 — Attachment Optimisation

**Status:** Planned.

### Research Question

> How do balloon-surface attachment locations influence geometry and sensing when anchor positions and pairing remain fixed?

### Variables

**Variable:** Attachment coordinates \(r_i\).

**Fixed:** Rail Assignment, anchor positions and pairing.

### Tasks

1. Define sphere-surface attachment constraints.
2. Establish attachment-spacing and mounting rules.
3. Search or optimise attachment locations.
4. Evaluate Cable–sphere and Cable–cable feasibility.
5. Evaluate worst-case sensing.
6. Test robustness to attachment placement errors.
7. Compare against matched fixed-anchor configurations.

### Deliverables

- Optimised attachment locations.
- Geometry and sensing comparison.
- Attachment robustness results.

### Completion Gate

Quantify whether attachment-only optimisation provides useful additional performance improvements.

---

## 7. B5.4 E3 — Cable Pairing Optimisation

**Status:** Planned.

### Research Question

> Can reassigning cable connections between fixed anchor and attachment point sets improve geometry or sensing?

### Variables

**Variable:** Pairing permutation \(\pi\).

**Fixed:** Anchor and attachment point sets.

### Tasks

1. Define valid pairing permutations.
2. Evaluate numerical cable interference.
3. Evaluate outward departure geometry.
4. Evaluate Jacobian quality.
5. Compare multi-pose sensing.
6. Record routing complexity.
7. Validate shortlisted pairings.

### Deliverables

- Pairing comparison.
- Geometry failure diagnostics.
- Selected pairing candidates.

### Completion Gate

Determine whether pairing changes provide benefits without unacceptable sensing or geometry trade-offs.

---

## 8. B5.4 E4 — Joint Configuration Optimisation

**Status:** Planned.

### Research Question

> Can coordinated optimisation of rail assignment, rail position, attachment points and pairing outperform the controlled-variable experiments?

### Variables

\[
\mathcal C_6=\{\rho_i,t_i,r_i,\pi\}_{i=1}^{6}
\]

### Tasks

1. Define the joint search space.
2. Establish geometric and mechanical constraints.
3. Select a justified optimisation algorithm.
4. Perform reproducible multi-start or structured searches.
5. Compare with E1a, E1b, E2 and E3.
6. Assess sensing, clearance and robustness.
7. Retain Pareto-relevant configurations.

### Deliverables

- Jointly optimised configurations.
- Controlled-versus-joint comparison.
- Shortlist for final validation.

### Completion Gate

Produce a defensible configuration shortlist without unsupported claims of global optimality.

---

## 9. B5.4 Final Robustness and Selection Gate

**Status:** Planned.

### Required Evaluation

- Independent unseen poses.
- Relevant motion paths.
- Minimum outward angular margin.
- Cable–cable clearance.
- Anchor and attachment uncertainty.
- Simultaneous installation perturbations.
- Measurement noise and bias.
- Estimator convergence.
- Mechanical mounting constraints.

### Selection Criteria

Use feasibility requirements before ranking sensing performance.

Retain a small number of Pareto-relevant candidates when justified.

### Deliverables

- Candidate comparison matrix.
- Configuration coordinates and pairing.
- Robustness results.
- Outstanding engineering risks.
- Shortlist for measurement validation.

**B5.4 Completion Gate:** Reproducible, geometrically defensible and numerically estimable candidates are available for further validation.

---

## 10. B5.5 — Measurement Validation and Calibration

**Status:** Planned.

### Main Research Question

> Can the shortlisted configurations recover passive rigid-body pose accurately and reliably under realistic measurement and modelling errors?

### Research Tasks

| Task | Main Activity | Expected Output |
|---|---|---|
| B5.5.1 | Cable-length noise and bias model | Measurement uncertainty specification |
| B5.5.2 | Nonlinear pose reconstruction | Position/orientation errors and convergence |
| B5.5.3 | Geometry and sensor calibration | Identified model parameters |
| B5.5.4 | Independent motion and fault tests | Robustness evidence |
| B5.5.5 | Ground-truth measurement protocol | Experimental validation procedure |
| B5.5.6 | Validation report | Accuracy and limitations |

### Key Requirements

- Ground truth must not be provided to the estimator as an unknown pose.
- Simulation noise assumptions must remain separate from sensor calibration data.
- Calibration and validation datasets must be separated.
- Report estimator failures, not only successful trials.
- Compare theoretical Jacobian predictions with pose-estimation results.

### Completion Gate

An estimator, uncertainty model and independent validation protocol are available.

Experimental accuracy must not be claimed before physical measurement.

---

## 11. B5.6 — Prototype Engineering and Decision

**Status:** Planned.

### Main Research Question

> Can the selected configuration be implemented as a mechanically feasible, low-tension cable-length sensing system?

### Research Tasks

| Task | Main Activity | Expected Output |
|---|---|---|
| B5.6.1 | Mechanical design and mounting | Frame, rails, guides and attachment interfaces |
| B5.6.2 | Cable travel and sensor requirements | Stroke, resolution and hardware specification |
| B5.6.3 | Low-tension feasibility | Cable tautness and disturbance assessment |
| B5.6.4 | Assembly and calibration | Registered physical geometry |
| B5.6.5 | Prototype measurement experiments | Ground-truth comparison |
| B5.6.6 | Prototype V1.0 decision | Retain, adjust or redesign |

### Key Requirements

- Model actual effective cable exit points.
- Consider finite cable and connector dimensions.
- Determine required cable length and stroke.
- Evaluate positive-tension operation without prescribing balloon motion.
- Verify installation and calibration accuracy.
- Compare experimental measurements with simulation predictions.

### Completion Gate

A reproducible prototype and measurement protocol support an evidence-based configuration decision.

If hardware is unavailable, report a prototype-ready design rather than claiming experimental validation.

---

## 12. Controlled-Variable Comparison

| Experiment | Rail ID | Rail Position | Attachment | Pairing |
|---|---|---|---|---|
| E0 | Fixed | Fixed | Fixed | Fixed |
| E1a | Fixed | Variable | Fixed | Fixed |
| E1b | Variable | Variable | Fixed | Fixed |
| E2 | Fixed | Fixed | Variable | Fixed |
| E3 | Fixed | Fixed | Fixed | Variable |
| E4 | Variable | Variable | Variable | Variable |

Every experiment must use an explicitly documented baseline.

The effects identified by controlled experiments are conditional on the variables held fixed. They do not establish that configuration variables are physically independent.

---

## 13. Open Engineering Requirements

The following remain unresolved and must be supported by hardware specifications, measurements or justified engineering calculations.

| Requirement | Current Status |
|---|---|
| Actual pulley and guide geometry | TBD |
| Mounting carriage dimensions | TBD |
| Rail-end exclusion zones | TBD |
| Physical cable clearance | TBD |
| Cable diameter and connector footprint | TBD |
| Cable length sensor characteristics | TBD |
| Anchor and attachment calibration accuracy | TBD |
| Allowed balloon disturbance | TBD |
| Positive-tension requirements | TBD |
| Independent ground-truth system | TBD |
| Required experimental pose accuracy | TBD |

Do not convert numerical tolerances or assumed uncertainty levels into physical acceptance requirements without supporting evidence.

---

## 14. Literature and Methodological Basis

The research process was informed by literature on:

- Cable-driven robot configuration optimisation.
- Interference-aware workspace analysis.
- Reconfigurable cable routing.
- Pose estimation and measurement uncertainty.
- Mechanical design and calibration.
- Prototype development and experimental validation.

Relevant doctoral research references include:

1. Joshua T. Bryson (2016), *The Optimal Design of Cable-Driven Robots*.
2. Philipp Miermeister (2020/2021), *Model Selection and Parameter Optimization for Cable-Driven Parallel Robots*.
3. Sara Gabaldo (2026), *Pose Estimation for Underactuated Cable-Driven Parallel Robots*.
4. Ruobing Wang (2023), *Prototype Design and Time-Optimal Control of a Lower-Mobility Cable-Driven Parallel Robot*.
5. Valentina Mattioni (2023), *Mechanical Design and Hybrid Control Strategies for Overconstrained Cable-Driven Parallel Robots*.
6. Damiano Zanotto (2011), *Analysis and Development of Cable-Driven Robotic Devices*.

These sources inform the research methodology. They do not directly establish the optimal design of this passive balloon sensing system.

Detailed citations and literature evidence belong in the relevant literature review and Research Logs.

---

## 15. Execution and Documentation Rules

Follow the stable working rules in [AGENTS2.md](../../AGENTS2.md).

For each research task:

1. Identify the research question.
2. Explain why the task is needed.
3. Identify literature and mathematical support.
4. Declare fixed and variable parameters.
5. Implement and verify the numerical method.
6. Interpret actual MATLAB results.
7. Record limitations and failures.
8. Make an evidence-based research decision.
9. Save completed work in a Research Log.
10. Update `CURRENT_STATE2.md` after meaningful verified milestones.

Historical scripts, data and logs must not be overwritten simply because a later configuration performs better.

---

## 16. Immediate Next Action

**B5.4 E1a-B.1 — Six-Configuration Baseline Verification**

Use:

```matlab
config_ids = [2 4 6 8 12 17];
```

### Required Actions

1. Load the original B5.3 configuration datasets.
2. Verify all six configurations.
3. Reproduce Core 189-pose screening results.
4. Confirm Rail IDs, rail positions, attachment coordinates and pairing.
5. Define common development pose samples.
6. Specify the final holdout-validation protocol.
7. Save a reproducible baseline comparison.

### Completion Criterion

All six baseline configurations are reproduced and can be compared using identical evaluation definitions.

Only then proceed to E1a-B.2 — Unified Optimisation Objective and Budget.

---

**Current Technical Priority:** E1a-B — Six-Configuration Fair Comparison.

**Subsequent Tasks:** E1b → E2 → E3 → E4 → B5.5 → B5.6.

**Research Principle:** Geometry determines feasibility; sensing metrics quantify measurement capability; robustness and experiments determine practical validity.
