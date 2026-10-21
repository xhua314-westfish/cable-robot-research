2026-10-20

how to define anchor points and attachment points

我的课题：根据我目前的workspace vol1如何定义六根cable的anchor points和attachment points？

---

paper1(2026-10-20-01...pdf)

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

paper2(2026-10-21-02...pdf)

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

<img width="1482" height="393" alt="image" src="https://github.com/user-attachments/assets/1c407844-273b-4c33-a607-ffb9bb7f2892" />


---

paper3(2026-10-21-03...pdf)

Name:Determining feasible cable attachment locations for cable-driven-parallel robot
DOI:https://doi.org/10.1007/978-3-031-94608-0_21
APA:Cheng, H. H., Lau, D., & Hughes, J. (2025, June). Determining feasible cable attachment locations for cable-driven-parallel robot. In International Conference on Cable-Driven Parallel Robots (pp. 261-273). Cham: Springer Nature Switzerland.

1. Main Finding

- The paper proposes an efficient method to identify and visualize **feasible cable attachment regions** for cable-driven parallel robots (CDPRs).
- Rather than directly calculating one optimal attachment location, the method identifies a region of candidate locations satisfying the **Wrench-Closure Condition (WCC)**.
- Feasible regions progressively shrink as more robot poses are considered.
- A **Prioritized Reconfiguration Index (PRI)** is introduced to evaluate the relative size of each cable's feasible attachment region.
- The method is demonstrated primarily on a **6-DOF, 7-cable CDPR**, where the cable exit points on the base are the design variables.

**Key finding:** Feasible attachment-region identification can support cable placement design before selecting specific optimal locations.

 2. Selected Method

**Initial Cable Configuration → Feasible Boundary Generation → Workspace Intersection**

### Algorithm 1 — Feasible Boundary Generation

1. Define an initial cable configuration, including fixed base attachment points and end-effector attachment points.
2. Select one target cable and parameterize its base attachment location:

   \[
   A_i(u)=[u_x,u_y,u_z]^T
   \]

3. Keep the remaining cable attachment locations fixed and calculate the configuration-dependent wrench matrix.
4. Use RREF to derive WCC boundary functions:

   \[
   h_i(u)<0
   \]

5. Approximate the boundary functions using linear polynomial fitting:

   \[
   h_i(u)=C_{i1}u_x+C_{i2}u_y+C_{i3}u_z+C_{i4}
   \]

6. Intersect the resulting half-spaces to obtain the feasible region for the selected cable at a given robot pose.

### Algorithm 2 — Feasible Region Generation

1. Define the desired workspace and sample robot poses.
2. Define a candidate attachment-location search region.
3. Apply Algorithm 1 to each sampled pose.
4. Remove locations violating the WCC constraints.
5. Intersect feasible regions across all sampled poses:

   \[
   W_i^{\mathrm{final}}
   =\bigcap_{q_k\in\mathcal Q}W_i(q_k)
   \]

6. Visualize the remaining feasible region and repeat for other cables.
7. Optionally select a location within the feasible region and update the robot configuration for subsequent analysis.

**Additional metric — PRI**

\[
PRI_i=
\frac{\text{Volume of feasible region}_i}
{\text{Volume of sampled region}_i}
\]

A smaller PRI indicates a more restricted feasible placement region and can help prioritize cable relocation or redesign.

3. Research Adaptation

**Application: Passive Cable-Based 6-DOF Balloon Sensing**

The feasible-region concept can be adapted to identify candidate Anchor and Attachment Point locations before sensing-performance optimization.

**Proposed system:**

- Rigid spherical balloon: approximately 550 mL.
- Balloon radius: approximately 50.83 mm.
- Initial geometric boundary: 140 × 150 × 160 mm.
- Fixed external Anchor Points \(A_i\).
- Balloon-surface Attachment Points \(r_i\), fixed in the balloon coordinate frame after installation.
- Unknown passive balloon motion in 6 DOFs.

**Proposed adaptation:**

1. Define an initial configuration of Anchor and Attachment Points.
2. Define allowable placement regions for these points.
3. Sample balloon positions and orientations within the geometric workspace.
4. Evaluate candidate configurations using geometric and sensing-feasibility conditions.
5. Identify feasible placement regions before numerical optimization.
6. Optimize selected locations using measurement-based performance criteria.

**Potential sensing criteria:**

- Full-rank measurement Jacobian.
- Scaled minimum singular value.
- Scaled condition number.
- Workspace sensing coverage.
- Estimated pose error under cable-length measurement noise.

Unlike the original paper, the main objective is **measurement performance**, not Wrench Closure.

4. Limitations

- The method focuses on WCC and does not directly evaluate cable-length sensing accuracy.
- The main formulation is demonstrated for systems with \(m=n+1\), particularly a 6-DOF, 7-cable CDPR.
- The analyzed design variables are primarily the **base cable exit points**, rather than balloon-surface attachment points.
- Feasible regions are computed while other cable locations remain fixed; the method does not guarantee a globally optimal joint configuration of all cable attachment points.
- Results depend on the initial configuration, selected sampling region, and sampled robot poses.
- The method outputs feasible regions, not unique optimal attachment coordinates.
- Cable interference, measurement noise, cable elasticity, and full physical sensing behavior are not included in the demonstrated optimization.

**Important distinction:** WCC feasibility cannot be directly substituted for sensing feasibility, especially for a 6-DOF, 6-cable sensing system.

5. Next Step

**Reproduce the Feasible-Region Method, Then Adapt It to Balloon Sensing**

### Step 1 — Reproduce the Paper

- Use the initial 6-DOF, 7-cable configuration from Table 1.
- Reproduce the WCC half-space inequalities in Section 3.1.
- Reproduce Figure 2: feasible attachment-region visualization.
- Reproduce Figure 3: feasible-region reduction across sampled poses.
- Understand the numerical implementation of Algorithm 1 and Algorithm 2.

### Step 2 — Establish Our Initial Configuration

- Select an initial set of external Anchor Points.
- Select an initial set of balloon-surface Attachment Points.
- Calculate cable geometry, cable lengths, and the measurement Jacobian.
- Evaluate baseline sensing performance over sampled balloon poses.

### Step 3 — Adapt Feasible-Region Analysis

- Keep Anchor Points fixed initially.
- Search feasible Attachment Point locations on the spherical balloon surface.
- Apply geometric, spacing, interference, and sensing-rank constraints.
- Identify candidate regions for subsequent optimization.

### Step 4 — Optimize and Compare

- Define a sensing-performance objective based on the scaled Jacobian and/or pose estimation error.
- Optimize Attachment Point locations within the feasible regions.
- Extend to Anchor Point optimization if necessary.
- Compare baseline and optimized configurations.
- Later compare 6-, 7-, and 8-cable sensing systems.

**Expected outcome:** A systematic cable configuration design process combining feasible-region identification and sensing-performance optimization.

目前研究路线总结：
<img width="768" height="543" alt="image" src="https://github.com/user-attachments/assets/7884e971-8139-45c3-9f1e-18f124b52134" />

---

paper4(2026-10-21-04...pdf)

Name:Forward kinematics of a cable-driven parallel robot with pose estimation error covariance bounds
DOI:https://doi.org/10.1016/j.mechmachtheory.2023.105231
APA:Patel, S., Nguyen, V. L., & Caverly, R. J. (2023). Forward kinematics of a cable-driven parallel robot with pose estimation error covariance bounds. Mechanism and Machine Theory, 183, 105231.

# Paper 4 — Literature Review

**Title:** Forward kinematics of a cable-driven parallel robot with pose estimation error covariance bounds

**Authors:** Patel, Nguyen & Caverly (2023)

**Journal:** Mechanism and Machine Theory, 183, 105231

1. Main Finding

- The paper develops four iterative forward kinematics algorithms for estimating the 6-DOF pose of cable-driven parallel robots.
- The proposed methods estimate both the end-effector pose and its **pose estimation error covariance**.
- Two measurement formulations are compared: cable-length and cable-length-squared loop-closure equations.
- Euler angles, quaternions, and direction cosine matrices (DCMs) are investigated as attitude representations.
- Monte Carlo simulations demonstrate accurate covariance predictions and generally faster convergence with the cable-length-squared formulation under the tested conditions.

**Key finding:** Cable-length measurements can be used not only to estimate robot pose but also to quantify the uncertainty of the estimated pose.

2. Selected Method

**Cable Geometry → Measurement Model → Jacobian → Pose Estimation → Covariance Evaluation**

**1. Cable-length measurement model**

\[
\ell_i=\|A_i-(P+Rr_i)\|+v_i
\]

where \(A_i\) and \(r_i\) are known attachment locations, \(P\) and \(R\) define the unknown pose, and \(v_i\) represents measurement noise.

**2. Measurement Jacobian**

\[
H(\rho)=\frac{\partial g(\rho)}{\partial\rho}
\]

The Jacobian relates small changes in robot pose to changes in cable-length measurements.

**3. Forward kinematics**

The pose is estimated using weighted nonlinear least squares and the Levenberg–Marquardt algorithm.

**4. Pose estimation error covariance**

\[
P_{\mathrm{cov}}\approx(H^TV^{-1}H)^{-1}
\]

The covariance depends on the measurement Jacobian and the assumed cable-length noise covariance.

**5. Numerical validation**

- 8-cable, 6-DOF CDPR simulation.
- Gaussian cable-length measurement noise.
- Monte Carlo simulations.
- Position and attitude estimation errors.
- RMSE, predicted 3σ uncertainty bounds, and NEES consistency testing.

 3. Research Adaptation

**Application: Passive Cable-Based Balloon Pose Sensing**

The measurement and estimation methods can be adapted to a rigid spherical balloon undergoing unknown passive motion.

**Proposed research model:**

- Rigid spherical proxy with a volume of approximately 550 mL.
- Fixed external Anchor Points.
- Attachment Points fixed on the balloon surface.
- Passive 6-DOF translation and rotation.
- Cable-length measurements with simulated sensor noise.

**Proposed adaptation:**

1. Define an initial cable configuration.
2. Establish the cable-length measurement model.
3. Derive the 6-DOF measurement Jacobian.
4. Evaluate local pose observability through Jacobian rank.
5. Introduce cable-length measurement noise.
6. Calculate pose estimation covariance.
7. Compare different cable configurations using predicted uncertainty and Monte Carlo RMSE.
8. Investigate 6-, 7-, and 8-cable sensing configurations.

**Potential sensing-performance criteria:**

- Full-rank measurement Jacobian.
- Scaled singular values and condition number.
- Position and orientation estimation uncertainty.
- Position and orientation RMSE.
- Sensing performance across the sampled workspace.

**Research opportunity:** Extend covariance-based pose estimation analysis into Anchor Point and Attachment Point configuration optimization.

 4. Limitations

- The paper studies pose estimation for known robot geometry rather than directly optimizing cable attachment locations.
- Numerical validation primarily uses an 8-cable, 6-DOF configuration.
- The proposed forward kinematics algorithms are local iterative methods and may converge to an incorrect solution depending on initialization.
- The cable model assumes no sag or elastic deformation.
- Covariance predictions depend on the measurement noise model and local linearization assumptions.
- Calibration errors and non-Gaussian measurement noise require further investigation.
- The paper provides numerical simulation validation rather than experimental validation of the proposed methods.

**Important distinction:** Pose estimation covariance describes predicted uncertainty under the assumed model; it does not guarantee physical sensing accuracy when unmodeled errors are present.

 5. Next Step

**Develop a Measurement-Based Sensing Quality Evaluation Framework**

**Step 1 — Initial Geometry**

Define initial Anchor and balloon-surface Attachment Point locations.

**Step 2 — Measurement Model**

Implement cable-length calculations and derive the measurement Jacobian.

**Step 3 — Sensing Quality**

Evaluate rank, appropriately scaled singular values, and predicted pose estimation covariance.

**Step 4 — Pose Estimation**

Implement a baseline weighted least-squares forward kinematics estimator.

**Step 5 — Numerical Validation**

Add simulated cable-length noise and evaluate position/orientation estimation errors using Monte Carlo simulations.

**Step 6 — Configuration Comparison**

Compare sensing performance for different cable configurations and eventually investigate 6-, 7-, and 8-cable systems.

**Expected outcome:** A quantitative framework for evaluating how cable configuration affects 6-DOF pose estimation accuracy in a passively moving balloon sensing system.

---

四篇文章总结：

<img width="1518" height="363" alt="image" src="https://github.com/user-attachments/assets/15b26b9e-c10f-476f-899c-3ad5353c5b6a" />

研究逻辑：
<img width="759" height="684" alt="image" src="https://github.com/user-attachments/assets/e7574367-cfda-492a-a3c0-2b01657743ef" />

目前研究重点：
Measurement-Oriented Cable Configuration Design for Passive 6-DOF Balloon Pose Sensing.

---

