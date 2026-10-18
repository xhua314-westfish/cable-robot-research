# Cable-Robot-Based Sensing for a Passive Deformable Balloon

**Master Research Project**  
**Last Updated:** 2026-10-19  
**Current Phase:** 3D Rigid-Body Sensing and Cable Configuration Design  
**Primary Tool:** MATLAB

---

## 1. Research Overview

<!-- UPDATED: Clarified the current 3D rigid-body research focus. -->

This project investigates cable-based sensing for a passively moving balloon-like object, motivated by intragastric balloon monitoring.

The long-term goal is to estimate object position, orientation, and eventually deformation or shape using cable measurements, without relying on a known motion trajectory.

The current research focuses on **3D 6-DOF rigid-body pose estimation**, rather than active motion control.

A motor-assisted low-tension cable tracking concept is proposed to maintain cable tension while minimising disturbance to passive object motion.

---

## 2. Simplified Research Baseline

<!-- UPDATED: Replaced the planar sensing baseline with the selected 3D model. -->

The initial study uses a simplified physical model:

| Parameter | Initial Definition |
|---|---|
| Target application | Intragastric balloon monitoring |
| Population reference | Adult female, prioritising obesity-related evidence |
| Environment | Simplified 3D gastric workspace |
| Workspace geometry | Approximate length, width and height |
| Measurement object | Rigid spherical balloon proxy |
| Balloon volume | 550 mL |
| Equivalent diameter | Approximately 101.7 mm |
| Initial sensing state | 3D position and orientation (6-DOF) |
| Primary measurement | Cable length |
| Cable configuration | 6 baseline; 7 and 8 primary candidates |
| Cable tracking | Motor-assisted low-tension tracking |
| Design variables | Cable number, anchors and attachments |
| Evaluation | Identifiability, pose accuracy, workspace coverage and physical feasibility |

**Model assumptions:**

- The gastric boundary constrains object movement; it does not reproduce detailed gastric anatomy.
- The 550 mL rigid sphere is an engineering approximation of a commercial gastric balloon.
- Gastric dimensions must be supported by literature or explicitly labelled as assumptions.
- Object motion is passive and unknown to the estimator.
- The initial model estimates full 3D rigid-body pose.
- Two-dimensional examples are retained for mathematical verification, not as a separate optimisation stage.
- The low-tension tracking architecture remains to be validated.

---

## 3. Current Research Question

<!-- UPDATED: Focused the study on 7/8-cable 6-DOF sensing. -->

> How do seven- and eight-cable configurations affect the accuracy, identifiability, and feasible sensing workspace of a passively moving 6-DOF rigid spherical object?

The study investigates three main design questions:

1. **Cable Number:** How does measurement redundancy affect 6-DOF pose estimation?
2. **Anchor and Attachment Placement:** Which three-dimensional arrangements provide reliable sensing information?
3. **Sensing Performance:** How accurately and reliably can position and orientation be estimated within the feasible workspace?

The six-cable configuration is retained as a theoretical minimum-count reference.

The seven- and eight-cable configurations are the primary research candidates.

**Main evaluation metrics:**

- Jacobian rank and conditioning.
- Position and orientation estimation errors.
- Measurement-noise sensitivity.
- Sensing workspace coverage.
- Mechanical feasibility and passive-motion disturbance.

No fixed position or orientation accuracy requirement has yet been established.

---

## 4. Current Progress

<!-- UPDATED: Separated previous learning results from current 3D research tasks. -->

### Previously Established

- Cable geometry and coordinate transformations.
- Cable-length calculations and Jacobian analysis.
- Rigid-body kinematics and dynamics.
- Preliminary planar workspace and sensing-quality simulations.
- Clinical evidence review and balloon-size references.
- Initial 3D 6-DOF sensing research scope.

### Current Priorities

- Establish a simplified 3D gastric boundary.
- Determine the geometrically feasible rigid-sphere movement region.
- Implement the 3D cable measurement model.
- Verify the 6-DOF measurement Jacobian.
- Establish initial pose estimation.
- Compare six-, seven-, and eight-cable configurations.
- Evaluate sensing accuracy and physical feasibility.

**Future Extension:** Deformable-balloon sensing and shape reconstruction.

---

## 5. Repository Guide

The repository separates supporting learning, literature, simulation, research development, and project management.

| Location | Purpose |
|---|---|
| [01_Learning](01_Learning/) | Supporting theory and learning |
| [02_Paper_Reading](02_Paper_Reading/) | Literature and clinical evidence |
| [03_Simulation](03_Simulation/) | Simulation models and tools |
| [04_Code_Exercises](04_Code_Exercises/) | MATLAB and programming exercises |
| [05_My_Research](05_My_Research/) | Research models, methods and results |
| [06_Research_Log](06_Research_Log/) | Research progress and decisions |
| [07_Resources](07_Resources/) | Supporting resources |
| [08_Project_Management](08_Project_Management/) | Planning and task management |

### Main Documents

<!-- UPDATED: Added the current sensing objective and corrected technical-document links. -->

- [CURRENT_STATE2.md](CURRENT_STATE2.md) — Current research status and open questions.
- [AGENTS2.md](AGENTS2.md) — Research and coding guidelines.
- [Sensing Objective v0.2](05_My_Research/Sensing_Objective_v0.2.md) — Current research scope and cable-number rationale.
- [Rigid-Body Sensing Design](05_My_Research/Rigid_Body_Sensing_Design.md) — 3D measurement model and technical methods.
- [Roadmap.md](08_Project_Management/Roadmap.md) — Research phases and milestones.
- [TODO.md](08_Project_Management/TODO.md) — Current actionable tasks.
- [WEEKLY_PLAN.md](08_Project_Management/WEEKLY_PLAN.md) — Weekly and daily research schedule.

---

**Current Objective:** Establish and validate 3D 6-DOF cable-based rigid-body pose sensing, compare seven- and eight-cable configurations against a six-cable baseline, and evaluate sensing performance before extending to deformable-balloon measurement.
