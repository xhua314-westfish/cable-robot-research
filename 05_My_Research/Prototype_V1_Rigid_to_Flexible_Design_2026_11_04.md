# Prototype V1.0 — Six-Cable Configuration and Rigid-to-Flexible Design

**Version:** 0.1 (engineering requirements draft)  
**Date:** 2026-11-04  
**Research phase:** B5 / B5.5 — Prototype-first configuration selection and flexible-balloon compatibility  
**Status:** Design requirements defined; Prototype V1.0 coordinates **not yet selected**  
**System intent:** Passive balloon sensing with motor-assisted low-tension cable tracking; **not active trajectory control**.

> **Role of this document:** Define the engineering handoff from six-cable rigid-body configuration selection (B5) to flexible-balloon compatibility checks (B5.5) and engineering sizing (B6). It supplements, rather than replaces, `Rigid_Body_Sensing_Design.md` and `Sensing_Objective_v0.2.md`. Daily progress belongs in the November Weekly Plan.

## 1. Design Decision and Scope

**Design objective:** Select a *good-enough, physically implementable, reconfigurable* six-cable layout for early prototyping—not a mathematically proven global optimum. Freeze a documented V1.0 geometry for first-pass cable-length and motor sizing while preserving options for later adjustment.

**In scope now:** Six-cable anchor/attachment placement; cable correspondence; finite-sample geometry and sensing tests; low-force mounting principles; first-pass deformation compatibility; parameter handoff to B6.

**Not claimed:** Continuous sensing workspace, physical clearance, experimental pose accuracy, validated membrane properties, clinically representative gastric motion, or full flexible-body shape reconstruction.

**Dependency and sequence:**

1. **B5:** Candidate-generation and screening → choose rigid Prototype V1.0 for a declared *core test-pose set*.
2. **B5.5:** Test whether that same hardware concept remains useful when the sphere becomes deformable. A revision may be required.
3. **B6:** Begin preliminary cable length/travel/tension/drum/motor/sensor sizing; retain reserves for flexible model uncertainties.
4. **B7–B9:** Build adjustable rig; calibrate; compare rigid vs flexible experiments; refine layout and estimation.

**Timing rule:** Preliminary frame design can proceed in parallel, but final reel/motor specifications await credible load, travel, speed and tension assumptions.

## 2. Verified Starting Baseline (B1–B4.1)

| Parameter | Established engineering baseline |
|---|---|
| Engineering cavity | Axis-aligned box 280 × 300 × 320 mm; X=Length, Y=Width, Z=Height |
| Initial balloon | 550 mL rigid equivalent sphere; radius ~50.83 mm |
| Cable number | 6 independent length measurements |
| Current anchor candidates | 26 discrete points on six box faces |
| Current attachment candidates | 40 sampled points on sphere surface |
| B3.2 pose samples | 27 translations × 7 individual-axis orientations = 189 poses |
| A geometric pass | 40/189 (ideal zero-thickness straight segments) |
| B geometric pass | 105/189; Cable Pair 5–6 numerical contact in 81 poses |
| A median scaled minimum singular value | 0.182628 over its 40 feasible poses |
| B median scaled minimum singular value | 0.416239 over its 105 feasible poses |
| A/B median condition number | 11.1157 / 4.4673 over their respective feasible poses |
| A/B median predicted position uncertainty | 0.3860 / 0.1657 mm using assumed σ_L = 0.1 mm |
| A/B median predicted orientation uncertainty | 0.5663° / 0.2913° using the same hypothetical noise |
| Common feasible poses | 19; B predicted position uncertainty lower in 19/19, orientation lower in 18/19 |

**Interpretation:** Experiment B is a useful *comparison baseline*, not an acceptable final hardware arrangement: the Cable 5–6 contact must be addressed. Its better medians do not establish feasibility at zero rotation, a practical core test condition.

**Coordinate sources:** `B2_6cable_experiment_A.mat` (`config6.A`, `config6.r`) and `B2_experiment_B_results.mat` (`resultB.A`, `resultB.r`). These exact 6×3 coordinates and row-wise cable pairings must be copied into the V1.0 configuration record after selection; do not invent them from aggregate performance data.

## 3. B5 — Rapid Six-Cable Configuration Selection

### B5.1 Configuration audit and design variables

For cable *i*:

\[
\mathcal C_6=\{(A_i,r_{i0})\}_{i=1}^{6},\quad A_i\in\Omega_A,\quad \|r_{i0}\|=r_b.
\]

Each row defines **one cable** and its unique anchor–attachment correspondence. An assignment permutation changes cable geometry even if the two unpaired point sets remain the same.

**Method:** Audit A/B coordinates, mounting face labels, minimum anchor/attachment spacing and routing constraints. Generate alternative spatial layout families rather than only perturbing B. Include six-face distributed, layered/opposite-face, asymmetric, and altered-pairing candidates; families are candidate-generation heuristics, not literature-proven optimum layouts.

**Evidence/theory:** Constrained cable attachment placement and interference-free workspace formulations in Cheng & Lau [R1]; general CDPR kinematics in Pott [R5].

**Deliverable:** `B5_1_configuration_audit.csv` or `.mat`, including coordinate system, units, 6×3 A/r, pairing ID and mount-face labels.

### B5.2 Expand candidate regions without exhaustive search

**Anchor:** compare existing 26-point 3×3 face grid with a 5×5 face grid (98 unique surface points for this rectangular box); where installation permits, refine continuously on mounting planes/rails.

**Attachment:** compare existing 40-point latitude/longitude sample with a larger approximately uniform surface sample (e.g., Fibonacci sphere). Preserve unique, separated physical mounting locations and accessible attachment hardware.

\[
\|A_i-A_j\|\ge d_{A,\min},\qquad
\|r_{i0}-r_{j0}\|\ge d_{r,\min}\quad (i\ne j).
\]

The required physical separations are **undetermined** until mounting hardware is chosen. Candidate counts and Fibonacci sampling are *engineering search choices*, not numerical values from [R1].

**Deliverable:** Expanded candidate datasets and a visual check of coverage and mount accessibility.

### B5.3 Staged geometric screening

Rigid pose geometry:

\[
B_i(q)=P+Rr_{i0},\qquad
C_i(t;q)=B_i(q)+t\,[A_i-B_i(q)],\quad 0\le t\le1.
\]

**Evaluate in sequence:** valid mounting, unique/separated attachment points, positive cable lengths, sphere containment, cable–sphere nonpenetration, segment–segment distance, cable routing and mount accessibility. Store *which cable and which pose failed*, not just a binary score.

\[
d_{ij}(q)=\min_{s,t\in[0,1]}\|C_i(s;q)-C_j(t;q)\|.
\]

For physical cables, a proposed centerline clearance check is

\[
d_{ij}(q)\ge\frac{d_i+d_j}{2}+c_{\mathrm{mount}},
\]

where the diameters and extra clearance must be specified from hardware evidence. The zero-thickness numerical contact threshold from B3 is **not** a validated physical clearance margin. Cable–sphere checks must likewise account for cable radius, local connector hardware and contact exclusions.

**Pose policy:** Declare a smaller *core commissioning set* and a broader target set. Preserve the original 189 poses for comparable reporting; do not imply sampled feasibility equals continuous-workspace coverage. Core zero-rotation feasibility is particularly important because B failed at all 27 zero-rotation positions.

**Evidence/theory:** Segment-distance geometry; interference-free constraints in [R1]; reconfigurable cable–cable collision mitigation in Youssef & Otis [R2]. [R2]'s actively controlled, rail-based robot is *not* a direct model of passive balloon sensing.

### B5.4 Assess sensing quality only after geometry screening

For rigid pose, let \(u_i=(A_i-B_i)/L_i\), \(s_i=Rr_{i0}\). For a **world-frame infinitesimal rotation perturbation**:

\[
H_i=\begin{bmatrix}-u_i^T & (u_i\times s_i)^T\end{bmatrix},\qquad
H_s=H\,\mathrm{diag}(1,1,1,1/r_b,1/r_b,1/r_b).
\]

Evaluate \(\mathrm{rank}(H_s)\), \(\sigma_{\min}(H_s)\), \(\kappa(H_s)\), and predicted covariance (only if full rank and under a declared noise model):

\[
\Sigma_q\approx (H^T\Sigma_L^{-1}H)^{-1}.
\]

**Decision strategy:** First require defined *core* geometry and a nondegenerate Jacobian, then prefer broader geometric coverage and better worst-case sensing quality. Report medians and worst cases. Keep several non-dominated designs instead of inventing arbitrary weighted scores. Use identical poses and noise assumptions across candidates.

**Evidence/theory:** Singular-value/least-squares sensitivity; local Fisher information \(H^T\Sigma_L^{-1}H\) (E-optimal weakest-direction reasoning). This is a mathematical basis—not an experimentally established precision specification.

### B5.5 Select and freeze Prototype V1.0 for a first build

**Minimum handoff record:**

- Six anchor coordinates (world frame, mm), six nominal attachment coordinates (balloon/body reference, mm), numbered one-to-one cable pairing.
- A schematic and mount-face/accessibility notes.
- Core and extended pose sets; pose-level geometry pass/fail with minimum clearances.
- Rank, minimum singular value, condition number and theoretical pose uncertainty under explicitly assumed sensor noise.
- Preliminary rigid geometric cable lengths and travel ranges; independent verification samples.
- Adjustable mount locations and limits; exact assumptions and known unverified physical constraints.
- Version lock `Prototype_V1_0` plus at least one alternative candidate.

**Go/no-go:** A candidate may be released for *limited, supervised prototype commissioning* if its specified core use envelope is interference-free under stated mechanical dimensions, sensor geometry is locally identifiable there, and remaining tension/force issues are explicitly carried into B6. Do **not** claim validated low-disturbance passive operation or a feasible full anatomical workspace.

## 4. B5.5 — Rigid-to-Flexible Balloon Transition

**Purpose:** Test compatibility *before locking expensive hardware*, without delaying the prototype until arbitrary 3D shape reconstruction is solved.

### B5.5.1 Define an initial flexible-balloon model

A deliberately simplified reference model is an affine deformation of a spherical material reference:

\[
F(\eta)=\mathrm{diag}(\lambda_x,\lambda_y,\lambda_z),
\quad \lambda_j=1+\eta_j>0.
\]

\[
x_0(X;P,R,\eta)=P+R F(\eta)X.
\]

For a nominal attachment at body-reference material coordinate \(r_{i0}\):

\[
B_i=P+R F(\eta)r_{i0}.
\]

Affine deformation maps the sphere into an ellipsoid. Its reference-to-deformed volume ratio is \(\det F=\lambda_x\lambda_y\lambda_z\). **Only under an explicitly chosen nearly incompressible/constant-enclosed-volume approximation** use

\[
\det F\approx1.
\]

This constraint is *not* a universal statement about gas-filled balloons: enclosed gas/liquid volume, internal pressure and elastomer wall incompressibility are distinct. Document which physical quantity is assumed constant; material incompressibility alone does not prove fixed enclosed volume.

**First model purpose:** bounded hypothetical deformation scenarios, not constitutive prediction. Use labelled small/medium illustrative strains for sensitivity studies; do not call them measured gastric-balloon deformation ranges.

**Theory upgrade when required:** nonlinear hyperelastic membrane/shell equilibrium, pressure–stretch relations, contact or finite-element simulation. Gent/Gent–Gent and related spherical-rubber-balloon inflation models [R3] support *nonlinear membrane mechanics*, **not** the particular 3-axis affine ellipsoid formula, which is our explicit engineering approximation.

**Output:** assumptions table; MATLAB model function; deformation parameter bounds with provenance; tests for \(F=I\), positive stretches, and geometric integrity.

### B5.5.2 Attachment migration and attachment engineering

Define material attachment migration relative to its rigid reference:

\[
\Delta r_i=(F-I)r_{i0},\quad
\Delta B_i=R\Delta r_i.
\]

For a general non-affine displacement field \(u(X,\eta)\):

\[
B_i=P+R[r_{i0}+u(r_{i0},\eta)].
\]

Evaluate migration, local surface normal variation, connector footprint/strain and whether local rigid reinforcement biases the deformation. The attached connector follows a **material point**; it is not automatically stationary on the sphere or along a fixed radius.

**Output:** six attachment migration plots, displacement table and hardware mounting risk notes. Retaining initial \(r_{i0}\) is acceptable as a *material reference label*, not proof the current physical attachment coordinates remain fixed.

### B5.5.3 Re-evaluate cable geometry and lengths against deformed surfaces

\[
L_i(P,R,\eta)=\|A_i-P-RF(\eta)r_{i0}\|.
\]

Update cable–surface intersection from a sphere to a deformed mesh or, for the simplified ellipsoid, a transformed implicit surface. Evaluate cable–cable clearances and cable–surface separation over the chosen rigid-pose and deformation samples; consider connector footprint and cable thickness.

**Output:** maximum incremental payout/retrieval induced by deformation, interference map and identify which Anchor/Attachment pairs need adjustment. Rigid B3's sphere-only outward test must **not** be assumed valid for arbitrary deformed surfaces.

### B5.5.4 Test rigid–deformation observability before claiming shape sensing

The extended local measurement model is

\[
\delta L\approx H_{\mathrm{rigid}}\,\delta q+H_{\eta}\,\delta\eta,
\qquad H_{\mathrm{total}}\in\mathbb R^{6\times(6+p)}.
\]

For an ellipsoid with \(F=\mathrm{diag}(1+\eta_x,1+\eta_y,1+\eta_z)\), let \(u_i=(A_i-B_i)/L_i\). The derivative with respect to the deformation parameter \(\eta_j\) is

\[
\frac{\partial L_i}{\partial\eta_j}=-u_i^T R E_j r_{i0},
\quad E_j=\mathrm{diag}(\delta_{1j},\delta_{2j},\delta_{3j}).
\]

With six independent length observations, \(\mathrm{rank}(H_{\mathrm{total}})\le6\). When \(p>0\), **all unconstrained 6+p unknown state variables cannot be locally independently identified** from six scalar cable lengths alone. Even with a volume constraint, count independent deformation coordinates after applying that constraint and check Jacobian rank. Additional calibrated mechanical priors, independent measurements or temporal constraints might change practical identifiability; they must be explicitly stated and tested.

**Output:** rank/nullspace comparison, rigid-pose bias when shape changes are ignored, and a limited claim of which state variables are supported by the measurements.

**Evidence/theory:** Rank-nullity and nonlinear measurement linearisation; model-assisted sensing/shape reconstruction under extra constraints in Liu et al. [R4], which uses **distributed strain sensors**, not this six-cable balloon apparatus.

### B5.5.5 Hardware compatibility gate

| Check | Keep current V1.0? | Action if not |
|---|---|---|
| Flexible deformation causes no new collision within declared core test set | Conditional | Revise pairing or anchor path |
| Attachment migration remains within hardware and payout allowance | Conditional | Change attachment mounting or add stroke reserve |
| Cable-induced membrane stress/disturbance is tolerable | Unverified until mechanical tests | Lower tension, distribute load or redesign mount |
| Six-cable measurements support stated estimation target | Requires rank/model check | Narrow target, add priors or extra independent sensing |
| Mounts/motors allow practical reconfiguration | Mechanical design check | Add rail/plate/hole interfaces before manufacture |

**Gate outcome:** `KEEP_V1` / `MODIFY_ATTACHMENTS` / `MODIFY_ANCHORS` / `ADDITIONAL_MEASUREMENT_NEEDED`, with explicit scope and reasons. A failed flexible shape-estimation identifiability test need not block a rigid-only demonstration if the prototype is labelled accordingly and expansion provisions remain.

## 5. B6 Engineering Sizing Handoff

For the frozen V1.0 and declared core / extended test sets:

\[
L_{i,\min}=\min_{q,\eta}L_i(q,\eta),\quad
L_{i,\max}=\max_{q,\eta}L_i(q,\eta),\quad
\Delta L_i=L_{i,\max}-L_{i,\min}.
\]

The formulas apply to straight active spans; **actual cable inventory and reel travel** also depend on guides, pulleys, wrap, routing, end fittings and reserve turns.

Rigid-body quasi-static wrench balance, if mechanically applicable, is

\[
W(q)T+w_{\mathrm{ext}}=0,
\quad T_{\min}\le T_i\le T_{\max}.
\]

The external wrench must include the relevant weight, buoyancy/support/contact and disturbances; the cable force direction and signs must be checked. **Full-rank sensing Jacobian does not guarantee positive-tension mechanical equilibrium** for arbitrary loads. Passive low-tension tracking must also limit the *disturbing cable wrench* rather than using aggressive position control.

Approximate drum/motor relations after a credible tension demand is established:

\[
\tau_{\mathrm{motor}}\approx T_{\mathrm{design}}r_{\mathrm{drum}}/\eta_{\mathrm{drive}},
\quad \omega_{\mathrm{drum}}=v_{\mathrm{cable}}/r_{\mathrm{drum}}.
\]

Account for inertia, acceleration, friction, drum-radius changes, safety factors, motor control bandwidth, sensor resolution, and calibration.

**Required B6 input packet:** A/r pairing table; selected pose/deformation envelopes; stroke and speed estimates; hypothesised or measured mass/loading; low-tension disturbance target; physical mount limits; cable diameter/material candidates; explicitly unresolved parameters.

## 6. Reconfigurable Test Rig Requirements

- Adjustable anchor rails/plates/slots with repeatable coordinate calibration and mechanical locking.
- Replaceable attachment modules with known material-reference placement and strain-distribution considerations.
- Modular winch, tension sensing and cable-length sensing channels.
- Physical cable routing that does not obstruct the stated test envelope.
- Provision for a seventh/eighth sensing channel only if later identifiability/robustness analysis warrants it.
- Independent rigid and flexible ground truth: e.g., external optical tracking of markers for pose, plus images/3D scanning or other suitable shape-reference method for deformation; suitability to be determined experimentally.
- Baseline commissioning in a limited, known safe envelope; defined emergency stop, low-force mechanical limits and operator access.

**A redesign is required if** the deformed balloon introduces systematic cable–surface collisions, strain concentration at fixtures, unsupported tension demands or insufficient measurement information for the selected estimation objective.

## 7. Verification and Versioning Requirements

| Stage | Verification | Status |
|---|---|---|
| B5 | Baseline A/B reproducibility and candidate diversity | Pending |
| B5 | Core-pose geometric and Jacobian checks | Pending |
| B5 | Independent validation poses | Pending |
| B5 | V1.0 coordinate and pairing version lock | Pending |
| B5.5 | Affine model reduces to rigid at F=I | Pending |
| B5.5 | Flexible surface intersection and clearance checks | Pending |
| B5.5 | Extended Jacobian finite-difference and rank checks | Pending |
| B5.5 | Compatibility gate | Pending |
| B6 | Preliminary mass/tension/drum sizing | Pending |

**Dataset convention:** `Prototype_V1_0` must store `A` (6×3), `r0` (6×3), units, frame definition, row-wise pairing, geometry version, target pose set, flexible-model version, active routing model, physical clearance assumptions, verification result and date. Keep old configurations immutable and record subsequent revisions as `V1_1`, `V2_0`, etc.

**Reference pose and datasets:** `B1_geometry_baseline.mat`, `B2_6cable_experiment_A.mat`, `B2_experiment_B_results.mat`, `B3_2_results.mat`, `B4_1_results.mat`. Planned results and hardware specifications must never be marked completed before numerical or experimental confirmation.

## 8. Literature and Theory Register

**[R1] Cheng, H. H., & Lau, D. (2023).** *Cable Attachment Optimization for Reconfigurable Cable-Driven Parallel Robots Based on Various Workspace Conditions*. IEEE Transactions on Robotics, 39(5), 3759–3775. DOI: [10.1109/TRO.2023.3288838](https://doi.org/10.1109/TRO.2023.3288838). **Use:** constrained attachment placement, workspace and interference-free inequalities; not a direct passive-sensing validation.

**[R2] Youssef, K., & Otis, M. J.-D. (2020).** *Reconfigurable fully constrained cable driven parallel mechanism for avoiding interference between cables*. Mechanism and Machine Theory, 148, 103781. DOI: [10.1016/j.mechmachtheory.2020.103781](https://doi.org/10.1016/j.mechmachtheory.2020.103781). **Use:** geometric reconfiguration/cable–cable collision avoidance; active robot differences must be noted.

**[R3]** *Gent models for the inflation of spherical balloons*. International Journal of Non-Linear Mechanics, 68 (2015), 52–58. DOI: [10.1016/j.ijnonlinmec.2014.05.016](https://doi.org/10.1016/j.ijnonlinmec.2014.05.016). **Use:** nonlinear hyperelastic spherical membrane mechanics; NOT a direct source of our affine ellipsoid deformation assumption.

**[R4] Liu, L., et al. (2025).** *Model-Based 3D Shape Reconstruction of Soft Robots via Distributed Strain Sensing*. Soft Robotics, 12(6), 721–731. DOI: [10.1089/soro.2024.0158](https://doi.org/10.1089/soro.2024.0158). **Use:** shape reconstruction with distributed sensing plus model constraints; not a six-cable balloon measurement proof.

**[R5] Pott, A. (2018).** *Cable-Driven Parallel Robots: Theory and Application*. Springer. DOI: [10.1007/978-3-319-76138-1](https://doi.org/10.1007/978-3-319-76138-1). **Use:** CDPR geometry, wrench/tension concepts and engineering foundations.

**Method provenance note:** All measurement Jacobian, affine deformation and extended observability equations above are either standard geometry/calculus/linear algebra or explicit engineering models for this project. The cited papers provide relevant mathematical/engineering context; none directly validates the entire proposed gastric-balloon architecture.

## 9. Active Project Documents

- Research state: [`../CURRENT_STATE2.md`](../CURRENT_STATE2.md)
- November TODO: [`../08_Project_Management/November/`](../08_Project_Management/November/) — use the exact committed November TODO filename.
- Current two-week plan: [`../08_Project_Management/November/weekly_plan_nov_04_17_2026.md`](../08_Project_Management/November/weekly_plan_nov_04_17_2026.md)
- Existing rigid design: [`Rigid_Body_Sensing_Design.md`](Rigid_Body_Sensing_Design.md)
- Existing sensing objective: [`Sensing_Objective_v0.2.md`](Sensing_Objective_v0.2.md)

**Immediate next action:** Complete the B5 configuration audit, candidate expansion and core-pose screening according to the November plan. Do not lock a motor or cable design until critical geometry, loading and tension assumptions are explicit.
