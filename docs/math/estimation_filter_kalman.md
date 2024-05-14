# 状态估计-滤波
## 卡尔曼滤波器wikipedia系统模型
https://en.wikipedia.org/wiki/Kalman_filter#Underlying_dynamic_system_model

[目标追踪: 匈牙利匹配和kalmanfilter详解-good](https://blog.csdn.net/dou3516/article/details/126479836)

[apollo匈牙利匹配](https://github.com/ApolloAuto/apollo/blob/master/modules/perception/common/graph/gated_hungarian_bigraph_matcher.h)

| 表示  | 意义           |
| ----- | -------------- |
| $F_k$ | 状态转移模型   |
| $Q_k$ | 过程噪声协方差 |

卡尔曼滤波器模型假设k时刻的真实状态是 根据$k-1$处的状态演化而来,$w_k$是过程噪声,$w_k \sim N(0,Q_k)$

$$
\hat{X}_{k}=F_kX_{k-1}+B_ku_k+w_k
$$ 

| 表示  | 意义                                 |
| ----- | ------------------------------------ |
| $H_k$ | 观测模型，真实状态空间映射到观测空间 |
| $R_k$ | 观测噪声协方差                       |

在时间k 处，根据以下公式 对真实状态$X_k$进行观察（或测量）$Z_k$，$v_k$是观测噪声，$v_k \sim N(0, R_k)$

$$Z_k = H_kX_k+v_k$$


### 预测
- 预测(先验)状态估计
  
$$
  \hat{X}_{k|k-1}=F_kX_{k-1|k-1}+B_ku_k
$$

- 预测(先验)估计协方差(预测协方差)
  
$$
  \hat{P}_{k|k-1}=F_kP_{k-1|k-1}F^T_k+Q_k
$$

### 更新
- 创新/测量预拟合残差
  
$$
  \tilde{y}_k=Z_k - H_k\hat{X}_{k|k-1}
$$

- 创新/测量预拟合残差-协方差(将协方差P映射到观测空间并加上观测噪声)
  
$$
  S_k = H_k\hat{P}_{k|k-1}H^T_k + R_k
$$

- 最优卡尔曼增益--->用于估计误差重要程度
  
$$
  K_k = \hat{P}_{k|k-1}H^T_kS^{-1}_k
$$

- [for next迭代] 更新(后验)状态估计
  
$$
  X_{k|k}=\hat{X}_{k|k-1} + K_k\tilde{y}_k
$$

- [for next迭代] 更新(后验)估计协方差
  
$$
  P_{k|k} = (I-K_kH_k)\hat{P}_{k|k-1}
$$

- 测量拟合后残差
  
$$
  \tilde{y}_{k|k} = Z_k - H_kX_{k|k}
$$

### 不变量
如果模型准确,且值$\hat{x}_{0|0}$和$P_{0|0}$准备反映初始状态值分布，则保留一下不变量

$$E[x_k - \hat{x}_{k|k}] =E[x_k - \hat{x}_{k|k-1}]=0$$

$$E[\tilde{y}_k]=0$$

$$P_{k|k} = cov(x_k - \hat{x}_{k|k})$$

$$P_{k|k-1} = cov(x_k - \hat{x}_{k|k-1})$$

$$S_k=cov(\tilde{y}_k)$$

### 推导后验估计协方差矩阵

$$
\begin{align}
P_{k|k} &= cov(x_k - \hat{x}_{x|k}) \\
&=cov[x_k - (\hat{x}_{k|k-1} + K_k\tilde{y}_k)] \\
&=cov[x_k - (\hat{x}_{k|k-1} + K_k(z_k - H_k\hat{x}_{k|k-1}))] \\
&=cov[x_k - (\hat{x}_{k|k-1} + K_k(H_kx_k+v_k - H_k\hat{x}_{k|k-1}))] \\
&=cov[(I-K_kH_k)(x_k - \hat{x}_{k|k-1})-K_kv_k] \quad \text{测量误差 v_k与其他项不相关}\\
&=cov[(I-K_kH_k)(x_k - \hat{x}_{k|k-1})]+ cov[K_kv_k] \\
&=(I-K_kH_k)cov(x_k - \hat{x}_{k|k-1})(I-K_kH_k)^T+ K_kcov(v_k)K_k^T \\
&=(I-K_kH_k)P_{k|k-1}(I-K_kH_k)^T+ K_kR_kK_k^T
\end{align}
$$


## ESKF
参见`Joan-Sola-1773-Quaternion-kinematics-for-the-error-state-Kalman-filter`的paper
### 优点
  - error-state最小轻量化,参数和自由度一样，但是避免了参数化冗余(即强约束计算时可能随之而来的协方差奇异性的问题)
  - error-state总是保持误差处在0值附近，避免潜在的参数奇异性、万向锁问题/ 能保证任何时刻有效线性化
  - error-state足够小,意味着其二阶导基本可忽略，Jacobian计算会很容易很快或者Jacobian是恒定的
  - todo

### ESKF基本介绍
状态量包括`true-state / nominal-state / error-state`
1. 高频IMU数据 $u_m$ 集成到`nominal-state` $x$, 不考虑噪声项目 $w$ 和其他扰动
2. 实时累计的误差集成到 `error-state`(由小的信号状态量构成,有时序的动态线性系统进行`correct`,用到的控制及测量矩阵由`nominal-state`计算) $\delta x$ 并用ESKF评估(包含了所有的噪声项和扰动)
3. `nominal-state`集成的同时,ESKF会`prdict`一个`error-state`的高斯估计
4. 精度高于IMU的`anchor-msg`(rtk/lidar/vision)到达时对`error—state`进行`correct`,从而计算出一个后验的`error-state`的高斯估计,最后将`error-state`的均值注入到`nominal-state`后重置为0,`error-state`的协方差.....


## 卡尔曼滤波(ycw)
The content mainly reference from [ycnw's IMM Prediction](https://blog.yongcong.wang/2020/10/29/autonomous/imm-for-prediction/)
The Kalman filter which was published by R.E.Kalman in 1960, is a set of mathematical equations that provides an efficient computational (recursive) means to estimate the state of a process, in a way that minimizes the mean of the squared error. <!--more-->The filter is very powerful in several aspects: it supports estimations of past, present, and even future states, and it can do so even when the precise nature of the modeled system is unknown.
### Basic Equations 
- overview 

$$
\begin{aligned}
    \underset{n \times 1}{X_k} &= \underset{n \times n}{A}\underset{n \times 1}{X_{k-1}} + \underset{n \times b}{B}   \underset{b \times 1}{U_{k-1}} + \underset{n \times 1}{w_{k-1}}\,(Q)\\\\
    \underset{m \times 1}{Z_k} &= \underset{m \times n}{H}\underset{n \times 1}{X_k} + \underset{m \times 1}{v_{k}}\,(R)  
\end{aligned}
$$

- predict

$$
\begin{aligned}
    \underset{n \times 1}{X_k^{pre}} &= \underset{n \times n}{A} \cdot \underset{n \times 1}{X_{k-1}} + \underset{n \times b}{B} \cdot \underset{b \times 1}{U_{k-1}}\\\\
    \underset{n \times n}{P_k^{pre}} &= \underset{n \times n}{A} \cdot \underset{n \times n}{P_{k-1}} \cdot \underset{n \times n}{A^T} + \underset{n \times n}{Q}
\end{aligned}
$$

<!-- $$
\begin{aligned}
    \underset{n \times n}{P^{pre}_k} will be wrong,it should be write as "\underset{n \times n}{P_k^{pre}}"
\end{aligned}
$$ -->
- correct
  
$$
\begin{aligned}
    \mathcal{K_{n \times m}} &= (P^{pre}_kH^T)  \cdot (HP^{pre}_kH^T + R)^{-1} \\\\
    X_k &= X^{pre}_k + \mathcal{K}(Z_k- HX^{pre}_k) \\\\
    P_k &= (I - \mathcal{K}H)P^{pre}_k
\end{aligned}
$$

### The process to be estimated
The Kalman filter addressed the general problem of trying to estimate the state $x\in \Re^n$ of a discrete-time controlled process that is governed by the linear stochastic difference equation:
$$
x_k = Ax_{k-1} + Bu_{k-1} + w_{k-1} \qquad p(w) \sim N(0, Q) \tag{1}
$$
with a measurement $z \in \Re^m$ that is:
$$
z_k = Hx_k + v_k \qquad p(v) \sim N(0,R) \tag{2}
$$
- The $n*n$ matrix $A$ is `transition matrix` which relates the state at the previous time step $k-1$ to the state at the current step $k$, in the absence of either a driving function or process noise. Note that in practice $A$ might change with each time step, but here we assume it is constant.
- The $n *1$ matrix $B$ is `control matrix` which relates the optional control input $u \in \Re^l$ to the state $x$.
- The $m *n$ matrix $H$ is `measurement matrix` which relates the state to the measurement $z_k$. In practice $H$ might change with each time step, but here we also assume it is constant.
- The random variable $w_{k-1}$ and $v_k$ represent the process and measurement noise. They are assumed to be independent(of each other), it belongs to gauss-white noise with normal probability distributions. and $Q$ is `process noise covariance` and $R$ is `measurement noise covariance`, they might change with each time step, but we assume they are both constant.

### The computational origin of the filter
We define $\hat{x}\_k^- \in \Re^n$ to be our `priori state` estimate at step $k$ given knowledge of the process priori to step $k$ and $\hat{x}\_k \in \Re^n$ to be our `posteriori state`  estimate at step $k$ given measurement $z_k$. we also define $x_k$ is the ground truth, then we can get a `priori` and a `posteriori` estimate errors as:
$$
prio\ estimate\ error: \ e\_k^- \equiv x\_k - \hat{x}\_k^-   \tag{3}
$$
$$
post\ estimate\ error:\ e\_k \equiv x\_k - \hat{x}_k \tag{4}
$$
The `priori` estimate error covariance is:
$$
P\_k^-  = E[e\_k^-(e\_k^-)^T] \tag{5}
$$
The `posteriori` estimate error covariance is:
$$
P\_k = E[e\_ke\_k^T] \tag{6}
$$
In deriving the equation for the kalman filter, we begin with the goal of finding an equation that compute an `posteriori` state estimate $\hat{x}\_k$ as a linear combination of the `priori` estimate $\hat{x}\_k^-$ and a weighted difference between an actual measurement $z\_k$ and a prediction of the measurement $H\hat{x}\_k^-$ as show below:
$$
\hat{x}\_k = \hat{x}\_k^- + K(z\_k - H\hat{x}\_k^-) \tag7
$$
The difference $(z\_k - H\hat{x}\_k^-)$ is called the measurement `innovation` or `residual`. The residual reflects the discrepency bewteen the predicted measurement $H\hat{x}\_k^-$ and the actual measurement $z_k$. A residual of zero means that the two are in complete agreement.
The $n*m$ matrix $K$ is chosen to be the `gain` or `blending factor` that minimizes the `posteriori` error covariance in (6).

This minimization can be accomplished by:
1. substituting (7) into the (4) and substituting that into (6);
2. performing the indicated expectation;
3. taking the derivative of the trace of the result with respect to $K$;
4. setting the result equal to $0$ and then solving for $K$.
One form of the resulting $K$ that minimized (6) is:

$$
\begin{aligned}
   K_k  &= P_k^-H^T(HP_k^-H^T \ +\ R )^{-1} \\\\
        &= \frac{P_k^-H^T}{HP_k^-H^T \ +\ R }
\end{aligned} \tag{8}
$$ 

Looking at (10) we see that as the `measurement error covariance` $R \to 0$, the gain $K$ weights the residual more heavily.Specially,
$$
\lim_{R_k \to 0}K_k = H^{-1} \tag{9}
$$
On the other hand, as the `priori estimate error covariance` $P_k^- \to 0$, the gain $K$ weights the residual less heavily.Specially,
$$
\lim_{P_k^- \to 0}K_k = 0 \tag{10}
$$

Another way of thinking about the weighting by $K$ is that as the measurement error covariance $R \to 0$, the actual measurement $z_k$ is `more trusted`, while the predicted mesaurement $H\hat{x}_k^-$ is `less trusted `. On the other hand, as the `priori estimate error covariance` $P_k^- \to 0$, the actual measurement $z_k$ is `less trusted`, while the predicted measurement $H\hat{x}_k^-$ is `more trusted`.

### The discrete Kalman Filter Algorithm
The kalman filter estimate a process by using a form of feedback control: the filter estimates the process state at some time and then obtains feedback in the form of (noisy) measurement. As such, the equations for the Kalman filter falls into two groups:
- `time update`(predict) equations;
- `measurement update`(correct) equations;

The `time update` equations are responsible for projecting forwar(in time) the current state and error covariance estimates to obtain the `prior` estimates for the next time step.

The `measurement update` equations are responsible for the feedback, incorporating a new measurement into the `priori estimate` to obtain an improved `posterori` estimate.

The final estimation algorithm resembles that of a `predictor->corrector` algorithm for solving numerical problems:
```
           Time Update -----> Measurement Update
            (Predict)             (Correct)
                ^                     |
                |                     |
                -----------------------
```
The specific equations for the `time update(predictor)` are:
$$
\hat{x}\_k^- = A\hat{x}\_{k-1} + Bu\_{k-1} \tag{11}
$$
$$
P_k^- = AP_{k-1}A^T + Q \tag{12}
$$
where:
- $\hat{x}\_{k-1}$ is the `posteriori` state from time step $k-1$; 
- $u\_{k-1}$ is the control from time step $k-1$;
- $\hat{x}\_k^-$ is the `priori` state from time step $k$;
- $P_{k-1}$ is the `posterirori` estimate error covariance from time step $k-1$;
- $P_k^-$ is the `priori` estimate error covariance from time step $k$;
  
The specific equations for the `measurement update(corrector)` are:

$$
K_k = P_k^-H^T \cdot (HP_k^-H^T + R)^{-1} \tag{13}
$$

$$
\hat{x}\_k = \hat{x}\_k^- + K_k\cdot (z_k - H\hat{x}\_k^-) \tag{14}
$$

$$
P_k= (I - K_kH) \cdot P_k^- \tag{15}
$$

where:
- $K_k$ is the `gain` from time step $k$;
- $z_k$ is the actual measurement variable from time step $k$;
- $\hat{x}\_k$ is the `posteriori` state from time step $k$;
- $P_k$ is the `posteriori` estimate error covariance from time step $k$;

### Python of Kalman Filter
```py
class KalmanFilter:
    def __init__(self, A, B, H, Q, R):
        self.A = A
        self.B = B
        self.H = H
        self.Q = Q
        self.R = R

        self.U = np.zeros((B.shape[1], 1))
        self.X = np.zeros((A.shape[0], 1))
        self.X_pre = self.X
        self.P = np.zeros(A.shape)
        self.P_pre = self.P

    def __init__(self, A, H):
        self.A = A
        self.X = np.zeros((A.shape[0], 1))
        self.B = np.eye(A.shape[0])
        self.U = np.zeros((self.B.shape[1], 1))
        self.Q = np.eye(A.shape[0])

        self.H = H
        self.R = np.eye(H.shape[0])

        self.X_pre = self.X
        self.P = np.zeros(A.shape)
        self.P_pre = self.P

    def filt(self, Z):
        """
        x = A*x + B*u +Q
        y = H*x +     R
        """
        self.__predict()
        self.__update(Z)
        return self.X

    def __predict(self):
        """
        x_next = A*x + B*u
        P_next = A*P*AT + Q
        """
        self.X_pre = np.dot(self.A, self.X) + np.dot(self.B, self.U)
        self.P_pre = np.dot(np.dot(self.A, self.P), self.A.T) + self.Q

    def __update(self, Z):
        """
        K = (P_next*HT) * (H*P_next*HT + R).inverse()
        x = x_next + K*(z - H*x_next)
        P = P_next - K*H*P_next
        """
        K = np.dot(np.dot(self.P_pre, self.H.T),
                   np.linalg.inv(np.dot(np.dot(self.H, self.P_pre), self.H.T) +
                                 self.R))
        self.X = self.X_pre + np.dot(K, Z - np.dot(self.H, self.X_pre))
        self.P = self.P_pre - np.dot(np.dot(K, self.H), self.P_pre)

```