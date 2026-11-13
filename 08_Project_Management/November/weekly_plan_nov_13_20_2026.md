# Weekly Research Plan — 13–20 November 2026

**Project:** Cable-Robot-Based Sensing for a Passive Deformable Balloon  
**Current phase:** B5.4 — Six-Cable Configuration Optimisation  
**Period:** Friday 13 November – Friday 20 November 2026 (eight working days, including weekend)  
**Daily workload:** 5 hours; **total:** 40 hours  
**Status:** Planned. Do not mark any task complete without saved MATLAB evidence.  
**Suggested repository path:** `08_Project_Management/November/weekly_plan_nov_13_20_2026.md`

## 1. Research Goal and Definition of Success

**Primary question:** Among six eligible, rail-constrained six-cable configurations, which configuration provides the strongest defensible balance of geometric feasibility, local sensing quality, estimation performance, robustness, and practical implementation potential after controlled and joint optimisation?

This sprint aims to complete **one reproducible research pass** through E1a-B, E1b, E2, E3, E4, followed by a frozen-candidate independent validation and design shortlist. It does **not** promise proof of global optimum, continuous-workspace collision freedom, positive-tension feasibility, real cable clearance, or experimental accuracy.

**Authoritative source order:** `AGENTS2.md` → `CURRENT_STATE2.md` (currently inconsistent; see below) → `08_Project_Management/November/B5_3_B5_6_Active_Research_Plan_Six_Cable_Sensing.md` → `08_Project_Management/Roadmap.md` → MATLAB scripts and research logs. Treat archived weekly plans as historical.

**Pre-existing results:**

- B5.3 Core-eligible configuration IDs: `[2 4 6 8 12 17]` (189/189 sampled Core geometry and rank screening).
- B5.4 E1a-A completed only for Config 2, with a **historically hand-repaired** candidate `E1a_Robust_Config2_v1`.
- Config 2 robust rail parameters: `t = [0.375000 0.446898 0.304465 0.470000 0.754805 0.314867]`.
- Existing Config 2 result: sampled geometry/rank `539/539`, worst scaled `sigma_min = 0.508750` across those 539 poses, minimum ideal cable clearance `6.1055 mm`, minimum sphere-outward angle `+1.545778°`, and `12/12` assumed independent single-anchor `±0.005` installation perturbations passed on the 539-pose development set.
- The previously used Core 189 + 150 + 200 pose sets are **development data**, because failures were examined and repaired. Reserve a genuinely fresh validation set.
- **Repository hygiene issue to resolve on Day 1:** `CURRENT_STATE2.md` currently contains a document headed `AGENTS2 — Research and AI Working Rules` rather than a current-state report; `AGENTS2.md` itself has a different version header. Do not treat the erroneous `CURRENT_STATE2.md` content as verified progress.

## 2. Common Evaluation Contract

Before comparing designs, freeze the following in a single evaluation configuration:

1. Model: 550 mL nominal rigid sphere, `rb = 50.8266 mm`, and engineering boundary `280 × 300 × 320 mm`.
2. Cable geometry: `B_i = P + R r_i`; `D_i = A_i - B_i`; `L_i = ||D_i||`, where `A_i` is an anchor and `r_i` is its paired body-frame attachment.
3. Jacobian: `H_i = [-u_i^T, (u_i × R r_i)^T]`, with `u_i = D_i / L_i`. Scaled Jacobian `Hs = H diag(1,1,1,1/rb,1/rb,1/rb)`.
4. Hard numerical filters: balloon containment; outward cable departure from the sphere; no numerical contact between any of the 15 ideal finite cable-pair segments; six-column Jacobian rank. Record all thresholds and tolerance conventions. A geometry pass does not prove physical clearance or tension feasibility.
5. Optimisation/ranking metrics: minimum scaled singular value over the **same** development poses, maximum scaled condition number, minimum outward angular margin, minimum ideal cable-pair separation, pose estimation convergence and RMSE, and installation perturbation results. Physical cable/connector dimensions and target accuracy remain to be specified.
6. Development set: existing Core 189 plus existing off-grid 150 and extra 200 tests as applicable, using identical tests for every candidate; these 539 poses must not be called a final independent holdout.
7. Independent holdout: pre-register the pose-generation algorithm, random seed (suggested `rng(20261120)`), pose ranges, and test count (target at least 250 previously unseen combined-motion poses). Do **not** inspect or tune on these until the candidates are frozen for 20 November. If any candidate is repaired against them, relabel this set development and reserve a new holdout.
8. Fairness: same objective, fixed/variable parameter definitions, pose sets, evaluator, stopping rules, search budget (prefer exact objective-function/pose evaluations), and failure logs. Re-optimise Config 2 from its **unmodified B5.3 starting configuration** in the six-way fair comparison; keep historically repaired E1a-A candidate as a separate reference, not the unfair starting advantage.
9. Save scripts, `.mat` outputs, random seeds, rejected trials and Markdown Research Logs. Do not silently overwrite historical evidence. User manually commits files to GitHub, one at a time.

## 3. Weekly Task Checklist

- [ ] **13 Nov — E1a-B.1**: restore a reliable current-status record; reproduce all six original baselines; lock common comparison rules and independent holdout protocol.
- [ ] **14 Nov — E1a-B.2–B.3**: fix optimisation objective and equal budget; rail-position optimisation for all six, including a fresh fair Config 2 run.
- [ ] **15 Nov — E1a-B.4–B.5**: common development robustness, simulated noise/nonlinear estimation; select 2–3 Pareto-relevant designs and log failures.
- [ ] **16 Nov — E1b**: rail-assignment optimisation with fixed attachments/pairing; single-cable reassignment first, including position re-optimisation and mounting checks.
- [ ] **17 Nov — E2**: attachment-position optimisation on the balloon surface with fixed anchor geometry/pairing; attachment separation and placement-uncertainty checks.
- [ ] **18 Nov — E3**: permutation-based anchor–attachment pairing optimisation with fixed sets; hierarchical geometric then sensing screening.
- [ ] **19 Nov — E4**: coordinated multi-variable, reproducible multi-start refinement; consolidate a small candidate shortlist, then freeze designs.
- [ ] **20 Nov — Final B5.4 gate**: genuinely independent holdout and matched nonlinear estimation tests, physically meaningful risk register, final design decision, and one-week research presentation summary.

## 4. Day-by-Day 5-Hour Schedule

| Date | Research task | Hour 1 | Hours 2–3 | Hour 4 | Hour 5 | Required evidence / go-no-go |
|---|---|---|---|---|---|---|
| **Fri 13 Nov** | **E1a-B.1 — Six-config baseline audit** | Check repo authority and repair plan for `CURRENT_STATE2.md` | Load 6 B5.3 configurations; verify cable-to-rail and cable-to-attachment mapping, original `t` and Core 189 | Reproduce rank, `sigma_min`, clearance and outward margins with common evaluator | Freeze development vs holdout rules and save baseline/short log | Six IDs `[2 4 6 8 12 17]` reproduce; inconsistencies explained, not silently ignored |
| **Sat 14 Nov** | **E1a-B.2–B.3 — Fair rail-position optimisation** | Set objective, hard constraints, exact evaluation budget and seed | Run the same E1a procedure for all six from original states | Review failures and comparable best feasible outputs | Save table, six `t` vectors and optimization histories | Every candidate receives the same allowed budget; Config 2's historic repair kept as a separate benchmark |
| **Sun 15 Nov** | **E1a-B.4–B.5 — Robustness and shortlist** | Set noise and tolerance models | Reassess all six on the same 539 *development* poses; minimum outward angle and 15 segment gaps | Nonlinear pose estimation and simulated noise on common conditions | Rank feasible candidates and select 2–3 Pareto-relevant finalists; E1a-B log | All failures and advantages recorded, no misuse of old holdout as independent |
| **Mon 16 Nov** | **E1b — Rail assignment** | Define permitted rails and slider/corner exclusion assumptions | Enumerate single-cable rail swaps and re-optimise new `t_i` on preferred configurations | Multi-pose geometry and sensing comparison | Select whether reassignment merits retention and record added mechanical complexity | Identified rail changes and matched E1a comparison; no claim that every possible assignment was searched |
| **Tue 17 Nov** | **E2 — Attachment position** | Fix sphere surface and minimum attachment-spacing assumptions | Test Fibonacci/locally perturbed attachments while freezing anchors and pairing | Reassess multi-pose routing, sensing and attachment-location perturbations | Save matched E2 gains/losses | Six attachment coordinates, separation, and identical-pose evidence; if no gain retain earlier geometry |
| **Wed 18 Nov** | **E3 — Pairing** | Confirm fixed anchor/attachment sets and uniqueness conventions | Generate `6! = 720` pairings for each selected fixed-set case; fast geometry prefilter | Full multi-pose sensing/clearance evaluation for survivors | Record best feasible pairing or why the baseline pairing remains preferable | Matched E3 table with rejected permutations and complete mapping |
| **Thu 19 Nov** | **E4 — Joint optimisation** | Define mixed discrete/continuous search variables and shared budget | Multi-start coordinated optimisation seeded from E1a/E1b/E2/E3 winners | Compare E4 to controlled experiments on identical development data | Freeze 2–3 finalists and exact geometry; no new tuning on final holdout | Complete candidate records (`rho, t, r, pi`) and a reproducible Pareto shortlist |
| **Fri 20 Nov** | **B5.4 Final Gate** | Read-only independent holdout generation/verification, candidate freeze check | Evaluate untouched poses and common simulated noise/pose-estimator tests | Compare worst margins, clearance, RMSE, installation robustness, nominal length/stroke; list mechanical and tension unknowns | Write B5.4 decision memo/Research Log, PPT summary and GitHub handoff | Defensible numerical shortlist or explicit blocker; B5.5/B5.6 requirements stated separately |

## 5. Required Final Comparison Columns

`Config ID | lineage/family | rho(1:6) | t(1:6) | r(6×3) | pi | development pass/total | untouched holdout pass/total | worst scaled sigma_min | max scaled kappa | min outward angle [deg] | min ideal cable clearance [mm] | nonlinear position RMSE [mm] | orientation RMSE [deg] | estimator failure rate | installation robustness | cable length range/stroke [mm] | mounting risks | decision`.

Compute every comparative numerical indicator on the same stated pose set and noise assumptions. Compare geometry and sensing separately; define practical physical thresholds only after evidence for cable diameter, routing and connector sizes exists.

## 6. Priorities When Time Runs Short

**P0 (essential):** Six-way fair E1a-B, reproducible evaluator, lossless candidate records, same-set geometry and sensing, fresh holdout protocol and end-of-week independent validation.

**P1 (target):** At least one controlled, reproducible E1b, E2, E3 and E4 iteration on a 2–3-candidate shortlist; one frozen robust shortlist.

**P2 (stretch):** Exhaustive coordinated rail reassignment, deep hyperparameter tuning, high-fidelity physical cable/pulley modelling and initial flexible-balloon study. These are not prerequisites for declaring a bounded B5.4 numerical optimisation pass complete and may transfer into B5.5/B5.6.

## 7. Day 1 Starting Procedure

**Research question:** Are the six B5.3 baselines faithfully reconstructed and objectively comparable before any new optimisation?

**Why:** Config 2 has received much more hand tuning than the other five. Comparing it directly with original baselines would exaggerate relative superiority and undermine the final selection.

**Theory:** The measurement relation `delta L ≈ H delta q`, full-column-rank local identifiability and scaled singular-value/conditioning analysis provide the sensing metrics; finite-segment distance and sphere outward-exit tests provide numerical routing feasibility. All must share the same pose set and scaling.

**Inputs:** `B5_3_initial_six_cable_configurations.mat`, `B5_3_early_multipose_screening.mat`, `B5_4_unified_evaluation_baseline.mat`, `B5_4_Lesson1_Unified_Evaluator_2026_11_11.m`, and B5.3/B5.4 research logs. Inspect actual `.mat` fields before coding.

**Deliverables:** `B5_4_E1a_B_1_six_config_baseline_verification.m`, `B5_4_E1a_B_1_baseline.mat`, a small baseline comparison table and an initial `06_Research_Log/2026-11/` entry. File naming is suggested, not yet created.

**Decision gate:** Continue to E1a-B.2 only when the six baselines reproduce saved 189-pose results and measurement/routing definitions align, or any discrepancy is documented and resolved.

---

**End-of-week target:** A frozen, reproducible **numerical** shortlist suitable for B5.5 estimator validation and B5.6 mechanical feasibility review, not a globally optimal or experimentally validated final prototype.
