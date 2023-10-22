## 点到线的优化问题
以视觉定位为例
### 变量
$x = (\theta, t_x, t_y)$, 表示yaw及二维translation的变化
### cost function
$$
P = 
\begin{bmatrix}
P_x \\\\
P_y
\end{bmatrix} = 
\begin{bmatrix}
\cos \theta, & \sin \theta \\\\
\sin \theta, & \cos \theta
\end{bmatrix}
\begin{bmatrix}
x_i \\\\
y_i
\end{bmatrix} + 
\begin{bmatrix}
t_x \\\\
t_y
\end{bmatrix} =
\begin{bmatrix}
\cos \theta x_i - \sin \theta y_i + t_x \\\\
\sin \theta x_i + \cos \theta y_i + t_y
\end{bmatrix}
$$
即优化点$P$到线段$P_1 \quad P_2$的距离
$$
f(x) =f[P(x)]  = \frac{|PP_1 \times PP_2|}{|P_1P_2|} = \frac{|PP_{1x} PP_{2y} - PP_{1y} PP_{2x}|}{|P_1P_2|} = d 
$$
### 计算jacobian
$$
J^TJ \Delta x = -J^T\cdot f(x) \\\\
H \Delta = - g ,\quad \text{g \quad is \quad gradient}
$$
$$
J = 
\begin{bmatrix}
\frac{\partial f}{\partial \theta} \\\\
\frac{\partial f}{\partial t_x} \\\\
\frac{\partial f}{\partial t_y}
\end{bmatrix}^T =  
\frac{\partial f}{\partial P}\frac{\partial f}{\partial x(\theta, t_x, t_y)} =  
\begin{bmatrix}
\frac{\partial f}{\partial P_x} \frac{\partial P_x}{\partial \theta} + \frac{\partial f}{\partial P_y} \frac{\partial P_y}{\partial \theta} \\\\
\frac{\partial f}{\partial P_x} \frac{\partial P_x}{\partial t_x} + \frac{\partial f}{\partial P_y} \frac{\partial P_y}{\partial t_x} \\\\
\frac{\partial f}{\partial P_x} \frac{\partial P_x}{\partial t_y} + \frac{\partial f}{\partial P_y} \frac{\partial P_y}{\partial t_y} 
\end{bmatrix}^T
$$
#### 详细计算Jacobian
$$
set \quad A =PP_{1x} PP_{2y} - PP_{1y} PP_{2x}   \quad and \quad B = {|P_1P_2|} \\\\
(f(x))^2 = \frac{A^2}{B^2} =d^2   \\\\
2f(x){f}'(x) = \frac{2A{A}'}{B^2} \tag{tmp} 
$$
公式$tmp$两边同时对$P_x$求导
$$ 
2d \frac{\partial f}{\partial P_x} = \frac{2A}{B^2} \frac{\partial A}{\partial P_x} = \frac{2A}{B^2} \cdot(PP_{2y} - PP_{1y}) \\\\
\frac{\partial f}{\partial P_x} =  \frac{A \cdot P_1P_{2y}}{d\cdot B^2} 
$$
公式$tmp$两边同时对$P_y$求导
$$
2d \frac{\partial f}{\partial P_y} = \frac{2A}{B^2} \frac{\partial A}{\partial P_y} = \frac{2A}{B^2} \cdot(PP_{1x} - PP_{2x}) \\\\
\frac{\partial f}{\partial P_y} =  \frac{A \cdot P_2P_{1x}}{d\cdot B^2} =  \frac{ - A \cdot P_1P_{2x}}{d\cdot B^2} 
$$
$P(x)对 x = (\theta, t_x, t_y)求导$
$$
\frac{\partial P}{\partial x} = 
\begin{bmatrix}
\frac{\partial P_x}{\partial \theta} \quad \frac{\partial P_x}{\partial t_x} \quad \frac{\partial P_x}{\partial t_y}
 \\\\
 \frac{\partial P_y}{\partial \theta} \quad \frac{\partial P_y}{\partial t_x} \quad \frac{\partial P_y}{\partial t_y}
\end{bmatrix}
$$
$$
\frac{\partial P_x}{\partial \theta} = -\sin \theta x_i - \cos \theta y_i \quad \quad \frac{\partial P_x}{\partial t_x} = 1 \quad \quad \frac{\partial P_x}{\partial t_y} = 0 \\\\
\frac{\partial P_y}{\partial \theta} = \cos \theta x_i - \sin \theta y_i \quad \quad \frac{\partial P_y}{\partial t_x} = 0 \quad \quad \frac{\partial P_y}{\partial t_y} = 1 \\\\ 
$$