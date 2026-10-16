# Current Research State

**Last Updated:** 2026-10-16  
**Research Phase:** Rigid-Body Sensing and Cable Configuration Design  
**Primary Tool:** MATLAB  
**Status:** Research baseline defined; sensing validation pending

---

## 1. Current Research Direction

### Long-Term Goal

Develop a cable-based sensing system to estimate the position and eventually deformation or shape of a passively moving balloon-like object.

The research focuses on measurement and state estimation rather than motion control.

### Current Research Objective

Investigate how cable number and placement affect position-estimation accuracy for a simplified rigid object.

**Current Research Question:**

> How do cable number and placement affect the accuracy and reliability of position estimation for a 550 mL rigid spherical object moving within a simplified gastric workspace?

---

## 2. Simplified Research Baseline

| Parameter | Current Definition | Status |
|---|---|---|
| Application | Intragastric balloon sensing | Research context |
| Population | Adult female reference | Selected initial focus |
| Environment | Simplified gastric outline | Proposed model |
| Workspace dimensions | Length × Width × Height | Literature evidence pending |
| Measurement object | Rigid spherical balloon proxy | Engineering assumption |
| Balloon volume | 550 mL | Commercial product reference |
| Equivalent diameter | Approximately 10.17 cm | Calculated |
| Initial measurement | Object position | Primary objective |
| Initial state model | Planar position [x, y] | Proposed starting point |
| Cable number | To be determined | Research variable |
| Anchor positions | To be determined | Research variable |
| Attachment positions | To be determined | Research variable |

### Key Assumptions

- The gastric environment is used only to constrain object movement.
- Detailed stomach anatomy and deformation are not required initially.
- The 550 mL sphere is a simplified rigid-body representation, not an exact balloon shape.
- The equivalent diameter is derived from volume, not directly measured.
- Initial planar position sensing assumes orientation is constrained or independently known.
- Experimental motion can be prescribed for validation, but must remain unknown to the state estimator.

The anatomical dimensions and final measurement configuration have not yet been validated.

---

## 3. Completed Work

### 3.1 Clinical Evidence Review

Four evidence areas have been investigated:

| Evidence | Main Finding |
|---|---|
| A — Monitoring | Clinical assessment is intermittent; continuous state measurements are not routinely established |
| B — Volume and Morphology | Nominal filling volumes and abnormal expansion cases provide preliminary size references |
| C — Position and Migration | Migration is documented, but normal movement trajectories remain uncertain |
| D — Dimensions | Volume and selected imaging data provide partial geometric information |

**Main conclusion:**

Clinical evidence supports an initial balloon-size reference and motivates position sensing, but does not define a complete gastric motion workspace.

For the current rigid-body study, simplified anatomical boundaries are sufficient as an initial engineering model, provided their assumptions are documented.

### 3.2 MATLAB and Cable-Robot Foundation

Previously explored or implemented:

- Coordinate transformations
- Anchor and attachment geometry
- Cable vectors and lengths
- Measurement Jacobian
- Cable-length velocity and acceleration
- Rigid-body kinematics and dynamics
- Cable tension and wrench feasibility
- Geometric and tension-feasible workspace
- Measurement sensitivity and pattern similarity
- Forward kinematics
- Planar CASPR reference models

The existing four-cable planar MATLAB model will be reused as a mathematical reference.

It is not assumed to be the optimal final cable configuration.

---

## 4. Current Technical Findings

### 4.1 Cable Measurements

The forward cable-length measurement model is:

\[
L=h(q)
\]

The sensor model is:

\[
y=h(q)+\varepsilon
\]

where \(q\) is the object state and \(\varepsilon\) represents measurement error.

The measurement Jacobian is:

\[
H(q)=\frac{\partial h(q)}{\partial q}
\]

These relationships provide the foundation for state estimation and cable-configuration analysis.

### 4.2 Previous Sensitivity Observation

Previous planar simulations indicated that x-translation and rotation could generate nearly dependent cable-length measurement patterns at the reference configuration.

**Implication:**

Four cables do not automatically guarantee independent measurement information for all three planar degrees of freedom.

Jacobian rank and measurement conditioning must be evaluated before selecting a configuration.

### 4.3 Workspace Interpretation

Three different regions must be distinguished:

1. **Gastric boundary:** Simplified anatomical environment.
2. **Geometrically feasible region:** Positions where the entire rigid sphere fits within the boundary.
3. **Sensing workspace:** Configurations where cable measurements satisfy the required identifiability and accuracy conditions.

The gastric boundary is not automatically the cable sensing workspace.

---

## 5. Open Research Questions

| Priority | Question | Current Status |
|---|---|---|
| High | What is the initial state model and orientation constraint? | Not finalised |
| High | What simplified gastric dimensions should be used? | Evidence pending |
| High | What is the minimum feasible cable number? | Not evaluated |
| High | Where should anchors and attachments be located? | Not evaluated |
| High | What measurement accuracy can be achieved? | Not validated |
| Medium | How should measurement noise be modelled? | Not finalised |
| Medium | How should rigid-body ground truth be measured? | Not designed |
| Future | How can sensing extend to balloon deformation? | Not started |

---

## 6. Immediate Next Step

**Task 2.1 — Define the Initial Sensing Objective**

The proposed starting point is planar position estimation:

\[
q=[x,y]^T
\]

Before confirming this choice:

1. Specify how object rotation is constrained or measured.
2. Define the simplified gastric boundary assumptions.
3. Establish the initial position-accuracy requirement.
4. Verify the existing cable measurement model.
5. Prepare candidate cable configurations for comparison.

**Expected Outcome:**

A clearly defined rigid-body position sensing problem suitable for MATLAB simulation and subsequent accuracy evaluation.

---

## Related Documents

- [Research Guidelines](AGENTS2.md)
- [Research Roadmap](08_Project_Management/Roadmap.md)
- [Research TODO](08_Project_Management/TODO.md)
- [Weekly Plan](08_Project_Management/WEEKLY_PLAN.md)
- [Rigid-Body Sensing Design](05_My_Research/Rigid_Body_Sensing_Design_v0.1.md)
- [Research Log](06_Research_Log/)

**Next milestone:** Verify that the selected cable measurements can recover the object's position reliably within the simplified test region.
