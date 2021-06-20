### ErrorState
$$
ErrorState=\begin{bmatrix}
VarType \quad error\_{var} \\\\
CovType \quad error\_state\_cov \quad state\_progation \quad propagated\_noise\_cov \\\\
double \quad beta\_{coefficient}
\end{bmatrix}
$$
### CoreState
$$
CoreState=\begin{bmatrix}
P \\\\
V \\\\
Q \\\\
Ba \\\\
Bg \\\\
ErrorState  \\\\ 
double \quad beta\_{coefficient}
\end{bmatrix}
$$