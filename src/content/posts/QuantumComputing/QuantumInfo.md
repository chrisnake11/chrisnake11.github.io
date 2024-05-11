---
title: Quantum Information
published: 2024-05-02T10:00:00Z
description: 'Quantum Information，量子信息基础部分：基本概念、线性代数（转置、酉变换、张量积、内积、投影矩阵、投影测量）、单量子逻辑门、量子特性（全局相位无关、不可克隆、纠缠不可拆分）'
image: ''
tags: ['Quantum Computing']
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

基向量表示：一个量子处于0/1的一种叠加态中，其中系数表示量子通过测量后坍缩到某个0或者1态下的概率。

## 线性代数

### 量子力学中的向量(vector)

$$
\langle\Psi | = \alpha^* \langle0 | + \beta^* \langle 1 |
$$

对于量子比特(qubit)，$\langle 0 | $ 和 $\langle 1 $ （读作: "**bra**")可以看成二维行向量，特别的：
$$
\langle 0 | = (1, 0); \langle 1 | = (0, 1)
$$

### 共轭转置(conjugate transpose)

对矩阵A,$A^\dagger$(A dagger)表示将矩阵A转置为$A^T$，然后对每个元素取共轭(将虚部取反)。
$$
A = 
\left[
    \begin{matrix}
	1 & -2-i & 5 \\
	1+i & i & 4-2i
    \end{matrix}
\right] \\

A^\dagger = 
\left[
    \begin{matrix}
	1 & 1-i \\
	-2+i & -i \\
	5 & 4+2i
    \end{matrix}
\right] \\
$$

### 幺正变换/酉变换(unitary transformation)

如果]$AA^{\dagger} = I$，则称矩阵$A$是一个酉变换.

同时也可以推出，对于酉变换矩阵$A$
$$
A^\dagger = A^{-1}
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

### 张量积(tensor product)

#### 向量与向量(vector & vector)

$$
\left[ \begin{matrix} a_1 \\ b_1 \end{matrix} \right] \otimes \left[ \begin{matrix} a_2 \\ b_2 \end{matrix} \right] = 
\left[
\begin{matrix} a_1 \otimes \left[ \begin{matrix} a_2 \\ b_2 \end{matrix} \right] \\
b_1 \otimes \left[ \begin{matrix} a_2 \\ b_2 \end{matrix} \right] \end{matrix} 
\right] = 
\left[
\begin{matrix} a_1a_2 \\ a_1b_2 \\ b_1a_2 \\ b_1b_2\end{matrix} 
\right]
$$



#### 矩阵和矩阵(matrix & matrix)

![image-20240423092856117](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/tensor-product.png)

假设$A$矩阵为单位矩阵$I$，那么**左乘单位矩阵**，可以**提高矩阵的维度**。

如上公式，由于矩阵$A$是二维的，从而把矩阵$B$​提高到了4维矩阵。

### 内积(inner product)

#### 对于一个2-dimension 向量，他的内积可以写成如下的形式：

$$
|\Psi\rangle =  (\alpha, \beta)^T \\
\langle \Psi | \cdot | \Psi \rangle  = \langle \Psi | \Psi \rangle = (\alpha^*, \beta^*) 
    \left(
        \begin{array}{c}
          \alpha \\
          \beta
        \end{array}
    \right)
= |\alpha|^2 + |\beta|^2 = 1
$$

>  $\alpha^*$表示$\alpha$的共轭复数

#### 拓展为n-dimension vector

假设向量表示为若干个standard basis vector的线性组合：$|\phi\rangle = \sum{\alpha_a |a\rangle}$​

那么这个向量的内积可以表示为$\langle \phi | \phi\rangle = \sum{\alpha_a^* \alpha_a \langle a | a \rangle} = \sum{\alpha_a^* \alpha_a}$​。标准正交基向量为单位向量，欧几里得范数为1.

对于两个在同一个空间中的向量$|\phi\rangle, |\psi\rangle$
$$
|\phi\rangle = \sum_{a\in\Sigma}{\alpha_a |a\rangle} \\
|\psi\rangle = \sum_{b\in\Sigma}{\alpha_b |b\rangle}
$$
二者的内积可以写成如下的形式：
$$
\langle\phi|\psi\rangle = \sum_{a\in\Sigma}\sum_{b\in\Sigma}{\alpha_a^*\alpha_b \langle a|b\rangle} = \sum_{a\in\Sigma}\alpha^*_a \alpha_a
$$

> 因为a和b都是标准正交基的向量，因此只有当a == b时，二者的内积为1；

#### 内积的几何意义

+ 在标准圆上的向量，向量的内积表示$\cos{\alpha}$，$\alpha$表示向量之间的夹角。

#### 正交orthogonal和标准正交化orthonormal

+ 两个向量正交：内积为0
+ 两个向量是标准正交基：内积为0，且自身是单位向量。
+ 施密特正交化(Schmitt Orthonormalization)

#### 标准正交基和酉矩阵的关系

+ 酉矩阵的所有行向量能够组成标准正交基
+ 酉矩阵的所有列向量能够组成标准正交基

利用酉矩阵和共轭转置的性质可以推出：
$$
U^\dagger U = I
$$

#### 投影矩阵 projection

将图像变投影到某个低维空间上。（对于已投影的图像，投影不再产生任何影响）

投影矩阵的要求

1. 是酉矩阵
2. 矩阵的n次幂等于自己（幂等律）

> 任意单位向量的outer product，都能够满足条件2。

例如：$\Pi = |\psi\rangle \langle \psi|$, $|\psi\rangle$为单位向量。零矩阵也是投影矩阵。

### Projective Measurements

在量子系统中，相比于标准正交投影矩阵，我们额外添加一个要求，即：所有矩阵的和为单位矩阵
$$
\sum_{i = 1}^{n}{\Pi_i} = I
$$

### Eular's formula



#### 单量子系统

假设对于单量子系统$\psi\rangle$，进行一次测量，测量的概率为$Pr(k)$，这可以表示为投影的形式
$$
Pr(k) = ||\Pi_k|\psi\rangle||^2
$$
在测量之后，这个量子状态坍缩为：
$$
<<<<<<< HEAD
\frac{\Pi_k |\psi\rangle}{||\Pi_k |\psi\rangle||^2}
=======
\frac{\Pi_k |psi\rangle}{||\Pi_k |\psi\rangle||^2}
>>>>>>> 98ec9df11b9c2120032a47cde86ad1b7d02477a0
$$

#### 多量子系统

我们可以类比单量子系统进行同样的操作。对于不需要操作的量子只需要在变换矩阵上$\otimes I$即可。

例如：在双量子系统上，我们一般使用Bell Basis来作为标准正交基。

Bell Basis基向量的外积，构成了2-qubit system下的投影矩阵。

## 单量子逻辑门

### Pauli matrices

Pauli-X gate，相当于经典的逻辑非门。表示$|0\rangle,|1\rangle$互换。
$$
\delta_x = X = 
\left[
\begin{array}{c}
	0 & 1 \\
	1 & 0
\end{array}
\right]
$$

Pauli-Y gate, 表示$|0\rangle, |1\rangle$互换，前者变为$i$倍，后者变为$-i$倍。
$$
\delta_y = Y = 
\left[ 
\begin{array}{c}
	0 & -i \\
	i & 0
\end{array}
\right] \\
$$
Pauli-Z gate，表示将$|1\rangle$取反。
$$
\delta_z = Z = 
\left[
\begin{array}{c}
	1 & 0 \\
	0 & -1
\end{array}
\right]
$$




其中：$\hat{n}$表示旋转的轴向量，$\vec{\delta} = X\vec{x} + Y\vec{y} + Z\vec{z}$是一个Pauli matrices，$i$表示复数的虚部，$\alpha$表示旋转的角度

### Hadamard matrix

将门的基本状态由$|0\rangle$变为$\frac{|0\rangle + |1 \rangle}{\sqrt 2}$，将$|1\rangle$变为$\frac{|0\rangle - |1\rangle}{\sqrt 2}$，前者一般称为$|+\rangle$正态，后者一般称为$|-\rangle$​负态。
$$
H = \frac{1}{\sqrt{2}} \left[ \begin{matrix} 1 & 1 \\ 1 & -1\end{matrix}\right] \\
H(|0\rangle, |1\rangle) = (|+\rangle, |-\rangle)
$$
其中，H是一个酉矩阵(unitary matrix)

推论：
$$
H^\dagger = H \\
H^\dagger H = I \\
HH = I
$$


从而有：
$$
H(|+\rangle, |-\rangle) = (|0\rangle, |1\rangle)
$$


特别：
$$
|+\rangle \langle+| + |-\rangle \langle-| = 
\left( \begin{matrix} \frac{1}{\sqrt2} \\ \frac{1}{\sqrt2} \end{matrix} \right)
\left( \begin{matrix} \frac{1}{\sqrt2} & \frac{1}{\sqrt2} \end{matrix} \right)
+ \left( \begin{matrix} \frac{1}{\sqrt2} \\ -\frac{1}{\sqrt2} \end{matrix} \right)
\left( \begin{matrix} \frac{1}{\sqrt2} & -\frac{1}{\sqrt2} \end{matrix} \right)
= \left( \begin{matrix} 1 & 0 \\ 0 & 1 \end{matrix} \right)
= I
$$


### Phrase shift gates

$$
P(\theta) = \left[ \begin{matrix} 1 & 0 \\ 0 & e^{i\theta} \end{matrix}  \right]
$$

$\theta$表示相位位移，将qubit的虚部变为$e^{i\theta}$​​倍。对应布洛赫球上的相位旋转(绕着$Z$轴旋转)
$$
Z = P(\pi) = \left[ \begin{matrix} 1 & 0 \\ 0 & -1 \end{matrix}  \right]\\
S = P(\frac{\pi}{2}) = \left[ \begin{matrix} 1 & 0 \\ 0 & e^{i\frac{\pi}{2}} \end{matrix}  \right]  = \left[ \begin{matrix} 1 & 0 \\ 0 & i \end{matrix}  \right] = \sqrt{Z} \\
T = P(\frac{\pi}{4}) = \left[ \begin{matrix} 1 & 0 \\ 0 & e^{i\frac{\pi}{4}} \end{matrix}  \right]  = \sqrt{S} = \sqrt[4]{Z}
$$

## 量子的性质

### 1. 全局相位不相关性

对于一个量子态，如果将他在全局范围（量子整体）乘以一个单位圆上定义的复数（Euler's formula）。不会改变这个量子态，换句话说，这两个量子态视为同一个。

在测量计算概率时，这个复数能够作为全局相位，在计算欧几里得范数（概率）时，结果为1，不会产生影响。

### 2. 量子不可克隆理论

完美克隆一个任意状态的量子比特是不可能的。

假设存在两个相互纠缠的量子比特$X, Y$，二者共享一个经典比特信息。假设$(X, Y) = |\psi\phi\rangle$

不存在酉矩阵$U$，$\forall |\psi\rangle \in X$，使得状态$Y$能够变为$X$的副本。
$$
U|\psi\rangle \otimes| \phi\rangle = |\psi\rangle \otimes |\psi\rangle
$$

#### 证明

假设存在两个不同的量子态$a, b \in \Sigma, a \neq b$，假设存在酉矩阵$U$能够满足上述的变换。那么对于$X$的任意状态$|a\rangle, |b\rangle$，必有
$$
U(|a\rangle \otimes |\phi\rangle) = |a\rangle \otimes |a \rangle \\
U(|b\rangle \otimes |\phi\rangle) = |b\rangle \otimes |b \rangle
$$
对于量子态向量的线性组合。根据张量积的线性性质可以得到：
$$
U((\frac{1}{\sqrt2}|a\rangle + \frac{1}{\sqrt2}|b\rangle) \otimes |\phi\rangle) = \frac{1}{\sqrt2}|a\rangle \otimes |a\rangle + \frac{1}{\sqrt2}|b\rangle \otimes |b\rangle
$$
然而对于这个线性组合的整体来说
$$
U((\frac{1}{\sqrt2}|a\rangle + \frac{1}{\sqrt2}|b\rangle) \otimes |\phi\rangle) = 
(\frac{1}{\sqrt2}|a\rangle + \frac{1}{\sqrt2}|a\rangle) \otimes (\frac{1}{\sqrt2}|b\rangle + \frac{1}{\sqrt2}|b\rangle) \\
= \frac{1}{\sqrt2}|a\rangle \otimes |a\rangle + \frac{1}{\sqrt2}|a\rangle \otimes |b\rangle + \frac{1}{\sqrt2}|b\rangle \otimes |a\rangle + \frac{1}{\sqrt2}|b\rangle \otimes |b\rangle \\
\neq \frac{1}{\sqrt2}|a\rangle \otimes |a\rangle + \frac{1}{\sqrt2}|b\rangle \otimes |b\rangle
$$
对于线性组合整体的拷贝结果，和根据张量积线性性质得到的拷贝结果向矛盾。



结论：

1. 对于一个量子的完美拷贝是不可能的，但是可能实现允许部分误差(limited accuracy)的拷贝(approximate cloning)。

2. 对于任意状态(arbitrary state)的量子的拷贝是不可能的，但是**允许克隆处于标准基本态的量子**(standard basis state, $|0\rangle , |1\rangle$)，例如：使用CNOT。这并不与上一个结论相矛盾。

   > 因此，对于一个$|+\rangle$​​，使用CNOT操作实现拷贝，是不可能的。

其实，这一性质在probabilistic state也是相同的。假设你和另外一个人玩1~10的猜数游戏，你知道对方每个结果的可能性都是1/10，将对方抽象为一个模型。

那么你就可以同样拷贝这个模型，但是你们二者的模型实际上是不相同的。因为不可能做到你们二者的想法保持一致（即，每次想到的数字相同）



### 3. 非正交的量子态不能被完美的拆分（两个互不影响的量子态一定是相互正交的）

假设在量子电路中的0号qubit，存在两个相互正交的量子态$|\psi\rangle, |\phi\rangle$。

如果通过同一个酉矩阵变换$U$，对于$|\psi\rangle$得到$|0\rangle$，而$|\phi\rangle$得到$|1\rangle$。那么变换后的输出结果一定是相互正交的​。

又有，如果两个量子态通过同一个酉变换$U$，得到相互不同的结果$|0\rangle, |1\rangle$​，那么这两个量子态一定是正交的。



对于相互正交的量子态，我们可以使用投影矩阵来完美地区分他们，从而不产生混淆。
