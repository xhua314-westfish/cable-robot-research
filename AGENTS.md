# AGENTS.md — Repository Instructions for AI Coding Agents

**Project:** Cable-Robot-Based Sensing for a Passive Deformable Balloon

This file is the entry point for AI coding agents, including Codex.

The detailed research and AI working rules are maintained in [AGENTS2.md](AGENTS2.md).

Do not use historical learning plans as the current research instructions.

---

## 1. Required Context

Before starting a research or coding task, read:

1. `AGENTS2.md` — Research principles, modelling conventions, validation rules and AI workflow.
2. `CURRENT_STATE2.md` — Current research phase, completed work and unresolved questions.
3. `08_Project_Management/current_october_november_todo.md` — Active tasks and completion criteria.
4. `08_Project_Management/Roadmap.md` — Research milestones and phase definitions.

Then inspect only the MATLAB scripts, research models and notes relevant to the active task.

If an instruction or document is unavailable, report the missing context rather than assuming its content.

---

## 2. Current Research Direction

The project develops a cable-based measurement and sensing system for a passively moving balloon-like object.

**Long-term objective:** Estimate position, orientation and eventually deformation or shape using cable measurements.

**Current scope:**

- Simplified 3D gastric environment.
- 550 mL rigid spherical balloon proxy.
- Six-degree-of-freedom rigid-body pose estimation.
- Six-, seven- and eight-cable configuration comparison.
- Cable-length-based measurements.
- Passive and unknown balloon motion.
- Motor-assisted low-tension cable tracking as a proposed architecture.

The research concerns measurement and estimation, not active trajectory control.

---

## 3. Current Research Phase

**Phase A:** Core literature-based method reproduction completed.

**Phase B:** Balloon-specific cable sensing design — current.

**Active work package:** B1 — Geometry and Candidate Region Definition.

The Phase B sequence is:

B1 — Geometry and Candidate Regions  
B2 — Cable Configuration Generation  
B3 — Feasibility Screening  
B4 — Sensing Quality Evaluation  
B5 — Configuration Selection

Do not repeat completed A1–A5 exercises unless a specific research question requires further verification.

Do not begin configuration optimisation before the relevant geometry and constraints are documented.

---

## 4. Scientific and Modelling Rules

1. Treat balloon motion as passive and unknown to the estimator.
2. Distinguish world-frame anchors from body-frame attachments.
3. Use explicit coordinate conventions, units and matrix dimensions.
4. Separate geometric feasibility, cable routing, tension feasibility and sensing quality.
5. Treat Jacobian rank 6 as a local identifiability condition, not a guarantee of global uniqueness.
6. Do not assume that more cables automatically improve sensing accuracy.
7. Distinguish literature-supported, derived and assumed values.
8. Do not claim numerical simulations establish experimental hardware accuracy.
9. Preserve validated numerical results and record model limitations.
10. Use the detailed conventions and validation rules in `AGENTS2.md`.

---

## 5. Coding and Verification

MATLAB is the primary computational platform.

When implementing or modifying code:

- Reuse existing verified implementations where possible.
- Prefer small, readable and reproducible functions.
- Document physical units and coordinate frames.
- Verify Jacobians numerically where appropriate.
- Check matrix dimensions, constraints and residuals.
- Record random seeds for Monte Carlo simulations.
- Report both successful and failed tests.
- Do not label code as verified unless it has actually been executed and checked.

CASPR is a secondary verification tool, not the default research platform.

---

## 6. Repository Editing Rules

Only modify files relevant to the requested task.

Before editing:

1. Read the existing file.
2. Identify the smallest necessary change.
3. Preserve validated results and historical records.
4. Avoid duplicating research status across multiple documents.

After editing, report:

- Files changed.
- Purpose of each change.
- Tests actually performed.
- Results and limitations.
- Remaining issues.
- Recommended next action.

Do not commit, push or rewrite project-wide plans without explicit user approval.

---

## 7. Daily Research Handoff

At the end of a research session, provide:

```text
Current phase:
Current task:
Research question:
Files used or modified:
Verified results:
Unresolved issues:
Next action:
```

Update research status or completion checkboxes only when supported by verified work.

The repository, rather than a long chat history, should retain the essential research state.

---

## 8. Authoritative Documents

| Document | Responsibility |
|---|---|
| `AGENTS.md` | Entry instructions for AI coding agents |
| `AGENTS2.md` | Detailed research and AI working rules |
| `CURRENT_STATE2.md` | Current research status |
| `08_Project_Management/Roadmap.md` | Long-term research stages |
| `08_Project_Management/current_october_november_todo.md` | Current actionable tasks |
| `08_Project_Management/weekly_plan_02.md` | Archived Phase A sprint record |
| `05_My_Research/` | Research models and technical designs |
| `04_Code_Exercises/MATLAB/` | MATLAB implementations |
| `06_Research_Log/` | Verified experiment notes and research history |

When current and historical documents disagree, prefer the verified current research state and report unresolved conflicts.

---

**Current Priority:** Complete B1 geometry and candidate-region definition before comparing six-, seven- and eight-cable sensing configurations.
