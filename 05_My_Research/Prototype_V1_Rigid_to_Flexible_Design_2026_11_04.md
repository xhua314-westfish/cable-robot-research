
# Prototype V1.0 — Six-Cable Configuration and Rigid-to-Flexible Design

**Version:** 0.2
**Original Date:** 2026-11-04
**Research Phase:** B5 — Prototype Selection / B5.5 — Flexible Compatibility
**Document Status:** Engineering requirements defined; final Prototype V1.0 geometry not yet selected.
**Primary Tool:** MATLAB

---

## Document Purpose

This document defines the engineering requirements for selecting an adjustable six-cable sensing prototype and assessing its compatibility with a deformable balloon.

It connects three research stages:

1. **B5 — Configuration Selection:** Choose a provisional rigid-body six-cable layout.
2. **B5.5 — Flexible Compatibility:** Assess attachment migration, flexible cable routing, observability and hardware implications.
3. **B6 — Engineering Sizing:** Transfer the selected geometry and physical requirements into cable, motor and sensor design.

The prototype is intended for passive balloon sensing with motor-assisted low-tension cable tracking.

It is not intended for active balloon trajectory control.

This document does not duplicate the complete rigid-body sensing model, daily schedule or experimental research logs.

**Document boundaries:**

- Rigid-body mathematics: `Rigid_Body_Sensing_Design.md`.
- Current progress: `CURRENT_STATE2.md`.
- Active tasks: November TODO.
- Daily execution: November Weekly Plan.
- Numerical evidence: Research Logs.

---

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


## 2. Engineering Design Baseline

The initial prototype uses the geometry established in B1–B4.1.

| Parameter | Engineering Baseline |
|---|---|
| Boundary | 280 × 300 × 320 mm |
| Coordinate axes | X = Length, Y = Width, Z = Height |
| Balloon | 550 mL rigid spherical reference |
| Balloon radius | Approximately 50.83 mm |
| Initial cable number | 6 |
| Original anchor candidates | 26 |
| Original attachment candidates | 40 |
| Reference configurations | Experiment A and Experiment B |
| Evaluation | Common rigid-body pose samples |
| Primary measurement | Cable length |

### Existing Configuration Limitations

Experiment A is primarily limited by cable–sphere interference.

Experiment B is primarily limited by interference between Cable Pair 5–6.

Neither configuration is approved as the final physical prototype.

Both remain numerical comparison baselines during B5.

### Design Implications

Prototype V1.0 should:

- Allow anchor-position adjustment.
- Support replaceable attachment locations.
- Provide explicit cable pairing.
- Avoid critical interference over a declared core test region.
- Maintain acceptable local sensing identifiability.
- Allow cable-length and tension measurement.
- Support initial flexible-balloon experiments.
- Reserve reasonable provision for additional sensing channels.

The exact V1.0 anchor and attachment coordinates must be selected using actual B5 evaluation results.

Aggregate performance statistics must not be used to invent missing coordinates.

Detailed B2–B4.1 results belong in `CURRENT_STATE2.md` and the associated Research Logs.

---


## 3. B5 — Rapid Six-Cable Prototype Configuration Selection

**Objective:** Select a practical, adjustable and numerically justified six-cable Prototype V1.0 without requiring proof of global optimality.

### 3.1 B5.1 — Configuration Audit and Candidate Expansion

**Design variables:**

\[
\mathcal C_6=\{(A_i,r_i)\}_{i=1}^{6}
\]

where each cable has:

- One world-frame anchor \(A_i\).
- One body-frame attachment \(r_i\).
- An explicit anchor–attachment correspondence.

Cable pairing is a design variable.

**Engineering requirements:**

- Review existing Experiment A/B configurations.
- Expand anchor candidate regions where mounting is practical.
- Expand attachment candidates beyond the initial coarse spherical grid.
- Consider multiple anchor-distribution families.
- Evaluate alternative cable pairings.
- Define minimum physical spacing as an adjustable design parameter.
- Preserve reproducibility of candidate generation.

**Expected Output:** Reproducible candidate configurations with coordinates, pairing and mounting-region definitions.

### 3.2 B5.2 — Multi-Pose Geometric Screening

**Objective:** Identify layouts that avoid significant interference over a declared experimental pose set.

Check:

- Balloon containment.
- Cable–balloon penetration.
- Cable–cable interference.
- Cable length and routing.
- Minimum cable separation.
- Anchor mounting accessibility.
- Attachment mounting accessibility.

Two pose sets should be distinguished:

**Core Experimental Pose Set:** Required poses for initial prototype commissioning.

**Extended Evaluation Pose Set:** Broader numerical samples used for comparison and limitation assessment.

Physical cable diameter and mounting clearance must be included when their values become available.

Ideal zero-thickness line-segment feasibility does not establish physical clearance.

**Expected Output:** Geometry-feasibility results, interference records and shortlisted configurations.

### 3.3 B5.3 — Multi-Pose Sensing Evaluation

**Objective:** Rank geometrically admissible configurations by rigid-body sensing performance.

Evaluate:

- Measurement Jacobian rank.
- Scaled minimum singular value.
- Scaled condition number.
- Weak sensing directions.
- Predicted position and orientation uncertainty.
- Performance across common pose samples.

Candidates must be compared under consistent noise assumptions and Jacobian scaling conventions.

Prioritise required geometric feasibility, then compare sensing performance and implementation trade-offs.

Do not select a prototype using reference-pose condition number alone.

**Expected Output:** Ranked candidates and a documented sensing-performance comparison.

Detailed Jacobian derivations and covariance equations are maintained in `Rigid_Body_Sensing_Design.md`.

### 3.4 B5.4 — Refinement and Prototype V1.0 Selection

**Objective:** Select a provisional six-cable layout suitable for experimental development.

Refine promising configurations through:

- Anchor-position adjustment.
- Attachment-position adjustment.
- Cable-pairing changes.
- Geometric re-evaluation.
- Independent validation poses.
- Mounting and assembly review.

### Prototype V1.0 Selection Record

The selected configuration must include:

| Item | Required Information |
|---|---|
| Anchors | Six world-frame coordinates |
| Attachments | Six body-frame reference coordinates |
| Cable pairing | Explicit one-to-one mapping |
| Geometry version | Boundary and balloon parameters |
| Core test region | Required initial experimental poses |
| Geometric results | Interference and minimum clearance |
| Sensing results | Rank, singular values and predicted uncertainty |
| Cable lengths | Nominal lengths and sampled travel range |
| Mechanical interfaces | Mounting and adjustment requirements |
| Open issues | Remaining physical and experimental uncertainties |

### Selection Decision

Possible outcomes:

- **PROVISIONAL_V1:** A configuration satisfies the declared initial numerical and engineering requirements.
- **REVISE_CONFIGURATION:** Critical geometry or sensing limitations remain.
- **RESTRICT_CORE_REGION:** A scientifically justified smaller experimental region is required.
- **REVIEW_ARCHITECTURE:** No suitable configuration has been identified within the evaluated design space.

A provisional selection permits further engineering analysis.

It does not constitute verified positive-tension feasibility, experimentally validated accuracy or approval for final hardware procurement.

**Output:** A versioned six-cable configuration and B5 decision record.

---


## 4. B5.5 — Rigid-to-Flexible Balloon Compatibility

**Objective:** Determine whether the provisional rigid-body six-cable configuration can support initial flexible-balloon sensing experiments.

**Status:** Planned after selection of a provisional rigid Prototype V1.0.

This stage is a limited engineering compatibility assessment, not a complete nonlinear membrane-model validation or full shape-reconstruction project.

### Research Questions

1. How do balloon attachment positions change during deformation?
2. Does deformation introduce additional cable interference?
3. How do cable-length requirements change?
4. Which rigid-body and deformation variables are locally identifiable?
5. Can the proposed prototype hardware be retained or adjusted?

### Task Structure

| Task | Technical Focus | Required Output |
|---|---|---|
| B5.5.1 | Simplified flexible-balloon model | Deformation assumptions and model |
| B5.5.2 | Attachment migration | Material-point displacement and mounting requirements |
| B5.5.3 | Flexible cable routing | Interference and length changes |
| B5.5.4 | Rigid–deformation observability | Extended Jacobian and identifiable state analysis |
| B5.5.5 | Hardware compatibility | Keep, modify or redesign decision |

The simplified affine or ellipsoidal deformation model is an engineering screening approximation.

It must not be presented as a validated physical model of intragastric balloon deformation.

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

---


## 7. Prototype Configuration and Version Control

### 7.1 Configuration Data Structure

Each prototype configuration must contain:

| Field | Description |
|---|---|
| `version` | Prototype version identifier |
| `A` | 6 × 3 world-frame anchor coordinates |
| `r0` | 6 × 3 body-frame attachment coordinates |
| `pairing` | Cable-to-anchor/attachment mapping |
| `units` | Coordinate and measurement units |
| `geometry_version` | Boundary and balloon model identifier |
| `pose_set` | Declared evaluation poses |
| `length_range` | Sampled cable-length limits |
| `clearance` | Geometric clearance assumptions and results |
| `sensing_metrics` | Rank, singular values and predicted uncertainty |
| `validation_status` | Numerical and experimental evidence status |
| `limitations` | Unresolved mechanical or measurement issues |

### 7.2 Version Naming

Use:

- `Prototype_V1_0` — Initial provisional configuration.
- `Prototype_V1_1` — Limited adjustment without changing the overall architecture.
- `Prototype_V2_0` — Substantial configuration or architecture revision.

Preserve previous configurations and their evaluation datasets.

Do not overwrite verified historical results without retaining their provenance.

### 7.3 Existing Numerical References

The initial numerical baseline includes:

- `B1_geometry_baseline.mat`
- `B2_6cable_experiment_A.mat`
- `B2_experiment_B_results.mat`
- `B3_2_results.mat`
- `B4_1_results.mat`

These files represent the earlier simulation baseline.

They must not be confused with a validated Prototype V1.0 configuration.

### 7.4 Engineering Release Conditions

A provisional prototype configuration may be passed to B6 when:

- Anchor and attachment coordinates are documented.
- Cable pairing is reproducible.
- Required core-pose geometry checks are completed.
- Local sensing feasibility is assessed.
- Flexible compatibility limitations are identified.
- Preliminary cable-length requirements are available.
- Remaining mechanical and tension assumptions are explicit.

Detailed research acceptance checklists belong in the November TODO.

Actual validation evidence belongs in the Research Logs.

---

## 8. Literature and Theory Register

**[R1] Cheng, H. H., & Lau, D. (2023).** *Cable Attachment Optimization for Reconfigurable Cable-Driven Parallel Robots Based on Various Workspace Conditions*. IEEE Transactions on Robotics, 39(5), 3759–3775. DOI: [10.1109/TRO.2023.3288838](https://doi.org/10.1109/TRO.2023.3288838). **Use:** constrained attachment placement, workspace and interference-free inequalities; not a direct passive-sensing validation.

**[R2] Youssef, K., & Otis, M. J.-D. (2020).** *Reconfigurable fully constrained cable driven parallel mechanism for avoiding interference between cables*. Mechanism and Machine Theory, 148, 103781. DOI: [10.1016/j.mechmachtheory.2020.103781](https://doi.org/10.1016/j.mechmachtheory.2020.103781). **Use:** geometric reconfiguration/cable–cable collision avoidance; active robot differences must be noted.

**[R3]** *Gent models for the inflation of spherical balloons*. International Journal of Non-Linear Mechanics, 68 (2015), 52–58. DOI: [10.1016/j.ijnonlinmec.2014.05.016](https://doi.org/10.1016/j.ijnonlinmec.2014.05.016). **Use:** nonlinear hyperelastic spherical membrane mechanics; NOT a direct source of our affine ellipsoid deformation assumption.

**[R4] Liu, L., et al. (2025).** *Model-Based 3D Shape Reconstruction of Soft Robots via Distributed Strain Sensing*. Soft Robotics, 12(6), 721–731. DOI: [10.1089/soro.2024.0158](https://doi.org/10.1089/soro.2024.0158). **Use:** shape reconstruction with distributed sensing plus model constraints; not a six-cable balloon measurement proof.

**[R5] Pott, A. (2018).** *Cable-Driven Parallel Robots: Theory and Application*. Springer. DOI: [10.1007/978-3-319-76138-1](https://doi.org/10.1007/978-3-319-76138-1). **Use:** CDPR geometry, wrench/tension concepts and engineering foundations.

**Method provenance note:** All measurement Jacobian, affine deformation and extended observability equations above are either standard geometry/calculus/linear algebra or explicit engineering models for this project. The cited papers provide relevant mathematical/engineering context; none directly validates the entire proposed gastric-balloon architecture.


## 9. Related Project Documents

### Research Management

- [Current Research State](../CURRENT_STATE2.md)
- [Research Roadmap](../08_Project_Management/Roadmap.md)
- [November Research TODO](../08_Project_Management/November/current_november_todo_updated_2026_11_04.md)
- [November Weekly Plan](../08_Project_Management/November/weekly_plan_nov_04_17_2026.md)

### Technical Design

- [Sensing Objective](Sensing_Objective_v0.2.md)
- [Rigid-Body Sensing Design](Rigid_Body_Sensing_Design.md)
- [Workspace Boundary](Workspace_Boundary_v0.2_2026-10-20.md)

### Research Evidence

- [MATLAB Simulations](../03_Simulation/MATLAB/)
- [Research Logs](../06_Research_Log/)
- [Literature Review](../02_Paper_Reading/Literature_Review/)

---

**Engineering Objective:** Select an adjustable six-cable Prototype V1.0 and establish its compatibility with initial flexible-balloon experiments.

**Long-Term Objective:** Support experimental sensing research and future six-/seven-/eight-cable comparison.

**Guiding Principle:** Prototype decisions must be based on documented numerical evidence, physical assumptions and clearly stated limitations.

