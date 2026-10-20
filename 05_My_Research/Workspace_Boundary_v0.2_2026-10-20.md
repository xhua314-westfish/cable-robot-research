# Workspace Boundary v0.2 — Preliminary 3D Gastric Geometry

**Date:** 2026-10-20  
**Research phase:** 3D rigid-body cable sensing foundation  
**Status:** Provisional engineering baseline; **not** a measured adult-female gastric workspace  
**Source literature notes:** [`gastric boundary.md`](../../02_Paper_Reading/Literature_Review/workspace%20definition/gastric%20boundary.md) and `Gastric_Boundary_Evidence_Summary_v0.1.md`

## 1. Research purpose and scope

Establish a reproducible, adjustable three-dimensional boundary for the first stage of sensing a passively moving **550 mL rigid spherical balloon proxy**. The immediate estimation state remains 6-DOF pose, not balloon volume or deformation. Dimensions of the reference environment are engineering inputs; they are not claimed to be exact anatomical dimensions of an implanted balloon patient's stomach.

Three distinct sets must be distinguished:

1. **Anatomical bounding box:** axis-aligned enclosure of a segmented stomach.
2. **Geometrically feasible centre domain:** centres for which the *whole rigid sphere* fits within an assumed cavity geometry, with optional clearance.
3. **Cable sensing workspace:** feasible poses that also satisfy sensing, routing, tension, and accuracy requirements; **not yet determined**.

## 2. Fixed coordinate convention

Use an anatomical, right-handed coordinate system, with units in **mm**:

| Axis | Positive direction | Dimension | Definition |
|---|---|---|---|
| X | Patient's left | **Wg** (transverse width) | `max(x_stomach) - min(x_stomach)` |
| Y | Posterior | **Hg** (anteroposterior depth) | `max(y_stomach) - min(y_stomach)` |
| Z | Cranial | **Lg** (craniocaudal extent) | `max(z_stomach) - min(z_stomach)` |

The model origin is the centre of the *engineering reference bounding box*, not the T12 vertebral reference point in Lamart et al. (2013). Z is anatomical craniocaudal, and need not coincide with the laboratory gravity direction in a supine experiment. Gastric anatomical curve lengths must not be substituted for these orthogonal spans.

## 3. Boundary evidence and selection

**Directly observed orthogonal bounding-box dimensions:** Lamart et al. (2013), 30 adult men, supine CT. These are study-specific observed ranges, not population confidence intervals, nor adult-female or implanted-balloon values.

| Parameter | Literature-observed range | Engineering candidate study range | **v0.2 reference** | Reference and justification |
|:--|--:|--:|--:|:--|
| **Wg (X)** | 90–160 mm | **130–160 mm** | **150 mm** | Lamart et al. (2013) 3D transverse bounding box; upper part permits translation of 101.65-mm sphere |
| **Hg (Y)** | 100–200 mm | **130–180 mm** | **160 mm** | Lamart et al. (2013) 3D AP bounding box; other gastric-wall studies inform cavity/outer-surface distinction but not AP size |
| **Lg (Z)** | 60–150 mm | **120–170 mm** | **140 mm** | Lamart et al. (2013) 3D CC bounding box; **150–170 mm is an engineering extrapolation** for testing, not directly validated CT CC range |

The nine-paper literature synthesis also includes Kim (2020), Toniolo (2022), Kwon (2020), Wang (2016), Bertoli (2023), Banerjee (2020), Karnul & Murthy (2022), and Pickhardt & Asher (2003). These papers contribute volume, female cadaveric anatomical length, shape variability, filling-related movement, and wall thickness—but **do not provide independently comparable X/Y/Z bounding-box ranges**. Therefore **no weighted pooled mean or combined clinical interval is calculated**.

**Important non-equivalences:** female cadaveric stomach length 171 ± 20.1 mm (Karnul & Murthy, 2022) is not an imaging-derived CC projection; fundus radius, greater curvature length, MRI scan coverage, and one-landmark motion are not Wg/Hg/Lg. Volumes alone cannot identify three independent lengths.

## 4. Balloon and containment calculation

Rigid sphere proxy volume `Vb = 550 mL = 550,000 mm^3`:

`rb = (3*Vb/(4*pi))^(1/3) = 50.83 mm`  
`Db = 2*rb = 101.65 mm`

For a **rectangular cavity surrogate** of size `(Wg,Hg,Lg)` centered at (0,0,0), with an **assumed** clearance `c = 5 mm` between the sphere surface and the boundary:

`abs(x_center) <= Wg/2 - rb - c`  
`abs(y_center) <= Hg/2 - rb - c`  
`abs(z_center) <= Lg/2 - rb - c`

A positive right-hand side on every axis is required. Results at the v0.2 reference:

| Axis | Boundary dimension (mm) | No-clearance centre travel (mm) | Centre extent with 5 mm clearance (mm) | Total centre travel with 5 mm clearance (mm) |
|---|---:|---:|---:|---:|
| X | 150 | 48.35 | ±19.17 | **38.35** |
| Y | 160 | 58.35 | ±24.17 | **48.35** |
| Z | 140 | 38.35 | ±14.17 | **28.35** |

This verifies **containment in the simplified rectangular surrogate only**. Box volume is `3,360 mL`; it is **not** the segmented gastric lumen volume. No normal clinical migration amplitude or motion direction is inferred.

## 5. Shape representation for the next stage

- **Reference bounding box:** `Wg = 150, Hg = 160, Lg = 140 mm`. Provides measurable X/Y/Z dimensions, simple movement constraints, and a clear engineering envelope.
- **Conceptual stomach/cavity boundary:** for a preliminary 3D illustration, an ellipsoid with semi-axes `(Wg/2,Hg/2,Lg/2) = (75,80,70) mm` can be drawn in the same bounding box. It is an *assumed cavity shape*, not an anatomical reconstruction.
- **Ellipsoid caution:** its model volume is approximately **1,759 mL**, not the 3,360 mL rectangular-box volume. Neither represents the volume of a documented single patient. Ellipsoidal sphere-centre feasibility requires collision/containment checking against the ellipsoid. **The box-based travel table above must not be reused as ellipsoid travel bounds.**
- **Sphere depiction:** rigid opaque sphere of diameter 101.65 mm at reference centre; do not imply current rigid sphere can measure volume changes.

## 6. Sensitivity scenarios and later validation

Explore candidates Wg = 130–160 mm, Hg = 130–180 mm, Lg = 120–170 mm, initially one axis at a time. If combining independent endpoint values, treat each combination as a synthetic engineering scenario, not a measured individual stomach. Validate sphere containment for every scenario and for the chosen cavity shape before sampling poses.

Open limitations and later tasks:

1. Adult female and high-BMI 3D bounding-box dimensions remain insufficiently evidenced.
2. Real lumen versus outer stomach surface and patient posture are not reproduced by the simplified model.
3. In-vivo gastric filling does not imply equivalent accommodation of an ideal rigid 550-mL sphere.
4. Anchor/attachment placement, cable routing, interference, low positive tension, Jacobian rank, pose noise, and identifiability have **not** been evaluated.
5. The reference geometry shall be revised if stronger imaging or experimental measurements become available.

## 7. Handoff to the next scheduled task

**Step 2 deliverable:** dimension table, conventions, nominal parameters, collision-screening assumptions (this file).  
**Step 3 (on request):** MATLAB 3D figure with one X/Y/Z frame, one solid spherical balloon, one visibly distinct simplified gastric boundary/ellipsoid, and optionally an external dashed bounding box. Verify whole-sphere containment.  
**Following 3D cable geometry:** use the confirmed reference parameters and define six 3D anchors and body-frame attachment points before Jacobian and estimator work.

## 8. Key references (original paper IDs)

- **Paper 1:** Kim et al. (2020). *Stomach volume assessment using three-dimensional computed tomography gastrography for bariatric treatment.* https://doi.org/10.1007/s11695-019-04189-5
- **Paper 2:** Toniolo et al. (2022). *Patient-specific stomach biomechanics before and after laparoscopic sleeve gastrectomy.* https://doi.org/10.1007/s00464-022-09233-7
- **Paper 3:** Kwon et al. (2020). *Modelling and manufacturing of 3D-printed, patient-specific, and anthropomorphic gastric phantoms.* https://doi.org/10.1038/s41598-020-74110-z
- **Paper 4:** Wang et al. (2016). *Gastric Anatomic Type Is Associated with Obesity and Gender.* https://doi.org/10.1159/000445062
- **Paper 5:** Bertoli et al. (2023). *A novel MRI-based three-dimensional model of stomach volume, surface area, and geometry in response to gastric filling and emptying.* https://doi.org/10.1111/nmo.14497
- **Paper 6:** Banerjee et al. (2020). *Volume and position change of the stomach during gastric accommodation and emptying.* https://doi.org/10.1111/nmo.13865
- **Paper 7:** Karnul & Murthy (2022). *A Study of Variations of the Stomach in Adults and Growth of the Fetal Stomach.* https://doi.org/10.7759/cureus.28517
- **Paper 8:** Lamart et al. (2013). *Prediction of the location and size of the stomach using patient characteristics for retrospective radiation dose estimation following radiotherapy.* https://doi.org/10.1088/0031-9155/58/24/8739
- **Paper 9:** Pickhardt & Asher (2003). *Wall Thickening of the Gastric Antrum as a Normal Finding.* https://doi.org/10.2214/ajr.181.4.1810973
