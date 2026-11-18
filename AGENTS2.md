# CURRENT_STATE2 — Current Research State

**Version:** 1.0  
**Last Updated:** 2026-11-18  
**Project:** Cable-Robot-Based Sensing for a Passive Deformable Balloon  
**Current Phase:** Prototype V1 — Pre-Prototype Design Finalisation  
**Current Task:** P0.1 — Targeted Anchor Refinement  
**Primary Tool:** MATLAB  
**Status:** Numerical E1/E2 development completed; physical prototype not yet built.

---

## 1. Purpose of This Document

This document provides the latest verified research state and immediate technical context for continuing the project.

It is intended to support research continuity across GitHub, ChatGPT and Codex sessions.

Document responsibilities:

| Document | Purpose |
|---|---|
| `AGENTS2.md` | Stable research and AI collaboration rules |
| `CURRENT_STATE2.md` | Current verified progress, decisions, limitations and next task |
| `08_Project_Management/Roadmap.md` | Long-term research direction |
| Active Research Plan | Detailed upcoming tasks, methods and completion criteria |
| `06_Research_Log/` | Detailed methods, experimental evidence and numerical results |
| `03_Simulation/MATLAB/` | MATLAB source code and numerical datasets |

**Active Research Plan:**

`08_Project_Management/November/Prototype_V1_Build_and_Validation_Plan.md`

The previous B5.3–B5.6 plan and November weekly plans remain historical planning references. Their outstanding E3/E4 tasks do not override the current prototype-oriented priorities.

---

## 2. Main Research Objective

Develop a cable-length-based sensing system capable of estimating the six-degree-of-freedom pose of a passively moving balloon-like object.

The application is motivated by intragastric balloons used in obesity treatment.

The intended system measures motion rather than actively controlling the balloon trajectory.

### Initial Measurement Outputs

- X, Y and Z translation.
- Roll, pitch and yaw orientation.
- Future extension to deformation and shape estimation.

### Experimental Development Strategy

**Stage 1 — Rigid sphere**

Validate six-cable geometry, cable-length sensing and rigid-body six-DOF pose estimation.

**Stage 2 — Air-filled flexible balloon**

Investigate attachment stability, deformation, motion disturbance and the limitations of the rigid-body model.

**Stage 3 — More realistic balloon model**

Investigate a liquid-filled silicone balloon surrogate and additional application-related physical effects.

The current project does not claim clinical validation.

---

## 3. Current Geometry and Measurement Baseline

| Parameter | Current Value |
|---|---|
| Computational boundary | 280 × 300 × 320 mm |
| Coordinate convention | X = length, Y = width, Z = height |
| Nominal balloon volume | 550 mL |
| Equivalent rigid-sphere radius | 50.8266 mm |
| Initial cable number | 6 |
| Anchor candidate geometry | Twelve edges of a rectangular computational frame |
| Attachment geometry | Six points on the nominal sphere surface |
| Main measured quantity | Cable length / displacement |
| Initial cable-length noise assumption | Standard deviation = 0.100 mm |
| Core evaluation set | 189 sampled poses |
| Extended development set | 539 sampled poses |
| Preferred physical architecture | Single 3030 aluminium extrusion frame |
| Motor function | Low-tension cable tracking, not commanded balloon motion |

The 280 × 300 × 320 mm computational boundary is not automatically the physical frame manufacturing size or a proven collision-free motion workspace.

The 539 sampled poses are development evidence, not an untouched independent validation set.

### Rigid Cable Geometry

For cable i:

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

- \(P\): balloon-centre position.
- \(R\): body-to-world rotation matrix.
- \(r_i\): body-frame attachment point.
- \(A_i\): effective cable exit point in world coordinates.
- \(B_i\): attachment point in world coordinates.
- \(L_i\): ideal straight cable length.

The physical guide, pulley and routing mechanism may require corrections to this ideal length model.

---

## 4. Completed Research

### B1 — Geometry Baseline

Completed:

- Three-dimensional engineering boundary.
- Equivalent rigid-sphere balloon model.
- Initial feasible centre region.
- Initial anchor candidates.
- Initial attachment candidates.
- Basic geometry verification.

### B2 — Six-Cable Configuration Search

Completed initial configuration exploration.

Experiment A optimised attachment locations with fixed anchors.

Experiment B allowed anchor and attachment locations to vary.

The experiments demonstrated that good reference-pose sensing alone does not guarantee multi-pose geometric feasibility.

### B3–B4 — Motion Feasibility and Sensing Evaluation

Completed:

- Translation and rotation pose evaluation.
- Cable–sphere interference screening.
- Cable–cable finite-segment distance calculations.
- Analytical and numerical Jacobian checks.
- Singular-value and condition-number analysis.
- Initial measurement-noise and uncertainty simulations.

These established the evaluation framework for later configuration optimisation.

### B5.1–B5.3 — Configuration Redesign

Completed:

- Twelve-rail anchor constraints.
- Structured configuration families.
- Expanded attachment candidate generation.
- Attachment selection and pairing enumeration.
- Multi-pose geometric screening.

Eighteen structured configurations were generated.

Six configurations passed the Core 189-pose geometry and rank screening:

`[2, 4, 6, 8, 12, 17]`

### B5.4 E1 — Anchor Optimisation

Completed the relevant candidate development work involving:

- Anchor-position optimisation along selected rails.
- Selected rail-reassignment investigations.
- Controlled optimisation comparisons.
- Multi-pose geometry and sensing evaluation.
- Selected installation perturbation checks.

The resulting candidate branches used in E2 were:

- E1b C2-2
- E1b C4-1
- E1b C8-16
- E1a C12

Important: E1a C12 is the direct parent for the final E2 C12 candidate. E1b C12-40 belongs to a different design branch and must not be substituted.

### B5.4 E2 — Attachment Optimisation

Completed development-stage attachment optimisation with fixed parent anchors and pairing.

Four final designs were retained:

1. C2-2 Repaired M
2. C4-1 E2 M
3. C8-16 E2 M
4. C12 E2 M

All four passed 539/539 nominal development-pose geometry checks.

E2 attachment matrices are already arranged by cable row. Historical pairing permutations must not be applied again.

Detailed evidence:

`06_Research_Log/2026-11/B5_4_E2_Phase_Research_Summary.md`

---

## 5. Current Four-Configuration Comparison

### 5.1 Numerical Performance

All sigma values in the table below are worst scaled minimum Jacobian singular values over the 539 development poses.

| Metric | C2-2 Repaired M | C4-1 E2 M | C8-16 E2 M | C12 E2 M |
|---|---:|---:|---:|---:|
| Worst scaled sigma-min | 0.702000 | 0.582702 | 0.569039 | 0.505817 |
| Nominal geometry pass | 539/539 | 539/539 | 539/539 | 539/539 |
| Minimum ideal cable distance (mm) | 5.2958 | 39.0163 | 16.0627 | 13.5666 |
| Minimum nominal outward angle (deg) | 0.4254 | 13.7606 | 0.8580 | 16.3849 |
| Attachment perturbation protocol | 23/24 | 24/24 | 24/24 | 24/24 |
| Position RMSE (mm) | 0.15268 | 0.15348 | 0.15813 | 0.16120 |
| Orientation RMSE (deg) | 0.18153 | 0.21433 | 0.20998 | 0.21895 |

The pose-estimation RMSE values were obtained using synthetic independent cable-length errors with a standard deviation of 0.100 mm.

They are simulation results, not measured hardware accuracy.

The attachment perturbation protocol used specified individual point perturbations. Passing 24/24 does not establish general manufacturing reliability.

### 5.2 Engineering Mounting Comparison

Results from the Prototype V1 hardware-envelope and rail-mounting audits:

| Design | Minimum rail-end distance (mm) | Limiting cable | Minimum attachment chord (mm) | Maximum sampled cable travel (mm) |
|---|---:|---:|---:|---:|
| C2-2 Repaired M | 31.111 | C3 | 28.306 | 72.505 |
| C4-1 E2 M | 0.000 | C2 | 39.016 | 75.056 |
| C8-16 E2 M | 66.667 | C5 | 29.489 | 74.887 |
| C12 E2 M | 10.000 | C6 | 21.584 | 73.872 |

The cable-travel figures come from the 539 development poses and are not complete hardware stroke specifications.

### 5.3 Provisional Configuration Decision

**Provisional primary: C4-1 E2 M**

Reason:

- Good sensing performance.
- Largest nominal cable-pair separation among the four candidates.
- Relatively large outward-angle margin.
- Largest minimum attachment spacing.

Outstanding issue:

- Cable 2 anchor lies at a rail endpoint.
- Mechanical mounting and possible anchor relocation remain unresolved.

**Provisional backup: C12 E2 M**

Reason:

- Relatively large outward-angle margin.
- Acceptable nominal sensing and geometric results.
- Passed the specified attachment perturbation protocol.

Outstanding issues:

- Cable 6 anchor lies 10 mm from a rail endpoint.
- Connector spacing requires physical verification.
- Ideal cable clearance is smaller than C4-1.

**Alternative: C8-16 E2 M**

Advantages:

- Convenient anchor mounting distances.
- Good numerical sensing performance.

Concern:

- Small outward-angle margin, including limited margin under specified installation perturbations.

**High-sensing reference: C2-2 Repaired M**

Advantage:

- Best numerical sensing performance of the four.

Concerns:

- Small ideal cable clearance.
- One specified attachment perturbation failure involving Cable 6.

**No design is yet approved as the final physical prototype configuration.**

---

## 6. Preliminary Mechanical Research — M1.1 to M1.4

### M1.1 — Single-Frame Reference Geometry

A single-frame 3030 aluminium extrusion architecture was selected for initial development.

The current concept distinguishes:

- The theoretical effective anchor \(A_i\).
- The physical guide mounting reference \(M_i\).
- The actual cable exit geometry.
- The motor and winch installation position.

With a simplified 30 mm profile and zero additional gap, the reference distance between the theoretical edge anchor and the associated extrusion-centre reference is:

\[
\|M_i-A_i\|=21.213\ \mathrm{mm}
\]

This is a coordinate-reference distance, not a manufactured guide bracket length.

### M1.2 — Simplified Frame Occupancy

A solid 30 × 30 mm extrusion-envelope approximation was used.

All 24 reference lines from extrusion centre to theoretical anchor crossed their corresponding solid profile envelopes.

This was a consequence of the chosen reference geometry and does not establish that all 24 anchors are mechanically impossible.

Two anchors were identified as lying within 20 mm of their corresponding rail endpoints:

- C4-1 E2 M — Cable 2.
- C12 E2 M — Cable 6.

### M1.3 — Fixed-Plane Guide Direction Analysis

The 539 development poses were used to calculate cable directions.

A least-squares fixed plane was fitted for each cable.

Maximum out-of-plane direction deviations across the four designs were approximately 11.0–12.1 degrees when considering the worst cable in each design.

These are geometric direction metrics, not actual pulley friction or cable measurement errors.

### M1.4 — Local Guide Angular Envelope

The development-pose directional envelopes showed:

| Design | Largest local yaw range | Largest local pitch range | Maximum reference cone angle |
|---|---:|---:|---:|
| C2-2 Repaired M | 19.411° | 20.585° | 11.713° |
| C4-1 E2 M | 22.443° | 21.994° | 12.745° |
| C8-16 E2 M | 21.107° | 23.443° | 12.716° |
| C12 E2 M | 21.658° | 24.079° | 12.694° |

These values describe cable directions in local reference coordinates.

They are not certified swivel-pulley joint travel requirements.

### Mechanical Guide Direction

The preferred approach is to evaluate:

- A compact low-friction eyelet as a reference.
- A swivel or panning pulley as a candidate mechanism.

A standard fixed single-groove pulley is not assumed suitable without geometric and friction testing.

No guide hardware has yet been experimentally validated.

---

## 7. External Prototype Information

Consultation with Jingjun Liu from Darwin Lau's research group provided practical prototype information.

Reported components and methods include:

- 3030 aluminium extrusion frame.
- An existing experimental frame measuring 700 × 560 × 540 mm.
- Custom 3D-printed routing pieces and winches.
- T-slot fasteners for mounting cable routing components.
- Feetech SM45BL servo motors.
- No.10 PE fishing line.
- TPU-95 flexible printed structures with mechanical screw attachments.
- Temporary tape-based cable attachment for an earlier balloon experiment.

Jingjun noted that SM45BL has relatively low back-drivability and may not suit a passive balloon measurement system.

These details are references from another prototype, not final specifications selected for the present project.

Specific pulley, winch, sensor and mounting dimensions remain to be determined for Prototype V1.

---

## 8. Main Unresolved Problems

### Problem 1 — Anchor Installation

C4-1 Cable 2 is located at the endpoint of Rail 6:

\[
A_2=(140,150,-160)\ \mathrm{mm}
\]

C12 Cable 6 is 10 mm from the start of Rail 10:

\[
A_6=(140,-140,-160)\ \mathrm{mm}
\]

Both anchors may be adjusted locally along their existing rails.

However, no adjusted design has yet been accepted.

Any proposed movement must be re-evaluated for geometric feasibility, sensing performance and installation constraints.

### Problem 2 — Continuous Motion Interference

The current 539-pose evaluation is discrete.

It does not certify all continuous motion paths or the complete six-dimensional motion workspace.

Outstanding checks include:

- Continuous translation and rotation paths.
- High-risk intermediate configurations.
- Conservative minimum-distance bounds.
- Finite cable diameters.
- Cable–guide and cable–frame interference.
- Connector geometry and manufacturing tolerances.

### Problem 3 — Physical Cable Guide

A physical guide must:

- Be mountable on the single 3030 frame.
- Accommodate the required cable direction variation.
- Avoid excessive friction under low tension.
- Maintain a modelled or calibrated effective cable exit geometry.
- Support sufficiently accurate cable-length measurements.

### Problem 4 — Attachment Interface

Actual connector dimensions and mounting techniques remain unresolved.

The initial rigid sphere may use mechanical attachment points.

Flexible balloon attachment must be investigated separately, with attention to local deformation, slippage and leakage.

### Problem 5 — Experimental Measurement Architecture

The following are not yet finalised:

- Cable and guide dimensions.
- Encoder and displacement measurement hardware.
- Low-tension cable tracking method.
- Winch geometry.
- Actual cable-length measurement noise and bias.
- Ground-truth pose measurement arrangement.

---

## 9. Current Engineering Decision

The current priority is not to maximise the Jacobian minimum singular value indefinitely.

The priority is to obtain a six-cable configuration that satisfies four requirements:

1. Practical installation.
2. Interference-free motion within a defined and verified operating region.
3. Adequate sensing and pose-estimation performance.
4. Overall geometric and mechanical feasibility.

The initial architecture is a single 3030 aluminium frame with independently mounted cable guides and suitably located cable-length measurement/actuation components.

The final guide and motor architecture must be experimentally validated.

Full E3 Pairing Optimisation and E4 Joint Optimisation are paused.

They may be reopened only if targeted mechanical or geometric problems cannot be resolved with simpler modifications.

---

## 10. Active Research Plan

The current active plan is:

`08_Project_Management/November/Prototype_V1_Build_and_Validation_Plan.md`

### Pre-Procurement Tasks

| Task | Description | Status |
|---|---|---|
| P0.1 | Targeted anchor refinement for C4-1 C2 and C12 C6 | Next technical task |
| P0.2 | Continuous motion interference screening | Pending |
| P0.3 | Provisional primary/backup configuration freeze | Pending |
| P0.4 | Single-cable mechanical concept and preliminary BOM | Pending |
| P0.5 | Supervisor presentation and funding request | Pending |

### Hardware Development Tasks

| Task | Description | Status |
|---|---|---|
| P1 | One-cable mechanical assembly | Not started |
| P2 | Low-tension and cable-length measurement validation | Not started |
| P3 | Final mechanical geometry and CAD/BOM freeze | Not started |
| P4 | Six-cable rigid prototype assembly | Not started |
| P5 | Experimental six-DOF pose validation | Not started |
| P6 | Flexible balloon pilot testing | Not started |

**Prototype V1.0 completion:** P5 — functional and experimentally evaluated six-cable rigid-body sensing system.

**Prototype V1.1 extension:** P6 — preliminary flexible-balloon compatibility study.

---

## 11. Immediate Next Task — P0.1

**Research question**

Can small rail-constrained adjustments resolve the most critical anchor installation issues without unacceptable loss of geometric and sensing performance?

### Configuration A — C4-1 E2 M

Cable 2:

- Rail ID: 6.
- Original \(t=1\).
- Original anchor: \((140,150,-160)\) mm.
- Initial candidate inward adjustments: 10, 20, 25 and 30 mm.

These are proposed test inputs, not verified improved designs.

### Configuration B — C12 E2 M

Cable 6:

- Rail ID: 10.
- Original \(t\approx0.033333\).
- Original anchor: \((140,-140,-160)\) mm.
- Initial candidate inward adjustments: 5, 10, 15 and 20 mm.

These are proposed test inputs, not verified improved designs.

### Fixed Variables

- All other anchor points.
- All paired attachment points.
- Cable pairing.
- Rigid-sphere dimensions.
- Computational boundary.

### Required Outputs

- Original-versus-adjusted anchor coordinates.
- Rail-end installation distances.
- Geometry pass counts.
- Minimum cable separation.
- Minimum outward departure angles.
- Worst scaled Jacobian singular values.
- Condition-number comparison.
- Relevant installation robustness checks.

### Completion Decision

Retain an adjusted design only if its practical installation advantage justifies its geometry and sensing trade-offs.

Otherwise, retain the original candidate with a justified special mounting arrangement, or evaluate the next eligible configuration.

**Do not start P0.1 until the planned GitHub documentation updates are completed.**

---

## 12. Research Documentation and Continuity

### Relevant Evidence

- `06_Research_Log/2026-11/B5_3_Twelve_Rail_Structured_Configuration_Research_Log_2026_11_11.md`
- `06_Research_Log/2026-11/B5_4_E1a_Anchor_Rail_Position_Optimisation_Research_Log_2026_11_12.md`
- `06_Research_Log/2026-11/B5_4_E2_Phase_Research_Summary.md`
- Prototype V1 M1.1–M1.4 MATLAB outputs retained in the local working directory.

### Data Integrity Rules

- Preserve the original E2 candidate configurations.
- Do not overwrite the saved baseline matrices.
- Do not invent missing numerical results.
- Do not present development poses as an independent holdout.
- Do not present numerical cable separation as certified physical clearance.
- Do not describe simulated RMSE as hardware measurement accuracy.
- Keep the final E2 C12 lineage linked to E1a C12.
- Do not reapply historical pairing indices to already paired attachment matrices.

### Collaboration Workflow

Research discussions may be conducted in Chinese.

GitHub technical documents and research presentations are written in English.

When providing new MATLAB scripts:

1. Explain the research question.
2. Explain why the step is necessary.
3. Explain the mathematical or engineering principle.
4. Summarise the code logic.
5. Provide directly copyable MATLAB code with Chinese comments.
6. Review actual output before making a research decision.

GitHub updates are performed manually, one file at a time, after user confirmation.

---

## 13. Current One-Paragraph Research Summary

The project has progressed from initial three-dimensional workspace definition and six-cable configuration search through rail-constrained anchor optimisation and sphere-constrained attachment optimisation. Four E2 candidate configurations have been retained after 539-pose development-stage geometric and sensing evaluation. C4-1 E2 M is the provisional primary design, with C12 E2 M as backup. Preliminary 3030 single-frame and cable guide analyses have been completed, but physical mounting, continuous-motion interference, low-tension cable tracking and experimental measurement accuracy remain unverified. The immediate objective is to complete targeted anchor refinement and interference screening, then prepare the mechanical concept, procurement request and experimental validation of a one-cable module before building the six-cable rigid prototype.

---

**Next technical action:** P0.1 — Targeted Anchor Refinement, after completing GitHub documentation updates.
