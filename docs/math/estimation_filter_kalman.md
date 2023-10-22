https://en.wikipedia.org/wiki/Kalman_filter#Underlying_dynamic_system_model

| 表示  | 意义           |
| ----- | -------------- |
| $F_k$ | 状态转移模型   |
| $Q_k$ | 过程噪声协方差 |

卡尔曼滤波器模型假设k时刻的真实状态是 根据$k-1$处的状态演化而来,$w_k$是过程噪声,$w_k \sim N(0,Q_k)$
$$\hat{X}_{k}=F_kX_{k-1}+B_ku_k+w_k$$ 

| 表示  | 意义                                 |
| ----- | ------------------------------------ |
| $H_k$ | 观测模型，真实状态空间映射到观测空间 |
| $R_k$ | 观测噪声协方差                       |

在时间k 处，根据以下公式 对真实状态$X_k$进行观察（或测量）$Z_k$，$v_k$是观测噪声，$v_k \sim N(0, R_k)$

$$Z_k = H_kX_k+v_k$$

## 系统模型
### 预测
- 预测(先验)状态估计
  $$\hat{X}_{k|k-1}=F_kX_{k-1|k-1}+B_ku_k$$
- 预测(先验)估计协方差
  $$\hat{P}_{k|k-1}=F_kP_{k-1|k-1}F^T_k+Q_k$$

### 更新
- 创新/测量预拟合残差
  $$\tilde{y}_k=Z_k - H_k\hat{X}_{k|k-1}$$
- 创新/测量预拟合残差-协方差
  $$S_k = H_k\hat{P}_{k|k-1}H^T_k + R_k$$
- 最优卡尔曼增益
  $$K_k = \hat{P}_{k|k-1}H^T_kS^{-1}_k$$
- 更新(后验)状态估计
  $$X_{k|k}=\hat{X}_{k|k-1} + K_k\tilde{y}_k$$
- 更新(后验)估计协方差
  $$P_{k|k} = (I-K_kH_k)\hat{P}_{k|k-1}$$
- 测量拟合后残差
  $$\tilde{y}_{k|k} = Z_k - H_kX_{k|k}$$
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
&=cov[(I-K_kH_k)(x_k - \hat{x}_{k|k-1})-K_kv_k] \quad 测量误差 v_k与其他项不相关\\
&=cov[(I-K_kH_k)(x_k - \hat{x}_{k|k-1})]+ cov[K_kv_k] \\
&=(I-K_kH_k)cov(x_k - \hat{x}_{k|k-1})(I-K_kH_k)^T+ K_kcov(v_k)K_k^T \\
&=(I-K_kH_k)P_{k|k-1}(I-K_kH_k)^T+ K_kR_kK_k^T
\end{align}
$$