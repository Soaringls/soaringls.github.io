---
title: Integration IMU 
date: 2020-07-08 11:07:05
mathjax: true
categories:
  - autonomous
  - imu
tags:
  - imu
---


The measurements of angular volocity and acceleration from an IMU are defined using Eqs below
<!--more-->
$$
\hat{w}_t = w_t + b^w_t + n^w_t \tag 1
$$
$$
\hat{a}_t = R^{BW}_t + b^a_t + n^a_t \tag 2
$$

| state           | 角速度                                                                                                  | 加速度                                                                                                                                                                                                                                                                                            |
| --------------- | ------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 原始值          | $\hat{w}_t$                                                                                             | $\hat{a}_t$                                                                                                                                                                                                                                                                                       |
| 偏置            | $bias^w_t$                                                                                              | $bias^a_t$                                                                                                                                                                                                                                                                                        |
| **corrected**   | $w^c_t=\hat{w}_t - bias^w_t$                                                                            | $a^c_t=\hat{a}_t - bias^a_t$                                                                                                                                                                                                                                                                      |
| **update bias** | $bias^w_t = bias^w_{t-1}$                                                                               | $bias^a_t = bias^a_{t-1}$                                                                                                                                                                                                                                                                         |
| **update pose** | $tf_{imu} = \mathcal{R}^{\frac{w^c_t + w^c_{t-1}}{2}\cdot \Delta t}$<br/> $R_t = R_{t-1}\cdot tf_{imu}$ | ENU系下$dv=R \cdot a^c_t + g$<br> as for g,(与imu-z轴朝向无关,始终为$dv=R \cdot a^c_t - 9.8$)<br> 加速度: $\mathcal{dv}=\frac{R_t \cdot a^c_t + R_{t-1} \cdot a^c_{t-1}}{2} + g$<br> 速度: $v_t = v_{t-1} + dv \cdot \Delta t$<br> 位置: $P_t = P_{t-1} + \frac{v_t + v_{t-1}}{2} \cdot \Delta t$ |


code
```cpp
last_state
//update biase
Eigen::Vector3d acc_bias = last_state->acc_bias;
Eigen::Vector3d gyro_bias= last_state->gyro_bias;

Eigen::Vector3d mean_corrected_angle_vel = (corrected_angle_vel + last_state->corrected_angle_vel)/2;
double rot_angle = mean_corrected_angle_vel.norm() * dt;
Eigen::Vector3d rot_axis(0, 0, 1);
if(rot_angle > 1e-9){
    rot_axis = mean_corrected_angle_vel.normalized();
}
Eigen::AngleAxisd tf_rot_vector(rot_angle, rot_axis);
attitude = (last_state->atitude * tf_rot_vector).normalized();//update pose attitude类型为Eigen::Quaterniond


//因为imu的线加速度和角速度数据是在Body坐标系下表示的
//东北天坐标系下线加速度计算公式:"a = R*(acc-acc_biase) + g"
//(acc_biase和gyro_biase不可求，故通常是0，imu-z轴朝下/g=9.8, imu-z轴朝上/g=-9.8),现有车上imu-Z轴朝上
//所以要利用对应时刻的姿态将其转换到世界坐标系下，转换之前要减去bias，转化之后要减去重力加速度
Eigen::Vector3d gravity_vector(0, 0, -9.8);//imu-z up
Eigen::Vector3d dv = (attitude*corrected_acc + last_state->attitude * last_state->corrected_acc)/2.0 + gravity_vector;//加速度
//update velocity
velocity = last_state->velocity + dv * dt;
//update position: vt=vo+at, dv是加速度
position = last_state->position + (velocity + last_state->velocity) /2.0 * dt;
  
```