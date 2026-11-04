
# Workspace Boundary — Engineering Geometry and Historical Evidence

**Version:** 0.3
**Original Date:** 2026-10-20
**Last Updated:** 2026-11-04
**Research Phase:** Phase B — Balloon-Specific Cable Sensing Design
**Geometry Status:** B1 engineering baseline completed; anatomical validation pending.

**Current Engineering Boundary:** 280 × 300 × 320 mm.

**Historical Reference Boundary:** 140 × 150 × 160 mm.

---

## Document Purpose

This document records the geometric assumptions, coordinate conventions and boundary evidence used to define the balloon sensing environment.

It distinguishes three types of information:

1. Literature-reported anatomical measurements.
2. Historical engineering reference scenarios.
3. Current numerical simulation parameters.

The current B1–B4 MATLAB studies use the 280 × 300 × 320 mm engineering boundary.

The earlier 140 × 150 × 160 mm model is retained as a historical reference scenario.

Neither boundary is a clinically validated patient-specific gastric workspace.

Detailed project progress belongs in `CURRENT_STATE2.md`.

---

## 1. Research Purpose and Scope

This document defines the provisional three-dimensional engineering boundary used to investigate cable-based sensing of a passively moving 550 mL rigid spherical balloon.

The initial model focuses on six-degree-of-freedom rigid-body pose sensing.

The simplified gastric boundary is intended to constrain the spatial position of the balloon.

It must not be interpreted as a measured patient-specific gastric lumen or clinically established balloon-motion workspace.

Three concepts must be distinguished:

1. **Gastric boundary:** A simplified geometric envelope derived from literature evidence and engineering assumptions.
2. **Geometrically feasible centre region:** The set of positions where the entire rigid sphere remains inside the selected cavity model.
3. **Cable sensing workspace:** The set of feasible poses satisfying cable geometry, mechanical and measurement-quality requirements.

The cable sensing workspace has not yet been determined.

---

## 2. Coordinate Convention

### 2.1 Selected Engineering Coordinates

The current project uses a right-handed Cartesian engineering coordinate system:

| Axis | Engineering dimension | Meaning |
|---|---|---|
| X | \(L_g\) | Length |
| Y | \(W_g\) | Width |
| Z | \(H_g\) | Height |

Units: millimetres.

The origin is located at the centre of the selected engineering bounding box.

The signs of the engineering axes define the computational model. They must not be interpreted automatically as patient anatomical directions.

### 2.2 Mapping from the Previous Anatomical Convention

The original geometry evidence was organised using:

- Original X: Transverse width.
- Original Y: Anteroposterior depth.
- Original Z: Craniocaudal extent.

For the initial B1 computational model, the axes are rearranged as follows:

| Selected axis | Previous axis | Physical dimension |
|---|---|---|
| New X | Original Z | Craniocaudal extent |
| New Y | Original X | Transverse width |
| New Z | Original Y | Anteroposterior depth |

This is a coordinate permutation.

The physical dimensions are preserved, but their coordinate labels change.

**Important distinction:** The new engineering Z axis is called Height for consistency with the project's current MATLAB convention. In the source evidence, this dimension corresponds to anteroposterior depth, not a clinically measured vertical stomach height.

Similarly, the new engineering X axis refers to a craniocaudal projected span, not the anatomical stomach centreline or greater-curvature length.

Anatomical directions, laboratory gravity and engineering axes must not be conflated.

---


## 3. Boundary Evidence and Engineering Parameters

### 3.1 Literature Evidence

The existing literature review provides anatomical and morphological evidence relevant to stomach geometry.

The historical orthogonal dimension ranges were attributed to Lamart et al. (2013), based on CT data from an adult male cohort.

These data are not direct measurements of the target adult-female population or actual intragastric-balloon motion.

The historical ranges must not be interpreted as:

- Population-wide anatomical limits.
- Validated dimensions for adult women.
- Patient-specific gastric lumen dimensions.
- Clinically measured balloon-motion ranges.
- Cable-robot sensing workspace boundaries.

The supporting literature evidence is maintained in:

`02_Paper_Reading/Literature_Review/workspace definition/Gastric_Boundary_Evidence_Summary_v0.1.md`

### 3.2 Historical Engineering Reference

The original boundary document used:

| Dimension | Historical literature range | Historical engineering candidate range | Historical reference |
|---|---|---|---|
| X — Length | 60–150 mm | 120–170 mm | 140 mm |
| Y — Width | 90–160 mm | 130–160 mm | 150 mm |
| Z — Height | 100–200 mm | 130–180 mm | 160 mm |

These ranges and their interpretation belong to the historical geometry investigation.

The reference box was:

\[
D_{\mathrm{historical}}=
[140,150,160]\ \mathrm{mm}
\]

This model remains useful for understanding the original evidence synthesis and containment calculations.

It is not the current MATLAB engineering baseline.

### 3.3 Current B1 Engineering Baseline

The active numerical model uses:

\[
L_g=280\ \mathrm{mm}
\]

\[
W_g=300\ \mathrm{mm}
\]

\[
H_g=320\ \mathrm{mm}
\]

Therefore:

\[
D_{\mathrm{B1}}=
[280,300,320]\ \mathrm{mm}
\]

| Parameter | Value | Classification |
|---|---:|---|
| X — Length | 280 mm | Engineering assumption |
| Y — Width | 300 mm | Engineering assumption |
| Z — Height | 320 mm | Engineering assumption |
| Balloon volume | 550 mL | Selected nominal reference |
| Balloon equivalent radius | Approximately 50.83 mm | Derived |
| Initial clearance | 0 mm | Numerical modelling assumption |

The engineering dimensions provide a simplified and sufficiently spacious initial environment for testing cable geometry, workspace feasibility and sensing performance.

They were not directly derived as a clinically validated adult-female gastric bounding box.

### 3.4 Parameter Selection and Future Refinement

The active boundary dimensions are fixed across B1–B4 to preserve consistency between numerical experiments.

Future research may investigate alternative dimensions when:

- Stronger anatomical evidence becomes available.
- Physical test-rig constraints are established.
- Balloon deformation is introduced.
- Sensitivity to environmental dimensions needs evaluation.

Any change must be documented as a new geometry version.

Results generated with different boundary dimensions must not be compared without explicitly accounting for the geometry change.

---

## 4. Balloon Geometry

### 4.1 Reference Volume

The selected rigid spherical balloon volume is:

\[
V_b=550\ \mathrm{mL}=550000\ \mathrm{mm}^3
\]

For a sphere:

\[
V_b=\frac{4}{3}\pi r_b^3
\]

Therefore:

\[
r_b=\left(\frac{3V_b}{4\pi}\right)^{1/3}
\]

The equivalent spherical dimensions are approximately:

\[
r_b=50.83\ \mathrm{mm}
\]

\[
D_b=101.65\ \mathrm{mm}
\]

These are calculated dimensions of the engineering sphere, not directly measured external dimensions of a real gastric balloon.

### 4.2 Balloon Model Assumptions

The initial model assumes:

- A rigid spherical object.
- Constant volume.
- No deformation.
- Passive and unknown motion.
- A body-fixed coordinate frame.
- Fixed attachment coordinates relative to the balloon body.

The spherical geometry alone is rotationally symmetric.

For full 6-DOF pose sensing, orientation must be defined relative to identifiable body-fixed attachment locations or another physically established orientation reference.

---


## 5. Cuboid Boundary and Geometric Containment

### 5.1 Current Engineering Boundary

The current cavity model is an axis-aligned cuboid centred at the origin.

\[
\Omega_g=
\left\{
(x,y,z):
|x|\leq\frac{L_g}{2},
|y|\leq\frac{W_g}{2},
|z|\leq\frac{H_g}{2}
\right\}
\]

For the B1 engineering baseline:

\[
|x|\leq140\ \mathrm{mm}
\]

\[
|y|\leq150\ \mathrm{mm}
\]

\[
|z|\leq160\ \mathrm{mm}
\]

The cuboid volume is:

\[
V_{\mathrm{box}}=
280\times300\times320
\]

\[
V_{\mathrm{box}}=
26{,}880{,}000\ \mathrm{mm}^3
=26{,}880\ \mathrm{mL}
\]

This is the volume of the idealised engineering box, not a measured stomach capacity.

### 5.2 Full Sphere Containment

For a rigid spherical balloon with centre position

\[
P=[P_x,P_y,P_z]^T
\]

and radius \(r_b\), full containment requires:

\[
|P_x|\leq\frac{L_g}{2}-r_b-c
\]

\[
|P_y|\leq\frac{W_g}{2}-r_b-c
\]

\[
|P_z|\leq\frac{H_g}{2}-r_b-c
\]

where \(c\geq0\) is an assumed geometric clearance.

The initial B1 simulation uses:

\[
c=0\ \mathrm{mm}
\]

The zero-clearance assumption is used for ideal numerical containment.

It is not a validated physical clearance for a real balloon or cable system.

### 5.3 Current Geometrically Feasible Centre Region

For a nominal 550 mL sphere:

\[
r_b\approx50.83\ \mathrm{mm}
\]

The approximate feasible centre bounds are:

| Axis | Boundary dimension | Feasible centre coordinate | Total centre travel |
|---|---:|---:|---:|
| X — Length | 280 mm | ±89.17 mm | 178.35 mm |
| Y — Width | 300 mm | ±99.17 mm | 198.35 mm |
| Z — Height | 320 mm | ±109.17 mm | 218.35 mm |

The values are rounded independently.

These are ideal geometric limits, not observed physiological motion amplitudes.

The region is calculated from full-sphere containment, rather than centre-point containment alone.

### 5.4 MATLAB Implementation

```matlab
%% Current B1 engineering geometry

Lg = 280;  % mm, X length
Wg = 300;  % mm, Y width
Hg = 320;  % mm, Z height

V_balloon_ml = 550;
V_balloon = V_balloon_ml * 1000;

r_balloon = (3*V_balloon/(4*pi))^(1/3);

clearance = 0;  % mm, ideal geometry

centre_limit = [Lg; Wg; Hg]/2 ...
             - r_balloon - clearance;

assert(all(centre_limit >= 0), ...
    'No feasible sphere-centre region.');

fprintf('X: +/- %.2f mm\n',centre_limit(1));
fprintf('Y: +/- %.2f mm\n',centre_limit(2));
fprintf('Z: +/- %.2f mm\n',centre_limit(3));
```

The authoritative B1 implementation is:

`03_Simulation/MATLAB/workspace definition/B1_balloon_geometry_2026_10_30.m`

The saved geometry dataset is:

`B1_geometry_baseline.mat`

### 5.5 Historical Containment Calculation

For historical comparison only:

\[
D_{\mathrm{historical}}=
[140,150,160]\ \mathrm{mm}
\]

with:

\[
c=5\ \mathrm{mm}
\]

The previously calculated approximate centre extents were:

| Axis | Historical centre extent |
|---|---:|
| X | ±14.17 mm |
| Y | ±19.17 mm |
| Z | ±24.17 mm |

These results are retained to document the earlier engineering model.

They must not be used as the current B1–B4 workspace limits.

---


## 6. Alternative Ellipsoidal Boundary

An ellipsoidal cavity may be investigated as a future sensitivity scenario.

For engineering dimensions \(L_g,W_g,H_g\):

\[
\frac{x^2}{(L_g/2)^2}+
\frac{y^2}{(W_g/2)^2}+
\frac{z^2}{(H_g/2)^2}\leq1
\]

Using the current engineering dimensions:

\[
a=140,\qquad b=150,\qquad c_e=160
\]

where all semi-axes are in millimetres.

The corresponding ideal ellipsoid volume is approximately:

\[
V_{\mathrm{ellipsoid}}\approx14{,}074\ \mathrm{mL}
\]

The cuboid and ellipsoid have different internal geometry despite sharing the same overall dimensions.

The cuboid sphere-containment limits cannot be directly reused as exact ellipsoidal containment limits.

Full-sphere containment within an ellipsoid requires an appropriate geometric or numerical test.

**Status:** Alternative modelling scenario. Not the active B1–B4 geometry.

---


## 7. Geometry Sensitivity and Future Scenarios

The current B1–B4 numerical baseline is:

\[
D_{\mathrm{B1}}=[280,300,320]\ \mathrm{mm}
\]

Future sensitivity studies may investigate:

- Smaller or larger engineering boundaries.
- Different cuboid aspect ratios.
- Ellipsoidal boundaries.
- Alternative geometric clearance assumptions.
- Balloon volume changes.
- Flexible balloon deformation.

The historical ranges documented in Section 3 may be retained as separate reference scenarios.

They should not be treated as validated bounds for the current experimental system.

For each alternative scenario:

1. Declare the geometry and its evidence classification.
2. Recalculate the feasible balloon-centre region.
3. Regenerate anchor candidates where appropriate.
4. Re-evaluate cable geometry and interference.
5. Recompute sensing metrics.
6. Report differences from the current B1 baseline.

A new geometry scenario should have its own parameter set and version identifier.

Do not silently overwrite the original B1 baseline dataset.

---

## 8. Modelling Limitations

The current reference boundary does not establish:

1. Clinically validated adult-female gastric bounding-box dimensions.
2. A patient-specific intragastric lumen.
3. Physical compatibility of a rigid 550 mL sphere with a real stomach.
4. Physiological balloon migration or movement limits.
5. Gastric wall deformation or pressure.
6. Practical anchor mounting structures.
7. Cable routing and interference feasibility.
8. Cable tension requirements.
9. Position and orientation estimation accuracy.
10. A validated six-degree-of-freedom sensing workspace.

These questions require additional modelling, numerical evaluation or physical evidence.

The selected boundary should be revised if stronger relevant evidence becomes available.

---


## 9. B1 Completion and B5 Handoff

### 9.1 Completed B1 Geometry Tasks

**Status:** Completed.

The initial geometry model established:

- A 280 × 300 × 320 mm engineering cuboid.
- A nominal 550 mL rigid spherical balloon.
- Whole-sphere containment constraints.
- A geometrically feasible balloon-centre region.
- 26 initial anchor candidates.
- 40 initial body-frame attachment candidates.
- MATLAB visualisation and geometry verification.
- A saved B1 geometry dataset.

These results provide the geometry baseline for subsequent six-cable configuration evaluation.

### 9.2 Remaining Geometry Limitations

The B1 model does not establish:

- Clinically validated gastric dimensions.
- Physical anchor mounting feasibility.
- Finite cable-clearance requirements.
- Physiological balloon-motion limits.
- Flexible-balloon containment.
- Actual cable-tension feasibility.

### 9.3 B5 Configuration Design Handoff

The current geometry model is used for B5 six-cable configuration development.

B5 may expand the original anchor and attachment candidate sets without changing the declared B1 engineering boundary.

Any proposed changes to the boundary, clearance model or balloon geometry must be recorded explicitly.

The long-term seven-/eight-cable comparison should use consistent geometry and evaluation conventions.

---

## 10. Key References

The following references are retained from the existing nine-paper literature synthesis.

1. Kim et al. (2020). *Stomach volume assessment using three-dimensional computed tomography gastrography for bariatric treatment.* DOI: 10.1007/s11695-019-04189-5.

2. Toniolo et al. (2022). *Patient-specific stomach biomechanics before and after laparoscopic sleeve gastrectomy.* DOI: 10.1007/s00464-022-09233-7.

3. Kwon et al. (2020). *Modelling and manufacturing of 3D-printed, patient-specific, and anthropomorphic gastric phantoms.* DOI: 10.1038/s41598-020-74110-z.

4. Wang et al. (2016). *Gastric Anatomic Type Is Associated with Obesity and Gender.* DOI: 10.1159/000445062.

5. Bertoli et al. (2023). *A novel MRI-based three-dimensional model of stomach volume, surface area, and geometry in response to gastric filling and emptying.* DOI: 10.1111/nmo.14497.

6. Banerjee et al. (2020). *Volume and position change of the stomach during gastric accommodation and emptying.* DOI: 10.1111/nmo.13865.

7. Karnul & Murthy (2022). *A Study of Variations of the Stomach in Adults and Growth of the Fetal Stomach.* DOI: 10.7759/cureus.28517.

8. Lamart et al. (2013). *Prediction of the location and size of the stomach using patient characteristics for retrospective radiation dose estimation following radiotherapy.* DOI: 10.1088/0031-9155/58/24/8739.

9. Pickhardt & Asher (2003). *Wall Thickening of the Gastric Antrum as a Normal Finding.* DOI: 10.2214/ajr.181.4.1810973.

---


## 11. Related Research Documents

### Active Research Management

- [Current Research State](../CURRENT_STATE2.md)
- [Research Roadmap](../08_Project_Management/Roadmap.md)
- [November Research TODO](../08_Project_Management/November/current_november_todo_updated_2026_11_04.md)
- [November Weekly Plan](../08_Project_Management/November/weekly_plan_nov_04_17_2026.md)

### Technical Design

- [Sensing Objective](Sensing_Objective_v0.2.md)
- [Rigid-Body Sensing Design](Rigid_Body_Sensing_Design.md)
- [Prototype V1.0 Design](Prototype_V1_Rigid_to_Flexible_Design_2026_11_04.md)

### Geometric Evidence

- [Gastric Boundary Evidence](../02_Paper_Reading/Literature_Review/workspace%20definition/Gastric_Boundary_Evidence_Summary_v0.1.md)

---

**Current Engineering Boundary:** 280 × 300 × 320 mm.

**Historical Reference Boundary:** 140 × 150 × 160 mm.

**Geometry Status:** B1 completed. Anatomical and physical validation remain outstanding.

**Guiding Principle:** Keep literature evidence, historical engineering assumptions and current simulation parameters clearly separated.
