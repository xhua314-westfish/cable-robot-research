
# Prototype V1 — Pre-Prototype Research Summary

**Date:** 2026-11-18  
**Document Type:** Research Log / Stage Transition Record  
**Project:** Cable-Robot-Based Sensing for a Passive Deformable Balloon  
**Research Stage:** Transition from Numerical Configuration Development to Prototype V1  
**Status:** Stage Review Completed — Mechanical and Experimental Validation Pending

---

## 1. Purpose

This document records the research progress, numerical evidence, engineering findings and decisions leading to the Prototype V1 development stage.

It summarises:

1. The development of the six-cable sensing model.
2. The evolution from initial configurations to four retained E2 candidates.
3. The current primary and backup design rationale.
4. Preliminary single-frame mechanical and cable-guide analysis.
5. The remaining research and engineering uncertainties.
6. The transition towards hardware procurement and experimental validation.

This document is a historical research summary, not an active task schedule.

Detailed future procedures are maintained in the active Prototype V1 Build and Validation Plan.

---

## 2. Research Objective and Application

### 2.1 Main Research Question

Can cable-length measurements be used to estimate the six-degree-of-freedom pose of a passively moving balloon-like object?

The system is intended to estimate:

- X, Y and Z translation.
- Roll, pitch and yaw orientation.

Future research may extend the sensing framework towards balloon deformation and shape estimation.

### 2.2 Application Context

The research is motivated by intragastric balloons used in obesity treatment.

The relevant physical application involves an inflatable and deformable object.

However, deformation and uncertain attachment locations create additional measurement challenges.

A staged experimental approach has therefore been adopted.

**Initial stage:** Rigid spherical end-effector for six-DOF pose sensing.

**Intermediate stage:** Air-filled flexible balloon for attachment and deformation experiments.

**Future stage:** More realistic liquid-filled silicone balloon surrogate.

This progression allows the fundamental measurement method to be evaluated before introducing all flexible-body uncertainties.

The current results do not establish clinical suitability or an implantable sensing system.

### 2.3 Passive Measurement Principle

Unlike an actively driven CDPR, the intended balloon motion is not prescribed by the cables.

The system must measure externally induced or passive balloon movement.

A motor or another tensioning mechanism may be used to maintain low positive cable tension and prevent slack.

The influence of cable tension on passive motion must be experimentally evaluated.

---

## 3. Numerical Geometry Baseline

| Parameter | Baseline |
|---|---|
| Computational boundary | 280 × 300 × 320 mm |
| Coordinate axes | X = length, Y = width, Z = height |
| Nominal balloon volume | 550 mL |
| Equivalent sphere radius | 50.8266 mm |
| Cable number | 6 |
| Original anchor candidate region | Rectangular boundary |
| Later anchor constraint | Twelve computational frame-edge rails |
| Attachment region | Nominal sphere surface |
| Primary measurement | Cable length / displacement |
| Initial cable-length noise model | Independent Gaussian errors, SD = 0.100 mm |
| Core development poses | 189 |
| Extended development poses | 539 |

The rectangular boundary is an engineering approximation for configuration development.

It is not a clinically measured complete stomach-motion workspace.

The equivalent sphere is a rigid-body sensing reference, not a realistic deformable intragastric balloon model.

---

## 4. Evolution of the Configuration Research

### 4.1 B1 — Geometric Definition

The initial work established:

- A three-dimensional rectangular engineering boundary.
- A 550 mL equivalent spherical end-effector.
- Candidate anchor locations.
- Candidate attachment locations.
- Initial feasible balloon-centre regions.
- Geometry verification scripts.

The purpose was to create a reproducible geometrical basis for cable configuration studies.

### 4.2 B2 — Initial Six-Cable Configuration Search

Two main optimisation experiments were performed.

**Experiment A**

- Fixed anchor positions.
- Variable attachment positions.
- Reference-pose sensing optimisation.

**Experiment B**

- Variable anchor positions.
- Variable attachment positions.
- Reference-pose sensing optimisation.

The experiments demonstrated that substantial improvements in reference-pose Jacobian conditioning were possible.

However, good reference-pose sensing performance did not guarantee multi-pose geometric feasibility.

### 4.3 B3–B4 — Multi-Pose Geometry and Sensing

The initial configurations were assessed using:

- Combined translation and rotation poses.
- Cable–sphere interference screening.
- Cable–cable finite-segment distance checks.
- Jacobian rank.
- Scaled singular values.
- Condition number.
- Simulated measurement uncertainty.

An important finding was that sensing optimisation and geometric feasibility must be evaluated together.

For example, a modified cable pairing could improve geometric feasibility while reducing sensing performance.

This motivated structured configuration redesign rather than reference-pose-only optimisation.

### 4.4 B5.1–B5.3 — Structured Configuration Redesign

The design framework was expanded through:

- Twelve-rail anchor constraints.
- Expanded attachment candidate distributions.
- Structured anchor layout families.
- Cable pairing enumeration.
- Multi-pose geometric and sensing screening.

Eighteen structured anchor layouts were evaluated.

Six configurations satisfied the Core 189-pose geometry and rank screening:

`[2, 4, 6, 8, 12, 17]`

This provided a controlled set of candidates for further configuration development.

### 4.5 B5.4 E1 — Anchor Optimisation

E1 investigated anchor placement along the rails and selected rail reassignment strategies.

The resulting candidate branches used for subsequent E2 evaluation included:

- E1b C2-2.
- E1b C4-1.
- E1b C8-16.
- E1a C12.

The E1 research established that rail-constrained anchor locations could be refined while retaining the six-cable measurement architecture.

Installation position and sensing performance remained competing design considerations.

### 4.6 B5.4 E2 — Attachment Optimisation

E2 investigated attachment-point optimisation on the sphere while retaining the selected parent anchors and cable pairing.

Two optimisation priorities were studied:

- Sensing-priority search.
- Margin-preserving sensing search.

Selected candidates were evaluated using the 539-pose development set, installation perturbations and matched nonlinear pose-estimation simulations.

The retained final designs were:

1. C2-2 Repaired M.
2. C4-1 E2 M.
3. C8-16 E2 M.
4. C12 E2 M.

All four passed 539/539 nominal development-pose geometric checks.

The results do not establish global optimality or collision-free motion across a complete continuous workspace.

---

## 5. Final Four-Configuration Numerical Comparison

### 5.1 Geometric and Sensing Results

| Metric | C2-2 Repaired M | C4-1 E2 M | C8-16 E2 M | C12 E2 M |
|---|---:|---:|---:|---:|
| Worst scaled sigma-min, 539 poses | 0.702000 | 0.582702 | 0.569039 | 0.505817 |
| Nominal geometric pass | 539/539 | 539/539 | 539/539 | 539/539 |
| Minimum ideal cable distance (mm) | 5.2958 | 39.0163 | 16.0627 | 13.5666 |
| Minimum outward angle (deg) | 0.4254 | 13.7606 | 0.8580 | 16.3849 |
| Specified attachment perturbation pass | 23/24 | 24/24 | 24/24 | 24/24 |

The scaled minimum singular value measures the weakest local measurement direction under the established Jacobian scaling.

A larger value indicates stronger local sensitivity in the weakest direction.

It is not a direct experimental accuracy measurement.

The reported minimum cable distances are ideal geometric results and do not incorporate the complete physical envelopes of cables, guides or connectors.

### 5.2 Matched Nonlinear Pose Estimation

Using independent synthetic cable-length noise with SD = 0.100 mm:

| Design | Position RMSE (mm) | Orientation RMSE (deg) |
|---|---:|---:|
| C2-2 Repaired M | 0.15268 | 0.18153 |
| C4-1 E2 M | 0.15348 | 0.21433 |
| C8-16 E2 M | 0.15813 | 0.20998 |
| C12 E2 M | 0.16120 | 0.21895 |

The matched E2 study used 36 selected development poses with 20 independent noise repetitions per pose.

All reported values are simulation outputs.

No independent physical pose measurement, hardware calibration or experimentally measured sensor noise was available.

Therefore, the values must not be used as guaranteed Prototype V1 accuracy specifications.

### 5.3 Interpretation

The four configurations provide different balances of:

- Local sensing performance.
- Cable separation.
- Balloon outward-departure margin.
- Attachment robustness.
- Rail mounting accessibility.
- Connector spacing.

Selecting the maximum sigma-min alone would favour C2-2, but would not adequately address its geometric and perturbation-related limitations.

A prototype configuration must balance measurement quality with physical implementation requirements.

---

## 6. Initial Mechanical Mounting Audit

### 6.1 Research Question

Can the selected mathematical anchor coordinates be implemented using practical mounts on a 3030 aluminium extrusion frame?

### 6.2 Rail-End Mounting Results

| Configuration | Minimum Rail-End Distance (mm) | Limiting Cable |
|---|---:|---|
| C2-2 Repaired M | 31.111 | Cable 3 |
| C4-1 E2 M | 0.000 | Cable 2 |
| C8-16 E2 M | 66.667 | Cable 5 |
| C12 E2 M | 10.000 | Cable 6 |

A preliminary centred-clamp assumption used:

- Mounting footprint: 30 mm.
- Additional end reserve: 5 mm.

This produced a simplified required rail-end distance of 20 mm.

Under that assumption:

- C2-2: 6/6 nominal anchor positions acceptable.
- C4-1: 5/6 acceptable.
- C8-16: 6/6 acceptable.
- C12: 5/6 acceptable.

The assumed clamp dimensions were not derived from final hardware.

These results are one-dimensional mounting checks, not full physical assembly verification.

### 6.3 Attachment Spacing

| Configuration | Minimum Attachment Chord (mm) |
|---|---:|
| C2-2 Repaired M | 28.306 |
| C4-1 E2 M | 39.016 |
| C8-16 E2 M | 29.489 |
| C12 E2 M | 21.584 |

The C4-1 design provides the largest minimum attachment spacing of the four.

However, actual connector dimensions, protrusion and local cable routing have not yet been modelled.

---

## 7. Mechanical Architecture Decision

### 7.1 Single-Frame Concept

The initial hardware development architecture is a single 3030 aluminium extrusion frame.

The computational reference boundary remains:

280 × 300 × 320 mm.

The proposed physical arrangement separates:

- The effective cable exit point.
- The mechanical guide mounting position.
- The pulley centre, where applicable.
- The external motor or winch location.

A larger double-boundary frame was considered but not selected as the initial architecture.

Reasons for preferring the single-frame concept include lower expected structural complexity and easier mechanical development.

These advantages remain preliminary engineering judgements rather than experimentally demonstrated performance differences.

### 7.2 M1.1 — Frame Reference Mapping

A simplified 3030 model was constructed using a 30 × 30 mm extrusion envelope.

For the chosen reference arrangement, each theoretical anchor was associated with a mounting reference offset by 15 mm in two directions.

The resulting reference distance was:

\[
\sqrt{15^2+15^2}=21.213\ \mathrm{mm}
\]

This value represents a reference-point distance, not the length of an actual manufactured bracket.

### 7.3 M1.2 — Frame Envelope Analysis

The simplified model represented each extrusion by a solid rectangular cross-section.

All 24 theoretical mounting-reference segments crossed the corresponding extrusion envelope.

This was a consequence of the reference-point definition and should not be treated as proof of 24 actual mounting failures.

The meaningful installation concerns were the rail-end positions of C4-1 Cable 2 and C12 Cable 6.

---

## 8. Cable Guide Direction Analysis

### 8.1 M1.3 — Fixed-Plane Direction Deviation

Cable directions were calculated over the 539 development poses.

A least-squares fixed plane was fitted separately for each cable.

The maximum out-of-plane deviations, considering the limiting cable in each configuration, were:

| Configuration | Limiting Cable | Maximum Deviation (deg) |
|---|---:|---:|
| C2-2 Repaired M | Cable 1 | 11.046 |
| C4-1 E2 M | Cable 5 | 11.720 |
| C8-16 E2 M | Cable 2 | 11.671 |
| C12 E2 M | Cable 4 | 12.121 |

These results show that cable direction varies in three dimensions during the sampled motion.

The fitting procedure minimised mean squared out-of-plane directional components.

It did not directly minimise the maximum deviation.

The deviation values cannot be interpreted as measured friction, cable escape risk or guaranteed pulley failure.

### 8.2 M1.4 — Local Angular Envelope

The largest directional ranges were:

| Configuration | Largest Yaw Range | Largest Pitch Range | Maximum Reference Cone Angle |
|---|---:|---:|---:|
| C2-2 Repaired M | 19.411° | 20.585° | 11.713° |
| C4-1 E2 M | 22.443° | 21.994° | 12.745° |
| C8-16 E2 M | 21.107° | 23.443° | 12.716° |
| C12 E2 M | 21.658° | 24.079° | 12.694° |

These angles are defined in local mathematical coordinates around each reference cable direction.

They are not directly the required joint angles of a real swivel pulley.

### 8.3 Mechanical Implications

A conventional fixed single-plane pulley should not be assumed suitable for all required cable directions.

Two guide concepts were identified for future testing:

1. Fixed low-friction eyelet.
2. Swivel or panning pulley.

The guide must be evaluated for:

- Directional freedom.
- Mechanical clearance.
- Low-tension friction.
- Hysteresis.
- Cable retention.
- Effective cable exit geometry.
- Measurement calibration.

No guide has yet been physically tested.

---

## 9. Practical Prototype Information

Informal technical communication with Jingjun Liu provided additional hardware design context.

The reported prototype used:

- 3030 aluminium extrusion.
- Custom 3D-printed routing components.
- T-slot fasteners.
- Custom winch drums.
- Feetech SM45BL servos.
- No.10 PE fishing line.
- TPU-95 flexible printed structures.

The external prototype was developed for a different actuation context.

Jingjun noted that the servo has limited back-drivability and may not suit the current passive balloon sensing application.

The discussion also highlighted practical difficulties in attaching cables to a thin inflatable balloon.

Screw-mounted attachments were used with a relatively stiff TPU-95 flexible structure.

Tape attachment to an earlier balloon prototype was reported to be unstable.

These observations support the decision to begin with a rigid spherical end-effector and investigate flexible attachment separately.

The external prototype components are useful references, not selected specifications for the present system.

---

## 10. Provisional Primary and Backup Decision

### 10.1 Primary Candidate — C4-1 E2 M

C4-1 is the current provisional primary candidate because it combines:

- Reasonable sensing quality.
- Large nominal cable separation.
- Relatively large outward-departure angle.
- Large attachment spacing.
- Complete nominal development-pose geometric feasibility.

Its main outstanding installation issue is Cable 2.

Cable 2 anchor:

\[
A_2=(140,150,-160)\ \mathrm{mm}
\]

Assigned Rail: 6.

The position lies at the endpoint of the rail.

A targeted adjustment along the same rail is planned.

No revised anchor location has yet been accepted.

### 10.2 Backup Candidate — C12 E2 M

C12 is the current provisional backup because it provides a relatively large outward-departure margin.

Its main installation issue is Cable 6.

Cable 6 anchor:

\[
A_6=(140,-140,-160)\ \mathrm{mm}
\]

Assigned Rail: 10.

The position lies 10 mm from the nearest rail endpoint.

A limited inward adjustment is planned.

Connector spacing must also be checked using realistic hardware dimensions.

### 10.3 Other Candidates

**C8-16 E2 M**

Retained as an alternative with convenient rail mounting positions.

Its small minimum outward-departure margin is an important limitation.

**C2-2 Repaired M**

Retained as the high-sensing numerical reference.

Its small cable separation and residual attachment sensitivity currently make it less attractive for the first physical build.

### 10.4 Decision Status

The primary and backup selections are provisional.

No final physical configuration has been frozen or manufactured.

---

## 11. Outstanding Research Questions

### 11.1 Can the Critical Anchors Be Moved?

The current plan is to locally adjust:

- C4-1 Cable 2 along Rail 6.
- C12 Cable 6 along Rail 10.

Other anchors, attachment coordinates and pairing will remain fixed during the initial study.

Any accepted adjustment must be re-evaluated for sensing, clearance and installation feasibility.

### 11.2 Is Continuous Motion Interference-Free?

Not yet established.

The existing 539-pose results are discrete development-stage checks.

Additional work is required to evaluate:

- Motion between sampled poses.
- Representative continuous trajectories.
- High-risk intermediate configurations.
- Conservative distance bounds.
- The limits of any certified operating region.

The physical cable diameter and guide/connector geometry must subsequently be included.

### 11.3 Can the Mathematical Anchor Be Implemented Physically?

Not yet established.

The final guide arrangement must account for mounting geometry, pulley tangency, cable wrap and possible motion-dependent cable paths.

The physical effective anchor or full length model must be calibrated.

### 11.4 What Measurement and Tension Hardware Is Needed?

Not yet established.

Important unknowns include:

- Required operating tension.
- Maximum cable tracking speed.
- Guide friction.
- Cable elongation.
- Encoder resolution and accuracy.
- Winch winding behaviour.
- Motor back-drivability.
- Experimental ground-truth accuracy.

### 11.5 How Should Cables Attach to a Flexible Balloon?

Not yet established.

Future experiments must investigate attachment reliability, local deformation, slippage and sealing.

Rigid-body sensing validation will precede the flexible-balloon study.

---

## 12. Transition to Prototype Development

The research has moved beyond initial configuration exploration.

The next scientific uncertainty is no longer only whether a favourable six-cable Jacobian can be obtained.

The remaining key questions concern whether the numerical design can be implemented as a measurable physical system.

These include:

- Mechanical mounting feasibility.
- Continuous-motion interference.
- Real guide friction.
- Low-tension tracking.
- Cable displacement accuracy.
- Effective anchor calibration.
- Experimental six-DOF pose estimation.

Consequently, the research strategy has shifted from broad theoretical optimisation to targeted engineering refinement followed by experimental validation.

### Paused Optimisation Tasks

Full E3 pairing optimisation and E4 joint optimisation have not been completed.

They are currently paused.

They may be reconsidered if targeted mechanical refinement reveals an unresolved configuration problem.

The current plan does not require global optimality before building an experimental prototype.

---

## 13. Next Research Plan

The active plan is:

`08_Project_Management/November/Prototype_V1_Build_and_Validation_Plan.md`

### Pre-Procurement

| Task | Activity | Status |
|---|---|---|
| P0.1 | Targeted Anchor Refinement | Pending |
| P0.2 | Continuous Motion Interference Screening | Pending |
| P0.3 | Provisional Primary/Backup Freeze | Pending |
| P0.4 | One-Cable CAD Concept and Preliminary BOM | Pending detailed engineering |
| P0.5 | Supervisor Presentation and Funding Request | Pending |

A preliminary concept and procurement planning BOM have been documented, but final specifications and quotations are not yet available.

### Hardware Development

| Task | Activity | Status |
|---|---|---|
| P1 | One-Cable Mechanical Module | Not started |
| P2 | Length Measurement and Low-Tension Validation | Not started |
| P3 | Final Mechanical Configuration Freeze | Not started |
| P4 | Six-Cable Rigid Prototype Assembly | Not started |
| P5 | Experimental Six-DOF Sensing Validation | Not started |
| P6 | Flexible Balloon Pilot Test | Not started |

**Prototype V1.0:** Six-cable rigid-body sensing system with documented experimental performance.

**Prototype V1.1:** Preliminary flexible-balloon compatibility evaluation.

---

## 14. Evidence and Data Integrity

The following distinctions must be preserved:

- Development-pose results versus independent validation.
- Ideal cable geometry versus physical cable clearance.
- Nominal geometry versus manufacturing perturbation robustness.
- Jacobian sensitivity versus actual sensor accuracy.
- Simulated pose RMSE versus experimental pose RMSE.
- Mathematical anchors versus real guide exit geometry.
- Active cable actuation versus passive motion sensing.
- Initial rigid sphere versus realistic deformable balloon.

The 539-pose development set was used during configuration development and repair.

It must not be relabelled as an untouched final holdout.

Future independent validation should use a separately defined pose set after numerical configurations are provisionally frozen.

The mathematical E2 attachment matrices are already paired by cable row.

Historical pairing indices must not be applied to them again.

---

## 15. Relevant Research Records

### Existing GitHub Evidence

- `06_Research_Log/2026-11/B5_3_Twelve_Rail_Structured_Configuration_Research_Log_2026_11_11.md`
- `06_Research_Log/2026-11/B5_4_E1a_Anchor_Rail_Position_Optimisation_Research_Log_2026_11_12.md`
- `06_Research_Log/2026-11/B5_4_E2_Phase_Research_Summary.md`

### MATLAB Numerical Evidence

- `B5_4_E2_539pose_verification.mat`
- `B5_4_E2_C2_C4_targeted_repair.mat`
- `B5_4_E2_matched_pose_estimation.mat`
- Relevant B5.3/B5.4 anchor and attachment optimisation outputs.

### Preliminary Mechanical Analysis

Local MATLAB outputs from:

- M1.1 — Single-Frame Anchor Layout.
- M1.2 — Frame Occupancy Check.
- M1.3 — Cable Guide Direction Audit.
- M1.4 — Guide Angular Envelope.

These M1.1–M1.4 outputs were reviewed during the current research discussion.

Their permanent repository locations have not yet been established.

The local mechanical analysis outputs should be archived before subsequent model changes.

### Current Project Documents

- `CURRENT_STATE2.md`
- `05_My_Research/Prototype_V1_Mechanical_Design_Concept.md`
- `08_Project_Management/November/Prototype_V1_Build_and_Validation_Plan.md`
- `08_Project_Management/November/Prototype_V1_Procurement_BOM.md`

---

## 16. Stage Conclusion

The project has established a reproducible six-cable sensing geometry and developed four candidate configurations through structured screening, rail-constrained anchor optimisation and spherical attachment optimisation.

All four retained E2 candidates passed the nominal geometry checks on the 539-pose development set.

C4-1 E2 M is the provisional primary design and C12 E2 M is the provisional backup.

Preliminary single-frame mounting and cable-guide direction analyses have identified important physical implementation constraints.

The key remaining problems are targeted anchor installation refinement, continuous-motion interference verification and the selection of a practical low-tension cable measurement mechanism.

The next development stage will address these problems before moving to a one-cable experimental module and finally a six-cable rigid-body sensing prototype.

**Stage decision: Proceed with targeted pre-prototype engineering validation and prepare for experimental development.**

---

**Record status:** Completed retrospective stage summary.  
**Next technical task:** P0.1 — Targeted Anchor Refinement, after completing repository documentation consistency checks.
