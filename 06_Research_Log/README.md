# Research Log

Use this directory to trace a research decision back to the calculation, figure or measurement that supports it. Keep the dated plan in Project Management and record actual work here as evidence becomes available.

## Find a record

| What do you need? | Where to look |
|---|---|
| Completed November studies | [November 2026 research logs](2026-11/) |
| E2 reference results for the four retained configurations | [E2 attachment optimisation research summary](2026-11/B5_4_E2_Phase_Research_Summary.md) |
| Scripts and numerical datasets | [MATLAB simulations](../03_Simulation/MATLAB/) |
| Current candidate roles and unresolved questions | [Current research state](../CURRENT_STATE2.md) |
| Planned studies and prototype decisions | [Prototype V1 build and validation plan](../08_Project_Management/November/Prototype_V1_Build_and_Validation_Plan.md) |

## Weekly research log

Use one dated plan and one corresponding weekly log as the entry points for a reporting period. Link an existing technical log when it already contains the full method and results. Add a new weekly entry when a run, measurement, failure investigation or design decision advances the research question.

The following Markdown can be copied into the weekly log:

### YYYY-MM-DD — Research question or test

| Field | Entry |
|---|---|
| Question | What uncertainty affects the next design decision? |
| Test and conditions | Which configuration, variant or specimen was tested? Record the inputs, units and conditions needed to repeat the test. |
| Evidence | Link the script and saved output, or the measurement record and calibration reference. Identify the relevant version or run. |
| Result | Give the observed value or failure, its units, and the comparison baseline. |
| Interpretation | What does the evidence establish? Which assumption or limitation still matters? |
| Decision and next action | What will be retained, changed, tested again or measured next? |

At the end of the reporting period, summarise the decision reached, its supporting evidence and the most important open question. Update the [current research state](../CURRENT_STATE2.md) when the findings change a candidate, an operating limit or the next task.

## What to record for different studies

| Study | Details needed to interpret the result |
|---|---|
| Baseline reproduction | Parent design, source dataset, evaluator settings, previously reported value, newly obtained value and any discrepancy. |
| Configuration optimisation | Variables allowed to move, fixed variables, physical bounds, search budget and accepted coordinates. Compare joint adjustment with the best installable single-group variant under comparable conditions. |
| Workspace analysis | Position and orientation domain, limiting pose and cable IDs, failure mechanism, and the coverage actually checked. Identify sampled poses, checked paths, continuously verified cells and unresolved regions. |
| Bench experiment | As-built geometry, instrument and reference, calibration, repeated trials and observed error or disturbance. For a change to the rig, keep enough of the original setup and data to repeat the comparison. |

## Example — Reproducing an E2 result

The E2 summary reports a minimum cable centreline distance of **39.0163 mm for C4-1 E2 M over 539 development poses**. Enter that number as the **historical reference** when preparing a reproduction test.

After running the evaluator, record the newly obtained value, limiting cable pair, pose index and saved output. If the difference exceeds the precision of the published value, document the discrepancy and check the geometry version, pairing and evaluator settings. The physical clearance assessment also requires cable diameter and installation allowance.

Preserve historical logs and original datasets. When a later result corrects an earlier interpretation, identify the earlier record and the evidence that changed the decision.
