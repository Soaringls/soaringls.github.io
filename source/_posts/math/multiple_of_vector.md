---
title: usage of vector's multi
date: 2020-07-08 11:07:05
mathjax: true
tags:
  - math
---
#### 向量点乘
- 二维向量
  $$
  \begin{aligned}
    \bold{\overrightarrow{a}} &= a_1\bold{i}+a_2\bold{j}\\
  \bold{\overrightarrow{b}} &= b_1\bold{i}+b_2\bold{j} \\
  \bold{\overrightarrow{a}}\cdot\bold{\overrightarrow{b}} &= a_1b_1\bold{i}+a_2b_2\bold{j}
  \end{aligned} \tag{1}
  $$
- 三维向量
  $$
  \begin{aligned}
    \bold{\overrightarrow{a}} &= a_1\bold{i}+a_2\bold{j}+a_3\bold{k}\\
  \bold{\overrightarrow{b}} &= b_1\bold{i}+b_2\bold{j}+b_3\bold{k}  \\
  \bold{\overrightarrow{a}}\cdot\bold{\overrightarrow{b}} &= a_1b_1\bold{i}+a_2b_2\bold{j}+a_3b_3\bold{k}
  \end{aligned}\tag{2}
  $$
#### 向量叉乘
- 三维向量
  $$
  \begin{aligned}
    \bold{\overrightarrow{a}} &= a_1\bold{i}+a_2\bold{j}+a_3\bold{k}\\
  \bold{\overrightarrow{b}} &= b_1\bold{i}+b_2\bold{j}+b_3\bold{k}  \\
  \bold{\overrightarrow{a}}\times\bold{\overrightarrow{b}} &= 
     \begin{bmatrix}
      \bold{i} & \bold{j}& \bold{k}\\
      a_1      & a_2     &a_3\\
      b_1      & b_2     &b_3
     \end{bmatrix} \\ &= (a_2b_3 - a_3b_2)\bold{i} + (a_3b_1 - a_1b_3)\bold{j} + (a_1b_2 - a_2b_1)\bold{k} \\
     &=
     \begin{bmatrix}       
      a_2 & a_3  \\        
      b_2 & b_3            
     \end{bmatrix}\bold{i} +
     \begin{bmatrix}       
      a_3 & a_1  \\        
      b_3 & b_1            
     \end{bmatrix}\bold{j}+
     \begin{bmatrix}       
      a_1 & a_2  \\        
      b_1 & b_2            
     \end{bmatrix}\bold{k}
  \end{aligned}\tag{3}
  $$
- 二维向量
  $$
  \begin{aligned}
    \bold{\overrightarrow{a}} &= a_1\bold{i}+a_2\bold{j}\\
  \bold{\overrightarrow{b}} &= b_1\bold{i}+b_2\bold{j}  \\
  \bold{\overrightarrow{a}}\times\bold{\overrightarrow{b}} &= 
     \begin{bmatrix}
      \bold{i} & \bold{j}& \bold{k}\\
      a_1      & a_2     &0\\
      b_1      & b_2     &0
     \end{bmatrix} \\ &=  (a_1b_2 - a_2b_1)\bold{k} \\
     &=
     \begin{bmatrix}       
      a_1 & a_2  \\        
      b_1 & b_2            
     \end{bmatrix}\bold{k}
  \end{aligned} \tag{4}
  $$