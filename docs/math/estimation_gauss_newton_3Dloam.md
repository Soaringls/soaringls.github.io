## lego-loam
[LOAM后端优化算法分析](https://zhuanlan.zhihu.com/p/205648834)
### 三维变换
其中旋转矩阵R定义如下，使用的是欧拉角表示方式，s表示sin，c表示cos，例如cry表示cos(ry)

rx、ry、rz分别表示绕X、Y、Z的角
$$
R=R(rx,ry,rz) = 
\begin{bmatrix}
c_{ry}c_{rz}+s_{rx}s_{ry}s_{rz} &c_{rz}s_{rx}s_{ry} - c_{ry}s_{rz} & c_{rx}s_{ry} \\\\
c_{rx}s_{rz} & c_{rx}c_{rz} & -s_{rx} \\\\
c_{ry}s_{rx}s_{rz} - c_{rz}s_{ry} & c_{ry}c_{rz}s_{rx} + s_{ry}s_{rz}& c_{rx}c_{ry}
\end{bmatrix}
$$
平移t:$t=(t_x,t_y,t_z)^T$
### 变量
$x = (r_x,r_y,r_z, t_x, t_y,t_z)$, 表示roll、pitch、yaw及translation的变化
### cost function
即优化点$P$到线段$P_1 \quad P_2$的距离,以求得$x = (r_x,r_y,r_z, t_x, t_y,t_z)$
$$
f(x) =f[P(x)]  = \frac{|PP_1 \times PP_2|}{|P_1P_2|} = \frac{\sqrt{a^2+b^2+c^2}}{|P_1P_2|} = d 
$$
其中$PP_1 \times PP_2 = (a,b,c)$,且
$$
a=PP_{1x}PP_{2y} - PP_{2x}PP_{1y} \\\\
b=PP_{1x}PP_{2z} - PP_{2x}PP_{1z} \\\\
c=PP_{1y}PP_{2z} - PP_{2y}PP_{1z}
$$
#### 优化求解优$x = (r_x,r_y,r_z, t_x, t_y,t_z)$过程
1. 给定初始值$x_0$
2. 对于第$k$次迭代, 求jacobian和f(x)
3. 求解增量方程 $H \Delta x = -g$,$H = J^TJ \quad g = J^Tf(x)$
4. 如果$\Delta x_k$或者损失函数$f(x_k)$ 足够小，则优化停止，否则令$x_{k+1} = x_k+\Delta x$ ,然后step2

#### step2详解：求Jocabian
- 将第$i$个观测通过变量$x_k$进行转换 
  $$P^w = G(x)=TP=RP+t \\\\ \quad \quad T=(R,t) = (r_x,r_y,r_z, t_x, t_y,t_z)^T
  $$
$$
P^{iw} = 
\begin{bmatrix}
P_x \\\\
P_y \\\\
P_z
\end{bmatrix} = R 
\begin{bmatrix}
x_i \\\\
y_i \\\\
z_i
\end{bmatrix} + 
\begin{bmatrix}
t_x \\\\
t_y \\\\
t_z
\end{bmatrix} = T_i P_i
$$
损失函数

$f(x)  = d = f(P^w, Target) = f[G(x), Target]$ 
### 计算jacobian
单次观测Jacobian为
$$
J_i = 
\begin{bmatrix}
\frac{\partial f}{\partial r_x} \\\\
\frac{\partial f}{\partial r_y} \\\\
\frac{\partial f}{\partial r_z} \\\\
\frac{\partial f}{\partial t_x} \\\\
\frac{\partial f}{\partial t_y} \\\\
\frac{\partial f}{\partial t_z} 
\end{bmatrix}^T = 
\frac{\partial f}{\partial P^{w}}\frac{\partial P^{w}}{\partial x} =
\begin{bmatrix}
\frac{\partial f}{\partial P_x} \frac{\partial P_x}{\partial r_x} + \frac{\partial f}{\partial P_y} \frac{\partial P_y}{\partial r_x} + \frac{\partial f}{\partial P_z} \frac{\partial P_z}{\partial r_x} \\\\
\frac{\partial f}{\partial P_x} \frac{\partial P_x}{\partial r_y} + \frac{\partial f}{\partial P_y} \frac{\partial P_y}{\partial r_y} + \frac{\partial f}{\partial P_z} \frac{\partial P_z}{\partial r_y} \\\\
\frac{\partial f}{\partial P_x} \frac{\partial P_x}{\partial r_z} + \frac{\partial f}{\partial P_y} \frac{\partial P_y}{\partial r_z} + \frac{\partial f}{\partial P_z} \frac{\partial P_z}{\partial r_z} \\\\
\frac{\partial f}{\partial P_x} \frac{\partial P_x}{\partial t_x} + \frac{\partial f}{\partial P_y} \frac{\partial P_y}{\partial t_x}+ \frac{\partial f}{\partial P_z} \frac{\partial P_z}{\partial t_x} \\\\
\frac{\partial f}{\partial P_x} \frac{\partial P_x}{\partial t_y} + \frac{\partial f}{\partial P_y} \frac{\partial P_y}{\partial t_y}+ \frac{\partial f}{\partial P_z} \frac{\partial P_z}{\partial t_y} \\\\
\frac{\partial f}{\partial P_x} \frac{\partial P_x}{\partial t_z} + \frac{\partial f}{\partial P_y} \frac{\partial P_y}{\partial t_z}+ \frac{\partial f}{\partial P_z} \frac{\partial P_z}{\partial t_z} \\\\
\end{bmatrix}^T
$$
其中
$$
\frac{\partial f}{\partial P^w} =[
\frac{\partial f}{\partial P_x} \quad
\frac{\partial f}{\partial P_y} \quad
\frac{\partial f}{\partial P_z}
] 
$$
为cost function对点的导数，具体到点到线和点到面距离d即为：距离d对点求导，可理解为求一个点的移动方向，在这个方向上移动d减小的最快，显然是垂线方向

所有观测对应Jacobian为: mxn
$$
J = 
\begin{bmatrix}
J_1 \\\\
J_2 \\\\
... \\\
J_m
\end{bmatrix}
$$

cost function单次结果$f(x) = dx$
所有观测结果为：mx1
$$
f = [f[P_1(x)] \quad f[P_2(x)] \quad ... \quad f[P_m(x)]]^T = [d_1 \quad d_2 \quad ... \quad d_m]^T
$$
#### 详细计算Jacobian
cost function
即优化点$P$到线段$P_1 \quad P_2$的距离,以求得$x = (r_x,r_y,r_z, t_x, t_y,t_z)$
$$
f(x) =f[P(x)]  = \frac{|PP_1 \times PP_2|}{|P_1P_2|} = \frac{\sqrt{a^2+b^2+c^2}}{B} = d \tag{ref}
$$
其中$P(x) = \quad PP_1 \times PP_2 = (a,b,c)$,且
$$
a=PP_{1x}PP_{2y} - PP_{2x}PP_{1y} \\\\
b=PP_{1x}PP_{2z} - PP_{2x}PP_{1z} \\\\
c=PP_{1y}PP_{2z} - PP_{2y}PP_{1z} \\\\
B = |P_1P_2|
$$
- 计算$\frac{\partial f}{\partial P_x}$
  - 方法1：公式$ref$两边平方,再对$P_x$直接求导
  $$
  [f(x)]^2 = \frac{a^2+b^2+c^2}{B^2} = d^2 \\\\
  2f(x){f}'(x) = \frac{2a \frac{\partial a}{\partial P_x} + 2b \frac{\partial b}{\partial P_x} + 2c \frac{\partial c}{\partial P_x}}{B^2} \\\\
  {f}'(x) = \frac{a \frac{\partial a}{\partial P_x} + b \frac{\partial b}{\partial P_x}}{d \cdot B^2} = \frac{1}{d\cdot B^2}(a(PP_{2y} - PP_{1y})+b(PP_{2z} - PP_{1z})) = \frac{a P_1P_{2y} + bP_1P{2z}}{d\cdot B^2}
  $$
  - 方法2：公式$ref$对$P_x$直接求导
  $$
  {f}'(x) = \frac{2a \frac{\partial a}{\partial P_x} + 2b \frac{\partial b}{\partial P_x} + 2c \frac{\partial c}{\partial P_x} }{B\cdot 2\sqrt{a^2+b^2+c^2}} = \frac{a \frac{\partial a}{\partial P_x} + b \frac{\partial b}{\partial P_x}}{B\cdot \sqrt{a^2+b^2+c^2}} \quad 然后两边同时乘f(x) \\\\
  f(x){f}'(x) =  \frac{a \frac{\partial a}{\partial P_x} + b \frac{\partial b}{\partial P_x}}{B^2} 
  $$
  then
  $$
  {f}'(x) = \frac{\partial f}{\partial P_x} = \frac{a \frac{\partial a}{\partial P_x} + b \frac{\partial b}{\partial P_x}}{d \cdot B^2} 
  $$
- 计算$\frac{\partial P_x}{\partial r_x}$

  由$P^w =RP+t$得
  $$
  P_x = (c_{ry}c_{rz} + s_{rx}s_{ry}s_{rz} )x_i + (-c_{ry}s_{rz}+s_{rx}s_{ry}c_{rz})y_i+ s_{ry}c_{rx}z_i + t_x
  $$
  $$
  \frac{\partial P_x}{\partial r_x} = c_{rx}s_{ry}s_{rz} x_i + c_{rx}s_{ry}c_{rz}y_i  - s_{ry}s_{rx}z_i
  $$ 

#### 点到面cost function

$P$为观测点，$P_i$为平面一点，$n$为平面法向量
$$
f(x) = f[P(x)] = |PP_1|\cdot |n|\cdot cos<PP_1,n> = d \\\\
f(x) = f[P(x)]  =PP_1 \cdot n =  n_x(x - x_i) + n_y(y - y_i) + n_z(z - z_i) 
$$

Jacobian计算
$$
\frac{\partial f}{\partial P} = 
\begin{bmatrix}
    \frac{\partial f}{\partial P_x} \\\\
    \frac{\partial f}{\partial P_y} \\\\
    \frac{\partial f}{\partial P_z} 
\end{bmatrix}^T = 
\begin{bmatrix}
    n_x \\\\
    n_y \\\\
    n_z
\end{bmatrix}^T
$$