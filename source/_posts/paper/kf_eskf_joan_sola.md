---
title: Note after reading paper of ESKF
date: 2020-10-09 10:29:34
mathjax: true
categories:
  - paper
  - algorithm
tag:
  - slam
---

note of eskf
<!-- more -->
- ESKF
  - error-state最小轻量化,参数和自由度一样，但是避免了参数化冗余(即强约束计算时可能随之而来的协方差奇异性的问题)
  - error-state总是保持误差处在0值附近，避免潜在的参数奇异性、万向锁问题/ 能保证任何时刻有效线性化
  - error-state足够小,意味着其二阶导基本可忽略，Jacobian计算会很容易很快或者Jacobian是恒定的
  - todo

### ESKF基本介绍
状态量包括`true-state / nominal-state / error-state`
1. 高频IMU数据 $u_m$ 集成到`nominal-state` $x$, 不考虑噪声项目 $w$ 和其他扰动
2. 实时累计的误差集成到 `error-state`(由小的信号状态量构成,有时序的动态线性系统进行`correct`,用到的控制及测量矩阵由`nominal-state`计算) $\delta x$ 并用ESKF评估(包含了所有的噪声项和扰动)
3. `nominal-state`集成的同时,ESKF会`prdict`一个`error-state`的高斯估计
4. 精度高于IMU的`anchor-msg`(rtk/lidar/vision)到达时对`error—state`进行`correct`,从而计算出一个后验的`error-state`的高斯估计,最后将`error-state`的均值注入到`nominal-state`后重置为0,`error-state`的协方差.....