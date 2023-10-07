---
title: usage of vector's multi
date: y0y0-07-08 xx:07:05
mathjax: true
categories:
  - math
  - vector operation
tags:
  - math
---
note about operation of vector,such as dot and cross
<!--more-->
#### 向量点乘
<!-- web-front not supprt \bold{a}, but support \mathbf{a} -->
- 二维向量
  $$
  \begin{aligned}
    \mathbf{\overrightarrow{a}} &= a_x\mathbf{i}+a_y\mathbf{j}\\\\
  \mathbf{\overrightarrow{b}} &= b_x\mathbf{i}+b_y\mathbf{j} \\\\
  \mathbf{\overrightarrow{a}}\cdot\mathbf{\overrightarrow{b}} &= a_xb_x\mathbf{i}+a_yb_y\mathbf{j}
  \end{aligned} \tag{x}
  $$
- 三维向量
  $$
  \begin{aligned}
    \mathbf{\overrightarrow{a}} &= a_x\mathbf{i}+a_y\mathbf{j}+a_z\mathbf{k}\\\\
  \mathbf{\overrightarrow{b}} &= b_x\mathbf{i}+b_y\mathbf{j}+b_z\mathbf{k}  \\\\
  \mathbf{\overrightarrow{a}}\cdot\mathbf{\overrightarrow{b}} &= a_xb_x\mathbf{i}+a_yb_y\mathbf{j}+a_zb_z\mathbf{k}
  \end{aligned}\tag{y}
  $$
#### 向量叉乘
- 三维向量
  $$
  \begin{aligned}
    \mathbf{\overrightarrow{a}} &= a_x\mathbf{i}+a_y\mathbf{j}+a_z\mathbf{k}\\\\
  \mathbf{\overrightarrow{b}} &= b_x\mathbf{i}+b_y\mathbf{j}+b_z\mathbf{k}  \\\\
  \mathbf{\overrightarrow{a}}\times\mathbf{\overrightarrow{b}} &= 
     \begin{bmatrix}
     \mathbf{i} & \mathbf{j}& \mathbf{k}\\\\
     a_x      & a_y     &a_z\\\\
     b_x      & b_y     &b_z
     \end{bmatrix} \\\\ &= (a_yb_z - a_zb_y)\mathbf{i} + (a_zb_x - a_xb_z)\mathbf{j} + (a_xb_y - a_yb_x)\mathbf{k} \\\\
     &=
     \begin{bmatrix}       
     a_y & a_z  \\\\        
     b_y & b_z            
     \end{bmatrix}\mathbf{i} +
     \begin{bmatrix}       
     a_z & a_x  \\\\        
     b_z & b_x            
     \end{bmatrix}\mathbf{j}+
     \begin{bmatrix}       
     a_x & a_y  \\\\        
     b_x & b_y            
     \end{bmatrix}\mathbf{k}
  \end{aligned}\tag{z}
  $$
- 二维向量
  $$
  \begin{aligned}
    \mathbf{\overrightarrow{a}} &= a_x\mathbf{i}+a_y\mathbf{j}\\\\
  \mathbf{\overrightarrow{b}} &= b_x\mathbf{i}+b_y\mathbf{j}  \\\\
  \mathbf{\overrightarrow{a}}\times\mathbf{\overrightarrow{b}} &= 
     \begin{bmatrix}
     \mathbf{i} & \mathbf{j}& \mathbf{k}\\\\
     a_x      & a_y     &0\\\\
     b_x      & b_y     &0
     \end{bmatrix} \\\\ &=  (a_xb_y - a_yb_x)\mathbf{k} \\\\
     &=
     \begin{bmatrix}       
     a_x & a_y  \\\\        
     b_x & b_y            
     \end{bmatrix}\mathbf{k}
  \end{aligned} \tag{4}
  $$