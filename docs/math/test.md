假设雷达水平视场角为 $\Beta$, 水平分辨率为 $r_{\beta}$, 垂直视场角为 $\Alpha$, 垂直分辨率为 $r_{\alpha}$, 对于点云中任意一点 $P(x,y,z)$, 其在图像系下坐标$P(u,v)$计算如下
$$
水平方位角  \quad \beta = arctan(\frac{y}{x}) \\\\
u = \frac{\Beta - \beta}{r_{\beta}} \\\\

P与雷达坐标系xy平面夹角 \quad \alpha =arctan(\frac{z}{ \sqrt{x^2+y^2}}) \\\\
v = 
\begin{cases}
      \frac{\Alpha  - \alpha}{r_{\alpha}} \quad z > 0 \\\\
      \frac{\Alpha  + \alpha}{r_{\alpha}} \quad z < 0 
\end{cases}
$$
