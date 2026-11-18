# Research Roadmap — Cable-Based Sensing of a Passive Balloon

**Revised:** 2026-11-18  
**Primary research tool:** MATLAB  
**Current milestone:** Refine C4-1 and C12, evaluate their usable workspaces, and select a provisional six-cable geometry for bench testing.

## 1. Research goal

Develop a cable-length measurement system that can estimate the pose of a passively moving balloon-like object in a stomach-inspired test environment.

The first prototype uses six cables and a rigid reference body with known attachment coordinates. Independent pose measurements will establish how accurately the cable system reconstructs rigid-body motion. An inflated-balloon pilot will then investigate how attachment movement, surface deformation and cable tension affect the measurements.

The immediate engineering objective is to obtain a configuration that can be built, calibrated and tested over a stated operating region.

## 2. Research completed to date

| Stage | Contribution to the current design |
|---|---|
| Phase 0 and Phase A | Defined the application and measurement objective, and reproduced selected literature methods. |
| B1–B4 | Established the frame and spherical surrogate, cable-length model, geometric checks, measurement Jacobian and initial uncertainty analysis. |
| B5.1–B5.3 | Diagnosed interference and sensitivity failures, studied cable pairing, and introduced anchor layouts constrained to twelve frame-edge rails. |
| B5.4 E1 and E2 | Refined anchor layouts, then optimised spherical attachments with the parent anchors and pairing fixed. Four final E2 candidates passed nominal geometry checks at 539 development poses. |
| Initial engineering work | Identified rail-end mounting risks, connector-spacing questions and cable-guide design choices. M1.1–M1.4 provide preliminary mechanical evidence. |

C4-1 is the provisional primary candidate and C12 is the provisional backup. C8-16 and C2-2 remain available as reference or reserve configurations. Detailed metrics and limitations are recorded in the [E2 research summary](../06_Research_Log/2026-11/B5_4_E2_Phase_Research_Summary.md).

## 3. P0 — Complete the theoretical design for the first experiments

### P0.1 — Refine C4-1 and C12 under physical installation constraints

**Research question:** Once the guides and connectors have physical dimensions, does moving anchors and attachments together produce a useful improvement over changing either group alone?

Start with the two installation questions that can affect the prototype choice:

- **C4-1:** Determine where Cable 2 anchor A2 can be installed on Rail 6 near the frame vertex. Use the effective cable exit point as the model coordinate.
- **C12:** Determine the installable range of Cable 6 anchor A6 on Rail 10 and check the separate B1–B5 connector-spacing constraint on the sphere.

Measure the available extrusion and corner fittings. Use a trial guide or dimensioned design to establish mounting footprints and allowable shifts. Record which dimensions were measured and which remain provisional.

Compare four variants within each candidate family:

| Variant | Anchor positions | Attachment positions | Decision supported |
|---|---|---|---|
| Original E2 | E2 values | E2 values | Establish the starting performance and installation limitations. |
| Anchor only | Selected rail coordinates adjustable | E2 values | Determine the effect of correcting the mounting position alone. |
| Attachment only | E2 values | Selected surface coordinates adjustable | Determine the benefit available from attachment changes at fixed anchors. Reuse E2 evidence where the comparison conditions match. |
| Joint | Selected rail coordinates adjustable | Selected surface coordinates adjustable | Determine whether coordinated changes recover or improve clearance and sensing after installation constraints are applied. |

Keep rail assignments and cable pairing fixed for this targeted study. In the joint search, allow an anchor to be revisited after an attachment changes. Use comparable objectives, constraints, evaluation poses and documented search budgets. Full E4 optimisation across additional design variables remains paused.

**Milestone:** Retain the installable variants that merit workspace analysis. Record why any remaining gain in sensing sensitivity justifies the associated mounting or clearance trade-off.

### P0.2 — Evaluate feasibility across the prescribed workspace

**Research question:** Over which combinations of translation and rotation can each retained variant measure pose while satisfying geometric and installation constraints?

1. Define the common six-dimensional test domain, including translation bounds, orientation bounds and rotation convention. The frame dimensions alone do not specify the usable workspace.
2. Map containment, cable departure, clearance between all 15 cable pairs, and interference with guides, connectors and frame hardware.
3. Evaluate Jacobian rank, worst-direction sensitivity and predicted pose uncertainty over the same domain. State the characteristic length and measurement-noise assumptions.
4. Refine near small margins and feasibility boundaries. Apply continuous bounds where available, identify what each bound covers, and record unresolved regions.
5. Identify the connected feasible region containing the intended starting pose. Distinguish positions usable at some orientations from positions usable throughout the required orientation range.
6. Recheck frozen variants on independent poses or cells. Keep the original 539 development poses as a historical benchmark.

**Milestone:** Produce comparable workspace maps for C4-1 and C12. Report the limiting poses, failure mechanisms, connected operating regions and strength of the evidence. A sampled pass rate alone is insufficient to establish continuous feasibility.

### P0.3 — Select the provisional V1 configuration

Choose the configuration and variant using installation feasibility, usable workspace, limiting cable clearance, sensing performance and sensitivity to placement errors. Record the six effective anchor coordinates, six attachment coordinates, cable pairing and supported test region.

If neither candidate covers the intended domain, identify the limiting constraint. Use that evidence to choose between a targeted redesign and a smaller, explicitly documented first-test region.

**Milestone:** One provisional V1 geometry, a justified backup decision and a defined range for the first experiments.

### P0.4–P0.5 — Prepare the single-channel design and funding request

Prepare the single-cable CAD concept, preliminary bill of materials and supervisor presentation. Reuse laboratory extrusion and fittings. Identify printed components, purchased components and quantities needed for a single working channel. Use the selected geometry to derive the required cable travel and guide-angle range.

**Milestone:** A costed first experiment with a stated measurement purpose for each major purchase.

## 4. P1–P6 — Build, measure and revise the prototype

| Stage | Main work | Evidence and decision |
|---|---|---|
| P1 — Single-cable module | Build one channel with a guide, spool, encoder and take-up mechanism. Establish a repeatable length reference. | Confirm that the channel can be assembled, adjusted and calibrated over the required travel. |
| P2 — Length and low-tension tests | Measure payout and retraction error, repeatability, reversal behaviour, slack and balloon-side tension across representative guide angles and speeds. | Determine whether reliable take-up and acceptable balloon disturbance can coexist. Select or revise the motor, spool and guide before replicating the module. |
| P3 — Final mechanical configuration | Update effective exit coordinates, guide geometry and error assumptions using the single-channel results. Repeat the affected P0 checks. | Decide which dimensions, components and settings to use for six-channel assembly. |
| P4 — Six-cable rigid prototype | Assemble and label six channels, measure the installed geometry, calibrate length offsets and establish synchronised data capture. | Obtain an as-built model and a reproducible calibration record. |
| P5 — Experimental six-DOF validation | Test known poses and continuous motions using an independent reference. Separate calibration data from evaluation data. | Report position and orientation errors, repeatability, failed estimates and the experimentally supported operating region. |
| P6 — Inflated-balloon pilot | Track surface markers and attachment motion under documented inflation and tension settings. | Estimate how much additional error and disturbance arise with a deformable specimen, and identify the next rig modification. |

If a bench test reveals a systematic length bias, moving exit point, attachment slip or excessive disturbance, revise the affected component or model and repeat the relevant test. Preserve each as-built geometry and its calibration data so improvements can be compared.

## 5. Longer-term research

| Workstream | Research direction |
|---|---|
| B6–B7 — Hardware and platform refinement | Use V1 data to improve mechanical sizing, sensing, calibration and repeatability. |
| B8 — Extended rigid and flexible experiments | Expand the tested motion and deformation conditions. Determine which deformation parameters can be identified and what additional measurements they require. |
| B9 — Configuration and cable-number comparison | Compare six-, seven- and eight-cable systems under common workspace, noise, installation and interference assumptions. Use the measured six-cable baseline to judge whether additional channels justify their complexity. |

Seven- and eight-cable theory can proceed in parallel. The six-cable experimental timeline depends on the P0–P6 evidence above.

## 6. Current milestone and project records

The next technical task is to establish the mountable ranges of C4-1 A2 and C12 A6, identify the attachment variables implicated by the engineering audit, and define the matched single-group and joint comparisons. Final V1 selection follows the workspace analysis.

- [Current research state](../CURRENT_STATE2.md)
- [Prototype V1 build and validation plan](November/Prototype_V1_Build_and_Validation_Plan.md)
- [MATLAB simulations](../03_Simulation/MATLAB/)
- [Research logs](../06_Research_Log/)
