# Current State

Last updated: 2026-09-22

---

# 1. Research Direction

My research focuses on developing a **cable-robot-based measurement and sensing system for a passive deformable balloon-like object**.

The long-term research goal is:

> Use cable measurements to estimate the position, orientation, and shape of a deformable balloon while the balloon undergoes passive and irregular motion, without directly controlling its motion.

The research is motivated by the concept of a **gastric balloon / stomach-like deformable object**, where the balloon may move and deform due to external environmental effects rather than following a predefined trajectory.

The key research question is:

> Can the motion, displacement, and/or tension of cables be measured and used to reconstruct the position and shape of a passively moving deformable balloon?

The conceptual research pipeline is:

```text
Passive balloon motion / deformation
            ↓
Cable displacement / length / tension changes
            ↓
Cable measurements
            ↓
Mathematical measurement model
            ↓
State estimation
            ↓
Position / orientation estimation
            ↓
Shape reconstruction
            ↓
Experimental validation
```

---

# 2. Important Research Assumption: Passive Balloon Motion

The balloon motion is assumed to be **passive** rather than actively controlled.

The balloon may move and deform irregularly because of external effects.

For example:

```text
External environment
        ↓
Balloon motion / deformation
        ↓
Cable motion
        ↓
Cable measurements
```

The balloon trajectory is therefore **not assumed to be known in advance**.

The system should not rely on:

```text
Known trajectory
       ↓
Control balloon
       ↓
Measure cable response
```

Instead, the intended research problem is:

```text
Unknown / irregular balloon motion
            ↓
Cable measurements
            ↓
Estimate balloon state
            ↓
Reconstruct balloon shape
```

This distinction is important.

The system is primarily a **measurement and sensing system**, not a trajectory-control system.

---

# 3. Research Development Path

The research should gradually develop through the following stages:

1. Cable robot fundamentals
2. Coordinate systems and cable geometry
3. Cable length and direction
4. Jacobian and cable velocity
5. Cable wrench and statics
6. Cable robot dynamics
7. Workspace and configuration feasibility
8. Forward kinematics
9. Inverse kinematics
10. Cable-based sensing
11. Measurement noise and uncertainty
12. Observability / identifiability
13. State estimation
14. Flexible / deformable-body modelling
15. Deformation parameter estimation
16. Shape reconstruction
17. Experimental sensing system
18. Experimental validation

Traditional cable-robot topics such as:

* trajectory planning
* active control
* tension control
* cable interference control

remain useful, but they are **supporting topics rather than the main research path** unless the future experimental system requires them.

---

# 4. Learning Philosophy

Learning should combine:

```text
Theory
    ↓
Mathematical derivation
    ↓
Simple numerical example
    ↓
MATLAB implementation
    ↓
CASPR simulation when useful
    ↓
Research application
```

Do not introduce advanced concepts without explaining their physical meaning and connecting them to a simple example.

The goal is not only to understand how to use a formula, but also:

* why the formula is needed
* what physical problem it represents
* how it connects to cable sensing
* how it will eventually apply to the deformable balloon

The learning process should remain beginner-friendly and step-by-step.

---

# 5. Current Technical Foundation

The current learning foundation includes:

* World coordinate system
* Local coordinate system
* Coordinate transformation
* Cable anchor points
* Cable attachment points
* Cable vector
* Cable length
* Cable direction
* Unit direction vector
* Moment arm
* Cable force
* Cable moment
* Cable wrench
* Jacobian
* Structure matrix
* Static equilibrium
* Cable tension constraints
* Tension distribution
* Tension optimisation
* Newton–Euler dynamics
* Mass and rotational inertia
* Platform acceleration
* Cable velocity
* Cable acceleration
* Time-varying Jacobian
* Numerical verification

The current simulation platform is CASPR.

The primary independent modelling and learning platform is MATLAB.

---

# 6. Coordinate System Rules

Always distinguish clearly between:

* World / global coordinates
* Local / body coordinates

For coordinate transformations, explicitly identify the coordinate system of every vector.

For a planar rigid body:

$$
p_{world}=p_{platform}+R(\theta)p_{local}
$$

For a cable attachment point:

$$
B_i=P+R(\theta)r_i
$$

where:

* \(P\) is the platform centre in world coordinates
* \(r_i\) is the cable attachment point in local coordinates
* \(B_i\) is the attachment point in world coordinates

Do not mix local and world coordinates without an explicit transformation.

---

# 7. Coding Rules

MATLAB is the primary programming language during the early stages.

Code should prioritise:

* clear variable names
* physical meaning of variables
* correct matrix dimensions
* readable implementation
* reusable functions
* vectorised operations where appropriate

Prefer MATLAB built-in functions when they make the physical meaning clearer.

For example:

```matlab
CableLength = vecnorm(LengthVector, 2, 2);
```

is preferred over manually calculating the Euclidean norm when appropriate.

Matrix dimensions must always be checked explicitly when introducing a new equation or model.

---

# 8. Simulation Rules

CASPR should be used to connect theory with physical behaviour.

Simulation tasks should follow:

```text
Physical problem
        ↓
Mathematical model
        ↓
CASPR / MATLAB implementation
        ↓
Simulation
        ↓
Observation
        ↓
Interpretation
```

Simulation results must not be invented.

If a result has not been verified, explicitly state whether it is:

* verified result
* numerical prediction
* assumption
* hypothesis

For the current research direction, simulations should eventually include **passive and irregular balloon motion**, rather than relying only on predefined trajectories.

---

# 9. Paper Reading Rules

For important papers, record:

* Research problem
* Motivation
* System architecture
* Mathematical model
* Measurement model
* Estimation method
* Experimental setup
* Results
* Advantages
* Limitations
* Relevance to the current research

The goal is not only to summarise papers.

Always ask:

> What can this paper contribute to the current cable-based passive sensing problem?

Important future paper categories include:

* cable-driven sensing
* cable-based position estimation
* cable length sensing
* tendon / cable tension sensing
* flexible-body sensing
* deformable-body modelling
* shape sensing
* state estimation
* nonlinear estimation
* observability
* soft robotics
* gastric balloon / stomach-like systems

---

# 10. Experiment Rules

Every important experiment should record:

* Objective
* Setup
* Parameters
* Expected result
* Actual result
* Difference
* Possible explanation
* Next experiment

Failed experiments should be preserved because they are part of the research history.

For the final sensing experiments, the important comparison will be:

```text
Ground-truth balloon state
        vs
Estimated balloon state
```

including:

* position
* orientation
* deformation
* reconstructed shape

---

# 11. AI / Codex Working Rules

When working with this repository:

1. Read `current-state.md` before starting a research task.
2. Understand the user's current learning stage.
3. Do not skip prerequisite concepts.
4. Explain theory before introducing advanced code.
5. Connect equations to physical meaning.
6. Prefer small working examples before large implementations.
7. Check vector and matrix dimensions carefully.
8. Explain why a method is used, not only how it is implemented.
9. Clearly distinguish verified results from assumptions or hypotheses.
10. Preserve useful existing work unless there is a clear reason to replace it.
11. When modifying code, explain what was changed and why.
12. Record important research decisions.
13. Do not invent experimental or simulation results.
14. If information is uncertain, explicitly identify the uncertainty.
15. Do not assume that the balloon follows a known trajectory.
16. Keep passive balloon motion as the default research assumption unless explicitly changed.
17. Prioritise sensing and estimation over active trajectory control.
18. Do not introduce flexible-body modelling before the rigid-body sensing foundation is understood.

---

# 12. Current Research Model

The current model is still a **planar rigid-body cable robot**.

For the current rigid platform:

$$
q=
[x,y,\theta]^T
$$

where:

* \(x,y\): platform position
* \(\theta\): platform orientation

The current model assumes:

* rigid platform
* fixed mass
* fixed rotational inertia
* fixed attachment geometry
* three planar degrees of freedom
* four cables

The deformable balloon model has not yet been introduced.

The purpose of the current rigid-body model is to establish a reliable foundation for the later sensing problem.

---

# 13. Current Kinematic Model

The current forward kinematic relationship is:

```text
q
 ↓
Platform position / orientation
 ↓
World-frame attachment points B
 ↓
Cable vectors D
 ↓
Cable lengths L
 ↓
Cable unit directions u
 ↓
Jacobian J
 ↓
Cable velocity L_dot
 ↓
Cable acceleration L_ddot
```

For each cable:

$$
B_i=P+R(\theta)r_i
$$

$$
d_i=A_i-B_i
$$

$$
L_i=\|d_i\|
$$

$$
u_i=\frac{d_i}{L_i}
$$

The cable Jacobian describes the relationship between platform velocity and cable velocity:

$$
\dot L=J^T\dot q
$$

where:

$$
J\in\mathbb{R}^{3\times4}
$$

and therefore:

$$
J^T\in\mathbb{R}^{4\times3}
$$

---

# 14. Current Static Model

For the current sign convention:

$$
A=-J^T
$$

where \(A\) is the structure matrix.

For cable tension vector:

$$
T=
[T_1,T_2,T_3,T_4]^T
$$

the total cable wrench is:

$$
w_c=AT
$$

Static equilibrium is:

$$
AT+w_{ext}=0
$$

Therefore:

$$
AT=-w_{ext}
$$

Cable tensions must satisfy:

$$
T_i\geq0
$$

and practical limits can be represented by:

$$
T_{min}\leq T_i\leq T_{max}
$$

Multiple tension distributions may satisfy the same equilibrium equations.

MATLAB `linprog` has been used to solve the constrained tension distribution problem.

---

# 15. Current Dynamic Model

For the planar rigid body:

$$
q=[x,y,\theta]^T
$$

$$
\dot q=[\dot x,\dot y,\dot\theta]^T
$$

$$
\ddot q=[\ddot x,\ddot y,\ddot\theta]^T
$$

Mass matrix:

$$
M=
\begin{bmatrix}
m&0&0\\
0&m&0\\
0&0&I_z
\end{bmatrix}
$$

The complete dynamic equation is:

$$
AT+w_{ext}=M\ddot q
$$

The current dynamic chain is:

```text
Cable tension
      ↓
Cable force
      ↓
Cable moment
      ↓
Cable wrench
      ↓
AT
      ↓
Net wrench
      ↓
Platform acceleration
      ↓
Platform velocity
      ↓
Platform position / orientation
      ↓
Changing cable geometry
      ↓
Cable length
      ↓
Cable velocity / acceleration
```

---

# 16. Cable Velocity and Acceleration

The cable velocity is:

$$
\dot L=J^T\dot q
$$

The cable acceleration is:

$$
\ddot L = J^T\ddot q+\dot J^T\dot q
$$

where:

* \(J^T\ddot q\) represents cable acceleration directly caused by platform acceleration
* \(\dot J^T\dot q\) represents additional cable acceleration caused by changing cable geometry

The time-varying Jacobian has been implemented numerically:

$$
\dot J
\approx
\frac{J_k-J_{k-1}}{\Delta t}
$$

Current dimensions:

```text
J       : 3 × 4
J_dot   : 3 × 4
J^T     : 4 × 3
q_dot   : 3 × 1
q_ddot  : 3 × 1
L       : 4 × 1
L_dot   : 4 × 1
L_ddot  : 4 × 1
```

These dimensions are currently understood and should remain consistent.

---

# 17. Current MATLAB Dynamic Simulation

A complete MATLAB simulation has been implemented for a four-cable, three-DOF planar rigid-body platform.

The simulation includes:

* platform mass
* rotational inertia
* mass matrix
* cable wrench
* external wrench
* net wrench
* platform acceleration
* velocity integration
* position integration
* rotation
* rotating attachment points
* cable vectors
* cable lengths
* cable unit directions
* Jacobian
* time-varying Jacobian
* cable velocity
* cable acceleration
* numerical cable velocity verification
* numerical cable acceleration verification
* platform plots
* cable length plots
* cable velocity plots
* analytical vs numerical comparison

Current geometry:

```text
Fixed anchor A:

A = [-2  2  2 -2
      3  3 -1 -1]

Local platform attachment points:

r = [-0.5  0.5  0.5 -0.5
      0.5  0.5 -0.5 -0.5]
```

World-frame attachment points:

$$
B=P+R(\theta)r
$$

Current forward model:

```text
q
 ↓
P, theta
 ↓
B
 ↓
D
 ↓
L
 ↓
u
 ↓
J
 ↓
L_dot
 ↓
L_ddot
```

The current model is a **forward dynamic / kinematic model**.

Cable tensions are currently represented through a specified cable wrench rather than a complete closed-loop tension-control law.

---

# 18. CASPR Model

CASPR has been used to understand:

* project structure
* XML configuration
* bodies
* cables
* operational spaces
* trajectories
* planar XY model
* coordinate systems
* cable geometry
* platform motion
* mass
* rotational inertia
* Jacobian
* trajectory configuration

Current CASPR model:

* planar XY cable robot
* four cables
* platform DOF \(q=[x,y,\theta]\)
* platform attachment points defined in local coordinates
* cable anchor points defined in world coordinates
* platform mass and inertia defined in `bodies.xml`
* cable geometry defined in `cables.xml`
* trajectories defined in `trajectories.xml`

---

# 19. CASPR Dynamics Verification Status

Status:

**Closed for the current learning phase.**

The original objective was to obtain an exact tension-driven dynamic equivalence between the independent MATLAB model and the available CASPR model.

The available CASPR files do not provide the same direct cable-tension input used in the MATLAB dynamic model.

The two models therefore have different input/output logic:

```text
MATLAB:

T
↓
Cable wrench
↓
Net wrench
↓
q_ddot
↓
q_dot
↓
q
```

while the available CASPR trajectory configuration primarily provides:

```text
q(t)
↓
q_dot(t)
↓
q_ddot(t)
```

The CASPR model was nevertheless used to verify:

* basic model structure
* geometry
* coordinate interpretation
* initial conditions
* platform mass
* rotational inertia
* attachment geometry
* Jacobian geometry
* trajectory representation

Exact tension-driven dynamic equivalence is **not required at this stage**.

Future CASPR work should only be performed when it directly supports a research question.

CASPR is therefore considered a:

> **secondary simulation and verification platform**

rather than the primary learning platform.

---

# 20. Current Knowledge Gaps

## Completed Foundations

The following topics have been studied at the current beginner learning level:

### Kinematics

* cable geometry
* cable length
* cable direction
* platform rotation
* local-to-world transformation
* cable velocity
* Jacobian
* analytical Jacobian
* numerical Jacobian
* Jacobian verification

### Statics

* cable tension
* cable force
* cable moment
* cable wrench
* structure matrix
* static equilibrium
* tension constraints
* tension distribution
* wrench feasibility
* basic wrench cone concept
* tension optimisation
* MATLAB `linprog`

### Dynamics

* Newton's second law
* rotational Newton–Euler equation
* mass
* rotational inertia
* mass matrix
* net wrench
* cable forces and moments
* three-DOF rigid-body dynamics
* platform acceleration
* numerical integration
* rotating attachment geometry
* time-varying Jacobian
* \(J_dot\)
* cable velocity
* cable acceleration
* numerical verification
* MATLAB dynamic simulation

### CASPR

* CASPR project structure
* planar model
* geometry
* coordinates
* mass / inertia
* Jacobian geometry
* trajectory representation
* partial dynamics verification

---

# 21. Major Remaining Knowledge Gaps

The remaining learning gaps are now divided into two branches.

## Main Research Branch

### Configuration and sensing

* workspace
* geometric workspace
* tension-feasible workspace
* forward kinematics
* inverse kinematics
* cable displacement sensing
* measurement model
* measurement noise
* sensor uncertainty
* observability
* identifiability
* state estimation
* nonlinear estimation

### Flexible-body research

* deformable-body representation
* deformation coordinates
* flexible-body kinematics
* cable–deformation relationship
* cable measurement model for deformable objects
* position estimation
* orientation estimation
* deformation estimation
* shape reconstruction

### Experimental research

* passive balloon motion generation
* cable attachment design
* cable displacement sensing
* cable tension sensing
* calibration
* data acquisition
* ground-truth measurement
* estimation validation
* shape reconstruction validation

---

# 22. Supporting Control Branch

The following topics remain useful but are not currently the main research path:

* trajectory planning
* active platform control
* cable motion control
* cable coupling
* tension-aware control
* cable interference
* force control

These topics should be studied when they become necessary for the experimental system.

The key distinction is:

```text
Traditional cable robot:

Desired trajectory
       ↓
Control
       ↓
Cable motion
       ↓
Platform motion
```

Current research direction:

```text
Passive / irregular balloon motion
       ↓
Cable motion
       ↓
Cable measurements
       ↓
State estimation
       ↓
Balloon position / shape
```

---

# 23. Updated Learning Path

# Phase 1 — Rigid-Body Cable Robot Foundation

## Lesson 1 — Cable Robot Kinematics

Status: **Completed**

```text
1.1 Cable Length                    √
1.2 Cable Direction                 √
1.3 Rotation and Cable Length      √
1.4 Cable Velocity                 √
1.5 Cable Jacobian                 √
```

---

## Lesson 2 — Cable Robot Statics

Status: **Completed**

```text
2.1 Kinematics → Statics            √
2.2 Structure Matrix                √
2.3 Static Equilibrium              √
2.4 Cable Tension Constraints       √
2.5 MATLAB Static Tension Solver    √
```

### Future optional task

```text
2.6 CASPR Statics
```

This is optional and should not delay the main research progression.

---

## Lesson 3 — Cable Robot Dynamics

Status: **Completed**

```text
3.1 Why Dynamics                    √
3.2 Newton–Euler Dynamics           √
3.3 Cable Forces / Moments          √
3.4 Complete Dynamic Model          √
3.5 Cable Velocity / Acceleration   √
3.6 MATLAB Dynamic Simulation       √
3.7 CASPR Dynamics Verification     √ / closed
```

---

# Phase 2 — Rigid-Body Configuration

## Lesson 4 — Workspace

### 4.1 Geometric Workspace

Status: completed 

Study:

* where the platform can physically move
* cable length limits
* cable geometry
* anchor configuration
* platform configuration

MATLAB goal:

```text
x-y grid
 ↓
calculate cable geometry
 ↓
check constraints
 ↓
plot feasible workspace
```
current parameters:
geometry
A = [-2 2 2 -2; 3 3 -1 -1]
r = [-0.5 0.5 0.5 -0.5; 0.5 0.5 -0.5 -0.5]
theta = 0

grid example
x = -4 : 0.1 : 4
y = -4 : 0.1 : 4

Important understanding:
- reducing $L_{max}$ removes regions that are too far from one or more anchors.
- Increasing $L_{min}$ removes regions where one or more cables become too short.
- Geometric feasibility does NOT guarantee static equilibrium or valid cable tension.       

### 4.2 Tension / Wrench Feasible Workspace

Status: Next

Connect workspace with previous statics knowledge:

$$
AT=-w_{ext}
$$

subject to:

$$
T_{min}\leq T\leq T_{max}
$$

Study:

* tension feasibility
* wrench feasibility
* cable engagement
* slack avoidance

### 4.3 Workspace and Sensing Quality

Introduce the idea that not every geometrically feasible position is equally useful for sensing.

Connect:

$$
Workspace
\rightarrow
Jacobian
\rightarrow
Sensitivity
$$

This prepares for later observability analysis.

---

# Phase 3 — Forward and Inverse Kinematics

## Lesson 5 — Forward Kinematics

Formalise the model:

$$
L=f(q)
$$

where:

$$
q=[x,y,\theta]^T
$$

and:

$$
L=
[L_1,L_2,L_3,L_4]^T
$$

The goal is to clearly distinguish:

```text
Forward problem:

q → L
```

from the future sensing problem.

---

## Lesson 6 — Inverse Kinematics

Study:

$$
L\rightarrow q
$$

Given measured cable lengths:

$$
L_{measured}
$$

estimate:

$$
q=[x,y,\theta]^T
$$

Start with simple numerical examples before introducing more advanced optimisation.

The main purpose is to establish the idea:

> Cable measurements can be used to estimate platform state.

---

# Phase 4 — Cable-Based Sensing

## Lesson 7 — Cable Displacement / Length Sensing

Use the rigid platform as a simplified sensing object.

Simulation:

```text
Known platform state
        ↓
Generate cable measurements
        ↓
Pretend measurements are sensor data
        ↓
Inverse model
        ↓
Estimated platform state
```

Compare:

$$
q_{true}
$$

with:

$$
\hat q
$$

---

## Lesson 8 — Measurement Noise and Uncertainty

Introduce:

$$
L_m=L+\epsilon
$$

where \(\epsilon\) represents measurement noise.

Study:

* sensor noise
* measurement error
* cable length uncertainty
* sensitivity
* estimation error

Simulation:

```text
True cable length
       ↓
Add noise
       ↓
Measured cable length
       ↓
Estimate q
       ↓
Compare with true q
```

---

## Lesson 9 — Observability and Identifiability

Study whether cable measurements contain enough information to determine the unknown state.

Use:

$$
J=\frac{\partial L}{\partial q}
$$

and investigate:

$$
rank(J)
$$

and related conditioning / sensitivity concepts.

The key question is:

> Can the available cable measurements uniquely determine the object state?

This is an important theoretical bridge between:

```text
Jacobian
    ↓
Sensing
    ↓
State estimation
```

---

# Phase 5 — State Estimation

## Lesson 10 — Least-Squares Estimation

Start with:

$$
\hat q = \arg\min_q \|L_{measured}-f(q)\|^2
$$

Study:

* estimation error
* residual
* least squares
* overdetermined measurements

---

## Lesson 11 — Nonlinear Least Squares

Because:

$$
L=f(q)
$$

is nonlinear, introduce nonlinear estimation methods.

The goal is to estimate:

$$
\hat q
$$

from cable measurements.

---

## Lesson 12 — Jacobian-Based Iterative Estimation

Use the local approximation:

$$
L(q+\Delta q)
\approx
L(q)+J\Delta q
$$

Therefore:

$$
\Delta q
\approx
J^\dagger
(L_{measured}-L)
$$

and:

$$
q_{k+1}=q_k+\Delta q
$$

This creates a direct connection:

```text
Lesson 1.5 Jacobian
        ↓
Inverse Kinematics
        ↓
State Estimation
```

---

# Phase 6 — Flexible / Deformable Body

Only after the rigid-body sensing problem is understood should the balloon model be introduced.

## Lesson 13 — Why Rigid-Body Models Are Not Enough

Rigid body:

$$
q=[x,y,\theta]
$$

cannot fully represent balloon deformation.

A deformable object requires additional state variables.

---

## Lesson 14 — Deformable-Body Representation

Start with simple representations before FEM.

Possible representations:

### Discrete points

$$
P_1,P_2,\ldots,P_n
$$

### Deformation parameters

$$
s=
[a_1,a_2,\ldots,a_n]^T
$$

For example:

$$
q=
[x,y,\theta,a_1,a_2]^T
$$

where \(a_i\) represent deformation modes.

---

## Lesson 15 — Cable–Deformation Measurement Model

Extend the rigid-body model:

Rigid body:

$$
L=f(x,y,\theta)
$$

Deformable body:

$$
L=f(x,y,\theta,s)
$$

where:

$$
s
$$

represents deformation.

This is the beginning of the core research model.

---

# Phase 7 — Passive Deformable-Object Sensing

## Lesson 16 — Passive Balloon Motion Model

The balloon motion should not be prescribed as a clean trajectory.

Instead, simulate or experimentally generate:

* irregular translation
* irregular rotation
* deformation
* combined motion and deformation

Conceptually:

```text
External / environmental disturbance
              ↓
      Passive balloon motion
              ↓
       Cable displacement
              ↓
       Cable measurements
```

The balloon state is treated as unknown.

---

## Lesson 17 — Passive State Estimation

Estimate:

$$
x,y,\theta,s
$$

from cable measurements.

The target relationship becomes:

$$
L_{measured}
\rightarrow
\hat{x},\hat{y},\hat{\theta},\hat{s}
$$

---

# Phase 8 — Shape Reconstruction

## Lesson 18 — Shape Parameter Estimation

Estimate deformation parameters:

$$
\hat s
$$

from cable measurements.

---

## Lesson 19 — Cable-to-Shape Reconstruction

Construct:

$$
\text{Cable measurements}
\rightarrow
\text{State}
\rightarrow
\text{Shape}
$$

Compare:

```text
True balloon shape
        vs
Estimated balloon shape
```

---

## Lesson 20 — Reconstruction Error and Robustness

Evaluate:

* position error
* orientation error
* deformation error
* shape error
* measurement noise sensitivity
* robustness to irregular motion

---

# Phase 9 — Experimental System

## Lesson 21 — Sensor System

Potential measurements:

* cable displacement / length
* cable tension
* cable velocity
* cable acceleration

Determine which measurements are actually required by the estimation model.

---

## Lesson 22 — Calibration

Study:

* anchor position calibration
* cable attachment calibration
* cable length zero point
* sensor calibration
* coordinate transformation calibration

---

## Lesson 23 — Data Acquisition

Develop:

```text
Cable sensors
      ↓
DAQ
      ↓
MATLAB
      ↓
Measurement processing
      ↓
State estimation
      ↓
Shape reconstruction
```

---

# Phase 10 — Experimental Validation

## Lesson 24 — Position Validation

Compare:

$$
p_{true}
$$

and:

$$
\hat p
$$

---

## Lesson 25 — Orientation Validation

Compare:

$$
\theta_{true}
$$

and:

$$
\hat\theta
$$

---

## Lesson 26 — Deformation Validation

Compare:

$$
s_{true}
$$

and:

$$
\hat s
$$

---

## Lesson 27 — Shape Reconstruction Validation

Compare:

```text
Ground-truth balloon shape
            vs
Reconstructed shape
```

under:

* different passive motions
* different deformation levels
* different cable configurations
* different measurement noise levels

---

# 24. Supporting Control Branch

Control is not deleted from the learning plan.

It is moved to a supporting branch:

```text
Supporting Cable Robot Branch

Workspace
    ↓
Trajectory Planning
    ↓
Active Control
    ↓
Cable Coupling
    ↓
Tension-aware Control
    ↓
Cable Interference
```

These topics should be studied when required by the final experimental system.

They are not currently the main route toward the research objective.

---

# 25. Main Research Learning Chain

The current completed foundation is:

```text
Cable Geometry
      ↓
Cable Length
      ↓
Cable Direction
      ↓
Platform Rotation
      ↓
Cable Velocity
      ↓
Jacobian
      ↓
Structure Matrix
      ↓
Statics
      ↓
Cable Tension
      ↓
Cable Wrench
      ↓
Dynamics
      ↓
Platform Acceleration
      ↓
Platform Motion
      ↓
Changing Cable Geometry
      ↓
Cable Velocity / Acceleration
      ↓
MATLAB / CASPR Verification
```

The new research-oriented chain is:

```text
MATLAB / CASPR Verification
          ↓
       Workspace
          ↓
   Forward Kinematics
          ↓
   Inverse Kinematics
          ↓
 Cable-based Sensing
          ↓
 Measurement Noise
          ↓
 Observability
          ↓
 State Estimation
          ↓
 Flexible-body Model
          ↓
 Deformation Estimation
          ↓
 Shape Reconstruction
          ↓
 Experimental Validation
```

---

# 26. Final Research Concept

The long-term research system is:

```text
        Passive Balloon
              │
              │
       irregular motion
       + deformation
              │
              ▼
       Cable displacement
       Cable length
       Cable tension
              │
              ▼
       Sensor measurements
              │
              ▼
      Measurement model
              │
              ▼
       State estimation
              │
        ┌─────┴─────┐
        ▼           ▼
    Position      Deformation
    Orientation       │
        │             │
        └──────┬──────┘
               ▼
        Shape reconstruction
               │
               ▼
       Experimental validation
```

The fundamental research direction is therefore:

$$
\boxed{
\text{Passive Deformable Motion}
\rightarrow
\text{Cable Measurements}
\rightarrow
\text{State Estimation}
\rightarrow
\text{Shape Reconstruction}
}
$$

The key difference from a traditional cable robot is that the object motion is **not primarily commanded by the system**.

Instead, the system observes the cable response generated by the object's passive and irregular motion and uses those measurements to infer the hidden state of the deformable object.

---

# 27. Current Next Task

**Current learning stage: Phase 2 — Rigid-Body Configuration**

## Immediate next lesson:

### Lesson 4.2 — Tension / Wrench Feasible Workspace

The next learning sequence should be:

```text
Lesson 4.1
Geometric Workspace                        [comepleted]
        ↓
Lesson 4.2
Tension / Wrench Feasible Workspace
        ↓
Lesson 4.3
Workspace and Sensing Quality
        ↓
Lesson 5
Forward Kinematics
        ↓
Lesson 6
Inverse Kinematics
        ↓
Lesson 7
Cable-based Sensing
```

The immediate goal is **not** to start balloon modelling yet.

First establish:

> Where can the rigid platform move, where is the cable configuration physically feasible, and how does the cable geometry affect the quality of future sensing?

This will provide the foundation for the later transition from:

```text
Rigid-body cable robot
        ↓
Cable-based measurement
        ↓
Passive deformable object
        ↓
State estimation
        ↓
Shape reconstruction
```

---

# 28. Current Research Boundary

At the current stage:

### Completed

```text
Rigid-body cable robot
Kinematics
Statics
Dynamics
MATLAB simulation
CASPR basic verification
```

### Current

```text
Workspace
```

### Next

```text
Forward / Inverse Kinematics
Cable-based Sensing
Observability
State Estimation
```

### Later

```text
Flexible-body modelling
Passive balloon motion
Shape reconstruction
Experimental validation
```

### Supporting branch

```text
Trajectory Planning
Control
Cable Coupling
Tension-aware Control
```

These supporting topics should not delay the main sensing research path unless they become necessary for the experimental system.
