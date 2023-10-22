### 直线相关
- 斜截式
  $$y=kx+b$$
  点$p(x_0,y_0)$到直线距离为$D = \frac{|y_0 - kx_0 - b|}{\sqrt{1+k^2}}$
  
- 一般式
  $$Ax+By+C=0, \quad A、B不能同时为0$$ 
  点$p(x_0,y_0)$到直线距离为$D = \frac{|Ax_0 + By_0 + C|}{\sqrt{A^2+B^2}}$
  
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
  x = \frac{B_1C_2 - B_2C_1}{ A_1B_2 - A_2B_1} \\\\
  y = \frac{A_2C_1 - A_1C_2}{A_1B_2 - A_2B_1}
  \end{cases}
  $$
- 向量叉乘
  
  待定向量$A\nwarrow$,参考向量$R\uparrow$, 则
  $$
  value = A_xR_y - A_yR_x = 
  \begin{cases}
  < 0, \quad A位于R的左侧 \quad \nwarrow\uparrow\\\\
  > 0, \quad A位于R的右侧 \quad \uparrow\nearrow \\\\
  = 0, \quad A、R重叠 
  \end{cases}
  $$ 

- 圆
  
  $(x-a)^2 +(y-b)^2 = r^2, 圆心(a,b),半径r$
- 椭圆
  
  $\frac{(x-h)^2}{a^2} + \frac{(y-k)^2}{b^2} = 1, 椭圆圆心(h,k), a为横半轴,b为纵半轴$