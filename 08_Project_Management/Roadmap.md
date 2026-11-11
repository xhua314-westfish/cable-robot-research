# Research Roadmap

**Version:** 0.7  
**Last Updated:** 2026-11-12  
**Project:** Cable-Robot-Based Sensing for a Passive Deformable Balloon  
**Current Phase:** B5.4 — Six-Cable Configuration Optimisation  
**Next Technical Milestone:** E1a-B — Six-Configuration Fair Comparison  
**Primary Tool:** MATLAB

---

## 1. Research Goal

Develop and experimentally validate a cable-length-based sensing system for estimating the position, orientation and eventually deformation of a passively moving balloon-like object.

The research is motivated by intragastric balloon monitoring in a simplified stomach-inspired environment.

### Main Research Question

> Can cable measurements reliably reconstruct passive balloon motion, and how should cable number and configuration be selected to improve sensing performance while satisfying geometric and mechanical constraints?

The system focuses on measurement and state estimation rather than active trajectory control.

### Long-Term Objectives

1. Establish reliable six-degree-of-freedom rigid-body pose sensing.
2. Develop a practical low-tension cable measurement prototype.
3. Validate pose-estimation accuracy experimentally.
4. Investigate deformable-balloon sensing.
5. Compare six-, seven- and eight-cable sensing systems.

---

## 2. Research Strategy

The project follows a research-question-driven, prototype-oriented strategy with two parallel workstreams.

### Workstream A — Six-Cable Prototype and Experiments

**Primary priority**

Develop a numerically justified and experimentally testable six-cable sensing system.

Main activities:

- Cable configuration design.
- Geometric feasibility.
- Sensing optimisation.
- Robustness analysis.
- Pose reconstruction.
- Measurement calibration.
- Mechanical and hardware development.
- Experimental validation.
- Initial deformable-balloon investigation.

### Workstream B — Seven-/Eight-Cable Theory and Simulation

**Parallel theoretical priority**

Investigate:

- Measurement redundancy.
- Local observability.
- Sensing quality and pose uncertainty.
- Geometric workspace.
- Cable interference.
- Tension feasibility.
- Hardware complexity.
- Performance relative to six cables.

Additional cables are not assumed to improve performance automatically.

The two workstreams should use consistent evaluation definitions and comparable assumptions.

---

## 3. Overall Research Phases

| Phase | Main Objective | Status |
|---|---|---|
| Phase 0 | Define application and measurement objectives | Initial synthesis completed |
| Phase A | Reproduce relevant literature methods | Core scope completed |
| B1 | Establish balloon and workspace geometry | Completed |
| B2 | Generate initial six-cable configurations | Completed |
| B3 | Evaluate geometric feasibility | Completed |
| B4 | Evaluate Jacobian and initial sensing quality | Initial scope completed |
| B5.1–B5.2 | Diagnose and redesign configurations | Completed |
| B5.3 | Develop twelve-rail structured configurations | Completed |
| B5.4 | Optimise cable configuration and assess robustness | Active |
| B5.5 | Validate pose estimation and calibration | Planned |
| B5.6 | Develop and evaluate Prototype V1.0 | Planned |
| B6–B8 | Extend engineering and experimental validation | Future |
| B9 | Integrate cable-number and configuration comparisons | Future |

Detailed completed results are maintained in [CURRENT_STATE2.md](../CURRENT_STATE2.md) and the [Research Logs](../06_Research_Log/).

---

## 4. Phase 0 — Application Definition

**Status:** Initial synthesis completed.

### Objective

Establish the sensing application, research requirements and initial engineering assumptions.

### Outcome

- Passive balloon sensing objective defined.
- Six-degree-of-freedom rigid-body pose selected as the initial measurement state.
- Nominal balloon geometry established.
- Simplified stomach-inspired engineering boundary adopted.

### Remaining Limitation

The engineering geometry and motion region are not clinically validated continuous gastric workspace boundaries.

---

## 5. Phase A — Literature-Based Method Reproduction

**Status:** Core scope completed.

### Objective

Understand and verify mathematical methods relevant to cable-based measurement.

### Main Methods

- Cable wrench and tension feasibility.
- Single-pose feasible-region analysis.
- Multi-pose feasible-region intersection.
- Forward kinematics.
- Jacobian and uncertainty analysis.
- Workspace sampling.

### Milestone

Reusable theoretical and MATLAB methods are available for balloon-specific sensing research.

These methods do not, by themselves, validate the final balloon sensing system.

---

## 6. Phase B — Six-Cable Sensing Development

### B1 — Geometry Definition

**Status:** Completed.

**Objective:** Establish the initial balloon model, engineering boundary and candidate connection regions.

**Milestone:** Reproducible geometric model.

### B2 — Initial Configuration Search

**Status:** Completed.

**Objective:** Investigate how anchor and attachment arrangements influence local sensing quality.

**Milestone:** Baseline six-cable configurations and initial sensing comparison.

### B3 — Geometric Feasibility

**Status:** Completed.

**Objective:** Evaluate cable interference and geometry across multiple balloon positions and orientations.

**Milestone:** Multi-pose feasibility assessment.

### B4 — Sensing Quality

**Status:** Initial scope completed.

**Objective:** Evaluate local six-degree-of-freedom identifiability, sensitivity and uncertainty.

**Milestone:** Verified measurement Jacobian and initial sensing-quality analysis.

Further nonlinear estimation and experimental accuracy validation continue in B5.4 and B5.5.

---

## 7. B5 — Configuration Optimisation and Prototype Preparation

### B5.1 — Configuration Audit and Candidate Expansion

**Status:** Completed.

**Objective:** Diagnose limitations of initial configurations and expand the available design space.

### B5.2 — Multi-Pose Configuration Screening

**Status:** Completed.

**Objective:** Evaluate alternative layouts and cable pairings under common geometric and sensing criteria.

### B5.3 — Twelve-Rail Structured Configuration Design

**Status:** Completed.

**Objective:** Introduce mechanically meaningful anchor mounting regions and generate structured configuration families.

**Milestone:** A reproducible set of eligible twelve-rail six-cable starting configurations.

### B5.4 — Configuration Optimisation

**Status:** Active.

**Objective:** Understand and optimise the effects of rail position, rail assignment, attachment position and cable pairing.

| Task | Research Focus | Status |
|---|---|---|
| E1a-A | Develop rail-position optimisation method using Config 2 | Completed |
| E1a-B | Apply fair rail-position optimisation across six candidates | Next |
| E1b | Rail assignment optimisation | Planned |
| E2 | Attachment optimisation | Planned |
| E3 | Cable pairing optimisation | Planned |
| E4 | Joint configuration optimisation | Planned |
| Final evaluation | Independent validation, robustness and shortlist | Planned |

**B5.4 Completion Milestone**

A small shortlist of configurations supported by:

- Geometric feasibility.
- Sensing performance.
- Pose-estimation evidence.
- Robustness evaluation.
- Mechanical plausibility.
- Independent validation.

The objective is a justified design shortlist, not an unsupported global optimum.

Detailed procedures are maintained in the [Active Research Plan](November/B5_3_B5_6_Active_Research_Plan_Six_Cable_Sensing.md).

---

## 8. B5.5 — Measurement Validation and Calibration

**Status:** Planned.

### Research Question

Can cable-length measurements reconstruct passive balloon pose accurately under realistic noise, bias and model uncertainty?

### Main Activities

- Measurement noise and bias modelling.
- Nonlinear pose reconstruction.
- Sensor and geometric calibration.
- Independent pose testing.
- Estimator convergence and failure analysis.
- Ground-truth measurement protocol.

### Completion Milestone

A reproducible pose-estimation method with documented uncertainty, calibration requirements and independent validation evidence.

Simulated accuracy must remain distinguishable from experimentally measured accuracy.

---

## 9. B5.6 — Prototype Engineering and Decision

**Status:** Planned.

### Research Question

Can the selected six-cable configuration be implemented as a practical low-tension measurement system?

### Main Activities

- Mechanical frame and mounting design.
- Pulley and cable-guide geometry.
- Cable length and stroke requirements.
- Sensor and motor selection.
- Positive-tension and passive-motion disturbance assessment.
- Assembly and calibration.
- Prototype measurement experiments.

### Completion Milestone

A reproducible Prototype V1.0 design and, when hardware is available, experimental evidence supporting a retain, modify or redesign decision.

A numerically feasible configuration does not automatically qualify as a physically validated prototype.

---

## 10. Longer-Term Research — B6 to B9

These stages describe work beyond the first prototype-development cycle.

They must not duplicate engineering and calibration activities already completed under B5.5–B5.6.

| Stage | Main Focus | Expected Outcome |
|---|---|---|
| B6 | Detailed hardware sizing and engineering refinement | Improved mechanical and sensing specifications |
| B7 | Prototype refinement and expansion capability | More robust experimental platform |
| B8 | Extended rigid/flexible balloon experiments | Broader experimental performance evidence |
| B9 | Final configuration and cable-number comparison | Integrated research conclusions |

### Rigid-to-Flexible Transition

Future work will investigate:

- Balloon deformation models.
- Attachment migration.
- Flexible-surface cable routing.
- Joint pose/deformation identifiability.
- Additional sensing requirements.

Six instantaneous cable-length measurements do not generally identify six unconstrained rigid-body pose variables plus additional independent deformation variables.

Shape reconstruction therefore requires justified additional information, constraints or reduced-order modelling.

---

## 11. Parallel Seven-/Eight-Cable Research

**Status:** Planned theoretical and numerical workstream.

### Main Questions

1. Does additional measurement redundancy improve pose estimation?
2. How does cable number change the measurement Jacobian?
3. How does geometric interference change?
4. Are improvements robust under equivalent measurement assumptions?
5. What mechanical complexity is introduced?
6. Which findings justify hardware expansion?

### Comparison Requirements

Use:

- Common pose sets.
- Consistent geometric assumptions.
- Compatible sensor-noise models.
- Comparable sensing metrics.
- Explicit mechanical constraints.

### Completion Milestone

An evidence-based assessment of when six, seven or eight cables are preferable for the intended sensing task.

---

## 12. Research Milestones and Decision Gates

| Gate | Required Decision |
|---|---|
| G1 — Mathematical model | Are the measurement equations and assumptions verified? |
| G2 — Geometry | Are configurations feasible across the required evaluation region? |
| G3 — Sensing | Is local pose information sufficient, and does nonlinear estimation perform adequately? |
| G4 — Optimisation | Have relevant configuration variables been compared fairly? |
| G5 — Robustness | Are results sufficiently stable under independent tests and uncertainty? |
| G6 — Engineering | Can the selected geometry be physically implemented? |
| G7 — Measurement validation | Does the system meet justified accuracy and repeatability requirements? |
| G8 — Prototype | Does physical evidence support retaining or modifying the design? |
| G9 — Final research | What configuration and cable-number conclusions are supported? |

Numerical feasibility, sensing quality, mechanical feasibility and experimental validation are separate requirements.

A failed gate should lead to a documented research decision rather than an unsupported acceptance claim.

---

## 13. Current Milestone

**Current Phase:** B5.4 — Configuration Optimisation.

**Latest Completed Task:** E1a-A — Config 2 Anchor Rail Position Optimisation.

**Next Technical Task:** E1a-B — Six-Configuration Fair Comparison.

### Immediate Objective

Compare the six Core-eligible starting configurations using equivalent rail-position optimisation and common evaluation criteria.

The outcome will support subsequent Rail Assignment, Attachment, Pairing and Joint Optimisation.

### Next Decision

Determine which configurations merit continued investigation based on their combined sensing, geometry and robustness performance.

Detailed steps and acceptance criteria are maintained exclusively in the Active Research Plan.

---

## 14. Repository Navigation

| Document | Purpose |
|---|---|
| [README](../README.md) | Project overview |
| [AGENTS2](../AGENTS2.md) | Stable research and AI working rules |
| [CURRENT_STATE2](../CURRENT_STATE2.md) | Verified current progress |
| [Active Research Plan](November/B5_3_B5_6_Active_Research_Plan_Six_Cable_Sensing.md) | Current technical research procedures |
| [Research Logs](../06_Research_Log/) | Numerical and experimental evidence |
| [Weekly Presentation Template](Weekly_Presentation_Template.md) | Research presentation workflow |

Historical and superseded plans should not be used as current execution instructions.

---

**Research Direction:** Six-cable pose-sensing optimisation and experimental development, parallel seven-/eight-cable theory, and eventual deformable-balloon measurement.

**Guiding Principle:** Research questions determine the methods. Numerical evidence informs design decisions. Independent validation and experiments establish practical performance.
