### 三维刚体运动
`四元数的共轭conjugate 即为其自身的逆`

$$
T =
\begin{bmatrix}
  R & t \\\\
  0^T & 1  
\end{bmatrix} 
\quad R^T = R^{-1} \quad \rightarrow \quad
T^{-1} =    
\begin{bmatrix}       
   R^T & -R^Tt \\\\       
   0^T & 1    
\end{bmatrix}
$$

### 反对称矩阵
$$
  \begin{aligned}
  \mathbf{\overrightarrow{a}}\times\mathbf{\overrightarrow{b}} &= 
     \begin{bmatrix}
     \mathbf{i} & \mathbf{j}& \mathbf{k}\\\\
     a_1      & a_2     &a_3\\\\
     b_1      & b_2     &b_3
     \end{bmatrix} \\\\ 
     &=\begin{bmatrix}
         a_2b_3 - a_3b_2 \\\\
         a_3b_1 - a_1b_3 \\\\
         a_1b_2 - a_2b_1
     \end{bmatrix}\\\\
     &=
     \begin{bmatrix}       
     0 & -a_3 & a_2  \\\\        
     a_3 & 0 & -a_1 \\\\
     -a_2 & a_1 & 0       
     \end{bmatrix} \cdot b  \\\\ &=\hat{\mathbf{a}} \cdot \mathbf{b},\quad \hat{\mathbf{a}}\text{即为a的反对称矩阵}
  \end{aligned}
  $$

### Camera
- 像素坐标`(u, v)`和相机坐标`(X, Y, Z)`的转换推导,$P_{wrold} = T(相机外参) \cdot P_{camera}$

$$
  \begin{bmatrix}
      u \\\\
      v \\\\
      1
  \end{bmatrix} = \dfrac{1}{Z}
  \begin{bmatrix}
      f_x & 0 & cx \\\\
      0 & f_y & cy \\\\
      0 & 0 & 1
  \end{bmatrix}
  \begin{bmatrix}
      X \\\\ Y \\\\ 1
  \end{bmatrix} = \dfrac{1}{Z} \cdot K\cdot T \cdot P_c 
  = \dfrac{1}{Z} \cdot K \cdot  P_w 
$$

$$
\begin{gather}
K为相机内参矩阵， T为路标点P_w对应的外参 \\\\ 
\rightarrow (用于先将路标点由世界系转到相机系,即P_c = RP_w +t),\\\\
\rightarrow 归一化相机坐标: P_c = (\dfrac{X}{Z}, \dfrac{Y}{Z},1), 像素坐标:P_{uv} = KP_c 
\end{gather}
$$
  

$$
\begin{gather}
\begin{cases} 
  u = \alpha X^\prime +cx \\\\ 
  v = \beta Y^\prime + cy \quad cx和cy的基本单位:pixel
\end{cases}  \\\\  \rightarrow
\begin{cases}
  u = \alpha \cdot f \cdot \dfrac{X}{Z} + cx \\\\
  v = \beta \cdot f \cdot \dfrac{Y}{Z} + cy \quad \alpha和\beta的基本单位:pixels/m
\end{cases}  \\\\  \rightarrow
\begin{cases}
  u = f_x \cdot \dfrac{X}{Z} +cx \\\\
  v = f_y \cdot \dfrac{Y}{Z} +cy
\end{cases}
\end{gather}
$$
 

- 双目

$$
  Z = \dfrac{fb}{d} \qquad 视差d越小 \to Z越大,即测距越远，同理基线b越大也是如此
$$

### 视觉里程计
- 2D-2D对极几何(计算求解: 旋转R 和 平移t) 

$$
\begin{gather}
    x^T_2 \hat{t} R x_1 = 0 \quad x_2和x_1为相机归一化坐标 \\\\
    本质矩阵 \quad E =\hat{t} R  \\\\
    P^T_2 K^{-T} \hat{t} R K^{-1} P_1 = 0 \quad 基础矩阵 F = K^{-T} \hat{t} R K^{-1}  
\end{gather}
$$ 

$$
  本质矩阵E在不同尺度下等价,因此与尺度无关。 特征点共面或相机纯旋转时E的自由度下降,即退化,因此一般同时估计基础矩阵$F$和单应性矩阵H,选取重投影误差比较小的作为最终的运动估计矩阵。
$$
 
  **单目slam初始化[旋转+平移]: 的2个image`must`有一定的平移量,而后的轨迹和地图都以此为单位**

- 三角化测量(计算求解: 路标点即地图点的空间位置)

  $$
  s_1 x_1  = s_2 R x_2 + t
  $$

### 非线性最小二乘
#### 状态估计
机器人状态估计中已知输入数据 $\mathcal{u}$ 和观测数据 $\mathcal{x}$ 的条件下, 未知状态 $x$ 的条件概率分布为: $P(x|z,u)$, 当没有测量运动的传感器时相当于估计$P(x|z)$ 的条件概率分布(若忽略时序关系则可理解为一个SFM问题)
>求最大后验 $\simeq$ 最大化似然和先验的乘积 $\simeq$ 最大化似然估计 $\to$ 最小化负对数(最小二乘问题)

- **利用贝叶斯法则**

$$
P(x|z) = \dfrac{P(z|x)P(x)}{P(z)}  \propto P(z|x)P(x)
$$

$$
后验P(x|z) * 常数(evidence)P(z)= 似然(likelihood)P(z|x) * 先验P(x)
$$

- 最大化后验概率(Maximize a Posterior,MAP): 

$$
x^*_{MAP} = argmax P(x|z) = argmax P(z|x)P(x)
$$

- 一般还不知道机器人大概的位置，此时没有了**先验**
  所以求**最大化后验概率**相当于求 $x$ 的**最大似然估计**(Maximize Likelihood Estimation,MLE)
`似然:在现在的姿态下，可能产生什么样的观测数据`
`最大似然估计:什么样的状态下，最可能产生当前的观测数据`---->等同于求最大后验

$$
x^*_{MLE} = argmax P(z|x)  
$$
  
- 对于观测模型 $z_{k,j} = h(y_j, x_k) + v_{k,j}$, 似然 $P(z|x) = N(h(y_j, x_k),Q_{k,j})$服从高斯分布,
  - 为了计算使得似然最大化的 $x_k, y_j$, 通常使用**最小化负对数**来求一个高斯分布的最大似然
    一般，对于一个任意的高纬度的高斯分布 $x \sim N(\mu, \Sigma)$, 其概率密度函数$P(x) = \dfrac{1}{\sqrt{(2\pi)^N det(\Sigma)}}exp\left(-\dfrac{1}{2}(x - \mu)^T \Sigma^{-1} (x - \mu)\right)$，
    取其负对数为: $-ln(P(x)) = \dfrac{1}{2}ln\left((2\pi)^N det(\Sigma)\right) + \dfrac{1}{2}(x - \mu)^T \Sigma^{-1} (x - \mu)$
  - **负对数式**的第一项与 $x$ 无关，直接略去, 则求状态的最大似然估计-->最小化右侧的二次型项，代入SLAM观测模型，等同于求
    $x^* = argmin \left((z_{k,j} - h(x_k, y_i))^T Q^{-1}_{k,j} (z_{k,j} - h(x_k, y_i)) \right)$ 
    等价于求噪声项(即误差)的最小二乘

#### 最小二乘问题
$$
\min\limits_{x}\dfrac{1}{2}|f(x)|^2
$$

未知自变量$x \in \mathbb{R}^n$,$f$为一个任意的非线性函数,假设为$m$维:$f(x) \in \mathbb{R}^m$。

- 解析形式求解: 令目标函数导数为零 $\dfrac{df}{d \mathbf{x}}=\mathbf{0}$,然后求解$\mathbf{x}$的最优解
- 优化求解:SLAM中的最小二乘问题导数形式比较复杂，使用迭代的方式从一个初始值出发，通过不断迭代更新当前的优化变量使目标函数下降
  1. 给定某个初始值$\mathbf{x}_0$
  2. 对于第$\mathcal{k}$次迭代，寻找一个增量$\Delta x_k$，使得$|f(x_k + \Delta x_k)|^2$达到极小值
  3. 若$\Delta x_k$足够小，则停止迭代
  4. 否则，令$x_{k+1} = x_k + \Delta x_k$
- 一阶和二阶梯度法
  将目标函数在 $x_k$ 附近泰勒展开
  
  $$
  f(x + \Delta)^2 = f(x)^2 + J(x)\Delta x + \dfrac{1}{2} \Delta x^T \mathbin{H} \Delta x
  $$
  
  $J$ 为 $f(x)^2$ 关于 $x$ 的导数(Jacobian矩阵)，而 $H$ 为二阶导数(Hessian矩阵)，保留泰勒展开的一阶或二阶项对应的求解方法则为一阶梯度或二阶梯度

  - **最速下降法**:保留一阶梯度，增量方程为
  
    $$
    \Delta x^* = -J(x)
    $$

    直观意义简单，沿反向梯度方向前进即可，通常会计算该方向上的一个步长 $\lambda$, 以获得最快下降的方式--->**最速下降法**(过于贪心,容易走锯齿路线，增加迭代次数)

    **反向梯度理解**：以开口向上抛物线为例，对称轴为$x=x_d, \quad 假设f(x)$在$x_k$导数为$\Delta_k$,
    
    - 当x位于$x_d$左侧时其导数(或梯度)$\Delta_k < 0$，若想朝y下降方向移动则x应该向右移动，即$x_{k+1}=x_{k}+(-\Delta_k)$;
    - 当x位于$x_d$右侧时其导数$\Delta_k > 0$，若想朝y下降方向移动则x应该向左移动，即$x_{k+1}=x_{k}+(-\Delta_k)$;

  - **牛顿法**:保留二阶梯度，增量方程为

    $$
    \Delta x^* = argminf(x)^2 +J(x) \Delta x + \dfrac{1}{2} \Delta x^T \mathbin{H} \Delta x
    $$

    该等式令关于 $\Delta x$ 的导数为零，得增量方程为: $H \Delta x = -J$  (需计算$H$矩阵，一般比较困难)

  - **Gauss-Newton**:(最优化算法最简单的方法之一, 将$f(x)$进行一阶泰勒展开，而非目标函数$f(x)^2$)

    $$
    f(x + \Delta x) \approx f(x) + J(x)\Delta x
    $$

    该式$J(x)$为$f(x)$关于$x$的导数，得线性最小二乘问题为:

    $$
    \Delta x^*_k = arg\min\limits_{\Delta x}\dfrac{1}{2} |f(x) + J(x)\Delta x|^2
    $$

    将最小二乘问题的目标函数$|f(x) + J(x)\Delta x|^2$对$\Delta x$求导并令导数为零得**增量方程(高斯牛顿方程GaussNewtonEquations或正规方程NormalEquations)**
    
    $$
    J(x)^T J(x) \Delta x = -J(x)f(x) \sim H \Delta x =g
    $$
    
    Gauss-Newton将$J^T J$作为牛顿法中二阶$Hessian$矩阵的近似，**求解增量方程是整个优化问题的核心**

  - Gauss-Newton算法步骤

    1. 给定某个初始值$x_0$
    2. 对于第$\mathcal{k}$次迭代，求出当前的Jacobian矩阵$J(x_k)$和误差$f(x_k)$
    3. 求解增量方程:$H \Delta x =g$
    4. 若$\Delta x_k$足够小，则停止。否则，令$x_{k+1} = x_k + \Delta x_k$,然后返回步骤2