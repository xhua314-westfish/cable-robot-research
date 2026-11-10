# B5.3–B5.6 Updated Research Plan — Twelve-Rail-Constrained Six-Cable Sensing

**Updated:** 2026-11-10  
**Research workstream:** Six-cable passive-balloon pose sensing  
**Status:** Revised plan; B5.3 Lesson 2 not yet numerically verified  
**Change request:** All **12 edges** of the rectangular engineering boundary are allowable anchor rails. This supersedes the provisional eight-rail design only.

---

## 1. Research Objective and Scope

Develop an installable six-cable sensing configuration for a passive spherical balloon model. Anchor points must lie on one of twelve structural frame edges; each can move along its assigned rail. Balloon attachment locations remain on the balloon surface. Cable pairing is a separate discrete design variable. Evaluate geometric feasibility first, then robust six-DOF sensing, then practical mounting, finite cable diameter, length stroke, and low-tension operation.

**Not the research objective:** actively control the balloon trajectory or assume that the balloon follows a known path.

### Fixed engineering inputs

| Variable | Value / convention | Status |
|---|---|---|
| Boundary | 280 (X/Length) × 300 (Y/Width) × 320 (Z/Height) mm | Existing B1 engineering approximation |
| Balloon radius | 50.8266 mm (nominal spherical model) | Existing B1 baseline |
| Cable count | Six | Current prototype workstream |
| Core positions | X,Y,Z ∈ {-20,0,20} mm | Existing sampling definition |
| Core orientations | Identity and single-axis ±5° rotations | Existing sampling definition |
| Core pose count | 27 × 7 = 189 | Verified sampling |
| Larger benchmark positions | X,Y,Z ∈ {-50,0,50} mm | Existing benchmark |
| Larger benchmark orientations | Identity and single-axis ±10° rotations | Existing benchmark |
| Larger benchmark count | 189 | Verified sampling |
| Anchor installation | All **12 box edges** (rail-constrained) | **New engineering constraint** |
| Physical rail end stops, sliders, connectors, cable diameter | To be specified | Open engineering requirements |

The Core and larger benchmark are **sampled test sets**, not a validated continuous gastric workspace.

---

## 2. Retained Evidence — B1 to B5.2

Do not overwrite historical simulation data. Previous face-interior anchor grids and the F1–F3 configurations remain useful as **method-development and geometry/sensing comparison baselines**; their anchor points are not automatically compliant with the new twelve-rail constraint.

| Configuration | Core geometry pass / 189 | Larger benchmark pass / 189 | Reference scaled σ_min | Reference κ | Status |
|---|---:|---:|---:|---:|---|
| Original B | 108 | 105 | 0.533600 | 3.2365 | Strong reference sensing; cable 5–6 contact dominates Core failures |
| Modified B′ | 189 | 189 | 0.075854 | 23.575 | Geometry reference; poorer sensing, especially in wider benchmark |
| F1 six-face | 74 | 54 | 0.153511 (best B5.1 pairing) | 15.1302 | Reference design only; many cable–sphere failures |
| F2 layered | 189 | 178 | 0.165045 | 12.7611 | Layered geometry inspiration, **not yet rail-compliant** |
| F3 asymmetric | 189 | 157 | 0.375288 | 5.4169 | Sensing/geometry inspiration, **not yet rail-compliant** |

**Failure evidence:** Original B has 81 Core poses with cable 5–6 contact. F1 has 115 Core sphere-failure poses, involving primarily cable 1, 3, and 4; individual failure counts can overlap on one pose. B′, F2, and F3 passed all 189 sampled Core poses under ideal zero-thickness straight-cable checks.

**Important:** A passing pose is not proof of continuous workspace feasibility, positive cable tension, estimation accuracy, or safe real-world cable clearance.

---

## 3. New Geometric Model — Twelve Edge Rails

Let the half-dimensions be h_x=140, h_y=150, h_z=160 mm. The frame has twelve distinct edges:

- **R1–R4 (four Z-rails):** (x,y) ∈ {(-h_x,-h_y),(h_x,-h_y),(-h_x,h_y),(h_x,h_y)}, z∈[-h_z,h_z].
- **R5–R8 (four X-rails):** (y,z) ∈ {(-h_y,-h_z),(h_y,-h_z),(-h_y,h_z),(h_y,h_z)}, x∈[-h_x,h_x].
- **R9–R12 (four Y-rails):** (x,z) ∈ {(-h_x,-h_z),(h_x,-h_z),(-h_x,h_z),(h_x,h_z)}, y∈[-h_y,h_y].

For an anchor on rail ρ_i ∈ {1,…,12}:

\[
A_i(\rho_i,t_i)=E^{(0)}_{\rho_i}+t_i\big(E^{(1)}_{\rho_i}-E^{(0)}_{\rho_i}\big),\quad 0\le t_i\le1.
\]

An attachment is a body-frame point r_i on the spherical balloon, \(\|r_i\|=r_b\). Pairing π is a permutation of six attachment identities. Therefore

\[
\mathcal C_6=\{(A_i(\rho_i,t_i),r_{\pi(i)})\}_{i=1}^6.
\]

**Baseline sampling only:** 5 uniformly spaced samples per rail, including endpoints. This yields 12×5=60 rail-sample records, but **44 unique spatial coordinates**: 12×3 interior edge samples + 8 corners. Each corner belongs to three rails and must retain rail-membership metadata. Future optimization may use continuous t_i rather than five discrete samples.

### Mounting constraints requiring future engineering values

- Rail-end exclusion zones and slider dimensions; physically achievable 0≤t_i≤1 is not guaranteed at the endpoints.
- Minimum distance between anchors, including anchors on intersecting rails.
- Restrictions on multiple anchors sharing one rail or sliding carriage.
- Clearance between pulley/guide, balloon, frame, and other cable hardware.
- Whether rails are fixed before operation (default prototype assumption) or reconfigured during operation (a separate, future mechanism).

A frame corner can appear under three rail IDs but must not be treated as three independent physical anchor locations.

---

## 4. Updated Lessons and Deliverables

### B5.3 Lesson 2 — Twelve-Rail Candidate Region (CURRENT)

**Research question:** How can anchor placement be restricted to all twelve physically installable frame edges while retaining a parameterized model for later optimization?

**Method:** Define twelve segment start/end coordinates; verify that each segment is exactly one full frame edge; sample 5 positions per rail; retain both raw rail IDs and deduplicated 3D coordinates with 1-to-many rail memberships; visualize X/Y/Z rails; save `B5_3_12rail_geometry_baseline.mat`.

**Required verification:** 12 unique rails (4 X, 4 Y, 4 Z), 60 raw records, 44 unique points, 8 corners with three memberships each, all samples on correct edges; dimension consistency; no hidden eight-rail assumptions.

**Decision enabled:** Fixed, physically meaningful permissible anchor domain for S1/S2/S3.

### B5.3 Lesson 3 — Structured Rail Assignment Families

**Research question:** Which rail-assignment structures provide interpretable and diverse six-cable layouts?

Define **design hypotheses**, not claimed optimal layouts:

- **S1 Layered:** assign anchors across upper/lower edge rails with rail diversity, inspired by F2. Test X/Y horizontal edges and vertical edges in controlled combinations.
- **S2 Distributed / Controlled Cross-Pairing:** spread anchor assignments around the frame, then permit only outwards-facing and clearance-verified attachment pairings. Projected visual crossing is not automatically 3D contact.
- **S3 Rail-Constrained Asymmetric:** allow bounded asymmetry and selective clustering but enforce connector separation and multi-pose geometry; learn from F3 and Original B without copying their noncompliant anchor coordinates.

Keep rail identity and axial position separately. Propose a small family parameter grid and generate **multiple** layouts per family with fixed seeds. Verify no duplicate physical anchors or invalid rail assignments.

**Output:** `B5_3_12rail_configuration_families.mat` with rail IDs, t_i, 6×3 anchor matrices, family metadata, and traceable seeds.

### B5.3 Lesson 4 — Attachment and Pairing Construction

For each anchor layout, select six attachment points from retained 40/100 candidate sets or a declared union; specify candidate set provenance. Pair anchors to attachments using a geometry-first feasibility screen (sphere outward condition and 15 finite-segment cable pairs at the reference pose), then compare the scaled six-DOF Jacobian. Avoid a greedy pairing decision being misrepresented as a global optimum.

**Output:** multiple complete initial 6-cable candidate configurations with coordinate/pairing tables; no premature winner.

### B5.4 Lesson 1 — Shared Evaluation Function

Use exactly the same geometry and scaled Jacobian conventions for all candidates. Evaluate Core and larger benchmark sets. Record sphere failures by cable, contacts by cable pair, finite-segment distance, cable lengths, rank, min singular value, max condition number, and noise propagation (where assumed). Distinguish reference-pose results from Core worst-case and Benchmark results.

**Geometry-first requirement:** candidates failing hard geometry requirements cannot win based on sensing. Choose an explicit policy for Core acceptance before searching; maintain benchmark for robustness comparisons.

### B5.4 Lesson 2 — E1 Anchor/Rail-Position-Only Study

Hold attachment coordinates and pairing fixed. Adjust **rail assignment ρ** in a declared subset and/or continuous position **t** along assigned rails. Prefer a two-part test: (a) move along fixed assigned rails, then (b) change rail assignments. The distinction avoids hiding a categorical structural change inside continuous tuning.

**Measure:** geometry pass counts, min clearance, worst-Core σ_min, condition number.

### B5.4 Lesson 3 — E2 Attachment-Only Study

Hold rail assignments/anchor coordinates and pairing fixed. Change six attachment locations on the balloon surface, respecting spacing and surface constraints. Use the same sample budget and pose sets as E1 where feasible.

### B5.4 Lesson 4 — E3 Pairing-Only Study

Hold the six anchors and six attachment positions fixed; enumerate up to 6!=720 permutations. Apply geometry constraints before ranking sensing metrics. Preserve unmodified baseline for comparisons.

### B5.4 Lesson 5 — E4 Joint Optimization

Combine rail ID/position, sphere attachment coordinates, and pairing. Use multistart or staged discrete-continuous optimization. State objective and constraints before implementation; report whether outcomes depend on seed and search budget.

**Primary proposed objective (subject to all Core hard constraints):**

\[
\max_{\mathcal C_6}\;\min_{q\in Q_\mathrm{core}}\sigma_{\min}(H_s(q;\mathcal C_6)).
\]

Secondary metrics: worst κ, sensing error under explicitly assumed cable-length noise, clearance, rail distribution, assembly complexity, stroke, and tension-related practical constraints. Do not replace hard geometric constraints with arbitrary weighted penalties alone.

### B5.4 Lesson 6 — Fair Comparison and Independent Checks

Compare E0/E1/E2/E3/E4 under matched Core/Benchmark protocols; validate winners on additional intermediate positions, combined rotations and smooth paths. Report whether better Core performance harms the wider benchmark or installation practicality. Retain Pareto candidates rather than forcing an unsupported single optimum.

### B5.5 — Measurement Validation

Test nonlinear pose reconstruction from six cable lengths, identifiability near singular poses, independent unseen poses, and error sensitivity to modeled measurement noise. Distinguish predicted uncertainty from measured physical accuracy.

### B5.6 — Prototype V1.0 Decision

Confirm permitted rail hardware, anchor hardware/end-stop margins, attachment connectors, finite-diameter cable clearance, required sensor travel, low positive tension and passive motion disturbance. Select a prototype candidate only after documenting open risks and hardware constraints. Further B6 tension and actuator/sensor work is not cancelled.

---

## 5. Controlled Comparison Matrix

| Experiment | Rail choice ρ | Rail coordinate t | Attachments r | Pairing π | Question |
|---|---|---|---|---|---|
| E0 | Fixed | Fixed | Fixed | Fixed | Reproducible initial baseline |
| E1a | Fixed | Variable | Fixed | Fixed | How much can sliding alone improve performance? |
| E1b | Variable | Variable | Fixed | Fixed | How much does rail reassignment contribute? |
| E2 | Fixed | Fixed | Variable | Fixed | Effect of balloon attachment positions |
| E3 | Fixed | Fixed | Fixed | Variable | Effect of cable pairing |
| E4 | Variable | Variable | Variable | Variable | Joint design versus controlled improvements |

**Comparison rule:** Every experiment must log the fixed/changed variables, initialization, random seed if any, sample budget, same Core/Benchmark pose definitions, same Jacobian scaling, geometry tolerances, and constraints. E1–E3 isolate first-order design interventions; coupling and interaction are assessed in E4.

---

## 6. Acceptance Framework

**Hard geometric and practical constraints:** anchor on permitted rail; unique physically realizable mounting positions; no cable segment penetrating rigid sphere; no cable–cable contact and later adequate finite-diameter clearance; no impossible cable lengths; no invalid fastener/slider placement (hardware data pending).

**Sensing requirements:** full-rank scaled Jacobian at required Core poses, sufficiently strong worst-case σ_min, acceptable worst-case condition number, and validated reconstruction error. Quantitative thresholds must be justified by sensor noise, desired accuracy and physical design, not invented beforehand.

**Auxiliary/diagnostic metrics:** minimum anchor separation, attachment separation, direction similarity, rail diversity, layout regularity, and broader-benchmark feasibility. Avoid treating visual projected crossing as a collision test.

---

## 7. Immediate Numerical Verification for Revised Lesson 2

Expected MATLAB output from the twelve-rail geometry script:

```text
Valid rail segments: 12 / 12
X-axis rails: 4
Y-axis rails: 4
Z-axis rails: 4
Raw rail candidate samples: 60
Unique rail candidate points: 44
Corner points (three rail memberships): 8
All twelve-rail geometry checks passed.
```

**Expected plots:** one 3D box-edge plot with 12 rail labels and distinct X/Y/Z rail colors; candidate locations clearly shown; legend inside where feasible.

**Next research decision:** Only after verifying the twelve rails, proceed to rail assignment families; do not quietly use the previous eight-rail `.mat` or the face-interior 98-point anchor set as the new allowable installation set.

---

## 8. Session Handoff

**Completed:** B1–B5.2; B5.3 Lesson 1 literature method study; B5.1 configuration-family methods and pairing tests.  
**Active:** B5.3 Lesson 2, corrected to **twelve installable frame-edge rails**.  
**Superseded:** Provisional eight-rail assumption, previous eight-rail Lesson 2 code and `B5_3_rail_geometry_baseline.mat` if created.  
**Preserved:** All B1–B5.2 historical models, results and logs as comparison baselines.  
**Next:** Verify 12 edge segments → 60 raw samples → 44 unique points → rail identity mapping; then B5.3 Lesson 3 structured rail assignments.  
**Research principle:** *Geometry must be physically installable; multi-pose sensing quality and geometric safety must be evaluated together.*
