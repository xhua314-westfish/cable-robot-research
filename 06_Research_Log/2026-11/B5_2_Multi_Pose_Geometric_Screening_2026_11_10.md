# B5.2 — Multi-Pose Geometric Screening and Failure Diagnosis

**Date:** 2026-11-10  
**Research Phase:** Phase B — Balloon-Specific Cable Sensing Design  
**Workstream:** A — Six-Cable Prototype  
**Stage:** B5.2 — Multi-Pose Geometric Screening  
**Lessons:** 1, 2, 3.1, and 3.2  
**Status:** Completed — discrete-pose geometric screening and diagnosis; physical clearance and continuous-workspace validation pending  
**Primary Tool:** MATLAB  
**Configurations:** Original B, Modified B′, F1 Six-Face, F2 Opposite/Layered, F3 Asymmetric

---

## 1. Research Objective and Context

### 1.1 Research Question

> Which existing six-cable configurations remain geometrically feasible as the balloon translates and rotates, what causes their failures, and which configurations should inform subsequent redesign?

The system is intended to **measure the six-degree-of-freedom (6-DOF) pose of a passively moving balloon**, rather than actively control its trajectory. A configuration must permit usable cable routing across the intended motion region while retaining sufficient sensing performance.

B5.1 generated and audited five configurations. Its pairing optimisation tested geometry and the Jacobian at the **reference pose only**. B5.2 extends the geometry tests to sampled translations and rotations and diagnoses the resulting failures.

### 1.2 Scope

- Evaluate the same five fixed configurations without changing anchors, attachments, or pairing.
- Check cable–sphere and cable–cable interference at every sampled pose.
- Diagnose failing cables, cable pairs, and representative worst poses.
- Compare a smaller **Core** set and a larger **Benchmark** set.
- Establish priorities for B5.3 structure-informed redesign.

**Out of scope:** multi-pose sensing optimisation, cable tension feasibility, finite cable diameter, connector geometry, deformable balloon modelling, and continuous-workspace certification.

---

## 2. Models, Inputs, and Geometric Criteria

### 2.1 Common Geometry

| Parameter | Value |
|---|---|
| Engineering boundary | 280 × 300 × 320 mm |
| Axes | X = Length, Y = Width, Z = Height |
| Nominal balloon model | Rigid sphere, 550 mL |
| Radius used | 50.8266 mm |
| Cable count | 6 |
| Anchor points | `A_i`, world frame |
| Attachment points | `r_i`, balloon body frame |
| Reference pose | `P = [0, 0, 0]` mm, `R = I` |

For each cable and pose:

\[
S_i(q)=Rr_i,\qquad B_i(q)=P+S_i(q),\qquad D_i(q)=A_i-B_i(q).
\]

### 2.2 Core Sampling Set

- Translations: \(x,y,z\in\{-20,0,20\}\) mm; 27 centre positions.
- Orientations: zero rotation and single-axis Roll/Pitch/Yaw ±5°; 7 cases.
- Total: **189 sampled poses**.

### 2.3 Larger Benchmark Sampling Set

- Translations: \(x,y,z\in\{-50,0,50\}\) mm; 27 centre positions.
- Orientations: zero rotation and single-axis Roll/Pitch/Yaw ±10°; 7 cases.
- Total: **189 sampled poses**.

Rotation convention in MATLAB: \(R=R_zR_yR_x\). The two 189-pose sets are **different discrete samples**, not one nested point set. Comparisons describe performance on those samples, not a continuous volume fraction.

### 2.4 Cable–Sphere Criterion

For the rigid sphere and straight line from an attachment to its anchor:

\[
g_i(q)=S_i(q)^TD_i(q),\qquad g_i(q)\ge -\varepsilon_s.
\]

The numerical tolerance was \(\varepsilon_s=10^{-9}\ \mathrm{mm}^2\). A negative value beyond tolerance indicates that the line leaves the attachment into the sphere-side half-space. The quantity is a dot product in mm², **not a penetration distance**.

### 2.5 Cable–Cable Criterion

Each pose requires 15 unique pairs, \(\binom{6}{2}=15\). For finite straight-line cable segments:

\[
d_{ij}(q)=\min_{s,t\in[0,1]}\|C_i(s;q)-C_j(t;q)\|.
\]

Numerical non-contact condition:

\[
d_{ij}(q)>\varepsilon_c,\qquad \varepsilon_c=10^{-6}\ \mathrm{mm}.
\]

The existing `B3_1_segment_distance_3d_2026_11_02` MATLAB function was reused. The threshold detects ideal zero-thickness segment contact; it is **not an engineering clearance threshold**.

### 2.6 Combined Criterion

\[
G(q)=G_{\mathrm{sphere}}(q)\land G_{\mathrm{cable}}(q),
\qquad N_{\mathrm{pass}}=\sum_{q\in Q}G(q).
\]

Cable–sphere and cable–cable checks were recorded independently even if the other check failed.

---

## 3. Tested Configurations

| ID | Configuration | Origin and role |
|---|---|---|
| B | Original Experiment B | B2.2 search result; sensing reference with known cable contact |
| B′ | Modified Bprime | Same physical point sets as B; attachment pairing 5 ↔ 6 exchanged |
| F1 | Six-Face Distributed | Six-face anchor family with geometry-constrained best reference-pose pairing |
| F2 | Opposite/Layered | Opposing and layered anchor family with reference-pose pairing |
| F3 | Asymmetric | Asymmetric anchor family with reference-pose pairing |

The B5.1 selected pairings were:

- **F1:** `[4 3 2 6 5 1]`
- **F2:** `[1 2 3 4 5 6]`
- **F3:** `[1 2 3 4 5 6]`

All five configurations were held fixed throughout B5.2.

---

## 4. Lesson 1 — Core Workspace Screening

### 4.1 Verified MATLAB Results

| Configuration | SpherePass /189 | CablePass /189 | GeometryPass /189 | GeometryPass (%) | Minimum pair distance (mm) |
|---|---:|---:|---:|---:|---:|
| Original B | 189 | 108 | **108** | 57.14 | 0.0000 |
| Modified B′ | 189 | 189 | **189** | 100.00 | 21.81 |
| F1 Six-Face | 74 | 189 | **74** | 39.15 | 2.39 |
| F2 Layered | 189 | 189 | **189** | 100.00 | 40.90 |
| F3 Asymmetric | 189 | 189 | **189** | 100.00 | 23.30 |

Minimum pair distances above are rounded from the prior B5.2 Core results. Exact precision should be taken from the saved MATLAB `.mat` data.

**Key observation:** Core geometry results support three feasible sampled-pose candidates (B′, F2, F3), whereas Original B is limited by cable contact and F1 by cable–sphere routing.

### 4.2 Reference-Pose Regression Correction

An initial script incorrectly asserted that **all five** configurations must pass reference-pose geometry. This was inconsistent with the previously observed Original B cable 5–6 contact. The assertion was replaced with diagnostic output showing whether the failure was cable–sphere or cable–cable, including failed cable identifiers and distances.

**Lesson learned:** A regression assertion should enforce only previously established properties. A known-infeasible reference case must be retained as a diagnostic benchmark, not rejected as an unexpected software error.

---

## 5. Lesson 2 — Failure Diagnosis

### 5.1 Core Failure Classification

| Configuration | Total failed poses | Primary cause | Identified problem |
|---|---:|---|---|
| Original B | 81 | Cable–cable | C5–C6 contact |
| Modified B′ | 0 | None detected | No sampled-pose interference |
| F1 | 115 | Cable–sphere | C1, C3, C4 outward-routing failures |
| F2 | 0 | None detected | No sampled-pose interference |
| F3 | 0 | None detected | No sampled-pose interference |

No additional cable–cable failures appeared in the Core tests of F1, F2, or F3 at the adopted numerical contact tolerance.

### 5.2 Original B — Cable 5–6 Contact

- All **81** Core geometry failures were associated with C5–C6 contact.
- Representative worst-distance pose: **Pose 43**.
- Balloon centre: **P = [-20, 20, -20] mm**.
- Orientation: **[0, 0, 0]°**.
- Computed C5–C6 distance: **0.00000000 mm**.

This makes Original B a useful sensing baseline and a strong candidate for **targeted cable 5–6 redesign**, rather than wholesale relocation of all six cable endpoints. Pairing changes should nevertheless be checked against the full sensing Jacobian because B′ demonstrates a major sensing trade-off.

### 5.3 F1 — Cable–Sphere Failures

Individual Core cable failure counts:

| Cable | Failing sampled poses |
|---|---:|
| C1 | 68 |
| C2 | 0 |
| C3 | 71 |
| C4 | 37 |
| C5 | 0 |
| C6 | 0 |

Counts can overlap because multiple cables may fail in the same pose; their sum is not the number of unique failing poses.

The most negative recorded outward dot product occurred for:

- **Pose 132**.
- **Cable C3**.
- Balloon centre: **P = [-20, -20, 20] mm**.
- Orientation: **Yaw +5°**, Roll/Pitch 0°.
- Outward dot: approximately **−1951.20 mm²**.

**Interpretation:** The anchor direction relative to the rotated attachment normal crosses into the inward half-space for part of the motion region. In the ideal rigid-sphere model, safe outward routing corresponds to an angle of at most 90° between the outward surface normal and cable direction. Failure is driven by the *relative geometry after translation and rotation*, not simply an absolute balloon movement direction.

F1 requires attention to **C1, C3, and C4**, not only C3.

### 5.4 F2 and F3 — Geometry-Safe Core Candidates

Both passed all 189 Core poses. F2 had the larger minimum cable–cable separation in the Core set, while F3 previously showed stronger reference-pose sensing. Neither observation proves superiority across the full pose domain.

---

## 6. Lesson 3.1 — Worst-Pose Visualisation

Two representative failure poses were visualised:

1. **Original B, Pose 43:** C5–C6 contact.
2. **F1, Pose 132:** C3 cable–sphere routing failure.

The revised visualisation includes:

- Rigid sphere and labelled balloon centre `P`.
- Rotated local body axes, to show orientation change.
- Anchors `A1–A6`, attachments `B1–B6`, and cables `C1–C6`.
- Normal cables in grey and failed cables in red.
- Outward normal and actual cable exit-direction vectors for sphere failures.
- Pose/position/orientation information and a legend.

**Visualisation limitation:** Projected line crossings in a 3D image do not prove collision. The numerical finite-segment distance remains the geometric test.

---

## 7. Lesson 3.2 — Larger Benchmark Comparison

### 7.1 Verified MATLAB Results

| Configuration | SpherePass /189 | CablePass /189 | GeometryPass /189 | GeometryPass (%) | Minimum pair distance (mm) |
|---|---:|---:|---:|---:|---:|
| Original B | 186 | 108 | **105** | **55.556** | 0.000000 |
| Modified B′ | 189 | 189 | **189** | **100.000** | 16.480783 |
| F1 Six-Face | 54 | 189 | **54** | **28.571** | 0.086830 |
| F2 Opposite/Layered | 178 | 189 | **178** | **94.180** | 25.180881 |
| F3 Asymmetric | 157 | 189 | **157** | **83.069** | 14.643076 |

All larger-benchmark numerical consistency checks passed and the MATLAB results were saved as:

`B5_2_larger_benchmark_geometry.mat`

### 7.2 Core vs Benchmark

| Configuration | Core GeometryPass | Benchmark GeometryPass | Core (%) | Benchmark (%) |
|---|---:|---:|---:|---:|
| Original B | 108/189 | 105/189 | 57.143 | 55.556 |
| Modified B′ | 189/189 | 189/189 | 100.000 | 100.000 |
| F1 | 74/189 | 54/189 | 39.153 | 28.571 |
| F2 | 189/189 | 178/189 | 100.000 | 94.180 |
| F3 | 189/189 | 157/189 | 100.000 | 83.069 |

**Interpretation:** F2 and F3 satisfy all sampled Core conditions, but some sampled Benchmark poses violate cable–sphere routing. B′ passes both sampled sets geometrically, but it is not automatically a good sensing solution. F1 has substantial cable–sphere problems even in Core.

### 7.3 Important Sampling Qualification

Core and Benchmark have different spacing and rotation samples. **The Benchmark set is not a superset of the Core set.** Hence a lower passing count is not a direct count of extra failures produced by expanding the range. A stronger future test should include denser and independently sampled intermediate and combined-rotation poses.

---

## 8. Sensing Context — Not Recomputed in B5.2

The following **reference-pose** scaled Jacobian figures come from earlier B5.1 work and are included only to contextualise the geometry findings:

| Configuration | Reference \(\sigma_{\min}(H_s)\) | Reference \(\kappa(H_s)\) |
|---|---:|---:|
| Original B | 0.533600 | 3.2365 |
| Modified B′ | 0.075854 | 23.575 |
| F1 best pairing | 0.153511 | 15.130220 |
| F2 best pairing | 0.165045 | 12.761140 |
| F3 best pairing | 0.375288 | 5.416895 |

The earlier larger Benchmark investigation also found very poor worst-case conditioning for B′ (approximately \(\kappa\sim 67{,}070\)), despite its geometric success. B5.2 itself **did not calculate multi-pose sensing performance** for the five-configuration comparison.

The correct conclusion is not that F2 or F3 is optimal: **geometry feasibility and sensing quality must be evaluated jointly in subsequent work**.

---

## 9. Main Research Findings

1. **Original B is a useful sensing baseline, but not geometrically acceptable across the tested sets.** The dominant Core failure is repeatable C5–C6 contact.
2. **Modified B′ is a strong geometric reference.** It passes all sampled Core and Benchmark poses, but prior sensing analysis revealed a substantial trade-off.
3. **One tested F1 layout does not establish the merit of the six-face family.** Its specific anchor–attachment–pairing combination is vulnerable to sphere intrusion, especially cables C1, C3, and C4.
4. **F2 is a promising geometry-oriented redesign starting point.** It maintains 178/189 Benchmark passes and the largest recorded minimum cable separation among the five Benchmark configurations.
5. **F3 is another important starting point.** It passes the Core set and has comparatively strong reference-pose sensing, but its Benchmark geometry is less robust than F2.
6. **Sampling-based geometry and sensing are separate requirements.** Neither geometric pass counts nor visual uniformity alone can select a final six-cable prototype.

---

## 10. Limitations and Open Questions

- The analysis samples discrete poses, not all continuous configurations within the box.
- Simultaneous multi-axis rotations and independent intermediate positions have not yet been assessed.
- Straight, zero-thickness cables were assumed; hardware cable diameter, routing guides, and attachment interface dimensions remain unspecified.
- Tension/slack feasibility and any disturbance of passive balloon motion remain unverified.
- A rigid sphere was assumed; balloon shape changes and elastic deformation were not modelled.
- Each F1/F2/F3 family was represented by only one generated anchor/attachment set before pairing search; results cannot rank whole families statistically.
- Only reference-pose sensing figures were used for contextual comparison; multi-pose \(\sigma_{\min}\), \(\kappa\), and estimation accuracy remain to be assessed.
- Some reported minimum distances are global minima over sampled poses, which may include poses that already fail the sphere test; these are not guaranteed safe clearances for an operating configuration.

---

## 11. Decisions for B5.3 — Literature-Informed Redesign

### 11.1 Retain as Fixed References

- **Original B:** reference sensing configuration and C5–C6 local redesign case.
- **Modified B′:** geometric reference and negative sensing-trade-off case.

Do not overwrite these reference datasets.

### 11.2 Retain for Structured Redesign

- **F2:** candidate for a structured layered/opposite-face layout with a robust geometric baseline.
- **F3:** candidate for controlled asymmetric refinement, aiming to retain sensing while improving wider-range geometry.

### 11.3 Redesign Rather Than Accept Current F1

The present F1 sample has severe cable–sphere limitations. The six-face design *idea* remains an open hypothesis. Future six-face layouts should be generated using explicitly designed attachment pairing and robust outward-routing constraints, rather than judged from this single sample.

### 11.4 Planned B5.3 Families

| Family | Design hypothesis | First evaluation focus |
|---|---|---|
| S1 — Structured Layered | Retain F2's layered geometric strengths, improve rotational sensing | Multi-pose clearance and Jacobian |
| S2 — Structured Cross-Paired Distributed | Improve directional diversity with deliberate pairing and no sphere intrusion | Outward routing and pair collisions |
| S3 — Refined Asymmetric | Preserve F3's sensing strengths while enlarging geometry-feasible coverage | Worst-pose sphere margin and sensing |

These are **project-proposed hypotheses**, not configurations established as optimal by the cited literature.

---

## 12. Relevant Research Basis

- **Cheng & Lau (2023)** — *Cable Attachment Optimization for Reconfigurable Cable-Driven Parallel Robots Based on Various Workspace Conditions.* DOI: https://doi.org/10.1109/TRO.2023.3288838  
  Use: workspace-aware configuration optimisation and constraints; adapt actuation objectives to passive sensing.
- **Cheng & Lau (2022)** — *Ray-based cable and obstacle interference-free workspace for cable-driven parallel robots.* DOI: https://doi.org/10.1016/j.mechmachtheory.2022.104782  
  Use: interference-free workspace analysis beyond individual pose checks.
- **Khoshbin et al. (2022)** — *Reconfigurable fully constrained cable-driven parallel mechanism for avoiding collision between cables with human.* DOI: https://doi.org/10.1017/S0263574722000996  
  Use: physical attachment arrangements, endpoint coordinates, and structured reconfiguration ideas.

The source systems and their tension/actuation goals differ from the present passive balloon sensing problem. Methods and arrangements must be adapted and validated, not copied wholesale.

---

## 13. Reproducibility and Outputs

**Saved MATLAB artefacts:**

- `B5_1_geometry_constrained_pairing.mat` — selected F1/F2/F3 pairings.
- `B5_2_five_config_core_geometry.mat` — Core masks, distances, and summary.
- `B5_2_failure_diagnosis.mat` — failure counts and worst-pose diagnosis.
- `B5_2_larger_benchmark_geometry.mat` — Benchmark masks, comparison tables, and diagnostics.
- `B5_2_worst_pose_comparison_revised.png` — illustrative failure-case visualisation (where exported).

**Core tables and plots:** Five-configuration geometry comparison; failure heatmaps; worst-pose diagrams.

**Benchmark tables and plots:** Benchmark geometry comparison; Core vs Benchmark side-by-side bar chart.

---

## 14. Session Handoff

**Current Workstream:** A — Six-Cable Prototype  
**Completed Task:** B5.2 Multi-Pose Geometric Screening, Lessons 1–3.2  
**Next Task:** B5.3 Lesson 1 — Literature Methods and Structure Requirements  

**Verified:**

- Five-configuration Core and Benchmark geometry pass counts.
- Core failure attribution for Original B and F1.
- Worst-pose visualisation of Original B C5–C6 contact and F1 C3 inward routing.
- Saved per-pose geometric masks and pair distances.

**Pending:**

- Literature figure/coordinate extraction and selection of transferable design principles.
- Structured families S1/S2/S3 with explicit parameters and pairings.
- Multi-start candidate search and multi-pose sensing evaluation.
- Physical clearance, tension, reconstruction, and prototype verification.

**Next research question:**

> How can published structured attachment arrangements and workspace-aware optimisation methods be adapted to generate more interpretable, geometry-safe, and sensing-effective six-cable configurations for passive balloon pose estimation?

**Research principle:** Geometry feasibility is necessary; sensing quality remains central; physical implementability and passive motion must be preserved.
