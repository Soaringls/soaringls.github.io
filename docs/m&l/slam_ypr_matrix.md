### 旋转矩阵
局部坐标系下坐标$P_{local}(x,y,yaw| \alpha)$, $yaw 即  \alpha$是相对东北天$ENU$系，则
$$
P_{enu} = 
\begin{bmatrix}
    x_{enu} \\\\
    y_{enu}
\end{bmatrix}
=
\begin{bmatrix}
    cos \alpha, & -sin \alpha \\\\
    sin \alpha, & cos \alpha
\end{bmatrix}
\begin{bmatrix}
    x_{local} \\\\
    y_{local}
\end{bmatrix}
$$
### yaw-pitch-roll ==> rotation matrix
x-front;y-left;z-up
$$
R_{z-yaw}
\begin{bmatrix}
    cos_yaw, & -sin_yaw,& 0.0\\\\
    sin_yaw, & cos_yaw,& 0.0\\\\
    0.0,& 0.0,& 0.0\\\\
\end{bmatrix} \\\\
R_{y-pitch}
\begin{bmatrix}
    cos_pitch, & sin_pitch,& 0.0\\\\
    -sin_pitch, & cos_pitch,& 0.0\\\\
    0.0,& 0.0,& 0.0\\\\
\end{bmatrix}
$$

function R = YawPitchRollToRotationMatrix (yaw_pitch_roll)
  sin_yaw = sin(yaw_pitch_roll(1));
  cos_yaw = cos(yaw_pitch_roll(1));
  sin_pitch = sin(yaw_pitch_roll(2));
  cos_pitch = cos(yaw_pitch_roll(2));
  sin_roll  = sin(yaw_pitch_roll(3));
  cos_roll = cos(yaw_pitch_roll(3));

  Ry = [cos_yaw, -sin_yaw, 0.0; ...
             sin_yaw,  cos_yaw, 0.0; ...
             0.0,            0.0,            1.0];

  Rp = [ cos_pitch, 0.0, sin_pitch; ...
              0.0,              1.0, 0.0; ...
              -sin_pitch, 0.0, cos_pitch];

  Rr = [1.0, 0.0,          0.0; ...
            0.0, cos_roll, -sin_roll; ...
            0.0, sin_roll, cos_roll];

  R =  Ry * Rp * Rr;

endfunction

生成旋转矩阵的一种简单方式是把它作为三个基本旋转的序列复合。关于右手笛卡尔坐标系的 x-, y- 和 z-轴的旋转分别叫做 roll, pitch 和 yaw 旋转。因为这些旋转被表达为关于一个轴的旋转，它们的生成元很容易表达

- 绕 x-轴的主动旋转定义为:
  $$
  R_x(\theta _x) = 
  \begin{bmatrix}
  1& 0& 0 \\\\
  0& cos\theta_x& -sin\theta_x \\\\
  0& sin\theta_x& cos\theta_x
  \end{bmatrix}
  $$
  此处$\theta_x$即为roll角，yz平面顺时针
- 绕 y-轴的主动旋转定义为:
  $$
  R_y(\theta _y) = 
  \begin{bmatrix}
  cos\theta_y&  sin\theta_y& 0 \\\\
  0& 1& 0 \\\\
  -sin\theta_y& cos\theta_y& 0
  \end{bmatrix}
  $$
  此处$\theta_y$即为pitch角，zx平面顺时针
- 绕 z-轴的主动旋转定义为:
  $$
  R_z(\theta _z) = 
  \begin{bmatrix}
  cos\theta_z& -sin\theta_z& 0 \\\\
  sin\theta_z& cos\theta_z& 0 \\\\
  0& 0& 1
  \end{bmatrix}
  $$
  此处$\theta_z$即为yaw角，xy平面顺时针

在飞行动力学中，roll - $\gamma$, pitch - $\alpha$ 和 yaw - $\beta$ , 但是为了避免混淆于欧拉角这里使用符号 $\theta _{x}$, $\theta _{y}$, $\theta _{z}$分别表示绕$X \quad Y \quad Z$(右手-Xfront-Yleft-Zup)轴旋转的roll、pitch、yaw

[ref wikibaike](https://en.wikipedia.org/wiki/Euler_angles)
![](./images/euler_R.png)
![](./images/euler_R2angle.png)