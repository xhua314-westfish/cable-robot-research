# Cable-Robot-Based Sensing for a Passive Deformable Balloon

**Master’s research project · Primary tool: MATLAB**  
**Last reviewed:** 2026-11-18

This project investigates whether six cable-length measurements can reconstruct the position and orientation of a passively moving balloon-like object in a stomach-inspired test frame. Each cable runs from a guide on the frame to a known attachment on the object. As the object translates and rotates, the six measured lengths change. The geometry of these connections determines which motions the system can distinguish and how strongly length errors affect the estimated pose.

The first experimental milestone is six-degree-of-freedom pose measurement on a rigid reference body. An air-filled balloon pilot will then examine how cable tension, attachment movement and surface deformation affect the measurements.

## Current research decision

**Which installable six-cable configuration should be built first, and over what range of positions and orientations can it provide reliable measurements?**

Earlier studies refined the rail anchors in E1 and then optimised spherical attachment points with the parent anchors and pairing fixed in E2. Four final E2 candidates passed nominal geometry checks at all 539 development poses. These results support the present shortlist. Continuous workspace coverage and physical measurement accuracy remain open.

| Working candidate | Why it needs further study |
|---|---|
| **C4-1 E2 M — provisional primary** | Cable 2 anchor A2 lies at a frame vertex on Rail 6. Determine where the guide can be mounted and how moving its effective exit point affects sensing and clearance. |
| **C12 E2 M — provisional backup** | Cable 6 anchor A6 is near the end of Rail 10. Check the available mounting space and the separate connector-spacing concern at spherical attachments B1 and B5. |

C8-16 E2 M and C2-2 Repaired M remain available as reference configurations. The numerical results and documented limitations are recorded in the [E2 research summary](06_Research_Log/2026-11/B5_4_E2_Phase_Research_Summary.md).

## Route to the first experiment

| Stage | Question and decision |
|---|---|
| **P0.1 — Targeted configuration refinement** | For C4-1 and C12, compare the original E2 layout, anchor-only adjustment, attachment-only adjustment and joint anchor–attachment adjustment. Keep rail assignments and pairing fixed. Determine whether joint refinement offers a practical gain once the guides and connectors can be installed. |
| **P0.2 — Workspace feasibility** | Evaluate the retained variants across the same six-dimensional position and orientation domain. Identify connected regions with adequate routing and sensing, limiting poses, and areas where evidence is still incomplete. |
| **P0.3–P0.5 — Provisional selection and funding** | Select the provisional V1 geometry and first-test region. Prepare single-channel CAD, a preliminary bill of materials and the supervisor funding presentation. |
| **P1–P3 — Single-channel validation** | Measure displacement error, reversal behaviour, reliable take-up tension and balloon disturbance. Use the results to select the guide and drive and finalise the six-channel mechanical design. |
| **P4–P6 — Prototype experiments** | Assemble and calibrate the six-channel rig, validate rigid-body pose against an independent reference, and then assess attachments and deformation on an inflated balloon. |

**Next technical action after the documentation review:** reproduce the C4-1 and C12 E2 baselines and identify their limiting cable pairs and poses. Use the actual corner fittings, guide footprints and connector dimensions to define the allowable changes before starting the targeted search.

## Engineering baseline

| Quantity | Working definition |
|---|---|
| Computational frame | 280 × 300 × 320 mm, with X = length, Y = width and Z = height |
| Initial rigid surrogate | Sphere of radius 50.8266 mm, corresponding to a nominal volume of 550 mL |
| Frame anchors | Six effective cable exit points associated with twelve frame-edge rails |
| Body attachments | Six known points expressed in the rigid-body coordinate system |
| Estimated state | Three position and three orientation coordinates |
| Measurement | Six cable lengths or calibrated displacements |
| Intended operation | Passive object motion with low positive cable tension; cable-induced disturbance is an experimental quantity |
| Numerical noise assumption | Cable-length standard deviation of 0.100 mm; hardware characterisation is pending |

The frame dimensions define the engineering model. The usable sensing workspace depends on configuration, orientation, physical clearances and measurement quality. A parallel seven-/eight-cable study will examine whether additional measurements justify the associated routing and hardware complexity.

## Start here

| If you need to know… | Read |
|---|---|
| What is complete, what is pending, and which candidates are active? | [Current research state](CURRENT_STATE2.md) |
| How do the configuration studies lead to prototype experiments? | [Research roadmap](08_Project_Management/Roadmap.md) |
| What are the inputs, steps, deliverables and decision criteria for the next task? | [Prototype V1 build and validation plan](08_Project_Management/November/Prototype_V1_Build_and_Validation_Plan.md) |
| Which conventions govern modelling, verification and research records? | [Research and collaboration rules](AGENTS2.md) |
| Where are the calculations and completed findings? | [MATLAB simulations](03_Simulation/MATLAB/) and [research logs](06_Research_Log/) |
| How are weekly research presentations prepared? | [Weekly presentation template](08_Project_Management/Weekly_Presentation_Template.md) |

## Repository structure

| Directory | Contents |
|---|---|
| [01_Learning](01_Learning/) | Foundational methods and learning notes |
| [02_Paper_Reading](02_Paper_Reading/) | Literature reviews and research evidence |
| [03_Simulation](03_Simulation/) | MATLAB models, evaluation scripts and simulation data |
| [04_Code_Exercises](04_Code_Exercises/) | Coding and mathematical exercises |
| [05_My_Research](05_My_Research/) | Technical research models and design studies |
| [06_Research_Log](06_Research_Log/) | Completed studies, numerical results and decisions |
| [07_Resources](07_Resources/) | Supporting research resources |
| [08_Project_Management](08_Project_Management/) | Roadmap, active plans and presentation materials |
