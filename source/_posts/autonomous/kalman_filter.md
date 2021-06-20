---
title: >-
  Introduction of Kalman Filter
date: 2020-12-31 19:22:23
mathjax: true
categories:
  - autonomous
  - algorithm
tags:
  - algorithm
---

The content mainly reference from [yongcongwang's IMM Prediction](https://blog.yongcong.wang/2020/10/29/autonomous/imm-for-prediction/)
The Kalman filter which was published by R.E.Kalman in 1960, is a set of mathematical equations that provides an efficient computational (recursive) means to estimate the state of a process, in a way that minimizes the mean of the squared error. <!--more-->The filter is very powerful in several aspects: it supports estimations of past, present, and even future states, and it can do so even when the precise nature of the modeled system is unknown.
## Basic Equations 
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

## The process to be estimated
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

## The computational origin of the filter
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

## The discrete Kalman Filter Algorithm
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

## Python of Kalman Filter
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