# Learning

This folder contains the theoretical and practical knowledge developed during the Cable Robot research project.

The learning strategy is:

> Theory → Derivation → Visualization → MATLAB → CASPR → Exercise → Research Connection

The goal is not only to learn how to use CASPR, but to understand the mathematical and physical principles behind cable robots.

---

# Learning Roadmap

## 00 — MATLAB Basics

Basic MATLAB programming and numerical computation.

Status: Completed

---

## 00.5 — CASPR Basics

Understanding the CASPR simulation framework.

Topics:

- CASPR project structure
- XML configuration
- bodies_system
- cables
- operational_spaces
- trajectories
- rigid body
- PLANAR_XY model
- anchor points
- attachment points
- local coordinate system
- world coordinate system

Status: Completed

---

# 01 — Cable Robot Kinematics

## 01.1 — Cable Length

Topics:

- Anchor point
- Attachment point
- Local coordinate
- World coordinate
- Cable vector
- Cable length

Basic relationship:

L_i = ||A_i - P_i||

Status: Completed

---

## 01.2 — Cable Direction

Topics:

- Cable vector
- Cable unit direction vector
- Vector normalization
- Force direction

Basic relationship:

d_i = A_i - P_i

L_i = ||d_i||

u_i = d_i / L_i

Status: Completed

---

## 01.3 — Rotation and Rigid Transformation

Topics:

- Platform rotation
- Rotation matrix
- SE(2) transformation
- Local-to-world coordinate transformation
- Effect of platform rotation on cable length

Status: Next

---

## 01.4 — Cable Velocity

Topics:

- Platform velocity
- Cable length rate
- Relationship between platform motion and cable motion

Status: Planned

---

## 01.5 — Cable Jacobian

Topics:

- Jacobian matrix
- Cable velocity mapping
- Platform velocity mapping
- Geometric interpretation of the Jacobian

Status: Planned

---

# 02 — Statics

Topics:

- Cable tension
- Force equilibrium
- Moment equilibrium
- Wrench matrix
- Tension distribution
- Static feasibility

Status: Planned

---

# 03 — Dynamics

Topics:

- Newton-Euler equations
- Mass and inertia
- Cable forces
- Platform acceleration
- Dynamic modelling

Status: Planned

---

# 04 — Workspace

Topics:

- Reachable workspace
- Wrench-feasible workspace
- Cable tension constraints
- Collision and cable interference

Status: Planned

---

# 05 — Trajectory Planning

Topics:

- Linear trajectory
- Cubic spline
- Quintic spline
- Parabolic blend
- Cartesian trajectory
- Joint-space trajectory
- Feasible trajectory

Status: Planned

---

# 06 — Control

Topics:

- Position control
- Cable tension control
- Inverse kinematics
- Jacobian-based control
- Feedback control
- Simulation control
- Simulink implementation

Status: Planned

---

# Research Connection

The ultimate purpose of this learning path is to support the development of a cable-robot-based measurement system for a deformable balloon-like object.

The research direction is:

Rigid Cable Robot

        ↓
Cable Kinematics

        ↓
Cable Jacobian

        ↓
Statics and Dynamics

        ↓
Cable-based Measurement

        ↓
Flexible / Deformable Object

        ↓
Position Estimation

        ↓
Shape Estimation
