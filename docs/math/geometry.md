# 几何学
### 直线相关
- 斜截式
  
$$
\begin{gather}
y=kx+b \\\\
p(x_0,y_0)  \text{点到直线距离为} \quad D = \dfrac{|y_0 - kx_0 - b|}{\sqrt{1+k^2}}
\end{gather}
$$
  
- 一般式

$$
\begin{gather}
  Ax+By+C=0, \quad A、B不能同时为0 \\\\
  p(x_0,y_0) 点到直线距离为\quad D = \dfrac{|Ax_0 + By_0 + C|}{\sqrt{A^2+B^2}}
\end{gather}
$$ 
  
  
- 直线交点计算
  $$
  \begin{cases}
      A_1x+B_1y+C_1=0  \\\\
      A_2x+B_2y+C_2=0
  \end{cases}
  $$
  交点为
  $$
  \begin{cases}
  x = \dfrac{B_1C_2 - B_2C_1}{ A_1B_2 - A_2B_1} \\\\
  y = \dfrac{A_2C_1 - A_1C_2}{A_1B_2 - A_2B_1}
  \end{cases}
  $$


- 向量叉乘: 待定向量$A\nwarrow$,参考向量$R\uparrow$, 则

$$
  value =|A\times B |= A_xR_y - A_yR_x = 
  \begin{cases}
  < 0, \quad A位于R的左侧 \quad \nwarrow\uparrow\\\\
  > 0, \quad A位于R的右侧 \quad \uparrow\nearrow \\\\
  = 0, \quad A、R重叠 
  \end{cases}
$$ 

- 圆
  
$$
(x-a)^2 +(y-b)^2 = r^2, 圆心(a,b),半径r
$$

- 椭圆
  
$$
\dfrac{(x-h)^2}{a^2} + \dfrac{(y-k)^2}{b^2} = 1, 椭圆圆心(h,k), a为横半轴,b为纵半轴
$$