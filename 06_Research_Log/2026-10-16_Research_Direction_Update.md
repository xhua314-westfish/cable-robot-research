# Research Log — Research Direction Update

**Date:** 2026-10-16  
**Research period:** Week 13 (16–23 October 2026)  
**Research topic:** Cable-Robot-Based Sensing for a Passive Deformable Balloon  
**Current phase:** Transition from clinical evidence review to sensing-system design

---

# 1. Research Context

The long-term research goal is to develop a cable-based sensing system capable of estimating the position, orientation, and deformation or shape of a passively moving balloon-like object.

The research is motivated by intragastric balloon monitoring, where changes in balloon position, volume, and morphology may be clinically relevant.

The system is intended to infer object states from cable length, displacement, and potentially tension measurements.

**Fundamental research principle:**

The balloon motion is passive and is not assumed to follow a known trajectory during estimation.

---

# 2. Work Completed and Presented

## 2.1 Clinical Evidence Review

The recent presentation consolidated four evidence areas.

### Evidence A — Clinical Monitoring

Main findings:

- Intermittent clinical follow-up
- Symptom-based assessment
- CT or X-ray when clinically indicated
- Endoscopic inspection or removal
- No established routine continuous balloon-state record

**Research implication:**

Continuous or more frequent quantitative state measurements may address information not captured by intermittent clinical assessment.

### Evidence B — Balloon Volume and Morphology

Main findings:

- Nominal and adjustable filling volumes
- Reported hyperinflation cases
- Selected MRI and CT observations
- Qualitative deflation and collapse states
- Limited quantitative collapsed-shape information

**Research implication:**

Reported volumes can define preliminary test scenarios, but do not uniquely determine balloon shape.

### Evidence C — Position and Migration

Main findings:

- Documented migration and impaction events
- Clinical identification of balloon location
- Records of obstruction and intervention
- Limited information on normal trajectories and velocities

**Research implication:**

Clinical outcomes demonstrate the relevance of balloon position, but do not establish normal motion boundaries.

### Evidence D — Physical Dimensions

Main findings:

- Product filling-volume references
- Selected measured dimensions
- Derived equivalent spherical diameters
- Incomplete three-dimensional geometric information

**Research implication:**

Existing evidence supports preliminary size references rather than a complete three-dimensional workspace.

---

# 3. Workspace Draft 1.0

The presentation established a preliminary workspace specification.

| Parameter | Reference | Classification |
|---|---|---|
| Nominal filling volume | 550–700 mL | Reported range |
| Adjustable volume examples | Approximately 380–850 mL | Reported examples |
| Hyperinflation cases | 1,011 / 1,513 mL | Reported cases |
| Nominal equivalent diameter | Approximately 10.17–11.02 cm | Derived reference |
| Abnormal equivalent diameter | Approximately 12.45–14.24 cm | Derived reference |
| Abnormal CT dimensions | 12.7 × 11.6 × 13.2 cm | Case-specific measurement |
| Normal motion range | Unknown | Evidence gap |
| Collapse dimensions | Unknown | Evidence gap |
| Complete gastric 3D boundaries | Unknown | Evidence gap |
| Cable sensing workspace | Not determined | Engineering investigation |

**Conclusion:**

Workspace Draft 1.0 provides preliminary physical references and candidate test scenarios.

It does not define the final cable-robot sensing workspace.

---

# 4. Meeting Feedback

Following the meeting, additional clarification was obtained through discussion with Siqi.

The following points represent Siqi's interpretation and recommendations, rather than a formally confirmed final research specification from Peter.

## 4.1 Simplify the Initial Motion Scenarios

The natural motion, expansion, and contraction of the gastric balloon are difficult to define comprehensively.

The initial sensing study should therefore focus on simplified and repeatable cases.

Examples:

- Straight-line displacement
- Different movement speeds
- Small position changes
- Simple rotational motion, if required

The purpose is to evaluate whether the cable system can measure object states accurately.

## 4.2 Focus on Cable Configuration

A central research challenge is determining:

- The minimum suitable number of cables
- Cable anchor locations
- Object attachment locations
- Measurement accuracy
- Sensing performance across the selected workspace

Cable number and placement should be justified using the measurement model and experimental evidence.

## 4.3 Begin with a Rigid Object

A rigid-body experimental platform was suggested as the initial development step.

The proposed progression is:

1. Study or reproduce a reference cable-robot platform.
2. Establish a rigid-body measurement system.
3. Introduce simple object motion.
4. Measure cable responses.
5. Estimate object state.
6. Compare with ground truth.
7. Extend to a deformable balloon.

## 4.4 Existing Reconstruction Information

Siqi indicated that existing balloon reconstruction or motion information may be available.

However:

- Some trajectories are complex and curved.
- The data may be difficult to use in the initial measurement experiments.
- Compatibility with the cable measurement model is not established.
- Further discussion is required before using these data.

---

# 5. Interpretation of the Research Challenge

The recent discussion helps separate the project into two levels.

## 5.1 Long-Term Research Challenge

Estimate the position, orientation, and deformation or shape of a passive balloon from cable measurements.

This remains the overall research objective.

## 5.2 Immediate Research Challenge

Determine whether a cable sensing system can reliably estimate the state of a simplified rigid object.

The immediate technical questions are:

1. Which state variables should be measured?
2. What cable number is required?
3. Where should anchors be located?
4. Where should cables attach to the object?
5. How does configuration affect measurement quality?
6. What measurement accuracy can be achieved?
7. Which regions allow reliable state estimation?

These questions should be investigated before attempting full balloon shape reconstruction.

---

# 6. Research Direction Adjustment

## Previous Emphasis

- General cable-robot theory
- Kinematics and dynamics
- Workspace concepts
- MATLAB learning exercises
- CASPR verification
- Clinical evidence collection

## Updated Emphasis

- Define a specific sensing objective
- Establish a rigid-body reference model
- Investigate cable configuration
- Evaluate measurement Jacobian and identifiability
- Implement state estimation
- Validate measurement accuracy
- Design initial experimental hardware
- Progress toward deformable-balloon sensing

**Important:**

The previous learning remains valuable and provides the technical foundation for the updated research.

The adjustment changes the order and priority of research activities rather than replacing the original research goal.

---

# 7. Connection to Previous MATLAB Results

Previous simulations established the relationship between object state and cable lengths.

For the planar reference model:

\[
q=[x,y,\theta]^T
\]

The measurement model is:

\[
L=h(q)
\]

The local sensitivity model is:

\[
\Delta L\approx H(q)\Delta q
\]

Previous sensitivity results suggested that x translation and theta rotation may produce linearly dependent measurement patterns at the reference configuration.

This leads to a specific research concern:

> Having four cables does not necessarily guarantee that all three planar state variables can be independently estimated.

The next investigation should verify Jacobian rank, local identifiability, and sensitivity under alternative cable geometries.

---

# 8. Research Decisions

## Decision 1 — Rigid-Body-First Approach

**Decision:** Use a simplified rigid body for the initial sensing-system development.

**Reason:** It separates rigid-body state estimation from deformation estimation, reducing the number of unknowns in the first experiments.

**Status:** Proposed working approach; final experimental details remain open.

## Decision 2 — Simplified Motion Validation

**Decision:** Use repeatable motion scenarios before investigating complex passive motion.

**Reason:** Simple scenarios allow controlled comparisons between estimated states and ground truth.

**Important distinction:** Prescribed experimental motion must not be supplied directly to the estimator.

## Decision 3 — Cable Geometry as a Primary Investigation

**Decision:** Investigate cable number, anchor placement, and attachment placement systematically.

**Reason:** These parameters determine the measurement information available for state estimation.

## Decision 4 — Preserve the Deformable-Balloon Objective

**Decision:** Retain balloon deformation and shape reconstruction as later research stages.

**Reason:** The long-term goal requires deformable-object sensing, while the first stage establishes the measurement foundation.

## Decision 5 — Use Clinical Evidence as Reference, Not Final Geometry

**Decision:** Use Workspace Draft 1.0 for preliminary test-scenario definition.

**Reason:** Available clinical data do not yet establish normal balloon motion, collapse geometry, or complete three-dimensional workspace boundaries.

---

# 9. Open Questions

## Sensing Objective

- Should the initial model estimate planar position only?
- Should planar orientation be included from the beginning?
- What measurement accuracy is required?

## Cable Configuration

- What is the minimum suitable cable number?
- Which anchor arrangement gives sufficient independent information?
- Which attachment arrangement reduces measurement coupling?
- How should redundancy be evaluated?

## Experimental Design

- Which reference robot configuration should be reproduced?
- Which sensors are suitable for cable-length measurement?
- How will object motion be generated?
- How will ground truth be measured?
- How will cable tension be maintained without undesired motion constraints?

## Deformable-Balloon Extension

- How should cables connect to a deformable balloon?
- How will attachment points move during deformation?
- Which deformation variables should be estimated?
- What reconstruction information is available from Siqi?

---

# 10. Next Research Actions

## Immediate Priority

**Define the initial rigid-body measurement objective.**

Compare:

\[
q=[x,y]^T
\]

and

\[
q=[x,y,\theta]^T
\]

The selected model determines the measurement requirements and candidate cable configurations.

## Next MATLAB Tasks

1. Reproduce the existing four-cable reference geometry.
2. Calculate the measurement Jacobian.
3. Verify Jacobian rank at selected states.
4. Investigate x–theta measurement coupling.
5. Compare alternative attachment or anchor layouts.
6. Implement initial state estimation.
7. Evaluate estimation error.

## Documentation

Update:

- `CURRENT_STATE2.md`
- `AGENTS2.md`
- `08_Project_Management/Roadmap.md`
- `08_Project_Management/TODO.md`
- `05_My_Research/Rigid_Body_Sensing_Design_v0.1.md`

---

# 11. Research Reflection

The main lesson from the recent research review and discussion is that the project should progress from demonstrable measurement capabilities toward increasingly complex physical behaviour.

Clinical evidence clarifies the application context and motivates relevant sensing objectives.

However, the next technical challenge is not to reproduce every possible gastric balloon motion.

Instead, the immediate priority is to establish whether cable measurements contain sufficient independent information to estimate a simplified rigid-body state accurately.

Once the measurement principle, cable geometry, and sensing accuracy are validated, the system can be extended toward deformation measurement and balloon shape reconstruction.

**Next research question:**

> How should the initial rigid-body sensing objective be defined so that cable number and attachment geometry can be evaluated quantitatively?

---
