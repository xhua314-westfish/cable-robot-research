# Research Roadmap

**Version:** 0.6  
**Last Updated:** 2026-11-12  
**Project:** Cable-Robot-Based Sensing for a Passive Deformable Balloon  
**Current Phase:** Phase B — Balloon-Specific Cable Sensing Design  
**Current Milestone:** B5.4 — Sensing-Oriented Configuration Optimisation  
**Completed Substage:** B5.4 E1a-A — Config 2 Anchor Rail Position Optimisation  
**Next Technical Priority:** B5.4 E1a-B — Six-Configuration Fair Comparison  
**Primary Tool:** MATLAB

**Research Strategy:** Research-question-driven, prototype-oriented development with parallel six-, seven- and eight-cable sensing investigations.

---

## 1. Research Goal

### 1.1 Long-Term Research Objective

Develop a cable-based measurement and sensing system capable of estimating the position, orientation and eventually deformation of a passively moving balloon-like object.

The application is motivated by intragastric balloon monitoring within a simplified stomach-inspired environment.

### 1.2 Main Research Question

> Can cable-length measurements be used to estimate the pose and eventually deformation of a passively moving balloon, and how should cable configurations be designed to improve sensing performance while maintaining geometric and mechanical feasibility?

The system focuses on measurement and state estimation rather than active trajectory control.

Motors may follow passive balloon motion to maintain low positive cable tension, but the balloon motion itself is not prescribed.

### 1.3 Core Research Principles

1. Start from a specific research question.
2. Select mathematical and experimental methods based on that question.
3. Evaluate geometry and sensing performance together.
4. Use actual numerical evidence to guide design decisions.
5. Distinguish ideal numerical feasibility from physical feasibility.
6. Validate sensing accuracy with independent ground truth.
7. Avoid unsupported claims of global optimality.

---

## 2. Overall Research Strategy

### 2.1 Workstream A — Six-Cable Prototype and Experimental Validation

**Priority:** Primary engineering and experimental workstream.

Main objectives:

1. Establish a reproducible six-cable geometric and sensing model.
2. Generate mechanically meaningful anchor and attachment configurations.
3. Identify geometrically feasible configurations.
4. Optimise sensing performance.
5. Validate nonlinear pose reconstruction.
6. Introduce practical installation, clearance and tension constraints.
7. Select a prototype-ready configuration.
8. Develop and calibrate a six-cable experimental platform.
9. Validate pose-estimation accuracy experimentally.
10. Investigate deformable-balloon compatibility.

The six-cable prototype will establish the experimental reference for subsequent system comparison.

### 2.2 Workstream B — Seven- and Eight-Cable Theory and Simulation

**Priority:** Parallel research, without delaying Workstream A.

Main objectives:

1. Extend the measurement Jacobian to seven and eight cables.
2. Investigate sensing redundancy.
3. Compare local observability and conditioning.
4. Analyse pose-estimation uncertainty.
5. Evaluate cable interference and geometric workspace.
6. Investigate positive-tension feasibility.
7. Compare estimation performance using identical pose samples.
8. Evaluate additional hardware complexity.
9. Determine whether experimental cable-number expansion is justified.

Additional cables are not assumed to improve sensing automatically.

### 2.3 Workstream Integration

Both workstreams should use consistent:

- Coordinate systems.
- Balloon geometry assumptions.
- Pose evaluation regions.
- Geometric feasibility definitions.
- Jacobian scaling.
- Noise assumptions.
- Estimation metrics.
- Mechanical constraints.

The theoretical seven-/eight-cable study may progress while the six-cable prototype is being developed.

---

## 3. Overall Research Roadmap

| Phase | Main Research Question | Expected Outcome | Status |
|---|---|---|---|
| Phase 0 | What problem should the sensing system solve? | Application and requirements | Initial synthesis completed |
| Phase A | Which published methods are applicable? | Verified mathematical methods | Core scope completed |
| B1 | How should the geometry be defined? | Engineering model and candidate sets | Completed |
| B2 | How should the first six-cable configurations be selected? | Initial baseline and A/B configurations | Completed |
| B3 | Are the configurations geometrically feasible? | Multi-pose geometric screening | Completed |
| B4 | Can cable lengths provide sufficient pose information? | Jacobian and initial uncertainty analysis | Initial scope completed |
| B5.1 | Why do initial configurations fail? | Configuration audit and candidate expansion | Completed |
| B5.2 | How do configurations perform across multiple poses? | Multi-pose geometry comparison | Completed |
| B5.3 | How can literature and installation constraints improve design? | Twelve-rail structured configurations | Completed |
| B5.4 | How should configuration variables be optimised? | Controlled and joint optimisation | Active |
| B5.5 | How accurately can the system estimate pose? | Calibration and measurement validation | Planned |
| B5.6 | Can the configuration become a working prototype? | Prototype V1.0 engineering and experimental decision | Planned |
| B6 | What additional engineering requirements are needed? | Detailed hardware sizing and refinement | Planned / partially integrated with B5.6 |
| B7 | How should the experimental system be extended? | Prototype refinement and additional experimental capability | Future |
| B8 | How robust is the system under broader experimental conditions? | Extended experimental validation | Future |
| B9 | What final configuration and cable number are justified? | Final comparison and conclusions | Future |

**Planning rule:** The detailed current work packages are B5.3–B5.6. The historical B6–B9 stages remain long-term headings and must not duplicate work already completed in B5.6.

---

## 4. Phase 0 — Application Definition

**Status:** Initial synthesis completed.

### Objective

Define the application, clinical motivation, measurement requirements and preliminary physical environment.

### Established Outcomes

- Clinical monitoring evidence reviewed.
- Gastric balloon geometry and clinical context investigated.
- Nominal balloon volume selected: 550 mL.
- Simplified rectangular engineering boundary established.
- Initial six-degree-of-freedom rigid-body sensing objective defined.
- Passive motion and measurement-focused system architecture established.

### Remaining Limitations

- Actual gastric motion limits remain uncertain.
- The simplified frame is not a clinically validated gastric lumen.
- Patient-specific anatomy is not included.
- Deformable-balloon behaviour remains outside the current rigid model.

**Decision:** Use the simplified model as an engineering research platform, not as a validated anatomical representation.

---

## 5. Phase A — Literature-Based Method Reproduction

**Status:** Core scope completed.

### Objective

Understand and reproduce the mathematical methods needed for cable-based sensing and configuration evaluation.

| Task | Main Research Method |
|---|---|
| A1 | Wrench feasibility, RREF and tension-related analysis |
| A2 | Single-pose feasible anchor region |
| A3 | Multi-pose feasible-region intersection |
| A4 | Forward kinematics and Jacobian analysis |
| A5 | Workspace sampling and numerical evaluation |

### Outcome

Reusable methods for:

- Cable geometry.
- Jacobian computation.
- Workspace sampling.
- Wrench feasibility.
- Conditioning and uncertainty analysis.
- Monte Carlo simulation.

**Limitation:** Reproduced literature methods do not directly validate a balloon-specific sensing system.

---

# 6. Phase B — Six-Cable Configuration Design

## 6.1 Engineering Baseline

| Parameter | Current Definition |
|---|---|
| Engineering boundary | 280 × 300 × 320 mm |
| X-axis | Length |
| Y-axis | Width |
| Z-axis | Height |
| Balloon model | Rigid sphere |
| Balloon volume | 550 mL |
| Balloon radius | Approximately 50.8266 mm |
| Initial cable number | 6 |
| Primary measurement | Cable length |
| Balloon motion | Passive and unknown |
| Current anchor installation model | Twelve frame-edge rails |
| Attachment installation region | Balloon surface |

The model assumes ideal straight cables.

Cable diameter, pulley position, attachment hardware, actual mounting dimensions and tension requirements remain open engineering inputs.

---

## 6.2 B1 — Initial Geometry and Candidate Definition

**Status:** Completed.

### Research Question

How can the balloon environment and candidate cable connection points be represented mathematically?

### Completed Work

- Defined the engineering boundary.
- Defined the equivalent spherical balloon.
- Generated feasible balloon-centre candidates.
- Generated 26 initial anchor candidates.
- Generated 40 initial attachment candidates.
- Verified candidate geometry.

### Outcome

A reproducible initial candidate-generation and verification framework.

### Limitation

The original anchor candidates were sampled on rectangular boundary faces without requiring installation on twelve frame edges.

---

## 6.3 B2 — Initial Six-Cable Configuration Search

**Status:** Completed.

### Research Question

How do anchor and attachment positions influence local six-degree-of-freedom sensing?

Three configurations were compared:

| Metric | Baseline | Experiment A | Experiment B |
|---|---:|---:|---:|
| Jacobian rank | 6 | 6 | 6 |
| Scaled minimum singular value | 0.004393 | 0.535345 | 0.533600 |
| Scaled condition number | 490.956 | 3.5759 | 3.2365 |

### Outcome

Anchor and attachment placement significantly influence the measurement Jacobian.

### Main Limitation

Optimisation at a single reference pose cannot establish multi-pose geometric feasibility.

---

## 6.4 B3 — Multi-Pose Geometric Feasibility

**Status:** Completed.

### Research Question

Do the initial configurations remain geometrically feasible when the balloon moves and rotates?

Historical benchmark:

- 27 balloon-centre positions.
- Seven orientation cases.
- 189 total sampled poses.

| Metric | Experiment A | Experiment B |
|---|---:|---:|
| Geometrically feasible poses | 40/189 | 105/189 |
| Main observed limitation | Cable–sphere interference | Cable 5–6 contact |

### Research Outcome

Good reference-pose sensing does not guarantee adequate multi-pose geometry.

This motivated configuration redesign and multi-pose screening.

---

## 6.5 B4 — Jacobian and Sensing Verification

**Status:** Core Jacobian and initial noise analyses completed.

### Research Question

Can six cable lengths provide locally independent information about the balloon's six rigid-body degrees of freedom?

Completed:

- Analytical Jacobian verification.
- Numerical finite-difference comparison.
- Rank analysis.
- Singular-value analysis.
- Condition-number evaluation.
- Simulated local uncertainty analysis.

### Research Outcome

Experiment B generally provided better local sensing performance than Experiment A over the evaluated feasible poses.

### Limitations

- Full Jacobian rank does not prove global pose uniqueness.
- Local uncertainty does not equal experimental measurement accuracy.
- Independent ground truth and physical sensor calibration remain necessary.

Preliminary nonlinear pose-estimation and noise sensitivity were subsequently investigated during B5.4.

---

# 7. B5.1–B5.2 — Configuration Diagnosis and Redesign Motivation

## 7.1 B5.1 — Candidate Expansion and Pairing Investigation

**Status:** Completed.

### Research Question

Why do the initial configurations fail, and what changes are needed?

Candidate expansion:

| Parameter | Initial | Expanded |
|---|---:|---:|
| Anchor candidates | 26 | 98 |
| Attachment candidates | 40 | 100 |

Modified B′ demonstrated the importance of cable pairing:

| Metric | Original B | Modified B′ |
|---|---:|---:|
| Wider-benchmark geometry | 105/189 | 189/189 |
| Reference minimum singular value | 0.533600 | 0.075854 |
| Reference condition number | 3.2365 | 23.575 |

### Research Outcome

Improving geometry through pairing may seriously reduce sensing quality.

Therefore, configuration optimisation must treat geometry and sensing as related but distinct objectives.

---

## 7.2 B5.2 — Multi-Pose Configuration Screening

**Status:** Completed.

Five configurations were compared:

- Original B.
- Modified B′.
- F1 — Six-Face Distributed.
- F2 — Opposite/Layered.
- F3 — Asymmetric.

| Configuration | Core Geometry | Wider Benchmark Geometry |
|---|---:|---:|
| Original B | 108/189 | 105/189 |
| Modified B′ | 189/189 | 189/189 |
| F1 | 74/189 | 54/189 |
| F2 | 189/189 | 178/189 |
| F3 | 189/189 | 157/189 |

### Research Outcome

The results showed that:

1. Candidate expansion alone does not guarantee improvement.
2. Geometric feasibility can vary substantially across poses.
3. Cable pairing changes both routing and sensing.
4. Structured configurations should be investigated.
5. Actual prototype installation constraints must be considered.

---

# 8. B5.3 — Literature-Informed Twelve-Rail Configuration Design

**Status:** Completed for initial structured configuration generation and screening.

## 8.1 Research Question

How can cable configurations be designed using literature-informed geometric principles while respecting realistic anchor mounting regions?

## 8.2 Literature and Design Motivation

Relevant literature is reviewed in:

`02_Paper_Reading/Literature_Review/workspace definition/`

The literature informed:

- Structured anchor and attachment arrangements.
- Reconfigurable cable routing.
- Cable interference avoidance.
- Multi-pose workspace evaluation.
- Configuration optimisation under geometric constraints.

The twelve-rail model was adopted as a project-specific engineering requirement.

## 8.3 Twelve-Rail Anchor Model

The rectangular frame contains:

- Four X-direction rails.
- Four Y-direction rails.
- Four Z-direction rails.

Total:

\[
N_{\mathrm{rail}}=12
\]

Each anchor is described using:

\[
A_i(\rho_i,t_i)
\]

where:

- \(\rho_i\) is the selected rail.
- \(t_i\in[0,1]\) is the normalised rail position.

This separates rail assignment from position optimisation.

## 8.4 Three Structured Configuration Families

| Family | Rail Arrangement | Research Hypothesis |
|---|---|---|
| S1 — Structured Layered | 4 X + 2 Z | Layered layouts may support good geometric coverage and sensing |
| S2 — Distributed | 2 X + 2 Y + 2 Z | Distributed directions may improve measurement independence |
| S3 — Asymmetric | 1 X + 2 Y + 3 Z | Controlled asymmetry may improve weak sensing directions |

These are experimentally testable design hypotheses, not established optimal structures.

## 8.5 Initial Configuration Generation

Each family generated six anchor layouts.

Total:

\[
3\times6=18
\]

The procedure included:

1. Rail assignment.
2. Anchor-position sampling.
3. Attachment selection.
4. Cable pairing search.
5. Reference-pose screening.
6. Multi-pose evaluation.

## 8.6 Multi-Pose Screening

The Core development set contains:

\[
27\text{ positions}\times7\text{ orientations}=189
\]

Each configuration was evaluated for:

- Cable–sphere outward direction.
- Cable–cable interference.
- Jacobian rank.
- Worst-case scaled minimum singular value.
- Condition number.
- Cable length and stroke.

Six of the eighteen configurations passed all 189 Core geometry and rank checks.

\[
\boxed{[2,\ 4,\ 6,\ 8,\ 12,\ 17]}
\]

| Config | Family | Worst-Core \(\sigma_{\min}\) | Minimum Cable Distance |
|---|---|---:|---:|
| 2 | S1 | 0.396711 | 4.6508 mm |
| 4 | S1 | 0.202621 | 34.2128 mm |
| 6 | S1 | 0.268443 | 18.1059 mm |
| 8 | S2 | 0.226512 | 9.5408 mm |
| 12 | S2 | 0.366266 | 9.3165 mm |
| 17 | S3 | 0.278687 | 15.2926 mm |

### B5.3 Decision

All six configurations remain valid initial candidates.

Config 2 was selected for the first detailed rail-position optimisation because of its relatively strong Core sensing performance.

It was not established as the final optimal configuration.

---

# 9. B5.4 — Sensing-Oriented Configuration Optimisation

**Status:** Active.

## 9.1 Main Research Question

How do rail assignment, anchor position, attachment position and cable pairing independently and jointly influence geometric feasibility, sensing performance and practical implementation?

## 9.2 Common Evaluation Requirements

All candidate configurations must be evaluated using consistent:

- Pose samples.
- Jacobian definitions.
- Geometry criteria.
- Numerical tolerances.
- Sensing metrics.
- Clearance calculations.
- Installation assumptions.
- Optimisation budgets.

A single-pose optimum is not sufficient.

The research must also distinguish:

- Development poses.
- Independent validation poses.
- Simulated sensor noise.
- Actual calibration and measurement data.

## 9.3 B5.4 Lesson 1 — Unified Evaluator

**Status:** Completed.

The unified evaluator reproduced all eighteen B5.3 configurations.

Regression errors for the previously saved geometric and sensing results were zero in the completed test.

### Outcome

A common numerical evaluation baseline is available.

## 9.4 B5.4 Lesson 2 — Nonlinear Pose Estimation

**Status:** Preliminary numerical validation completed.

The first noise-free test reconstructed six-degree-of-freedom pose from simulated cable lengths.

A subsequent noise-sensitivity experiment used:

\[
\sigma_L=0.1\ \mathrm{mm}
\]

All 2160 simulated tests converged under the tested conditions.

Observed results included:

- Lowest position RMSE: Config 12, 0.16779 mm.
- Lowest orientation RMSE: Config 2, 0.21444°.

These are results under assumed numerical noise, not experimentally measured accuracy.

---

## 9.5 E1a-A — Config 2 Rail Position Optimisation

**Status:** Completed as a controlled numerical case study.

### Design Variables

Optimise:

\[
t_1,t_2,t_3,t_4,t_5,t_6
\]

Keep fixed:

- Rail assignment.
- Attachment points.
- Cable pairing.

### Research Procedure

**Step 1 — Single-Variable Scan**

Study how independent changes in each \(t_i\) affect geometry, sensing and cable distance.

**Step 2 — Conditional Feasible Intervals**

Scan each rail over \(t\in[0,1]\) while keeping other variables fixed.

Identify conditional feasible regions and transition boundaries.

**Step 3 — Sequential Coordinate Search**

Optimise individual rail positions sequentially, using two objectives:

- Improve Worst-Core Sensing.
- Improve Minimum Cable Clearance.

Each accepted change updates the complete configuration.

**Step 4 — Off-Grid Verification**

Check additional combined translation-and-rotation poses beyond the original Core samples.

**Step 5 — Failure Diagnosis**

Identify geometrically failing cables and poses.

**Step 6 — Targeted Repair**

Repair C1 and C4 Cable–sphere interference by adjusting their anchor rail positions.

**Step 7 — Sampled Robustness Verification**

Evaluate combined pose samples, outward angular margin, cable distance and assumed installation perturbations.

### Initial Config 2

Rail assignment:

```matlab
rho = [5 6 7 8 1 4];
```

Initial positions:

```matlab
t_original = [ ...
    0.400000 0.600000 0.550000 ...
    0.450000 0.700000 0.300000 ];
```

### Current Preferred E1a Configuration

**ID:** `E1a_Robust_Config2_v1`

```matlab
t_E1a = [ ...
    0.375000 0.446898 0.304465 ...
    0.470000 0.754805 0.314867 ];
```

Verified results on the combined 539-pose development set:

| Metric | Result |
|---|---:|
| GeometryPass | 539/539 |
| Full-rank Jacobian | 539/539 |
| Worst scaled minimum singular value | 0.508750 |
| Minimum ideal cable distance | 6.1055 mm |
| Minimum outward angular margin | +1.545778° |
| Single-anchor installation perturbations | 12/12 |

### Important Limitations

- The 539-pose set has been used for failure diagnosis and repair, so it is not a fully untouched final holdout.
- Tests are discrete and do not prove continuous workspace feasibility.
- The 12 perturbation tests do not cover simultaneous installation errors.
- Actual mechanical clearance and tension have not been validated.
- The current result is not the globally optimal six-cable configuration.

---

## 9.6 E1a-B — Six-Configuration Fair Comparison

**Status:** Next technical research priority.

### Research Question

How do all six Core-eligible configurations perform after equivalent anchor rail-position optimisation?

Candidates:

\[
[2,\ 4,\ 6,\ 8,\ 12,\ 17]
\]

### Why This Stage Is Necessary

Only Config 2 has undergone detailed E1a optimisation.

A strong result from Config 2 does not establish that S1 is superior to S2 or S3.

Other candidates may achieve better sensing, clearance, robustness or balance after equivalent optimisation.

### Proposed Method

1. Preserve each configuration's Rail Assignment.
2. Preserve each configuration's Attachment Points.
3. Preserve each configuration's Cable Pairing.
4. Optimise only \(t_i\).
5. Use equivalent search budgets and numerical settings.
6. Apply identical geometric and sensing acceptance criteria.
7. Evaluate using common development poses.
8. Retain failures and rejected designs.
9. Use a fresh independent validation set for final comparison.
10. Compare performance and retain Pareto-relevant candidates.

### Required Outputs

- Before/after comparison for all six configurations.
- Worst-case sensing quality.
- GeometryPass and Jacobian Rank.
- Minimum outward angular margin.
- Minimum Cable–cable distance.
- Installation sensitivity.
- Pose-estimation performance.
- Family-level design observations.
- Shortlist for E1b and subsequent optimisation.

### Completion Criteria

A transparent and reproducible comparison across all six candidate configurations, without giving Config 2 an unfair optimisation advantage.

---

## 9.7 E1b — Rail Assignment Optimisation

**Status:** Planned after E1a-B.

### Research Question

Can changing the selected installation rails improve performance beyond optimisation along the currently assigned rails?

### Variables

Change:

\[
\rho_i
\]

and re-optimise the corresponding rail position \(t_i\).

Keep fixed initially:

- Attachment coordinates.
- Cable pairing.

### Proposed Method

Start with controlled single-cable rail reassignment.

Then investigate coordinated reassignment if justified.

### Key Constraints

- Valid twelve-rail membership.
- Realistic mounting locations.
- Cable–sphere feasibility.
- Cable–cable interference.
- Sensing quality.
- Installation robustness.
- Rail-end and hardware interface requirements.

### Expected Outcome

Determine whether alternative mounting edges offer meaningful improvements over position-only optimisation.

---

## 9.8 E2 — Attachment Point Optimisation

**Status:** Planned.

### Research Question

How do balloon-surface attachment positions affect sensing quality and cable geometry when anchor locations and pairing are controlled?

### Main Activities

- Define attachment design variables.
- Use sphere-surface constraints.
- Investigate attachment spacing.
- Optimise sensing quality.
- Check cable departure direction.
- Evaluate multi-pose geometry.
- Assess attachment placement sensitivity.

### Expected Outcome

A controlled assessment of the contribution of attachment-position optimisation.

---

## 9.9 E3 — Pairing Optimisation

**Status:** Planned.

### Research Question

How does changing the correspondence between fixed Anchor and Attachment point sets affect geometry and sensing?

### Main Activities

- Define pairing permutations.
- Check cable routing and crossing.
- Evaluate cable–sphere departure.
- Compare Jacobian performance.
- Preserve exact pairing records.
- Investigate sensitivity to pairing changes.

### Expected Outcome

Identify whether pairing changes offer additional advantages after anchor and attachment optimisation.

---

## 9.10 E4 — Joint Configuration Optimisation

**Status:** Planned.

### Research Question

Can coordinated optimisation of rail assignment, anchor position, attachment position and pairing produce better feasible sensing configurations than separate optimisation?

### Design Variables

\[
\mathcal C=\{\rho_i,t_i,r_i,\pi\}_{i=1}^{6}
\]

### Main Activities

- Define joint design-variable representation.
- Establish geometric and mechanical constraints.
- Define sensing and robustness objectives.
- Select appropriate optimisation algorithms.
- Compare initial and optimised configurations.
- Evaluate independent pose sets.
- Identify Pareto-relevant configurations.
- Document optimisation limitations.

### Expected Outcome

A numerically justified shortlist for detailed sensing validation and prototype engineering.

Global optimality must not be claimed without appropriate evidence.

---

## 9.11 B5.4 Completion Criteria

Before a configuration is considered ready for detailed prototype engineering:

- [ ] Anchor coordinates and Rail IDs are documented.
- [ ] Attachment coordinates are documented.
- [ ] Cable pairing is explicit.
- [ ] Multi-pose geometry is evaluated.
- [ ] Rank and sensing metrics are evaluated.
- [ ] Cable clearance and outward margins are assessed.
- [ ] Independent pose validation is performed.
- [ ] Installation sensitivity is assessed.
- [ ] Nonlinear pose reconstruction is tested.
- [ ] Mechanical limitations are identified.
- [ ] A defensible shortlist is produced.

**Expected Deliverable:** A shortlist of sensing-oriented, geometrically feasible and mechanically plausible six-cable configurations.

---

# 10. B5.5 — Measurement Validation and Calibration

**Status:** Planned.

## Research Question

Can the proposed cable-length measurement system accurately and reliably reconstruct passive rigid-body pose under realistic measurement errors?

### Main Tasks

**B5.5.1 — Measurement Noise and Bias Model**

Investigate:

- Random length noise.
- Systematic cable-length offset.
- Encoder resolution.
- Calibration uncertainty.
- Cable-related measurement errors.

**B5.5.2 — Pose Reconstruction Validation**

Evaluate:

- Position RMSE.
- Orientation RMSE.
- Estimator convergence.
- Initialisation sensitivity.
- Multiple-solution behaviour.

**B5.5.3 — Calibration and Model Selection**

Investigate:

- Anchor position calibration.
- Attachment position calibration.
- Length zero-offset calibration.
- Model mismatch.
- Error propagation.

**B5.5.4 — Independent Motion and Fault Tests**

Evaluate:

- Previously unseen poses.
- Combined motion.
- Sensor bias.
- Cable measurement failure.
- Perturbed geometry.

**B5.5.5 — Ground-Truth and Experimental Protocol**

Define:

- Independent pose measurement.
- Calibration procedures.
- Repeated-trial protocol.
- Acceptance criteria.
- Data storage and analysis.

**B5.5.6 — Validation Report**

Summarise numerical and experimental evidence with documented uncertainty.

### Expected Outcome

A measurement-validation framework that can support defensible claims about pose-estimation accuracy.

---

# 11. B5.6 — Prototype V1.0 Engineering and Decision

**Status:** Planned.

## Research Question

Can the selected six-cable configuration be implemented as a practical low-tension measurement system?

### Main Tasks

**B5.6.1 — Mechanical Design**

- Frame layout.
- Anchor mounts.
- Rail-end clearance.
- Pulley and cable-guide positions.
- Attachment hardware.
- Actual cable interference checks.

**B5.6.2 — Measurement Hardware and Stroke**

- Cable length ranges.
- Cable payout and retrieval.
- Encoder and sensor selection.
- Mechanical resolution.
- Cable winding mechanism.

**B5.6.3 — Low-Tension Feasibility**

- Cable tautness.
- Positive-tension requirements.
- Balloon motion disturbance.
- Motor following behaviour.
- Quasi-static load assumptions.

**B5.6.4 — Assembly and Calibration**

- Frame assembly.
- Anchor position registration.
- Cable-length zero calibration.
- Sensor setup.
- Mechanical alignment.

**B5.6.5 — Prototype Experiments**

- Static pose reconstruction.
- Controlled reference displacement for measurement testing.
- Passive balloon motion.
- Position and orientation measurement.
- Cable tension monitoring.

**B5.6.6 — Prototype V1.0 Decision**

Decide whether to:

- Retain the selected configuration.
- Adjust anchor locations.
- Change attachment locations.
- Modify cable pairing.
- Redesign mechanical components.

### Expected Outcome

A first-generation six-cable measurement prototype supported by numerical and experimental evidence.

Building a frame alone does not establish sensing accuracy.

---

# 12. Long-Term Engineering and Experimental Development

The original B6–B9 stages remain useful as broader milestones.

However, their responsibilities must be coordinated with the detailed B5.5–B5.6 work packages to avoid duplicate tasks.

## B6 — Detailed Engineering Sizing and Refinement

Focus:

- More complete cable tension and load analysis.
- Final motor and sensor specification.
- Mechanical tolerances.
- Hardware safety margins.
- Repeatability and reliability.

Engineering calculations started during B5.6 should not be repeated without a new research purpose.

## B7 — Prototype Refinement and Experimental Capability

Focus:

- Improved mounting and cable routing.
- Calibration refinement.
- Mechanical repeatability.
- Flexible-balloon compatibility.
- Expansion interfaces for additional cables.

## B8 — Extended Experimental Validation

Focus:

- Repeated pose-estimation experiments.
- Broader motion conditions.
- Sensor and mechanical uncertainty.
- Passive motion disturbance.
- Initial deformation-related experiments.

## B9 — Final Configuration and Cable-Number Comparison

Focus:

- Six-/seven-/eight-cable comparison.
- Measurement redundancy.
- Pose-estimation accuracy.
- Feasible sensing workspace.
- Cable routing complexity.
- Tension and implementation requirements.
- Deformation-estimation potential.

Final conclusions must distinguish theoretical, simulated and experimentally validated findings.

---

# 13. Current Research Progress and Next Actions

**Status Date:** 2026-11-12

## Completed

- Phase 0 initial application definition.
- Phase A core method reproduction.
- B1 initial candidate generation.
- B2 initial six-cable configuration comparison.
- B3 multi-pose geometric feasibility.
- B4 Jacobian and initial sensing quality.
- B5.1 candidate expansion and pairing diagnosis.
- B5.2 five-configuration multi-pose screening.
- B5.3 twelve-rail structured configuration design.
- B5.3 selection of six Core-eligible configurations.
- B5.4 unified evaluator.
- B5.4 preliminary nonlinear pose-estimation validation.
- B5.4 simulated noise sensitivity.
- B5.4 E1a-A Config 2 rail-position optimisation.
- B5.4 E1a-A C1/C4 failure diagnosis and repair.
- B5.4 E1a-A final sampled robustness comparison.

## Immediate Project-Management Tasks

1. Consolidate the research timeline.
2. Update `CURRENT_STATE2.md`.
3. Update `Roadmap.md`.
4. Revise the active November research plan.
5. Check README and other older documents for conflicts.
6. Prepare a concise research presentation framework.

## Next Technical Research Task

**B5.4 E1a-B — Fair Comparison of Six Core-Eligible Configurations**

Use the mature E1a optimisation and evaluation approach to investigate:

\[
[2,\ 4,\ 6,\ 8,\ 12,\ 17]
\]

Do not declare Config 2 globally optimal before conducting a fair comparison.

## Subsequent Tasks

1. E1b — Rail Assignment Optimisation.
2. E2 — Attachment Optimisation.
3. E3 — Pairing Optimisation.
4. E4 — Joint Configuration Optimisation.
5. B5.5 — Measurement Validation.
6. B5.6 — Prototype Engineering and Decision.

---

# 14. Related Repository Documents

## Research Context

- [Current Research State](../CURRENT_STATE2.md)
- [Research Working Rules](../AGENTS2.md)

## Active Research Planning

- [Revised B5.3–B5.6 Plan](November/B5_3_to_B5_6_Revised_Research_Plan_Thesis_Informed_2026_11_10.md)

The detailed November plan should be updated to reflect the completion of E1a-A and the new E1a-B priority.

## Technical Research

- [MATLAB Simulations](../03_Simulation/MATLAB/)
- [Technical Research Models](../05_My_Research/)
- [Literature Review](../02_Paper_Reading/Literature_Review/)

## Research Evidence

- [Research Logs](../06_Research_Log/2026-11/)

Relevant records include:

- B5.1 candidate expansion and pairing investigation.
- B5.2 multi-pose screening.
- B5.3 twelve-rail configuration design.
- B5.4 E1a anchor rail-position optimisation.

Historical research results should be preserved, not silently overwritten.

---

## 15. Roadmap Decision Principles

**Geometry First**

A configuration must satisfy the required geometric constraints before being considered a practical sensing candidate.

**Sensing Performance**

Among geometrically feasible candidates, evaluate measurement quality using Jacobian and actual pose-estimation metrics.

**Robustness**

Include outward angular margin, cable clearance, installation uncertainty and independent validation.

**Mechanical Feasibility**

Verify that numerical anchor positions can be realised using actual mounts, cable guides and frame geometry.

**Controlled Experiments**

Investigate rail position, rail assignment, attachment position and pairing separately before joint optimisation.

**Fair Comparison**

Apply equivalent optimisation effort and common evaluation criteria across candidate configurations.

**Prototype Development**

Avoid unnecessarily delaying experimental development, but do not freeze a design that has not passed its required engineering checks.

**Research Integrity**

Keep assumptions, numerical predictions and experimentally measured results clearly separated.

---

**Current Milestone:** B5.4 — Six-Cable Configuration Optimisation.

**Current Preferred Numerical Reference:** `E1a_Robust_Config2_v1`.

**Next Technical Priority:** E1a-B — Six-Configuration Fair Comparison.

**Long-Term Research Direction:** A validated passive cable-length sensing system with six-cable prototype development, seven-/eight-cable comparison, and eventual deformable-balloon sensing.
