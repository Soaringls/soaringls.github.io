
# 状态估计-优化

## 常见函数

### 指数函数

$$
\begin{align}
a^{\frac{m}{n}} &= \sqrt[n]{a^m} \quad (a>0)\\
a^m \cdot a^n &= a^{m+n} \\
(a^m)^n &= a^{m\cdot n} \\
(a \cdot b)^n &= a^n \cdot b^n \\
(\frac{a}{b})^n &= (a \cdot b^{-1})^n = a^n \cdot b^{-n}
\end{align}
$$

### 泰勒展开

$f(x) \quad 在\quad x=a \quad$处$\quad n \quad$阶可导,则$f(x)在x=a的局部领域内符合如下$

$$
f(x) = f(a)+
{f}'(a)(x-a) + 
{f}''(a)\frac{(x-a)^2}{2!} + 
\dots + {f}^{(n)}(a)\frac{(x-a)^n}{n!}
$$

## 如何选择线性求解器
  - 对于密集雅可比的小规模问题(几百或几千) DENSE_QR
  - 对于一般稀疏性问题(雅可比大量为零) SPARSE_NORMAL_CHOLESKY (依赖SuitSparse|CXSparse)
  - 对于稀疏schur补或缩减相机矩阵的大型bundle adjustment问题，使用SPARSE_SCHUR(候补为 ITERATIVE_SCHUR)
  - 对于大型的bundle adjustment问题(几千相机以上), 使用ITERATIVE_SCHUR

## 第三方库

### GTSAM
note of gtsam by DongJing

开源C++库，提供各种SLAM算法，包括bundle adjustment、SLAM、视觉SLAM、SLAM优化、SLAM建图、SLAM地图构建、SLAM数据集、SLAM评估、SLAM可视化等。

 
#### SLAM as a Bayes Net

$$
\begin{aligned}
&\mathbf{P}(\mathbf{X,L,Z}) = P(x_0)\prod_{i=1}^MP(x_i|x_{i-1},u_i)\prod_{k=1}^KP(z_k|x_{ik},l_{jk}) \\\\\\\\
& x_i = f_i(x_{i-1},u_i)+w_i \Leftrightarrow \\\\ 
& P(x_i|x_{i-1},u_i)\propto exp-\frac{1}{2}||f_i(x_{i-1},u_i)-x_i||^2\Lambda_i  \\\\
&z_k=h_k(x_{ik},l_{jk})+v_k \Leftrightarrow \\\\
&P(z_k|x_{ik},l_{jk})\propto exp-\frac{1}{2}||h_k(x_{ik},l_{jk})-z_k||^2_{\sum_k}
\end{aligned}
$$ 

```
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
```

### Ceres
开源C++库，提供自动微分求解器，包括线性求解器、非线性求解器、曲率约束求解器、边缘约束求解器、边缘化约束求解器、凸优化求解器等。
### COLMAP
开源C++库，提供多视角SLAM、3D重建、SfM、3D建模、3D重建评估、3D重建可视化等。
### Open3D
开源C++库，提供3D点云处理、3D重建、3D建模、3D重建评估、3D重建可视化等。
