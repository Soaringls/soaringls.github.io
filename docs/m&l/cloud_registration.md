# 点云配准

## note of pointmatcher

- target(ref-scan|pre-scan)和source(read-scan|cur-scan)去除质心
  
$$
\begin{align}
R^* = argmin \frac{1}{2} \sum_{i=1}^{n} \lVert q_t -  R q_s\rVert^2  
\end{align}
$$


$$
W = \sum \left( q_t q_s^T\right) = U  \Sigma V^T \to R = UV^T \qquad t = q_t - Rq_s
$$
 

- residuals可由`point->point`、`point->line`、`point->plane`
  
## PointMatcher
### ref 和 reading 去除质心
- `tf_refi_in_refmean`
- reference原点为ref
- 算法流程
  - T->init Identity Transform
  - 对reading做$T$变换,形成reading_reset
  - 对reading_reset中每个点在reference中寻找最邻近的点,并保存距离和index
### details
- ref's Normal
  >e.g $3 \times 277$

  $$
   \begin{bmatrix}
       x_1 &x_2 &... &x_n \\\\
       y_1 &y_2 &... &y_n \\\\
       z_1 &z_2 &... &z_n  
   \end{bmatrix}
  $$

- $reading \times ref's normal$, which is $277 \times 3 \cdot 3 \times 277$
  
  $$
    tmp = \begin{bmatrix}
        0 &-1 & 0 \\\\
        1 &0 & 0 \\\\
        0 & 0 &0
    \end{bmatrix} \times
    \begin{bmatrix}
        x_1 &x_2 &x_3  &... \\\\
        y_1 &y_2 &y_3  &... \\\\
        z_1 &z_2 &z_3  &...  
    \end{bmatrix} \to 
    \begin{bmatrix}
        -y_1 & -y_2 & -y_3 & ... \\\\
        x_1 &  x_2 &  x_3 & ... \\\\
        0 &  0 & 0 & ... 
    \end{bmatrix}\\\\
  $$
  
$$
\begin{align}
ret &= tmp^T \times ref's normal \quad is \quad N \times N, which \\\\
    &= \begin{bmatrix}
        -y1 & x1 & 0 \\\\
        -y2 & x2 & 0 \\\\
        -y3 & x3 & 0 \\\\
        ... & ... &... 
       \end{bmatrix} \times
       \begin{bmatrix}
          nx_1 & nx_2 & ... \\\\
          ny_1 & ny_2 & ... \\\\
          nz_1 & nz_2 & ... 
       \end{bmatrix} \\\\
    &=
       \begin{bmatrix}
        -y_1nx_1 + x_1ny_1 & elem_{12} & .....\\\\
        elem_{21} & -y_2nx_2 + x_2ny_2 & .....\\\\
        .... & ...&-y_nnx_n + x_nny_n
       \end{bmatrix}   
\end{align}
$$

---
  
  取$ret$的对角线,即为reading点云到ref's normal的距离(点到法向量的距离)
  $tmp2 = ret.diagonal.transpose = \begin{bmatrix}
      d1 & d2 & d3 & ...& d_n
  \end{bmatrix}$
 

- $A=WF \cdot F^t \to AX=b \qquad (4, 4) \times (4, 1) \to (4, 1)$

$$
A \cdot X = b \qquad \text{即如下}
$$

$$
  \begin{bmatrix}
       \sum_{i=1}^n d_i\cdot wd_i & & &  \\\\
       & \sum_{i=1}^nwnx_i\cdot nx_i & & \\\\
       & & \sum_{i=1}^nwny_i\cdot ny_i & \\\\
       & & & \sum_{i=1}^nwnz_i\cdot nz_i 
    \end{bmatrix} 
    \begin{bmatrix}
        yaw \\\\ X \\\\ Y \\\\ Z
    \end{bmatrix} = b
$$



$$
\begin{align}
b &= \underbrace{
        \begin{bmatrix}
            & tmp2 \cdot \omega(权重) \\\\
            nx_1 & nx_2 & ...\\\\
            ny_1 & ny_2 & ...\\\\
            nz_1 & nz_2 & ...
        \end{bmatrix}
    }_{WF} \times
    \underbrace{
        \begin{bmatrix}
            \Delta x_1 nx_1 + \Delta y_1 ny_1 + \Delta z_1 nz_1 \\\\
            \Delta x_2 nx_2 + \Delta y_2 ny_2 + \Delta z_2 nz_2 \\\\
            ...\\\\
        \end{bmatrix}
    }  \\\\
&=  -\underbrace{
         \begin{bmatrix}
             \sum_{i=1}^n d_i \cdot (\Delta x_i nx_i + \Delta y_i ny_i + \Delta z_i      nz_i) \\\\
             \sum_{i=1}^n nx_i \cdot (\Delta x_i nx_i + \Delta y_i ny_i + \Delta z_i      nz_i) \\\\
             \sum_{i=1}^n ny_i \cdot (\Delta x_i nx_i + \Delta y_i ny_i + \Delta z_i      nz_i) \\\\
             \sum_{i=1}^n nz_i \cdot (\Delta x_i nx_i + \Delta y_i ny_i + \Delta z_i      nz_i) 
         \end{bmatrix}
    }_{(4\times1)}
\end{align}
$$