# ing-slam-lidar




## 计算PCA
武汉大学遥测学院博士paper

- 均值

$$
\bar{x} = \frac{1}{n}\sum_{i=1}^Nx_i
$$

- 方差

$$
S^2 = \frac{1}{n-1}\sum_{i=1}^N(x_i - \bar{x})^2
$$

对于一组点集$P_i=(x_i,y_i,z_i), i \in [0,N)$

$$
Cov(x,y,z) = \begin{bmatrix}
    &cov(x,x) &cov(x,y) &cov(x,z) \\
    &cov(y,x) &cov(y,y) &cov(y,z) \\
    &cov(z,x) &cov(z,y) &cov(z,z) 
\end{bmatrix}
$$

其中

$$
\begin{align}
cov(x,y) = cov(y,x) = \frac{1}{n-1}\sum_{i=1}^N(x_i - \bar{x})(y_i - \bar{y}) \\\\
cov(x,z) = cov(z,x) = \frac{1}{n-1}\sum_{i=1}^N(x_i - \bar{x})(z_i - \bar{z}) \\\\
cov(y,z) = cov(z,y) = \frac{1}{n-1}\sum_{i=1}^N(z_i - \bar{z})(y_i - \bar{y})    
\end{align} 
$$

 

根据$Cov(x,y,z)$求特征值、特征向量: 设$S = Cov(x,y,z)$, 存在$\lambda$ 与 $n$使得$\lambda n = S n$,则$\lambda$与$n$分别为$S$的特征值和特征向量
$S=Q\Sigma Q^{-1}$,其中$Q$为$S$的特征向量组成的矩阵, $\Sigma$为对角阵，对角线上元素为特征值