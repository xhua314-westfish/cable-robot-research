# Current State

Last updated: 2026-08-18

## 1. Research Direction

My research focuses on developing a cable-robot-based measurement system for a deformable balloon-like object.

The long-term goal is:

> Use a cable robot system to measure the position and shape of a deformable balloon by using the motion of the balloon to drive cable motion, and infer the balloon state from cable measurements.

The research involves a transition from:

Rigid-body cable robot
        ↓
Cable-driven measurement system
        ↓
Flexible / deformable object
        ↓
Shape and position estimation

---

## 2. Current Research Idea

The basic concept is:

1. Attach cables to a balloon or deformable object.
2. Drive or deform the balloon.
3. The balloon motion changes cable positions and cable lengths.
4. Measure cable-related quantities such as:
   - cable length
   - cable displacement
   - cable tension
5. Use these measurements to estimate:
   - balloon position
   - balloon orientation
   - balloon shape / deformation

---

## 3. Current Learning Stage

### Completed

#### Lesson 0 — MATLAB Basics
Status: Completed

Basic MATLAB syntax and matrix operations have been studied.

---

#### Lesson 0.5 — CASPR Basic Structure
Status: Completed

Topics understood:

- CASPR project structure
- XML configuration files
- bodies_system
- cables
- operational_spaces
- trajectories
- rigid body
- PLANAR_XY
- cable attachment points
- anchor points
- world coordinate system
- local coordinate system

The planar_xy example has been inspected file by file.

---

#### Lesson 1.1 — Cable Length
Status: Completed

Topics understood:

- world coordinates
- local coordinates
- transformation from local to world coordinates
- anchor points
- attachment points
- cable length
- Euclidean distance
- basic cable geometry

Basic formula:

L_i = ||A_i - P_i||

where:

A_i = cable anchor point

P_i = cable attachment point

---

#### Lesson 1.2 — Cable Direction
Status: Completed

Topics understood:

- cable vector
- cable unit direction vector
- normalization
- relationship between cable length and direction

Basic formula:

d_i = A_i - P_i

l_i = ||d_i||

u_i = d_i / l_i

---

#### Lesson 1.3 — Rotation and Cable Length
Completed:
- 2D rotation matrix
- Local-to-world transformation
- Attachment point transformation
- Cable vector calculation
- Cable length calculation
- MATLAB for-loop
- MATLAB 3-D arrays
- squeeze()
- Cable length vs platform rotation plot

Key equations:

B_i = P + R(theta) r_i

d_i = A_i - B_i

L_i = ||d_i||

For the symmetric geometry:

L1(theta) = L3(theta)
L2(theta) = L4(theta)

---

## 4. Current CASPR Model

Status: Basic planar model understood

Current model:

Planar XY cable robot
4 cables
Platform DOF: q=[x,y,θ]
Platform attachment points defined in local coordinates
Cable anchor points defined in world coordinates

CASPR has been used mainly to understand:

model structure
coordinate systems
cable geometry
platform motion
trajectory configuration

The current focus is shifting from CASPR model setup to understanding the underlying cable-robot kinematics mathematically and implementing them independently in MATLAB.

---

## 5. Current MATLAB Practice

A MATLAB simulation has been independently implemented to:

rotate the platform from 0° to 360°
transform attachment points from local to world coordinates
calculate cable vectors
calculate cable lengths
plot cable length versus platform rotation

Current implementation uses:

for loops
matrices
3-D arrays
squeeze()
basic plotting

The next MATLAB step is to calculate cable velocity and the cable Jacobian.

---

## 6. Current Understanding

I currently understand:

- why local and world coordinate systems are needed
- how to transform an attachment point from local to world coordinates
- how cable length is calculated
- how cable direction is calculated
- why the cable vector needs to be normalized
- how cable tension creates force
- how the attachment point creates torque
- how four cable forces can be represented using a wrench matrix

---

## 7. Current Knowledge Gaps

The following topics still need to be learned:

- rotation matrix (completed)
- complete planar rigid-body transformation (completed)
- cable Jacobian
- relationship between cable length and platform motion
- differential kinematics
- static equilibrium
- tension distribution
- workspace
- dynamics
- trajectory planning
- control
- cable interference / coupling
- flexible-body modelling
- deformable object shape estimation

---

## 8. Current Learning Path

The current planned sequence is:

Lesson 1 — Cable Robot Kinematics

    1.1 Cable Length                    [Completed]
    1.2 Cable Direction                 [Completed]
    1.3 Rotation and Rigid Transformation [Completed]
    1.4 Cable Velocity
    1.5 Cable Jacobian

Lesson 2 — Cable Jacobian

Lesson 3 — Statics

Lesson 4 — Dynamics

Lesson 5 — Workspace

Lesson 6 — Trajectory Planning

Lesson 7 — Control

After the rigid-body cable robot foundation is established:

    Cable Robot
        ↓
    Flexible / Deformable Object
        ↓
    Cable-based Measurement
        ↓
    Position Estimation
        ↓
    Shape Estimation
