---
title: Integration IMU 
date: 2020-07-08 11:07:05
mathjax: true
tags:
  - autonomous
---
The measurements of angular volocity and acceleration from an IMU are defined using Eqs below
$$
\hat{w}_t = w_t + b^w_t + n^w_t \tag 1
$$
$$
\hat{a}_t = R^{BW}_t + b^a_t + n^a_t \tag 2
$$

| state           | 角速度                                                                                                  | 加速度                                                                                                                                                                                                                                                                    |
| --------------- | ------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 原始值          | $\hat{w}_t$                                                                                             | $\hat{a}_t$                                                                                                                                                                                                                                                               |
| 偏置            | $bias^w_t$                                                                                              | $bias^a_t$                                                                                                                                                                                                                                                                |
| **corrected**   | $w^c_t=\hat{w}_t - bias^w_t$                                                                            | $a^c_t=\hat{a}_t - bias^a_t$                                                                                                                                                                                                                                              |
| **update bias** | $bias^w_t = bias^w_{t-1}$                                                                               | $bias^a_t = bias^a_{t-1}$                                                                                                                                                                                                                                                 |
| **update pose** | $tf_{imu} = \mathcal{R}^{\frac{w^c_t + w^c_{t-1}}{2}\cdot \Delta t}$<br/> $R_t = R_{t-1}\cdot tf_{imu}$ | ENU系下$dv=R \cdot a^c_t + g$<br> as for g,imu-z up g=-9.8,down g=9.8<br> 加速度: $\mathcal{dv}=\frac{R_t \cdot a^c_t + R_{t-1} \cdot a^c_{t-1}}{2} + g$<br> 速度: $v_t = v_{t-1} + dv \cdot \Delta t$<br> 位置: $P_t = P_{t-1} + \frac{v_t + v_{t-1}}{2} \cdot \Delta t$ |
