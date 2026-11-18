# Prototype V1 — Procurement and Preliminary Bill of Materials

**Version:** 1.0  
**Date:** 2026-11-18  
**Project:** Cable-Robot-Based Sensing for a Passive Balloon  
**Status:** Preliminary BOM — Specifications and Prices Not Yet Finalised  
**Current Phase:** P0 — Pre-Prototype Design and Funding Preparation

**Related Documents:**

- `08_Project_Management/November/Prototype_V1_Build_and_Validation_Plan.md`
- `05_My_Research/Prototype_V1_Mechanical_Design_Concept.md`
- `CURRENT_STATE2.md`

---

## 1. Purpose

This document identifies the preliminary materials, purchased components, custom-manufactured parts and experimental equipment required to develop the six-cable sensing prototype.

Its main purposes are to:

1. Support the initial funding request.
2. Distinguish purchased parts from 3D-printed components.
3. Identify equipment that may already be available in the laboratory.
4. Support the design and assembly of one cable measurement module.
5. Define a staged procurement strategy for the complete six-cable prototype.
6. Avoid purchasing unsuitable motors, sensors or mechanical components before their requirements have been verified.

This is a planning BOM, not an approved purchasing list.

No final product models, unit prices or suppliers have been confirmed.

---

## 2. Procurement Strategy

The prototype will be developed in two procurement phases.

### Phase A — One-Cable Module

**Priority: High**

Build one adjustable cable measurement module to investigate:

- Cable guide alignment.
- Three-dimensional cable direction changes.
- Guide friction and hysteresis.
- Cable displacement measurement accuracy.
- Low-tension cable tracking.
- Effective anchor calibration.

The initial module should be reconfigurable and use replaceable components.

The purpose is to validate the mechanical and sensing principles before committing to six identical modules.

### Phase B — Six-Cable Prototype

**Priority: Conditional**

After Phase A testing:

- Select the guide architecture.
- Select suitable cable measurement hardware.
- Determine the tensioning method.
- Finalise the physical frame dimensions.
- Manufacture six guide assemblies.
- Integrate the rigid spherical end-effector.
- Build and calibrate the complete six-cable system.

Phase B should not begin solely because the Phase A components have been assembled.

The critical mechanical and sensing measurements must first be reviewed.

---

## 3. Phase A — One-Cable Module BOM

### 3.1 Structural and Mounting Components

| ID | Component | Preliminary Quantity | Source | Status |
|---|---|---:|---|---|
| A-M01 | 3030 aluminium extrusion | 1–2 short sections | Purchase or lab inventory | Required |
| A-M02 | Compatible T-slot nuts | 1 small pack | Purchase or lab inventory | Required |
| A-M03 | Compatible machine screws | 1 small pack | Purchase or lab inventory | Required |
| A-M04 | Aluminium corner brackets / mounting plates | 2–4 | Purchase or lab inventory | Required |
| A-M05 | Adjustable experimental support plate | 1 | Lab inventory or fabrication | Preferred |
| A-M06 | Cable guide mounting bracket | 1–3 prototypes | 3D print | Required |
| A-M07 | Guide adjustment and alignment hardware | 1 set | Purchase / fabricate | Required |

The exact T-slot hardware must be compatible with the selected 3030 extrusion system.

Profile slot geometry and fastening standards must be checked before ordering.

### 3.2 Cable Guide Components

| ID | Component | Preliminary Quantity | Source | Status |
|---|---|---:|---|---|
| A-G01 | Small ceramic or other low-friction eyelet | 1–2 | Purchase | Comparison component |
| A-G02 | Pulley wheel or pulley assembly | 1–2 | Purchase / fabricate | Candidate |
| A-G03 | Small ball bearings | 2–4 | Purchase | Candidate |
| A-G04 | Pulley shaft / axle | 1–2 | Purchase / fabricate | Candidate |
| A-G05 | Swivel pivot bearing or bushing | 1–2 | Purchase | Candidate |
| A-G06 | Swivel pulley housing | 1–3 versions | 3D print | Candidate |
| A-G07 | Shaft retainers / washers / spacers | 1 set | Purchase | Required for pulley trials |
| A-G08 | Mechanical stops or guards | As needed | 3D print | To be designed |

Two guide concepts will be compared:

1. Fixed low-friction eyelet.
2. Swivel or panning pulley.

The pulley configuration is not final.

### 3.3 Cable and Termination Components

| ID | Component | Preliminary Quantity | Source | Status |
|---|---|---:|---|---|
| A-C01 | Low-stretch flexible cable | 1 spool | Purchase | Required |
| A-C02 | Cable termination accessories | 1 small set | Purchase / fabricate | Required |
| A-C03 | Lightweight cable connection loops | 2–4 | Purchase / fabricate | Required |
| A-C04 | Spare cable material | Allowance | Same spool | Required |
| A-C05 | Cable diameter measurement tool | 1 | Lab inventory | Preferred |

A PE fishing line similar to that used in an existing laboratory prototype is a possible starting point.

However, its actual diameter, stiffness, elongation, creep, minimum bending radius and termination reliability require verification.

The exact cable specification will be selected based on measured performance.

### 3.4 Cable-Length Measurement

| ID | Component | Preliminary Quantity | Source | Status |
|---|---|---:|---|---|
| A-S01 | Cable displacement sensor / encoder | 1 | Purchase or lab inventory | Required |
| A-S02 | Sensor mounting bracket | 1 | 3D print / fabricate | Required |
| A-S03 | Encoder interface electronics | 1 | Purchase / lab inventory | Conditional |
| A-S04 | Calibrated displacement reference | 1 | Borrow / purchase | Required for validation |
| A-S05 | Measurement data acquisition interface | 1 | Borrow / purchase | Required |

Potential sensing architectures include:

- Rotary encoder with a defined measurement pulley.
- Independent cable displacement sensor.
- Motor encoder with suitable mechanical calibration.
- Combined actuation and independent sensing.

Motor shaft rotation must not automatically be interpreted as accurate cable displacement.

Winding radius variation, backlash, elasticity and slip may affect the measurement.

The final sensor architecture will be selected following a resolution, accuracy and calibration assessment.

### 3.5 Tension Measurement and Tracking

| ID | Component | Preliminary Quantity | Source | Status |
|---|---|---:|---|---|
| A-T01 | Low-range force sensor / load cell | 1 | Borrow or purchase | Required |
| A-T02 | Force sensor signal conditioning | 1 | Purchase / lab inventory | Conditional |
| A-T03 | Passive tensioning components | 1 small set | Purchase / fabricate | Comparison option |
| A-T04 | Candidate motor | 1 | Purchase after sizing | Pending |
| A-T05 | Compatible motor driver | 1 | Purchase after motor selection | Pending |
| A-T06 | Suitable power supply | 1 | Lab inventory / purchase | Conditional |
| A-T07 | Motor mounting bracket | 1 | 3D print / fabricate | Conditional |
| A-T08 | Winch drum | 1–3 prototypes | 3D print | Conditional |

The motor is used to follow passive cable displacement and maintain suitable low positive tension.

It must not intentionally command balloon motion.

Candidate motor selection must consider:

- Required tracking speed.
- Cable tension range.
- Torque and friction.
- Back-drivability.
- Closed-loop response.
- Sensor integration.
- Power and safety.
- Mechanical packaging.

The Feetech SM45BL is a reference from an external prototype, not an approved purchase for this system.

A passive spring-based or otherwise low-resistance tensioning arrangement should also be considered before committing to motor-assisted tracking.

### 3.6 Experimental Measurement Equipment

| ID | Equipment | Preliminary Quantity | Preferred Source |
|---|---|---:|---|
| A-E01 | Calibrated linear movement stage / displacement fixture | 1 | Laboratory |
| A-E02 | Digital caliper | 1 | Laboratory |
| A-E03 | Suitable low-range force reference | 1 | Laboratory |
| A-E04 | Multimeter | 1 | Laboratory |
| A-E05 | Computer with MATLAB | 1 | Existing |
| A-E06 | Basic hand tools | 1 set | Laboratory |
| A-E07 | 3D printer access | As required | University workshop |
| A-E08 | Experimental safety guards | As required | Lab / fabrication |

Borrowing existing laboratory equipment is preferred whenever it meets the measurement requirements.

---

## 4. Phase A — Custom 3D-Printed Parts

### Part P01 — Standard Cable Routing Bracket

**Function:** Mount a cable guide to a 3030 extrusion.

**Design requirements:**

- Compatible with the selected T-slot system.
- Adjustable guide positioning.
- Removable guide interface.
- Sufficient rigidity under the expected loading.
- No unintended cable contact with the bracket.
- Easy installation and replacement.

**CAD parameters:**

- Mounting hole diameter.
- Mounting hole spacing.
- Guide offset.
- Bracket thickness.
- Cable clearance.
- Fastener access.

**Initial quantity:** 1–2 prototypes.

### Part P02 — Corner / Offset Routing Bracket

**Function:** Investigate guide installation near rail endpoints.

This part is particularly relevant to:

- C4-1 E2 M, Cable 2.
- C12 E2 M, Cable 6.

The part should only be dimensioned after targeted anchor refinement and physical mounting review.

**Initial quantity:** 1 prototype if required.

### Part P03 — Swivel Pulley Housing

**Function:** Accommodate a rotating guide assembly.

**Design requirements:**

- Appropriate bearing seating.
- Swivel movement.
- Suitable wheel alignment.
- Cable retention.
- Physical stops or guarding where required.
- Replaceable pulley and shaft components.

**Initial quantity:** 1–3 experimental versions.

### Part P04 — Winch Drum

**Function:** Provide cable take-up or release.

**Design parameters:**

- Effective drum radius.
- Winding width.
- Groove geometry.
- Cable diameter.
- Shaft coupling.
- Available travel.
- Prevention of uncontrolled multiple-layer winding.

**Initial quantity:** 1 experimental version, if motor/winch testing is selected.

### Part P05 — Sensor and Motor Brackets

**Function:** Secure selected measurement or actuation hardware.

These parts must be designed around the actual sensor and motor models.

**Initial quantity:** As required.

---

## 5. Current Cable Travel Reference

The maximum sampled cable-length strokes from the existing 539-pose development study are:

| Configuration | Maximum Sampled Stroke |
|---|---:|
| C2-2 Repaired M | 72.505 mm |
| C4-1 E2 M | 75.056 mm |
| C8-16 E2 M | 74.887 mm |
| C12 E2 M | 73.872 mm |

An initial usable-travel design exploration of approximately 90–100 mm may be considered for the one-cable module.

This is not yet a verified final travel requirement.

Final travel must account for:

- The declared prototype motion domain.
- The selected guide geometry.
- Cable routing.
- Calibration travel.
- Mechanical reserves.
- Possible changes after targeted anchor refinement.

The maximum sampled stroke must not be confused with required total cable storage length.

---

## 6. Phase B — Six-Cable Prototype BOM

This phase is conditional on the outcome of Phase A.

### 6.1 Full Frame

| ID | Component | Preliminary Quantity | Status |
|---|---|---:|---|
| B-F01 | 3030 aluminium extrusion | 12 frame edges or equivalent cut-list | Pending CAD |
| B-F02 | Frame corner connectors | As required | Pending CAD |
| B-F03 | T-slot nuts | Assembly allowance | Pending CAD |
| B-F04 | Screws, washers and fasteners | Assembly allowance | Pending CAD |
| B-F05 | Feet / base supports | As required | Pending CAD |
| B-F06 | Cable guide mounting plates | 6 mounting locations | Pending CAD |

The frame concept is based on the 280 × 300 × 320 mm computational boundary.

The exact extrusion cut lengths and external frame dimensions require CAD verification.

No final frame dimensions should be ordered using the simplified mathematical boundary alone.

### 6.2 Six Cable Measurement Channels

| ID | Component | Target Quantity | Status |
|---|---|---:|---|
| B-C01 | Cable guide modules | 6 + spare allowance | Conditional |
| B-C02 | Cable lines | 6 + spare allowance | Conditional |
| B-C03 | Cable displacement measurement channels | 6 | Conditional |
| B-C04 | Cable tension tracking modules | 6 | Conditional |
| B-C05 | Force measurement channels | To be determined | Optional / experiment-dependent |
| B-C06 | Motor driver channels | Up to 6 if motor-assisted tracking selected | Conditional |
| B-C07 | Common controller / data acquisition | 1 system | Conditional |
| B-C08 | Power distribution and safety hardware | 1 system | Conditional |

Six independent motor units must not be purchased before the tracking architecture is selected.

### 6.3 Rigid End-Effector

| ID | Component | Preliminary Quantity | Status |
|---|---|---:|---|
| B-R01 | Rigid spherical end-effector | 1 + optional spare | 3D print / fabricate |
| B-R02 | Six attachment connectors | 6 + spare allowance | Design pending |
| B-R03 | Mechanical inserts / fasteners | As required | Design pending |
| B-R04 | Ground-truth tracking markers | As required | Measurement-system dependent |

The rigid-sphere equivalent radius is 50.8266 mm.

Attachment coordinates must be imported from the final selected configuration.

The end-effector must be designed to minimise unintended connector protrusion and attachment positioning errors.

### 6.4 Ground-Truth Measurement

Potential approaches include:

- Existing optical motion capture.
- Calibrated multi-camera tracking.
- An independently measured reference fixture.
- Other suitable laboratory pose measurement systems.

The selected method must provide an independent reference for position and orientation.

The availability and accuracy of existing university equipment must be investigated before procurement.

---

## 7. Flexible Balloon Extension — Prototype V1.1

The flexible-balloon phase should not delay completion of the six-cable rigid prototype.

Preliminary additional materials may include:

| ID | Component | Purpose |
|---|---|---|
| F-01 | Air-filled balloon test objects | Initial flexible behaviour study |
| F-02 | Flexible reinforcement patches | Cable load distribution |
| F-03 | Lightweight attachment tabs | Cable connection |
| F-04 | Material-compatible bonding materials | Attachment testing |
| F-05 | Inflation and pressure measurement tools | Balloon condition monitoring |
| F-06 | Silicone test materials | Future liquid-filled model investigation |

Attachment methods must be tested for:

- Adhesion.
- Slippage.
- Leakage.
- Local deformation.
- Material compatibility.
- Added mass and stiffness.
- Repeated loading performance.

Hot-melt glue and tape must not be assumed to provide a reliable final solution.

These investigations concern laboratory models and do not establish clinical implant compatibility.

---

## 8. Initial 3D Printing Strategy

Use a parametric CAD approach wherever practical.

The first printed components should be:

1. Standard cable routing bracket.
2. Interchangeable guide interface.
3. Swivel pulley housing.
4. Optional corner/offset bracket.
5. Sensor or winch bracket, once hardware interfaces are known.

The rigid spherical end-effector can be developed in parallel with the six-cable layout.

### Material Selection

PLA may be suitable for initial fit checks and noncritical geometry prototypes.

More durable engineering printing materials may be considered for functional brackets, subject to printer availability, operating conditions and mechanical testing.

Printed components carrying cable loads or supporting bearings require appropriate mechanical verification.

### Design Verification

Before printing:

- Check interface dimensions.
- Check screw and nut access.
- Check pulley/bearing seats.
- Check cable clearance.
- Check printed wall thickness.
- Check assembly orientation.
- Check replacement and maintenance accessibility.

---

## 9. Experimental Performance Requirements Before Final Component Selection

The following quantities must be defined or measured before the final hardware BOM is approved.

| Requirement | Current Status | Planned Source |
|---|---|---|
| Actual cable diameter | Unknown | Supplier data and measurement |
| Cable stretch and creep | Unknown | Supplier data / test |
| Operating tension range | Not established | Low-tension experiments |
| Peak cable tracking speed | Not established | Required motion specification |
| Cable displacement range | Preliminary sampled data available | P0/P1 |
| Required length measurement accuracy | Not finalised | Sensing error budget |
| Encoder resolution | Not selected | Sensor comparison |
| Guide friction and hysteresis | Unknown | Phase A experiments |
| Pulley bending radius | Not selected | Cable and pulley compatibility |
| Winch winding accuracy | Unknown | Phase A experiments |
| Motor torque and speed | Not selected | Tension and motion sizing |
| Attachment connector dimensions | Not selected | CAD development |
| Physical clearance margin | Not established | CAD and interference testing |
| Ground-truth measurement accuracy | Not established | Laboratory equipment review |

The initial simulated cable-length noise standard deviation of 0.100 mm is a modelling assumption, not a measured hardware sensor specification.

---

## 10. Preliminary Budget Worksheet

All amounts are to be entered in NZD after collecting supplier quotations.

### Phase A — Initial Funding Request

| Category | Estimated Cost (NZD) | Quotation Status |
|---|---:|---|
| Aluminium profile and mounting hardware | TBD | Not quoted |
| Cable and termination materials | TBD | Not quoted |
| Eyelet and swivel guide components | TBD | Not quoted |
| Bearings and shafts | TBD | Not quoted |
| Cable displacement measurement | TBD | Not quoted |
| Low-range force measurement | TBD | Check lab inventory |
| Motor and driver, if required | TBD | Specification pending |
| 3D printing and fabrication | TBD | Workshop estimate pending |
| Experimental fixtures | TBD | Check lab inventory |
| Shipping, tax and contingency | TBD | Not calculated |
| **Phase A Total** | **TBD** | **Not approved** |

### Phase B — Full Prototype

| Category | Estimated Cost (NZD) | Quotation Status |
|---|---:|---|
| Complete 3030 frame | TBD | CAD pending |
| Remaining five cable guide modules | TBD | Phase A dependent |
| Six-channel cable measurement system | TBD | Architecture pending |
| Low-tension tracking system | TBD | Architecture pending |
| Controller and electronics | TBD | Architecture pending |
| Rigid end-effector fabrication | TBD | CAD pending |
| Ground-truth measurement resources | TBD | Lab inventory check |
| Spare components and maintenance | TBD | Pending |
| Shipping, tax and contingency | TBD | Not calculated |
| **Phase B Total** | **TBD** | **Not approved** |

Do not present placeholder amounts as final quotations.

---

## 11. Supplier and Procurement Review

Potential supplier categories include:

- Local aluminium extrusion and fastening suppliers.
- Bearing and mechanical component suppliers.
- Electronics and encoder distributors.
- University mechanical workshops.
- University 3D printing facilities.
- Laboratory equipment suppliers.

Before selecting a supplier, record:

- Exact manufacturer and part number.
- Technical data sheet.
- Unit price.
- Quantity.
- Availability.
- Delivery estimate.
- Compatibility with existing components.
- Warranty or replacement policy, where relevant.

Preference should be given to reusable components and standard interfaces where possible.

---

## 12. Funding Request Justification

The current project has completed structured configuration development and initial six-degree-of-freedom sensing simulations.

Four final numerical configurations have been retained.

C4-1 E2 M is the provisional primary design, with C12 E2 M as the provisional backup.

However, further theoretical optimisation alone cannot establish the real performance of:

- Cable guide friction.
- Passive low-tension tracking.
- Cable-length sensing accuracy.
- Physical mounting.
- Mechanical calibration.

These uncertainties require experimental measurements.

The first funding request should therefore support a single-cable experimental module.

**Proposed funding rationale:**

> The initial hardware investment will validate the fundamental cable routing and length-measurement mechanisms before the design is replicated into a six-cable sensing prototype. This staged approach reduces procurement risk and provides experimental evidence for the final mechanical and sensing architecture.

---

## 13. Procurement Approval Gates

### Gate A — Before Initial Purchasing

Required:

- P0.1 targeted anchor refinement outcome.
- P0.2 motion interference screening record.
- Initial mechanical concept.
- Available laboratory equipment inventory.
- Selected Phase A experiment scope.
- Preliminary quotations.
- Supervisor approval.

The purpose is to ensure the initial order is justified and supports a specific experiment.

### Gate B — Before Full Six-Cable Purchasing

Required:

- One-cable guide functionality verified.
- Cable-length measurement performance evaluated.
- Low-tension mechanism selected.
- Physical mounting geometry checked.
- Final module design established.
- Updated six-cable CAD and BOM.
- Supervisor approval for expanded procurement.

### Gate C — Before Full Prototype Acceptance

Required:

- Six cable channels assembled and calibrated.
- Physical interference and safety checks performed.
- Declared operating region documented.
- Independent ground-truth pose experiments completed.
- Position/orientation accuracy and failure cases reported.

---

## 14. Immediate Action Items

Before completing the funding presentation:

1. Complete P0.1 targeted anchor refinement.
2. Complete P0.2 idealised continuous-motion interference screening.
3. Confirm the provisional primary and backup designs.
4. Check available 3030 extrusion, sensors, force measurement equipment and 3D printing facilities.
5. Prepare a preliminary one-cable CAD assembly.
6. Identify candidate commercial guide and bearing components.
7. Obtain quotations for the highest-priority Phase A components.
8. Prepare the eleven-slide supervisor presentation and funding request.

The full six-cable hardware order should follow the Phase A measurements rather than precede them.

---

## 15. Current Procurement Decision

**Approved purchasing list:** None yet.

**Recommended first procurement scope:** One-cable mechanical and measurement module.

**Preferred fabrication method:** Standard purchased mechanical components combined with replaceable 3D-printed brackets and guide housings.

**Final motor selection:** Pending low-tension tracking requirements.

**Final encoder selection:** Pending measurement requirements.

**Final six-cable frame cut list:** Pending CAD and configuration freeze.

**Next step:** Complete the pre-procurement design checks and obtain supervisor approval for the initial experimental hardware.

---

**Document status:** Preliminary BOM prepared for planning and funding discussion. All component specifications, prices and purchase quantities remain subject to engineering review.
