# Prototype V1 — Build and Validation Plan

**Version:** 1.1  
**Date:** 2026-11-18  
**Stage:** Pre-prototype design refinement  
**Working candidates:** C4-1 E2 M and C12 E2 M  
**Primary tools:** MATLAB, CAD, 3D printing and bench measurement

## 1. Objective and design decisions

Build a six-cable test rig that measures the pose of a passively moving object and quantify its performance against an independent reference. Begin with a rigid body carrying six known attachment points. Use an air-filled balloon to investigate attachment movement, deformation and cable-induced disturbance.

This plan supports three decisions:

1. **Before prototype funding:** Which configuration can be installed, over what position and orientation range, and what single-channel experiment should be funded?
2. **Before six-channel procurement:** Can one channel measure displacement repeatably and take up slack without excessive disturbance?
3. **After assembly:** Over what experimentally tested region can the six-channel system reconstruct rigid-body pose, and what changes when the object is flexible?

## 2. Starting evidence and available resources

| Item | Current basis |
|---|---|
| Geometry | 280 × 300 × 320 mm computational frame. X denotes length, Y width and Z height. The nominal 550 mL rigid sphere has radius 50.8266 mm. |
| Configuration development | B1–B5.3 established the model, sensing metrics and twelve-rail geometry. Of 18 structured configurations, six met the Core 189-pose geometry and rank requirements. |
| Optimisation completed | E1 refined anchor layouts. E2 optimised spherical attachments with the parent anchors and pairing fixed. Four final E2 candidates passed nominal geometry checks at 539/539 development poses. |
| Mechanical analysis completed | M1.1–M1.4 examined a single 3030 frame, mounting references, rail-end clearance, simplified frame envelopes and cable-direction envelopes. Reuse these outputs when defining the physical guides. |
| Sensing model | Six cable lengths for six rigid-body pose variables. The existing uncertainty study assumes a cable-length standard deviation of 0.100 mm. Actual channel errors remain to be measured. |
| Available resources | Reuse laboratory extrusion and mounting hardware where dimensions are compatible. Brackets, fixed guides, pulley wheels and drums can be printed. Purchase cable and select a motor. A commercial swivel guide is an option for comparison. |

The computational frame dimensions locate the nominal geometry. Determine extrusion cut lengths and bracket offsets from the actual frame assembly and effective cable exit coordinates.

## 3. Candidate roles

| Candidate | Starting evidence | Design question |
|---|---|---|
| **C4-1 E2 M** | Provisional primary. Minimum cable centreline distance of 39.0163 mm over 539 development poses. Passed all 24 prescribed attachment perturbation cases. | Can Cable 2 anchor A2 on Rail 6 be mounted at or near the vertex? If it moves inward, can a local attachment change preserve or improve sensing and clearance? |
| **C12 E2 M** | Provisional backup. Minimum cable centreline distance of 13.5666 mm over the same poses. Passed all 24 prescribed attachment perturbation cases. | Can Cable 6 anchor A6 on Rail 10 be installed with sufficient rail-end clearance? Can the connectors at B1 and B5 fit through the intended range of cable directions? |
| C8-16 E2 M | Reserve candidate with a smaller outward departure margin. | Reconsider if a mounting or workspace limitation rules out a preferred candidate. |
| C2-2 Repaired M | High-sensitivity reference with a known C6 attachment perturbation failure. | Retain for comparison when interpreting sensitivity and robustness trade-offs. |

The quoted distances are between modelled cable centrelines. Hardware clearance also depends on cable diameter, connector orientation, guide geometry and installation variation.

## 4. P0.1 — Targeted anchor and attachment optimisation

**Research question:** For each preferred family, what is gained by adjusting anchors and attachments jointly after real installation constraints are introduced?

### Step 1 — Reproduce the two starting configurations

Load the saved E2 coordinates, rail IDs, rail parameters and cable correspondence. Preserve an unchanged copy of each parent. The saved attachment rows are already paired with the anchors; applying an earlier pairing permutation again would change the design.

Reproduce the nominal 539-pose geometry results and the recorded minimum cable distances in Section 3. Record the limiting pose, cable pair, minimum outward angle and worst scaled minimum singular value. Resolve any discrepancy before comparing variants.

**Output:** One reproducible baseline record per family, including source data, evaluation script and units.

### Step 2 — Establish physical bounds for the search

Measure the extrusion, corner fitting, required fastener access and proposed guide footprint. Distinguish the bracket mounting coordinate from the effective point where the cable enters the working space. A bracket mounted inward from the corner may still place the exit point close to the original vertex.

For C4-1, convert these measurements into an allowable interval for A2 on Rail 6. For C12, do the same for A6 on Rail 10. Separately measure or model the envelopes of the B1 and B5 connectors. Moving A6 changes cable routing but leaves the B1–B5 attachment spacing unchanged.

Select attachment variables from a documented constraint or limiting pose. Declare their allowed surface neighbourhoods before searching. Record each physical dimension as measured, estimated from a drawing, or unknown. An unknown critical dimension leaves the corresponding hardware decision provisional.

**Output:** A constraint table with variable ID, coordinate frame, bounds, units, source and affected hardware.

### Step 3 — Compare four variants within each family

| Variant | Anchor variables | Attachment variables | Purpose |
|---|---|---|---|
| Original E2 | Fixed at E2 | Fixed at E2 | Preserve the common reference and quantify its installation limitation. |
| Anchor only | Search the selected rail interval | Fixed at E2 | Measure the cost or benefit of resolving the rail-end issue alone. |
| Attachment only | Fixed at E2 | Search selected spherical neighbourhoods | Isolate the attachment contribution. Reuse E2 evidence where bounds, objective and evaluation conditions match. |
| Joint | Search the same rail interval | Search the same spherical neighbourhoods | Test whether coordinated changes give a useful improvement over the single-group variants. |

Keep the rail assignments, cable pairing, frame, sphere radius and unselected points fixed. In the joint search, evaluate each candidate with its updated anchors and attachments together. The search must permit revisiting the anchor after an attachment changes. Simultaneous search and iterative alternating search are both acceptable if their budgets and stopping rules are documented.

Use a common development set, geometric definitions, Jacobian scaling and noise assumptions. Declare the objective, hard constraints, search bounds and evaluation budget before comparing results. Keep physically infeasible variants in the comparison record with their failure reasons.

### Step 4 — Decide which variants advance

Compare mounting clearance, connector fit, minimum cable separation, minimum departure angle, worst scaled minimum singular value and sensitivity to installation errors. For the shortlist, repeat the nonlinear pose-estimation comparison with matched noise realisations and report convergence failures.

**Decision:** Advance the simplest installable variant from each family that merits workspace evaluation. If two variants exchange sensing performance for clearance, retain both for P0.2. A joint search returning no worthwhile improvement is a valid result. Full E3 pairing enumeration and unrestricted E4 configuration search remain paused.

## 5. P0.2 — Determine the usable workspace

**Research question:** Within the declared six-dimensional pose domain, which positions and orientations support physical routing and six-DOF measurement, and which feasible regions are connected to the starting pose?

| Step | Action | Required output |
|---|---|---|
| 1. Define the domain | Specify position bounds, rotation convention, orientation bounds, starting pose and the motions required for the first experiment. Apply the same domain to both families. | A common domain specification with units, assumptions and sampling or subdivision rules. |
| 2. Screen geometry | At each evaluated pose, check body containment, cable departure, all 15 cable pairs, connectors, guides and frame obstacles. Include cable radii and declared installation allowances. | Minimum physical margins and the cable, hardware feature and pose responsible for each limit. |
| 3. Evaluate sensing | Map Jacobian rank, weakest-direction sensitivity, conditioning and predicted pose uncertainty. State the characteristic length used for Jacobian scaling. Evaluate cable-length extrema and required travel by channel. | Sensing and travel maps. Where an accuracy target is still open, retain the metric values and label acceptance as pending. |
| 4. Examine intervals and cells | Refine near tight clearances, orientation extremes and transitions between feasible and failed poses. Use conservative continuous bounds where available. Record the geometry and criterion covered by each bound. | A coverage record distinguishing verified cells, sampled cells, observed failures and unresolved cells. |
| 5. Identify a usable region | Find the feasible region reachable from the intended starting pose. Check transitions used to establish connectivity. At each centre position, distinguish feasibility at some orientations from feasibility throughout the required orientation range. | Comparable position maps, orientation coverage and the evidence supporting each connection. |
| 6. Validate frozen variants | Evaluate independent poses or cells after the design variables are frozen. If a failure leads to redesign, move that case into the development record and reserve fresh validation data. | Independent results, limiting cases and recommended operating limits for each variant. |

Representative translation, rotation and combined test paths should be selected from this analysis for later experiments. A successful path check supports that path; a claim about a surrounding region requires evidence covering the region.

**Decision:** State the operating region supported for each candidate, the criteria verified there and the remaining uncertainties. If the original domain is too large, identify the specific limiting mechanism before choosing between a local redesign and a smaller first-test region.

## 6. P0.3–P0.5 — Select the design and prepare the funding request

### P0.3 — Provisional configuration selection

Compare C4-1 and C12 using the same domain, installation assumptions and sensing criteria. Document the selected primary configuration, the status of the backup and the reasons for the decision.

Freeze the numerical version with its six effective anchor coordinates, paired attachment coordinates, rail IDs and parameters, assumed hardware envelopes, operating region and limiting poses. Record what new evidence would require the model to be revised.

### P0.4 — Single-channel CAD and preliminary BOM

Design one removable channel on the single-frame architecture. Draw the path from the drum, through any external redirection, to the last guide and the attachment. Dimension the mounting point and effective exit point separately.

Use P0.2 to specify free cable length, travel, reserve and exit-angle range. State the assumed speed and tension ranges for initial motor sizing, and identify how each will be checked. Include access for a displacement reference and balloon-side force measurement.

| Resource | Initial decision |
|---|---|
| Frame and fasteners | Inventory and measure existing laboratory extrusion, corner fittings and T-slot hardware before ordering. |
| Bracket, drum and fixed guide | Print one set. Inspect alignment, surface finish, winding behaviour and access for adjustment. |
| Cable | Purchase sample material. Record diameter, construction and termination method. |
| Pulley or swivel guide | Evaluate a printed pulley where its angular range is suitable. Include one commercial swivel guide as a costed alternative if the fixed guide has excessive friction or angle-dependent error. |
| Motor, encoder and drive | Specify one channel from the required travel, speed, tension and drum geometry. Record encoder location and how rotation will be converted to length. |
| Measurement references | Identify available displacement, low-range force and independent pose references. Record their resolution and calibration status. |

**Output:** Preliminary assembly CAD, one-channel BOM, available inventory, supplier quotations where needed, and the measurements that justify later six-channel procurement.

### P0.5 — Supervisor presentation and funding decision

Prepare an eleven-slide English presentation:

1. Measurement objective and passive-motion application.
2. Rigid-body validation and flexible-balloon pilot.
3. Configuration development and four E2 finalists.
4. C4-1 and C12 mounting constraints.
5. Anchor-only, attachment-only and joint comparison.
6. Workspace evidence, limitations and provisional selection.
7. Effective exit point, cable routing and guide design.
8. Single-channel experiment and quantities to measure.
9. Reused, printed and purchased components with estimated cost.
10. P1–P6 experimental sequence and design decisions.
11. Requested resources and decisions for supervisor review.

Label planned tests and pending results explicitly if the presentation precedes completion of a study.

## 7. P1–P6 — Build, test and revise

| Stage | Experiment | Evidence required for the next decision |
|---|---|---|
| **P1 — Assemble one channel** | Fit the guide, drum, encoder and take-up mechanism. Establish a reproducible length reference. Check alignment and full travel. | Working module, as-built dimensions, cable path and calibration procedure. |
| **P2 — Validate length and low tension** | Use known displacements in payout and retraction at representative angles and speeds. Measure offset, scale error, repeatability, hysteresis, slack and balloon-side tension. Characterise balloon attachment movement under load. | Determine whether the tension needed for reliable take-up is compatible with allowable disturbance. Select or revise the guide, drive and length model before replication. |
| **P3 — Freeze the mechanical design** | Update effective exit coordinates, connector envelopes and error assumptions from P1–P2. Repeat affected geometry, workspace and sensing checks. | Assembly-ready six-channel CAD and BOM with documented operating limits. |
| **P4 — Assemble the rigid test rig** | Install and label six channels. Measure actual anchors and attachments, calibrate offsets, and synchronise the six measurements and the independent reference. | As-built geometry, calibration record and reproducible data acquisition. |
| **P5 — Validate six-DOF pose** | Test held-out static poses and continuous motions against independent ground truth. Declare justified position, orientation and repeatability targets before acceptance testing. | Position and orientation errors, P95, repeatability, convergence failures and experimentally supported operating region. Record all attempted trials. |
| **P6 — Run the flexible-balloon pilot** | Use an air-filled balloon with visible markers. Record inflation condition, attachment stability, local deformation and response to cable tension. | Evidence of the additional error or disturbance introduced by flexibility, and a prioritised rig modification. A liquid-filled silicone model remains a later application-oriented stage. |

If a test exposes a systematic failure, preserve the original measurements, identify the affected assumption, change the relevant component or model, and repeat the same test conditions for comparison.

## 8. Records and immediate next action

For each study, save the research question, inputs, assumptions, configuration version, evaluation method, results, failures and resulting decision. Record scripts and datasets alongside the numerical evidence. Preserve original baselines and physical trial records.

After the repository documentation review is complete, begin **P0.1 Step 1**: reproduce the C4-1 and C12 E2 baselines and identify their limiting cable pairs and poses. The first physical measurements needed for Step 2 are the actual mounting intervals for C4-1 A2 on Rail 6 and C12 A6 on Rail 10, plus the connector envelopes relevant to C12 B1–B5.

- [Current research state](../../CURRENT_STATE2.md)
- [Research roadmap](../Roadmap.md)
- [E2 research summary](../../06_Research_Log/2026-11/B5_4_E2_Phase_Research_Summary.md)
- [MATLAB simulations](../../03_Simulation/MATLAB/)
- [Research logs](../../06_Research_Log/)
