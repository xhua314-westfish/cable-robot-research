# B3.2 — Six-Cable Multi-Pose Geometric Feasibility

**Date:** 2026-11-03  
**Phase:** B — Balloon-Specific Cable Sensing Design  
**Status:** Completed — Initial 189-pose numerical geometric evaluation  
**Next task:** B4.1 — Jacobian and Sensing Quality (after B3 archiving)

---

## 1. Research Question

How do combined balloon translation and rotation affect cable lengths, cable–sphere interference, cable–cable interference, and sampled geometric feasibility for the two six-cable configurations produced in B2?

**Purpose:** Test the existing Experiment A and Experiment B without altering anchor coordinates, attachment coordinates, or cable pairing. These are pose-by-pose feasibility tests, **not** a prescribed balloon trajectory or configuration optimisation.

## 2. Geometry and Test Set

| Item | Definition |
|---|---|
| Engineering boundary (X/Y/Z) | 280 × 300 × 320 mm |
| Balloon | Ideal rigid sphere, nominal volume 550 mL |
| Balloon radius (loaded MATLAB dataset) | 50.8266 mm (rounded) |
| Cable count | 6 for each configuration |
| Configuration A | Six fixed face-centre anchors; selected attachments |
| Configuration B | Jointly selected anchors and attachments |
| Sampled translations | `Px, Py, Pz ∈ {-50, 0, +50}` mm |
| Number of centre positions | 27 |
| Sampled rotations | Identity; roll ±10°; pitch ±10°; yaw ±10° |
| Rotation convention | `R = Rz(yaw) * Ry(pitch) * Rx(roll)` |
| Number of orientation cases | 7 |
| Total sampled poses | **27 × 7 = 189** |
| Cable model | Straight, zero-thickness, finite line segments |
| Cable–cable numerical contact tolerance | `1e-6` mm (not a physical safety clearance) |

Each orientation case was evaluated at all 27 centre positions. The sample includes **only individual-axis** ±10° rotations, not simultaneous nonzero roll, pitch and yaw. The ranges are engineering test assumptions, not measured physiological motion bounds. All sampled sphere centres passed the cuboid containment check; for a rigid sphere, containment does not change with orientation.

For cable `i`, with fixed world-frame anchor `A_i`, body-fixed attachment `r_i`, centre `P` and rotation `R`:

\[
B_i=P+Rr_i,\quad D_i=A_i-B_i,\quad L_i=\|D_i\|.
\]

**Cable–sphere check:** For `s_i = Rr_i`, require `s_i^T D_i >= 0` within the documented numerical tolerance. This is the ideal straight-line outward criterion for a zero-thickness cable starting on a spherical surface.

**Cable–cable check:** For every cable pair `(i,j)`, calculate the minimum distance between finite segments `[B_i,A_i]` and `[B_j,A_j]`. There are `nchoosek(6,2) = 15` cable pairs, hence **2,835 pair evaluations per configuration** across the 189 poses.

**Combined classification:** A pose passes only when **all six cables** pass the sphere check and **all 15 cable pairs** exceed the numerical contact threshold.

## 3. Numerical Verification and Length Results

### 3.1 Regression and Consistency Checks

The MATLAB run reported:

- Positions: **27**; orientation cases: **7**; total poses: **189**.
- Rotation orthonormality and determinant checks passed.
- Translation–rotation pose construction passed.
- Cable length consistency with the original B3.1 zero-rotation model: **0.000e+00 mm** maximum error for A and B.
- Cable–sphere classification at zero rotation matched the B3.1 classifications.
- Cable–cable distance consistency with B3.1: **0.000e+00 mm** maximum error for A and B.

These are numerical consistency checks against the previous code and data, not an independent physical validation.

### 3.2 Cable-Length Statistics Across 189 Poses

| Metric | Experiment A | Experiment B |
|---|---:|---:|
| Minimum cable length (mm) | 39.173 | 91.306 |
| Maximum cable length (mm) | 223.620 | 329.134 |

Per-cable maximum-minus-minimum lengths (mm):

| Cable | Experiment A | Experiment B |
|---:|---:|---:|
| 1 | 120.66 | 150.80 |
| 2 | 139.28 | 181.97 |
| 3 | 132.76 | 181.97 |
| 4 | 146.21 | 160.47 |
| 5 | 131.84 | 185.00 |
| 6 | 143.60 | 156.31 |

Experiment B had greater per-cable length variation in this sample. Larger length variation does **not** independently demonstrate superior sensitivity, estimation accuracy, or hardware feasibility.

## 4. Geometric Feasibility Results

| Test | Experiment A | Experiment B |
|---|---:|---:|
| Cable–sphere pass count | **40/189 (21.2%)** | **186/189 (98.4%)** |
| Cable–cable no-contact count | **189/189 (100%)** | **108/189 (57.1%)** |
| Combined geometric pass count | **40/189 (21.2%)** | **105/189 (55.6%)** |
| Global minimum cable–cable distance | **6.090818 mm** | **≈ 0 mm** |

### 4.1 Cable–Sphere Failure Counts

| Cable | Experiment A | Experiment B |
|---:|---:|---:|
| 1 | 0 | 0 |
| 2 | 42 | 0 |
| 3 | 3 | 0 |
| 4 | **90** | 0 |
| 5 | 0 | **3** |
| 6 | 49 | 0 |

These are **per-cable failure occurrences**, not distinct failed-pose counts: multiple cables may fail within one pose. Experiment A's main sphere-interference issue remained cable 4; Experiment B had only three sphere-failure poses, all involving cable 5.

### 4.2 Cable–Cable Contact Diagnosis

- **Experiment A:** No cable pair met the numerical contact criterion at any of 189 poses. Minimum observed inter-cable distance: **6.090818 mm**.
- **Experiment B:** There were **81/189 poses** with a numerical cable–cable contact. Every recorded contact involved **cable pair 5–6**; the other 14 pairs recorded zero contacts.
- For B, cable pair 5–6 contacted at **all 27 positions** under each of the following orientation cases: identity, roll +10°, roll −10°.
- For B, pair 5–6 recorded **zero contacts** in the four tested pitch/yaw ±10° cases.

Distances reported as `0.000000 mm` are numerically indistinguishable from zero under the chosen tolerance. The **precise contact geometry** (interior intersection, tangency, or overlap), and whether small but finite clearances are adequate for real cables, still require separate checking. The finite-segment distance implementation passed the previous simple regression tests but has not been certified as an exhaustive geometric collision engine.

### 4.3 Combined Feasibility by Rotation Case

Each row represents 27 sampled centre positions with the specified rotation.

| Case | Roll (°) | Pitch (°) | Yaw (°) | Feasible A /27 | Feasible B /27 | B: pair 5–6 contacts /27 |
|---:|---:|---:|---:|---:|---:|---:|
| 1 | 0 | 0 | 0 | 8 | 0 | 27 |
| 2 | +10 | 0 | 0 | 11 | 0 | 27 |
| 3 | −10 | 0 | 0 | 2 | 0 | 27 |
| 4 | 0 | +10 | 0 | 4 | 25 | 0 |
| 5 | 0 | −10 | 0 | 5 | 27 | 0 |
| 6 | 0 | 0 | +10 | 5 | 27 | 0 |
| 7 | 0 | 0 | −10 | 5 | 26 | 0 |
| **Total** | | | | **40/189** | **105/189** | **81/189** |

**Experiment B failure breakdown:**

| Failure category | Number of poses |
|---|---:|
| Cable–sphere failure only | 3 |
| Cable–cable numerical contact only | 81 |
| Both failure types | 0 |
| At least one failure | **84** |
| Combined pass | **105** |

The totals are internally consistent: `105 + 84 = 189`.

## 5. Interpretation and Research Findings

1. **Different configurations exhibit different dominant failure modes.** Experiment A is limited mainly by cable–sphere interference (especially cables 2, 4 and 6). Experiment B is limited mainly by cable pair 5–6 reaching a zero-distance contact condition.
2. **Rotation direction matters.** For A, roll +10° yielded 11/27 combined feasible positions, while roll −10° yielded 2/27. For B, both roll directions yielded 0/27 combined feasibility, whereas pitch/yaw rotations produced 25–27/27.
3. **B performs better over the stated *sampled combined-pose set*, but is not a final design.** B reached 105/189 (55.6%) versus A's 40/189 (21.2%). This is a discrete geometric-screening result only, and not a finding about true sensor accuracy or a continuous workspace.
4. **Do not interpret B3.1 (0/27 for B at zero rotation) versus B3.2 (105/189 for B) as proof that rotating the balloon expands the physical workspace.** The tested pose sets and denominators differ. Some newly sampled pitch/yaw orientations remove the 5–6 numerical contact observed at zero rotation.
5. **B2's local condition-number ranking cannot select the engineering configuration.** Even if the initial 6×6 measurement Jacobian is full rank and well conditioned, cable routing may fail away from that pose.

## 6. Limitations and Unresolved Questions

- Only **189 discrete poses**, not the continuous six-dimensional pose space. No simultaneous multi-axis rotations or larger rotation envelopes were tested.
- Ideal zero-thickness, straight cable geometry; no pulley routing, cable elasticity, sagging, friction, wrapping or attachment hardware.
- The `1e-6 mm` contact threshold is numerical, **not** a verified physical clearance requirement. A positive gap may still be unsafe for finite-diameter cables.
- The exact geometric mechanism of pair 5–6 contact has not been independently visualised or analytically classified; verify if needed before redesigning the pair.
- **Tension feasibility, low-tension tracking, and disturbance to passive balloon motion were not evaluated.** Full 6-DOF wrench closure must not be inferred from six length measurements.
- The 189-pose results are **geometric feasibility**, not **sensing workspace**: no workspace-level Jacobian rank, minimum singular value, conditioning, pose covariance, forward-kinematics accuracy or Monte Carlo RMSE has yet been reported.
- Engineering boundary dimensions and motion samples are modelling choices, not clinically measured gastric travel or motion limits.
- The A/B configurations are not established as globally optimal.

## 7. Reproducibility and Files

**Required inputs (existing B1/B2 dataset):**

- `B1_geometry_baseline.mat` (variable `geometry`)
- `B2_6cable_experiment_A.mat` (variable `config6`)
- `B2_experiment_B_results.mat` (variable `resultB`)
- `B3_1_results.mat` (variable `B3_1_results`)

**MATLAB scripts/results generated locally during B3:**

- `B3_1_multi_position_feasibility.m`
- `B3_1_segment_distance_3d.m`
- `B3_2_multi_pose_feasibility.m`
- `B3_2_results.mat` (variable `B3_2_results`)
- `B3_2_Experiment_A_feasibility.png`
- `B3_2_Experiment_B_feasibility.png`

Place the MATLAB source and datasets together or adapt the scripts to use explicit paths. **The existence of local outputs does not establish their GitHub upload status.** Archive the scripts, `.mat` results and generated figures separately from this Markdown record.

The figures show 27 centre locations under each of seven fixed orientation cases (green: combined pass; red: at least one interference failure). They are **pose slices**, not connected motion trajectories or continuous feasibility boundaries.

**Consistency gates already passed in the reported MATLAB run:** rotation-matrix checks, 189-pose construction, B3.1 zero-rotation length/cable–sphere/segment-distance regression checks, and result saving.

## 8. Research Decision and B4 Handoff

**B3.2 is complete as an initial multi-pose geometric feasibility study.** Keep A and B as fixed reference configurations for subsequent B4 sensing assessment; do not retroactively change them to improve B3 results.

**Next:** B4.1 — Jacobian and Sensing Quality, reusing the saved 189 poses. For each tested pose, calculate the analytical/scaled cable-length Jacobian and assess its rank, minimum singular value, condition number, and local uncertainty under explicit measurement-noise assumptions. Clearly distinguish feasible poses from geometrically invalid ones. Consider running the sensing diagnostics on *all* sampled poses for failure analysis, while making engineering candidate comparisons only over the declared feasible pose sets (and noting when the sets differ).

**Later:** B4.2 — Forward Kinematics and Monte Carlo; B5 — constrained multi-pose anchor–attachment optimisation including geometric validity, uncertainty and passive-motion requirements. A six-cable reference configuration is not yet selected, and the seven-/eight-cable extension remains deferred.

---

**Concise takeaway:** Across 189 translation–rotation samples, Experiment A passed 40 (21.2%) and Experiment B passed 105 (55.6%) of the ideal geometric checks. Experiment A was limited primarily by cable–sphere interference; B primarily by pair 5–6 cable contact. These results motivate feasibility-aware sensing evaluation and later joint placement optimisation.
