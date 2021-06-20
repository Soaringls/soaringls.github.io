---
title: Note after reading paper of lio-mapping
date: 2020-10-09 10:29:34
mathjax: true
categories:
  - paper
  - algorithm
tag:
  - slam
---

note of lio-mapping
<!-- more -->
shortcomnigs
- make featuring tracking an intractable problem
- lidar mounted on moving robots suffer from motion distortion
- there are some lidar-degraded cases in which the lidar receives few or missing points
  such as narrow corridor environments lead to ill-constrained pose estimation
  
the paper's contributions as follows:
- to achieve real-time and more consistent estimation,fixed-lag smoothing and marginalization of old poses are applied,followed by a rotation constrained refinement.
- pre-integrate and use raw IMU measurements with lidar measurements to optimize the states within the whole system,which can work in laser degraded cases or when the motions are rapid.

Notations
- denote the transformation matrix as $\mathbf{T}_b^a \in  SE(3)\,[b \to a]$, which transforms the point $\mathbf{x}^b \in \mathbb{R}^3$ in the frame $\mathcal{F}_b$ into the frame $\mathcal{F}_a$,just as [$\mathbf{T}_L^I$ -> lidar / imu, transform point $P$ from lidar frame $\mathcal{F}_{lidar}$ to imu frame $\mathcal{F}_{imu}$].
- denote the raw measurements of the IMU at timestamp $\mathcal{k}$ as $\hat{a}_k$ and $\hat{w}_k$.
- denote the extracted features as $\mathbf{F}_a$ in original $\mathcal{F}_{lidar}$,which can be transformed into the frame $\mathcal{F}_b$ as $\mathbf{F}_a^b$.
- robot body frame $\mathcal{F}_B \to imu$, and lidar body frame$\mathcal{F}_L \to lidar$