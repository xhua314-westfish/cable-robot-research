# Lesson 0.5 — CASPR Basics

## Objective

Understand the basic structure of CASPR and learn how a cable robot is represented using XML configuration files.

---

# 1. CASPR Model Structure

The planar XY example contains several important configuration files:

- bodies_system
- cables
- operational_spaces
- trajectories

These files describe different parts of the robot model.

---

# 2. bodies_system

The `bodies_system` file defines the rigid bodies and their joints.

For the planar XY example:

```text
q = [x, y, theta]
