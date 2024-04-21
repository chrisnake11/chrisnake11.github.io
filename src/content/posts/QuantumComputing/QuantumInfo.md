---
title: Quantum Computing
published: 2024-04-20T10:00:00Z
description: 'Quantum Computing'
image: 'https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/quantumComputer.png'
tags: [Quantum Computing]
category: 'Quantum Computing'
draft: false
---

[toc]

# 量子信息(Quantum Infomation)

## 量子

一切能够释放能量的粒子都叫做量子。量子具有：量子相干、量子纠缠、量子叠加、量子不可克隆

- 其中量子相干和量子叠加是量子计算机并行计算的基础
- 量子纠缠和量子不可克隆是超高速信息传送和保密通信的基础。

一个粒子可以存在激活状态和基本状态，也可以存在于两个状态的叠加态之间。我们可以通过量子的状态来记录信息。

## 量子比特(qubit)

因为量子存在$| 0 \rangle$和$| 1 \rangle$(读作："**ket**")的一个线性组合的叠加状态上，因此可以用一个二维向量(vector)表示：
$$
| \Psi \rangle = \alpha \ 0 \rangle + \beta | 1 \rangle
$$
其中向量空间的基向量分别为$| 0 \rangle$ 和 $| 1 \rangle$，且$\alpha$ 和 $\beta$ 是任意复数，$\alpha \alpha^* + \beta\beta^* = 1$；$a^*$表示a的共轭复数（实部不变，虚部取负）

且基向量也可以看成二维向量：
$$
| 0 \rangle = \left(
    \begin{array}{c}
      1 \\
      0
    \end{array}
  \right), 
  | 1 \rangle = \left(
    \begin{array}{c}
      0 \\
      1
    \end{array}
  \right)
$$

## 线性代数

### 量子力学中的向量(vector)

$$
\langle\Psi | = \alpha^* \langle0 | + \beta^* \langle 1 |
$$

$\langle 0 | $ 和 $\langle 1 $ （读作: "**bra**")可以看成二维行向量
$$
\langle 0 | = (1, 0); \langle 1 | = (0, 1)
$$

### 内积(inner product)

$$
\langle \Psi_1 | \cdot | \Psi_2 \rangle  = \langle \Psi_1 | \Psi_2 \rangle = (\alpha^*, \beta^*) 
    \left(
        \begin{array}{c}
          \alpha \\
          \beta
        \end{array}
    \right)
= |\alpha|^2 + |\beta|^2 = 1
$$



### 张量积(tensor product)

#### 向量与向量(vector & vector)

#### 矩阵和矩阵(matrix & matrix)

### 外积(outer product)

#### 投影算符(projection operator)

### 特征值和特征向量(eigenvalues & eigenvectors)

#### 谱分解定理(spectral theorem)

完备性定理(Completeness relation)

### 幺正变换/酉变换(unitary transformation)

#### 关于任意轴的旋转(rotation)

$$
exp(i\alpha \hat{n} \cdot \vec{\delta}) = \cos(\frac{\alpha}{2})I + i\sin(\frac{\alpha}{2})\hat{n}\cdot\vec{\delta}
\\
\delta_x = X = 
\left( 
\begin{array}{c}
	0 & 1 \\
	1 & 0
\end{array}
\right) \\
\delta_y = Y = 
\left( 
\begin{array}{c}
	0 & -i \\
	i & 0
\end{array}
\right) \\
\delta_z = Z = 
\left( 
\begin{array}{c}
	1 & 0 \\
	0 & -1
\end{array}
\right)
$$

其中：$\hat{n}$表示旋转的轴向量，$\vec{\delta} = X\vec{x} + Y\vec{y} + Z\vec{z}$是一个Pauli matrices，$i$表示复数的虚部，$\alpha$表示旋转的角度

### 共轭转置(conjugate transpose)

$$
\langle 0 | = (1, 0); \langle 1 | = (0, 1)
$$

### 布洛赫球(Bloch sphere)

$$
| \Psi \rangle 
= e^{i \eta} \cos \frac{\theta}{2} | 0 \rangle + e^{i \phi} \sin \frac{\theta}{2} | 1 \rangle 
= e^{i \eta} (\cos \frac{\theta}{2} | 0 \rangle + e^{i (\phi - \eta)} \sin \frac{\theta}{2} | 1 \rangle)
$$

$e^{i \eta}$表示为向量在球上的一个偏角（见[欧拉公式 Euler's formula](https://en.wikipedia.org/wiki/Euler%27s_formula)）。在量子计算中，外部的(global)偏角，并不重要（Without loss of generality WLOG)，不失一般性，假设$\eta = 0$。因此可以简化为：
$$
| \Psi \rangle 
= \cos \frac{\theta}{2} | 0 \rangle + e^{i\phi} \sin \frac{\theta}{2} | 1 \rangle
\\
| \Psi \rangle = 
\left(
    \begin{array}{c}
      \cos\frac{\theta}{2} \\
      e^{i \phi} \sin \frac{\theta}{2}
    \end{array}
  \right)
$$
其中，显然有：${\cos\frac{\theta}{2}}^2 + {\sin\frac{\theta}{2}}^2 = 1$，$e^{i \phi}$​表示为向量在球上的一个偏角。$\frac{\theta}{2}$表示向量$| 0 \rangle, | 1 \rangle$旋转的角度。

#### Pure State & mixed State

Pure State在布洛赫球表面上

Mixed State在球内部

## 量子操作符

### 量子逻辑门 

### 测量

## 量子编码

## Shor's Algorithm

