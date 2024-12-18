# 直线拟合
问题描述：给定一组带有噪声的数据点 $(x_1,y_1)、(x_2,y_2)、....、(x_n,y_n)$, 拟合直线 $y=ax+b$
## 最小二乘法
### 算法推导
- 构建最小化函数：$f= \sum_{i=1}^n (y_i - (ax_i + b))^2$ 
- 函数比较简单，没必要通过优化求解，可直接求解析解
  - 分别求$f$对 $a$ 和 $b$ 的偏导
  - 令偏导为0，解得 $a$ 和 $b$ 的值

$$
\begin{aligned}
\frac{\partial f}{\partial a} &= \sum_{i=1}^n -2(y_i - (ax_i + b))x_i = 0 \\
\frac{\partial f}{\partial b} &= \sum_{i=1}^n -2(y_i - (ax_i + b)) = 0 \\
\end{aligned}
$$

解方程组：

$$
\begin{bmatrix}
\sum_{i=1}^n x_i^2 & \sum_{i=1}^n x_i \\
\sum_{i=1}^n x_i & n \\
\end{bmatrix}
\begin{bmatrix}
a \\
b \\
\end{bmatrix}
=
\begin{bmatrix}
\sum_{i=1}^n x_iy_i \\
\sum_{i=1}^n y_i \\
\end{bmatrix}
$$
得到：

$$
\begin{aligned}
a &= \frac{\sum_{i=1}^n x_iy_i - \sum_{i=1}^n x_i\sum_{i=1}^n y_i}{\sum_{i=1}^n x_i^2 - (\sum_{i=1}^n x_i)^2} \\
b &= \frac{\sum_{i=1}^n y_i - a\sum_{i=1}^n x_i}{\sum_{i=1}^n n} \\
\end{aligned}
$$
### 代码实现
```cpp
#include <iostream>
#include <vector>
#include <cmath>

struct Point {
    double x, y;
};

// 计算直线拟合参数
void linearFit(const std::vector<Point>& points, double& a, double& b) {
    int n = points.size();
    double sum_x = 0, sum_y = 0, sum_xy = 0, sum_x2 = 0;

    // 计算所需的和
    for (const auto& point : points) {
        sum_x += point.x;
        sum_y += point.y;
        sum_xy += point.x * point.y;
        sum_x2 += point.x * point.x;
    }

    // 计算斜率a和截距b
    a = (n * sum_xy - sum_x * sum_y) / (n * sum_x2 - sum_x * sum_x);
    b = (sum_y - a * sum_x) / n;
}

int main() {
    // 示例数据点
    std::vector<Point> points = {
        {1, 2}, {2, 3}, {3, 5}, {4, 4}, {5, 6}
    };

    double a, b;
    linearFit(points, a, b);

    std::cout << "拟合直线方程为: y = " << a << "x + " << b << std::endl;

    return 0;
}
```

## RANSAC
### 算法原理
>RANSAC（随机采样一致性）是一种鲁棒拟合方法，特别适用于数据中存在大量噪声或离群值（outliers）的情况。与最小二乘法不同，RANSAC会迭代随机采样点集并找到最优模型，忽略离群值的干扰。

以下是使用 RANSAC 方法拟合直线的实现。

1. 随机从点集中抽取 最小数量的点集（直线拟合需要两个点）。
2. 用抽取的点计算模型参数（斜率m和截距b）。
3. 计算所有点到模型的距离，确定 内点集合（与模型误差在阈值范围内的点）。
4. 如果当前内点集合大小超过预设阈值，记录下该模型为候选模型。
5. 重复步骤 1-4，直到达到最大迭代次数或找到最优模型。
6. 返回包含最多内点的模型。
   
### 代码实现
```cpp

#include <cmath>
#include <iostream>
#include <random>
#include <utility>
#include <vector>

// 定义点结构
struct Point {
  double x;
  double y;
};

// 计算两点之间的距离
double pointToLineDistance(const Point& p, double m, double b) {
  // 点到直线 y = mx + b 的距离公式
  return std::abs(m * p.x - p.y + b) / std::sqrt(m * m + 1);
}

// 用两点拟合直线，返回斜率 m 和截距 b
std::pair<double, double> fitLineFromTwoPoints(const Point& p1,
                                               const Point& p2) {
  double m = (p2.y - p1.y) / (p2.x - p1.x);
  double b = p1.y - m * p1.x;
  return {m, b};
}

// RANSAC 算法拟合直线
std::pair<double, double> ransacFitLine(const std::vector<Point>& points,
                                        int maxIterations,
                                        double distanceThreshold,
                                        int minInliers) {
  int bestInlierCount = 0;
  std::pair<double, double> bestModel = {0.0, 0.0};

  std::random_device rd;
  std::mt19937 gen(rd());
  std::uniform_int_distribution<> dis(0, points.size() - 1);

  for (int iter = 0; iter < maxIterations; ++iter) {
    // 随机选择两个点
    int idx1 = dis(gen);
    int idx2 = dis(gen);
    if (idx1 == idx2) {
      continue;  // 如果两个点相同，则跳过本次迭代
    }

    auto [m, b] = fitLineFromTwoPoints(points[idx1], points[idx2]);

    // 计算内点数量
    int inlierCount = 0;
    for (const auto& p : points) {
      if (pointToLineDistance(p, m, b) <= distanceThreshold) {
        ++inlierCount;
      }
    }

    // 如果当前模型内点数量大于历史最佳，更新最佳模型
    if (inlierCount > bestInlierCount && inlierCount >= minInliers) {
      bestInlierCount = inlierCount;
      bestModel = {m, b};
    }
  }

  if (bestInlierCount < minInliers) {
    throw std::runtime_error(
        "Failed to find a valid model with enough inliers.");
  }

  return bestModel;
}

int main() {
  // 输入带噪声的点集
  std::vector<Point> points = {
      {1.0, 2.0},  {2.0, 4.1},  {3.0, 6.0}, {4.0, 8.2}, {5.0, 10.0},  // 直线点
      {6.0, 14.0}, {7.0, 15.0}, {8.0, 18.0}  // 离群点
  };

  try {
    int maxIterations = 100;
    double distanceThreshold = 1.0;
    int minInliers = 5;

    auto [m, b] =
        ransacFitLine(points, maxIterations, distanceThreshold, minInliers);
    std::cout << "Fitted Line using RANSAC: y = " << m << "x + " << b
              << std::endl;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
  }

  return 0;
}

```
## 贝叶斯方法
### 算法原理
>贝叶斯方法（Bayesian method）是一种基于概率论的统计学习方法，它利用先验知识和数据来估计后验概率，并据此做出预测或决策，本质上是通过对参数（如斜率m 和截距 b）建立概率分布来估计模型

后验 x 观测 = 先验 x 似然函数

贝叶斯直线拟合的核心思想如下：

- 模型假设：假设直线模型为 $y=mx+b+\epsilon$，其中 $\epsilon$ 为服从正态分布的噪声, $\epsilon \sim N(0, \sigma^2)$。
- 参数估计：m为直线的斜率，b为直线的截距，是需要估计都参数，噪声的方差 $\sigma^2$ 是未知的，但可以通过数据来估计。

贝叶斯框架如下：

- 先验分布(Prior)：先验分布$P(m,b)$表示在观测数据之前对参数$m,b$的置信度，假设$m,b$服从均值为0，方差分别为10的正态分布。
  
  正太分布函数如下：
$$
f(x) = \dfrac{1}{\sigma \sqrt{2\pi } } e^{- \dfrac{(x-\mu )^2}{2\sigma ^2} }
$$
  
  对于$m、b$,先验分布可写为：$P(m,b) = P(m) \cdot P(b)$
  
  两边取对数：

$$
\begin{align}
logP(m,b) &= log P(m) \cdot P(b) \\\\
&= logP(m)+logP(b) \\\\
&= -\dfrac{1}{2}(\dfrac{m^2}{10^2} + \dfrac{b^2}{10^2}) + log(2\pi \cdot \sigma^2)
\end{align}
$$ 

- 似然函数(Likelihood)：基于数据$D = {(x_i, y_i)}$ 推导模型参数的可能性，即 $P(D|m,b,\sigma)$表示在给定$m,b,\sigma$情况下，观测数据$D$的概率，在当前示例中假设数据点$y_i$服从均值为$mx_i+b$，标准差为$\sigma$的正太分布，则似然函数为：

$$
P(D|m,b,\sigma) =  {\textstyle \prod_{1}^{n}}\frac{1}{\sqrt{2\pi \sigma^2 } } exp(-\frac{(y_i - (x_im+b))^2}{2\sigma ^2} )
$$

两边同时取对数：

$$
\begin{align}
logP(D|m,b,\sigma) 
&= \sum_{1}^{n} log(\dfrac{1}{\sqrt{2\pi \sigma^2} }exp(-\dfrac{(y_i-mx_i-b)^2}{2\sigma^2})) \\\\
&= -\frac{n}{2}log(2\pi) - nlog(\sigma) - \dfrac{1}{2\sigma^2} \sum_{1}^{n}(y_i-mx_i-b)^2 \\\\
&= -\frac{n}{2} log(2\pi \cdot \sigma^2)- \dfrac{1}{2\sigma^2} \sum_{1}^{n}(y_i-mx_i-b)^2
\end{align}
$$ 

- 后验分布(Posterior)：基于似然函数和先验分布，计算得到后验分布 $P(m,b,\sigma|D) \propto P(D|m,b,\sigma)P(m,b,\sigma)$。
  
  两边同时取对数：

$$
\begin{align}
logP(m,b,\sigma|D) 
&= logP(D|m,b,\sigma) + logP(m,b,\sigma)
\end{align}
$$
  
- 采样估计：使用 MCMC（Markov Chain Monte Carlo） 或 变分推断 对后验分布进行采样，得到参数估计值

### 代码实现
```cpp
#include <cmath>
#include <iostream>
#include <random>
#include <utility>
#include <vector>

// 定义点结构
struct Point {
  double x;
  double y;
};

// 计算似然函数：P(D | m, b, sigma)
double likelihood(const std::vector<Point>& points, double m, double b,
                  double sigma) {
  double logLikelihood = 0.0;
  for (const auto& point : points) {
    double y_pred = m * point.x + b;
    double error = point.y - y_pred;
    logLikelihood += -0.5 * std::log(2 * M_PI * sigma * sigma) -
                     (error * error) / (2 * sigma * sigma);
  }
  return logLikelihood;
}

// 定义先验分布：P(m, b)
double prior(double m, double b) {
  // 假设 m 和 b 都服从 N(0, 10^2)
  double prior_m = -0.5 * (m * m) / (10 * 10);
  double prior_b = -0.5 * (b * b) / (10 * 10);
  return prior_m + prior_b;
}

// Metropolis-Hastings 采样
std::pair<double, double> bayesianFitLine(const std::vector<Point>& points,
                                          int iterations, double sigma) {
  // 初始化参数
  double m_current = 0.0, b_current = 0.0;
  double m_proposed, b_proposed;

  std::random_device rd;
  std::mt19937 gen(rd());
  
  //gaussian_distribution和normal_distribution一样，是一个早期的提案名称，它并没有被包含在最终的C++标准中,而normal_distribution在c++11标准中
  std::normal_distribution<double> proposal_dist(0, 0.1);  // 用于生成小扰动，均值为0，标准差为0.1的gaussian分布
  std::uniform_real_distribution<double> acceptance_dist(0, 1);//包括0但不包括1的均匀分布，即每个数出现的概率是相同的。这种分布通常用于生成决策或接受/拒绝机制中的随机数，比如在Metropolis-Hastings算法中用于决定是否接受一个提议的样本。
/*
在模拟或优化算法中，proposal_dist 可能用于生成新的候选解，而 acceptance_dist 则可能用于决定是否接受这个新的候选解，这是基于某种接受概率计算得出的。例如，在Metropolis-Hastings算法中，proposal_dist 生成的新状态和当前状态之间的差异会被评估，然后 acceptance_dist 会生成一个随机数来决定是否接受这个新状态。
*/

  double best_m = m_current, best_b = b_current;
  double best_posterior = likelihood(points, m_current, b_current, sigma) +
                          prior(m_current, b_current);

  for (int i = 0; i < iterations; ++i) {
    // 提议新的参数
    m_proposed = m_current + proposal_dist(gen);
    b_proposed = b_current + proposal_dist(gen);

    // 计算似然和先验
    double proposed_posterior =
        likelihood(points, m_proposed, b_proposed, sigma) +
        prior(m_proposed, b_proposed);
    double current_posterior = likelihood(points, m_current, b_current, sigma) +
                               prior(m_current, b_current);

    // 接受或拒绝新参数 acceptance_ratio = P(proposed) / P(current)
    double acceptance_ratio = std::exp(proposed_posterior - current_posterior);
    if (acceptance_dist(gen) < acceptance_ratio) {
      m_current = m_proposed;
      b_current = b_proposed;
    }

    // 更新最佳参数
    if (proposed_posterior > best_posterior) {
      best_posterior = proposed_posterior;
      best_m = m_current;
      best_b = b_current;
    }
  }

  return {best_m, best_b};
}

int main() {
  // 输入带噪声的点集
  std::vector<Point> points = {
      {1.0, 2.1}, {2.0, 4.0}, {3.0, 6.2}, {4.0, 8.3}, {5.0, 10.1}};

  try {
    int iterations = 10000;
    double sigma = 0.5;  // 假设噪声标准差为 0.5

    auto [m, b] = bayesianFitLine(points, iterations, sigma);
    std::cout << "Fitted Line using Bayesian Inference: y = " << m << "x + "
              << b << std::endl;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
  }

  return 0;
}

```

## PCA
### 算法原理
>PCA（Principal Component Analysis，主成分分析）是一种常用的降维方法，它通过分析数据集的协方差矩阵，将原始变量投影到一个新的空间中，使得各个变量的方差最大化，同时保持各个变量之间的相关性最小。

- 数据去中心化：计算数据点的均值，将所有点平移使其以均值为中心。
- 协方差矩阵计算：基于中心化后的数据计算协方差矩阵，描述数据的分布方向
- 特征值分解：对协方差矩阵进行特征值分解，得到各个特征向量和特征值，第一主成分（最大特征值对应的特征向量）指向点云的主方向
- 拟合直线参数：使用主方向（特征向量）和中心点确定直线

### 代码实现
```cpp 

#include <iostream>
#include <vector>

#include "Eigen/Dense"

// 定义点结构
struct Point {
  double x;
  double y;
};

// 使用 PCA 进行直线拟合
std::pair<double, double> fitLineUsingPCA(const std::vector<Point>& points) {
  if (points.size() < 2) {
    throw std::runtime_error("Need at least two points for line fitting.");
  }

  // 将数据中心化
  double mean_x = 0.0, mean_y = 0.0;
  for (const auto& p : points) {
    mean_x += p.x;
    mean_y += p.y;
  }
  mean_x /= points.size();
  mean_y /= points.size();

  // 构造中心化矩阵
  Eigen::MatrixXd data(points.size(), 2);
  for (size_t i = 0; i < points.size(); ++i) {
    data(i, 0) = points[i].x - mean_x;  // 中心化 x
    data(i, 1) = points[i].y - mean_y;  // 中心化 y
  }

  // 计算协方差矩阵：为了得到一个无偏估计（unbiased estimator），需要除以 n-1，而不是n
  Eigen::Matrix2d covariance = data.transpose() * data / (points.size() - 1);

  // 对协方差矩阵进行特征值分解
  Eigen::SelfAdjointEigenSolver<Eigen::Matrix2d> solver(covariance);
  Eigen::Vector2d principalDirection =
      solver.eigenvectors().col(1);  // 最大特征值对应的特征向量

  // 计算直线参数：斜率 m 和截距 b
  double m = principalDirection(1) / principalDirection(0);  // 斜率
  double b = mean_y - m * mean_x;                            // 截距

  return {m, b};
}

int main() {
  // 输入带噪声的点集
  std::vector<Point> points = {{1.0, 2.1},  {2.0, 4.0},  {3.0, 6.2},
                               {4.0, 8.3},  {5.0, 10.1}, {6.0, 12.0},
                               {7.0, 14.2}, {8.0, 16.3}, {9.0, 18.4}};

  try {
    auto [m, b] = fitLineUsingPCA(points);
    std::cout << "Fitted Line using PCA: y = " << m << "x + " << b << std::endl;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
  }

  return 0;
}

```