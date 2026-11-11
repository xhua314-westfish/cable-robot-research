# B5.3–B5.6 Revised Research Plan — Thesis-Informed Six-Cable Sensing

**Version:** 0.3  
**Last Updated:** 2026-11-12  
**Project:** Cable-Robot-Based Sensing for a Passive Balloon-Like Object  
**Research Track:** Six-Cable Configuration Optimisation and Prototype Validation  
**Current Stage:** B5.4 — Sensing-Oriented Configuration Optimisation  
**Completed:** B5.3 and B5.4 E1a-A (Config 2)  
**Next Technical Task:** B5.4 E1a-B — Six-Configuration Fair Comparison  
**Primary Tool:** MATLAB  
**Document Type:** Active Research Plan

**Replaces the execution instructions in the previous version of this file. Historical numerical results and Research Logs remain unchanged.**

---

# 1. Research Background and Purpose

## 1.1 Main Research Objective

Develop a cable-length-based sensing system capable of estimating the three-dimensional position and orientation of a passively moving balloon-like object.

The initial research focuses on a rigid spherical balloon with six degrees of freedom:

\[
q=[x,y,z,\theta_x,\theta_y,\theta_z]^T
\]

The long-term objective includes:

- Rigid-body pose measurement.
- Deformable-balloon sensing.
- Experimental measurement accuracy.
- Six-, seven- and eight-cable comparison.

The balloon motion is passive and unknown.

The cable system is intended to follow and measure this motion rather than actively control its trajectory.

## 1.2 Main Configuration Research Question

> How should six anchor points, six balloon attachment points, and their cable connections be arranged to achieve reliable pose measurement while maintaining geometric and mechanical feasibility?

The complete six-cable configuration is:

\[
\mathcal C_6=\{(A_i,r_i)\}_{i=1}^{6}
\]

For the twelve-rail model, the design variables are:

\[
\mathcal C_6=\{\rho_i,t_i,r_i,\pi\}_{i=1}^{6}
\]

where:

- \(\rho_i\): Rail assignment.
- \(t_i\): Normalised anchor position on the selected rail.
- \(r_i\): Balloon-surface attachment position.
- \(\pi\): Anchor–attachment pairing.
- \(A_i\): World-frame anchor coordinate.

These variables are related, but their effects must first be investigated through controlled experiments.

## 1.3 Research Strategy

The research follows:

```text
Research Question
        |
        v
Existing Evidence and Literature
        |
        v
Configuration Hypothesis
        |
        v
Mathematical Model
        |
        v
MATLAB Implementation
        |
        v
Numerical Verification
        |
        v
Failure Diagnosis
        |
        v
Design Decision
        |
        v
Independent Validation
        |
        v
Prototype Investigation
```

**Core principle:**

A numerically attractive configuration is not necessarily a geometrically robust or physically implementable configuration.

---

# 2. Current Engineering Model and Evaluation Criteria

## 2.1 Fixed Engineering Assumptions

| Parameter | Current Value |
|---|---|
| Engineering frame | 280 × 300 × 320 mm |
| X axis | Length |
| Y axis | Width |
| Z axis | Height |
| Balloon volume | 550 mL |
| Balloon model | Rigid sphere |
| Balloon radius | 50.8266 mm |
| Cable number | 6 |
| Anchor installation region | Twelve rectangular-frame edges |
| Attachment installation region | Balloon surface |
| Measurement | Cable length |
| Motion | Passive and unknown |

The rectangular frame is an engineering approximation.

It must not be interpreted as a clinically validated continuous gastric workspace.

## 2.2 Twelve-Rail Anchor Representation

Every anchor must lie on one of the twelve frame edges:

\[
A_i(\rho_i,t_i)
=
E_{0,\rho_i}
+
t_i(E_{1,\rho_i}-E_{0,\rho_i})
\]

with:

\[
0\le t_i\le1
\]

The rectangular frame contains:

- Four X-direction rails.
- Four Y-direction rails.
- Four Z-direction rails.

Total:

\[
N_{\mathrm{rails}}=12
\]

The first prototype is expected to use fixed mounting positions while retaining the possibility of future mechanical adjustment.

Actual pulley offsets and effective cable exit locations are not yet calibrated.

## 2.3 Cable Geometry

For each cable:

\[
B_i=P+Rr_i
\]

\[
D_i=A_i-B_i
\]

\[
L_i=\|D_i\|
\]

\[
u_i=\frac{D_i}{L_i}
\]

The current model assumes ideal straight, zero-thickness cables.

## 2.4 Geometric Feasibility

### Cable–Sphere

The ideal outward-direction condition is:

\[
(Rr_i)^TD_i\ge-10^{-9}\ \mathrm{mm}^2
\]

The outward angular margin is:

\[
m_i(q)=
\arcsin
\left(
\frac{(Rr_i)^TD_i}{r_bL_i}
\right)
\]

A larger positive angular margin generally provides greater separation from the inward-departure boundary.

### Cable–Cable

All fifteen cable pairs are evaluated using the minimum distance between finite three-dimensional segments:

\[
d_{ij}(q)
\]

Current numerical contact criterion:

\[
d_{ij}>10^{-6}\ \mathrm{mm}
\]

This is a zero-thickness numerical interference test.

It is not the required physical clearance for actual cables and attachments.

## 2.5 Sensing Quality

The measurement Jacobian is:

\[
H_i=
\begin{bmatrix}
-u_i^T & (u_i\times Rr_i)^T
\end{bmatrix}
\]

The scaled Jacobian is:

\[
H_s=
H\operatorname{diag}
\left(
1,1,1,\frac1{r_b},\frac1{r_b},\frac1{r_b}
\right)
\]

Main indicators:

- Full Jacobian rank.
- Worst-case scaled minimum singular value.
- Maximum scaled condition number.
- Position and orientation estimation error.
- Estimation convergence and failure rate.
- Sensitivity to measurement and installation errors.

Full rank is a local first-order condition, not a guarantee of global pose uniqueness.

---

# 3. Pose Evaluation Sets

Different pose sets serve different research purposes and must not be mixed when reporting performance improvements.

| Pose Set | Translation | Rotation | Samples |
|---|---|---|---:|
| Historical wider benchmark | Each axis: −50, 0, +50 mm | Identity and single-axis ±10° | 189 |
| Core development set | Each axis: −20, 0, +20 mm | Identity and single-axis ±5° | 189 |
| Original off-grid set | Random in ±20 mm per axis | Combined RPY in ±5° | 150 |
| Additional independent set | Random in ±20 mm per axis | Combined RPY in ±5° | 200 |
| E1a combined development set | Core + both off-grid sets | Mixed discrete poses | 539 |

## 3.1 Important Validation Rule

The 539-pose set has already been used to diagnose and repair Config 2.

Therefore, it is now a **development and repair-evaluation set**.

It must not be presented as a fully untouched final validation set.

For subsequent fair comparison:

1. Define a common optimisation pose set.
2. Define a separate diagnostic or stress-test set.
3. Generate a new independent holdout set.
4. Freeze candidate configurations before evaluating the final holdout.
5. Report all failed poses and reasons.
6. Do not repeatedly optimise against the holdout without explicitly changing its status to development data.

Passing finite samples does not prove continuous workspace feasibility.

---

# 4. Completed Research — B5.3

**Status:** Completed for initial structured design and numerical screening.

## 4.1 Research Motivation

B5.1–B5.2 revealed that:

- Reference-pose sensing performance can be misleading.
- Cable pairing strongly affects geometric feasibility.
- Candidate expansion alone does not guarantee better designs.
- Arbitrary anchor locations on frame faces may be difficult to install.
- Structured spatial configurations deserve further investigation.

The B5.3 design method was informed by literature reviewed in:

`02_Paper_Reading/Literature_Review/workspace definition/`

The twelve-rail restriction is a project-specific mechanical design constraint informed by literature and prototype requirements.

It is not a claim that all cable-driven parallel robots require twelve rails.

## 4.2 Lesson 2.1 — Twelve-Rail Geometry

**Status:** Completed.

Numerically verified:

| Item | Result |
|---|---:|
| Complete frame-edge rails | 12 |
| X-direction rails | 4 |
| Y-direction rails | 4 |
| Z-direction rails | 4 |
| Raw candidate records | 60 |
| Unique candidate coordinates | 44 |
| Shared corners | 8 |

Verified output:

`B5_3_12rail_geometry_baseline.mat`

Both spatial coordinates and Rail ID metadata are retained.

This is necessary because identical physical corner positions can belong to different rails.

## 4.3 Lesson 2.2 — Mechanical Interface Assumptions

**Status:** Preliminary design discussion completed; detailed mechanical verification remains open.

Established decisions:

- Anchor points are restricted to the twelve frame edges.
- The first prototype may use fixed mounting points.
- Future adjustment interfaces may be retained.
- A pulley centre or slider position is not automatically the effective cable exit point.
- Actual cable guide and pulley offsets require later engineering review.

Still required:

- Slider dimensions.
- Rail-end exclusion zones.
- Mounting bracket dimensions.
- Pulley/guide geometry.
- Connector envelope.
- Actual cable exit-point coordinates.

These parameters must not be invented merely to complete an optimisation.

## 4.4 Lesson 2.3 — Measurement Requirements

**Status:** Preliminary criteria discussed; final numerical acceptance thresholds not established.

Research priority:

**Sensing accuracy is the primary functional objective, subject to hard geometry and mechanical feasibility requirements.**

Required future measurements include:

- Position and orientation RMSE.
- Cable length sensor uncertainty.
- Geometric clearance.
- Installation repeatability.
- Estimator convergence.
- Cable stroke.
- Low-tension disturbance.

Real acceptance thresholds require experimental needs, hardware specifications or calibration evidence.

## 4.5 Lesson 3 — Structured Configuration Families

**Status:** Completed.

Three literature-informed design hypotheses were defined.

| Family | Rail Composition | Main Hypothesis |
|---|---|---|
| S1 — Structured Layered | 4 X + 2 Z | Layered structure may improve geometric coverage and maintain sensing |
| S2 — Distributed | 2 X + 2 Y + 2 Z | Distributed spatial directions may improve measurement independence |
| S3 — Asymmetric | 1 X + 2 Y + 3 Z | Controlled asymmetry may improve some weak sensing directions |

Six anchor layouts were generated for each family.

Total:

\[
18\text{ anchor layouts}
\]

These families are proposed hypotheses, not proven optimal designs.

## 4.6 Lesson 4 — Attachments and Pairings

**Status:** Completed for the initial candidate search.

The procedure used:

1. Twelve-rail anchor layouts.
2. Balloon-surface attachment candidates.
3. Attachment spacing requirements.
4. Cable pairing enumeration or search.
5. Reference-pose geometry checks.
6. Reference-pose sensing evaluation.

Pairing search considered up to:

\[
6!=720
\]

per fixed set of six anchor and six attachment points.

The original candidate-search records tested 3600 pairing combinations per anchor layout across the attachment-selection trials.

## 4.7 Lesson 5 — Core Multi-Pose Screening

**Status:** Completed.

The Core development set contained:

\[
27\times7=189\text{ poses}
\]

Each candidate was checked for:

- Cable–sphere outward direction.
- Cable–cable interference.
- Jacobian rank.
- Worst scaled \(\sigma_{\min}\).
- Condition number.
- Cable lengths and stroke.

Six configurations passed all 189 Core geometry and rank checks.

\[
\boxed{[2,\ 4,\ 6,\ 8,\ 12,\ 17]}
\]

| Config | Family | Core Geometry | Worst-Core \(\sigma_{\min}\) | Minimum Cable Distance |
|---|---|---:|---:|---:|
| 2 | S1 | 189/189 | 0.396711 | 4.6508 mm |
| 4 | S1 | 189/189 | 0.202621 | 34.2128 mm |
| 6 | S1 | 189/189 | 0.268443 | 18.1059 mm |
| 8 | S2 | 189/189 | 0.226512 | 9.5408 mm |
| 12 | S2 | 189/189 | 0.366266 | 9.3165 mm |
| 17 | S3 | 189/189 | 0.278687 | 15.2926 mm |

**B5.3 Research Decision:**

Retain all six configurations for further comparison.

Config 2 was selected as the first detailed optimisation case because it had the highest Worst-Core \(\sigma_{\min}\) among these six initial candidates.

This did not establish Config 2 as globally optimal.

---

# 5. Completed Research — B5.4 Initial Studies

## 5.1 Lesson 1 — Unified Evaluation

**Status:** Completed.

A common numerical evaluator was used to analyse all eighteen B5.3 configurations.

Verification included:

- Geometry results.
- Rank results.
- Jacobian singular values.
- Condition numbers.
- Cable lengths.
- Cable distances.

Regression checks reproduced the stored B5.3 results.

**Outcome:**

A common evaluation basis for controlled optimisation experiments.

## 5.2 Lesson 2 — Minimal Nonlinear Pose Estimator

**Status:** Preliminary simulation completed.

Research question:

> Can six simulated cable-length measurements reconstruct unknown six-degree-of-freedom pose?

Method:

- Nonlinear least squares.
- Damped Gauss–Newton updates.
- Rotation updates on SO(3).
- Identical initialisation for controlled comparisons.
- Ground truth used for measurement generation and final error calculation only.

Noise-free evaluation:

- Six configurations.
- Twelve selected poses per configuration.
- 72 total tests.
- All 72 converged.
- Recovered poses were numerically close to ground truth.

This verifies basic numerical consistency, not global uniqueness or real sensor accuracy.

## 5.3 Lesson 2.1 — Simulated Noise Sensitivity

**Status:** Completed under assumed noise conditions.

Noise model:

\[
\epsilon_i\sim\mathcal N(0,0.1^2)\ \mathrm{mm}
\]

Experiment:

- Six configurations.
- Twelve poses per configuration.
- Thirty repetitions per pose.
- 2160 total nonlinear reconstructions.

All 2160 tests converged.

| Config | Position RMSE (mm) | Orientation RMSE (deg) |
|---|---:|---:|
| 2 | 0.18259 | 0.21444 |
| 4 | 0.18778 | 0.32122 |
| 6 | 0.25253 | 0.27455 |
| 8 | 0.20286 | 0.28363 |
| 12 | **0.16779** | 0.25736 |
| 17 | 0.24053 | 0.26899 |

**Research Outcome:**

Different configurations amplify identical cable-length noise differently.

Config 12 obtained the lowest simulated position RMSE.

Config 2 obtained the lowest simulated orientation RMSE.

These results do not establish experimental accuracy.

---

# 6. Completed Research — E1a-A Config 2 Optimisation

**Status:** Completed numerical case study.

## 6.1 Research Question

Can changing the six anchor positions along their already selected rails improve geometry and sensing without changing attachment points or pairing?

### Fixed Variables

- Rail assignment.
- Attachment coordinates.
- Cable pairing.

### Optimisation Variables

\[
t=[t_1,t_2,t_3,t_4,t_5,t_6]
\]

## 6.2 Initial Configuration

**Config 2 — S1 Structured Layered**

Rail assignment:

```matlab
rho = [5 6 7 8 1 4];
```

Initial rail positions:

```matlab
t0 = [0.4 0.6 0.55 0.45 0.7 0.3];
```

Initial performance:

| Metric | Result |
|---|---:|
| Core geometry | 189/189 |
| Worst-Core \(\sigma_{\min}\) | 0.396711 |
| Minimum cable distance | 4.6508 mm |

## 6.3 Lesson 3.1 — Single-Variable Rail Scan

**Status:** Completed.

Each anchor was independently adjusted using:

\[
\Delta t_i\in\{-0.10,-0.05,0,+0.05,+0.10\}
\]

Only one variable was modified per experiment.

Twenty-five unique configurations were evaluated.

Results:

- 21/25 configurations remained Core-eligible.
- C1 and C4 showed strong geometric sensitivity near particular boundaries.
- C2 and C6 adjustments could improve cable clearance.
- C3 and C5 adjustments could improve Worst-Core sensing.

**Decision:**

Identify each anchor's conditional feasible region before coordinated search.

## 6.4 Lesson 3.2 — Conditional Feasible Rail Intervals

**Status:** Completed.

Each rail position was scanned over:

\[
t_i\in[0,1]
\]

The other five anchor positions remained fixed.

| Cable | Rail | Detected Conditional Feasible Interval |
|---|---|---|
| C1 | R5 | [0, 0.401382] |
| C2 | R6 | [0, 0.893796] |
| C3 | R7 | [0, 0.878574] |
| C4 | R8 | [0.434622, 1] |
| C5 | R1 | [0.459610, 1] |
| C6 | R4 | [0, 0.503787] |

**Important:**

These are sampled and refined single-variable feasible intervals.

They are not proven continuous feasible regions and are not permanent hard constraints for joint optimisation.

## 6.5 Lesson 3.3 — Sequential Coordinate Search

**Status:** Completed.

Two controlled searches were conducted.

### Search A — Sensing-Oriented

Primary objective:

Maximise Worst-Core \(\sigma_{\min}\).

Protection condition:

Do not reduce minimum cable distance below the original baseline.

### Search B — Clearance-Oriented

Primary objective:

Maximise minimum cable distance.

Protection condition:

Do not reduce Worst-Core \(\sigma_{\min}\) below the original baseline.

| Result | Original | Sensing-Oriented | Clearance-Oriented |
|---|---:|---:|---:|
| Core Geometry | 189/189 | 189/189 | 189/189 |
| Worst-Core \(\sigma_{\min}\) | 0.396711 | 0.522643 | 0.401213 |
| Minimum cable distance (mm) | 4.6508 | 6.1055 | 9.2340 |

The initial Sensing-oriented result increased Worst-Core \(\sigma_{\min}\) by approximately 31.7%.

However, this result was obtained before subsequent off-grid failure diagnosis and repair.

It must not be used as the final repaired configuration's performance figure.

## 6.6 Lessons 3.4–3.5 — Off-Grid Verification and Failure Diagnosis

**Status:** Completed.

The first additional 150-pose set identified a common C1 Cable–sphere failure at Pose 149.

The later 200-pose set identified a separate C4 failure for the Sensing-oriented candidate at Pose 164.

These findings demonstrated that:

- Core 189/189 is not sufficient to guarantee combined-motion feasibility.
- A candidate with strong sensing may lie close to a geometric failure boundary.
- Failure identification should guide local repair rather than triggering blind random search.

## 6.7 Targeted C1 and C4 Repair

**Status:** Completed.

C1 repair:

\[
t_1:0.400\rightarrow0.375
\]

C4 repair:

\[
t_4:0.434622\rightarrow0.470
\]

The repairs were performed with the other design variables fixed during each targeted experiment.

## 6.8 Current Preferred E1a Configuration

**Configuration ID:** `E1a_Robust_Config2_v1`

Rail assignment:

```matlab
rho = [5 6 7 8 1 4];
```

Final selected rail parameters:

```matlab
t_E1a = [ ...
    0.375000 0.446898 0.304465 ...
    0.470000 0.754805 0.314867 ];
```

Selected anchor coordinates:

| Cable | Rail | Anchor X (mm) | Anchor Y (mm) | Anchor Z (mm) |
|---|---|---:|---:|---:|
| C1 | R5 | −35.0000 | −150 | −160 |
| C2 | R6 | −14.8686 | 150 | −160 |
| C3 | R7 | −54.7498 | −150 | 160 |
| C4 | R8 | −8.4000 | 150 | 160 |
| C5 | R1 | −140 | −150 | 81.5376 |
| C6 | R4 | 140 | 150 | −59.2426 |

The six attachment points and cable pairing remain unchanged from B5.3 Config 2.

### Final Sampled Results

| Metric | Result |
|---|---:|
| Combined sampled geometry | 539/539 |
| Combined sampled Rank 6 | 539/539 |
| Worst scaled \(\sigma_{\min}\) over 539 poses | 0.508750 |
| Minimum ideal Cable–cable distance | 6.1055 mm |
| Minimum outward angular margin | +1.545778° |
| Installation perturbation passing cases | 12/12 |
| Worst perturbed outward angular margin | +1.1734° |
| Worst perturbed cable distance | 6.0597 mm |

The candidate `t4=0.450` is retained as a sensing-favoured alternative.

### E1a-A Conclusion

Config 2 can be significantly improved by rail-position adjustment alone.

The final selected design provides:

- Better ideal Cable–cable distance than the original Config 2.
- Corrected C1 and C4 interference at the observed failure poses.
- Full geometric and rank passing on the 539-pose development set.
- Improved outward angular margin.
- Successful independent single-anchor perturbation checks at the assumed perturbation level.

The candidate is **not** a globally optimal or experimentally validated prototype configuration.

---

# 7. NEXT PRIORITY — B5.4 E1a-B Six-Configuration Fair Comparison

**Status:** Not started.

## 7.1 Research Question

> After equivalent anchor rail-position optimisation, which of the six Core-eligible configurations provides the most promising combination of sensing quality, geometric feasibility and robustness?

Candidate set:

```matlab
config_ids = [2 4 6 8 12 17];
```

The selected configurations belong to:

- S1: Configs 2, 4 and 6.
- S2: Configs 8 and 12.
- S3: Config 17.

## 7.2 Why This Stage Is Necessary

Config 2 has undergone extensive optimisation, failure diagnosis and targeted repair.

The other five configurations have not received equivalent treatment.

Therefore, comparing final Config 2 against the other five unoptimised configurations would be unfair.

E1a-B must evaluate what each configuration can achieve under a common optimisation method and comparable computational effort.

The result may confirm Config 2's advantage, or identify another configuration with a better sensing–geometry–robustness balance.

## 7.3 Controlled Variables

For each configuration:

**Fixed**

- Rail assignment \(\rho\).
- Attachment coordinates \(r\).
- Cable pairing \(\pi\).

**Optimised**

- Six rail-position parameters \(t_1,\ldots,t_6\).

Each configuration retains its own original geometry.

Do not transplant Config 2's Rail ID, attachment arrangement or conditional feasible intervals into the other candidates.

## 7.4 Fair Comparison Rules

The following must be consistent:

1. Same MATLAB evaluation logic.
2. Same pose-set definitions.
3. Same outward-direction criterion.
4. Same cable-contact criterion.
5. Same Jacobian scaling.
6. Same rank tolerance.
7. Same optimisation strategy.
8. Comparable candidate-evaluation budgets.
9. Same objective and constraint definitions.
10. Same final validation protocol.

The existing Config 2 optimisation is retained as historical evidence.

For a strict algorithmic comparison, all six candidates should also undergo a **standardised optimisation run**, including Config 2.

The historical hand-tuned repairs of Config 2 must not receive an unreported advantage over other configurations.

## 7.5 Lesson E1a-B.1 — Baseline Verification and Evaluation Dataset

**Research Question**

Can all six historical configurations be reproduced under one evaluator and one common pose set?

**Tasks**

1. Load the six original B5.3 configurations.
2. Reproduce the stored Core 189 results.
3. Verify Rail ID and anchor coordinates.
4. Verify attachment coordinates and pairing.
5. Define the common development pose set.
6. Preserve the historical 539-pose results as development/diagnostic evidence.
7. Define a fresh holdout validation protocol.
8. Record the baseline performance of all six configurations.

**Expected Outputs**

- Six-configuration baseline table.
- Saved immutable configuration structures.
- Common evaluator regression report.
- Pose-set specification.
- Holdout generation and handling rules.

**Acceptance**

All six baseline configurations must reproduce their historical results before any optimisation begins.

## 7.6 Lesson E1a-B.2 — Unified Optimisation Objective and Constraints

**Research Question**

How can sensing quality and geometric constraints be evaluated fairly across different starting configurations?

**Proposed Hard Constraints**

For the common development pose set:

- Required geometric feasibility.
- Full Jacobian rank.
- Valid anchor positions on assigned rails.
- No numerical Cable–sphere penetration.
- No numerical Cable–cable contact.

Physical clearance and mounting requirements must remain provisional until actual dimensions are available.

**Primary Sensing Objective**

\[
\max_t\min_{q\in Q_{\mathrm{dev}}}
\sigma_{\min}(H_s(q;t))
\]

**Secondary Comparison Metrics**

- Maximum condition number.
- Minimum outward angular margin.
- Minimum Cable–cable distance.
- Cable length and stroke.
- Position RMSE.
- Orientation RMSE.
- Installation perturbation sensitivity.

A configuration that fails a hard constraint must not be treated as the best feasible design merely because its sensing metric is high.

**Acceptance**

A common evaluator and decision rule must be documented before optimisation.

## 7.7 Lesson E1a-B.3 — Standardised Rail-Position Optimisation

**Research Question**

What improvement can each initial configuration achieve through position-only optimisation?

**Method**

Use the mature E1a method:

1. Baseline parameter verification.
2. Single-variable sensitivity.
3. Conditional rail-position feasibility scan.
4. Sequential coordinate optimisation.
5. Common multi-pose geometry checks.
6. Worst-case sensing evaluation.
7. Failure diagnosis and recording.

Use consistent:

- Search increments.
- Number of sweeps.
- Candidate sampling density.
- Maximum evaluation budget.
- Stopping rules.
- Numerical tolerances.

If an algorithmic extension or additional repair is permitted, the same opportunity and reporting rules must apply to all six configurations.

**Expected Outputs**

- Optimised \(t\) for each configuration.
- Updated anchor coordinates.
- Number of evaluated candidates.
- Number of feasible candidates.
- Optimisation history.
- Rejected trial diagnostics.

## 7.8 Lesson E1a-B.4 — Geometry and Robustness Comparison

**Research Question**

Do the improved configurations remain feasible under common combined-pose and installation tests?

**Method**

Evaluate all optimised configurations using:

- A common development pose set.
- Additional diagnostic stress poses where justified.
- The same installation perturbation assumptions.
- Common minimum outward-angle calculations.
- Common Cable–cable distance calculations.
- Cable length and stroke indicators.

If new failures are discovered, keep the failure records.

Any subsequent repair makes those diagnostic poses part of the development process.

Use a new untouched holdout only after the shortlisted configurations have been frozen.

**Acceptance**

Record:

- Geometry passing counts.
- Rank passing counts.
- Worst-case sensing.
- Minimum outward margin.
- Minimum cable clearance.
- Installation perturbation outcomes.
- Failure locations and causes.

## 7.9 Lesson E1a-B.5 — Pose Estimation and Pareto Comparison

**Research Question**

Do the Jacobian-based indicators correspond to actual simulated pose-estimation performance, and which configurations merit continued optimisation?

**Method**

Run common nonlinear pose-estimation tests under:

- Identical pose samples.
- Identical assumed noise models.
- Identical random noise realisations where appropriate.
- Identical initialisation policies.
- Consistent solver tolerances.

Report:

- Position RMSE.
- Orientation RMSE.
- Maximum estimation errors.
- Failure and convergence rates.
- Worst-case \(\sigma_{\min}\).
- Maximum condition number.
- Geometry and clearance metrics.

Compare sensing, robustness and practical geometry without arbitrarily combining incompatible units.

**Expected Decision**

Select a **shortlist**, not necessarily a single winner.

Retain different families when they offer meaningful alternatives.

## 7.10 E1a-B Completion Criteria

- [ ] All six historical baselines reproduced.
- [ ] Common development and validation rules established.
- [ ] All six configurations given equivalent optimisation effort.
- [ ] Anchor positions remain on assigned rails.
- [ ] Same geometry and rank requirements applied.
- [ ] All optimisation outcomes and failed candidates recorded.
- [ ] Common robustness tests completed.
- [ ] Common pose-estimation comparison completed.
- [ ] Independent holdout results reported.
- [ ] Pareto-relevant shortlist selected.
- [ ] Research Log saved.

**Gate E1a-B → E1b**

Proceed when the rail-position optimisation method has been applied fairly and a defensible shortlist exists.

Do not claim that one Family is universally superior based on the limited initial sample of configurations.

---

# 8. B5.4 E1b — Rail Assignment Optimisation

**Status:** Planned after E1a-B.

## 8.1 Research Question

> Can changing which frame-edge rails support the six cables improve geometry and sensing beyond position-only optimisation?

## 8.2 Design Variables

**Variable**

- Rail assignment \(\rho_i\).
- Anchor rail position \(t_i\) on the selected rail.

**Fixed Initially**

- Attachment coordinates.
- Cable pairing.

## 8.3 Why E1b Is Needed

E1a can only move an anchor along its existing rail.

For example:

\[
A_i=A(\rho_i,t_i)
\]

If a rail assignment creates an unfavourable cable departure direction, position changes alone may have limited improvement potential.

Changing \(\rho_i\) can alter the available three-dimensional cable direction and the mechanical routing.

However, rail reassignment may also introduce interference or poor Jacobian conditioning.

Therefore, it must be evaluated rather than assumed beneficial.

## 8.4 Lesson E1b.1 — Rail Reassignment Rules

Define:

- Available rails.
- Allowed anchor occupancy.
- Shared-corner policy.
- Duplicate mounting restrictions.
- Rail-end constraints.
- Physical accessibility.
- Fixed attachment and pairing definitions.

**Output:** Valid rail-assignment search rules.

## 8.5 Lesson E1b.2 — Single-Cable Rail Reassignment

Start from the E1a-B shortlist.

For each selected configuration:

1. Fix five anchor rail assignments.
2. Reassign one cable to an alternative permitted rail.
3. Optimise its \(t_i\) on the new rail.
4. Check geometry and sensing.
5. Compare results with the original assignment.
6. Record failures and viable alternatives.

**Purpose:** Isolate the effect of changing a particular cable's mounting rail.

## 8.6 Lesson E1b.3 — Coordinated Rail Reassignment

If single-cable reassignment reveals promising alternatives, consider coordinated changes to multiple rail assignments.

The search may use:

- Structured candidate families.
- Selected rail combinations.
- Deterministic search.
- Reproducible discrete optimisation.

All candidates must retain valid mounting geometry.

## 8.7 Lesson E1b.4 — Matched Multi-Pose Evaluation

Compare:

- Best E1a configuration with fixed rails.
- Best E1b configurations with reassigned rails.

Use common:

- Development poses.
- Geometry rules.
- Sensing indicators.
- Robustness assumptions.
- Validation protocol.

**Expected Decision**

Determine whether rail reassignment provides meaningful gains that justify additional mechanical complexity.

---

# 9. B5.4 E2 — Attachment Point Optimisation

**Status:** Planned.

## 9.1 Research Question

> How much additional sensing improvement can be obtained by optimising balloon-surface attachment locations while keeping anchor locations and pairing controlled?

## 9.2 Controlled Variables

**Variable**

- Balloon attachment positions \(r_i\).

**Fixed**

- Rail assignments.
- Anchor positions.
- Cable pairing indices.

For a rigid spherical balloon:

\[
\|r_i\|=r_b
\]

## 9.3 Research Procedure

### Lesson E2.1 — Attachment Design Space

Define:

- Sphere parameterisation.
- Candidate distribution.
- Attachment spacing.
- Mechanical attachment restrictions.
- Sampling density and refinement rules.

### Lesson E2.2 — Attachment-Only Search

Evaluate attachment changes under common geometry and sensing constraints.

### Lesson E2.3 — Multi-Pose Screening

Check:

- Cable–sphere departure.
- Cable–cable interference.
- Jacobian rank.
- Worst-case sensing.
- Configuration robustness.

### Lesson E2.4 — Independent Comparison

Compare E2 against the matched fixed-anchor baseline.

## 9.4 Expected Outcome

Quantify the contribution of attachment-point selection independently of new anchor changes.

---

# 10. B5.4 E3 — Cable Pairing Optimisation

**Status:** Planned.

## 10.1 Research Question

> Can rearranging the correspondence between fixed anchor and attachment point sets improve geometry or sensing without physically moving either set?

## 10.2 Controlled Variables

**Variable**

- Pairing permutation \(\pi\).

**Fixed**

- Anchor point set.
- Attachment point set.

## 10.3 Research Procedure

1. Enumerate or systematically search pairing permutations.
2. Check all six Cable–sphere departure conditions.
3. Evaluate all fifteen Cable–cable distances.
4. Calculate Jacobian rank and sensing indicators.
5. Compare multi-pose feasibility.
6. Record routing consequences.
7. Validate shortlisted pairings on common poses.

The historical Original B/B′ example demonstrates that pairing may improve geometry while substantially degrading sensing.

## 10.4 Expected Outcome

Determine whether pairing changes provide meaningful improvements beyond anchor and attachment optimisation.

---

# 11. B5.4 E4 — Joint Configuration Optimisation

**Status:** Planned.

## 11.1 Research Question

> Can simultaneous optimisation of rail assignment, rail position, attachment points and pairing outperform the separate controlled experiments?

## 11.2 Full Design Representation

\[
\mathcal C_6=
\{\rho_i,t_i,r_i,\pi\}_{i=1}^{6}
\]

The variables include:

- Discrete Rail IDs.
- Continuous rail parameters.
- Sphere-surface attachment coordinates.
- Discrete pairing permutations.

## 11.3 Proposed Objective

A primary sensing objective is:

\[
\max_{\mathcal C_6}
\min_{q\in Q_{\mathrm{dev}}}
\sigma_{\min}(H_s(q;\mathcal C_6))
\]

subject to:

- Valid installation regions.
- Cable–sphere feasibility.
- Cable–cable feasibility.
- Full-rank local sensing.
- Applicable engineering constraints.

The design should also be evaluated using:

- Outward angular margin.
- Physical Cable–cable clearance when dimensions are known.
- Pose-estimation error.
- Cable length and stroke.
- Mounting complexity.
- Installation and calibration sensitivity.

## 11.4 Search Approach

Potential algorithms include:

- Multi-start coordinate search.
- Structured discrete search.
- Evolutionary optimisation.
- Particle swarm optimisation.
- Hybrid discrete–continuous optimisation.

Algorithm choice must be justified by the actual design space and computational requirements.

Do not introduce a complex algorithm solely because it appears in the literature.

## 11.5 Validation and Decision

Compare E4 with the strongest E1a, E1b, E2 and E3 candidates under matched criteria.

Retain Pareto-relevant configurations.

Do not claim global optimality without appropriate evidence.

---

# 12. B5.4 Final Robustness and Design Shortlist

**Status:** Planned after controlled and joint optimisation.

## 12.1 Research Question

> Which configurations remain geometrically feasible, sufficiently observable and mechanically plausible when tested beyond their nominal optimisation conditions?

## 12.2 Required Tests

### Unseen Poses

- New combined translation and rotation samples.
- Stress poses near observed geometric boundaries.
- Relevant motion paths.
- Continuous-workspace assessment where practical.

### Installation Uncertainty

- Individual anchor errors.
- Simultaneous anchor errors.
- Attachment placement errors.
- Systematic mounting bias.
- Effective pulley/guide offsets.

### Measurement Uncertainty

- Random length noise.
- Zero-point bias.
- Different sensor channels.
- Calibration error.
- Estimator initialisation and convergence.

### Physical Feasibility

- Actual cable diameter.
- Connector geometry.
- Pulley routing.
- Rail-end dead zones.
- Carriage and bracket clearance.
- Cable stroke.
- Low-tension feasibility.

## 12.3 Decision Criteria

Use hard feasibility requirements before ranking sensing performance.

A recommended shortlist should contain approximately two or three Pareto-relevant candidates where the evidence supports them.

The shortlist must record:

- Coordinates.
- Rail assignments.
- Attachment positions.
- Pairing.
- Geometry.
- Sensing performance.
- Robustness.
- Mechanical limitations.
- Outstanding validation requirements.

**Gate B5.4 → B5.5**

A shortlist exists with reproducible numerical evidence and an explicit independent validation plan.

The shortlist is not yet equivalent to experimentally validated Prototype V1.0 hardware.

---

# 13. B5.5 — Measurement Validation, Calibration and Protocol

**Status:** Planned.

## 13.1 Main Research Question

> How accurately and reliably can cable-length measurements reconstruct passive balloon pose under realistic measurement and modelling errors?

## 13.2 Lesson 1 — Noise and Bias Measurement Model

Define:

\[
L_{\mathrm{meas}}
=
L_{\mathrm{true}}+b+\epsilon
\]

where:

- \(b\): Measurement bias.
- \(\epsilon\): Random measurement error.

Study:

- Channel-specific noise.
- Zero-offset bias.
- Noise correlation.
- Tension-dependent error where relevant.
- Sensor repeatability.

Replace hypothetical values with calibrated measurements when available.

## 13.3 Lesson 2 — Nonlinear Pose Reconstruction

Validate:

- Position RMSE.
- Orientation RMSE.
- Maximum errors.
- Solver convergence.
- Initial-guess sensitivity.
- Multiple-solution behaviour.
- Computational performance.

Ground truth must not be passed into the estimator as an unknown state.

## 13.4 Lesson 3 — Calibration and Model Selection

Investigate:

- Effective anchor location.
- Actual attachment coordinates.
- Cable-length zero offsets.
- Pulley/guide geometry.
- Mechanical and sensor-related model mismatch.

Use independently designed calibration and validation data.

## 13.5 Lesson 4 — Independent Motion and Fault Tests

Test:

- Static poses.
- Combined translation and rotation.
- Previously unseen trajectories.
- Sensor noise and bias.
- Slack or missing Cable scenarios where relevant.
- Model-parameter errors.

## 13.6 Lesson 5 — Ground-Truth Measurement Protocol

Define:

- Independent pose reference method.
- Synchronisation.
- Calibration procedure.
- Test repetition.
- Data quality checks.
- Error reporting.
- Acceptance criteria.

## 13.7 Lesson 6 — Measurement Validation Report

Report actual numerical or experimental evidence separately.

Do not describe assumed simulated sensor noise as calibrated hardware accuracy.

**Gate B5.5 → B5.6**

An estimator, uncertainty model and independent validation protocol are available to guide the physical prototype.

---

# 14. B5.6 — Prototype Engineering and Decision

**Status:** Planned.

## 14.1 Main Research Question

> Can the shortlisted six-cable configuration be implemented as a practical low-tension sensing prototype?

## 14.2 Lesson 1 — Mechanical Interface Review

Investigate:

- Frame and rail construction.
- Fixed mounting points.
- Future adjustment interfaces.
- Slider and bracket geometry.
- Pulley exit-point offsets.
- Cable guide location.
- Attachment fixtures.
- Collision clearance.

## 14.3 Lesson 2 — Cable Travel and Measurement Hardware

Determine:

- Cable-length ranges.
- Required stroke.
- Motor and winding requirements.
- Cable-length sensing.
- Sensor resolution and repeatability.
- Electrical and data acquisition requirements.

## 14.4 Lesson 3 — Low-Tension Feasibility

Investigate:

- Slack prevention.
- Positive cable tension.
- Resultant balloon force and torque.
- Passive motion disturbance.
- Motor-assisted cable following.
- Sensor and tension compatibility.

Do not treat active-robot wrench-closure optimisation as the primary sensing objective.

## 14.5 Lesson 4 — Assembly and Calibration

Record:

- Actual Anchor coordinates.
- Rail mounting settings.
- Effective cable exit points.
- Attachment positions.
- Sensor offsets.
- Calibration results.

## 14.6 Lesson 5 — Prototype Measurement Experiments

Evaluate:

- Static pose measurements.
- Combined motion.
- Passive balloon motion.
- Position and orientation accuracy.
- Cable tension behaviour.
- Repeatability.
- Measurement failures.

## 14.7 Lesson 6 — Prototype V1.0 Decision

Possible outcomes:

- Retain the configuration.
- Adjust anchor positions.
- Change Rail Assignment.
- Modify Attachment Points.
- Reconsider Pairing.
- Modify sensor or mechanical hardware.

The decision must be supported by measurement evidence.

A successfully assembled frame alone does not establish sensing performance.

---

# 15. Controlled-Variable Experiment Matrix

| Experiment | Rail Assignment | Rail Position | Attachment | Pairing | Main Purpose |
|---|---|---|---|---|---|
| E0 | Fixed | Fixed | Fixed | Fixed | Common baseline |
| E1a-A | Fixed | Variable | Fixed | Fixed | Develop and verify optimisation method on Config 2 |
| E1a-B | Fixed | Variable | Fixed | Fixed | Fair comparison of six candidates |
| E1b | Variable | Variable | Fixed | Fixed | Rail Assignment effect |
| E2 | Fixed | Fixed | Variable | Fixed | Attachment effect |
| E3 | Fixed | Fixed | Fixed | Variable | Pairing effect |
| E4 | Variable | Variable | Variable | Variable | Coupled optimisation |

**Interpretation rule:**

Controlled experiments isolate the effect of selected changes under fixed surrounding conditions.

They do not imply the full configuration variables are physically independent.

Joint optimisation is needed to study interactions.

---

# 16. Research Requirements and Traceability

| Requirement | Evaluation Method | Current State |
|---|---|---|
| R-GEO-01 — Valid Rail Membership | Rail assignment and coordinate verification | Twelve-rail model verified |
| R-GEO-02 — Cable–sphere Feasibility | Outward-direction tests over sampled poses | Numerical model verified |
| R-GEO-03 — Cable–cable Feasibility | Finite-segment distances | Ideal model verified; physical clearance TBD |
| R-GEO-04 — Outward Margin | Minimum angular departure margin | Introduced and evaluated in E1a |
| R-SEN-01 — Full Local Rank | Jacobian rank | Numerical tests completed |
| R-SEN-02 — Sensing Conditioning | Worst \(\sigma_{\min}\), maximum \(\kappa\) | Numerical tests completed |
| R-SEN-03 — Pose Estimation | RMSE, maximum error, convergence | Preliminary simulated tests completed |
| R-SEN-04 — Measurement Calibration | Sensor and geometry calibration | Planned |
| R-ROB-01 — Unseen Pose Robustness | Common holdout and stress tests | E1a development tests completed; fresh holdout pending |
| R-ROB-02 — Installation Robustness | Anchor and attachment perturbations | Independent-anchor numerical tests completed; broader tests pending |
| R-MECH-01 — Mountability | Actual rail, carriage and pulley geometry | TBD |
| R-MECH-02 — Cable Travel | Length/stroke analysis | Preliminary simulation available; hardware sizing pending |
| R-MECH-03 — Cable Tension | Positive-tension and disturbance analysis | Pending |
| R-VAL-01 — Independent Ground Truth | Calibrated pose reference | Pending |
| R-VAL-02 — Experimental Accuracy | Position/orientation error | Pending |

No unknown physical requirement should be assigned an arbitrary threshold and reported as an established engineering fact.

---

# 17. File Organisation and Documentation Workflow

## 17.1 Research Management

```text
08_Project_Management/
    Roadmap.md

08_Project_Management/November/
    B5_3_to_B5_6_Revised_Research_Plan_Thesis_Informed_2026_11_10.md
```

## 17.2 Current Research State

```text
CURRENT_STATE2.md
AGENTS2.md
```

## 17.3 Literature

```text
02_Paper_Reading/Literature_Review/workspace definition/
```

## 17.4 MATLAB and Numerical Evidence

```text
03_Simulation/MATLAB/
06_Research_Log/2026-11/
```

### Verified or Reported Numerical Data

- `B5_3_12rail_geometry_baseline.mat`
- `B5_3_12rail_anchor_families.mat`
- `B5_3_initial_six_cable_configurations.mat`
- `B5_4_unified_evaluation_baseline.mat`
- `B5_4_pose_estimator_baseline.mat`
- `B5_4_noise_sensitivity_baseline.mat`
- `B5_4_E1a_Config2_rail_position_scan.mat`
- `B5_4_E1a_Config2_feasible_rail_intervals.mat`
- `B5_4_E1a_Config2_sequential_optimisation.mat`
- `B5_4_E1a_Config2_robustness_verification.mat`
- `B5_4_E1a_C1_targeted_repair.mat`
- `B5_4_E1a_C1_repair_robustness.mat`
- `B5_4_E1a_C4_targeted_repair.mat`
- `B5_4_E1a_final_robustness.mat`

These filenames identify outputs reported during the research sessions. Their presence in the GitHub repository should be checked separately; a reported MATLAB save does not prove that the file has been committed.

## 17.5 Documentation Rules

For every research lesson:

1. Define the Research Question.
2. Explain why the task is needed.
3. Identify literature and mathematical support.
4. Define fixed and variable parameters.
5. Provide one complete Chinese-commented MATLAB implementation.
6. Run the numerical experiment.
7. Interpret actual results.
8. Answer research reflection questions.
9. Make the next research decision.
10. Record verified evidence in the appropriate Research Log.

GitHub updates remain manual and file-by-file.

Do not overwrite historical experimental evidence merely because the current design has improved.

---

# 18. Priority and Research Schedule

The sequence below describes research dependencies rather than guaranteed completion dates.

| Priority | Research Block | Current Status | Main Output |
|---|---|---|---|
| 1 | Research summary and GitHub consistency review | In progress | Consistent research documentation |
| 2 | Presentation of B1–B5.4 progress | Planned | Research progress PPT |
| 3 | E1a-B.1 Baseline and evaluation-set verification | Next technical task | Common six-config baseline |
| 4 | E1a-B.2 Objectives and constraints | Planned | Standardised optimisation specification |
| 5 | E1a-B.3 Six-config optimisation | Planned | Optimised rail positions |
| 6 | E1a-B.4 Geometry and robustness | Planned | Common feasibility results |
| 7 | E1a-B.5 Estimation and Pareto comparison | Planned | Shortlist |
| 8 | E1b Rail Assignment | Planned | Alternative rail layouts |
| 9 | E2 Attachment | Planned | Attachment optimisation results |
| 10 | E3 Pairing | Planned | Pairing optimisation results |
| 11 | E4 Joint Optimisation | Planned | Jointly optimised shortlist |
| 12 | B5.5 Measurement Validation | Planned | Validated estimator and protocol |
| 13 | B5.6 Prototype Engineering | Planned | Prototype V1.0 decision |

## 18.1 Recommended E1a-B Research Sequence

At approximately four to five focused research hours per day, the E1a-B work may be organised into:

| Research Session | Main Task |
|---|---|
| Session 1 | Reproduce six baselines and define common pose sets |
| Session 2 | Establish objective, constraints and equal search budget |
| Sessions 3–4 | Apply standardised position optimisation |
| Session 5 | Analyse geometric failures and robustness |
| Session 6 | Compare simulated pose-estimation performance |
| Session 7 | Prepare Pareto shortlist and Research Log |

This is a planning allocation, not a promise of completion.

If additional debugging or independent validation is required, the schedule should be adjusted based on evidence.

## 18.2 Parallel Engineering Tasks

While configuration optimisation continues, investigate:

- Mechanical rail and carriage dimensions.
- Potential pulley/guide mounting approaches.
- Cable length sensor candidates.
- Tension sensor options.
- Independent ground-truth methods.
- Motor and cable-following concepts.

These tasks should inform later physical constraints without prematurely freezing the prototype.

---

# 19. Doctoral-Research Sources Informing the Plan

The doctoral theses below motivated the research-process structure, particularly configuration optimisation, calibration, pose estimation, prototype development and evidence-based design decisions.

They are methodological references rather than direct evidence that an active cable-driven robot's optimisation target is optimal for passive balloon sensing.

1. **Joshua T. Bryson (2016)** — *The Optimal Design of Cable-Driven Robots*, University of Delaware. Configuration design, workspace and performance optimisation, robustness and experimental design.  
   https://udspace.udel.edu/items/0ab52ba8-088d-4c14-ba90-359fe846357a

2. **Philipp Miermeister (2020; published 2021)** — *Model Selection and Parameter Optimization for Cable-Driven Parallel Robots*, University of Stuttgart. Parameter identification, modelling fidelity and calibration.  
   DOI: https://doi.org/10.18419/opus-11732

3. **Sara Gabaldo (2026)** — *Pose Estimation for Underactuated Cable-Driven Parallel Robots*, University of Bologna. Sensor-based pose estimation and nonlinear reconstruction.  
   DOI: https://doi.org/10.48676/unibo/amsdottorato/13196

4. **Ruobing Wang (2023)** — *Prototype Design and Time-Optimal Control of a Lower-Mobility Cable-Driven Parallel Robot*, Hong Kong Polytechnic University. Configuration design, workspace analysis and prototype implementation.  
   https://ira.lib.polyu.edu.hk/handle/10397/103800

5. **Valentina Mattioni (2023)** — *Mechanical Design and Hybrid Control Strategies for Overconstrained Cable-Driven Parallel Robots*, University of Bologna. Mechanical interfaces, pulley/guide systems and tension-related implementation.  
   DOI: https://doi.org/10.48676/unibo/amsdottorato/10738

6. **Damiano Zanotto (2011)** — *Analysis and Development of Cable-Driven Robotic Devices*, University of Padua. Task-oriented performance, mechanism development and experimental evidence.  
   https://www.research.unipd.it/handle/11577/3427530

### Citation Rules

For formal academic writing:

- Verify original thesis sections and figure numbers.
- Distinguish published results from project-specific adaptations.
- Do not claim unverified quantitative improvements.
- Do not transfer active-motion control objectives directly to passive sensing.
- Keep DOI and bibliographic information accurate.

---

# 20. Immediate Next Technical Action

## B5.4 E1a-B Lesson 1 — Six-Configuration Baseline Verification

Before starting new optimisation:

1. Load Configs `[2 4 6 8 12 17]`.
2. Reproduce their Core 189-pose geometric and sensing results.
3. Verify their Rail IDs and Anchor coordinates.
4. Verify their Attachment coordinates and Pairing.
5. Define a common development pose set.
6. Freeze the common evaluation criteria.
7. Define a fair search budget.
8. Specify the fresh holdout-validation protocol.
9. Save the baseline results without overwriting B5.3 or E1a-A evidence.

**Do not proceed to E1b or declare Config 2 the final winner before performing a fair multi-configuration E1a comparison.**

---

## Final Research Principle

> Geometry is a feasibility requirement. Sensing quality is the primary measurement objective. Robustness and mechanical implementation determine whether a numerically promising configuration can become a credible prototype.

**Current Preferred Numerical Reference:** `E1a_Robust_Config2_v1`  
**Current Technical Priority:** B5.4 E1a-B — Six-Configuration Fair Comparison  
**Future Stages:** E1b, E2, E3, E4, B5.5 and B5.6  
**Long-Term Direction:** Passive balloon pose sensing, experimental validation, deformation sensing and six-/seven-/eight-cable comparison.
