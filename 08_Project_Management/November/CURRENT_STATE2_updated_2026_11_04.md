# Current Research State

**Last updated:** 2026-11-04  
**Research phase:** Phase B — Balloon-Specific Cable Sensing Design  
**Current focus:** Rapid six-cable Prototype V1.0 configuration selection, followed by flexible-balloon compatibility screening  
**Current task:** B5.1 — Configuration audit and expanded candidate design  
**Current schedule:** 2026-11-04 to 2026-11-17 (first day: half-day; remaining weekdays: approximately 4–5 h/day)  
**Primary tool:** MATLAB  
**Overall status:** Phase A methods, B1 geometry, B2 configuration comparison, B3 geometric screening, and B4.1 Jacobian/sensing-quality evaluation completed. B4.2 nonlinear forward-kinematics validation is pending and may proceed in parallel with prototype preparation.

---

## 1. Research Direction and Engineering Decision

### 1.1 Long-Term Research Goal

Develop a **cable-based sensing and measurement system** capable of estimating the position, orientation, and eventually deformation/shape of a **passively moving balloon-like object** in a simplified stomach-like environment.

The balloon is not commanded to follow a known trajectory. Motors, if used, are intended to track motion and maintain sufficiently low positive cable tension, **not to impose the balloon's trajectory**.

### 1.2 Two Distinct Research Questions

**Rigid baseline:** Can six cable-length measurements provide identifiable and sufficiently accurate local 6-DOF pose measurements over a specified experimental pose set?

**Flexible extension:** Can a configuration initially designed for a rigid spherical balloon remain geometrically and mechanically useful when attachment points move with deformation, and which motion/deformation variables can be identified from the available measurements?

### 1.3 New Near-Term Decision (2026-11-04)

**Prioritise a buildable, adjustable Prototype Configuration V1.0 rather than proving globally optimal anchor–attachment positions before hardware work.**

Sequence:

1. **B5 — Rapid Configuration Selection:** six-cable coordinates, pairing, geometric clearance and sensing evidence; preserve alternative candidates.
2. **B5.5 — Rigid-to-Flexible Compatibility Gate:** simple deformation model, attachment migration, routing, observability and hardware compatibility.
3. **B6 — Engineering Sizing:** cable lengths/strokes, loads, tension/tracking model, drums, motors and sensors.
4. **B7 — Adjustable Prototype:** repositionable anchors, replaceable attachments, calibration and optional expansion interfaces.
5. **B8 — Experimental Validation:** rigid benchmark first, flexible balloon second; ground-truth comparison.
6. **B9 — Refinement:** data-driven geometry and deformation-estimation improvement.

**B4.2 nonlinear forward kinematics and Monte Carlo remains outstanding**, but should not indefinitely block preliminary frame design. No empirical accuracy claim is allowed before estimator and hardware validation.

**Cable number:** six for the first prototype. Seven/eight may be investigated if observability, tension, or experimental evidence justifies them; do not assume extra cables automatically solve shape estimation.

---

## 2. Established Engineering Baseline

| Parameter | Current working value | Interpretation |
|---|---|---|
| Engineering boundary | 280 × 300 × 320 mm | Simplified rectangular envelope, **not** clinically verified gastric anatomy |
| Coordinate axes | X = length; Y = width; Z = height | World-frame dimensions |
| Balloon volume | 550 mL | Nominal reference |
| Rigid balloon radius | approximately 50.83 mm | Equivalent sphere |
| Rigid balloon diameter | approximately 101.65 mm | Equivalent sphere |
| Number of cables | 6 | Initial measurement configuration |
| Anchor candidate region | Six rectangular boundary faces | Idealised support/mounting region |
| Initial anchor sample set | 26 unique surface points | 3 × 3 points per face, duplicates removed |
| Attachment candidate region | Balloon surface | Body-frame material points in rigid model |
| Initial attachment sample set | 40 points | Coarse azimuth/elevation grid |
| Reference pose | P = [0,0,0] mm; R = I | Only a calibration/analysis reference |
| B3/B4 pose samples | 27 positions × 7 orientations = 189 | Discrete engineering samples, not motion trajectories |
| Proposed sensing | Cable lengths; future tension sensing | Sensor specification not final |
| Proposed actuation | Low-tension cable following | Disturbance and force balance unverified |

The test positions are P_x,P_y,P_z ∈ {-50,0,50} mm. The seven rotations are zero and independent roll/pitch/yaw ±10° cases. **Simultaneous multi-axis rotations have not yet been comprehensively sampled.**

For rigid-body modelling, anchor coordinates are world-fixed while attachment coordinates are body-fixed. The balloon moves passively without a prescribed trajectory.

### Outstanding physical definitions

- Actual mounting hardware, cable routing and pulley/guide locations.
- Cable diameter, compliance, friction, minimum separation and clearance.
- Balloon/hardware masses, centre of mass, inertia and environmental support/loading.
- Positive-tension/low-disturbance design criteria and tracking dynamics.
- Sensor resolution, bias, calibration, drift and sampling rate.
- Flexible-balloon material, pressure, fill state and attachment hardware.

---

## 3. Completed Methods — Phase A

**Status:** Core method reproduction completed. Do not repeat lessons unless required to resolve a specific new question.

| Method | Completed contribution | Recorded example/limitation |
|---|---|---|
| A1 — Tension Factor / RREF / WCC | Tension ratio and static-feasibility mathematics | TF ≈ 0.6671 for reference planar example; **not** a sensing accuracy metric |
| A2 — Feasible anchor region | Single-pose WCC inequality screening | 29,291 feasible from 68,921 samples for the reference example; not the current balloon geometry |
| A3 — Multi-pose WCC intersection | Intersected candidate anchor regions across eight reference poses | 1,005 locations in the selected experiment; seven-cable WCC is not automatically a requirement for passive six-cable sensing |
| A4 — FK and uncertainty | 8-cable 3D Jacobian, Gauss–Newton, noise, covariance, Monte Carlo and NEES | Method reproduction; different geometry and cable count from the current balloon |
| A5 — Workspace sampling | 3D pose sampling and constraint intersections | Reference-model results; not balloon-specific |

Relevant transferable methods: cable-length kinematics, finite-difference Jacobian verification, singular-value analysis, segment distances, local covariance, constrained optimisation, forward-kinematics testing and statistical error assessment.

---

## 4. Completed Balloon-Specific Research — B1 to B4.1

### 4.1 B1 — Geometry and Candidate Regions (Completed)

- Established the 280 × 300 × 320 mm engineering envelope.
- Modelled a 550 mL rigid sphere and derived its radius.
- Defined ideal anchor regions on six boundary faces; generated 26 unique candidates.
- Generated 40 body-frame spherical attachment candidates.
- Verified balloon containment, coordinate transformations and data generation.
- Saved `B1_geometry_baseline.mat`.

**Limitation:** Initial candidate sets are coarse and are not the full continuous design space; sampling and actual mounting constraints must be expanded for B5.

### 4.2 B2 — Initial Six-Cable Configurations (Completed)

| Reference | Anchor design | Attachment design | Reference-pose scaled σ_min | Reference-pose κ |
|---|---|---|---:|---:|
| Original baseline | Six face centres | Initial chosen points | 0.004393 | 490.956 |
| Experiment A | Six fixed face centres | Random selection from 40 points | 0.535345 | 3.5759 |
| Experiment B | Random selection from 26 points | Random selection from 40 points | 0.533600 | 3.2365 |

- Experiments A and B each used 20,000 single-pose random search trials (seed 42).
- Valid sampled configurations reported: A = 46; B = 75.
- B had asymmetric anchor placement with five anchors on the positive-Z boundary.
- Each cable is defined by its **row-matched anchor–attachment pair**; pairing is a design variable.
- Saved A/B parameter datasets in the existing MATLAB workflow.

**Limitations:** Reference-pose-only objective, limited spatial candidate grids, incomplete multi-pose collision/clearance information during search and no global-optimality guarantee.

### 4.3 B3.1 — 27-Position Geometry (Completed)

| Metric | Experiment A | Experiment B |
|---|---:|---:|
| Cable–sphere pass | 8/27 | 27/27 |
| Cable–cable pass | 27/27 | 0/27 |
| Combined geometric pass | 8/27 | 0/27 |

Experiment A was limited mainly by cable–sphere penetration; B showed Cable 5–6 numerical contact at all zero-rotation sampled positions.

### 4.4 B3.2 — 189-Pose Geometry (Completed)

| Metric | Experiment A | Experiment B |
|---|---:|---:|
| Cable–sphere pass | 40/189 | 186/189 |
| Cable–cable pass | 189/189 | 108/189 |
| Combined pass | **40/189 (21.2%)** | **105/189 (55.6%)** |
| Minimum sampled inter-cable distance | 6.090818 mm | approximately 0 mm |

- B: 81 cable-contact poses, all associated with Cable Pair 5–6; zero rotation and roll ±10° account for the contact cases.
- The same 189 poses were evaluated for both configurations.
- Ideal straight, zero-thickness cable assumption; no guarantee of physical or continuous-workspace safety.

Research records: `06_Research_Log/2026-11/B3_1_feasibility_notes.md` and `B3_2_feasibility_notes.md`.

### 4.5 B4.1 — Jacobian, Weak Directions, Covariance and Sensing Synthesis (Completed)

Analytical versus finite-difference Jacobian maximum error at the reference pose:

- A: 1.329 × 10^-8.
- B: 1.831 × 10^-8.

Both configurations had Jacobian rank 6 at all 189 tested poses. This proves **local first-order identifiability of the rigid model at those samples**, not globally unique reconstruction.

**Sensing metrics on each configuration's geometrically feasible samples:**

| Metric | A (40 poses) | B (105 poses) |
|---|---:|---:|
| Minimum scaled σ_min | 0.012226 | 0.204807 |
| Median scaled σ_min | 0.182628 | 0.416239 |
| Maximum scaled κ | 166.1761 | 9.1591 |
| Median scaled κ | 11.1157 | 4.4673 |
| Median position uncertainty | 0.3860 mm | 0.1657 mm |
| Worst position uncertainty | 5.7243 mm | 0.3347 mm |
| Median orientation uncertainty | 0.5663° | 0.2913° |
| Worst orientation uncertainty | 6.5895° | 0.4626° |

Assumed independent zero-mean cable-length noise standard deviation: **0.1 mm** (simulation assumption, not measured hardware performance).

**Matched comparison:** 19 poses are geometrically feasible for both A and B. B had larger σ_min in 18/19, lower κ in 18/19, lower predicted position uncertainty in 19/19, and lower predicted orientation uncertainty in 18/19.

- Generated boxchart distributions and paired uncertainty scatter plots.
- Covariance algebra checks passed at the reference pose.
- A consolidated B4.1 synthesis code block and final figures were prepared. The final synthesis's full command-window assertion output has **not been independently supplied** in the available conversation; do not claim independent verification of every final assertion.

Research log: `06_Research_Log/2026-11/B4_1_sensing_quality_evaluation_2026_11_04.md` (confirm uploaded path in GitHub).

**Scientific conclusion:** B is a stronger **current comparison baseline** on sampled ideal geometric and local sensing metrics, but its Cable 5–6 contact means **B must not be treated as build-ready**. Neither A nor B is the final six-cable layout.

---

## 5. Established Mathematical Framework

### 5.1 Rigid Cable-Length Model

For cable i:

\[
B_i=P+Rr_i,\qquad L_i=\|A_i-B_i\|.
\]

The measured length includes noise:

\[
L_{i,\mathrm{meas}}=L_i+\varepsilon_i.
\]

### 5.2 Local Measurement Jacobian and Scaling

With \(u_i=(A_i-B_i)/L_i\) and \(s_i=Rr_i\), using a **world-frame small-rotation vector**:

\[
H_i=\begin{bmatrix}-u_i^T&(u_i\times s_i)^T\end{bmatrix},\qquad
\delta L\approx H\begin{bmatrix}\delta P\\\delta\theta\end{bmatrix}.
\]

Using the characteristic length \(r_b\):

\[
S=\mathrm{diag}(1,1,1,1/r_b,1/r_b,1/r_b),\qquad H_s=HS.
\]

The scaled state perturbation \([\delta P;r_b\delta\theta]\) has units of mm in all six components. Rank 6 is a **local first-order requirement**, not a global uniqueness guarantee.

### 5.3 Local Pose Uncertainty

For independent, identical length noise with standard deviation \(\sigma_L\), a full-rank square Jacobian gives the local linearised covariance:

\[
\Sigma_{q_s}=\sigma_L^2(H_s^TH_s)^{-1},\qquad
\Sigma_q=S\Sigma_{q_s}S^T.
\]

Predicted 3D RMS error-vector norms are \(\sqrt{\mathrm{tr}(\Sigma_P)}\) (mm) and \(\frac{180}{\pi}\sqrt{\mathrm{tr}(\Sigma_\theta)}\) (degrees). These are **theoretical local uncertainty measures**, not measured RMSE.

### 5.4 Flexible Balloon Extension — Preliminary Model

For an initial low-dimensional deformation parameter \(\eta\):

\[
B_i=P+R\left[r_{i0}+d_i(\eta)\right],\qquad
L_i=\|A_i-B_i\|.
\]

A preliminary affine/ellipsoidal approximation may use:

\[
F(\eta)=\mathrm{diag}(1+\eta_x,1+\eta_y,1+\eta_z),\qquad
B_i=P+RF(\eta)r_{i0}.
\]

If *near-constant volume is a justified physical assumption*, apply \(\det F\approx1\); do **not** impose it universally on all flexible/filled balloon states. This affine model is an **engineering screening approximation**, not a validated membrane constitutive law or a model of wrinkles/local indentation.

The combined local model is:

\[
\delta L\approx H_{\mathrm{rigid}}\delta q+H_{\mathrm{def}}\delta\eta.
\]

With six lengths and more than six independent unknown pose/deformation components, simultaneous unconstrained recovery is locally underdetermined; extra measurements, known loading/volume constraints, priors or a reduced state may be needed.

### 5.5 Tension and Passive Motion

For quasi-static mechanical analysis under a specified load/support model:

\[
W(q)T+w_{\mathrm{ext}}=0,\qquad T_i\ge T_{\min}>0.
\]

**Do not assume** full-rank measurement Jacobian implies a feasible positive-tension balance for arbitrary external wrenches. Motor-assisted tracking must avoid excessive force-induced motion or deformation. Include gravity, buoyancy/support, contact, friction and dynamics as appropriate to the chosen experiment.

---

## 6. Current Plan — B5 Rapid Configuration Selection

**Status:** Active design/planning; prototype layout not yet selected.

**Primary goal:** Find a reproducible, installable, adjustable six-cable **Prototype V1.0** that supports initial experiments. Global optimality is **not** required.

### B5.1 — Audit and Expand Configuration Candidates

- [ ] Extract exact A/B 6 × 3 anchor and attachment coordinate tables and cable pairing.
- [ ] Record candidate face distribution and minimum anchor/attachment separation.
- [ ] Keep B2 A/B as baselines, not restrictions on the new search.
- [ ] Expand anchor face samples beyond the original 26-point set.
- [ ] Introduce more spatially even spherical attachment candidates.
- [ ] Define candidate configuration families and pairing as explicit design choices.
- [ ] Document manufacturability and adjustable mounting regions.

### B5.2 — Fast Geometric Screening

- [ ] Reuse B3 finite-segment/sphere interference tests over a **fixed common pose set**.
- [ ] Verify outward routing and cable–cable distances including cable thickness and hardware clearance once dimensions are defined.
- [ ] Reject or explicitly flag interference cases; track failure causes and counts.
- [ ] Distinguish a small initial **core test region** from the broader long-term workspace.

### B5.3 — Multi-Pose Sensing Ranking

- [ ] Reuse B4.1 rank, scaled σ_min, κ and local covariance calculations.
- [ ] Avoid optimising only the reference-pose condition number.
- [ ] Prioritise geometry coverage before local sensing quality, while retaining alternatives with different trade-offs.
- [ ] Compare candidates on the same target samples and common illustrative noise model.

### B5.4 — Shortlist and Limited Local Refinement

- [ ] Retain several geometrically diverse configurations instead of one random-search winner.
- [ ] Refine promising anchor, attachment and pairing choices within permitted mounting regions.
- [ ] Evaluate on an **independent** pose set with combined rotations and additional positions.
- [ ] Record algorithm, random seed, search budget, constraints and failures.

### B5-V1 — Prototype V1.0 Decision (within B5)

- [ ] Select a candidate **conditionally**, with explicit usable pose range and remaining risks.
- [ ] Save 6 × 3 anchor coordinates, 6 × 3 attachment coordinates and exact cable pairing.
- [ ] Record cable-length ranges, minimum observed clearance, local sensing metrics and installation adjustability.
- [ ] Flag any unverified tension, contact, calibration or nonlinear-estimator criteria as pending.
- [ ] Do not label any numerically interfering configuration as fully build-ready.

**Numbering rule:** `B5-V1` is the final selection gate within B5. `B5.5.1`–`B5.5.5` are reserved exclusively for the separate flexible-transition phase.

---

## 7. New Phase B5.5 — Rigid-to-Flexible Transition and Compatibility Gate

**Status:** Planned after a rigid six-cable V1 candidate is available; before final motor/drum sizing.

This is a **limited pre-prototype compatibility screen**, not a full nonlinear soft-body reconstruction project.

### B5.5.1 — Flexible Balloon Model and Assumptions

- [ ] Select a low-dimensional initial deformation model and state its validity limits.
- [ ] Start with reference body positions \(r_{i0}\), affine deformation \(F(\eta)\), and optional justified volume constraint.
- [ ] Specify plausible deformation cases for simulation; do not present arbitrary ranges as clinical measurements.
- [ ] Record future extension toward nonlinear inflation/membrane mechanics.

**Theory:** Continuum kinematics \(x=F X\), deformation gradient, volume ratio \(J=\det F\); nonlinear spherical balloon inflation laws for later material modelling.

**Reading starting points:** *Gent models for the inflation of spherical balloons* — DOI `10.1016/j.ijnonlinmec.2014.05.016`; standard continuum mechanics for \(F\) and \(J\). The affine ellipsoid is a project simplification, **not** a direct prediction of that paper.

### B5.5.2 — Attachment Migration

- [ ] Calculate \(B_i=P+RF(\eta)r_{i0}\) over deformation cases.
- [ ] Quantify \(\Delta B_i=R(F-I)r_{i0}\) relative to the rigid reference at the same pose.
- [ ] Distinguish material-attached points from freely sliding cable contacts.
- [ ] Assess local reinforcement, strain concentration, sealing and replaceable hardware.

**Theory:** Lagrangian material points and deformation mapping. Reference: nonlinear membrane/soft-robot kinematics; use the spherical balloon inflation paper above as background, not as validation of fastening hardware.

### B5.5.3 — Deformed-Surface Routing and Clearance

- [ ] Recompute cable lengths and pairwise segment distances for each deformation/pose sample.
- [ ] Replace rigid sphere penetration checks with cable–deformed-surface checks.
- [ ] Include finite cable diameter and mounting clearance where known.
- [ ] Identify whether anchor, attachment or pairing modifications are required.

**Theory:** Finite-segment geometry and segment/triangulated-surface intersection; reuse verified B3 routines where applicable. Start from the B3 geometric methodology and CDPR interference-avoidance studies cited in the November TODO.

### B5.5.4 — Rigid–Deformation Observability

- [ ] Differentiate cable lengths with respect to rigid pose and deformation parameters.
- [ ] Compute \(H_{\mathrm{total}}=[H_{\mathrm{rigid}}\;H_{\mathrm{def}}]\).
- [ ] Evaluate rank, singular vectors and null space for sampled states.
- [ ] Explicitly report which parameter combinations cannot be resolved from six lengths.
- [ ] Decide whether a reduced deformation model, additional measurements or 7/8 cables are justified.

**Theory:** Local linear identifiability via Jacobian rank/null space and Fisher information; soft-robot shape reconstruction literature as model/measurement context. See DOI `10.1089/soro.2024.0158` for distributed strain-sensing methods, **not** proof that six cables reconstruct an arbitrary balloon.

### B5.5.5 — Hardware Compatibility Gate

- [ ] Decide what can be retained: external frame, anchors, routing, motors and sensor architecture.
- [ ] Decide what may need adjustment: material attachments, pairing and cable count.
- [ ] Record flexible-specific cable stroke and force considerations for B6.
- [ ] Reserve modular mounts and optional additional measurement channels.

**Decision:** Keep V1 geometry if the stated flexible screening tests pass; otherwise revise only the necessary elements and record the remaining uncertainty. This gate need not complete full shape reconstruction.

---

## 8. Planned Engineering and Experimental Phases

| Phase | Main deliverable | Status |
|---|---|---|
| **B6 — Engineering Sizing** | Cable strokes, support/load assumptions, tension feasibility, drum/motor speed/torque, sensor specifications and initial BOM | Planned |
| **B7 — Adjustable Prototype** | Adjustable anchor rails/plates, replaceable attachments, tracked cables, calibration and expandable interface | Planned |
| **B8 — Experimental Validation** | Rigid ground-truth pose error and calibration; then flexible balloon tests and disturbance analysis | Planned |
| **B9 — Configuration Refinement** | Data-driven placement adjustment, deformation-state modelling and extended estimation | Planned |

**Sizing dependencies:** Straight cable length is \(\|A_i-(P+Rr_i)\|\) (or its flexible counterpart). Total routed length and spool stroke require guides, wrap, reserve and retraction model. Tension is **not** fixed by rigid-body mass alone: external support, buoyancy, friction, cable geometry and allowable disturbance must be modelled. Motor selection follows torque/speed calculations and margin checks; do not lock a motor from an unverified tension assumption.

**Mechanical model starting points:** CDPR static wrench equilibrium and tension-feasibility literature; the verified November TODO contains the planned DOI index and task-to-reference mapping.

---

## 9. Next Two-Week Schedule (Only the Current Planning Window)

**Planning window:** 2026-11-04 to 2026-11-17; November 4 is **half a research day**. Other weekdays are approximately 4–5 h; weekends are not mandatory work days.

| Date | Main focus | Target output |
|---|---|---|
| Wed Nov 4 | B5 configuration audit and V1 acceptance conditions | A/B coordinate/pairing tables and constraints |
| Thu Nov 5 | Expanded anchor and attachment candidates | Candidate sets and validity tests |
| Fri Nov 6 | Configuration families and pairing design | Diverse candidate-generation code |
| Mon Nov 9 | Multi-pose geometric screening | Feasibility/failure/clearance results |
| Tue Nov 10 | Sensing quality ranking | Candidate comparison and shortlist |
| Wed Nov 11 | Local refinement and independent pose validation | Improved candidates with caveats |
| Thu Nov 12 | Conditional rigid Prototype V1.0 selection | Coordinates, pairing, initial stroke estimates |
| Fri Nov 13 | B5.5.1 flexible deformation model | Documented assumptions and preliminary model |
| Mon Nov 16 | B5.5.2–B5.5.3 attachment motion/routing | Migration and interference checks |
| Tue Nov 17 | B5.5.4–B5.5.5 observability and compatibility gate | Flexible adaptation decision and B6 handoff |

**Do not pre-plan later days in detail** until this two-week block has been reviewed. A failed gating condition must be documented, not silently bypassed to meet a date.

---

## 10. Key Open Research Questions and Scientific Safeguards

1. Does the new six-cable configuration avoid cable–sphere/cable–cable interference over its **declared core experimental pose set**?
2. What physical clearance is needed for cable diameter, mounting tolerances and routing hardware?
3. Are the rigid 6-DOF pose Jacobian and local uncertainty acceptable for the intended experiment?
4. What does the nonlinear estimator actually recover under realistic noise and geometry errors (B4.2)?
5. Are six positive tensions mechanically achievable for the chosen support/load cases without disturbing passive motion?
6. Do flexible attachment displacements invalidate the rigid calibration or introduce ambiguous measurements?
7. Can six cable lengths distinguish rigid pose and additional deformation variables without priors? **Not generically when the number of independent unknowns exceeds six.**
8. Can anchors be retained on an adjustable frame, while attachments remain replaceable and the system expandable?
9. Are engineering assumptions, chosen acceptance tolerances and literature-supported physical claims clearly distinguished?
10. Do not claim continuous-workspace coverage, clinical realism, real pose accuracy or global optimality from this initial sampled ideal model.

---

## 11. Repository Pointers and Update Conventions

**Project:** `xhua314-westfish/cable-robot-research`

**Current management files (user-organised November folder):**

- `08_Project_Management/November/` — current November TODO and the new two-week weekly plan. Exact TODO filename should follow the manually committed GitHub file; do not duplicate the old long-form October–November TODO.
- `08_Project_Management/November/weekly_plan_nov_04_17_2026.md` — Nov 4–17 execution plan (confirm committed).
- `CURRENT_STATE2.md` — this high-level research state.

**Supporting files:**

- `03_Simulation/MATLAB/workspace definition/` — source MATLAB modelling and numerical evaluations.
- `06_Research_Log/2026-11/` — B2/B3/B4 research notes and future B5/B5.5 research logs.
- `05_My_Research/` — detailed sensing design, flexible model and eventual prototype definitions.
- `02_Paper_Reading/Literature_Review/` — literature-to-method records and full bibliographic checks.

**Reference starting points (task-matched):**

| Focus | Literature or theory | Identifier |
|---|---|---|
| Anchor–attachment and workspace constraints | Cheng & Lau, cable attachment optimisation for reconfigurable CDPR | DOI `10.1109/TRO.2023.3288838` |
| Flexible balloon constitutive background | Gent models for inflation of spherical balloons | DOI `10.1016/j.ijnonlinmec.2014.05.016` |
| Model-based soft-body shape reconstruction | Distributed strain sensing of soft robots | DOI `10.1089/soro.2024.0158` |
| Tension sizing | Static wrench equilibrium, positive cable tension, support/load assumptions | Theory; verify task-specific sources before sizing |

These references provide modelling frameworks; they do not directly validate the simplified gastric envelope, the six-cable sensing configuration, or the affine flexible-balloon approximation.

### Daily research workflow

Research question → literature/theory → minimal MATLAB implementation → numerical checks → physical interpretation → limitations → GitHub archive. Update files **one at a time** by manual confirmation, as agreed.

---

## 12. Immediate Next Action and Milestone

**Next task:** B5 configuration audit and expanded design-space definition. Extract exact A/B anchor–attachment coordinates and pairing, identify current interference mechanisms, and define the **core experimental pose set** and **conditional Prototype V1.0 acceptance criteria**.

**Immediate deliverables:** A/B configuration tables, expanded candidate-region specification, geometric clearance tests, a shortlist and provisional V1.0 handoff record. No hardware purchase or final motor specification is authorised merely by this state document.

**Milestone:** Numerically justified, **adjustable and buildable** six-cable prototype reference, with a documented flexible-compatibility gate before detailed engineering sizing. Full experimental validation and flexible shape reconstruction remain future tasks.
