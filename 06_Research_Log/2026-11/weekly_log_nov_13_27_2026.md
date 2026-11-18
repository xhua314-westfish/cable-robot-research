# Research Log — 13–27 November 2026

**Project:** Cable-based sensing for a passive balloon  
**Reporting period:** 13–27 November 2026  
**Latest entry:** 18 November 2026  
**Companion plan:** [Research plan for 13–27 November](../../08_Project_Management/November/weekly_plan_nov_13_27_2026.md)

## 18 November — Scope of the pre-prototype design study

### Question

Before choosing the first six-cable layout to build, what remains to be established about C4-1 E2 M and C12 E2 M?

### Evidence reviewed

E1 refined the anchors. E2 subsequently optimised the spherical attachments while holding each parent’s anchors and pairing fixed. The archived plan records full E4 joint optimisation as paused. Moving an anchor to accommodate a real guide therefore raises an open question: are the existing attachment coordinates still suitable for the modified geometry?

The E2 results also identify two different installation issues. C4-1 has an A2 rail-end mounting concern on Rail 6. C12 has an A6 mounting concern on Rail 10 and a separate B1–B5 connector-spacing concern on the sphere. Moving A6 can change cable routing, but it leaves the distance between B1 and B5 unchanged.

Sources: [E2 research summary](B5_4_E2_Phase_Research_Summary.md) · [Archived optimisation plan and E4 scope](../../08_Project_Management/November/B5_3_B5_6_Active_Research_Plan_Six_Cable_Sensing.md)

### Decisions recorded

| Decision | Reason |
|---|---|
| Retain C4-1 as provisional primary and C12 as provisional backup. | Both have usable E2 baselines. Their outstanding mounting and workspace questions can be tested under common conditions. |
| Compare original E2, anchor-only, attachment-only and joint variants within each family. | The comparison will show the cost of correcting the mounting issue and any additional benefit from adjusting the attachments. Keep rail assignments and cable pairing fixed. |
| Allow the joint search to revisit anchor coordinates after an attachment change. | This tests the coupling that the earlier sequential E1–E2 workflow left open. |
| Evaluate retained variants across a declared six-dimensional pose domain before provisional selection. | The balloon moves passively. The experiment needs an identifiable, connected operating region around the starting pose, together with evidence of its limits. |
| Use the installed guide geometry to define allowable anchor shifts. | The effective exit point may be offset from the bracket mounting point. A shift inferred from the frame drawing alone may overstate or understate the required correction. |

These decisions are reflected in the [current research state](../../CURRENT_STATE2.md), [roadmap](../../08_Project_Management/Roadmap.md) and [Prototype V1 plan](../../08_Project_Management/November/Prototype_V1_Build_and_Validation_Plan.md).

### Baseline handoff for P0.1

The reported distances below are minima between ideal cable centrelines over the 539 E2 development poses. The fresh-run columns are reserved for results obtained from the saved parent geometries.

| Configuration | E2 geometry passes | E2 minimum centreline distance | Fresh-run passes and distance | Limiting cable pair and pose | Saved output |
|---|---:|---:|---|---|---|
| C4-1 E2 M | 539/539 | 39.0163 mm | Pending | Pending | Pending |
| C12 E2 M | 539/539 | 13.5666 mm | Pending | Pending | Pending |

**Next technical action after the documentation review:** Load the two unchanged E2 parents and reproduce this table using their saved cable correspondence. Record the evaluator, dataset, settings and limiting pose coordinates. Also capture the minimum departure angle and worst scaled minimum singular value, since their limiting poses may differ from the closest cable-pair pose.

### Next physical inputs

| Input | What to record | Decision enabled |
|---|---|---|
| C4-1 A2 on Rail 6 | Corner fitting, fastener access, bracket footprint, effective exit offset and allowable interval in mm and rail coordinates | Whether A2 needs to move and how far |
| C12 A6 on Rail 10 | The same quantities under the same mounting convention | Whether C12 provides an installable alternative |
| C12 B1–B5 | Attachment-centre spacing, connector dimensions and orientation, plus cable-segment clearance as a separate quantity | Whether the problem calls for an attachment change, a routing change or no correction |

## Subsequent entries

Append a dated entry when a run, measurement or design review produces evidence. Record the question, input version, result, limiting case, saved evidence and decision.

For the 27 November review, summarise the incremental benefit of joint refinement, the connected operating region supported for each retained candidate, and any remaining condition that prevents provisional selection.
