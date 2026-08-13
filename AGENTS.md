# AGENTS.md

## 1. Project Purpose

This repository is a long-term learning and research workspace for
cable-driven robotics, cable-based sensing, simulation, mathematical
modeling, control, and flexible-body research.

The repository is used for:

- Learning cable robot theory
- Developing MATLAB code
- Developing CASPR simulations
- Reading and analyzing research papers
- Recording experiments
- Developing the user's research project


## 2. Current Research Direction

The current research direction is:

> Cable-Based Sensing and Shape Reconstruction for Flexible Bodies

The main research idea is to investigate whether the motion,
displacement, and/or tension of cables can be used to estimate
the position and shape of a flexible body such as a balloon.

The conceptual pipeline is:

Flexible body deformation
→ cable displacement / tension change
→ cable measurements
→ mathematical model
→ state estimation
→ position and shape reconstruction


## 3. Research Development Path

The research should gradually develop through the following stages:

1. Cable robot fundamentals
2. Coordinate systems and cable geometry
3. Cable length and direction
4. Wrench and Jacobian
5. Forward kinematics
6. Inverse kinematics
7. Cable-based sensing
8. State estimation
9. Flexible-body modeling
10. Shape reconstruction
11. Experimental validation


## 4. Learning Philosophy

Learning should combine:

Theory
→ Mathematical derivation
→ Simple numerical example
→ MATLAB implementation
→ CASPR simulation
→ Research application

Do not introduce advanced concepts without explaining their
physical meaning and connecting them to a simple example.

The goal is not only to understand how to use a formula, but also
to understand why the formula is needed and what physical problem
it represents.


## 5. Current Technical Foundation

The current learning foundation includes:

- World coordinate system
- Local coordinate system
- Coordinate transformation
- Cable length
- Cable direction vector
- Unit direction vector
- Attachment point
- Moment arm
- Cable wrench matrix
- Basic force and moment analysis

The current simulation platform is CASPR.

The current CASPR example is a planar XY rigid-body system
with four cables.


## 6. Rigid Body to Flexible Body

The current CASPR learning examples mainly use a rigid body.

For a planar rigid body:

q = [x, y, theta]

The long-term research will move from rigid-body modeling toward
flexible-body modeling.

A flexible body may require additional generalized coordinates
or distributed shape representations.

The transition should be gradual:

Rigid body
→ cable geometry
→ cable sensing
→ flexible-body deformation
→ shape estimation


## 7. Coordinate System Rules

Always distinguish clearly between:

- World/global coordinates
- Local/body coordinates

For coordinate transformations, explicitly identify the coordinate
system of every vector.

For a planar rigid body:

p_world = p_platform + R(theta) * p_local

Do not mix local and world coordinates without an explicit
transformation.


## 8. Coding Rules

MATLAB is the primary programming language during the early stages.

Code should prioritize:

- Clear variable names
- Physical meaning of variables
- Correct matrix dimensions
- Vectorized operations where appropriate
- Reusable functions
- Simple and readable implementation

Prefer MATLAB built-in functions when they make the physical
meaning clearer.

For example:

CableLength = vecnorm(LengthVector, 2, 2);

is preferred over manually calculating the Euclidean norm
when appropriate.


## 9. Simulation Rules

CASPR should be used to connect theory with physical behavior.

Simulation tasks should follow:

Physical problem
→ mathematical model
→ CASPR implementation
→ simulation
→ observation
→ interpretation

Simulation results must not be invented.

If a result has not been verified, explicitly state that it is
a prediction or hypothesis.


## 10. Paper Reading Rules

For important papers, record:

- Research problem
- Motivation
- System architecture
- Mathematical model
- Method
- Experimental setup
- Results
- Advantages
- Limitations
- Relevance to the current research

The goal is not only to summarize papers.

Always ask:

> What can this paper contribute to the current research?


## 11. Experiment Rules

Every important experiment should record:

- Objective
- Setup
- Parameters
- Expected result
- Actual result
- Difference
- Possible explanation
- Next experiment

Failed experiments should be preserved because they are part
of the research history.


## 12. AI / Codex Working Rules

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


## 13. Current State

`current-state.md` is the main source of truth for the current
learning and research status.

It should contain:

- Current learning stage
- Completed milestones
- Current research stage
- Current research question
- Current task
- Next task

Do not create multiple files that duplicate the same current-status
information.


## 14. Repository Structure

The main repository structure is:

01-paper-reading/
02-simulation-learning/
03-code-exercises/
04-my-research/
05-knowledge-base/
06-experiments/

The purpose of each section is:

01-paper-reading:
Research papers and paper analysis.

02-simulation-learning:
CASPR and other simulation learning.

03-code-exercises:
MATLAB and other programming exercises.

04-my-research:
The user's actual research development.

05-knowledge-base:
Long-term theoretical knowledge and reference material.

06-experiments:
Simulation and physical experiment records.


## 15. Long-Term Goal

The long-term goal is to develop a complete research pipeline:

Literature Review
→ Theory
→ Mathematical Modeling
→ MATLAB Implementation
→ CASPR Simulation
→ Cable-Based Sensing
→ Flexible-Body Modeling
→ State Estimation
→ Shape Reconstruction
→ Experimental Validation
→ Research Contribution
