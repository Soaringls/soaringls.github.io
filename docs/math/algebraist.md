
https://services.math.duke.edu/~jdr/ila/ila.pdf
https://github.com/QBobWatson/ila
https://services.math.duke.edu/~jdr/ila/systems-of-eqns.html
### 矩阵基础
### 基础
- 乘法
  - 结合律: $(AB)C = A(BC), k(AB)=(kA)B=A(kB)$
  - 左分配律: $(A + B)C = AC + BC$
  - 右分配律: $C(A + B)C = CA + CB, k(A+B)=kA+kB$
  
### 转置
[https://zh.wikipedia.org/wiki/%E8%BD%AC%E7%BD%AE%E7%9F%A9%E9%98%B5]
#### 基础
- ${A^T}^T = A$
- $(A+B)^T = A^T+B^T$
- $(AB)^T=B^TA^T$, e.g $(ABC)^T=C^TB^TA^T$
- $(cA)^T=cA^T$
- $det(A)^T=det(A)$
#### 特殊转置矩阵
- 对称矩阵: 转置等于自身 $A^T=A$
- 正交矩阵: 转置等于逆 $GG^T=G^TG=I$
- 斜对称矩阵: 转置等于他的负矩阵 $A^T=-A$

### 反对称矩阵
向量$a = (a_1,a_2,a_3)$
反对称矩阵为
$$
a^\prime = 
\begin{bmatrix}
&0,&-a_3,&a_2 \\
&a_3,&0,&-a_1 \\
&-a_2,&a_1,&0
\end{bmatrix}
$$
### 逆矩阵
https://zh.wikipedia.org/wiki/%E9%80%86%E7%9F%A9%E9%98%B5

存在$B$使得$AB=BA=I$,则$A^{-1}=B$
#### 基础
- $(A^{-1})^{-1}=A$
- $(\lambda A)^{-1}=\frac{1}{\lambda} \times A^{-1}$
- $(AB)^{-1}=B^{-1}A^{-1}$
- $(A^T)^{-1}=(A^{-1})^T$
- $det(A^{-1})=\frac{1}{det(A)}$, det为行列式

### 矩阵分解
运行速度
$$LU分解 > Cholesky分解 > QR分解 > 直接求逆$$
#### LU分解
$A=LU$,其中$L$为下三角(主对角线下有值)，$U$为上三角(主对角线以上有值)
$$Ax = (LU)x = L(Ux) =b \\
令y=Ux,则Ly=b$$
通过求解$y$使$Ly=b$,然后求解$x$使得 $Ux=y$
