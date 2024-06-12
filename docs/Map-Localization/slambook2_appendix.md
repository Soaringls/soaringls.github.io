# done-slambook2额外补充材料
## ch04 评估轨迹误差
估计轨迹 $T_{esti, i}$与真实轨迹 $T_{gt, i}$,其中$i=1,2,...,N$

- 绝对轨迹误差(ATE,absolute trajectory error)
  
$$
 \begin{align}
  ATE_{all} = \sqrt{\dfrac{1}{N}\sum_{i=1}^N} \cdot log(T_{gt,i}^{-1} \cdot T_{esti,i})^2 
 \end{align} 
$$ 

$$
\text{即每个李代数的均方根误差(RMSE,root-mean squar error)，反应两条轨迹旋转平移误差}
$$
 
  

- 绝对平移误差(ATE, Average Translated Error)
  
$$
 ATE_{trans} =  \sqrt{\dfrac{1}{N}\sum_{i=1}^N}(trans(T_{gt,i}^{-1} \cdot T_{esti,i}))^2
$$

- 相对位姿误差(RPE,Relative Pose Error)，考虑$i$到$i+\Delta t$时刻运动
  
$$
RPE_{all} = \sqrt{\dfrac
{1}{N-\Delta t} \cdot \sum_{i=1}^{N-\Delta t}log|(T_{gt,i}^{-1} \cdot T_{gt,i+\Delta t})^{-1}(T_{gt,i}^{-1} \cdot T_{gt,i+\Delta t})|^2}
$$

- 相对平移误差
  
$$
RPE_{all} = \sqrt{\dfrac
  {1}{N-\Delta t} \cdot \sum_{i=1}^{N-\Delta t}trans|(T_{gt,i}^{-1} \cdot T_{gt,i+\Delta t})^{-1}(T_{gt,i}^{-1} \cdot T_{gt,i+\Delta t})|^2}
$$

## ch06 手写高斯牛顿-code
[高斯牛顿实践-以视觉定位为例](loc_gauss_newton_example.md)

$$y=exp(ax^2 + bx + c) + w, \quad w \sim N(0, \sigma^2)$$

$N个x,y的观测点$,误差 $e_i = y_i - exp(ax_i^2 + bx_i + c)$

$$\min\limits_{a,b,c} \dfrac{1}{2} \sum_{i=1}^{N}|e_i|^2$$

$e_i$对状态变量(待优化变量: 即$a,b,c$)求导:

$$
\dfrac{\partial e_i}{\partial a} =  -x_i^2 \cdot exp(ax_i^2+bx_i+c) \\
\dfrac{\partial e_i}{\partial b} =  -x_i \cdot exp(ax_i^2+bx_i+c) \\
\dfrac{\partial e_i}{\partial c} =    exp(ax_i^2+bx_i+c) \\
$$

雅可比$Jacobian$矩阵 

$$
J_i = [\dfrac{\partial e_i}{\partial a},\dfrac{\partial e_i}{\partial b},\dfrac{\partial e_i}{\partial c}]^T
$$

$Gauss-Newton$的增量方程为 

$$
\big ( \sum_{i=1}^{100}J_i(\sigma ^2)^{-1} J_i^T \big) \Delta x_k  = \sum_{i=1}^{100}(-J_i(\sigma ^2)^{-1}e_i)
$$

## appendx 矩阵求导
### 标量函数对向量求导
向量$\overrightarrow{x} = \{x_1,x_2,...,x_m\}^T \in R^m$,$f(x)$为标量，则:

$$
\dfrac{df}{\partial \overrightarrow{x}} = [\dfrac{df}{\partial x_1},\dfrac{df}{\partial x_2}, ..., \dfrac{df}{\partial x_m}]^T \in R^m, \quad 为m \times 1的列向量，梯度或Jacobian
$$

而

$$
\dfrac{df}{\partial \overrightarrow{x}^T} = [\dfrac{df}{\partial x_1},\dfrac{df}{\partial x_2}, ..., \dfrac{df}{\partial x_m}] \in R^m, \quad 结果则为1 \times m的行向量
$$

### 向量函数对向量求导
向量函数$f(·)$为$n \times 1$维, 变量$x$为$m\times 1$维，
设$F(x)$为一个向量函数，$F(x)=[f_1(x),f_2(x),...,f_n(x)]^T$,其中每个$f(x)$都是一个自变量为向量，取值为标量的函数。

列向量函数对行向量进行求导

$$
\dfrac{\partial F}{\partial x^T} = \begin{bmatrix}
  \dfrac{\partial f_1}{\partial x^T} \\\\
  \dfrac{\partial f_2}{\partial x^T} \\\\
  .\\\\
  \dfrac{\partial f_n}{\partial x^T}
\end{bmatrix} 
= 
\begin{bmatrix}
    &\dfrac{\partial f_1}{\partial x_1},&\dfrac{\partial f_1}{\partial x_2},&\cdots,&\dfrac{\partial f_1}{\partial x_m} \\\\
    &\dfrac{\partial f_2}{\partial x_1},&\dfrac{\partial f_2}{\partial x_2},&\cdots,&\dfrac{\partial f_2}{\partial x_m} \\\\
    &\vdots, &\vdots, &\vdots, &\vdots,\\\\
    &\dfrac{\partial f_n}{\partial x_1},&\dfrac{\partial f_n}{\partial x_2},&\cdots,&\dfrac{\partial f_n}{\partial x_m} 
\end{bmatrix} \in R^{n \times m      }
$$

典型例子如 $\dfrac{\partial (Ax)}{\partial x^T} = A$, **求导前对被求导变量进行转置**

反之，一个行向量函数对列向量求导，则结果为上面结果的转置，即

$$\dfrac{\partial F^T}{\partial x} = (\dfrac{\partial F}{\partial x^T})^T$$