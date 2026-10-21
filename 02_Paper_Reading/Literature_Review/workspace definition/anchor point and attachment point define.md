2026-10-20

how to define anchor points and attachment points

我的课题：根据我目前的workspace vol1如何定义六根cable的anchor points和attachment points？

---

paper1 

Name:An Overview of Cable-Driven Parallel Robots: Workspace, Tension Distribution, and Cable Sagging
DOI:https://doi.org/10.1155/2022/2199748
APA:Tho, T. P., & Thinh, N. T. (2022). An Overview of Cable‐Driven Parallel Robots: Workspace, Tension Distribution, and Cable Sagging. Mathematical Problems in Engineering, 2022(1), 2199748.

Main Finding

CDPR Workspace depends on geometric configuration, cable tensions, external loads, and other constraints. Different workspace definitions and computation methods serve different design objectives.

Selected Method

Pointwise sampling is selected as the initial approach for evaluating a passive cable-based sensing system.

Research Adaptation

Traditional wrench-based feasibility will not be used as the primary sensing criterion. Instead, Jacobian rank, appropriately scaled conditioning, and pose-estimation performance will be investigated.

Limitations

The paper is a review, not a direct implementation guide for passive cable sensing or Anchor/Attachment optimisation. Additional methodological studies are required.

Next Step

Study a dedicated Cable Attachment or Configuration Optimisation paper to determine design variables, objective functions, and constraints.：

---

paper2

Name:Cable Attachment Optimization for Reconfigurable Cable-Driven Parallel Robots Based on Various Workspace Conditions
DOI:https://doi.org/10.1109/TRO.2023.3288838
APA:Cheng, H. H., & Lau, D. (2023). Cable attachment optimization for reconfigurable cable-driven parallel robots based on various workspace conditions. IEEE Transactions on Robotics, 39(5), 3759-3775.


1. Main Finding

- Cable attachment configurations significantly affect CDPR workspace, wrench capability, and interference conditions.
- The paper proposes a polynomial optimization framework to determine optimal cable attachment configurations for reconfigurable CDPRs.
- Two optimization objectives are investigated:
  - **Maximize Tension Factor (TF):** Improve wrench-closure-related performance.
  - **Minimize Cable Force:** Reduce the cable force required to produce a specified wrench.
- Wrench-Closure Condition (WCC), Wrench-Feasible Condition (WFC), and Interference-Free Condition (IFC) are incorporated as constraints.
- Simulation results demonstrate performance improvements through attachment reconfiguration.

2. Selected Method

**Configuration-based optimization framework**

1. Define cable geometry using Anchor Points and Attachment Points.
2. Calculate cable vectors, lengths, and the Jacobian matrix.
3. Evaluate candidate configurations using workspace conditions.
4. Define optimization variables, objective functions, and constraints.
5. Apply numerical optimization to determine a suitable cable configuration.

**Key mathematical relationships:**

Cable geometry:

\[
B_i=P+Rr_i
\]

\[
L_i=\|A_i-B_i\|
\]

Configuration-dependent Jacobian:

\[
J=J(q,\mathcal C)
\]

Generic optimization:

\[
\mathcal C^*=\arg\min_{\mathcal C}F(\mathcal C)
\]

Subject to geometric, workspace, and interference constraints.

The paper demonstrates polynomial optimization using semidefinite programming relaxation and also evaluates other solvers, including MATLAB `fmincon`.

3. Research Adaptation

**Application: Passive Cable-Based Balloon Sensing System**

The proposed optimization framework can be adapted to a fixed-configuration sensing system.

- **Anchor Points:** Fixed on the external frame.
- **Attachment Points:** Fixed relative to the balloon surface after installation and move with the balloon.
- **Moving Object:** 550 mL rigid spherical balloon.
- **Workspace:** Simplified rectangular bounding box, 140 × 150 × 160 mm.
- **Primary objective:** Estimate the balloon's 6-DOF position and orientation using cable-length measurements.

Unlike the original paper, the main optimization objective should be **sensing performance**, rather than wrench capability.

Potential evaluation metrics:

- Measurement Jacobian rank
- Scaled minimum singular value
- Scaled condition number
- Workspace sensing coverage
- Pose estimation error under measurement noise

The paper's WFC and IFC concepts can be retained as additional physical feasibility constraints.

4. Limitations

- The original study focuses on **reconfigurable CDPRs**, whereas the proposed sensing system uses fixed attachment configurations during operation.
- Its optimization objectives emphasize cable forces and wrench capability rather than measurement accuracy.
- Optimal configurations are calculated for specified poses or trajectory instances; they are not automatically optimal over the entire sensing workspace.
- The proposed polynomial IFC formulation is primarily developed for one-dimensional reconfiguration paths.
- Reconfiguration dynamics and control effects are not fully considered.
- The study does not directly validate passive balloon sensing, measurement noise propagation, or 6-DOF pose estimation accuracy.

Therefore, the optimization framework is transferable, but its objective functions and some constraints require adaptation.

5. Next Step

**Develop an Initial 3D Cable Configuration and Evaluate Its Performance Before Optimization**

### Step 1 — Define a Baseline Configuration

- Begin with a 6-cable configuration.
- Select an initial set of fixed Anchor Points \(A_i\) on the external frame.
- Select an initial set of Attachment Points \(r_i\) on the spherical balloon.
- Calculate the cable geometry and initial lengths.

### Step 2 — Evaluate the Baseline Configuration

- Construct the 6-DOF Measurement Jacobian.
- Check local identifiability using Jacobian rank.
- Calculate scaled singular values and condition number.
- Evaluate the configuration at sampled balloon poses.
- Check basic geometric and cable interference constraints.

### Step 3 — Optimize Attachment Locations

- Initially keep Anchor Points fixed.
- Parameterize Attachment Points on the balloon surface.
- Define feasible attachment regions and spacing constraints.
- Evaluate alternative configurations using sensing-performance metrics.
- Identify a configuration that improves performance over the baseline.

### Step 4 — Extend the Configuration Study

- Explore Anchor Point placement if necessary.
- Compare 6-, 7-, and 8-cable configurations.
- Evaluate workspace-wide sensing performance and pose estimation accuracy.
- Introduce cable tension and other physical feasibility constraints.

**Expected outcome:** A literature-informed, simulation-validated methodology for selecting Cable Anchor and Attachment Point configurations for passive 6-DOF balloon sensing.

---

paper1 

Name:
DOI:
APA:

文章内容：

与我课题的联系：

哪些点可以支撑我的课题：

---

