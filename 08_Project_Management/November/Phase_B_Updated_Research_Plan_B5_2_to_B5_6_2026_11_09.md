# Phase B Updated Research Plan — B5.2 to B5.6

**Planned / updated:** 2026-11-09  
**Workstream:** A — Six-Cable Prototype and Experiments  
**Starting point:** B5.1 completed through geometry-constrained pairing and best-configuration visualisation  
**Status:** Proposed detailed plan; none of B5.2–B5.6 is yet verified by new MATLAB results  
**Estimated effort:** ~13–17 research days at ~4–5 hours/day; **research days, not fixed calendar deadlines**

---

## 1. Objective and scope

**Research question:** Which six-cable geometry can provide an adequate interference-free Core Workspace with sufficiently robust 6-DOF passive-balloon sensing, and can that geometry be implemented in an adjustable prototype?

**Do not** optimize the aesthetic appearance of the cables as a substitute for geometric feasibility or sensing. Use structured layouts to generate interpretable candidates, then test them.

**Fixed comparisons:**

- Baselines: Original B and Modified B′.
- Existing reference-pose candidates: F1 Best, F2 Best, F3 Best.
- Core: 27 translation samples (−20/0/+20 mm on each axis) × 7 single-axis orientation cases (identity; roll/pitch/yaw ±5°) = 189 poses.
- Wider benchmark: 27 translation samples (−50/0/+50 mm) × seven identity/single-axis ±10° orientation cases = 189 poses.
- Sphere radius: 50.8266 mm; boundary: 280 × 300 × 320 mm.
- B4 scaling and B3 finite-segment distance conventions must remain fixed across all candidates.

**Validity caveats:** These are finite pose samples and simplified rigid-sphere/ideal cable models; they are not clinical motion limits or continuous-workspace guarantees.

---

## 2. High-level stage list

| Stage | Status | Main question | Required exit evidence | Decision enabled |
|---|---|---|---|---|
| B5.2 — Multi-Pose Geometric Screening | **Next** | Where and why do the five current layouts fail? | Core pass/fail masks, per-cable/pair diagnosis, worst pose, benchmark | Which designs/constraints need redesign |
| B5.3 — Literature-Informed Redesign | Pending | Can structured layouts give better candidate starts? | Literature-to-design matrix and multiple S1/S2/S3 instances | Structured search families to optimize |
| B5.4 — Joint Configuration Optimisation | Pending | Can \(A_i,r_i,\pi\) be optimized for geometry and sensing jointly? | Reproducible constrained-search results; multi-pose sensing, geometry and Pareto table | Choose 2–3 strong candidates |
| B5.5 — Independent Sensing Validation | Pending | Can unknown poses actually be reconstructed from lengths? | Held-out pose estimation, error/noise results and failure cases | Determine sensing readiness |
| B5.6 — Prototype V1.0 Decision | Pending | Can a preferred configuration be built and tested safely at low tension? | Feasibility/engineering checklist, adjustable prototype choice | Transition to experimental prototype and existing tension/hardware tasks |

**Naming:** B5.3–B5.6 are the proposed detailed work packages for the next iteration. They refine the existing repository roadmap and do **not** supersede separate B6 tension, sensing hardware, seven/eight-cable, or deformable-balloon workstreams.

---

## 3. B5.2 — Multi-Pose Geometric Screening (3 research days)

### Lesson 1 — Five-configuration Core screening

**Why:** Reference-pose geometry passing does not establish that cable routing remains feasible under balloon translation and rotation.

**Theory:** For each pose \(q=(P,R)\), calculate \(B_i=P+Rr_i\), \(D_i=A_i-B_i\); evaluate cable–sphere outward condition and 15 pairwise 3-D finite-segment distances. Maintain the validated sign conventions and numeric tolerances in the B3/B5.1 code.

**Implementation:**

1. Load B and reconstruct B′ using the confirmed row-5/row-6 attachment swap.
2. Load the F1/F2/F3 **best-pairing** structures from `B5_1_geometry_constrained_pairing.mat`.
3. Generate the same 189 Core poses **once** and use them unchanged for all five configurations.
4. For each pose, record `sphere_safe`, `cable_safe`, `geometry_safe`, per-cable outward tests, and all 15 pairwise segment distances.
5. Check that the shared reference pose agrees with B5.1's reference-pose results; store run settings and configuration IDs.

**Output:** Five-row Core comparison with `SpherePass`, `CablePass`, `GeometryPass`, minimum ideal segment distance, and the pose-wise masks; `.mat` results.

**Not included:** Jacobian optimization, finite-thickness clearance certification, or continuous-workspace claims.

### Lesson 2 — Failure diagnosis

**Why:** Pass counts alone cannot say **which anchor, attachment, pairing, or pose** causes the problem.

**Method:**

- Divide failed poses into sphere-only, cable-only, and both.
- Count outward failures by Cable 1–6.
- Count contacts and minimum distances by all 15 cable pairs.
- Report the first and most critical failure poses with position and roll/pitch/yaw.
- Separate translation effects from single-axis orientation effects.
- Check both **minimum distance anywhere** and minimum distance over geometrically feasible poses; distinguish numerical contact from future physical clearance.

**Output:** Failure diagnosis table, cable-pair heatmap, worst-pose selection and explanation of dominant failure mode per candidate.

### Lesson 3 — Visualisation and original benchmark

**Why:** The five configurations must be compared on identical datasets; plots should make failure modes interpretable rather than merely visually attractive.

**Method and outputs:**

1. Core pass-count comparison chart for B/B′/F1/F2/F3.
2. Cable–cable contact heatmap (pair × configuration or pose).
3. 3-D renderings at worst poses with **A1–A6**, **B1–B6**, **C1–C6**, and actual pairing information.
4. Original wider Benchmark (±50 mm, ±10°) run with the **same geometry checks**.
5. Distinguish Core, wider Benchmark, reference pose, and physical design claims in all outputs.

**B5.2 exit decision:** Identify which **specific candidate instances** deserve further optimization and what most often fails. **Do not infer that an entire F1/F2/F3 family is poor from only one instance.** No configuration is declared final here.

---

## 4. B5.3 — Literature-Informed Redesign (4 research days)

### Lesson 1 — Evidence matrix / actual configurations

**Why:** The current random/greedy attachment selection produced geometries that are hard to justify as practical final layouts.

For each paper, extract **only what the original source actually demonstrates**: base/attachment geometry, pairing conventions, adjustable variables, constraints/objectives, algorithm, displayed results, and limits of applicability. Record figure/table/page identifiers **after checking the article**. Avoid stating an exact final pairing without confirming it in the full paper.

**Primary reading set (verified DOIs):**

1. Cheng & Lau 2023 — https://doi.org/10.1109/TRO.2023.3288838 (attachment optimization with workspace constraints).
2. Cheng & Lau 2022 — https://doi.org/10.1016/j.mechmachtheory.2022.104782 (interference-free workspace).
3. Abbasnejad & Tale-Masouleh 2021 — https://doi.org/10.1177/0954406220976166 (wrench-closure and PSO-based reconfiguration).
4. Khoshbin et al. 2022 — https://doi.org/10.1017/S0263574722000996 (explicit eight-cable base/platform geometry: Fig. 1, Tables I–II).

**Caution:** Most papers concern actively actuated CDPRs, not passive sensing. Transfer geometry/optimization concepts, **not** their tension objectives wholesale.

### Lesson 2 — Define structured candidate families

- **S1 — Structured Layered / Opposite:** interpretable upper/lower and opposite-face organization.
- **S2 — Structured Cross-Paired:** distributed anchors with deliberately varied (not necessarily no-crossing-in-projection) pairing.
- **S3 — Near-Symmetric:** readable physical arrangement allowing modest asymmetry to improve 6-DOF sensing.

For each, specify allowed faces/rails, attachment surface regions, pairing restrictions, and adjustable coordinates; avoid hard-coding unjustified symmetry or a mandatory one-anchor-per-face rule.

### Lessons 3–4 — Generate and preliminarily screen

- Generate **multiple** reproducible candidate instances per family (not just one).
- Use the 98 anchor and 100 Fibonacci attachment sets, and optionally an explicit union set with deduplication.
- Use reference-pose geometry and Jacobian to remove obvious failures; run a subset/multi-pose check on survivors.
- Compare against retained B/B′ and F1/F2/F3 baselines.

**Exit:** Structured family definitions, documented source-to-design reasoning, repeatable candidate pool; **no claim of global optimality**.

---

## 5. B5.4 — Joint Configuration Optimisation (4–5 research days)

### Mathematical design variables

\[
\mathcal C_6=\{(A_i,r_{\pi(i)})\}_{i=1}^{6},
\]

where anchors lie on permitted boundary surfaces, attachments on the balloon sphere, and \(\pi\) is a one-to-one pairing permutation.

### Constrained objective

For a **Core-feasible** candidate, prioritize robust scaled 6-DOF observability:

\[
\max_{\mathcal C_6}\min_{q\in Q_{\mathrm{core}}}\sigma_{\min}\!\left(H_s(q;\mathcal C_6)\right).
\]

Report worst-case \(\kappa\), clearance and pose coverage separately; do not rely on an arbitrary weighted score without sensitivity testing.

### Constraints and diagnostics

**Hard, once specified:** Core balloon containment; sphere non-penetration; cable pair physical clearance; Jacobian full rank; manufacturable anchor/attachment separation and cable length/stroke bounds.

**Secondary:** face coverage, cable-direction similarity, spatial distribution, adjustment complexity and engineering interpretability. **Projected visual crossings are not themselves collision constraints.**

### Work packages

1. Specify objectives, units, normalized Jacobian convention, collision/spacing/accuracy thresholds (mark unknown hardware values as provisional).
2. Multi-start candidate search by structured family; use feasible-first screening and controlled random seeds.
3. Pairing refinement plus local movements of anchor/attachment positions; keep a record of exactly what changed and why.
4. Robust Core evaluation, alternative intermediate/combined-rotation validation, and no re-use of held-out poses in optimization.
5. Pareto comparison of feasible sensing, minimum clearance, workspace coverage and implementation effort.

**Exit:** 2–3 documented candidates, not a claim of globally best configuration. Preserve raw data, random seeds, and unsuccessful runs needed for research reproducibility.

---

## 6. B5.5 — Independent Sensing Validation (2 research days)

**Why:** Full-rank Jacobian and good singular values describe **local sensitivity**, not actual reconstruction of unknown pose.

- Generate cable-length data at **held-out** poses (including intermediate translations and simultaneous rotations), not used to select the configuration.
- Apply plausible **assumed** noise levels; later replace with empirically calibrated sensor noise.
- Solve nonlinear forward pose estimation from measured lengths with explicit initial guesses / multi-start checks.
- Compare estimated position and orientation with known simulation ground truth; report medians, worst cases, failure rate and ambiguity.
- Distinguish noise-induced local uncertainty from global solution ambiguity and model errors.

**Exit:** Evidence for achievable simulated pose accuracy and clearly documented failures.

---

## 7. B5.6 — Prototype V1.0 Decision (2–3 research days)

**Why:** A numerically promising configuration still may be impractical for a low-tension passive balloon sensing prototype.

- Specify adjustable anchor mounting and attachment fixture geometry.
- Check cable diameter, routing clearance, connector size and cable travel.
- Review positive low-tension feasibility and whether cable forces disturb passive motion (coordinate with existing B6/tension plan).
- Map provisional sensor resolution, range and calibration needs to the results of B5.5.
- Select one adjustable prototype layout with backups, plus an explicit list of unverified assumptions.

**Exit:** Prototype V1.0 **draft design decision**, not a declaration that deformable-balloon sensing has been validated.

---

## 8. Suggested research-day schedule (4–5 hours/day)

| Research day | Priority | Deliverable |
|---|---|---|
| Day 1 | B5.2 Lesson 1 | Five-configuration Core results and `.mat` |
| Day 2 | B5.2 Lesson 2 | Failure-cause table and worst poses |
| Day 3 | B5.2 Lesson 3 | Figures, wider Benchmark comparison, B5.2 log |
| Day 4–5 | B5.3 Lesson 1 | Literature figure/table-method matrix |
| Day 6–7 | B5.3 Lessons 2–4 | S1/S2/S3 rules and candidate pool |
| Day 8–9 | B5.4 Formulation + search | Geometrically screened multi-start candidates |
| Day 10–11 | B5.4 Refinement | Stronger Core-sensing candidates |
| Day 12 | B5.4 Pareto + held-out preparation | 2–3 shortlisted configurations |
| Day 13–14 | B5.5 | Simulated pose reconstruction and error report |
| Day 15–17 | B5.6 | Adjustable Prototype V1.0 decision draft |

Dates are intentionally not fixed; a failed check creates a **diagnose → correct → re-run** loop, rather than skipping ahead.

---

## 9. Required teaching and GitHub logging workflow (AGENTS2-aligned)

**For each lesson:**

1. **Research Question:** Why is it needed, what unresolved issue does it address, and what decision will it enable?
2. **Theory / literature:** Derive the relevant equations and identify what the cited literature does and does not support.
3. **Implementation plan:** Inputs, outputs, assumptions, algorithm stages, and likely failures.
4. **MATLAB code:** One **Chinese-annotated complete version only**; do not dump whole future-stage scripts in advance.
5. **Numerical verification:** Run MATLAB, compare actual console output and figures with expected properties; diagnose mismatches.
6. **Research reflection:** Explain why the result matters and whether it changes the next decision.
7. **Research Log:** Save verified inputs, parameters, output tables, figures, limitations, and next action to the repository.

**GitHub update principle:** Manually update **one file at a time**, preserving historic logs and separating completed results from proposed plans. Do not overwrite past B/B′ or F1–F3 raw results when exploring new families.

---

## 10. Immediate next action / handoff

**Next lesson:** `B5.2 Lesson 1 — Five-Configuration Core Workspace Geometric Screening`

**Load:** `B2_experiment_B_results.mat`, `B5_1_geometry_constrained_pairing.mat` and the B3 finite-segment distance function. Reconstruct B′ from B by swapping the two attachment assignments; do not move the original anchor/attachment sets.

**Check:** Reference-pose consistency, 189 poses shared by all five configurations, complete 15-pair distance checks at every pose, sphere checks for each cable, and counts as well as masks.

**Save:** A five-configuration `Core` result table and pose-wise data so B5.2 Lesson 2 can diagnose specific failures.

**Stop condition:** If pose conventions, collision thresholds or file formats do not match the previous validated scripts, fix the discrepancy and verify before ranking configurations.
