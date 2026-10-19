
2026-10-19

**define geometric constraints**

**cable 5~8**

---

**cable 5**

paper1

Revisiting trilateration for robot localization
DOI:10.1109/TRO.2004.833793
APA:Thomas, F., & Ros, L. (2005). Revisiting trilateration for robot localization. IEEE Transactions on robotics, 21(1), 93-101.

支撑要点：从代数几何角度证明，求解三维空间刚体的 6D 位姿至少需要 6 个独立的距离标量；少于 6 个独立测量值（如 $n=5$）时，几何约束方程组不闭合，位姿解存在至少 1 个未约束的连续流形。

paper2

Pose-Estimation Methods for Planar Underactuated Cable-Driven Parallel Robots
DOI:10.1007/978-3-031-32322-5_1
APA:Gabaldo, S., Idà, E., & Carricato, M. (2023, June). Pose-estimation methods for planar underactuated cable-driven parallel robots. In International Conference on Cable-Driven Parallel Robots (pp. 3-15). Cham: Springer Nature Switzerland.

支撑要点：从代数几何角度证明，求解三维空间刚体的 6D 位姿至少需要 6 个独立的距离标量；少于 6 个独立测量值（如 $n=5$）时，几何约束方程组不闭合，位姿解存在至少 1 个未约束的连续流形。

---

**cable 6**

paper3

Cable-Driven Parallel Robots: Theory and Application
DOI:10.1007/978-3-319-76138-1
APA:Pott, A., & Bruckmann, T. (Eds.). (2013). Cable-driven parallel robots (Vol. 116). Berlin/Heidelberg, Germany: Springer.

支撑要点：系统阐述了 CDPR 的运动学理论，证明 $n=6$ 是空间 6-DOF 位姿局部几何确定（Just-determined）的最小标量测量与约束数量（Kinematic Minimum）。

paper4
Interval-Analysis-Based Determination of the Wrench-Feasible Workspace of Parallel Cable-Driven Robots

DOI:10.1109/TRO.2010.2089531
APA:Gouttefarde, M., Daney, D., & Merlet, J. P. (2010). Interval-analysis-based determination of the wrench-feasible workspace of parallel cable-driven robots. IEEE Transactions on Robotics, 27(1), 1-13.

支撑要点：通过区间分析证明了 $n=6$ 时机构雅可比矩阵满秩的几何条件，明确了 6 缆线系统在空间位姿求解中的确定性与局部奇异性分布。

---

**cable 7**

paper5
Wrench-closure workspace of six-dof parallel mechanisms driven by seven cables

DOI:10.1139/tcsme-2005-0036
APA:Gouttefarde, M., & Gosselin, C. M. (2005). Wrench-closure workspace of six-dof parallel mechanisms driven by 7 cables. Transactions of the canadian society for mechanical engineering, 29(4), 541-552.

支撑要点：专门针对 3D 空间 6-DOF 平台，推导并证明了为什么 6 根缆线无法在全姿态下保持拉力封闭，以及为什么 $n=7$ 是实现 6-DOF 全向受力完全约束的几何下限。

paper6

Analysis of the Wrench-Closure Workspace of Planar Parallel Cable-Driven Mechanisms
DOI:10.1109/TRO.2006.870638
APA:Gouttefarde, M., & Gosselin, C. M. (2006). Analysis of the wrench-closure workspace of planar parallel cable-driven mechanisms. IEEE Transactions on Robotics, 22(3), 434-445.

支撑要点：从凸包（Convex Hull）与张力矩阵角度严格证明了单向拉力约束下实现 Wrench-Closure 的充分必要条件，为 7 缆线冗余约束提供了基础数学框架。

---

**cable 8**

paper7

Cable-driven parallel robots for industrial applications: The IPAnema system family
DOI:10.1109/ISR.2013.6695742
APA:Pott, A., Mütherich, H., Kraus, W., Schmidt, V., Miermeister, P., Dietz, T., & Verl, A. (2013, October). Cable-driven parallel robots for industrial applications: The IPAnema system family. In IEEE ISR 2013 (pp. 1-6). IEEE.

支撑要点：展示了工业级 IPAnema 系统的标准 8 缆线构型。证明了 8 缆线对称布局能消除 7 缆线非对称布局带来的局部拉力瓶颈，在全工作空间内提供高度一致的刚度与更大的工作空间。

paper8

A novel real-time tension distribution method for cable-driven parallel robots
DOI:10.1017/S0263574724001590
APA:Song, D., Lu, M., Zhao, L., Sun, Z., Wang, H., & Zhang, L. (2024). A novel real-time tension distribution method for cable-driven parallel robots. Robotica, 42(11), 3692-3708.
支撑要点：展示了工业级 IPAnema 系统的标准 8 缆线构型。证明了 8 缆线对称布局能消除 7 缆线非对称布局带来的局部拉力瓶颈，在全工作空间内提供高度一致的刚度与更大的工作空间。

---


