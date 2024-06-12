# 主成分分析PCA-TODO
>Principal Components Analysis


点云法向量的估计在很多场景都会用到，比如ICP配准，以及曲面重建。<br>
  基于PCA的点云法向量估计，其实是从最小二乘法推导出来的。假设我们要估计某一点的法向量，我们需要通过利用该点的近邻点估计出一个平面，然后我们就能计算出该点的法向量。或者可以这么说，通过最小化一个目标函数（要求的参数为法向量），使得该点与其每个近邻点所构成的向量与法向量的点乘为0，也就是垂直:<br>
$$
\mathop{min}\limits_{\mathbf{c},\mathbf{n},||\mathbf{n}||=1}=\sum\limits_{i = 1}^n(({x_i-c})^T{n})^2
$$
正常情况下，我们可以将点c看成是某一领域中所有点的中心点: <br>$m=\frac{1}{n}\cdot\sum\limits_{i = 1}^{n}X_i$
<br>$y_i=X_i-m$<br>
优化目标函数为:<br>
$$
\mathop{min}\limits_{||\mathbf{n}||=1}=\sum\limits_{i = 1}^n(y_i^T\cdot{n})^2 
$$
$
\mathop{min}\limits_{n^Tn = 1}\sum\limits_{i=1}^n(y_i^T\cdot{n})^2=\mathop{min}\limits_{n^Tn=1}\sum\limits_{i=1}^nn^Ty_iy_i^Tn=\mathop{min}\limits_{n^Tn=1}n^T(\sum\limits_{i=1}^ny_iy_i^T)n=\mathop{min}\limits_{n^Tn=1}n^T(YY^T)n
$
<br>

等同于$f(n)=n^TSn$, 其中$S=(YY^T)$,相当于
$\mathop{min(f(n))}\limits_{s\cdot{t}\cdot{n^Tn=1}}$<br>
其中$YY^T$是一个3×3的协方差矩阵(x,y,z坐标的协方差矩阵)，拉格朗日算法求解最后得:<br>
$$S\mathbf{n}=\lambda\mathbf{n}$$
对法向量(即特征向量) $\mathbb{n}$ 的求解就是要对 $S$ 进行向量分解，然后取特征值最小的特征向量作为求解的法向量(PCA的一个标准求解过程)

PCA的协方差矩阵的特征值越大，其特征向量就越能够描述数据的特征，越小就越不能区分样本之间的不同，也就是表征了数据中的共性。在目标函数中，就是要为所有的邻域点寻找一个平面，使得所有的邻域点都在这个平面上，或者说所有点与该平面的距离最小，而不是而不是最大