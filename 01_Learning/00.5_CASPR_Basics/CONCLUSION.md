# Lesson 0 — Cable Robot Fundamentals

> Status: 🔴 Not Started / 🟡 In Progress / 🟢 Completed  
> Last Updated: 2026-08-17

---

## 1. Learning goal

建立基本概念 

## 2. Core Theory

### 2.1 Concept

Cable-robot 

Cable-Driven parallel robot (CDPR) 使用cable代替传统刚性节点控制moving platform

基本结构

Anchor → Cable → Attachment → Platform

Cable只能产生拉力 因此tension必须满足 T＞0

anchor通常使用世界坐标系，
比如 a1 = （0， 0），a2 = （1， 0）.....
attachment point使用local coordinate，
比如 r = （-0.125， 0） 表示attachment位于平台左侧0.125

### 2.2 Mathematical Model

Key equations:

\[
...
\]

Where:

- \( ... \) =
- \( ... \) =
- \( ... \) =

### 2.3 Derivation

Step-by-step derivation:

1. 
2. 
3. 

### 2.4 Physical Meaning

Explain what the equations mean physically.

---

## 3. Geometry & Coordinate System

### 3.1 World Coordinate System

Describe the world coordinate system.

### 3.2 Local Coordinate System

Describe the local coordinate system.

### 3.3 Coordinate Transformation

\[
...
\]

### 3.4 Key Geometry

- Anchor point:
- Attachment point:
- Platform position:
- Platform orientation:
- Cable direction:

---

## 4. CASPR Connection

### 4.1 Relevant CASPR Files

```text
03_Simulation/CASPR/...

