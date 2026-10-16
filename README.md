# Cable-Robot-Based Sensing for a Passive Deformable Balloon

**Master Research Project**

**Last updated:** 2026-10-16

**Current Research Phase:** Rigid-Body Sensing Objective and Measurement-System Design

**Primary Simulation Tool:** MATLAB  
**Secondary Simulation Tool:** CASPR

---

## 1. Research Overview

This research focuses on developing a cable-robot-based measurement and sensing system for a passively moving deformable balloon-like object.

The research is motivated by intragastric balloon monitoring, where changes in balloon position, volume, and morphology may be clinically relevant.

The long-term objective is to estimate balloon position, orientation, and deformation or shape using measurements obtained from cables.

The research prioritises **sensing and state estimation**, rather than controlling the balloon trajectory.

### Research Concept

```text
External Environment
        |
        v
Passive Balloon Motion / Deformation
        |
        v
Cable Length / Displacement / Tension
        |
        v
Sensor Measurements
        |
        v
Measurement Model
        |
        v
State Estimation
        |
        v
Position / Orientation / Deformation
        |
        v
Shape Reconstruction
```

The object motion is not assumed to be known by the estimator.

---

## 2. Research Questions

### Long-Term Research Question

> Can cable measurements be used to estimate the position, orientation, and shape of a passively moving deformable balloon?

### Current Research Question

> For a simplified rigid object, how many cables are required, and where should anchors and attachment points be located to achieve a specified measurement accuracy?

### Key Technical Questions

- What object state variables should be measured?
- What is the minimum suitable cable number?
- How should external anchor points be arranged?
- Where should cables attach to the measured object?
- How does cable geometry affect observability?
- How accurately can the object state be estimated?
- What sensing workspace can be achieved?
- How can the system later be extended to deformation and shape reconstruction?

---

## 3. Research Strategy

The project follows a research-question-driven development process:

```text
Research Question
       |
       v
Sensing Objective
       |
       v
Cable Geometry
       |
       v
Measurement Model
       |
       v
MATLAB Simulation
       |
       v
State Estimation
       |
       v
Experimental Validation
       |
       v
Next Research Question
```

### Development Principles

1. Start with a simplified rigid-body sensing model.
2. Validate the cable measurement principle before introducing deformation.
3. Use repeatable motion cases for initial testing.
4. Estimate states from cable measurements without assuming known trajectories.
5. Select cable number and placement according to the measurement objective.
6. Evaluate identifiability, accuracy, and sensing workspace.
7. Extend to deformable-balloon sensing after rigid-body validation.

---

## 4. Current Research Progress

### 4.1 Mathematical and Simulation Foundation

Previous work has investigated:

- Cable geometry and coordinate transformations
- Cable lengths and direction vectors
- Measurement Jacobian
- Cable-length velocity and acceleration
- Planar rigid-body dynamics
- Tension and wrench feasibility
- Geometric and tension-feasible workspace
- Measurement sensitivity
- Measurement-pattern similarity
- Forward kinematics
- Planar CASPR models

MATLAB remains the primary platform for research-specific simulations.

### 4.2 Clinical Evidence Review

Clinical evidence has been organised into four areas.

| Evidence | Topic | Main Finding |
|---|---|---|
| A | Clinical monitoring | Intermittent and often symptom-driven assessment |
| B | Balloon volume and morphology | Reported normal and abnormal volume states |
| C | Balloon position and migration | Migration cases without established normal motion trajectories |
| D | Physical dimensions | Preliminary geometric references with incomplete 3D boundaries |

### 4.3 Workspace Definition — Draft 1.0

Current clinical evidence supports preliminary references for:

- Nominal balloon volume
- Adjustable filling volume
- Hyperinflation scenarios
- Equivalent spherical diameter
- Selected CT-measured dimensions

However, the following remain unresolved:

- Normal balloon motion range
- Motion velocity
- Collapsed balloon dimensions
- Complete three-dimensional shape
- Gastric anatomical boundaries
- Final cable-robot sensing workspace

**Workspace Draft 1.0 defines initial engineering test scenarios, not final workspace boundaries.**

### 4.4 Updated Research Direction

Recent research discussions identified the need to prioritise cable sensing-system design.

The proposed first experimental platform uses a rigid object with simplified motion.

Initial investigation focuses on:

- Cable number
- Anchor-point placement
- Attachment-point placement
- Measurement Jacobian
- Local identifiability
- State estimation
- Measurement accuracy

Full balloon deformation and shape reconstruction remain long-term objectives.

---

## 5. Initial Rigid-Body Sensing Model

The current mathematical reference is a planar rigid body.

Candidate position-only state:

\[
q=[x,y]^T
\]

Candidate planar-pose state:

\[
q=[x,y,\theta]^T
\]

The ideal cable-length measurement model is:

\[
L=h(q)
\]

The sensor measurement model is:

\[
y=h(q)+\varepsilon
\]

The measurement Jacobian is:

\[
H(q)=\frac{\partial h(q)}{\partial q}
\]

For small state changes:

\[
\Delta L\approx H(q)\Delta q
\]

The current technical priority is to determine which state variables can be independently estimated under different cable configurations.

The previous planar four-cable model provides a reference, but is not assumed to be the optimal final geometry.

---

## 6. Research Roadmap

| Phase | Research Focus | Status |
|---|---|---|
| 1 | Application definition and clinical evidence | Initial synthesis completed |
| 2 | Sensing objective and rigid-body model | Current |
| 3 | Cable configuration and sensing quality | Next |
| 4 | Rigid-body measurement validation | Planned |
| 5 | Deformable-balloon extension | Future |
| 6 | Integrated sensing-system evaluation | Future |

Research stages progress according to mathematical and experimental validation, rather than completion of isolated learning lessons.

---

## 7. Repository Structure

```text
cable-robot-research/
|
|-- README.md
|-- AGENTS.md
|-- AGENTS2.md
|-- CURRENT_STATE.md
|-- CURRENT_STATE2.md
|
|-- 01_Learning/
|   `-- Robotics and mathematical fundamentals
|
|-- 02_Paper_Reading/
|   `-- Literature review and evidence
|
|-- 03_Simulation/
|   |-- MATLAB/
|   |-- CASPR/
|   `-- Simulink/
|
|-- 04_Code_Exercises/
|   |-- MATLAB/
|   |-- CASPR/
|   `-- Python/
|
|-- 05_My_Research/
|   `-- Research models, design and results
|
|-- 06_Research_Log/
|   `-- Research activities and decisions
|
|-- 07_Resources/
|   `-- Supporting references and resources
|
`-- 08_Project_Management/
    |-- Roadmap.md
    `-- TODO.md
```

### Main Research Documents

**AGENTS2.md**

Research principles, working rules, and development strategy.

**CURRENT_STATE2.md**

Current research progress, completed work, and open questions.

**08_Project_Management/Roadmap.md**

Research development phases, milestones, and expected outcomes.

**08_Project_Management/TODO.md**

Current research tasks and completion criteria.

**05_My_Research/Rigid_Body_Sensing_Design_v0.1.md**

Initial rigid-body sensing-system design and validation plan.

**06_Research_Log/**

Dated research progress, meeting feedback, decisions, and reflections.

Previous learning and project documents are retained for historical reference.

---

## 8. Immediate Next Steps

### Step 1 — Define the Initial Sensing Objective

- Compare planar position and planar-pose estimation.
- Select the initial state variables.
- Define measurement accuracy requirements.

### Step 2 — Verify the Rigid-Body Measurement Model

- Establish coordinate systems.
- Calculate cable lengths.
- Derive the measurement Jacobian.
- Verify sensitivity numerically.

### Step 3 — Investigate Cable Configuration

- Compare candidate cable numbers.
- Compare anchor placements.
- Compare attachment placements.
- Evaluate identifiability and sensing quality.

### Step 4 — Validate State Estimation

- Generate simplified static and motion test cases.
- Estimate unknown states from cable measurements.
- Compare estimates with independent ground truth.
- Evaluate accuracy and repeatability.

### Step 5 — Prepare Experimental Implementation

- Review the reference cable-robot platform.
- Define sensor requirements.
- Investigate attachment feasibility.
- Establish calibration and validation procedures.

---

## 9. Long-Term Research Direction

The intended capability progression is:

**Rigid-Body State Estimation**

↓

**Deformation Parameter Estimation**

↓

**Balloon Shape Reconstruction**

↓

**Integrated Passive Motion and Deformation Sensing**

The rigid-body phase provides the measurement foundation for the more complex deformable-balloon problem.

The final goal is not to control the balloon trajectory, but to infer its state from cable-based measurements.

---

## 10. Current Research Priority

> Establish a reliable rigid-body cable sensing model and determine how cable number, anchor placement, and attachment placement influence state-estimation accuracy.

**Next research task:** Define the initial sensing objective and verify the existing four-cable measurement Jacobian.

---
