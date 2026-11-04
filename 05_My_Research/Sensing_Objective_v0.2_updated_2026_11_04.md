# Sensing Objective v0.2 — Passive Balloon Cable-Based Sensing

**Original Definition:** 2026-10-19  
**Last Updated:** 2026-11-04  
**Research Phase:** Phase B — Balloon-Specific Cable Sensing Design  
**Current Priority:** Six-Cable Prototype V1.0, Rigid-to-Flexible Compatibility, and Early Test-Rig Construction  
**Long-Term Comparative Scope:** Six-, Seven-, and Eight-Cable Sensing Systems  
**Status:** Research objective retained; implementation sequence revised to prioritise experimental prototyping.

> **Document role:** This file defines the scientific objectives, measurement architecture, cable-number comparison, and validation principles. Task schedules and progress belong in `CURRENT_STATE2.md` and the November project-management files. This file is not a daily progress log.

---

## 1. Research Objective

### 1.1 Long-Term Research Question — Retained

> How do seven- and eight-cable configurations affect the accuracy, identifiability, robustness, and feasible sensing workspace of a passively moving balloon-like object, compared with a six-cable reference system?

The long-term cable-number comparison is **not cancelled or replaced** by the six-cable prototyping priority.

### 1.2 Long-Term Research Goal

Develop and evaluate a cable-based sensing system for estimating the position and orientation, and ultimately selected deformation or shape parameters, of a **passively moving balloon-like object** using cable measurements.

The application is motivated by a gastric balloon in a simplified stomach-like environment. The proposed system measures passive motion; it does **not** prescribe the balloon trajectory.

The project will study:

1. **Six cables:** Establish an experimentally testable 6-DOF rigid-body sensing baseline and a modular prototype.
2. **Seven cables:** Investigate the benefit and limitations of one additional measurement and associated cable routing and tension constraints.
3. **Eight cables:** Investigate further redundancy and its trade-offs in sensing quality, interference, hardware complexity, and low-tension operation.
4. **Deformable balloon:** Evaluate whether rigid-body sensing layouts remain useful when attachments migrate with material deformation, and whether additional state information is observable.

The eventual preferred cable count will be selected from **quantitative comparisons**, not assumed in advance.

### 1.3 Immediate Engineering Goal

> Rapidly identify an adjustable, numerically justified six-cable **Prototype Configuration V1.0**, estimate its cable lengths and engineering loads, construct a test rig, and use experiments to refine the sensing design.

The immediate goal is **not** to prove global optimum for the six-cable geometry. However, basic routing, clearance, identifiability, and mechanical-safety issues must not be hidden by a good numerical condition number.

---

## 2. Research Architecture and Parallel Workstreams

### 2.1 Workstream A — Six-Cable Experimental Baseline (Priority)

| Stage | Main objective | Intended output |
|---|---|---|
| B1–B4.1 | Baseline geometry, candidate A/B configurations, geometric and sensing analysis | Reproducible numerical evidence (completed initial evaluations) |
| B5 | Rapid, topology-diverse six-cable configuration selection | Prototype V1.0 coordinates, pairing, core operating pose set |
| B5.5 | Rigid-to-flexible feasibility gate | Attachment migration and observability/compatibility assessment |
| B6 | Engineering sizing | Length/stroke, tension/load assumptions, drum/motor/sensor shortlist |
| B7 | Adjustable test rig | Movable anchors, replaceable attachments, calibrated measuring channels |
| B8 | Rigid and flexible experiments | Pose-estimation error, noise/calibration, tension and motion disturbance |
| B9 | Experimental refinement | Updated configuration and deformation estimation methods |

**B4.2 nonlinear forward kinematics and Monte Carlo** remain required for accuracy claims. They may run in parallel with mechanical concept development and should not unnecessarily prevent design of the adjustable frame.

### 2.2 Workstream B — Seven- and Eight-Cable Theory (Parallel, Bounded)

Theoretical work on seven and eight cables **may proceed while the six-cable rig is being designed or built**. It is not necessary to wait for the entire six-cable experimental campaign to end.

Appropriate parallel activities include:

- Derive the 7×6 and 8×6 measurement Jacobians and rank/redundancy conditions.
- Adapt the same anchor/attachment regions and pose samples used in six-cable work.
- Analyse measurement covariance for redundant measurements.
- Study cable interference, positive tension, and routing feasibility.
- Reproduce or adapt relevant literature methods (including seven-cable wrench-closure analysis **only** when the mechanical assumptions apply).
- Define a fair 6-vs-7-vs-8 simulation protocol, including matched noise assumptions and mechanical constraints.

**Do not interpret parallel theoretical study as authorization to prematurely build or purchase seven/eight complete cable channels.** Their hardware expansion can be decided after the six-cable prototype has provided useful evidence.

### 2.3 Priority Rule

When research time or resources are limited, complete the six-cable prototype milestones first. Reserve spare mechanical and electronics interfaces for later 7/8-cable experiments if feasible. Parallel theory is allowed when it does not block the primary build.

---

## 3. Physical System and Engineering Boundary

### 3.1 Balloon

| Parameter | Initial specification | Interpretation |
|---|---|---|
| Balloon proxy | Rigid sphere | First-stage sensing model |
| Nominal volume | 550 mL | Engineering reference |
| Equivalent radius | About 50.83 mm | Calculated from volume |
| Motion | Passive, irregular and not trajectory-controlled | Research assumption |
| Later model | Deformable balloon | B5.5 initial compatibility, B8–B9 deeper research |

For the initial sphere,

\[
r_b=\left(\frac{3V_b}{4\pi}\right)^{1/3},\qquad V_b=550000\ \mathrm{mm^3}.
\]

This calculated equivalent sphere is not a measured external shape of a specific commercial balloon.

### 3.2 Engineering Environment

- Current rectangular engineering boundary: **280 × 300 × 320 mm**.
- Engineering axes: **X = Length, Y = Width, Z = Height**.
- Origin: centre of the selected engineering box.
- Current anchors: candidates on the six idealised boundary faces.
- Initial attachment region: body-frame sphere surface.
- Current baseline candidate sets: **26 anchors** and **40 attachments**, with expansion planned in B5.

These values are **engineering assumptions**, not a clinically validated adult-female gastric cavity or physiological balloon-motion envelope. More detailed anatomical modelling is outside the immediate prototype selection goal.

### 3.3 Low-Tension Passive Tracking

The proposed motors pay out or retrieve cable to maintain small positive tension while the object moves passively. They do not prescribe pose trajectories.

The design must minimise cable-induced disturbances and assess slack, cable compliance, friction, drum mechanics, tension-feedback capability, and sensor calibration. Low tension does not automatically guarantee mechanically feasible equilibrium.

---

## 4. Measurement Model — Rigid Balloon

For cable \(i\), let \(A_i\) denote the fixed world-frame anchor and \(r_i\) the body-fixed attachment coordinate:

\[
B_i=P+Rr_i,\qquad L_i(P,R)=\|A_i-B_i\|.
\]

Measured lengths are:

\[
y_i=L_i(P,R)+\varepsilon_i.
\]

Here \(P\in\mathbb R^3\) is the balloon-centre location and \(R\in SO(3)\) its orientation. The estimator must infer pose from measurements, **without being given true pose or a prescribed trajectory**.

For a world-frame infinitesimal rotation perturbation, define

\[
u_i=\frac{A_i-B_i}{L_i},\qquad s_i=Rr_i.
\]

The local length-measurement Jacobian row is

\[
H_i=\begin{bmatrix}-u_i^T&(u_i\times s_i)^T\end{bmatrix}.
\]

For \(n\) cables, \(H\in\mathbb R^{n\times6}\). Without additional pose constraints, first-order 6-DOF local identifiability requires

\[
\mathrm{rank}(H)=6,\quad n\ge6.
\]

This is a **local, first-order** condition; it does not establish global uniqueness, accurate nonlinear reconstruction, or positive-tension feasibility.

Use characteristic-length scaling consistently:

\[
H_s=H\,\mathrm{diag}(1,1,1,1/r_b,1/r_b,1/r_b).
\]

In this convention the scaled pose perturbation is \([\delta P^T,(r_b\delta\theta)^T]^T\), with components represented in millimetres. The scaled Jacobian is not a claim that pose components are dimensionless.

---

## 5. Cable-Number Study — Long-Term Priority Preserved

### 5.1 Six-Cable Reference

Six independent length measurements provide the minimum scalar count needed for a locally full-rank rigid 6-DOF measurement Jacobian. A 6×6 full-rank matrix is sufficient only for local linear identifiability, not all physical or estimator requirements.

**Research role:** Build and calibrate a six-cable reference system, determine the limitations of nonredundant sensing, and establish a common experimental benchmark.

### 5.2 Seven-Cable System

A 7×6 Jacobian can provide redundant length information. Under a suitable independent measurement-noise model, redundancy may improve pose estimation information; it also introduces another cable path and additional mechanical constraints.

**Research questions:**

- Does an extra cable improve worst-direction sensitivity or covariance over the same pose set?
- Does it improve estimator robustness or convergence?
- Does additional cable routing create unacceptable interference or passive-motion disturbance?
- Under a justified mechanical model, does the extra cable improve tension feasibility?

**Reference:** Gouttefarde & Gosselin (2005), *Wrench-Closure Workspace of Six-DOF Parallel Mechanisms Driven by 7 Cables*, DOI: [10.1139/tcsme-2005-0034](https://doi.org/10.1139/tcsme-2005-0034). This is **wrench-closure theory**, not direct proof of superior sensing performance.

### 5.3 Eight-Cable System

An 8×6 measurement Jacobian provides two additional scalar measurements relative to the rigid 6-DOF state. Its potential sensing gains must be evaluated against cable interference, mounting complexity and actuator/sensor cost.

**Research questions:**

- Does an eight-cable layout materially reduce position/orientation RMSE under matched noise conditions?
- Is any gain robust over the predefined workspace rather than limited to the reference pose?
- What is the additional cable-induced disturbance in a passive balloon system?

**Engineering reference:** Pott et al. (2013), *Cable-driven parallel robots for industrial applications: The IPAnema system family*, DOI: [10.1109/ISR.2013.6695742](https://doi.org/10.1109/ISR.2013.6695742). It motivates multi-cable architectures; it does not establish that eight cables are best for this project.

### 5.4 Comparison Requirements

All three cable counts must be compared with:

1. A declared common target pose set, plus independent validation poses.
2. The same balloon/body model, boundary, rotation conventions, and geometric rules.
3. A consistent cable-length noise model; report when additional sensors increase information simply because sensor count increases.
4. Identical definitions for rank, scaled singular values, condition number, uncertainty, nonlinear estimator errors and failures.
5. Mechanical feasibility metrics, including routing, real cable thickness, tension and interference with passive motion.
6. Comparable search budgets or clear disclosure when candidate-search effort differs.

Additional cables are **not** automatically better, and comparisons must not mix active-control wrench feasibility with passive sensing performance.

---

## 6. B5 — Rapid Six-Cable Configuration Selection

**Goal:** Choose a manufacturable and adjustable **Prototype Configuration V1.0**, not prove a global optimum.

Design variables:

\[
\mathcal C_6=\{(A_i,r_i)\}_{i=1}^{6},
\]

including anchor coordinates, attachment coordinates and explicit cable pairing.

The search should **not** be restricted to small changes around Experiment B. Use the original A/B as benchmarks, extend candidate regions and evaluate different spatial layout families and pairings.

**Proposed order:**

1. Audit the A/B coordinates and failure mechanisms.
2. Expand anchor and attachment candidate sets; preserve manufacturable mounting regions.
3. Generate diverse layout families and pairing assignments.
4. Screen cable–balloon and cable–cable geometry on a common target-pose set.
5. Compare feasible candidates using worst-direction sensitivity and predicted pose uncertainty; keep condition number for diagnosis.
6. Locally refine promising candidates and assess new validation poses.
7. Freeze one versioned V1.0 coordinate/pairing set **for preliminary sizing**, while preserving adjustment and recording open risks.

Do not declare a numerical position/angle accuracy acceptance threshold solely from arbitrary simulated noise values. Define an explicit **core prototype operating set**, and do not claim full-workspace coverage from it.

**Initial evidence:** On 189 sampled poses, Experiment A passed geometry at 40/189 and Experiment B at 105/189. Experiment B exhibited Cable 5–6 contact in 81 poses; therefore B is not an approved final physical layout.

**Outputs:** \(6\times3\) anchor and attachment coordinate matrices, cable mapping, selected core pose set, minimum clearance, Jacobian quality, predicted uncertainty, length-range estimates, and a statement of remaining mechanical assumptions.

**Related method:** Cheng & Lau (2023), *Cable Attachment Optimization for Reconfigurable Cable-Driven Parallel Robots Based on Various Workspace Conditions*, DOI: [10.1109/TRO.2023.3288838](https://doi.org/10.1109/TRO.2023.3288838). Adapt the idea of workspace-dependent configuration and interference constraints; do not copy active-control objectives without justification.

---

## 7. B5.5 — Rigid-to-Flexible Balloon Compatibility

The first prototype should be **mechanically compatible with subsequent flexible-balloon experiments** even though its initial numerical baseline is rigid.

### 7.1 Attachment-Migration Model

For a reference attachment \(r_{i0}\), use a reduced deformation model:

\[
B_i=P+R\left[r_{i0}+d_i(\eta)\right].
\]

A first **engineering approximation** may use affine ellipsoidal deformation:

\[
d_i(\eta)=(F(\eta)-I)r_{i0},\qquad
F=\mathrm{diag}(1+\eta_x,1+\eta_y,1+\eta_z).
\]

When approximate volume conservation is warranted:

\[
\det F\approx1.
\]

**These affine/ellipsoid assumptions are proposed simplified models, not clinical observations or a validated membrane constitutive law.** Inflation and mechanical effects may require nonlinear membrane/constitutive modelling later.

### 7.2 Observability and Measurement Limits

The local model becomes

\[
\delta L\approx H_{\mathrm{rigid}}\delta q+H_{\eta}\delta\eta.
\]

With six scalar cable lengths and six rigid pose coordinates plus additional independent deformation variables, the augmented Jacobian has more columns than rows. Hence arbitrary rigid motion and all independent deformation coordinates are **not jointly locally identifiable** without constraints, priors, reduced state dimension, or extra measurements.

Seven or eight cables may add information, but are not automatically sufficient for unrestricted shape reconstruction.

### 7.3 Compatibility Gate Before B6 Procurement

Check whether the proposed V1.0:

- Preserves a suitable anchor installation region under a declared deformation range.
- Can tolerate attachment migration without major cable–surface or cable–cable interference.
- Allows replaceable, non-damaging balloon attachment hardware.
- Accommodates altered length stroke and low-tension behaviour.
- Reserves optional interfaces for extra cable/sensor channels.

**A pass here means hardware compatibility under stated scenarios, not proof of deformation reconstruction.** Detailed soft-body reconstruction and experimental identification remain later research tasks.

**Method references:** Relevant continuous/soft-robot sensing and nonlinear balloon mechanics literature should support later model selection. The affine model above is a deliberately simplified engineering test; its constitutive validity requires independent evidence.

---

## 8. B6–B9 — Engineering and Experimental Programme

### B6 — Engineering Sizing

For each proposed configuration and pose set:

\[
L_i(q)=\|A_i-P-Rr_i\|,\qquad \Delta L_i=L_{i,\max}-L_{i,\min}.
\]

Check guide/route offsets and flexible attachment migration before assigning physical drum stroke.

For a stated quasi-static mechanical model:

\[
W(q)T+w_{\mathrm{ext}}=0,\qquad T_i>0.
\]

Mass alone is not sufficient: external support, gravity/buoyancy, attachment loading, pretension, and constraints must be specified. Rank-six sensing does not imply arbitrary positive-tension equilibrium. Estimate torque with an explicit mechanical efficiency model, e.g. \(\tau\approx Tr_d/\eta_m\), then include acceleration, motor speed, transient loads, and margins.

### B7 — Adjustable Prototype

Prefer movable anchor fixtures, replaceable attachment modules, modular motor/sensor channels, cable routing access, independent pose ground-truth provision and safe low-tension commissioning.

The six-cable rig may be **designed with unused mounting/electronics capacity for channels 7 and 8**, but this is a design provision, not a decision to install them immediately.

### B8 — Experimental Validation

Start with rigid-object calibration and controlled ground-truth poses, then test passive motion and flexible balloon scenarios. Report pose RMSE, convergence and failures, actual measurement-noise properties, calibration uncertainty, cable tension, slack and trajectory disturbance.

### B9 — Refinement and Deformation Estimation

Use experiment-derived evidence to revise geometry, pairing, calibration, noise assumptions and deformation models. Compare the eventual 6-, 7- and 8-cable implementations where technically justified.

---

## 9. Measurement Performance and Evidence Rules

| Metric | Meaning | Important limitation |
|---|---|---|
| Jacobian rank | First-order local pose identifiability | Not global uniqueness |
| Scaled minimum singular value | Worst local sensing direction | Depends on scaling and pose |
| Scaled condition number | Relative sensitivity balance | Not an absolute pose error |
| Local covariance | Predicted random pose uncertainty | Depends on linear model and noise assumptions |
| FK/Monte Carlo RMSE | Numerical estimator performance | Not experimental accuracy |
| Measured pose RMSE | Experimental estimation performance | Requires independent ground truth |
| Geometric pass rate | Fraction of declared pose samples accepted | Not continuous workspace volume |
| Cable clearance | Mechanical/routing margin | Requires finite diameter and hardware geometry |
| Tension feasibility | Ability to maintain appropriate positive forces | Distinct from sensing rank |
| Disturbance | Effect of cables on passive motion | Requires mechanical model or experiment |

Position error:

\[
e_P=\|\hat P-P\|_2.
\]

Rotation error:

\[
e_R=\cos^{-1}\!\left(\mathrm{clip}\left(\frac{\mathrm{tr}(\hat R^TR)-1}{2},-1,1\right)\right).
\]

Noise predictions must be labelled clearly; the current B4.1 illustrative cable-length standard deviation is **0.1 mm**, not a sensor calibration result. Never claim that the six-cable setup achieves that experimental pose accuracy before B8.

---

## 10. Current Verified Results and Unresolved Risks

**Completed numerical baselines:**

- B1: 280 × 300 × 320 mm boundary; 550 mL equivalent rigid sphere; 26 initial anchor candidates and 40 attachment candidates.
- B2: Six-cable Experiment A/B baseline, 20,000 single-reference-pose random trials per experiment.
- B3: 27 position and 189 combined position/orientation sample feasibility evaluations.
- B4.1: Analytical/numerical Jacobian checks, rank/singular values, weakest directions and local covariance calculations; integrated comparison prepared.

| B3/B4.1 metric | Experiment A | Experiment B |
|---|---:|---:|
| Geometry-pass poses / 189 | 40 | 105 |
| Median feasible-pose scaled \(\sigma_{\min}\) | 0.182628 | 0.416239 |
| Median feasible-pose scaled \(\kappa\) | 11.1157 | 4.4673 |
| Median predicted position uncertainty, \(\sigma_L=0.1\) mm | 0.3860 mm | 0.1657 mm |
| Median predicted orientation uncertainty | 0.5663° | 0.2913° |

Important unresolved risks include Experiment B Cable 5–6 contact, unverified finite cable clearances, six-cable positive-tension feasibility, sensor calibration, nonlinear estimator robustness and the rigid-to-flexible attachment model.

**Next active task:** B5 configuration audit and rapid six-cable V1.0 search, per the November 4–17 plan. Theoretical 7/8-cable preparation may progress in parallel with the six-cable rig where time permits.

---

## 11. Research Sequence and Decision Gates

| Gate | Required evidence | Unlocks |
|---|---|---|
| Gate A — B5 V1.0 | Coordinate pairs, geometry over core poses, Jacobian statistics, routing issues stated | Preliminary cable-length and rig layout calculations |
| Gate B — B5.5 | Flexible migration/clearance scenarios, state-observability limitations, modular interfaces | More informed B6 hardware sizing/procurement |
| Gate C — B6 | Length/stroke, specified external load/tension model, motor/sensor sizing and safety review | Construction and low-tension commissioning |
| Gate D — B8 | Calibration, independent ground truth, rigid/flexible measurement results | Data-driven refinement and hardware 7/8 expansion decisions |

Theoretical 7/8 work has **no requirement to wait for Gate D**, provided its assumptions and simulation-only status are explicitly documented.

---

## 12. Key References and Scope

1. Thomas, F., & Ros, L. (2005). *Revisiting trilateration for robot localization.* DOI: [10.1109/TRO.2004.833793](https://doi.org/10.1109/TRO.2004.833793). Distance-geometry foundation; not proof of all six-DOF configurations.
2. Pott, A. (2018). *Cable-Driven Parallel Robots: Theory and Application.* DOI: [10.1007/978-3-319-76138-1](https://doi.org/10.1007/978-3-319-76138-1). General CDPR kinematics, workspace and hardware background.
3. Gouttefarde, M., & Gosselin, C. M. (2005). *Wrench-Closure Workspace of Six-DOF Parallel Mechanisms Driven by 7 Cables.* DOI: [10.1139/tcsme-2005-0034](https://doi.org/10.1139/tcsme-2005-0034). Seven-cable mechanical wrench feasibility.
4. Gouttefarde, M., Daney, D., & Merlet, J.-P. (2011). *Interval-Analysis-Based Determination of the Wrench-Feasible Workspace of Parallel Cable-Driven Robots.* DOI: [10.1109/TRO.2010.2089531](https://doi.org/10.1109/TRO.2010.2089531). Mechanically constrained workspace methods.
5. Pott, A., et al. (2013). *Cable-driven parallel robots for industrial applications: The IPAnema system family.* DOI: [10.1109/ISR.2013.6695742](https://doi.org/10.1109/ISR.2013.6695742). Multi-cable hardware reference.
6. Cheng & Lau (2023). *Cable Attachment Optimization for Reconfigurable Cable-Driven Parallel Robots Based on Various Workspace Conditions.* DOI: [10.1109/TRO.2023.3288838](https://doi.org/10.1109/TRO.2023.3288838). Workspace-dependent attachment optimisation and interference constraints.
7. Song et al. (2024). *A novel real-time tension distribution method for cable-driven parallel robots.* DOI: [10.1017/S0263574724001590](https://doi.org/10.1017/S0263574724001590). Tension distribution; not direct evidence of sensing superiority.

The references support the specified **general methods**. The selected balloon geometry, sampling densities, reduced deformation model, prototype milestones and acceptance trade-offs are **project-specific engineering choices** unless separately validated.

---

## 13. Related Project Files

- `../CURRENT_STATE2.md` — current research state and completed results.
- `../08_Project_Management/November/` — current November TODO and November 4–17 weekly plan.
- `Rigid_Body_Sensing_Design.md` — established rigid-body sensing assumptions and derivations.
- `Prototype_V1_Rigid_to_Flexible_Design_2026_11_04.md` — rapid prototype and flexible-compatibility bridge document.
- `Workspace_Boundary_v0.2_2026-10-20.md` — prior evidence and coordinate-convention notes; numerical dimensions should be reconciled against the newer B1 model before reuse.

---

**Guiding Principle:** **Six cables first for an experimental reference; seven- and eight-cable theory in parallel when useful; seven/eight hardware expansion after suitable evidence.** The long-term 6/7/8 comparison remains a central research objective, while a modular six-cable prototype accelerates practical validation and eventual flexible-balloon sensing research.
