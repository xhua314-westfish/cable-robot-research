# Prototype V1 — Mechanical Design Concept

**Version:** 1.0  
**Date:** 2026-11-18  
**Project:** Cable-Robot-Based Sensing for a Passive Balloon  
**Status:** Preliminary Mechanical Concept — Not Yet Experimentally Validated  
**Current Phase:** Pre-Prototype Design Finalisation  
**Related Plan:** `08_Project_Management/November/Prototype_V1_Build_and_Validation_Plan.md`

---

## 1. Purpose

This document defines the preliminary mechanical architecture of Prototype V1 and the engineering assumptions required to translate the existing six-cable sensing configurations into a physically implementable test rig.

The design should support:

1. Practical installation of six cable guides and attachment connectors.
2. Interference-free motion within a defined experimental operating region.
3. Accurate and repeatable cable-length measurement.
4. Geometric feasibility and low-tension passive tracking.

The objective is not to reproduce a conventional actively controlled cable-driven parallel robot (CDPR).

The prototype is intended to measure passive motion while minimising disturbance to the moving object.

This document records the mechanical concept, not a final approved CAD design or manufacturing specification.

---

## 2. Prototype Architecture

### 2.1 Selected Architecture — Single Physical Frame

**Preferred concept:** A single aluminium extrusion frame supporting six independently mounted cable guides.

The motor/winch assemblies do not have to be installed directly at the effective cable exit locations.

Instead, the system is divided into three mechanical functions:

| Subsystem | Primary Function |
|---|---|
| Physical frame | Provide structural support and mounting locations |
| Cable guide | Route the cable into the sensing workspace |
| Motor / winch / sensing module | Maintain suitable cable tension and measure cable displacement |

The preferred physical frame material is **3030 aluminium extrusion**, subject to final structural and assembly verification.

A larger double-boundary frame is not currently selected.

Local brackets or offset mounts may still be used when required.

### 2.2 Why a Single-Frame Architecture?

The current preference is based on:

- Reduced structural complexity.
- Shorter potential guide mounting offsets.
- Fewer structural components.
- Easier access for assembly and calibration.
- Lower expected fabrication effort.
- Compatibility with standard T-slot mounting hardware.
- The possibility of external motor and winch placement.

These are preliminary engineering advantages rather than experimentally proven superiority over a double-boundary design.

A single frame must still accommodate the full physical envelope of guides, cables, connectors and mounting hardware.

---

## 3. Computational Geometry and Physical Frame

### 3.1 Existing Computational Model

The current engineering boundary is:

\[
L_x=280\ \mathrm{mm}
\]

\[
L_y=300\ \mathrm{mm}
\]

\[
L_z=320\ \mathrm{mm}
\]

The coordinate convention is:

- X: length.
- Y: width.
- Z: height.

The nominal spherical end-effector has:

\[
V_b=550\ \mathrm{mL}
\]

\[
r_b=50.8266\ \mathrm{mm}
\]

The original anchor candidates are constrained to the twelve edges of the computational rectangular boundary.

### 3.2 Physical Frame Interpretation

The computational boundary and physical aluminium extrusion are different geometric representations.

The computational model defines ideal cable exit locations.

The physical model must include:

- Aluminium extrusion cross-sections.
- Corner connectors.
- T-slot nuts and mounting screws.
- Cable guide brackets.
- Pulley and bearing assemblies.
- Cable routing paths.
- External winch and motor modules.

**The computational boundary must not be treated automatically as either the extrusion centreline dimensions or the final external dimensions of the physical frame.**

For preliminary CAD evaluation, a 30 × 30 mm extrusion envelope may be positioned outside the computational edge reference.

One previous reference arrangement placed the extrusion centre 15 mm outward along each of the two fixed directions of a rectangular edge.

In this simplified arrangement:

\[
\|M_i-A_i\|=\sqrt{15^2+15^2}
\]

\[
\|M_i-A_i\|=21.213\ \mathrm{mm}
\]

This value represents the distance between two idealised reference points.

It is **not** a validated guide bracket length, pulley offset or required cable path length.

The exact frame dimensions and extrusion assembly must be established through physical CAD modelling.

### 3.3 Frame Geometry Validation

Before manufacturing, the CAD model must verify:

1. The aluminium profiles form the required frame.
2. Corner connectors and mounting brackets do not block cable routes.
3. Each cable guide has sufficient installation space.
4. The six cable guides can reach their specified effective exit geometry.
5. The required balloon movement region remains unobstructed.
6. The frame provides sufficient stiffness for the intended measurement accuracy.

The 3030 frame is the current preferred design baseline, not a completed structural validation result.

---

## 4. Effective Anchor and Cable Guide Geometry

### 4.1 Distinguishing Three Positions

Each cable assembly has three potentially different reference positions.

**Effective anchor \(A_i\)**

The position used in the cable-length sensing model.

**Mechanical mounting reference \(M_i\)**

The position where the guide bracket attaches to the frame.

**Pulley centre \(C_i\)**

The rotational centre of the guide pulley, if a pulley is used.

In general:

\[
A_i\neq M_i\neq C_i
\]

The final design must not assume these points coincide.

### 4.2 Current Ideal Cable-Length Model

For cable \(i\):

\[
B_i(q)=P+Rr_i
\]

\[
L_i(q)=\|A_i-B_i(q)\|
\]

where:

- \(P\): balloon centre in world coordinates.
- \(R\): body-to-world rotation.
- \(r_i\): corresponding body-frame attachment point.
- \(A_i\): ideal effective cable exit position.
- \(B_i\): world-frame attachment position.

This is an ideal straight-segment model.

### 4.3 Actual Pulley-Based Cable Length

A physical pulley can introduce:

- A direction-dependent tangent location.
- A cable wrap arc.
- Guide bearing friction.
- Possible out-of-plane cable motion.
- Additional routing length.
- Mechanical deflection.

Consequently, the measured total cable length may not be represented exactly by the ideal straight-line equation.

A more realistic model may require:

\[
L_{i,\mathrm{total}}(q)=
L_{i,\mathrm{free}}(q)+
L_{i,\mathrm{wrap}}(q)+
L_{i,\mathrm{routing}}(q)
\]

The specific expressions depend on the selected guide architecture.

Fixed routing lengths may be removed by initial calibration when appropriate.

Motion-dependent tangent, wrap and deformation effects require further investigation.

### 4.4 Design Requirement

The physical guide system must provide a known or calibratable relationship between balloon motion and measured cable displacement.

Preserving the original mathematical anchor coordinates is desirable, but it is not sufficient by itself.

The actual cable-length model must remain valid over the intended experimental motion region.

---

## 5. Findings from M1.1–M1.4

### 5.1 M1.1 — Single-Frame Anchor Mapping

The twelve computational rails were mapped to a simplified 3030 frame reference.

For the adopted reference offset, all 24 anchor instances across four candidate configurations had a theoretical reference span of 21.213 mm.

This confirmed coordinate consistency within the simplified model.

It did not confirm physical guide feasibility.

### 5.2 M1.2 — Simplified Profile Occupancy

The centre-to-anchor reference segments intersected the solid extrusion envelopes for all 24 anchor instances.

This occurred because of the defined centreline and inner-corner geometry.

It must not be interpreted as evidence that all 24 physical anchors are impossible to install.

Two specific rail-end mounting concerns were identified:

- C4-1 E2 M, Cable 2.
- C12 E2 M, Cable 6.

### 5.3 M1.3 — Fixed-Plane Cable Direction Analysis

Cable directions were evaluated over 539 development poses.

The largest out-of-plane deviation under least-squares fixed-plane fitting was:

| Configuration | Largest Out-of-Plane Deviation |
|---|---:|
| C2-2 Repaired M | 11.046° |
| C4-1 E2 M | 11.720° |
| C8-16 E2 M | 11.671° |
| C12 E2 M | 12.121° |

These values indicate substantial three-dimensional direction variation.

They are not measured pulley friction or certified out-of-plane operating limits.

### 5.4 M1.4 — Local Direction Envelopes

The maximum local angular ranges over the 539 development poses were:

| Configuration | Largest Yaw Range | Largest Pitch Range | Maximum Reference Cone Angle |
|---|---:|---:|---:|
| C2-2 Repaired M | 19.411° | 20.585° | 11.713° |
| C4-1 E2 M | 22.443° | 21.994° | 12.745° |
| C8-16 E2 M | 21.107° | 23.443° | 12.716° |
| C12 E2 M | 21.658° | 24.079° | 12.694° |

These are direction envelopes in local mathematical coordinates.

They are not directly equivalent to physical swivel-joint angles.

### 5.5 Mechanical Implication

A conventional fixed single-groove pulley should not be assumed suitable for all required cable directions.

The leading guide options for experimental comparison are:

1. A fixed low-friction eyelet.
2. A compact swivel or panning pulley.

The appropriate solution must be selected based on actual motion, friction, mechanical clearance and cable-length measurement performance.

---

## 6. Current Configuration Mounting Issues

Four E2 configurations remain available for prototype development.

### 6.1 C4-1 E2 M — Provisional Primary

The main mechanical issue is Cable 2:

\[
A_2=(140,150,-160)\ \mathrm{mm}
\]

Rail ID: 6.

Normalised rail position:

\[
t_2=1
\]

The anchor lies at the endpoint of its assigned rail.

This may require:

- A corner-specific guide bracket.
- An offset guide arrangement.
- A small inward movement along Rail 6.

A targeted inward anchor-position study is planned.

Candidate adjustments include 10, 20, 25 and 30 mm.

These positions have not yet been accepted as feasible revised configurations.

### 6.2 C12 E2 M — Provisional Backup

The main mounting issue is Cable 6:

\[
A_6=(140,-140,-160)\ \mathrm{mm}
\]

Rail ID: 10.

The anchor is 10 mm from the nearest rail endpoint.

Potential solutions include:

- A compact offset guide.
- A custom bracket.
- A small inward movement along Rail 10.

Candidate inward adjustments include 5, 10, 15 and 20 mm.

The C1–C5 attachment chord distance also requires verification against actual connector geometry.

### 6.3 C8-16 E2 M — Alternative

All six anchors have relatively convenient rail-end distances.

However, the nominal minimum balloon outward cable departure angle is small.

The physical guide arrangement does not automatically eliminate this balloon-surface routing limitation.

### 6.4 C2-2 Repaired M — Sensing Reference

This design has strong simulated sensing performance.

However, it has relatively small nominal cable separation and one failed specified attachment perturbation case.

It remains a numerical reference rather than the first hardware configuration to freeze.

---

## 7. Preliminary One-Cable Module Architecture

### 7.1 Research Purpose

Before replicating six channels, build and experimentally evaluate one adjustable cable measurement module.

The module must demonstrate:

- Practical frame mounting.
- Acceptable cable direction tracking.
- Low mechanical resistance.
- Repeatable cable displacement measurement.
- A calibratable effective cable exit geometry.

### 7.2 Functional Architecture

The proposed functional chain is:

**Frame → Guide Bracket → Cable Guide → Free Cable Segment → End-effector Attachment**

The cable then continues through an appropriate routing path to the displacement measurement and/or low-tension tracking mechanism.

The motor and winch may be physically separated from the guide.

### 7.3 Proposed Components

| Component | Function | Current Approach |
|---|---|---|
| Aluminium frame | Structural support | Standard 3030 profile |
| T-slot hardware | Frame mounting | Standard compatible nuts and screws |
| Routing bracket | Guide positioning | Custom 3D-printed part |
| Guide bearing/shaft | Rotation support | Standard components |
| Eyelet | Fixed guide comparison | Commercial component |
| Swivel guide housing | Cable direction adaptation | Custom 3D-printed part |
| Winch drum | Cable take-up | Preliminary custom design |
| Cable | Sensing transmission | Low-stretch flexible line |
| Cable displacement sensing | Measurement | Sensor selection pending |
| Low-tension mechanism | Maintain cable tracking | Motor or alternative mechanism under evaluation |
| Force measurement | Quantify disturbance | Laboratory sensor or suitable low-range sensor |
| Test fixture | Apply known movement | Existing laboratory equipment where possible |

No motor model has yet been selected for the passive sensing system.

---

## 8. Preliminary 3D-Printed Components

The following components should be planned as parametric CAD designs.

### Part 01 — Cable Routing Bracket

**Function**

Attach a guide assembly to the 3030 frame while positioning its functional cable exit geometry.

**Parameters**

- Compatible T-slot mounting dimensions.
- Screw diameter and spacing.
- Bracket thickness.
- Guide position relative to the mounting surface.
- Bearing or eyelet interface.
- Required cable direction clearance.

**Variants**

- Standard edge-mount bracket.
- Corner or offset bracket where required.

**Initial quantity**

One test bracket plus optional alternative prototypes.

### Part 02 — Swivel Pulley Housing

**Function**

Provide a rotatable cable guide with sufficient angular freedom.

**Parameters**

- Pulley outside diameter.
- Pulley groove geometry.
- Bearing seat dimensions.
- Shaft diameter.
- Swivel axis position.
- Physical angular limits.
- Cable entry and exit clearance.

The housing must be designed to prevent cable escape or rubbing against the surrounding structure.

### Part 03 — Winch Drum

**Function**

Convert rotational movement into cable take-up or release.

**Parameters**

- Effective winding radius.
- Groove pitch.
- Winding width.
- Cable capacity.
- Shaft coupling.
- Motor compatibility.
- Winding-layer control.

The initial development-set maximum cable stroke across the four configurations is approximately 75.056 mm.

An approximately 90–100 mm usable stroke may be explored as an initial sizing assumption.

This is not the final required stroke for the complete physical operating region.

### Part 04 — Rigid Sphere Attachment Interface

**Function**

Secure the six cables to a nominal spherical end-effector at known coordinates.

**Parameters**

- Sphere radius: 50.8266 mm.
- Attachment positions from the selected final E2 design.
- Connector footprint.
- Local attachment protrusion.
- Screw or insert geometry.
- Cable connection direction.
- Surface clearance.

The initial rigid sphere may incorporate screw-mounted connectors.

Flexible-balloon interfaces will be developed separately.

---

## 9. Cable Attachment Strategy

### 9.1 Rigid Sphere

The initial six-cable sensing experiment should use a rigid spherical substitute.

Possible attachment methods include:

- Embedded threaded inserts.
- Through-bolted lightweight eyelets.
- Removable attachment brackets.
- Printed bosses with verified mechanical strength.

The physical attachment locations must be measured and incorporated into calibration.

### 9.2 Flexible Balloon

Flexible balloon attachment is more challenging because the surface may deform, slip or leak.

Potential laboratory research directions include:

- Flexible reinforcement patches.
- Lightweight bonding interfaces.
- Material-compatible adhesive systems.
- Distributed load-transfer areas.

Direct screw attachment through a thin inflatable membrane is not assumed acceptable.

Adhesives and attachment methods must be tested for material compatibility, local deformation, sealing and mechanical reliability.

A provisional air-filled balloon experiment does not demonstrate compatibility with a liquid-filled silicone intragastric balloon.

---

## 10. Motor, Winch and Cable Selection

### 10.1 External Prototype Reference

Jingjun Liu reported using:

- 3030 aluminium extrusion.
- Custom 3D-printed routing parts and winches.
- Feetech SM45BL servo motors.
- No.10 PE fishing line.
- T-slot mounting hardware.

The motor was reported to have limited back-drivability.

Therefore, it is not currently selected as the motor for this passive measurement system.

### 10.2 Selection Requirements

The final mechanism must be evaluated for:

- Low-tension tracking capability.
- Back-drivability or controlled take-up response.
- Cable slack prevention.
- Measurement resolution and repeatability.
- Available cable stroke.
- Friction and hysteresis.
- Cable stretch.
- Drum radius variation and winding behaviour.
- Mechanical size and mounting.
- Electrical integration and cost.

### 10.3 Measurement and Actuation Separation

Cable actuation and cable-length measurement do not necessarily have to use the same mechanical component.

Possible arrangements include:

- Motor encoder-based length estimation.
- Independent cable displacement measurement.
- A combined system with calibration.

The final selection should be based on actual measurement performance, not motor positioning resolution alone.

---

## 11. Mechanical and Measurement Verification Plan

Before approving a guide architecture for six-channel replication, one module must be tested.

### Test A — Guide Direction Capability

Evaluate cable movement over representative two-axis direction variations.

Use the M1.4 directional envelopes as preliminary inputs.

Record:

- Motion range.
- Sticking or binding.
- Cable rubbing.
- Possible cable escape.
- Interference with mounting hardware.

### Test B — Low-Tension Friction

Measure the additional force required to move the cable through the guide.

Compare:

- Static starting resistance.
- Running resistance.
- Direction reversal effects.
- Behaviour at different low pretension levels.

### Test C — Cable Displacement Measurement

Apply known cable displacements and compare measured values.

Evaluate:

- Resolution.
- Repeatability.
- Hysteresis.
- Direction-dependent bias.
- Calibration consistency.

### Test D — Effective Anchor Calibration

Determine the physical guide geometry and its relationship to the mathematical anchor.

Evaluate whether:

- A fixed effective anchor is an adequate model.
- A motion-dependent pulley model is required.
- Calibration reduces systematic length errors.

No specific friction or accuracy acceptance value is currently claimed as experimentally validated.

Formal limits must be established from the sensing requirements and available measurement equipment.

---

## 12. Physical Interference Requirements

The final mechanical verification must evaluate:

1. Cable–cable clearance.
2. Cable–sphere clearance.
3. Cable–frame clearance.
4. Cable–guide clearance.
5. Guide–guide clearance.
6. Connector–connector clearance.
7. Cable routing near corners and mounting brackets.

Existing numerical distances refer to ideal geometric cable paths.

They do not automatically include physical cable diameter, connectors or guide structures.

Continuous-motion checking must be performed for a declared experimental operating region.

A 539-pose pass count is not equivalent to continuous-workspace certification.

---

## 13. CAD Development Strategy

The CAD model should be developed progressively.

### CAD Stage A — Single-Cable Test Assembly

Include:

- One 3030 extrusion.
- One T-slot mounting bracket.
- One interchangeable guide.
- One cable.
- An external displacement/actuation module envelope.

Use parametric dimensions where practical.

### CAD Stage B — Selected Six-Cable Layout

Import the final selected:

- Six anchor coordinates.
- Six paired attachment coordinates.
- Cable numbering.
- Rail references.
- Balloon geometry.

Locate the actual guide mounting positions and check component envelopes.

### CAD Stage C — Full Prototype Assembly

Include:

- Complete aluminium frame.
- All six guides.
- Motors or tensioning mechanisms.
- Cable-length sensors.
- Rigid sphere.
- Attachment connectors.
- Fasteners and wiring envelopes.

The final frame should not be manufactured from the preliminary centreline-only model.

---

## 14. Immediate Mechanical Decisions

The following design decisions remain pending.

| Decision | Current Preferred Direction | Required Evidence |
|---|---|---|
| Frame architecture | Single 3030 frame | Final CAD clearance and stiffness |
| Primary six-cable layout | C4-1 E2 M | Targeted anchor refinement and interference screening |
| Backup layout | C12 E2 M | Targeted anchor refinement and connector clearance |
| Cable guide | Swivel pulley under evaluation | Low-friction and angular-range tests |
| Comparison guide | Fixed eyelet | Experimental friction and measurement results |
| Motor | Not selected | Low-tension and measurement requirements |
| Winch | Parametric custom design | Stroke, winding and motor interface |
| Initial end-effector | Rigid spherical surrogate | Attachment geometry and experimental calibration |
| Flexible attachment | Undecided | Material and mechanical testing |

---

## 15. Relationship to Prototype Build Plan

This document provides technical mechanical design context.

The execution order and completion requirements are defined in:

`08_Project_Management/November/Prototype_V1_Build_and_Validation_Plan.md`

Current priorities:

**P0.1 — Targeted Anchor Refinement**

Determine whether small local adjustments can improve the mounting feasibility of C4-1 Cable 2 and C12 Cable 6.

**P0.2 — Continuous Motion Interference Screening**

Define the initial experimental motion region and assess ideal cable interference throughout relevant trajectories.

**P0.3 — Provisional Configuration Freeze**

Choose the primary and backup numerical configurations.

**P0.4 — Single-Cable CAD and BOM**

Prepare the mechanical concept, purchased-part specifications and printable components.

**P0.5 — Funding Approval**

Present the simulation evidence and experimental requirements to the supervisor.

Physical assembly begins only after the necessary equipment and fabrication resources are available.

---

## 16. Current Engineering Conclusion

The current six-cable numerical configurations provide a viable basis for physical prototype investigation, but they are not yet mechanically validated.

The preferred engineering strategy is:

**Single aluminium frame → Calibratable cable guides → Low-tension length measurement → Six-cable rigid-body prototype → Flexible balloon pilot**

The most important next action is to address the remaining anchor installation issues and continuous-motion interference risks.

Mechanical design should preserve useful sensing geometry where practical, but the final prototype must be evaluated using actual guide positions, mounting dimensions, cable paths and measured performance.

The objective is a practical, experimentally testable sensing system rather than an indefinitely optimised theoretical configuration.

---

**Current status:** Mechanical concept documented; detailed CAD, procurement, fabrication and physical validation remain pending.
