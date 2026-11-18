# Current Research State — Six-Cable Passive Balloon Sensing

**Last reviewed:** 2026-11-18  
**Current stage:** Pre-prototype configuration refinement and workspace feasibility analysis  
**Primary tool:** MATLAB  
**Working candidates:** C4-1 E2 M is the provisional primary candidate. C12 E2 M is the provisional backup. Final V1 selection is pending.

## 1. Current research question

After accounting for physical guide and connector dimensions, which six-cable configuration provides an installable geometry and a sufficiently sensitive, interference-free operating region for the first experiments?

Two design questions precede V1 selection:

1. For C4-1 and C12, does adjusting rail-anchor and spherical attachment positions together offer a useful improvement over adjusting either group alone?
2. Across the intended six-dimensional pose domain, where does each retained configuration satisfy the geometric and sensing requirements, including between sampled poses?

## 2. Verified progress

| Stage | Evidence | Interpretation |
|---|---|---|
| B1–B5.3 | Established the rigid-body model, cable-length Jacobian, 189-pose historical benchmark, interference checks and twelve-rail configuration families. | Provides the common geometry and evaluation methods. |
| B5.4 E1a/E1b | Completed anchor optimisation for the retained design branches. | Provides the parent anchor layouts used in E2. |
| B5.4 E2 | Optimised six spherical attachment positions while holding the parent anchors and pairing fixed. | Establishes the benefit of attachment refinement conditional on the chosen anchors. |
| E2 verification | All four final E2 candidates passed nominal geometry checks at 539/539 development poses. | Provides a reproducible sampled baseline. Physical envelopes and between-pose behaviour require further evaluation. |
| E3 engineering audit | The audit script loads saved configurations and evaluates rail-end margins, attachment spacing, departure angles and all 15 cable pairs. | Identifies mounting and routing issues for targeted refinement. |
| Joint optimisation | The archived plan records full E4 joint optimisation as unperformed and paused. | A targeted joint anchor–attachment study for C4-1 and C12 is proposed below. Its outcome is open. |

The 539 poses have been used for development and repair. Reserve separate poses or pose cells for validation after candidate selection.

## 3. Candidate baselines

The reported distances below are nominal minimum **cable centreline distances** over the 539 development poses. Physical clearance also depends on cable diameter, guide geometry, connector envelopes and installation tolerances.

| Candidate | Recorded E2 evidence | Current priority |
|---|---|---|
| **C4-1 E2 M** | 539/539 nominal geometry passes, 39.0163 mm minimum centreline distance and 24/24 prescribed one-at-a-time attachment perturbations passed. | Evaluate the installable range of Cable 2 anchor A2 on Rail 6 near the frame vertex. Determine whether moving A2 warrants compensating attachment changes. |
| **C12 E2 M** | 539/539 nominal geometry passes, 13.5666 mm minimum centreline distance and 24/24 prescribed one-at-a-time attachment perturbations passed. | Evaluate Cable 6 anchor A6 on Rail 10 near the rail end. Check B1–B5 connector spacing separately. Moving A6 alone leaves the B1–B5 attachment distance unchanged. |
| C8-16 E2 M | Passed nominal geometry and the prescribed attachment perturbations, with a smaller outward-angle margin. | Retain as a reserve candidate. |
| C2-2 Repaired M | Passed nominal geometry after repair. One prescribed C6 attachment perturbation still failed. | Retain as a sensing-performance comparison. |

## 4. Next design study — Targeted joint anchor–attachment refinement

**Status:** Proposed for the two retained candidates. No joint result or performance gain has been established.

### 4.1 Define the installable geometry

Use the existing extrusion, corner hardware and proposed guide to establish the allowable rail intervals. Define each anchor by its effective cable exit point. Record measured dimensions and label provisional connector or guide dimensions explicitly.

Preserve the E2 coordinates, rail IDs, attachment IDs and cable pairing for each parent. Keep rail assignments and pairing fixed during this study so that the effect of coordinate refinement can be identified.

### 4.2 Compare four variants within each parent configuration

| Variant | Rail-anchor coordinates | Spherical attachment coordinates | Question answered |
|---|---|---|---|
| **E2 baseline** | Original | Original | What performance and installation limitations do we start with? |
| **Anchor only** | Search selected installable rail intervals | Original | How much does moving the critical anchor solve or cost? |
| **Attachment only** | Original | Search declared surface neighbourhoods | What improvement is available at the original anchors? Reuse the recorded E2 comparison where its bounds and evaluation protocol match. |
| **Joint** | Search the same selected rail intervals | Search the same selected surface neighbourhoods | Can coordinated changes preserve mounting clearance and improve sensing or routing beyond the single-group alternatives? |

Start with C4-1 A2 and C12 A6 as the anchor variables. Select the attachment variables from the measured connector constraints or the limiting cable and pose identified in the audit. Record the reason for each choice. An attachment-only variant with an unmountable original anchor remains a comparison case and must be labelled accordingly.

In the joint search, score each candidate using its updated anchors **and** attachments together. The optimiser must be able to revisit an anchor after an attachment changes. A single anchor pass followed by an attachment pass with the anchors permanently frozen reproduces the earlier sequential workflow.

### 4.3 Retain candidates on engineering evidence

Apply common development poses, Jacobian scaling, objective definitions and physical constraints. Declare search bounds, algorithm, seed where relevant, and evaluation budget. Record:

- Rail-end mounting clearance and connector clearance.
- Minimum cable separation, minimum departure angle, and their limiting cables and poses.
- Worst scaled minimum singular value and predicted pose uncertainty under the stated length-noise model.
- Sensitivity to installation perturbations and the practical cost of relocating hardware.

Retain a joint variant only if its improvement justifies the added adjustment. Where sensing and clearance favour different variants, carry the relevant alternatives into workspace analysis. Full E4 search across rail assignments and cable pairings remains a separate, paused task.

## 5. Workspace feasibility before V1 selection

Define a common pose domain with translation bounds, orientation bounds and rotation convention. The 280 × 300 × 320 mm frame and 550 mL equivalent rigid sphere define the engineering geometry. The usable sensing workspace must be determined for each configuration.

1. **Screen the domain.** Check containment, cable departure, all 15 cable pairs, connector and frame interference, Jacobian rank and sensing quality.
2. **Inspect between samples.** Refine regions near clearance limits, orientation extremes and poor sensing. Apply conservative continuous bounds where available and identify the criteria those bounds cover.
3. **Map the operating region.** Distinguish positions feasible at some orientations from positions feasible throughout the required orientation range. Identify the connected region reachable from the intended starting pose.
4. **Report evidence strength.** Mark verified regions, sampled regions, known failures and unresolved regions. Preserve limiting pose coordinates, orientation, cable IDs and failure reasons.
5. **Select V1.** Compare C4-1 and C12 under identical conditions, including the simplest acceptable variant from each family. Record the selected geometry, supported operating region, remaining uncertainties and reason for retaining the backup.

The assumed 0.100 mm cable-length standard deviation supports simulation comparisons. Hardware accuracy and allowable balloon disturbance remain experimental quantities.

## 6. Transition to experiments

| Step | Decision or output |
|---|---|
| Physical dimension check | Measure the guide, corner and connector envelopes needed to constrain the numerical design. This can proceed during refinement. |
| Targeted refinement and workspace comparison | Select the V1 geometry and initial operating region. |
| Single-cable module | Measure displacement error, reversal behaviour, reliable take-up tension and balloon-side disturbance. Use the data to select motor and guide hardware. |
| Six-channel rigid-body validation | Calibrate the installed geometry and length offsets. Measure pose errors against an independent reference. |
| Inflated-balloon experiments | Quantify attachment movement, deformation and motion disturbance. Use measured failure mechanisms to improve the rig and sensing model. |

**Immediate next action:** Establish the installable intervals for C4-1 A2 and C12 A6, extract the limiting attachment and cable pairs from the audit, and define the four comparison variants before starting the targeted search.

## Project records

- [Research and collaboration rules](AGENTS2.md)
- [Project roadmap](08_Project_Management/Roadmap.md)
- [Prototype V1 build and validation plan](08_Project_Management/November/Prototype_V1_Build_and_Validation_Plan.md)
- [E2 attachment optimisation research summary](06_Research_Log/2026-11/B5_4_E2_Phase_Research_Summary.md)
- [Archived optimisation plan and E4 scope](08_Project_Management/November/B5_3_B5_6_Active_Research_Plan_Six_Cable_Sensing.md)
