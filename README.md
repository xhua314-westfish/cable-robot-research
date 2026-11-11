# Cable-Robot-Based Sensing for a Passive Deformable Balloon

**Master's Research Project**  
**Last Updated:** 2026-11-12  
**Research Phase:** Six-Cable Configuration Design and Sensing Validation  
**Current Stage:** B5.4 — Configuration Optimisation  
**Primary Tool:** MATLAB

---

## 1. Research Overview

This project investigates a cable-based measurement system for estimating the position, orientation and eventually deformation of a passively moving balloon-like object.

The application is motivated by the concept of intragastric balloon monitoring within a simplified stomach-inspired environment.

### Main Research Question

> Can cable-length measurements be used to estimate the six-degree-of-freedom pose of a passively moving balloon, and how should cable configurations be designed to improve sensing performance while satisfying geometric and mechanical constraints?

The system focuses on **measurement and state estimation**, not active trajectory control.

The balloon undergoes passive and potentially irregular motion. Motors may follow cable displacement to maintain low positive tension, but must not prescribe the balloon's trajectory.

### Research Concept

```text
Passive Balloon Motion
          |
          v
Cable Length Changes
          |
          v
Cable Length Measurements
          |
          v
Mathematical Measurement Model
          |
          v
Pose Estimation
          |
          v
Position and Orientation
          |
          v
Experimental Validation
```

Future research will extend the model toward deformable-balloon sensing.

---

## 2. Research Objectives

### 2.1 Primary Objective — Six-Cable Sensing

Develop and evaluate a six-cable measurement system capable of reconstructing the rigid-body pose of a passive balloon.

The main research activities include:

- Anchor and attachment configuration design.
- Cable pairing and routing.
- Geometric feasibility analysis.
- Measurement Jacobian and sensing-quality evaluation.
- Nonlinear pose reconstruction.
- Robustness to motion and installation uncertainty.
- Mechanical implementation.
- Experimental measurement validation.

### 2.2 Long-Term Objective — Six-, Seven- and Eight-Cable Comparison

Investigate how cable number influences:

- Measurement redundancy.
- Local identifiability.
- Sensing accuracy.
- Estimation uncertainty.
- Geometric workspace.
- Cable interference.
- Tension feasibility.
- Implementation complexity.

The six-cable prototype will serve as the initial experimental reference.

Seven- and eight-cable theoretical studies may proceed in parallel.

Additional cables are not assumed to improve sensing automatically.

---

## 3. Engineering Model

The initial model uses a rigid spherical balloon inside a simplified rectangular boundary.

| Parameter | Definition |
|---|---|
| Application | Passive balloon sensing |
| Engineering boundary | 280 × 300 × 320 mm |
| X-axis | Length |
| Y-axis | Width |
| Z-axis | Height |
| Balloon volume | 550 mL |
| Balloon radius | 50.8266 mm |
| Initial balloon model | Rigid sphere |
| Rigid-body state | 6 DOF |
| Primary measurement | Cable length |
| Initial cable number | 6 |
| Anchor installation region | Twelve frame-edge rails |
| Attachment installation region | Balloon surface |
| Motion | Passive and unknown |

The rectangular boundary and spherical balloon are engineering approximations.

They are not clinically validated representations of gastric anatomy or physiological motion.

### 3.1 Cable Geometry

For cable \(i\):

\[
B_i=P+Rr_i
\]

\[
D_i=A_i-B_i
\]

\[
L_i=\|D_i\|
\]

where:

- \(A_i\): World-frame anchor position.
- \(r_i\): Body-frame attachment position.
- \(P\): Balloon-centre position.
- \(R\): Balloon orientation.
- \(B_i\): World-frame attachment position.
- \(L_i\): Cable length.

### 3.2 Measurement Jacobian

The local measurement Jacobian is:

\[
H_i=
\begin{bmatrix}
-u_i^T & (u_i\times Rr_i)^T
\end{bmatrix}
\]

with:

\[
u_i=\frac{D_i}{L_i}
\]

A six-cable configuration requires a full-rank \(6\times6\) measurement Jacobian for local first-order six-degree-of-freedom identifiability.

Full rank alone does not guarantee global pose uniqueness or experimental measurement accuracy.

---

## 4. Research Development

The research has progressed through several stages.

| Stage | Research Focus | Status |
|---|---|---|
| Phase 0 | Application definition and clinical evidence | Initial synthesis completed |
| Phase A | Literature-based method reproduction | Core scope completed |
| B1 | Initial geometry and candidate generation | Completed |
| B2 | Initial six-cable configuration search | Completed |
| B3 | Multi-pose geometric feasibility | Completed |
| B4 | Jacobian and local sensing analysis | Initial scope completed |
| B5.1 | Configuration audit and candidate expansion | Completed |
| B5.2 | Multi-pose configuration screening | Completed |
| B5.3 | Literature-informed twelve-rail configuration design | Completed |
| B5.4 — E1a-A | Config 2 anchor rail-position optimisation | Completed |
| B5.4 — E1a-B | Fair optimisation comparison of six configurations | Next technical task |
| B5.4 — E1b | Rail assignment optimisation | Planned |
| B5.4 — E2 | Attachment optimisation | Planned |
| B5.4 — E3 | Cable pairing optimisation | Planned |
| B5.4 — E4 | Joint configuration optimisation | Planned |
| B5.5 | Measurement validation and calibration | Planned |
| B5.6 | Prototype engineering and experimental decision | Planned |

The latest verified progress is maintained in [CURRENT_STATE2.md](CURRENT_STATE2.md).

---

## 5. Cable Configuration Design Development

### 5.1 Initial Candidate Generation — B1

The first configuration model used:

- 26 anchor candidates on the rectangular boundary.
- 40 attachment candidates on the spherical balloon.

These candidate sets provided a simple and reproducible initial search space.

### 5.2 Initial Configuration Optimisation — B2

The first experiments investigated:

- A symmetric six-cable baseline.
- Experiment A: variable attachments with fixed anchors.
- Experiment B: variable anchors and attachments.

The reference-pose Jacobian results improved substantially over the symmetric baseline.

However, later multi-pose evaluation revealed geometric interference.

### 5.3 Multi-Pose Evaluation — B3 and B4

The initial configurations were evaluated under multiple balloon positions and orientations.

Results showed that:

**Good reference-pose sensing does not necessarily imply good multi-pose geometric feasibility.**

This motivated a more systematic configuration design and evaluation strategy.

### 5.4 Candidate Expansion and Redesign — B5.1 and B5.2

The initial candidate sets were expanded:

| Candidate Type | Initial | Expanded |
|---|---:|---:|
| Anchor | 26 | 98 |
| Attachment | 40 | 100 |

The research also investigated:

- Original B.
- Modified B′.
- F1 — Six-Face Distributed.
- F2 — Opposite/Layered.
- F3 — Asymmetric.

These experiments demonstrated the importance of cable pairing, spatial configuration and multi-pose geometric constraints.

### 5.5 Literature-Informed Twelve-Rail Design — B5.3

Based on relevant cable-driven robot literature and prototype mounting requirements, anchor locations were restricted to the twelve edges of the rectangular frame.

Each anchor is represented by:

\[
A_i=A(\rho_i,t_i)
\]

where:

- \(\rho_i\): Rail assignment.
- \(t_i\): Normalised position along the rail.

Three structured configuration families were investigated:

| Family | Rail Arrangement | Main Design Hypothesis |
|---|---|---|
| S1 — Structured Layered | 4 X + 2 Z rails | Layered geometry and spatial coverage |
| S2 — Distributed | 2 X + 2 Y + 2 Z rails | Cable-direction diversity |
| S3 — Asymmetric | 1 X + 2 Y + 3 Z rails | Controlled asymmetric sensing geometry |

Six layouts were generated for each family, producing eighteen initial configurations.

### 5.6 Six Core-Eligible Configurations

After multi-pose geometric and sensing screening, six configurations passed all 189 Core geometric and rank checks:

```matlab id="jxk4ze"
eligible_config_ids = [2 4 6 8 12 17];
```

| Config | Family | Worst-Core \(\sigma_{\min}\) | Minimum Ideal Cable Distance |
|---|---|---:|---:|
| 2 | S1 | 0.396711 | 4.6508 mm |
| 4 | S1 | 0.202621 | 34.2128 mm |
| 6 | S1 | 0.268443 | 18.1059 mm |
| 8 | S2 | 0.226512 | 9.5408 mm |
| 12 | S2 | 0.366266 | 9.3165 mm |
| 17 | S3 | 0.278687 | 15.2926 mm |

Config 2 was selected as the first detailed anchor rail-position optimisation case because of its relatively strong Core sensing performance.

The six configurations remain candidates for future fair comparison.

---

## 6. Current B5.4 E1a Result

### 6.1 E1a — Anchor Rail Position Optimisation

E1a investigates how the six anchor positions affect geometry and sensing while keeping the following fixed:

- Rail assignment.
- Attachment positions.
- Cable pairing.

Only the normalised rail-position parameters are optimised:

\[
t=[t_1,t_2,t_3,t_4,t_5,t_6]
\]

The optimisation process included:

1. Single-variable sensitivity analysis.
2. Conditional feasible rail-position intervals.
3. Sequential coordinate optimisation.
4. Sensing-oriented and clearance-oriented comparisons.
5. Off-grid pose validation.
6. Cable–sphere failure diagnosis.
7. Targeted C1 and C4 repair.
8. Installation perturbation testing.

### 6.2 Current Preferred Numerical Configuration

**Configuration ID:** `E1a_Robust_Config2_v1`

**Family:** S1 — Structured Layered

**Rail Assignment:**

```matlab id="62c3kz"
rho = [5 6 7 8 1 4];
```

**Optimised Rail Positions:**

```matlab id="77fzkw"
t_E1a = [ ...
    0.375000 0.446898 0.304465 ...
    0.470000 0.754805 0.314867 ];
```

### 6.3 Current Numerical Performance

| Metric | Result |
|---|---:|
| Combined sampled geometry | 539/539 |
| Full-rank Jacobian | 539/539 |
| Worst scaled \(\sigma_{\min}\) | 0.508750 |
| Minimum ideal cable distance | 6.1055 mm |
| Minimum outward angular margin | +1.545778° |
| Single-anchor installation perturbations | 12/12 |

Compared with the original Config 2, the minimum ideal cable distance increased from 4.6508 mm to 6.1055 mm, approximately 31.3%.

Targeted modifications to C1 and C4 eliminated the identified Cable–sphere interference failures in the sampled development poses.

**Important Limitations:**

- The 539 poses form a finite development and repair-evaluation set.
- Passing these poses does not prove continuous workspace feasibility.
- Physical cable diameter and mounting geometry have not been included.
- Installation perturbations are assumed numerical tests.
- Experimental sensing accuracy has not been established.
- The selected Config 2 is not the globally optimal six-cable configuration.

---

## 7. Next Research Priorities

### 7.1 E1a-B — Six-Configuration Fair Comparison

**Next technical research task.**

The six Core-eligible configurations are:

\[
[2,4,6,8,12,17]
\]

Only Config 2 has received detailed rail-position optimisation.

The next step is to apply a consistent optimisation procedure to all six configurations and compare:

- Multi-pose geometric feasibility.
- Worst-case sensing quality.
- Outward angular margin.
- Minimum Cable–cable distance.
- Installation robustness.
- Simulated pose-estimation performance.

Each configuration will retain its own rail assignment, attachment positions and cable pairing during E1a-B.

A fresh independent holdout should be used for final comparison.

### 7.2 Subsequent Configuration Optimisation

After E1a-B:

| Task | Optimisation Variables |
|---|---|
| E1b | Rail assignment and associated rail position |
| E2 | Attachment positions |
| E3 | Cable pairing |
| E4 | Joint configuration variables |

The objective is to identify a defensible shortlist of configurations rather than claiming global optimality without proof.

### 7.3 Measurement and Prototype Development

Future research includes:

- Measurement uncertainty and calibration.
- Nonlinear pose-estimation validation.
- Cable length and stroke requirements.
- Mechanical mounting design.
- Pulley and cable-guide geometry.
- Low-tension feasibility.
- Experimental prototype development.
- Rigid and flexible balloon experiments.

Seven-/eight-cable theory and simulation remain a parallel workstream.

---

## 8. Repository Structure

| Directory | Responsibility |
|---|---|
| [01_Learning](01_Learning/) | Foundational learning and tutorials |
| [02_Paper_Reading](02_Paper_Reading/) | Literature review and evidence |
| [03_Simulation](03_Simulation/) | MATLAB simulations and datasets |
| [04_Code_Exercises](04_Code_Exercises/) | Mathematical and coding exercises |
| [05_My_Research](05_My_Research/) | Technical models and engineering design |
| [06_Research_Log](06_Research_Log/) | Numerical results and research records |
| [07_Resources](07_Resources/) | Supporting resources |
| [08_Project_Management](08_Project_Management/) | Research roadmap and plans |

---

## 9. Start Here

### Research Management

- [AGENTS2.md](AGENTS2.md) — Research and AI working rules.
- [CURRENT_STATE2.md](CURRENT_STATE2.md) — Current verified research progress.
- [Research Roadmap](08_Project_Management/Roadmap.md) — Long-term research milestones.
- [Active B5.3–B5.6 Research Plan](08_Project_Management/November/B5_3_to_B5_6_Revised_Research_Plan_Thesis_Informed_2026_11_10.md) — Detailed research workflow.

### Technical Research Documents

- [Sensing Objective](05_My_Research/Sensing_Objective_v0.2.md)
- [Rigid-Body Sensing Design](05_My_Research/Rigid_Body_Sensing_Design.md)
- [Prototype and Flexible Transition](05_My_Research/Prototype_V1_Rigid_to_Flexible_Design_2026_11_04.md)
- [Workspace Boundary](05_My_Research/Workspace_Boundary_v0.2_2026-10-20.md)

### Literature

- [Cable Configuration and Workspace Literature](02_Paper_Reading/Literature_Review/workspace%20definition/)

### Research Evidence

- [MATLAB Simulations](03_Simulation/MATLAB/)
- [Research Logs](06_Research_Log/2026-11/)
- [B5.1 Candidate Expansion and Pairing](06_Research_Log/2026-11/B5_1_Lesson2_Candidate_Expansion_and_Pairing_2026_11_10.md)
- [B5.2 Multi-Pose Screening](06_Research_Log/2026-11/B5_2_Multi_Pose_Geometric_Screening_2026_11_10.md)
- [B5.3 Twelve-Rail Configuration Research](06_Research_Log/2026-11/B5_3_Twelve_Rail_Structured_Configuration_Research_Log_2026_11_11.md)
- [B5.4 E1a Anchor Rail Position Optimisation](06_Research_Log/2026-11/B5_4_E1a_Anchor_Rail_Position_Optimisation_Research_Log_2026_11_12.md)

---

## 10. Research Principles

1. Research questions determine the methods.
2. Passive sensing must remain distinct from active trajectory control.
3. Geometric feasibility is a prerequisite for reliable sensing.
4. Local Jacobian quality must be distinguished from global pose-estimation performance.
5. Multi-pose evaluation is required for configuration assessment.
6. Installation robustness and physical clearance must be considered.
7. Numerical simulation is not experimental validation.
8. Different configurations should receive fair optimisation and comparison.
9. Historical research evidence must be preserved.
10. The long-term goal includes deformation sensing and cable-number comparison.

---

**Current Preferred Numerical Reference:** `E1a_Robust_Config2_v1`  
**Next Technical Priority:** B5.4 E1a-B — Six-Configuration Fair Comparison  
**Long-Term Direction:** Six-cable experimental sensing, parallel seven-/eight-cable research, and eventual deformable-balloon sensing.
