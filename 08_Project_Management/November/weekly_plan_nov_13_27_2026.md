# Research Plan — 13–27 November 2026

**Project:** Cable-based sensing for a passive balloon  
**Revised:** Wednesday, 18 November 2026  
**Review date:** Friday, 27 November 2026  
**Active candidates:** C4-1 E2 M and C12 E2 M  
**Time budget from 18 November:** Up to 5 hours per weekday, 40 hours total. The weekend of 21–22 November is optional buffer time.

## 1. Objective for 27 November

Determine whether targeted joint refinement of rail-anchor and spherical attachment positions improves either candidate enough to justify using the revised geometry for Prototype V1.

The study has two linked parts:

1. **P0.1 — Configuration refinement.** Compare the original E2 design, anchor-only adjustment, attachment-only adjustment and joint adjustment within each family. Identify which changes improve installation, cable routing or sensing, and at what cost.
2. **P0.2 — Workspace feasibility.** Compare the retained variants across a common six-dimensional pose domain. Determine where an installable configuration can be reached from the starting pose while meeting the stated geometric and sensing criteria.

**Target decision:** Select a provisional primary configuration, a backup and a supported first-test region if the available evidence permits. If a critical measurement or workspace check remains open, identify the exact condition preventing selection and the smallest follow-up task that would resolve it.

## 2. Starting evidence

| Item | Recorded result | Use in this plan |
|---|---|---|
| Optimisation history | E1 refined anchors. E2 optimised spherical attachments with parent anchors and pairing fixed. | Preserve the E2 parents and test the added value of joint adjustment. |
| C4-1 E2 M | 539/539 nominal development-pose geometry passes. Minimum cable centreline distance: 39.0163 mm. | Reproduce the baseline. Check the installation of Cable 2 anchor A2 on Rail 6 at the frame vertex. |
| C12 E2 M | 539/539 nominal development-pose geometry passes. Minimum cable centreline distance: 13.5666 mm. | Reproduce the baseline. Check Cable 6 anchor A6 on Rail 10 and the separate B1–B5 connector-spacing issue. |
| Existing tools | The E3 audit evaluates 15 cable pairs over 539 development poses. M1.1–M1.4 examined frame mounting and cable-direction envelopes. | Reuse existing code, saved coordinates and mechanical analyses. |
| Hardware inputs | Laboratory extrusion and fittings are available. Guide footprints, connector envelopes and effective exit locations depend on the actual parts. | Track each critical dimension as measured, drawing-based, provisional or unknown. |

The 13–17 November period is covered by the existing research records. The schedule below begins with the revision on 18 November. Mark work complete only when its output exists.

## 3. Schedule

### Wednesday, 18 November — Reproduce the unchanged parents

**Question:** Are both families being evaluated with the correct coordinates, pairing and pose set?

- Finish the agreed documentation review before starting new optimisation runs.
- Load the saved C4-1 and C12 E2 designs. Verify the rail IDs, rail parameters, six anchor coordinates and six already-paired attachment rows.
- Evaluate the unchanged parents on the same 539 development poses. Reproduce the nominal pass counts and reported minimum cable distances.
- Record the limiting cable pair and pose, minimum departure angle, worst scaled minimum singular value and maximum scaled condition number. Different metrics may have different limiting poses.

**Output:** A two-row baseline table with the source dataset, script and evaluation settings. Investigate discrepancies beyond published rounding before ranking new variants.

### Thursday, 19 November — Establish physical design bounds

**Question:** How far can each critical anchor move, and which attachments have a reason to move?

- Measure the relevant extrusion, corner fitting, fastener access and guide footprint for C4-1 A2 and C12 A6. Distinguish the bracket location from the effective cable exit point.
- Express each allowable interval in millimetres and in the rail parameter used by MATLAB. State the origin and positive direction.
- For C12, assess B1–B5 connector fit using connector dimensions and orientation. Separately extract C1–C5 cable-segment clearance. Moving A6 cannot change the fixed B1–B5 attachment spacing.
- Select attachment variables from an identified connector conflict, limiting cable or sensing trade-off. Define their spherical search neighbourhoods.

**Output:** A constraint table with candidate, variable ID, physical bounds, units, evidence source and uncertainty. If a part is unavailable, specify a provisional range and the measurement needed to replace it.

### Friday, 20 November — Freeze the comparison protocol and run the anchor-only scan

**Question:** What happens to each family when the critical anchor is moved far enough to fit?

| Variant | Rail-anchor coordinates | Spherical attachment coordinates |
|---|---|---|
| Original E2 | Original | Original |
| Anchor only | Search the selected rail interval | Original |
| Attachment only | Original | Search the selected surface neighbourhoods |
| Joint | Search the same rail interval | Search the same surface neighbourhoods |

- Keep rail assignments, cable pairing, frame and sphere radius fixed. Record physical constraints, objective, search budget, stopping rule and Jacobian scaling before comparing candidates.
- Run the anchor-only scan for **both** families. Include the original position as a reference even if it fails the mounting constraint.
- Plot inward anchor shift against installation margin, minimum cable separation and worst scaled sensing sensitivity. Identify any region where a small additional shift causes a large performance loss.
- Draft the common workspace domain and rotation convention before inspecting workspace maps.

**Output:** Matched anchor-only results and a documented protocol for the remaining variants. Where dimensions are assumed, label the resulting mounting assessment provisional.

### Saturday–Sunday, 21–22 November — Optional buffer

Use this period for delayed measurements, resolving baseline discrepancies or completing an already-defined run. The weekday plan does not depend on weekend work.

### Monday, 23 November — Evaluate attachment-only and joint variants

**Question:** After moving an anchor, can a change in attachment position recover lost performance or improve the design further?

- Run the attachment-only comparison for each family. Reuse E2 results only where the variable bounds, objective, constraints and evaluation protocol match this study.
- Run the targeted joint search for C4-1 and C12. Score the updated anchor and attachment coordinates together. If using alternating updates, allow the anchor to be revisited after the attachment changes.
- Apply the same constraints and metrics used for the single-group scans. Record evaluation counts, stopping reasons and failed candidates.
- Save actual coordinate changes and cable IDs, so any gain can be traced to a physical design modification.

**Output:** Results for all four variants in both families, or a documented run status and remaining computation. An optimum at a provisional installation bound should be flagged for measurement.

### Tuesday, 24 November — Decide which variants advance

**Question:** Does joint refinement offer enough benefit to justify changing both parts of the geometry?

- Build one comparison table with four rows per family. Include mountability, connector fit, minimum cable clearance, minimum departure angle, worst scaled sensitivity and limiting pose.
- Compare the joint variant directly with the **best installable single-group variant**. Record the incremental benefit and any loss in clearance, sensing or mounting simplicity.
- For shortlisted variants, repeat the relevant installation perturbations and nonlinear pose-estimation tests under matched noise assumptions. Record convergence failures as well as errors.
- Freeze the retained geometry versions before P0.2. Where two variants have a meaningful trade-off, carry both forward and record why.

**Output:** A shortlist with exact anchor coordinates, paired attachments, rail parameters and selection reasons. A simpler variant may advance if joint adjustment offers little practical gain.

### Wednesday, 25 November — Map the common six-dimensional pose domain

**Question:** Where do the retained variants satisfy geometry and sensing requirements across position and orientation?

- Finalise translation bounds, orientation bounds, rotation convention and starting pose. Use the same domain and evaluation rules for all retained variants.
- Screen containment, all 15 cable pairs, outward departure, relevant frame and guide obstacles, connector envelopes, Jacobian rank and sensing sensitivity. Extract cable-length range and travel by channel.
- For each failed or limiting pose, retain its position, orientation, cable or hardware feature, and failure mechanism.
- Produce position maps that distinguish feasibility at **some tested orientations** from feasibility at **all tested orientations**. State the orientation coverage explicitly.

**Output:** Comparable workspace maps, worst-case tables and a list of cells or transitions requiring refinement. Identify criteria that still rely on provisional hardware dimensions.

### Thursday, 26 November — Examine continuity, connectivity and independent evidence

**Question:** Can the object move from the starting pose into the apparent usable region without crossing an unresolved or failed transition?

- Refine intervals and pose cells near small clearances, steep sensitivity changes and feasibility boundaries. Prioritise the region connected to the intended starting pose.
- Apply conservative continuous bounds where available. For each bound, record the criterion and geometry it covers. A cable-pair distance bound alone does not certify connector clearance or sensing quality.
- Check transitions before reporting connectivity. Label regions as continuously verified for specified criteria, sampled, failed or unresolved.
- Evaluate frozen candidates on independently generated poses or cells using a documented sampling rule. If a failure leads to redesign, reclassify that case as development evidence and reserve fresh validation data.

**Output:** A connected-region assessment, limiting poses, independent results and a clear statement of which continuous claims are supported.

### Friday, 27 November — Configuration review and next decision

**Question:** Is one geometry sufficiently supported to enter single-channel CAD and experimental planning?

Compare the retained C4-1 and C12 variants using:

1. Mounting feasibility and confidence in the effective exit coordinates.
2. Connector fit, limiting cable clearance and outward departure.
3. Connected usable region and required orientation coverage.
4. Worst-direction sensing quality, pose-estimation results and installation robustness.
5. Mechanical complexity, required cable travel and unresolved assumptions.

**If evidence supports selection:** record the provisional primary, backup, frozen coordinate versions, first-test region and conditions that would reopen the decision. Carry channel travel, guide-angle range and mounting dimensions into P0.4 single-channel CAD and the preliminary BOM.

**If selection remains conditional:** record the exact obstacle, affected candidate and region, and the next measurement or calculation. If neither candidate covers the full intended domain, assess whether a smaller connected region still supports a meaningful first experiment.

**Output:** A configuration decision record, a workspace figure suitable for supervisor review, and a weekly log separating completed results from pending tasks.

## 4. Minimum evidence to retain

| Record | Required contents |
|---|---|
| Baseline reproduction | Dataset and script names, settings, geometry pass counts, numerical metrics and limiting poses |
| Physical constraints | Measured or assumed dimensions, rail intervals, attachment bounds and remaining unknowns |
| Four-variant comparison | Common evaluation protocol, design changes, results, failures and incremental value of joint refinement |
| Workspace assessment | Declared domain, sampling and refinement method, connected region, limiting cases and evidence coverage |
| 27 November decision | Selected or conditional configurations, supported operating limits and the next actionable task |

Use the existing core and 539-pose datasets for historical and development comparisons. Report assumed 0.100 mm cable-length noise as a simulation input. Actual encoder noise, guide friction, low-tension tracking and balloon disturbance remain bench-test quantities.

## 5. Project references

- [Current research state](../../CURRENT_STATE2.md)
- [Research roadmap](../Roadmap.md)
- [Prototype V1 build and validation plan](Prototype_V1_Build_and_Validation_Plan.md)
- [E2 attachment optimisation research summary](../../06_Research_Log/2026-11/B5_4_E2_Phase_Research_Summary.md)
- [MATLAB simulations](../../03_Simulation/MATLAB/)
