### 非线性最小二乘(from slambook chapter 6.2)
#### 状态估计
机器人状态估计中已知输入数据 $\mathcal{u}$ 和观测数据 $\mathcal{x}$ 的条件下, 未知状态 $x$ 的条件概率分布为: $P(x|z,u)$, 当没有测量运动的传感器时相当于估计$P(x|z)$ 的条件概率分布(若忽略时序关系则可理解为一个SFM问题)
>求最大后验 $\simeq$ 求最大似然估计 $\to$ 最小化负对数(最小二乘问题)
- **利用贝叶斯法则**
$$
P(x|z) = \frac{P(z|x)P(x)}{P(z)}  \propto P(z|x)P(x)
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
  - 为最大化似 $x_k, y_j$, 然通常使用**最小化负对数**来求一个高斯分布的最大似然
    一般，对于一个任意的高斯分布 $x \sim N(\mu, \Sigma)$, 其概率密度函数$P(x) = \frac{1}{\sqrt{(2\pi)^N det(\Sigma)}}exp\left(-\frac{1}{2}(x - \mu)^T \Sigma^{-1} (x - \mu)\right)$
    取其负对数为: $-ln(P(x)) = \frac{1}{2}ln\left((2\pi)^N det(\Sigma)\right) + \frac{1}{2}(x - \mu)^T \Sigma^{-1} (x - \mu)$
  - **负对数式**的第一项与 $x$ 无关，直接略去, 则求状态的最大似然估计-->最小化右侧的二次型项，代入SLAM观测模型，等同于求
    $x^* = argmin \left((z_{k,j} - h(x_k, y_i))^T Q^{-1}_{k,j} (z_{k,j} - h(x_k, y_i)) \right)$ 
    等价于求噪声项(即误差)的最小二乘

#### 最小二乘问题
$$
\min\limits_{x}\frac{1}{2}|f(x)|^2
$$
未知自变量$x \isin \mathbb{R}^n$,$f$为一个任意的非线性函数,假设为$m$维:$f(x) \isin \mathbb{R}^m$。
- 解析形式求解: 令目标函数导数为零 $\frac{df}{d \mathbf{x}}=\mathbf{0}$,然后求解$\mathbf{x}$的最优解
- 优化求解:SLAM中的最小二乘问题导数形式比较复杂，使用迭代的方式从一个初始值出发，通过不断迭代更新当前的优化变量使目标函数下降
  1. 给定某个初始值$\mathbf{x}_0$
  2. 对于第$\mathcal{k}$次迭代，寻找一个增量$\Delta x_k$，使得$|f(x_k + \Delta x_k)|^2$达到极小值
  3. 若$\Delta x_k$足够小，则停止迭代
  4. 否则，令$x_{k+1} = x_k + \Delta x_k$
- 一阶和二阶梯度法
  将目标函数在 $x_k$ 附近泰勒展开
  $$
  f(x + \Delta)^2 = f(x)^2 + J(x)\Delta x + \frac{1}{2} \Delta x^T \mathbin{H} \Delta x
  $$
  $J$ 为 $f(x)^2$ 关于 $x$ 的导数(Jacobian矩阵)，而 $H$ 为二阶导数(Hessian矩阵)，保留泰勒展开的一阶或二阶项对应的求解方法则为一阶梯度或二阶梯度
  - 保留一阶梯度，增量方程为
    $$
    \Delta x^* = -J(x)
    $$
    直观意义简单，沿反向梯度方向前进即可，通常会计算该方向上的一个步长 $\lambda$, 以获得最快下降的方式--->**最速下降法**(过于贪心,容易走锯齿路线，增加迭代次数)
  - 保留二阶梯度，增量方程为
    $$
    \Delta x^* = argminf(x)^2 +J(x) \Delta x + \frac{1}{2} \Delta x^T \mathbin{H} \Delta x
    $$
    该等式令关于 $\Delta x$ 的导数为零，得增量方程为: $H \Delta x = -J  $  **牛顿法**(需计算$H$矩阵，一般比较困难)
  - **Gauss-Newton**(最优化算法最简单的方法之一, 将$f(x)$进行一阶泰勒展开，而非目标函数$f(x)^2$)
    $$
    f(x + \Delta x) \approx f(x) + J(x)\Delta x
    $$
    该式$J(x)$为$f(x)$关于$x$的导数，得线性最小二乘问题为:
    $$
    \Delta x^*_k = arg\min\limits_{\Delta x}\frac{1}{2} |f(x) + J(x)\Delta x|^2
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