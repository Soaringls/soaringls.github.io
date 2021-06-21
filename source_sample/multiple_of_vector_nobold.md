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
- 二维向量
  $$
  \begin{aligned}
    \overrightarrow{a} &= a_1i+a_2j\\\\
    \overrightarrow{b} &= b_1i+b_2j \\\\
    \overrightarrow{a}\cdot \overrightarrow{b} &= a_1b_1i+a_2b_2j
  \end{aligned} \tag{1}
  $$
- 三维向量
  $$
  \begin{aligned}
    \overrightarrow{a} &= a_1i+a_2j+a_3k\\\\
    \overrightarrow{b} &= b_1i+b_2j+b_3k  \\\\
    \overrightarrow{a}\cdot\overrightarrow{b} &= a_1b_1i+a_2b_2j+a_3b_3k
  \end{aligned}\tag{2}
  $$
#### 向量叉乘
- 三维向量
  $$
  \begin{aligned}
    \overrightarrow{a} &= a_1i+a_2j+a_3k\\\\
    \overrightarrow{b} &= b_1i+b_2j+b_3k  \\\\
    \overrightarrow{a}\times\overrightarrow{b} &= 
     \begin{bmatrix}
     i & j& k\\\\
     a_1      & a_2     &a_3\\\\
     b_1      & b_2     &b_3
     \end{bmatrix} \\\\ &= (a_2b_3 - a_3b_2)i + (a_3b_1 - a_1b_3)j + (a_1b_2 - a_2b_1)k \\\\
     &=
     \begin{bmatrix}       
     a_2 & a_3  \\\\        
     b_2 & b_3            
     \end{bmatrix}i +
     \begin{bmatrix}       
     a_3 & a_1  \\\\        
     b_3 & b_1            
     \end{bmatrix}j+
     \begin{bmatrix}       
     a_1 & a_2  \\\\        
     b_1 & b_2            
     \end{bmatrix}k
  \end{aligned}\tag{3}
  $$
- 二维向量
  $$
  \begin{aligned}
    \overrightarrow{a} &= a_1i+a_2j\\\\
  \overrightarrow{b} &= b_1i+b_2j  \\\\
  \overrightarrow{a}\times\overrightarrow{b} &= 
     \begin{bmatrix}
     i & j& k\\\\
     a_1      & a_2     &0\\\\
     b_1      & b_2     &0
     \end{bmatrix} \\\\ &=  (a_1b_2 - a_2b_1)k \\\\
     &=
     \begin{bmatrix}       
     a_1 & a_2  \\\\        
     b_1 & b_2            
     \end{bmatrix}k
  \end{aligned} \tag{4}
  $$