---
title: Linear Algebra
published: 2024-04-21T12:00:00Z
description: '关于3Blue1Brow-线性代数的本质的个人总结'
image: 'https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/1092830.jpg'
tags: ['Linear Algebra']
category: 'Math'
draft: false
---



[toc]

# 线性代数的本质

## 矩阵与线性变换

$$
A\vec{x} = \vec{v} \\
\vec{x} = \left( 
\begin{matrix}
2 \\
1
\end{matrix}
\right) \\
A = 
\left( 
    \begin{matrix}
    2 & 1\\
    1 & 1
    \end{matrix}
\right) \\
$$

### 线性变换

矩阵$A$，表示对$\vec{x}$向量的**线性变换**。$\vec{x}$表示以基向量$\vec{i} = (1, 0)^T, \vec{j} = (0, 1)^T$的向量$\vec{x} = 2\vec{i} + 1\vec{j}$。其中：$\vec{i} = (1, 0)^T, \vec{j} = (0, 1)^T$。

在经过$A$变换后，基向量改变为：$\vec{i} = (2, 1)^T,\vec{j} = (1, 1)^T$

因此$\vec{v}$为变换后的向量空间的向量$\vec{x} = 2\vec{i} + 1\vec{j} = (5, 3)^T$

### 行列式

表示对于一个矩阵的线性变换，变换后的空间，相比于原空间的改变程度。

如：在以基向量$\vec{i} = (1, 0)^T, \vec{j} = (0, 1)^T$的空间中，单个$\vec{i} = (1, 0)^T, \vec{j} = (0, 1)^T$所围成的空间大小为$1$

经过$A = 
\left( 
    \begin{matrix}
    2 & 1\\
    1 & 1
    \end{matrix}
\right)$的变换后，基向量改变为：$\vec{i} = (2, 1)^T,\vec{j} = (1, 1)^T$，单个$\vec{i} = (2, 1)^T,\vec{j} = (1, 1)^T$表示的空间大小为$5 = |A| \times 1$

### 逆矩阵

对与上列矩阵变换的一种逆变换，即从$\vec{v} \to \vec{x}$

### 秩

矩阵的列向量(column vector)所表示的列空间维数。

假设在三维向量空间中：对于满秩的一个矩阵变换A，表示对三维向量$\vec{v}$的一个变换

对于一个秩为2的矩阵变换，表示将三维向量压缩到三维向量空间的一个二维平面子空间上。

### 线性方程组的解

$$
A\vec{x} = \vec{v} \\
\vec{v} = \left( 
\begin{matrix}
2 \\
1 \\
1
\end{matrix}
\right) \\
A = 
\left( 
    \begin{matrix}
    2 & 1 & 1\\
    1 & 1 & 1\\
    1 & 1 & 1
    \end{matrix}
\right) \\
$$

$\vec{v}$为三维向量

#### 方程组唯一解

线性方程组有唯一解，表示能够找到一个三维向量$\vec{x}$通过三维空间内的矩阵变换得到$\vec{v}$

#### 方程组无解

如果矩阵$r(A) = 2$，表示一种二维的压缩变换，这种变换一定无法变化为三维向量，因此找不到一个向量能够变换为$\vec{v}$​，因此线性方程组无解。

#### 方程组无穷解

如果矩阵$r(A) = r(\bar{A}) = 2$，表示在三维空间中找到能够通过矩阵压缩变换A到二维向量$\vec{v}$​的一个向量，三维空间中能够压缩到二维向量的三维向量有无数个，因此有无穷解。

### 非方阵

### 点积

## 

