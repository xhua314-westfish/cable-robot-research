# Workspace Boundary v0.2 — Preliminary 3D Gastric Geometry

**Original Date:** 2026-10-20  
**Last Reviewed:** 2026-10-30  
**Current Phase:** Phase B — Balloon-Specific Cable Sensing Design  
**Current Task:** B1.1 — Review Existing Geometry Evidence  
**Status:** Provisional engineering geometry; not a clinically validated gastric workspace

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

### 3.1 Source Evidence

The principal directly reported orthogonal bounding-box ranges cited in the existing literature synthesis are attributed to Lamart et al. (2013), based on CT data from 30 adult men in a supine position.

These data are not direct measurements of adult women with intragastric balloons.

The ranges must not be interpreted as:

- Adult-female population confidence intervals.
- Patient-specific gastric lumen dimensions.
- Balloon migration ranges.
- Clinically validated sensing workspace boundaries.

Other studies in the literature synthesis contribute information about gastric volume, geometry, variability and morphology.

However, their reported quantities are not necessarily directly interchangeable with three orthogonal bounding-box dimensions.

### 3.2 Engineering Parameter Table

The following parameters are mapped into the selected X/Y/Z coordinate convention.

| Parameter | Literature-observed range | Engineering candidate range | Provisional reference |
|---|---|---|---|
| \(L_g\) — X | 60–150 mm | 120–170 mm | 140 mm |
| \(W_g\) — Y | 90–160 mm | 130–160 mm | 150 mm |
| \(H_g\) — Z | 100–200 mm | 130–180 mm | 160 mm |

**Parameter interpretation:**

- \(L_g\) corresponds to the previously reported craniocaudal projected extent.
- \(W_g\) corresponds to transverse width.
- \(H_g\) corresponds to anteroposterior depth in the source evidence.

The engineering candidate ranges are selected for simulation and sensitivity studies.

Values outside the original observed range, including \(L_g\) values above 150 mm, are engineering extrapolations rather than directly validated clinical observations.

### 3.3 Provisional Reference Geometry

For the initial engineering example:

\[
L_g=140\ \mathrm{mm}
\]

\[
W_g=150\ \mathrm{mm}
\]

\[
H_g=160\ \mathrm{mm}
\]

These dimensions preserve the physical lengths used in the previous reference geometry while applying the new coordinate convention.

**Status:** Provisional. The dimensions remain subject to review in B1.1.

They are not final clinically validated boundary parameters.

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

### 5.1 Initial Engineering Boundary

The initial cavity surrogate is an axis-aligned rectangular box centred at the origin.

Define:

\[
\Omega_g=
\left\{
(x,y,z):
|x|\leq\frac{L_g}{2},
|y|\leq\frac{W_g}{2},
|z|\leq\frac{H_g}{2}
\right\}
\]

For the provisional reference dimensions:

\[
\Omega_g=
\left\{
(x,y,z):
|x|\leq70,
|y|\leq75,
|z|\leq80
\right\}
\]

All coordinates are in millimetres.

The calculated cuboid volume is:

\[
V_{\mathrm{box}}=140\times150\times160
\]

\[
V_{\mathrm{box}}=3360000\ \mathrm{mm}^3
=3360\ \mathrm{mL}
\]

This volume is not a measured stomach lumen volume.

### 5.2 Full Sphere Containment

Let:

\[
P=
\begin{bmatrix}
P_x\\
P_y\\
P_z
\end{bmatrix}
\]

be the balloon-centre position.

For a sphere of radius \(r_b\), the complete sphere must fit within the cavity.

With an assumed clearance \(c\geq0\):

\[
|P_x|\leq\frac{L_g}{2}-r_b-c
\]

\[
|P_y|\leq\frac{W_g}{2}-r_b-c
\]

\[
|P_z|\leq\frac{H_g}{2}-r_b-c
\]

The geometrically feasible centre domain is empty when any right-hand side is negative.

These constraints verify containment in the rectangular surrogate only.

### 5.3 Reference Clearance Calculation

For comparison with the previous engineering study, use an illustrative clearance:

\[
c=5\ \mathrm{mm}
\]

This clearance is an engineering assumption and is not clinically established.

The resulting centre-travel table is:

| Axis | Boundary dimension | No-clearance total travel | Centre extent with 5 mm clearance | Total travel with 5 mm clearance |
|---|---:|---:|---:|---:|
| X — Length | 140 mm | 38.35 mm | ±14.17 mm | 28.35 mm |
| Y — Width | 150 mm | 48.35 mm | ±19.17 mm | 38.35 mm |
| Z — Height | 160 mm | 58.35 mm | ±24.17 mm | 48.35 mm |

These results are the previous containment calculations rearranged into the new coordinate system.

They do not represent observed physiological movement amplitudes.

### 5.4 General Implementation

The centre bounds should be calculated directly from the selected parameters:

```matlab
Vb = 550000;                  % mm^3
rb = (3*Vb/(4*pi))^(1/3);     % mm

Lg = 140;                     % mm, provisional
Wg = 150;                     % mm, provisional
Hg = 160;                     % mm, provisional

clearance = 5;                % mm, assumed

halfTravel = [Lg; Wg; Hg]/2 - rb - clearance;

isNonempty = all(halfTravel >= 0);

if ~isNonempty
    error('No geometrically feasible sphere-centre region.');
end

% Candidate centre P must satisfy:
% all(abs(P) <= halfTravel)
```

The numerical example is a reference calculation, not a completed B1 implementation.

---

## 6. Alternative Ellipsoidal Boundary

An ellipsoidal cavity may be used as a sensitivity scenario.

Under the selected coordinate convention:

\[
\Omega_{\mathrm{ellipsoid}}=
\left\{
(x,y,z):
\frac{x^2}{(L_g/2)^2}
+
\frac{y^2}{(W_g/2)^2}
+
\frac{z^2}{(H_g/2)^2}
\leq1
\right\}
\]

For the provisional parameters, its semi-axes are:

\[
a=70,\quad b=75,\quad c_e=80\ \mathrm{mm}
\]

The corresponding model volume is approximately 1759 mL.

The ellipsoid and cuboid have different internal geometry despite sharing the same bounding-box dimensions.

**Important:** The cuboid sphere-centre travel limits must not be reused as exact ellipsoid containment limits.

The full sphere must be checked against the ellipsoidal surface using an appropriate geometric or numerical containment procedure.

---

## 7. Sensitivity Scenarios

The provisional candidate dimension ranges are:

\[
L_g\in[120,170]\ \mathrm{mm}
\]

\[
W_g\in[130,160]\ \mathrm{mm}
\]

\[
H_g\in[130,180]\ \mathrm{mm}
\]

For initial sensitivity analysis:

1. Vary one engineering dimension at a time.
2. Keep other dimensions at their provisional reference values.
3. Recalculate the whole-sphere containment constraints.
4. Report the resulting feasible centre region.
5. Identify cases with no feasible region.
6. Compare the cuboid and ellipsoid only using their respective containment methods.

Combining independently reported or assumed ranges produces synthetic simulation scenarios.

Such combinations are not measurements of an individual stomach.

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

## 9. Phase B1 Handoff

**Current task:** B1.1 — Review Existing Geometry Evidence.

### B1.1 — Evidence and Parameter Review

- [ ] Cross-check the literature-observed dimension ranges.
- [ ] Verify the selected coordinate mapping.
- [ ] Confirm the provisional engineering dimension ranges.
- [ ] Distinguish reported, derived and assumed quantities.
- [ ] Record any remaining anatomical uncertainty.

### B1.2 — Balloon Geometry

- [ ] Implement the 550 mL sphere in MATLAB.
- [ ] Verify the radius, diameter and volume.
- [ ] Define the balloon body frame.

### B1.3 — Feasible Centre Region

- [ ] Implement the cuboid containment constraints.
- [ ] Test reference and boundary positions.
- [ ] Visualise the full sphere and feasible centre region.

### B1.4–B1.6 — Candidate Regions and Integration

- [ ] Define candidate fixed anchor regions.
- [ ] Define candidate balloon-surface attachment regions.
- [ ] Combine the geometry and constraints.
- [ ] Save the MATLAB model and verification note.

Anchor-region and attachment-region selection must distinguish physically supported mounting assumptions from purely mathematical candidate locations.

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

- [Current Research State](../CURRENT_STATE2.md)
- [Sensing Objective](Sensing_Objective_v0.2.md)
- [Rigid-Body Sensing Design](Rigid_Body_Sensing_Design.md)
- [Research Roadmap](../08_Project_Management/Roadmap.md)
- [Active Research TODO](../08_Project_Management/current_october_november_todo.md)

---

**Current Status:** Provisional engineering geometry documented with consistent X/Y/Z coordinates. Formal B1.1 evidence review and B1 numerical validation remain outstanding.
