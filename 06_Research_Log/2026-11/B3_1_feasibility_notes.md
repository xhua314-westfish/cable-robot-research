# B3.1 — Six-Cable Multi-Position Geometric Feasibility

**Date:** 2026-11-03  
**Phase:** B — Balloon-Specific Cable Sensing Design  
**Status:** Completed — Initial 27-position, zero-rotation geometric evaluation  
**Next task:** B3.2 — Multi-Pose Geometric Feasibility

---

## 1. Research Question

Can the six-cable configurations selected during B2 remain geometrically feasible when the rigid balloon translates to different positions within the engineering boundary?

The purpose of B3.1 was **validation**, not optimisation. The anchor coordinates, attachment coordinates, and cable pairings of Experiments A and B were kept unchanged.

## 2. Model and Evaluation Setup

| Parameter | Setting |
|---|---|
| Engineering boundary | 280 × 300 × 320 mm (X/Y/Z) |
| Balloon | 550 mL rigid sphere |
| Radius from MATLAB dataset | 50.8266 mm (rounded) |
| Cables | 6 per configuration |
| Configurations | Experiment A; Experiment B from B2.2 |
| Centre coordinates on each axis | −50, 0, +50 mm |
| Sampled centre positions | 27 = 3³ |
| Orientation | R = I for all positions |
| Cable geometry | Ideal straight, zero-thickness line segments |
| Cable–cable contact threshold | 1 × 10⁻⁶ mm (numerical only) |

The full rigid sphere was contained at all 27 sampled positions. The tested subset must not be confused with the complete engineering centre-position domain or a clinically validated gastric workspace.

For cable *i*:

\[
B_i=P+Rr_i,\qquad D_i=A_i-B_i,\qquad L_i=\lVert D_i\rVert.
\]

The cable–sphere check uses \(s_i=B_i-P\) and the ideal-sphere outward condition

\[
s_i^\mathsf{T}D_i\geq0.
\]

The cable–cable check computes the minimum distance between each pair of **finite** cable segments, with 15 distinct pairs per pose (405 pair evaluations across 27 positions).

## 3. Numerical Results

### 3.1 Cable-Length Results

| Metric | Experiment A | Experiment B |
|---|---:|---:|
| Minimum length among sampled poses | 39.173 mm | 92.332 mm |
| Maximum length among sampled poses | 215.857 mm | 322.392 mm |

Cable-specific maximum-minus-minimum length variation (mm):

| Cable | Experiment A | Experiment B |
|---:|---:|---:|
| 1 | 116.93 | 146.71 |
| 2 | 127.14 | 169.69 |
| 3 | 119.18 | 169.69 |
| 4 | 131.67 | 152.30 |
| 5 | 118.63 | 171.59 |
| 6 | 128.30 | 148.75 |

The length values are geometric predictions over the selected sample positions. They do not establish hardware cable travel requirements or sensing accuracy.

### 3.2 Interference and Geometric Feasibility

| Test | Experiment A | Experiment B |
|---|---:|---:|
| Full sphere containment | 27/27 | 27/27 |
| Cable–sphere check passed | 8/27 | 27/27 |
| Cable–cable check passed | 27/27 | 0/27 |
| Both interference checks passed | **8/27 (29.6%)** | **0/27 (0%)** |
| Global minimum inter-cable distance | 10.697497 mm | Approximately 0 mm |

Counts of cable–sphere failures (one cable can fail at multiple sampled positions):

| Cable | Experiment A | Experiment B |
|---:|---:|---:|
| 1 | 0 | 0 |
| 2 | 5 | 0 |
| 3 | 0 | 0 |
| 4 | 12 | 0 |
| 5 | 0 | 0 |
| 6 | 6 | 0 |

**Experiment A:** Its principal failure mechanism is cable–sphere interference, especially cable 4. No cable–cable pair crossed the numerical contact threshold in the 27-position dataset. The closest pair was cables 2–6, at position index 25.

**Experiment B:** All 27 positions passed the ideal cable–sphere check, but cable pair **5–6** reached a distance numerically indistinguishable from zero at **all 27 positions**. All other cable pairs had zero recorded contacts under the specified threshold. The reported closest case was position index 13. Thus, no tested position passed both interference criteria.

The observed zero distances were on the order of floating-point rounding error (approximately 10⁻¹³ mm or smaller). These results support a geometric contact classification, but the exact contact type (interior crossing, shared endpoint, overlap) has not yet been independently characterised.

## 4. Interpretation

1. **Single-pose Jacobian conditioning is insufficient for configuration selection.** Experiment B had the lowest scaled condition number at the B2 reference pose, yet it failed the B3.1 combined interference screen at every tested translation.
2. **Different layouts have different dominant failure modes.** Experiment A is limited mainly by cables that enter the sphere, whereas Experiment B is limited by a repeatable contact involving cables 5–6.
3. **Anchor distribution alone does not predict feasibility.** Feasibility depends on anchor–attachment pairing and the complete cable paths, not just how evenly anchors appear distributed.
4. **Cable length alone cannot certify feasibility.** All computed lengths were positive despite failures of geometric routing constraints.
5. **The sampled pass fraction is not a continuous-workspace volume fraction.** The 27-pose test is a coarse engineering screen.

## 5. Verification and Limitations

### Completed Checks

- Both B2 configurations were loaded from saved MATLAB results.
- All 27 sphere centres met the chosen engineering containment check.
- Cable-length matrices were 27 × 6 with finite, positive entries.
- Finite-segment distance code was tested with intersecting, parallel, and separated example segments.
- The 15 cable-pair distances were evaluated at each position.
- Failure counts, failing position indices, and 3D feasible/infeasible maps were generated.

### Not Yet Established

- Exact physical contact geometry for Experiment B's cables 5–6 (requires an independent closest-point/segment visual diagnostic).
- Any specified physical cable diameter or minimum mechanical clearance.
- Cable interactions with real mounting hardware, pulleys, or a non-rectangular gastric environment.
- Feasibility under rotations (addressed separately in B3.2).
- Cable tension, slack, and disturbance of passive balloon motion.
- Workspace-wide Jacobian conditioning, sensor-noise sensitivity, and pose-estimation accuracy.

There is **no basis yet to claim that either configuration is ready for physical implementation or that either is globally optimal**.

## 6. Reproducibility and Source Files

B1/B2 input datasets (repository folder `03_Simulation/MATLAB/workspace definition/`):

- `B1_geometry_baseline.mat` — contains `geometry`.
- `B2_6cable_experiment_A.mat` — contains `config6`, including `A` and `r`.
- `B2_experiment_B_results.mat` — contains `resultB`, including `A` and `r`.

B3.1 output files from the local MATLAB workflow (upload/check separately):

- `B3_1_multi_position_feasibility.m` — the 27-position analysis script.
- `B3_1_segment_distance_3d.m` — finite-segment minimum-distance function.
- `B3_1_results.mat` — saved positions, masks, cable-pair distances, and pairs.
- `B3_1_position_feasibility.png` — suggested descriptive filename for the combined feasibility figure (save/export if not already archived).

The code should be executed with the required datasets and helper function visible on the MATLAB path. The filename shown for the figure is a proposed archive filename, not a claim that a file with that exact name already exists in GitHub.

## 7. Research Conclusion and Handoff

**B3.1 is complete as a 27-position geometric screening experiment.** Under the stated idealised assumptions, Experiment A passed 8/27 tested positions and Experiment B passed 0/27. Their failure mechanisms differ and provide specific targets for future anchor–attachment optimisation.

**Next — B3.2:** Keep A/B fixed and test the 27 centres against seven orientations (zero and ±10° about each of the three axes), producing 189 combined poses. Recalculate lengths and both interference checks at every pose. Verify that all 27 zero-rotation results reproduce B3.1.

**Later — B4/B5:** Evaluate sensing quality over geometrically admissible poses, then optimise anchor–attachment geometry and pairing subject to multi-pose feasibility constraints.

---

**Research decision:** Retain Experiments A and B as diagnostic reference configurations; do **not** select a final six-cable layout on the basis of B3.1 alone.
