# Gastric Boundary — Literature Evidence Summary v0.1

**Date:** 2026-10-20  
**Research phase:** 3D rigid-body sensing / preliminary gastric boundary  
**Status:** Literature synthesis and **provisional** engineering candidate ranges; not a clinically validated intragastric-balloon workspace  
**Source notes:** [`gastric boundary.md`](https://github.com/xhua314-westfish/cable-robot-research/blob/main/02_Paper_Reading/Literature_Review/workspace%20definition/gastric%20boundary.md)

## 0. Definitions and interpretation

The same axis-aligned anatomical coordinate convention is used throughout this summary:

| Axis | Anatomical direction | Model parameter | Definition |
|---|---|---|---|
| **X** | Transverse / left–right | **\(W_g\)** | \(x_{\max}-x_{\min}\) |
| **Y** | Anteroposterior / front–back | **\(H_g\)** | \(y_{\max}-y_{\min}\) |
| **Z** | Craniocaudal / head–foot | **\(L_g\)** | \(z_{\max}-z_{\min}\) |

Dimensions are **mm**, stomach volumes **mL**, unless otherwise stated. These are *axis-aligned bounding-box extents*, **not** greater/lesser-curvature arc lengths, path lengths or rotated principal axes. The anatomical Z axis need not coincide with laboratory gravity in a supine setup. The bounding box is **not** equivalent to usable lumen or the cable sensing workspace.

Evidence categories: **D** = directly reported matching 3D axis dimension; **I** = indirectly relevant anatomy/volume/motion; **E** = engineering assumption only. For values copied from the GitHub review, original article tables and definitions should be rechecked before clinical claims.

## 1. Comprehensive evidence table — nine papers

| Paper / Reference | Imaging / study population | Reported quantitative evidence | Direct 3D \(W_g,H_g,L_g\)? | Role and limitations |
|---|---|---|---|---|
| **1 — [Kim et al., 2020](https://doi.org/10.1007/s11695-019-04189-5)** | 3D CT gastrography; 100 people; obesity comparison | Stomach volume **268–751 mL** (as recorded in review); BMI ≥25 group **572 ± 301.6 mL** | **No (I)** | Volume/population context. Do not infer 3 independent axes from volume alone. Check whether the quoted 268–751 mL is a study range or another reported statistic before describing it as a patient min–max. |
| **2 — [Toniolo et al., 2022](https://doi.org/10.1007/s00464-022-09233-7)** | MRI-based patient-specific biomechanics; 23 bariatric surgery patients | Preoperative baseline **179.10 ± 93.6 mL**; preoperative simulated 30 mmHg **1100 ± 658 mL** | **No (I)** | Demonstrates distension sensitivity. **Simulated capacity is not a clinically observed bounding-box dimension.** |
| **3 — [Kwon et al., 2020](https://doi.org/10.1038/s41598-020-74110-z)** | CT reconstruction / 3D-printed phantom; 3 subjects | Original CT volumes **868, 1504, 1683 mL**; printed models **880, 1579, 1697 mL** | **No (I)** | Reference for larger segmented stomach volumes and phantom modelling; limited \(n=3\). Figure distances do not constitute complete axis-aligned XYZ maxima. |
| **4 — [Wang et al., 2016](https://doi.org/10.1159/000445062)** | Standing upper-GI radiography; 777 adults | Medial fundus platform threshold **38 mm**; fundus-related radius approximately **80–100 mm** *as noted in source review* | **No (I)** | Local 2D stomach-shape information; **80–100 mm radius requires original-variable verification** and must not be equated with overall X/Y/Z or balloon clearance. |
| **5 — [Bertoli et al., 2023](https://doi.org/10.1111/nmo.14497)** | MRI filling/emptying; 12 healthy adults (7 male, 5 female) | Baseline volume **140 ± 32 mL**, immediately after meal **669 ± 41 mL**; reported surface area ~**536 cm²** (source-note value to verify) | **No (I)** | Volume/surface/morphology context. Scanning slice count or cylindrical equivalent diameter does **not** establish CC extent, transverse width or AP depth. |
| **6 — [Banerjee et al., 2020](https://doi.org/10.1111/nmo.13865)** | 3D MRI; 16 healthy volunteers | Baseline **164.0 ± 19.6 mL**, after 800 mL infusion **806.9 ± 42.0 mL** (**mean ± SE** per review); mean inferior motion of incisural midpoint **32.3 ± 8.4 mm** | **No (I)** | Confirms filling-related volume and landmark changes, **not** whole-stomach Z-span increase or actual balloon motion range. |
| **7 — [Karnul & Murthy, 2022](https://doi.org/10.7759/cureus.28517)** | Adult cadaveric anatomy | Female anatomical *stomach length* **171 ± 20.1 mm**; female greater-curvature arc **292 ± 20.1 mm**; female lesser-curvature arc **260.5 ± 23 mm** | **No (I)** | Relevant female anatomy, **but cadaveric length and curvature are not CT CC bounding-box measurements**. Source article has reported sample-count inconsistency; avoid presenting subgroup values as population norms. |
| **8 — [Lamart et al., 2013](https://doi.org/10.1088/0031-9155/58/24/8739)** | Supine 3D CT; 30 **adult men** | Transverse (X) **mean 130, observed 90–160 mm**; AP (Y) **mean 150, observed 100–200 mm**; CC (Z) **mean 100, observed 60–150 mm** | **Yes (D)** | **Primary direct XYZ reference**. Sex, position, gastric filling and non-balloon context limit generalisation; independent axis ranges cannot be combined into a real individual stomach. |
| **9 — [Pickhardt & Asher, 2003](https://doi.org/10.2214/ajr.181.4.1810973)** | MDCT; 153 adults plus cadaveric comparisons | Gastric-body anterior wall **2.0 ± 0.4 mm**; antral wall **5.1 ± 1.6 mm** | **No (I)** | Wall-thickness evidence to distinguish external gastric boundary from internal cavity, **not** an AP bounding-box estimate. |

**Statistical caution:** Preserve each paper's SD/SE definitions rather than silently converting all “±” values to SD. Studies use different protocols, populations, positions and degrees of filling. No pooled or meta-analytic confidence interval is implied by this table.

## 2. Evidence regrouped by X / Y / Z

| Parameter / axis | Direct same-axis evidence | Indirect supporting literature | Evidence-based reading |
|---|---|---|---|
| **\(W_g\) / X — Transverse** | **Paper 8:** observed **90–160 mm**, mean **130 mm**, supine male CT | **Paper 4:** 2D fundus geometry and shape categories; **Paper 7:** cadaveric curvatures; **Papers 1, 3, 5:** gastric volumes | **90–160 mm** is a reported direct CT observation interval in *one male cohort*, **not** a pooled female or balloon-implanted range. Curvature/volume cannot be added or transformed without geometry assumptions. |
| **\(H_g\) / Y — Anteroposterior** | **Paper 8:** observed **100–200 mm**, mean **150 mm**, supine male CT | **Paper 9:** local wall thickness; **Papers 2, 5, 6:** distension and volume variability | **100–200 mm** is the direct CT observation interval. Gastric outer wall and *usable lumen* are different boundaries; wall thickness does not yield total depth. |
| **\(L_g\) / Z — Craniocaudal** | **Paper 8:** observed **60–150 mm**, mean **100 mm**, supine male CT | **Paper 7:** female anatomical stomach length **171 ± 20.1 mm** (different measurement); **Paper 6:** incisural landmark inferior displacement **32.3 ± 8.4 mm** | **60–150 mm** is the direct CT **CC projection** observation interval. **171 mm must NOT be substituted for CC projection**, and 32.3 mm must NOT be added to obtain new whole-stomach height. |

**Evidence gaps:** None of the nine studies supplies a matched set of post-implantation 3D inner-lumen XYZ dimensions for adult women with a 550 mL intragastric balloon. A single reliable three-axis female-specific anatomical range therefore **cannot** be claimed.

## 3. Final summary — literature ranges vs provisional engineering candidate ranges

| Parameter | Direct literature observed range (Paper 8; mm) | Reference mean (Paper 8; mm) | **Provisional engineering candidate range (mm)** | Basis / status |
|---|---:|---:|---:|---|
| **\(W_g\) / X** | **90–160** | **130** | **130–160** | Upper part of directly observed transverse CT extents, selected to offer clearance around the proxy balloon (**E**). |
| **\(H_g\) / Y** | **100–200** | **150** | **130–180** | Test envelope within CT-reported AP span, with positive balloon centre travel (**E**). |
| **\(L_g\) / Z** | **60–150** | **100** | **120–170** | **120–150** overlaps the CT range; **150–170** is an *engineering extension*, **not directly supported as female CC extent** by Paper 7 (**E**). |

**Illustrative reference scenario (not a measured patient):** \((W_g,H_g,L_g)=(150,160,140)\) mm. This is one candidate for simulation, **not** the literature mean, and does not yet establish a real stomach lumen or feasible sensing region.

### 3.1 Physical consistency check for the 550 mL rigid-balloon proxy

For \(V_b=550\,\mathrm{mL}=550{,}000\,\mathrm{mm^3}\), the equivalent sphere has diameter

\[
D_b=2\left(\frac{3V_b}{4\pi}\right)^{1/3}\approx101.7\,\mathrm{mm}.
\]

An **axis-aligned rectangular *inner cavity*** permits the sphere only if **each** internal span is at least \(D_b\). With an optional clearance \(c\) at each side, a candidate must satisfy

\[
W_g,H_g,L_g\geq D_b+2c.
\]

For this **box approximation only**, centre travel along each axis is \(\Delta X=W_g-D_b-2c\), \(\Delta Y=H_g-D_b-2c\), \(\Delta Z=L_g-D_b-2c\). If \(c=0\), the illustrative 150 × 160 × 140 mm **box** permits about **48.3 × 58.3 × 38.3 mm** centre travel. These are **geometric** calculations, **not observed clinical balloon trajectories**. A stomach-shaped mesh/ellipsoid has a smaller and differently shaped feasible centre set; collision tests must be performed separately. Literature outer-stomach bounding boxes cannot simply be treated as internal lumen without an explicit modelling assumption.

### 3.2 Research decision and limits

1. **Fix the axis definitions** \(X\to W_g\), \(Y\to H_g\), \(Z\to L_g\). A local simulation origin may be set at the bounding-box centre; it is **not** the T12 landmark reference in Paper 8.
2. **Retain both numerical ranges:** the directly observed Paper 8 ranges and the distinct engineering candidate ranges. **Do not present the latter as clinical measurements.**
3. **Do not pool unlike anatomical measurements** (curvature arc, cadaveric anatomical length, MRI volume, landmark displacement) into one direct XYZ interval.
4. **At the next stage**, choose a geometry (box vs ellipsoid / stomach-shaped mesh), explicitly declare inner vs outer boundary and clearance, verify sphere fit and collision-free motion, then compare sensing performance across the candidate dimensions.
5. The **immediate** measurement objective is **6-DOF pose estimation of a fixed-volume rigid proxy**, not direct estimation of volume changes; deformation/volume estimation is a later research stage.

### Sources (paper numbering follows `gastric boundary.md`)

1. Kim et al. (2020). *Stomach volume assessment using three-dimensional computed tomography gastrography for bariatric treatment*. [DOI](https://doi.org/10.1007/s11695-019-04189-5).
2. Toniolo et al. (2022). *Patient-specific stomach biomechanics before and after laparoscopic sleeve gastrectomy*. [DOI](https://doi.org/10.1007/s00464-022-09233-7).
3. Kwon et al. (2020). *Modelling and manufacturing of 3D-printed, patient-specific, and anthropomorphic gastric phantoms: a pilot study*. [DOI](https://doi.org/10.1038/s41598-020-74110-z).
4. Wang et al. (2016). *Gastric Anatomic Type Is Associated with Obesity and Gender*. [DOI](https://doi.org/10.1159/000445062).
5. Bertoli et al. (2023). *A novel MRI-based three-dimensional model of stomach volume, surface area, and geometry in response to gastric filling and emptying*. [DOI](https://doi.org/10.1111/nmo.14497).
6. Banerjee et al. (2020). *Volume and position change of the stomach during gastric accommodation and emptying*. [DOI](https://doi.org/10.1111/nmo.13865).
7. Karnul & Murthy (2022). *A Study of Variations of the Stomach in Adults and Growth of the Fetal Stomach*. [DOI](https://doi.org/10.7759/cureus.28517).
8. Lamart et al. (2013). *Prediction of the location and size of the stomach using patient characteristics for retrospective radiation dose estimation following radiotherapy*. [DOI](https://doi.org/10.1088/0031-9155/58/24/8739).
9. Pickhardt & Asher (2003). *Wall Thickening of the Gastric Antrum as a Normal Finding*. [DOI](https://doi.org/10.2214/ajr.181.4.1810973).
