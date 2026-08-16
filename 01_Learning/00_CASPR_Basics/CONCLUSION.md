# Lesson 0 — Cable Robot Fundamentals

> Status: 🔴 Not Started / 🟡 In Progress / 🟢 Completed  
> Last Updated: 2026-08-17

---

## 1. Learning goal

弄懂基本概念

弄懂公式计算

使用matlab把公式计算复现


## 2. Core Theory

### 2.1 Concept

1. Cable-robot, Cable-Driven parallel robot (CDPR) 使用cable代替传统刚性节点控制moving platform

2. 基本结构, Anchor → Cable → Attachment → Platform

3. Cable只能产生拉力 因此tension必须满足 T＞0

4. anchor通常使用世界坐标系，比如 a1 = （0， 0），a2 = （1， 0）.....
attachment point使用local coordinate，比如 r = （-0.125， 0） 表示attachment位于平台左侧0.125

5.计算时需要讲局部坐标系转换为世界坐标系 

6. rx,ry是attactment的局部坐标，ux,uy是单位长度向量

### 2.2 Mathematical Model and derivation

cable标准计算流程：

anchor(1,0) attachment(0.625,0.5) attachment局部坐标 (rx, ry)

a. 长度向量 anchor - attachment = (0.375, -0.5) (x,y)

b. cable长度 l = sprt(x^2 + y^2)

c. 单位向量长度 (x, y) / l = (0.6, -0.8) (ux, uy)

d. 力矩系数 m = rx*ux - ryux 

f. matrix = [ux, uy, m]


## 3. Matlab realization

Anchor = [
    0 0;
    1 0;
    1 1;
    0 1
];

Platform = [0.5 0.5];

AttachmentLocal = [
    -0.125 0;
     0.125 0;
     0.125 0;
    -0.125 0
];

AttachmentWorld = AttachmentLocal + Platform;

LengthVector = Anchor - AttachmentWorld;

CableLength = vecnorm(LengthVector,2,2); (矩阵长度计算公式)

UnitVector = LengthVector ./ CableLength;

MomentArm = ...
    AttachmentLocal(:,1).*UnitVector(:,2) ...
    - AttachmentLocal(:,2).*UnitVector(:,1);

WrenchMatrix = [
    UnitVector(:,1)';
    UnitVector(:,2)';
    MomentArm'
];

## 4. CASPR simulation

xy_planar_example,

bodies.xml, Platform, DOF, Initial Pose, Joint Limits, Mass, Inertia

cables.xml, Cable, Anchor, Attachment, Minimum Tension, Maximum Tension

trajectories.xml, q(t) = [x(t), y(t), θ(t)] (定义运动位置和时间步)


## 5. My research connection

我的研究目标:使用 Cable Robot 构建一个 balloon position / shape measurement system。

Balloon deformation

        ↓
        
Attachment movement

        ↓
        
Cable length change

        ↓
        
Cable measurement

        ↓
        
Position / Shape estimation

通过这一课基本知道基本框架 cable 和刚体怎么定义 

## 5. My next plan

1.研究下在cable systmen里面怎么定义气球？
