# Current State 2

Last updated: 2026-10-02

---

# 1. Research Direction

My research focuses on developing a:

> **Cable-robot-based measurement and sensing system for a passive deformable
> balloon-like object.**

The motivating application is a **stomach-like / gastric environment** in
which a balloon-like object may move and deform because of external
environmental effects.

The long-term goal is:

> Use cable measurements to estimate the position, orientation, and
> deformation/shape of a passively moving deformable balloon without assuming
> that its trajectory is known in advance.

The fundamental research concept is:

```text
External environment
        ↓
Passive balloon motion / deformation
        ↓
Cable displacement / length / tension changes
        ↓
Sensor measurements
        ↓
Measurement model
        ↓
State estimation
        ↓
Position / orientation / deformation
        ↓
Shape reconstruction
        ↓
Experimental validation
```

---

# 2. Major Change in Research Strategy

The previous development strategy was mainly:

```text
Learn cable robot theory
        ↓
Complete lessons
        ↓
Build technical foundation
        ↓
Eventually connect the knowledge to research
```

The new strategy is:

```text
Research problem
        ↓
Research question
        ↓
System-design question
        ↓
Identify missing knowledge
        ↓
Learn only what is required
        ↓
Build mathematical model
        ↓
Simulate
        ↓
Experiment
        ↓
Validate
        ↓
Generate next research question
```

The research problem is now the **main learning driver**.

The purpose of learning cable-robot theory is not to complete a curriculum.

The purpose is to obtain the tools required to solve the current research
question.

---

# 3. Researcher Mindset

The main question should change from:

> What lesson should I study next?

to:

> **What research question am I currently unable to answer?**

Then ask:

> What information, theory, model, simulation, paper, or experiment do I
> need to answer it?

Therefore:

```text
Research question
      ↓
Required knowledge
      ↓
Learning
      ↓
Application
      ↓
Evidence
```

This should become the default workflow for future research development.

---

# 4. Current Application Scenario

The working application concept is:

> A deformable balloon-like object exists inside a stomach-like environment
> and can move and deform passively due to external environmental effects.

The object does not follow a predefined trajectory.

The sensing system observes the consequences of this motion through cables.

Conceptually:

```text
Stomach-like environment
            ↓
Passive / irregular balloon motion
            +
Balloon deformation
            ↓
Cable attachment-point motion
            ↓
Cable length / displacement / tension change
            ↓
Sensors
            ↓
Balloon-state estimation
```

This application is currently a **research concept**, not yet a fully validated
physical system.

The exact geometry, environment, cable arrangement, attachment mechanism,
sensor architecture, and deformation model remain open research questions.

---

# 5. Core Research Question

The central working research question is:

> **Can a cable-based sensing system measure the response of cables caused by
> passive and irregular motion/deformation of a balloon-like object and use
> those measurements to estimate the object's state and reconstruct its shape?**

This question may later be divided into several smaller research questions.

---

# 6. Research Question Tree

## 6.1 Application

Need to determine:

- What is the relevant stomach-like environment?
- What physical constraints does it impose?
- What range of balloon motion is realistic?
- What types of deformation are relevant?
- What information about the balloon is actually useful?

---

## 6.2 Sensing Objective

Need to determine what should be estimated:

```text
Position?
Orientation?
Deformation?
Full shape?
```

A possible state representation is:

$$
x =
[x_{rigid},x_{deformation}]^T
$$

but the exact state representation is not yet fixed.

---

## 6.3 Measurement Principle

Need to determine what cable information should be measured:

```text
Cable length
Cable displacement
Cable tension
Combination of measurements
```

The general measurement relationship is:

$$
y=h(x)+\epsilon
$$

where:

- \(x\) = balloon state
- \(y\) = measured cable data
- \(h(\cdot)\) = measurement model
- \(\epsilon\) = measurement noise

The exact form of \(h\) remains a research task.

---

## 6.4 Cable Number

Need to determine:

> How many cables are required to estimate the state of interest?

The answer should be based on:

- number of unknowns
- independent measurement information
- observability / identifiability
- workspace
- sensitivity
- redundancy
- physical constraints

The existing four-cable planar robot is a **learning and modeling platform**,
not yet the final research-system specification.

---

## 6.5 Anchor Points

Need to determine:

> Where should the external cable anchor points be placed?

Candidate design variables include:

$$
A_i
$$

for external anchors.

The design should consider:

- physical accessibility
- workspace coverage
- cable directions
- sensitivity
- conditioning
- cable length
- mechanical feasibility

---

## 6.6 Balloon Attachment Points

Need to determine:

> Where and how should cables attach to the deformable balloon?

This is an important physical design question because the attachment
configuration directly affects:

- cable measurements
- deformation sensitivity
- observability
- mechanical interaction
- shape reconstruction

---

# 7. Current Technical Foundation

The following technical foundation has already been developed.

## Coordinate systems

- world/global coordinates
- local/body coordinates
- planar rotation
- coordinate transformation

For example:

$$
p_{world}=p_{platform}+R(\theta)p_{local}
$$

---

## Cable geometry

For a cable:

$$
L_i=\|A_i-B_i\|
$$

where:

- \(A_i\) = anchor point
- \(B_i\) = attachment point

---

## Cable direction

The unit cable direction has been implemented and interpreted physically.

---

## Jacobian

The cable Jacobian relationship has been studied:

$$
\dot L=J^T\dot q
$$

and:

$$
\ddot L
=
J^T\ddot q+\dot J^T\dot q
$$

The Jacobian is now understood not only as a kinematic quantity but also as
a potential **measurement sensitivity model**.

---

## Statics

The cable wrench / structure relationship has been studied.

The current foundation includes:

$$
A=-J^T
$$

and cable-force / wrench relationships.

Tension feasibility has also been explored using MATLAB.

---

## Dynamics

The rigid-body planar dynamic model has been developed:

$$
A T+w_{ext}=M\ddot q
$$

The current model is mainly a foundation for understanding cable-driven
motion and physical feasibility.

Dynamics is not currently the main research direction unless the final sensing
system requires dynamic modeling.

---

## Workspace

The following have been studied:

- geometric workspace
- tension-feasible workspace
- sensing-quality-related workspace analysis

The important research interpretation is:

> A configuration can be physically feasible but still provide poor sensing
> information.

---

## Sensing quality

The relationship:

$$
\Delta L\approx J^T\Delta q
$$

has been used to understand how object motion creates cable measurement
patterns.

The following concepts have been introduced:

- sensitivity
- singular values
- minimum singular value
- condition number

These should now be treated as tools for answering system-design questions,
rather than as isolated mathematical topics.

---

## Forward kinematics

Forward kinematics has been studied as:

```text
Object state
      ↓
Cable geometry
      ↓
Cable lengths
```

This provides the forward measurement model required before attempting the
inverse sensing problem.

---

# 8. Current Research Interpretation of Existing Knowledge

The existing technical foundation can now be reframed as:

```text
Cable geometry
      ↓
Measurement relationship
      ↓
Jacobian
      ↓
Sensitivity
      ↓
Workspace / configuration quality
      ↓
State estimation
```

This is the bridge from cable-robot theory to the research problem.

The important transition is:

> **From "How does a cable robot move?" to "How does object motion appear in
> cable measurements?"**

---

# 9. Current Research Phase

## Phase 1 — Application and Sensing-System Definition

This is the new current phase.

The immediate objective is **not** to continue a long sequence of generic
cable-robot lessons.

The immediate objective is to define the sensing system well enough that the
remaining technical learning becomes research-driven.

---

# 10. Current Main Task

The current task is:

> **Define the application and sensing architecture of the proposed
> cable-based balloon measurement system.**

This should answer, at least at a preliminary level:

```text
Application
    ↓
Balloon behavior
    ↓
State to estimate
    ↓
Measurement to obtain
    ↓
Cable arrangement
    ↓
Anchor points
    ↓
Attachment points
    ↓
Required workspace
    ↓
Sensing quality
    ↓
Sensor architecture
```

The design is expected to evolve as literature and simulation provide evidence.

---

# 11. Immediate Research Questions

The next work should focus on these questions.

### RQ1 — Application

What is the actual physical scenario that the system is intended to represent?

Need to investigate:

- stomach-like environment
- balloon size and geometry
- possible motion
- possible deformation
- environmental constraints

---

### RQ2 — State

What exactly should the system estimate?

Possible candidates:

$$
[x,y,\theta]^T
$$

for a simplified rigid-body state, followed later by deformation variables:

$$
[x,y,\theta,s_1,s_2,\ldots]^T
$$

The final state vector is not yet fixed.

---

### RQ3 — Measurement

Which cable quantities contain useful information?

Possible candidates:

```text
Cable length / displacement
Cable tension
Both
```

Need to compare their usefulness for the estimation problem.

---

### RQ4 — Cable Number

How many cables are required for the chosen state?

Need to consider:

- observability
- independent measurements
- redundancy
- physical constraints

---

### RQ5 — Geometry

How should anchor and attachment points be placed?

Need to evaluate:

- workspace
- cable length
- sensitivity
- singularity / conditioning
- physical feasibility

---

### RQ6 — Hardware

What physical sensing architecture can realize the measurement model?

Possible components:

```text
Encoder
Cable spool
Load cell
Displacement sensor
DAQ
Motor, if required
```

Motor selection should only occur after clarifying whether and why motorized
cable handling is necessary.

---

# 12. Research-Driven Learning Roadmap

The roadmap is no longer a fixed lesson sequence.

Instead, the following phases provide the research structure.

---

## Phase A — Application Definition

```text
Stomach-like environment
        ↓
Balloon geometry
        ↓
Expected motion
        ↓
Expected deformation
        ↓
Physical constraints
```

Output:

> A preliminary application specification.

---

## Phase B — Sensing Objective

```text
What must be estimated?
        ↓
Position
Orientation
Deformation
Shape
```

Output:

> A preliminary state definition.

---

## Phase C — Measurement Principle

```text
Balloon state
      ↓
Attachment motion
      ↓
Cable geometry
      ↓
Cable length / displacement / tension
```

Output:

> A preliminary measurement model.

---

## Phase D — Cable Configuration

Determine:

- cable number
- anchor locations
- attachment locations
- cable routing
- workspace

Output:

> A candidate sensing-system geometry.

---

## Phase E — Sensing Quality

Study:

$$
\Delta L\approx J^T\Delta q
$$

and, where appropriate:

- sensitivity
- singular values
- condition number
- rank
- observability
- identifiability

Output:

> Evidence for whether the proposed geometry can provide useful information.

---

## Phase F — Hardware

Determine:

- sensor type
- sensor resolution
- measurement range
- sampling rate
- calibration
- motor requirement
- mechanical interface

Output:

> A physically implementable sensing architecture.

---

## Phase G — State Estimation

Starting from:

$$
y=h(x)+\epsilon
$$

develop:

```text
Measurement
      ↓
State estimation
      ↓
Position / orientation
```

Only introduce advanced estimation methods when the measurement problem
requires them.

---

## Phase H — Deformable-Body Modeling

Extend:

$$
L=f(x,y,\theta)
$$

to:

$$
L=f(x,y,\theta,s)
$$

where \(s\) represents deformation.

Output:

> A tractable deformable-balloon measurement model.

---

## Phase I — Shape Reconstruction

Develop:

```text
Cable measurements
      ↓
Rigid state
      +
Deformation parameters
      ↓
Balloon shape
```

Output:

> A reconstructed balloon shape.

---

## Phase J — Experimental Validation

Validate:

- position
- orientation
- deformation
- shape
- robustness
- repeatability
- noise sensitivity

Output:

> Evidence supporting or rejecting the proposed sensing approach.

---

# 13. Role of Previous Lessons

The previous lessons are **not discarded**.

They are now treated as a toolbox.

| Existing knowledge | Research use |
|---|---|
| Cable geometry | Build measurement model |
| Coordinate transformation | Define physical configuration |
| Cable length | Convert geometry to measurements |
| Jacobian | Measurement sensitivity |
| Statics | Mechanical feasibility |
| Dynamics | Dynamic response when required |
| Workspace | Coverage of target motion |
| Tension feasibility | Physical cable configuration |
| Forward kinematics | Predict cable measurements |
| Inverse kinematics | Estimate object state |
| Condition number | Sensing quality |
| MATLAB | Independent research modeling |
| CASPR | Secondary cable-robot verification |

The goal is not to repeat these topics unless a research question requires
deeper understanding.

---

# 14. Supporting Topics

The following remain useful but are not currently the main route:

```text
Trajectory planning
Active control
Tension control
Cable interference control
Advanced CASPR control
```

They should be studied when they become necessary for:

- hardware operation
- cable safety
- maintaining attachment
- controlled experiments
- a later research question

They should not automatically determine the research roadmap.

---

# 15. Literature Strategy

Paper reading should now be organized around research questions rather than
around general cable-robot topics.

Priority literature categories:

### Application

- gastric / stomach-like robotic environments
- deformable balloon systems
- minimally invasive sensing

### Cable sensing

- cable-driven sensing
- cable displacement measurement
- cable tension sensing
- cable-based pose estimation

### Geometry and observability

- cable configuration optimization
- measurement sensitivity
- observability
- identifiability

### Deformable objects

- deformable-body sensing
- reduced-order deformation models
- shape reconstruction
- cable-based deformation measurement

For each important paper, record:

```text
Problem
Application
System
Measurement
Model
Estimation
Experiment
Result
Limitation
Relevance to my research
```

The final item is essential.

---

# 16. Assumptions vs Verified Knowledge

Current assumptions include:

- the balloon motion is passive
- the motion may be irregular
- the balloon is deformable
- cable measurements can contain information about balloon state
- a cable-based sensing architecture may be feasible

These are **research assumptions / hypotheses**, not final validated results.

Verified technical foundation includes:

- rigid planar cable geometry
- cable length calculation
- Jacobian formulation
- cable wrench / statics relationships
- rigid-body dynamics foundation
- workspace analysis
- sensing-quality analysis
- forward kinematics in the current simplified model
- MATLAB implementation and verification of the developed models

---

# 17. Current Research Boundaries

The following are **not yet fixed**:

```text
Final application geometry
Final balloon geometry
Final number of cables
Final anchor points
Final attachment points
Final sensor type
Final motor architecture
Final measurement vector
Final deformation model
Final estimator
Final experimental setup
```

These should be decided from:

```text
Literature
+
Physical constraints
+
Mathematical analysis
+
Simulation
+
Experiments
```

rather than assumed in advance.

---

# 18. Immediate Next Steps

The immediate sequence should be:

### Step 1

Define the application scenario.

### Step 2

Define what information about the balloon must be estimated.

### Step 3

Define candidate cable measurements.

### Step 4

Draw candidate sensing architectures.

### Step 5

Determine candidate cable numbers.

### Step 6

Define candidate anchor and attachment configurations.

### Step 7

Use the existing cable-robot toolbox to analyze:

- workspace
- sensitivity
- conditioning
- observability

### Step 8

Select candidate sensor architectures.

### Step 9

Build the measurement model.

### Step 10

Only then introduce the next required mathematical learning topics.

---

# 19. Current Guiding Principle

The most important rule for the next stage is:

> **Do not ask "What should I learn next?" Ask "What is preventing me from
> answering my current research question?"**

Then:

```text
Research question
      ↓
Knowledge gap
      ↓
Learning
      ↓
Model
      ↓
Simulation / experiment
      ↓
Evidence
      ↓
Research decision
```

---

# 20. Long-Term Research Loop

The intended Master research loop is:

```text
Application
      ↓
Research problem
      ↓
Research question
      ↓
System concept
      ↓
Measurement principle
      ↓
Cable configuration
      ↓
Mathematical model
      ↓
Required theory
      ↓
Simulation
      ↓
Hardware
      ↓
Experiment
      ↓
Validation
      ↓
Research contribution
      ↓
New research question
```

The goal is not to complete a fixed list of lessons.

The goal is to develop and validate a defensible cable-based sensing system.

---

# 21. Current One-Sentence Research Direction

> **Design and validate a cable-based sensing system that can infer the state
> and deformation/shape of a passively moving balloon-like object from cable
> measurements in a stomach-like environment.**

---

# 22. Current Next Research Question

The next concrete question is:

> **What exactly is the application scenario, what must be estimated from the
> balloon, and what cable measurements could provide that information?**

This question should be answered before continuing with a generic sequence of
cable-robot lessons.
