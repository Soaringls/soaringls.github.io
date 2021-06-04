---
title: >-
  Introduction of Gtsam
date: 2020-12-31 19:22:23
mathjax: true
categories:
  - autonomous
  - algorithm
tags:
  - algorithm
---

note of gtsam by DongJing
<!-- more -->
## Theory
### SLAM as a Bayes Net

$$
\begin{aligned}
&\mathbf{P}(\mathbf{X,L,Z}) = P(x_0)\prod_{i=1}^MP(x_i|x_{i-1},u_i)\prod_{k=1}^KP(z_k|x_{ik},l_{jk}) \\\\\\\\
& x_i = f_i(x_{i-1},u_i)+w_i \Leftrightarrow \\\\ 
& P(x_i|x_{i-1},u_i)\propto exp-\frac{1}{2}||f_i(x_{i-1},u_i)-x_i||^2\Lambda_i  \\\\
&z_k=h_k(x_{ik},l_{jk})+v_k \Leftrightarrow \\\\
&P(z_k|x_{ik},l_{jk})\propto exp-\frac{1}{2}||h_k(x_{ik},l_{jk})-z_k||^2_{\sum_k}
\end{aligned}
$$ 
### SLAM as a Factor Graph
### SLAM as a Non-linear Least Squares
### Optimization on Manifold/Lie Groups
### iSAM2 and Bayes Tree

## Programming
### First Cpp example
### Use Gtsam in Matlab
### Write your own factor
### Expression Automatic Differentiation(New in 4.0)
### Traits Optimize any type in GTSAM(New in 4.0)
### Use GTSAM in Python

## Applications
### Visual-lnertial Odometry
### Structure from Motion(SFM)
### Multi-Robot SLAM Coordinate Frame and Distrubuted Optimization 
### Multi-View Stereo and Optical Flow
### Motion Planning