# AGENTS2.md

## 1. Project Purpose

This repository is a long-term **research-driven workspace** for developing a
cable-robot-based measurement and sensing system for a passive deformable
balloon-like object.

The repository supports:

- Defining and refining the research problem
- Understanding the application scenario
- Designing the sensing-system architecture
- Reading and analyzing relevant research papers
- Learning cable-robot theory when it is required by a research question
- Developing mathematical models
- Developing MATLAB simulations
- Using CASPR when it is useful for verification
- Designing sensors and experimental hardware
- Developing state and shape estimation methods
- Recording experiments and validation results

The main principle is:

> **Research questions drive learning. Learning does not exist as an independent goal.**

---

## 2. Research-First Philosophy

The primary objective is not to complete a sequence of cable-robot lessons.

The primary objective is to answer the research problem:

> How can a cable-based sensing system estimate the state and shape of a
> passively moving and deforming balloon-like object?

Therefore, the research workflow should follow:

```text
Research Problem
      ↓
Application Scenario
      ↓
What must be known?
      ↓
What can be measured?
      ↓
System Architecture
      ↓
Technical Problem
      ↓
Required Theory / Learning
      ↓
Mathematical Model
      ↓
Simulation
      ↓
Experiment
      ↓
Validation
      ↓
Research Conclusion
      ↓
New Research Question
```

A learning topic should normally have a clear answer to:

> **Why do I need to learn this for my research?**

If a topic does not currently contribute to the research problem, it should
not automatically become the next lesson.

---

## 3. Current Research Direction

The research focuses on developing a:

> **Cable-robot-based measurement and sensing system for a passive deformable
> balloon-like object.**

The motivating application is a stomach-like or gastric environment in which
a balloon-like deformable object can move and deform because of external
environmental effects.

The intended system is primarily a **measurement and sensing system**, not a
trajectory-control system.

The balloon motion is therefore treated as:

- passive
- unknown in advance
- potentially irregular
- coupled with deformation

The fundamental research concept is:

```text
External environment
        ↓
Passive balloon motion / deformation
        ↓
Cable displacement / length / tension changes
        ↓
Sensors
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

## 4. Research Questions Drive the Development

The research should be developed by answering questions in roughly this order.

### Application

1. What is the actual application scenario?
2. What are the physical constraints of the stomach-like environment?
3. What can the balloon move and deform like?
4. What information about the balloon is actually needed?

### Sensing Objective

5. What state should be estimated?
6. Is position required?
7. Is orientation required?
8. Is deformation required?
9. Is full shape reconstruction required?

### Measurement Principle

10. What can a cable physically measure?
11. Should the system measure cable length/displacement?
12. Should it measure cable tension?
13. Are multiple measurement types required?
14. How does balloon motion affect the measurements?

### System Geometry

15. How should cables interact with the balloon?
16. How many cables are required?
17. Where should external anchor points be placed?
18. Where should balloon attachment points be placed?
19. What workspace must be covered?
20. Which configurations provide useful measurement sensitivity?

### Estimation

21. Is the available measurement information sufficient to identify the
    balloon state?
22. What is the measurement model?
23. How does measurement noise affect estimation?
24. What estimation method is appropriate?
25. Can rigid-body motion and deformation be distinguished?

### Hardware

26. What sensors are required?
27. Is a motor required, and if so, why?
28. What encoder / displacement / tension sensor is appropriate?
29. What resolution and measurement range are required?
30. How should the system be calibrated?

### Deformation and Shape

31. How should balloon deformation be represented?
32. How many deformation parameters are required?
33. Can cable measurements identify those parameters?
34. How can the balloon shape be reconstructed?

### Validation

35. What is the ground truth?
36. How accurate is the estimated state?
37. How robust is the system to noise and irregular motion?
38. Which configurations improve or degrade sensing performance?

These questions are not necessarily fixed. Results from experiments and
literature may create new questions or change the order.

---

## 5. Research Development Architecture

The preferred development architecture is:

```text
PHASE 1 — APPLICATION DEFINITION
        ↓
PHASE 2 — SENSING OBJECTIVE
        ↓
PHASE 3 — MEASUREMENT PRINCIPLE
        ↓
PHASE 4 — SYSTEM GEOMETRY
        ↓
PHASE 5 — SENSING QUALITY
        ↓
PHASE 6 — HARDWARE / SENSOR DESIGN
        ↓
PHASE 7 — MEASUREMENT MODEL
        ↓
PHASE 8 — STATE ESTIMATION
        ↓
PHASE 9 — DEFORMABLE-BODY MODEL
        ↓
PHASE 10 — SHAPE RECONSTRUCTION
        ↓
PHASE 11 — EXPERIMENTAL VALIDATION
```

Traditional cable-robot theory is inserted into these phases only when needed.

---

## 6. Role of Cable-Robot Theory

Cable-robot theory is a **toolbox**, not the research objective.

Existing knowledge such as:

- coordinate transformations
- cable geometry
- cable length
- cable direction
- Jacobian
- statics
- cable wrench
- dynamics
- workspace
- forward kinematics
- inverse kinematics

should be used to answer research questions.

For example:

### Research question

> How sensitive are cable measurements to balloon motion?

Required knowledge:

```text
Cable geometry
      ↓
Cable length
      ↓
Jacobian
      ↓
Sensitivity
```

### Research question

> Where should the anchors be placed?

Required knowledge:

```text
Cable geometry
      ↓
Workspace
      ↓
Jacobian
      ↓
Conditioning / sensitivity
      ↓
Configuration comparison
```

### Research question

> Can cable measurements uniquely determine the balloon state?

Required knowledge:

```text
Measurement model
      ↓
Jacobian
      ↓
Rank
      ↓
Observability / identifiability
```

### Research question

> Is the estimated state accurate?

Required knowledge:

```text
Sensor resolution
      ↓
Measurement noise
      ↓
Sensitivity
      ↓
Uncertainty
      ↓
State estimation
```

---

## 7. Learning Method

When a research problem requires new knowledge, use:

```text
Research question
      ↓
Why is existing knowledge insufficient?
      ↓
Required concept
      ↓
Physical meaning
      ↓
Mathematical model
      ↓
Simple numerical example
      ↓
MATLAB implementation
      ↓
Research-specific simulation
      ↓
Interpretation
```

Do not learn advanced theory simply because it appears in a standard
cable-robot textbook.

The preferred learning question is:

> **What is the minimum theory I need to solve the current research problem
> correctly?**

If deeper theory becomes necessary, then learn it progressively.

---

## 8. Modeling Rules

Every mathematical model should clearly identify:

- physical meaning
- assumptions
- coordinate system
- inputs
- outputs
- unknowns
- measurable quantities
- dimensions of vectors and matrices
- limitations

For example, a measurement model may take the form:

$$
y = h(x) + \epsilon
$$

where:

- \(x\) = unknown balloon state
- \(y\) = measured cable data
- \(h(\cdot)\) = measurement model
- \(\epsilon\) = measurement noise

The research objective is then related to:

$$
y \rightarrow \hat{x}
$$

and, for a deformable object:

$$
y \rightarrow
(\hat{x}_{rigid},\hat{x}_{deformation})
\rightarrow
\hat{shape}
$$

Do not assume that a model is correct simply because it is mathematically
consistent. Its physical assumptions must also be justified.

---

## 9. Geometry and Coordinate Rules

Always distinguish clearly between:

- world/global coordinates
- local/body coordinates

For a planar rigid body:

$$
p_{world}=p_{platform}+R(\theta)p_{local}
$$

For cable length:

$$
L_i=\|A_i-B_i\|
$$

where:

- \(A_i\) = fixed anchor point
- \(B_i\) = moving attachment point

Every vector should have an explicitly understood coordinate frame.

Never silently mix local and world coordinates.

---

## 10. Measurement-System Rules

The research should distinguish clearly between:

### Physical quantity

Examples:

- cable length
- cable displacement
- cable tension

### Sensor output

Examples:

- encoder counts
- motor angle
- load-cell voltage
- calibrated length

### Estimated quantity

Examples:

- balloon position
- orientation
- deformation parameters
- reconstructed shape

The chain should be explicit:

```text
Physical balloon motion
        ↓
Cable response
        ↓
Physical cable quantity
        ↓
Sensor output
        ↓
Calibration
        ↓
Measurement vector
        ↓
Estimation
```

Do not skip the sensor and calibration layers when designing the real system.

---

## 11. Cable Number and Configuration Rules

The number of cables should not be chosen only because a four-cable planar
example is convenient.

Cable number and geometry should be justified by:

- number of unknown state variables
- independent measurement information
- required workspace
- sensing sensitivity
- observability / identifiability
- physical attachment constraints
- mechanical feasibility
- redundancy requirements

The question is:

> **How many independent measurements are required to estimate the state of
> interest reliably?**

Similarly, anchor and attachment points should be treated as system-design
variables rather than fixed textbook parameters.

---

## 12. Workspace Rules

Workspace should be interpreted from the research perspective.

Do not only ask:

> Where can the cable robot move?

Also ask:

> Where can the sensing system obtain useful information about the object?

Therefore distinguish:

### Geometric feasibility

Can the cable configuration physically exist?

### Tension / mechanical feasibility

Can the cable forces satisfy physical constraints?

### Sensing feasibility

Does the configuration provide sufficient measurement sensitivity and
identifiability?

A region can therefore be geometrically feasible but poor for sensing.

---

## 13. Sensing Quality Rules

Useful quantities may include:

- Jacobian rank
- singular values
- minimum singular value
- condition number
- sensitivity
- measurement redundancy
- uncertainty propagation

These quantities should always be interpreted physically.

For example:

$$
\Delta L \approx J^T\Delta q
$$

describes how object motion produces cable measurement changes.

A small response in a particular direction may indicate poor sensitivity to
that motion.

Do not treat a numerical metric as meaningful without explaining what physical
sensing behavior it represents.

---

## 14. Simulation Rules

Simulation should follow:

```text
Research question
      ↓
Hypothesis / assumption
      ↓
Mathematical model
      ↓
Simulation
      ↓
Result
      ↓
Physical interpretation
      ↓
Research conclusion
```

MATLAB is the primary independent modeling and simulation environment.

CASPR is secondary and should be used when it provides useful verification
or cable-robot-specific functionality.

Simulation results must never be invented.

Clearly distinguish:

- verified result
- assumption
- prediction
- hypothesis
- unresolved question

---

## 15. Hardware Design Rules

Hardware decisions should be driven by the measurement model.

Do not select a motor, encoder, or tension sensor simply because it is common
in cable robots.

First determine:

1. What physical quantity must be measured?
2. What range is expected?
3. What resolution is required?
4. What sampling rate is required?
5. What accuracy is required?
6. What mechanical constraints exist?
7. Is a motor necessary?
8. What role does the motor play in the sensing architecture?

Only then compare hardware options.

---

## 16. Paper Reading Rules

Papers should be read as evidence for research decisions.

For important papers, record:

- Research problem
- Application
- System architecture
- Cable configuration
- Measurement method
- Mathematical model
- Sensors
- Estimation method
- Experimental setup
- Results
- Limitations
- Relevance to the current research

The key question is:

> **What decision or research question can this paper help me answer?**

Avoid collecting papers without connecting them to the current research.

---

## 17. Experiment Rules

Every important experiment should record:

- Research question
- Objective
- Hypothesis
- Setup
- Variables
- Parameters
- Expected result
- Actual result
- Error
- Interpretation
- Limitations
- Next research question

Failed experiments should be preserved.

A failed experiment can still answer an important research question.

---

## 18. Coding Rules

MATLAB is the primary programming language during the early research stages.

Code should prioritize:

- clear variable names
- physical meaning
- correct matrix dimensions
- readable structure
- reusable functions
- vectorized operations where appropriate
- explicit assumptions

For example:

```matlab
CableLength = vecnorm(CableVector, 2, 2);
```

is preferred when it makes the physical meaning clearer.

Before performing matrix operations, explicitly check dimensions.

---

## 19. AI / Codex Working Rules

When working with this repository:

1. Read `CURRENT_STATE2.md` before starting a research task.
2. Identify the current research question before proposing a learning task.
3. Do not automatically continue the next textbook-style lesson.
4. Explain why a concept is needed for the current research question.
5. Preserve useful existing work.
6. Reuse completed theory instead of relearning it unnecessarily.
7. Check vector and matrix dimensions carefully.
8. Separate assumptions from verified facts.
9. Do not invent simulation or experimental results.
10. Explain code modifications and their research purpose.
11. Prefer small research-specific models before large implementations.
12. Connect literature to concrete design or modeling decisions.
13. Record important research decisions.
14. Identify unresolved questions explicitly.
15. When the current research question changes, update the roadmap accordingly.

---

## 20. Current-State File Rule

`CURRENT_STATE2.md` is the main source of truth for the **research-driven
workflow**.

It should contain:

- research direction
- current application concept
- current research questions
- current system-design questions
- completed technical foundation
- current phase
- current task
- required learning
- assumptions
- verified results
- unresolved questions
- next research questions

The file should describe what the researcher is currently trying to solve,
not only which lessons have been completed.

---

## 21. Repository Structure

The existing repository structure can remain, but its purpose should be
interpreted through the research-first workflow.

```text
01_Learning/
02_Paper_Reading/
03_Simulation/
04_Code_Exercises/
05_My_Research/
06_Research_Log/
07_Resources/
08_Project_Management/
```

The priority is:

```text
05_My_Research
      ↓
02_Paper_Reading
03_Simulation
04_Code_Exercises
01_Learning
06_Research_Log
```

This does not mean learning is unimportant.

It means research questions determine what should be learned, simulated, and
implemented.

---

## 22. Long-Term Research Loop

The intended long-term workflow is:

```text
Application
    ↓
Research Problem
    ↓
Research Question
    ↓
System Concept
    ↓
Measurement Principle
    ↓
System Geometry
    ↓
Mathematical Model
    ↓
Required Theory
    ↓
Simulation
    ↓
Hardware
    ↓
Experiment
    ↓
Validation
    ↓
Research Contribution
    ↓
New Research Question
```

The goal is not to finish a fixed list of lessons.

The goal is to develop and validate a defensible sensing system that answers
the research question.
