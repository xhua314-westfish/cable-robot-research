2026-11-18

# Prototype V1 — Build and Validation Plan

**Version:** 1.0  
**Date:** 2026-11-18  
**Status:** Active — Pre-Prototype Design Finalisation  
**Project:** Cable-Robot-Based Sensing for a Passive Balloon  
**Primary Tools:** MATLAB, CAD, 3D Printing, Experimental Measurement

---

## 1. Purpose

This document defines the research and engineering activities required to progress from the current six-cable numerical configurations to a working Prototype V1.

The immediate priority is to develop a mechanically implementable, interference-aware and measurable six-cable system.

The project is moving from broad configuration optimisation towards targeted design refinement, hardware development and experimental validation.

Full E3 pairing optimisation and E4 joint optimisation are paused unless a specific mechanical or sensing problem justifies reopening them.

This document replaces the outstanding-task sequence of the earlier B5.3–B5.6 active plan. Previous research plans and logs remain historical records.

## 2. Research Objective

Develop a cable-length-based sensing system capable of estimating the six-degree-of-freedom pose of a passively moving balloon-like object.

The motivating application is the measurement of intragastric balloon motion.

The system is intended for passive motion sensing, not active trajectory control.

The experimental development sequence is:

1. Rigid spherical end-effector for six-DOF sensing validation.
2. Air-filled flexible balloon for preliminary attachment and deformation studies.
3. More realistic liquid-filled silicone balloon model for future application-oriented research.

A successful rigid-sphere prototype is not equivalent to a validated clinical balloon monitoring system.

## 3. Current Engineering Baseline

| Parameter | Current Value |
|---|---|
| Computational boundary | 280 × 300 × 320 mm |
| Coordinate axes | X = length; Y = width; Z = height |
| Nominal balloon volume | 550 mL |
| Rigid equivalent radius | 50.8266 mm |
| Cable number | 6 |
| Anchor definition | Six effective cable exit points |
| Original anchor constraint | Twelve edges of the computational frame |
| Candidate physical frame | Single 3030 aluminium extrusion frame |
| Primary sensor output | Cable length / displacement |
| Initial noise assumption | 0.100 mm cable-length standard deviation |
| Development pose set | 539 sampled poses |
| Intended operation | Passive movement with low positive cable tension |

The computational boundary must not automatically be interpreted as the full validated motion workspace or as a final physical frame manufacturing dimension.

## 4. Completed Research

### 4.1 Geometry and Configuration Development

B1–B4 established the three-dimensional geometry, initial configurations, multi-pose feasibility checks and sensing evaluation methods.

B5.1–B5.3 introduced structured configuration families, the twelve-rail anchor constraint and larger attachment candidate sets.

Eighteen structured configurations were screened, with six satisfying the Core 189-pose geometry and rank requirements.

### 4.2 Anchor Optimisation — E1

E1a and E1b investigated anchor positions and selected rail assignments.

The study identified promising six-cable layouts with improved sensing performance while retaining the rail-constrained design framework.

### 4.3 Attachment Optimisation — E2

E2 optimised spherical attachment coordinates while keeping the relevant parent anchors and cable pairings fixed.

Four final candidate designs were retained:

- C2-2 Repaired M
- C4-1 E2 M
- C8-16 E2 M
- C12 E2 M

All four passed 539/539 nominal development-pose geometric checks.

Their results remain numerical development evidence rather than physical validation or proof of continuous-workspace collision freedom.

### 4.4 Preliminary Mechanical Analysis — M1.1–M1.4

Completed analyses include:

- Single-frame 3030 reference geometry.
- Effective anchor versus frame mounting reference locations.
- Rail-end installation distance checks.
- Simplified frame envelope checks.
- Fixed-plane cable direction deviation.
- Local cable direction angular envelopes over 539 development poses.

The analyses indicate that a realistic cable guide and its mounting geometry must be explicitly designed and calibrated.

They do not establish that a particular pulley or guide is mechanically suitable.

## 5. Current Candidate Configuration Decision

| Candidate | Current Role | Main Advantage | Main Unresolved Issue |
|---|---|---|---|
| C4-1 E2 M | Provisional primary | Strong balance of sensing, cable separation and outward-angle margin | Cable 2 anchor at rail endpoint |
| C12 E2 M | Provisional backup | Relatively large outward-angle margin | Cable 6 near rail endpoint; connector spacing |
| C8-16 E2 M | Alternative | Convenient rail mounting positions | Small outward-angle margin |
| C2-2 Repaired M | High-sensing reference | Highest evaluated worst-case scaled sigma-min | Small clearance and attachment perturbation sensitivity |

The primary and backup assignments are provisional.

Final selection requires targeted mechanical refinement, further interference evaluation and implementation review.

## 6. Prototype V1 Acceptance Principles

The prototype design must address four priorities.

### 6.1 Installation Feasibility

- All six cable guides can be physically installed.
- Anchor mounting, fasteners and adjustment space are accessible.
- Attachment connectors can be fitted without physical overlap.
- Effective cable exit locations can be identified and calibrated.
- The assembly permits maintenance and replacement.

### 6.2 Interference-Free Motion

Within a clearly defined experimental motion domain:

- No unacceptable cable–cable contact.
- No unacceptable cable–sphere contact.
- No unacceptable cable–frame or cable–guide interference.
- Connector and guide envelopes are included.
- Physical cable diameters and appropriate clearances are considered.

Sampled-pose feasibility must not be reported as proof of continuous-workspace safety.

### 6.3 Sensing Performance

- The measurement Jacobian maintains the required rank.
- Weak-direction sensitivity and conditioning are evaluated.
- Nonlinear pose estimation is tested under declared noise assumptions.
- Experimental position and orientation errors are measured against independent ground truth.
- Failed estimates and non-convergence are reported.

Formal experimental accuracy targets must be established before final acceptance.

### 6.4 Overall Geometric Feasibility

- The required balloon motion region is explicitly defined.
- Cable lengths and travel are mechanically supported.
- Outward departure remains feasible.
- Low-tension tracking avoids unacceptable slack and disturbance.
- Calibration and routing assumptions are compatible with the physical hardware.

## 7. Pre-Procurement Research Plan — P0

### P0.1 — Targeted Anchor Refinement

**Research question**

Can the installation constraints of the preferred C4-1 and C12 configurations be improved by small anchor adjustments without unacceptable loss of geometry or sensing performance?

**Design changes**

- C4-1 E2 M: locally adjust Cable 2 along its existing Rail 6.
- C12 E2 M: locally adjust Cable 6 along its existing Rail 10.

**Fixed variables**

- All other anchor coordinates.
- All attachment coordinates.
- Existing cable pairing.
- Computational frame and rigid-sphere model.

**Method**

1. Preserve the original configurations as immutable baselines.
2. Define a limited set of inward rail-position adjustments.
3. Re-evaluate the common 539-pose development set.
4. Compare cable separation, sphere departure and sensing metrics.
5. Review anchor installation clearance.
6. Assess relevant installation perturbations.
7. Retain only feasible, implementation-relevant alternatives.

**Deliverables**

- Original-versus-adjusted configuration comparison.
- Updated anchor coordinates and rail parameters, if a modification is accepted.
- Geometry and sensing results.
- Explicit rationale for retaining or rejecting each adjustment.

**Completion gate**

Select an acceptable adjusted anchor location, retain the original geometry with a justified special mounting solution, or document why the candidate is not suitable.

Do not reopen global optimisation unless local solutions fail.

### P0.2 — Continuous Motion Interference Screening

**Research question**

Do the shortlisted cable configurations remain free from unacceptable idealised interference during motion between sampled poses?

**Method**

1. Define the intended Prototype V1 position and orientation domain.
2. Define representative continuous translation and rotation paths.
3. Evaluate all fifteen cable-pair distances.
4. Evaluate cable–sphere departure throughout the paths.
5. Apply adaptive path refinement in high-risk intervals.
6. Where feasible, derive conservative distance bounds.
7. Document unverified regions and unresolved cases.

Physical guide, frame, cable diameter and connector interference will be revisited using actual hardware dimensions.

**Deliverables**

- Motion-path test definitions.
- Minimum clearance results and limiting cable pairs.
- Conservative clearance verification records, where available.
- Identified unsafe or uncertified motion regions.
- Recommended experimental operating limits.

**Completion gate**

A justified operating region and motion-path plan are documented. Any claims of continuous clearance are restricted to regions and assumptions actually certified.

### P0.3 — Provisional Configuration Freeze

**Research question**

Which candidate provides the best balance of installation feasibility, interference margin and sensing performance?

**Method**

1. Compare original and locally refined C4-1 and C12 designs.
2. Retain C8-16 and C2-2 as references.
3. Apply the same declared geometry and sensing evaluation rules.
4. Evaluate mechanical guide implementation complexity.
5. Select a provisional primary and backup.
6. Freeze the corresponding numerical design versions.

**Deliverables**

- Primary and backup configuration decision.
- Exact anchor and paired attachment coordinates.
- Rail IDs, rail parameters and cable correspondence.
- Numerical assessment and limitations.
- Conditions requiring redesign.

**Completion gate**

One primary and one backup design are identified for mechanical development.

This is a provisional numerical freeze, not final physical calibration.

### P0.4 — Single-Cable Mechanical Concept and Preliminary BOM

**Research question**

Can one low-friction, measurable cable module be implemented on the selected single-frame architecture?

**Method**

1. Define the 3030 frame interface and mounting coordinates.
2. Develop a routing bracket concept.
3. Compare a fixed eyelet with a suitable swivel pulley.
4. Define a removable winch or displacement measurement assembly.
5. Estimate required cable travel and reserve.
6. Plan low-tension tracking experiments.
7. Identify standard parts, custom parts and laboratory resources.
8. Prepare preliminary CAD concepts and a bill of materials.

**Deliverables**

- Single-cable concept assembly.
- Preliminary parametric CAD parts.
- Procurement and 3D printing list.
- Initial supplier quotations or laboratory inventory.
- Risks and specifications still requiring testing.

**Completion gate**

The proposed module is sufficiently defined to request resources and begin prototype experiments, without claiming proven mechanical performance.

### P0.5 — Supervisor Presentation and Funding Request

Prepare an eleven-slide English research presentation covering:

1. Research objective and motivation.
2. Current rigid-to-flexible experimental strategy.
3. Configuration development from structured candidates to four finalists.
4. E1/E2 optimisation evidence.
5. Four-configuration comparison.
6. Primary and backup selection.
7. Remaining mechanical and interference limitations.
8. Proposed one-cable test module.
9. Procurement and 3D printing requirements.
10. Prototype development and validation roadmap.
11. Requested resources and supervisor decisions.

**Deliverables**

- Supervisor presentation.
- Provisional configuration decision.
- Initial hardware request.
- Preliminary BOM and fabrication plan.

**Completion gate**

Supervisor agreement on the next experimental phase and the required initial resources.

## 8. Hardware Development Plan — P1 to P6

### P1 — One-Cable Mechanical Module

Procure or access one set of mechanical components, fabricate guide parts and assemble a configurable one-cable test rig.

Verify cable travel, guide articulation, alignment and basic mechanical operation.

**Completion gate:** A working one-cable mechanical module.

### P2 — Cable Measurement and Low-Tension Validation

Integrate length sensing, an appropriate low-tension mechanism and a calibrated displacement reference.

Measure repeatability, friction, hysteresis and direction-dependent measurement errors.

Determine whether the straight-cable model remains adequate or whether guide/pulley corrections are required.

**Completion gate:** The selected guide and measurement architecture are supported by repeatable experimental evidence.

### P3 — Final Mechanical Configuration Freeze

Update anchor calibration, guide geometry, connector design and the required physical clearances using actual hardware dimensions.

Check the complete six-guide layout for physical installation and interference.

**Completion gate:** An assembly-ready CAD model and verified mechanical BOM.

### P4 — Six-Cable Rigid Prototype Assembly

Build the six-cable single-frame system with a rigid spherical end-effector.

Integrate sensing channels, low-tension tracking, calibration and data acquisition.

**Completion gate:** Six synchronised cable measurements and an operational rigid-sphere test rig.

### P5 — Experimental Six-DOF Pose Validation

Conduct experiments using independent ground-truth pose measurement.

Report:

- Position and orientation errors.
- Measurement repeatability.
- Calibration effects.
- Estimator convergence and failure cases.
- Motion-path coverage.
- Geometric and mechanical limitations.

**Completion gate — Prototype V1.0**

A functional six-cable rigid-body sensing prototype with documented experimental performance and a declared safe operating region.

### P6 — Preliminary Flexible Balloon Pilot

Introduce an air-filled flexible experimental object.

Evaluate attachment stability, shape variation, cable-induced deformation, pressure or air-loss effects and limitations of rigid-body pose estimation.

**Completion gate — Prototype V1.1**

A documented flexible-balloon pilot study identifying practical limitations and priorities for a more realistic liquid-filled silicone balloon model.

This phase does not constitute clinical validation.

## 9. Mechanical Architecture Decision

**Preferred architecture:** Single 3030 aluminium frame.

The effective cable exit point, guide mounting location and motor/winch installation position are distinct mechanical quantities.

The motor and winch may be positioned away from the effective anchor.

The actual cable path, pulley contact geometry and additional measured length must be incorporated into calibration or modelling as necessary.

**Initial guide concepts**

- Fixed low-friction eyelet: compact reference design.
- Swivel or panning pulley: preferred concept for evaluation.
- Conventional fixed pulley: not assumed suitable without angular and friction verification.

The previously computed 539-pose local direction envelopes are initial design inputs, not certified hardware articulation limits.

## 10. Procurement Strategy

Use staged procurement rather than immediately purchasing six complete drive modules.

**Phase A:** One-cable mechanical and measurement test module.

**Phase B:** Six-cable rigid prototype after the guide and sensing architecture is experimentally justified.

Initial procurement planning should include:

- Aluminium extrusion and compatible mounting hardware.
- Pulley bearings, shafts and guide materials.
- Cable material.
- Cable-length sensing.
- Appropriate low-range force measurement.
- Low-tension tracking hardware.
- Electronics and power.
- 3D printing materials.
- Ground-truth measurement resources.

Custom printable components may include:

- Cable routing bracket.
- Swivel guide housing.
- Winch drum.
- Rigid sphere and attachment interface.

Exact part numbers, quantities and prices remain subject to specification, available laboratory inventory and quotations.

## 11. Research Evidence and Limitations

### Established Evidence

- Structured configuration screening and controlled optimisation.
- Four retained E2 candidates.
- 539-pose development-stage geometry evaluation.
- Simulated nonlinear six-DOF reconstruction.
- Preliminary rail mounting and cable direction analyses.

### Outstanding Evidence

- Independent unseen pose validation.
- Continuous interference certification for the declared operating region.
- Actual guide and connector dimensions.
- Real cable thickness and mounting tolerances.
- Low-tension actuation and friction measurements.
- Encoder calibration and true measurement noise.
- Experimental ground-truth pose accuracy.
- Flexible balloon attachment stability.

No untested mechanical or experimental property should be described as verified.

## 12. Working Rules and Documentation

For each new research or hardware task:

1. State the research question and why it is necessary.
2. Identify existing evidence and assumptions.
3. Explain the calculation or experimental method.
4. Define inputs, outputs and acceptance criteria.
5. Preserve baseline configurations.
6. Record both successful and unsuccessful results.
7. Separate simulated performance from experimental performance.
8. Save numerical evidence and research decisions.

MATLAB scripts should be provided as complete, directly copyable code with Chinese explanatory comments and a clear logic summary.

GitHub documentation will be updated manually, one file at a time, after review.

Historical research logs should remain accessible and should not be silently overwritten.

## 13. Immediate Next Action

**Current task:** P0.1 — Targeted Anchor Refinement.

Only after this plan and the related GitHub documentation have been reviewed and updated should new optimisation or prototype experiments resume.

The first technical task will investigate local movement of:

- C4-1 E2 M, Cable 2, Rail 6.
- C12 E2 M, Cable 6, Rail 10.

Their unchanged baseline designs must be preserved for direct comparison.

---

**Overall objective:** Progress efficiently from simulation-supported candidate configurations to a physically implementable, low-tension six-cable sensing prototype, without unnecessary repetition of broad theoretical optimisation.
