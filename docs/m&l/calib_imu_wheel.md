# TODO: calib_imu_wheel

#### 地盘信号yaw_rate_bias、轮速系数speed_bias标定(from longchen)

- 状态量

$$  
  X(x , y,  z,  roll,  pitch,  yaw,  yaw\_rate,  yaw\_rate\_bias,  speed,   speed\_scale)
$$

- 控制量

$$
u(speed, yawrate, dt)
$$

|   yaw    | yaw_rate | yaw_rate_bias | speed | speed_scale |
| :------: | :------: | :-----------: | :---: | :---------: |
| $\theta$ |   $w$    |     $w_b$     |  $v$  |    $v_s$    |
 
 
predict

yaw以东为0度，右手法则，东逆时针: $0 \to 180$, 东顺时针:$0 \to -180$

$$
  \begin{align*}
    & {v}' = u(v) * [1 + u(v_s)] \\
    & {w}' = u(w) + w_b \\
    & {\theta}' = \theta + {w}' \cdot \delta{t}\\
    & {x}' = x + {v}' \cdot \delta{t} \cdot \cos({\theta}') \\
    & {y}' = y + {v}' \cdot \delta{t} \cdot \sin({\theta}')
  \end{align*}
$$ 

计算Jacobian
 
$$
\begin{gather}
   x行yaw列值 \\\\
 \dfrac{\partial {x}'}{\partial \theta} =  -\sin{\theta}' \cdot {v}' \cdot \delta t
\end{gather}
$$