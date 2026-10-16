# Cable-Robot-Based Sensing for a Passive Deformable Balloon

**Master Research Project**  
**Last Updated:** 2026-10-16  
**Current Phase:** Rigid-Body Sensing and Cable Configuration Design  
**Primary Tool:** MATLAB

---

## 1. Research Overview

This project investigates cable-based sensing for a passively moving balloon-like object, motivated by intragastric balloon monitoring.

The long-term goal is to estimate object position and eventually deformation or shape using cable measurements, without relying on a known motion trajectory.

The current research focuses on **measurement and state estimation**, rather than motion control.

## 2. Simplified Research Baseline

The initial study uses a simplified physical model:

| Parameter | Initial Definition |
|---|---|
| Target application | Intragastric balloon monitoring |
| Population reference | Adult female |
| Environment | Simplified gastric workspace |
| Workspace geometry | Approximate length, width and height |
| Measurement object | Rigid spherical balloon proxy |
| Balloon volume | 550 mL |
| Equivalent diameter | Approximately 10.17 cm |
| Primary measurement | Object position |
| Design variables | Cable number, anchors and attachments |
| Evaluation | Identifiability, accuracy and workspace coverage |

**Model assumptions:**

- The gastric outline constrains object movement; it does not reproduce detailed gastric anatomy.
- The 550 mL rigid sphere is an engineering approximation of a commercial gastric balloon.
- Gastric dimensions must be supported by literature or explicitly labelled as assumptions.
- Initial planar tests may constrain orientation; later work may extend to three-dimensional motion.

## 3. Current Research Question

> How do cable number and placement affect the accuracy and reliability of position estimation for a 550 mL rigid spherical object moving within a simplified gastric workspace?

The study investigates three main design variables:

1. **Cable Number:** How many independent cable measurements are needed?
2. **Anchor and Attachment Placement:** Which arrangements provide useful measurement information?
3. **Measurement Performance:** How accurately and reliably can object position be estimated?

The main evaluation metrics are Jacobian rank, sensing quality, position-estimation error and workspace coverage.

## 4. Current Progress

**Previously established:**

- Cable geometry and coordinate transformations
- Cable-length calculations and Jacobian analysis
- Rigid-body kinematics and dynamics
- Preliminary workspace and sensing-quality simulations
- Clinical evidence review and balloon-size references

**Current priorities:**

- Define the initial measurement state and orientation constraints
- Establish the simplified gastric workspace
- Verify the rigid-body measurement model
- Compare cable configurations
- Evaluate state-estimation accuracy

**Future extension:** Deformable-balloon sensing and shape reconstruction.

## 5. Repository Guide

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

- [CURRENT_STATE2.md](CURRENT_STATE2.md) — Current research status and open questions
- [AGENTS2.md](AGENTS2.md) — Research and coding guidelines
- [Roadmap.md](08_Project_Management/Roadmap.md) — Research phases and milestones
- [TODO.md](08_Project_Management/TODO.md) — Current actionable tasks
- [WEEKLY_PLAN.md](08_Project_Management/WEEKLY_PLAN.md) — Weekly and daily schedule
- [Rigid-Body Sensing Design](05_My_Research/Rigid_Body_Sensing_Design_v0.1.md) — Measurement model and technical design

---

**Current Objective:** Establish and validate a cable-based rigid-body position measurement system before extending to deformable-balloon sensing.
