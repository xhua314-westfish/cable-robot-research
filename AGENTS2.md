# AGENTS2 — Research Working Rules

**Last Updated:** 2026-10-16

**Project:** Cable-Robot-Based Sensing for a Passive Deformable Balloon

---

## 1. Purpose

This file defines the working rules for research, mathematical modelling, MATLAB simulation, validation, and repository maintenance.

The project follows a **research-question-driven approach**.

Core principle:

> Learn, model, simulate, and experiment only when they help answer a defined research question.

Detailed research progress, schedules, and technical designs are maintained in their respective documents.

---

## 2. Current Research Scope

The current study investigates cable-based position sensing using:

- A simplified gastric workspace based on an adult female anatomical reference.
- A 550 mL rigid spherical object (equivalent diameter approximately 10.17 cm).
- Cable length or displacement measurements.
- Candidate cable numbers, anchor locations, and attachment locations.
- Measurement accuracy, identifiability, and workspace coverage.

### Scope Rules

1. Use the gastric outline as a spatial constraint, not as a detailed physiological model.
2. Treat the rigid sphere as an engineering approximation of a gastric balloon.
3. Label any unsupported gastric dimensions as assumptions.
4. Start with a simple planar sensing model before introducing additional degrees of freedom.
5. Do not assume the object trajectory is known by the estimator.
6. Prioritise position estimation before deformation or shape reconstruction.

**Important:** The rigid-body model is the initial validation platform, not the final deformable-balloon model.

---

## 3. Research Workflow

Follow this sequence:

```text
Research Question
       ↓
Assumptions and Evidence
       ↓
Mathematical Model
       ↓
MATLAB Simulation
       ↓
Measurement / Estimation
       ↓
Validation
       ↓
Research Conclusion
```

For each research task:

- Define one
