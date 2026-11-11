# B5.4 E1a — Anchor Rail Position Optimisation: Research Log

**Date:** 2026-11-12  
**Status:** E1a controlled optimisation and sampled robustness screening completed; physical validation and continuous-workspace guarantees pending.  
**Research system:** Six-cable passive pose-sensing system for a spherical balloon in a simplified 280 × 300 × 320 mm workspace.  
**Balloon radius:** `rb = 50.8266 mm`  
**Primary tool:** MATLAB  
**Configuration lineage:** B5.3 Config 2 → E1a sensing-oriented/clearance-oriented → C1 repair → C4 repair → E1a robust candidate.

---

## 1. Research Question and Scope

**Question:** Can changing only the six anchor positions along their fixed physical rails improve multi-pose sensing and cable clearance while preserving geometric feasibility and robustness?

**Fixed:** six rail identities `rho = [5 6 7 8 1 4]` (R5, R6, R7, R8, R1, R4); the six attachment coordinates `r_i`; all cable-to-attachment pairings; balloon radius and pose model.  
**Variable:** the normalized rail parameters `t_i ∈ [0,1]`, each determining an anchor location on its selected rail.  
**Anchor parameterization:** `A_i(t_i) = rail_start(rho_i,:) + t_i * (rail_end(rho_i,:) - rail_start(rho_i,:))`.

This study optimises a **measurement geometry**, not prescribed balloon motion or control. It does not establish cable tension feasibility, exact mechanical pulley centers, continuous collision-free motion, physical cable diameter clearance or experimentally calibrated sensor accuracy.

### 1.1 Shared evaluation rules

- Core pose set: **189 poses** (27 positions at `x,y,z ∈ {-20,0,20} mm`, with seven rotations: identity, and ±5° about each individual axis).
- Original off-grid test: **150** random positions in `[-20,20]^3 mm` and simultaneous RPY in `[-5°,5°]^3` (`rng(42)` used in the earlier experiment).
- Independent off-grid holdout: **200** additional random combined-motion poses (`rng(2026)`).
- Final aggregate: **539 distinct sampled pose tests** (189 + 150 + 200).
- Geometric feasibility: each cable exits the sphere outward, and no pair of ideal finite line segments contacts within the numerical `1e-6 mm` tolerance.
- Outward dot: `g_i(q) = (R*r_i) · [A_i - (P + R*r_i)]`, with numerical sphere threshold `g_i >= -1e-9 mm^2`.
- Outward angular margin: `asin(g_i / (rb * L_i))` in degrees; positive means outward relative to tangent.
- Sensing Jacobian row: `H_i = [-u_i, cross(u_i,R*r_i)]`, where `u_i = [A_i - (P + R*r_i)] / L_i`.
- Scaled Jacobian: `Hs = H * diag(1,1,1,1/rb,1/rb,1/rb)`; use its minimum singular value and rank as local sensing diagnostics.
- All 12 independent installation perturbations: one cable at a time, `delta t_i = ±0.005`, all other rails fixed. These are simulated deviations, not manufacturer tolerance specifications.

**Important comparisons:** A minimum singular value must be compared over the **same pose set**, and pass counts are only evidence about the specified finite samples.

---

## 2. Original B5.3 Config 2 Baseline (Before E1a)

**Family:** S1 — Structured Layered.  
**Rails (C1–C6):** `[R5 R6 R7 R8 R1 R4]`  
**Original normalized positions:**

```matlab
t_baseline = [0.400000 0.600000 0.550000 0.450000 0.700000 0.300000];
```

| Cable | Rail | `t_i` | Anchor X (mm) | Y (mm) | Z (mm) |
|---|---|---:|---:|---:|---:|
| C1 | R5 | 0.400000 | -28.000 | -150 | -160.000 |
| C2 | R6 | 0.600000 | +28.000 | +150 | -160.000 |
| C3 | R7 | 0.550000 | +14.000 | -150 | +160.000 |
| C4 | R8 | 0.450000 | -14.000 | +150 | +160.000 |
| C5 | R1 | 0.700000 | -140.000 | -150 | +64.000 |
| C6 | R4 | 0.300000 | +140.000 | +150 | -64.000 |

### Original Core benchmarks

| Metric | Baseline |
|---|---:|
| Core geometry & rank | 189/189 |
| Worst **Core** scaled `sigma_min` | **0.396711** |
| Minimum ideal cable-pair distance | **4.6508 mm** |
| Off-grid original 150 | 149/150 |
| Independent holdout 200 | 200/200 |
| Combined sampled geometry | **538/539** |
| Installation tests on known 339 poses | **1/12** (after including original off-grid pose) |
| Failure at old Off-grid Pose 149 | Cable 1 sphere exit, `g1=-58.366 mm^2` |

**Interpretation:** Passing the original Core set did not ensure passing combined-axis orientations or tolerance perturbations.

---

## 3. Method and Experimental Sequence

### 3.1 Lesson 3.1 — One-factor-at-a-time rail scan

Each cable's `t_i` was independently perturbed by `±0.05` and `±0.10`, leaving all other variables unchanged. **21 of 25** evaluated trial configurations remained Core-eligible. The first local results showed:

- **Trial 21:** C5 `delta t = +0.10` gave best sampled sensing `sigma_min = 0.450202` with ideal minimum distance `4.6508 mm`.
- **Trial 6:** C2 `delta t = -0.10` gave best sampled cable clearance `5.7065 mm` with `sigma_min = 0.39529`.
- C1 positive movement and C4 negative movement caused Core geometry failures, indicating nearby limits.

### 3.2 Lesson 3.2 — Conditional feasible intervals

Each `t_i` was scanned over `[0,1]` while the **other five rail parameters remained at the baseline**. Forty-one grid samples and a transition-point bisection gave the following *detected, conditional* intervals:

| Cable | Rail | Baseline `t_i` | Detected interval | Corresponding rail span (mm) |
|---|---|---:|---|---:|
| C1 | R5 | .400 | `[0, .401382]` | 112.387 |
| C2 | R6 | .600 | `[0, .893796]` | 250.263 |
| C3 | R7 | .550 | `[0, .878574]` | 246.001 |
| C4 | R8 | .450 | `[.434622, 1]` | 158.306 |
| C5 | R1 | .700 | `[.459610, 1]` | 172.925 |
| C6 | R4 | .300 | `[0, .503787]` | 161.212 |

These are **not joint-optimization hard bounds**; changing another anchor or an attachment changes the feasible set. Narrow undetected intervals may exist between coarse samples. In the original configuration, C1 was only about **0.387 mm** away from the sampled upper feasible boundary.

### 3.3 Lesson 3.3 — Two-track sequential coordinate optimisation

Two sweeps were performed, evaluating all 189 Core poses after every trial:

- **Sensing-oriented search:** maximise worst-Core `sigma_min` while holding minimum cable distance at least the baseline.
- **Clearance-oriented search:** maximise minimum cable distance while holding worst-Core `sigma_min` at least the baseline.

| Design | Rail parameters `t=[t1..t6]` | Core Geometry | Worst Core `sigma_min` | Minimum cable distance |
|---|---|---:|---:|---:|
| Baseline | `[.4 .6 .55 .45 .7 .3]` | 189/189 | .396711 | 4.6508 mm |
| Sensing-oriented pre-repair | `[.4 .446898 .304465 .434622 .754805 .314867]` | 189/189 | .522643 | 6.1055 mm |
| Clearance-oriented pre-repair | `[.4 0 .55 .45 .7 0]` | 189/189 | .401213 | 9.2340 mm |

Improvements versus Core baseline: sensing-oriented **+31.7%** worst-Core `sigma_min` and **+31.3%** ideal cable clearance; clearance-oriented **+98.5%** ideal cable clearance and **+1.1%** worst-Core `sigma_min`. These are **Core-only** results before unseen-pose repair and are not directly interchangeable with 539-pose sensing values.

### 3.4 Lesson 3.4 — Off-grid and installation robustness

All three designs yielded 149/150 geometry passes on the **same** off-grid pose ID 149:

- Center `P=[-17.9408, 4.91562, -4.94962] mm`
- RPY `[-3.07711, +4.06472, -4.86998] degrees`
- Sphere-interference failure **C1**; `g1 = -58.366 mm^2`, same across all designs.
- C1 anchor was unchanged `A1=[-28,-150,-160] mm` for all three designs.
- No numerical cable-pair contact at that failed pose.

This established a common failure mechanism missed by the original single-axis Core orientations.

### 3.5 Lessons 3.5.1–3.5.2 — Targeted C1 repair

Holding all other variables fixed, move only C1 along R5:

- Original `t1=.400` → `t1=.375`, **7 mm** in the negative X direction.
- At old failed Pose 149, `g1` changes from `-58.366` to approximately `+291.38 mm^2`.
- Three candidate families passed 339/339 previously known poses at the repaired location.
- A new independent set of 200 combined poses exposed a **second**, distinct failure: sensing-oriented design at new Pose 164, **C4** sphere exit.
- New Pose 164: `P=[18.7188, -3.77358, 14.7244] mm`, RPY `[4.17701, 1.17903, -4.96363] degrees`.
- Sensing-oriented t1=.375 had **199/200** new poses and `g4=-42.010 mm^2` at this failure.
- `t1=.350` remained a useful C1-margin comparison but did not resolve the C4 failure.

**Decision:** Retain `t1=.375` for the main sensing-repair branch; retain .350 as a possible C1-margin alternative, not a final design.

### 3.6 Lesson 3.5.3 — Targeted C4 repair

Hold the sensing-oriented design with `t1=.375` fixed, then scan only C4's `t4` along R8. C4 at `t4=.434622` was close to a Core geometry boundary; `t4=.440` first achieved all **539/539** sampled poses in the scan, but with only **0.116°** minimum outward angle.

| `t4` | Total geom / rank | Worst scaled `sigma_min` over 539 | Minimum outward angle | Min cable distance |
|---|---|---:|---:|---:|
| .434622 | 538/539 | Not eligible | −.2267° | 6.1055 mm |
| .440 | 539/539 | .50877 | +.11592° | 6.1055 mm |
| .450 | 539/539 | **.509699** | +.757986° | 6.1055 mm |
| .460 | 539/539 | .50967 | +1.4063° | 6.1055 mm |
| .470 | 539/539 | **.508750** | **+1.545778°** | 6.1055 mm |
| .500 | 539/539 | .50571 | +1.545778° | 6.1055 mm |

At `t4=.450`, the limiting constraint was **C4 at combined Pose 503**. At `t4=.470`, the limiting constraint switched to **C1 at combined Pose 338**. Further increasing `t4` does not raise the overall minimum outward angle because C1 now limits it, and sensing gradually declines. This is *active-constraint switching*, not a new C1 collision.

### 3.7 Lesson 3.5.4 — Final same-set robustness comparison

| Metric | `t4=.450` Sensing candidate | `t4=.470` **Preferred robust candidate** |
|---|---:|---:|
| Nominal geometry / rank on 539 poses | 539/539 | 539/539 |
| Worst scaled `sigma_min` over 539 poses | **0.509699** | .508750 |
| Minimum outward angle (539 poses) | +.757986° | **+1.545778°** |
| Limiting Cable / combined Pose ID | C4 / 503 | C1 / 338 |
| Ideal min cable distance (539 poses) | 6.1055 mm | 6.1055 mm |
| Single-anchor `±.005` tests | 12/12 | 12/12 |
| All 539-pose passes in every perturbation | 12/12 | 12/12 |
| Worst perturbed outward angle | +.43616° | **+1.1734°** |
| Worst perturbed min cable distance | 6.0597 mm | 6.0597 mm |

` t4=.470 ` loses only around **0.19%** of worst scaled `sigma_min` relative to `.450`, while its nominal minimum outward angular margin increases around **104%**, and worst-perturbed angular margin around **169%**. It is the preferred *sampled robustness–sensing trade-off* for E1a.

---

## 4. Final E1a Selected Configuration (Current Best, Not Final Prototype)

**Label:** `E1a_Robust_Config2_v1`  
**Family:** S1 — Structured Layered  
**Rail IDs:** `[5 6 7 8 1 4]` (unchanged)  
**Attachment coordinates and cable pairing:** **unchanged from B5.3 Config 2**. Load them from `best_configs(2).r` in `B5_4_unified_evaluation_baseline.mat`; do not copy approximate attachment coordinates from other configurations.

```matlab
t_E1a_Robust_Config2_v1 = [ ...
    0.375000, 0.446898, 0.304465, ...
    0.470000, 0.754805, 0.314867 ];
```

| Cable | Rail | Original t | Selected t | Original A (x,y,z) mm | Selected A (x,y,z) mm |
|---|---|---:|---:|---|---|
| C1 | R5 (X) | .400000 | **.375000** | `[-28,-150,-160]` | `[-35,-150,-160]` |
| C2 | R6 (X) | .600000 | **.446898** | `[28,150,-160]` | `[-14.8686,150,-160]` |
| C3 | R7 (X) | .550000 | **.304465** | `[14,-150,160]` | `[-54.7498,-150,160]` |
| C4 | R8 (X) | .450000 | **.470000** | `[-14,150,160]` | `[-8.4,150,160]` |
| C5 | R1 (Z) | .700000 | **.754805** | `[-140,-150,64]` | `[-140,-150,81.5376]` |
| C6 | R4 (Z) | .300000 | **.314867** | `[140,150,-64]` | `[140,150,-59.2426]` |

**Selected prototype-independent performance on 539 tested poses:**

- Geometry and full-rank Jacobian: **539 / 539**.
- Worst scaled `sigma_min`: **0.508750**.
- Minimum ideal cable distance: **6.1055 mm**.
- Minimum outward angle: **+1.545778°** (C1, combined Pose 338).
- All 12 single-anchor `±.005` perturbation cases retained geometry and rank on all 539 poses.
- Worst outward margin among those perturbation cases: **+1.1734°**.

### 4.1 Quantified improvement versus original baseline

| Comparable measure | Original Config 2 | Selected E1a robust | Difference |
|---|---:|---:|---:|
| Ideal minimum cable distance (sampled tests) | 4.6508 mm | 6.1055 mm | **+31.3%** |
| Combined 539-pose geometry pass | 538/539 | 539/539 | **+1 sampled pose**, eliminating observed failures |
| Worst scaled `sigma_min` **on Core 189** | 0.396711 | **Not separately recomputed in final log** | **Do not compare to 539-pose value** |
| Worst scaled `sigma_min` **on all 539** | **Not reported for baseline as full-geometry-eligible** | 0.508750 | **No direct same-domain eligible percentage available** |
| Independent single-anchor perturbations **on known 339** | 1/12 | 12/12 on all 539 | **Different pose sets: avoid direct percentage claims** |
| Combined-pose outward geometry | C1 violated `-58.366 mm^2` at old Pose 149 | All 539-pose outward margins positive; min angle +1.545778° | **Observed C1 and C4 sphere failures repaired** |

**Important metric note:** The numerical ratio `0.508750 / 0.396711 - 1 ≈ +28.2%` uses different pose domains (539 vs 189). It is **not** a valid exact like-for-like sensing improvement. For an accurate *Core-only* sensing improvement, recompute `min(sigma_min_all(1:189))` for the selected E1a candidate. Keep the verified interim **Core-only** +31.7% value for the pre-repair sensing configuration, not for the selected repaired configuration.

### 4.2 Selection rationale

Retain `.450` as the **higher nominal sensing** control and **select `.470`** for current E1a record because the latter has practically unchanged 539-pose Jacobian quality, identical ideal cable-pair minimum distance, the same 12/12 independent perturbation pass rate, and considerably better minimum outward angular margins.

---

## 5. Remaining Limitations and Risks

1. **Finite sampling:** 539 discrete poses are not a guarantee of interference-free *continuous* workspace, especially under simultaneous rotations or motion between samples.
2. **Installation error model:** twelve individual `±0.005` offsets test only one anchor at a time; simultaneous anchor errors, errors in other directions, and attachment mounting inaccuracies were not evaluated.
3. **Ideal cable geometry:** no cable thickness, pulley groove/routing radius, physical exit tangent point, cable deflection, connector footprint or frame obstacles are included.
4. **Physical rails:** `t∈[0,1]` is a mathematical coordinate; actual end-stop clearance and carriage dimensions remain to be specified.
5. **Sensing:** local scaled singular values predict conditioning, but do not establish true calibrated pose error, global forward-kinematics uniqueness or hardware reliability.
6. **Tension:** low-tension cable tautness and tension feasibility require independent validation; rank 6 does not guarantee physical taut-cable operation.
7. **Optimisation:** sequential coordinate search is deterministic and interpretable but is not certified globally optimal and may miss coordinated changes.
8. **Inter-family competition:** this particular E1a search optimised only S1 Config 2; other eligible starting candidates remain available.

---

## 6. Why E1b — Rail Assignment Optimisation Comes Next

**E1a controlled:** Rail IDs fixed while `t_i` moved. This finds the best sampled position along *already selected* six physical rails but cannot change the available cable approach directions.

**E1b adds a discrete variable:** the rail assignment `rho_i ∈ {R1,...,R12}` for each cable, alongside its coordinate `t_i`. With attachment coordinates and pairing still fixed, E1b can explore a different family of spatial anchor arrangements that E1a can never reach merely by sliding existing mounts.

**Example:** C1 is presently on X-directed **R5** at `[-35,-150,-160] mm`. Changing its permitted rail can alter the direction of cable departure from attachment B1, potentially enlarge worst outward angle while preserving or improving measurement conditioning. It can also create new cable crossings, awkward pulley paths, near-corner crowding or lower rank; therefore, every assignment must be independently screened.

**Recommended staged E1b design:**

1. Use `E1a_Robust_Config2_v1` as the unchanged benchmark (and `.450` as a control).
2. Explicitly state rail compatibility and prototype mounting rules: whether multiple sliders can share a rail, minimum carriage spacing, corner exclusions, cable routing and attachment accessibility.
3. Run **single-cable rail reassignment** first (keep five rail assignments fixed); position-search within each candidate rail, under the exact same evaluation rules.
4. Compare 539-pose geometry, minimum outward angle, minimum cable clearance and scaled Jacobian quality; report both infeasible and eligible trials.
5. Then consider coordinated multiple-rail changes only if needed. Preserve fairness with common initial configurations, pose sets, objective definitions, and compute budget.
6. Revalidate finalists with independent held-out poses, simulated installation perturbations, nonlinear pose estimation, and, later, physical geometry/tension constraints.

**Why it matters:** E1a identified the limitation of position-only optimisation. E1b tests whether a **different physical mounting edge** can further improve the passive six-cable measurement system, before turning to E2 attachment placement, E3 cable pairing, and E4 joint optimisation.

---

## 7. Saved MATLAB Outputs (User-Run)

- `B5_4_unified_evaluation_baseline.mat` — 18-config regression-verified baseline.
- `B5_4_noise_sensitivity_baseline.mat` — assumed 0.1 mm length-noise pose reconstruction comparison.
- `B5_4_E1a_Config2_rail_position_scan.mat` — controlled one-factor scans.
- `B5_4_E1a_Config2_feasible_rail_intervals.mat` — detected conditional intervals.
- `B5_4_E1a_Config2_sequential_optimisation.mat` — two-track sequential coordinate optimisation.
- `B5_4_E1a_Config2_robustness_verification.mat` — first off-grid + installation test.
- `B5_4_offgrid_failure_point_check.mat` — exact failing pose / cable diagnostics.
- `B5_4_E1a_C1_targeted_repair.mat` — C1 position repair over 339 poses.
- `B5_4_E1a_C1_repair_robustness.mat` — hold-out test revealing C4 failure.
- `B5_4_E1a_C4_targeted_repair.mat` — 539-pose C4 scan.
- `B5_4_E1a_final_robustness.mat` — final `.450` versus `.470` comparison.

**Recommended next recorded activity:** B5.4 E1b Lesson 1 — Rail assignment design rules and controlled single-cable reassignment. Preserve this E1a log as a historical record instead of overwriting earlier experiments.
