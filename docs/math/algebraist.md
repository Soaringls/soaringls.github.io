# 矩阵和向量

https://services.math.duke.edu/~jdr/ila/ila.pdf
https://github.com/QBobWatson/ila
https://services.math.duke.edu/~jdr/ila/systems-of-eqns.html

## 向量相关

note about operation of vector,such as dot and cross

<!--more-->
### 向量点乘
<!-- web-front not supprt \bold{a}, but support \mathbf{a} -->
$\mathbf{a} \cdot \mathbf{b}  = |a|\cdot |b|\cdot cos<a,b>$

- 二维向量
  
  $$
  \begin{aligned}
    \mathbf{\overrightarrow{a}} &= a_x\mathbf{i}+a_y\mathbf{j}\\\\
  \mathbf{\overrightarrow{b}} &= b_x\mathbf{i}+b_y\mathbf{j} \\\\
  \mathbf{\overrightarrow{a}}\cdot\mathbf{\overrightarrow{b}} &= a_xb_x\mathbf{i}+a_yb_y\mathbf{j}
  \end{aligned} \tag{1}
  $$

- 三维向量
  
  $$
  \begin{aligned}
    \mathbf{\overrightarrow{a}} &= a_x\mathbf{i}+a_y\mathbf{j}+a_z\mathbf{k}\\\\
  \mathbf{\overrightarrow{b}} &= b_x\mathbf{i}+b_y\mathbf{j}+b_z\mathbf{k}  \\\\
  \mathbf{\overrightarrow{a}}\cdot\mathbf{\overrightarrow{b}} &= a_xb_x\mathbf{i}+a_yb_y\mathbf{j}+a_zb_z\mathbf{k}
  \end{aligned}\tag{2}
  $$

### 向量叉乘

$\mathbf{a} \times \mathbf{b}  = |a|\cdot |b|\cdot sin<a,b>$

- 三维向量
  $$
  \begin{aligned}
    \mathbf{\overrightarrow{a}} &= a_x\mathbf{i}+a_y\mathbf{j}+a_z\mathbf{k}\\\\
  \mathbf{\overrightarrow{b}} &= b_x\mathbf{i}+b_y\mathbf{j}+b_z\mathbf{k}  \\\\
  \mathbf{\overrightarrow{a}}\times\mathbf{\overrightarrow{b}} &= 
     \begin{bmatrix}
     \mathbf{i} & \mathbf{j}& \mathbf{k}\\\\
     a_x      & a_y     &a_z\\\\
     b_x      & b_y     &b_z
     \end{bmatrix} \\\\ &= (a_yb_z - a_zb_y)\mathbf{i} + (a_zb_x - a_xb_z)\mathbf{j} + (a_xb_y - a_yb_x)\mathbf{k} \\\\
     &=
     \begin{bmatrix}       
     a_y & a_z  \\\\        
     b_y & b_z            
     \end{bmatrix}\mathbf{i} +
     \begin{bmatrix}       
     a_z & a_x  \\\\        
     b_z & b_x            
     \end{bmatrix}\mathbf{j}+
     \begin{bmatrix}       
     a_x & a_y  \\\\        
     b_x & b_y            
     \end{bmatrix}\mathbf{k}
  \end{aligned}\tag{3}
  $$

- 二维向量
  
  $$
  \begin{aligned}
    \mathbf{\overrightarrow{a}} &= a_x\mathbf{i}+a_y\mathbf{j}\\\\
  \mathbf{\overrightarrow{b}} &= b_x\mathbf{i}+b_y\mathbf{j}  \\\\
  \mathbf{\overrightarrow{a}}\times\mathbf{\overrightarrow{b}} &= 
     \begin{bmatrix}
     \mathbf{i} & \mathbf{j}& \mathbf{k}\\\\
     a_x      & a_y     &0\\\\
     b_x      & b_y     &0
     \end{bmatrix} \\\\ &=  (a_xb_y - a_yb_x)\mathbf{k} \\\\
     &=
     \begin{bmatrix}       
     a_x & a_y  \\\\        
     b_x & b_y            
     \end{bmatrix}\mathbf{k}
  \end{aligned} \tag{4}
  $$

## 矩阵相关
### 基础
- 乘法
  - 结合律: $(AB)C = A(BC), k(AB)=(kA)B=A(kB)$
  - 左分配律: $(A + B)C = AC + BC$
  - 右分配律: $C(A + B)C = CA + CB, k(A+B)=kA+kB$
  
### [转置wikipedia](https://zh.wikipedia.org/wiki/%E8%BD%AC%E7%BD%AE%E7%9F%A9%E9%98%B5)

#### 基础
- ${A^T}^T = A$
- $(A+B)^T = A^T+B^T$
- $(AB)^T=B^TA^T$, e.g $(ABC)^T=C^TB^TA^T$
- $(cA)^T=cA^T$
- $det(A)^T=det(A)$
#### 特殊转置矩阵
- 对称矩阵: 转置等于自身 $A^T=A$
- 正交矩阵: 转置等于逆 $GG^T=G^TG=I$
- 斜对称矩阵: 转置等于他的负矩阵 $A^T=-A$

### 反对称矩阵
向量$a = (a_1,a_2,a_3)$
反对称矩阵为
$$
a^\prime = 
\begin{bmatrix}
&0,&-a_3,&a_2 \\
&a_3,&0,&-a_1 \\
&-a_2,&a_1,&0
\end{bmatrix}
$$
### [逆矩阵转置wikipedia](https://zh.wikipedia.org/wiki/%E9%80%86%E7%9F%A9%E9%98%B5)

存在$B$使得$AB=BA=I$,则$A^{-1}=B$
#### 基础
- $(A^{-1})^{-1}=A$
- $(\lambda A)^{-1}=\dfrac{1}{\lambda} \times A^{-1}$
- $(AB)^{-1}=B^{-1}A^{-1}$
- $(A^T)^{-1}=(A^{-1})^T$
- $det(A^{-1})=\dfrac{1}{det(A)}$, det为行列式

### 矩阵分解
运行速度

$$
LU分解 > Cholesky分解 > QR分解 > 直接求逆
$$

#### LU分解
$A=LU$,其中$L$为下三角(主对角线下有值)，$U$为上三角(主对角线以上有值)

$$
\begin{gather}
Ax = (LU)x = L(Ux) =b \\\\
令y=Ux,则Ly=b
\end{gather}
$$

通过求解$y$使$Ly=b$,然后求解$x$使得 $Ux=y$

### 对称正定矩阵

对称正定矩阵是一类特殊的矩阵，具有以下两个关键性质：

1. **对称性（Symmetry）：** 矩阵是对称的，即矩阵的转置等于矩阵本身。

$$
   A^T = A
$$

2. **正定性（Positive Definite）：** 对于任意非零列向量 \(v\)，其二次型 \(v^TAv\) 的值都是正的。

   $v^TAv > 0, \text{ 对于所有非零列向量 } v$

这两个条件结合在一起，就定义了对称正定矩阵。

对称正定矩阵具有一些重要的性质和应用：

- **唯一解：** 线性方程组 $Ax = b$ 具有唯一解，其中 $A$ 是对称正定矩阵。
- **Cholesky 分解：** 对称正定矩阵可以通过 Cholesky 分解表示为 $A = LL^T$，其中 $L$ 是下三角矩阵。
- **最小值：** 对于二次型函数 $f(x) = x^TAx$，其中$A$是对称正定矩阵，这个函数在$A$的最小特征值对应的方向上达到最小值。

这些性质使得对称正定矩阵在数学、统计学、优化等领域中非常重要。在实际应用中，例如在数值计算和机器学习中，对称正定矩阵常常出现在协方差矩阵、Gram 矩阵等场景中。

### Ax=b求解，分情况讨论

https://zhuanlan.zhihu.com/p/44114447


>当我们讨论求解线性方程组Ax=b时，可以根据系数矩阵A的特性和向量b的特性，将问题分为以下几种情况进行讨论。

- 方程组有唯一解：当系数矩阵A是满秩的（即行满秩或列满秩），并且向量b位于A的列空间中时，方程组有唯一解。我们可以使用高斯消元法或矩阵的逆来求解唯一解。

- 方程组无解：当系数矩阵A的列空间与向量b的空间不相交时，方程组无解。这通常发生在矛盾的情况下，表示无法找到满足所有方程的解。

- 方程组有无穷解：当系数矩阵A不是满秩的时，方程组可能有无穷解。在这种情况下，我们可以使用高斯消元法或矩阵的特解加上齐次方程的通解来表示解的形式。

- 方程组存在近似解：当系数矩阵A是病态的（ill-conditioned），或者向量b存在测量误差时，方程组可能没有精确解。这时我们可以使用最小二乘法或其他数值方法来找到近似解。

总之，求解线性方程组Ax=b的方法取决于系数矩阵A的特性和向量b的特性，可以采用解析方法或数值方法来找到精确解或近似解。具体的求解方法要根据具体的问题和数值计算的要求来选择。
 