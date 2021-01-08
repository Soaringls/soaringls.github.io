---
title: usage of vector's multi
date: 2020-07-08 11:07:05
mathjax: true
categories:
  - math
  - vector operation
tags:
  - math
---

#### 向量点乘
<!-- web-front not supprt \bold{a}, but support \mathbf{a} -->
- 二维向量
  $$
  \begin{aligned}
    \mathbf{\overrightarrow{a}} &= a_1\mathbf{i}+a_2\mathbf{j}\\\\
  \mathbf{\overrightarrow{b}} &= b_1\mathbf{i}+b_2\mathbf{j} \\\\
  \mathbf{\overrightarrow{a}}\cdot\mathbf{\overrightarrow{b}} &= a_1b_1\mathbf{i}+a_2b_2\mathbf{j}
  \end{aligned} \tag{1}
  $$
- 三维向量
  $$
  \begin{aligned}
    \mathbf{\overrightarrow{a}} &= a_1\mathbf{i}+a_2\mathbf{j}+a_3\mathbf{k}\\\\
  \mathbf{\overrightarrow{b}} &= b_1\mathbf{i}+b_2\mathbf{j}+b_3\mathbf{k}  \\\\
  \mathbf{\overrightarrow{a}}\cdot\mathbf{\overrightarrow{b}} &= a_1b_1\mathbf{i}+a_2b_2\mathbf{j}+a_3b_3\mathbf{k}
  \end{aligned}\tag{2}
  $$
#### 向量叉乘
- 三维向量
  $$
  \begin{aligned}
    \mathbf{\overrightarrow{a}} &= a_1\mathbf{i}+a_2\mathbf{j}+a_3\mathbf{k}\\\\
  \mathbf{\overrightarrow{b}} &= b_1\mathbf{i}+b_2\mathbf{j}+b_3\mathbf{k}  \\\\
  \mathbf{\overrightarrow{a}}\times\mathbf{\overrightarrow{b}} &= 
     \begin{bmatrix}
     \mathbf{i} & \mathbf{j}& \mathbf{k}\\\\
     a_1      & a_2     &a_3\\\\
     b_1      & b_2     &b_3
     \end{bmatrix} \\\\ &= (a_2b_3 - a_3b_2)\mathbf{i} + (a_3b_1 - a_1b_3)\mathbf{j} + (a_1b_2 - a_2b_1)\mathbf{k} \\\\
     &=
     \begin{bmatrix}       
     a_2 & a_3  \\\\        
     b_2 & b_3            
     \end{bmatrix}\mathbf{i} +
     \begin{bmatrix}       
     a_3 & a_1  \\\\        
     b_3 & b_1            
     \end{bmatrix}\mathbf{j}+
     \begin{bmatrix}       
     a_1 & a_2  \\\\        
     b_1 & b_2            
     \end{bmatrix}\mathbf{k}
  \end{aligned}\tag{3}
  $$
- 二维向量
  $$
  \begin{aligned}
    \mathbf{\overrightarrow{a}} &= a_1\mathbf{i}+a_2\mathbf{j}\\\\
  \mathbf{\overrightarrow{b}} &= b_1\mathbf{i}+b_2\mathbf{j}  \\\\
  \mathbf{\overrightarrow{a}}\times\mathbf{\overrightarrow{b}} &= 
     \begin{bmatrix}
     \mathbf{i} & \mathbf{j}& \mathbf{k}\\\\
     a_1      & a_2     &0\\\\
     b_1      & b_2     &0
     \end{bmatrix} \\\\ &=  (a_1b_2 - a_2b_1)\mathbf{k} \\\\
     &=
     \begin{bmatrix}       
     a_1 & a_2  \\\\        
     b_1 & b_2            
     \end{bmatrix}\mathbf{k}
  \end{aligned} \tag{4}
  $$