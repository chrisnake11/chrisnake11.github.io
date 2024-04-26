---
title: Multiple System & Quantum Information
published: 2024-04-25T14:00:00Z
description: '多量子系统下的Quantum Information，量子信息基础部分：基本概念、线性代数、量子逻辑门、量子通信'
image: ''
tags: ['Quantum Computing']
category: 'Quantum Computing'
draft: false
---

[toc]

# 多量子系统下的量子信息

## 状态信息表示

### 经典状态信息(Classical State)

假设有两个集合$\Sigma, \Gamma$​，$X, Y$分别是这两个集合中的元素。这两个集合可能相同也可能不同。
$$
X \in \Sigma \\
Y \in \Gamma
$$
对于这两个集合所能表示的信息的集合，可以用笛卡尔积表示(Cartesian product)。
$$
\Sigma \times \Gamma = \{(X, Y) | X \in \Sigma \land Y \in \Gamma \}
$$
其中：$(X, Y)$称为一个元组(tuple)。n个元素的元组叫做(n-tuple)

笛卡尔积中，元素的顺序按照集合原来的顺序进行排列。

> 例如：一个字符串，就是一系列字符集合的笛卡尔积中的某一个元素。$S \in {AlphaBet}^n$

### 概率状态信息(Probabilistic State)

给定两个相互独立的集合
$$
\Sigma, \Gamma, X \in \Sigma, Y \in \Gamma
$$
我们称$(X, Y)$是相互独立的，满足概率公式

$\forall a\in \Sigma, \forall b \in \Gamma \to Pr((X, Y) = (a, b)) = Pr(X = a)Pr(Y = b)$



关于$(X, Y)$的概率可以用一个向量表示:
$$
|\pi\rangle = \sum_{(a, b) \in \Sigma\times\Gamma}p_{ab}|ab\rangle
$$
$X, Y$各自的概率也可以使用向量表示
$$
|\phi\rangle = \sum_{a\in\Sigma}q_a|a\rangle \\
|\psi\rangle = \sum_{b\in\Gamma}q_b|b\rangle
$$
例如：对于两个相互独立的状态（不是量子态，不满足欧几里得范数为1）可以这样表示
$$
|\pi\rangle = \frac{1}{6}|00\rangle + \frac{1}{12}|01\rangle + \frac{1}{2}|10\rangle + \frac{1}{4}|11\rangle \\
|\phi\rangle = \frac{1}{4}|0\rangle + \frac{3}{4}|1\rangle \\
|\psi\rangle = \frac{2}{3}|0\rangle + \frac{1}{3}|1\rangle
$$

## 张量积

### 量子中的张量积

$$
|\psi\rangle \otimes | \phi \rangle = |\psi\rangle|\phi\rangle = |\psi\phi\rangle
$$

> 可以省略$\otimes$符号。

两个不同空间上两个量子向量张量积，可以表示两个不同**量子系统**上的量子叠加(Composite System)

对于两个量子比特$|0\rangle$ $|1\rangle$，两个量子的张量积矩阵可以表示为四维向量，每个矩阵对应一种比特组合
$$
|0\rangle \otimes |1\rangle = |0\rangle|1\rangle = |01\rangle
$$

$$
|00\rangle = \left[ \begin{matrix} 1 \\ 0 \end{matrix} \right] \otimes \left[ \begin{matrix} 1 \\ 0 \end{matrix} \right] =
\left[ \begin{matrix} 1 \\ 0 \\ 0 \\ 0 \end{matrix} \right]
$$

其余双量子比特同理。

### 矩阵之间的张量积

两个矩阵的张量积表示分别按顺序对于两个相互独立的系统，分别进行各自的变换。

例如：
$$
(X\otimes H)(|\phi\psi \rangle) = (X\otimes |\phi\rangle)(H \otimes |\psi\rangle)
$$


#### 例：对2-qubit的第2个qubit做NOT操作

$$
\frac{1}{\sqrt2}(|00\rangle + |11\rangle)
$$

要对第二个qubit进行$X=\left[ \begin{matrix} 0 & 1 \\ 1 & 0 \end{matrix} \right]$运算，只需要在前面加上关于$I$的张量积。
$$
(I \otimes X) \frac{1}{\sqrt2}(|00\rangle + |11\rangle) = \frac{1}{\sqrt2}(I|0\rangle \otimes X|0\rangle)\otimes(I|1\rangle \otimes X|1\rangle)
$$
表示第一个qubit进行$I$运算(**do nothing**)，第二个qubit进行$X$​运算。

## 多量子系统下的测量

### 任意处于叠加态的量子，在观测之后会以概率的形式坍缩到基向量

例如：$\Psi = \frac{1}{2}|0\rangle + \frac{\sqrt3}{2}|1\rangle$，就表示有$\frac{1}{2}$的概率测量为$|0\rangle$，$\frac{\sqrt3}{4}$的概率测量为$|1\rangle$​。

因此，我们可以把一个量子测量看成一个概率事件。对于多个qubit的系统，可以理解为多个iid事件。

多个量子系统之间的坍缩的情况使相互独立的。



 **That is, the probability for each particular outcome to appear when $X$ is measured cannot possibly depend on whether or not $Y$ was also measured, as that would otherwise allow for faster-than-light communication.**

**当我们对一个量子系统进行测量时，无论我们是否同时对另一个相关的物理量进行测量，我们对第一个量子系统测量结果的概率分布都不会受到影响。**



### 测量多量子系统中的单个量子系统

例如：我们可以通过计算，测量任意单个量子系统，得到另外一个量子系统坍缩的概率。
$$
|\Psi\rangle = \sqrt{\frac{1}{10}}|00\rangle + \sqrt{\frac{2}{10}}|01\rangle + \sqrt{\frac{3}{10}}|10\rangle + \sqrt{\frac{4}{10}}|11\rangle \\
= \sqrt{\frac{3}{10}}|0\rangle \otimes(\sqrt{\frac{1}{3}}|0\rangle + \sqrt{\frac{2}{3}}|1\rangle) + \sqrt{\frac{7}{10}}|0\rangle \otimes(\sqrt{\frac{3}{7}}|0\rangle + \sqrt{\frac{4}{7}}|1\rangle) \\
$$
+ 在测量的过程中，需要将向量的系数进行归一化，从而得到其中一个量子系统测量后，另一个量子系统坍缩的概率。（如：提取$\sqrt{\frac{3}{10}}$，使括号内部的向量变为基向量$|0\rangle, |1\rangle$

以上的qubit张量积可以类比成条件概率的形式，**系数的L2范数为概率**。
$$
P_\Psi(00) = \frac{1}{10}, P_\Psi(01) = \frac{2}{10}, P_\Psi(10) = \frac{3}{10P_\Psi(11)} = \frac{4}{10} \\
P_\Psi(0) = \frac{3}{10}, P_\Psi(1) = \frac{7}{10}
$$

#### 因此量子的测量可以理解为关于多个qubit的一个独立同分布的概率事件

### Projective Measurements

Projective measurements为一系列**投影矩阵且他们的和为Identity Matrix**所组成的一个矩阵**集合**。

#### **投影测量的意义：**

**对于一个multi-qubit system，如果测量部分qubit（比如其中的某一个qubit），此时整个量子系统必定会坍缩到某一个状态上，再向量的几何意义上体现为向量从$2^n$维度，降低（投影）到了$2^{n-1}$​的维度。因此坍缩为一个新的状态。此时的状态可以用新的公式表示。**

关于计算测量的概率：
$$
Pr(k) = ||\Pi_k |\psi\rangle||^2 = \langle \psi | \Pi_k | \psi \rangle
$$
由于$\Pi_k$是投影矩阵，因此会得到对应的$|0\rangle$向量。又因为$|0\rangle, |1\rangle$相互正交，从而可以得到： 
$$
\Pi_k |\psi \rangle = \alpha |0\rangle \implies
\langle \psi | \Pi_k | \psi \rangle = \langle \psi| \alpha |0\rangle = \alpha(\alpha \langle0|0\rangle + \beta \langle 0 | 1 \rangle) = ||\alpha||^2
$$
从而另外一个量子的状态可以利用这个概率进行归一化。
$$
\frac{\Pi_k |\psi\rangle}{||\Pi_k |\psi \rangle||}
$$

#### **归一化的意义：**

**在经过测量（投影变换）之后，新的量子状态向量中，基向量的系数不再满足欧几里得范数和为1，因此需要进行归一化，以满足量子状态向量的要求。**

### 在标准正交基下的 Projective Measurement

对于标准正交基向量，它自己的外积就是一个Projective matrix. 即：$| a \rangle \langle a |$

因此我们可以使用
$$
|||a\rangle\langle a|\psi\rangle||^2
$$
来表示$|\psi\rangle$在$\alpha$​基向量上的投影。

从而再进行归一化的到量子测量的结果:
$$
\frac{|a\rangle\langle a|\psi\rangle}{|||a\rangle\langle a|\psi\rangle||^2} = \frac{\alpha_a}{|\alpha_a|}|a\rangle
$$

## 叠加态/纠缠态(相互独立/线性相关)

一个量子系统能写成多个量子比特的张量积的形式，这个量子系统称作量子比特的叠加态。

反之，无法分解成张量积的形式，叫做量子比特的纠缠态

如：
$$
|00\rangle + |11\rangle \\
|01\rangle + |11\rangle = (|0\rangle + |1\rangle) \otimes |1\rangle
$$
前者是纠缠态，而后者是叠加态。

#### 为什么$|00\rangle + |11\rangle \\$就是纠缠态？

1. 这个量子系统由两个量子组成
2. 当第一个量子测量为$|0\rangle$，第二个量子肯定为$|0\rangle$，当第一个量子为$|1\rangle$第二个量子一定是$|1\rangle$。
3. 因此这两个量子关系十分紧密，处于一个相互纠缠的状态。

> 注：$|00\rangle + |11\rangle$ 也叫做最大纠缠态(maximum entangle state)。 

#### 叠加态$|01\rangle + |11\rangle$

1. 由上面可知，假设当第二个量子测量为$|1\rangle$，我们无法确定第一个量子到底是什么状态
2. 因此二者相互独立。处于一种叠加态。



## 多量子逻辑门

量子计算中的任意变化都是可逆的（酉矩阵）

**对于任意维度下的酉矩阵（对多个量子系统同时进行变换），都可以被表示为低维酉矩阵的张量积。表示同时对不同量子系统的进行各自变换。**

**因此多量子下的逻辑门是可以分解为多个单量子比特逻辑门的张量积。**

### Swap gate


$$
SWAP = \left[ 
    \begin{matrix}
    1 & 0 & 0 & 0 \\
    0 & 0 & 1 & 0 \\
    0 & 1 & 0 & 0 \\
    0 & 0 & 0 & 1 
    \end{matrix} 
\right]
$$

表示，对一个2-qubit，交换qubit。
$$
SWAP = \frac{I\otimes I + X \otimes X + Y \otimes Y + Z \otimes Z}{2}
$$


### Controlled gate(CU)

$$
CNOT = \left[ 
    \begin{matrix}
    1 & 0 & 0 & 0 \\
    0 & 1 & 0 & 0 \\
    0 & 0 & 0 & 1 \\
    0 & 0 & 1 & 0 
    \end{matrix}
\right] \\
CNOT = 
|0\rangle\langle0| \otimes I + |1\rangle\langle1|\otimes X = 
\left[ 
    \begin{matrix}
    1 & 0 \\
    0 & 0 \\
    \end{matrix}
\right] \otimes I +
\left[ 
    \begin{matrix}
    0 & 0 \\
    0 & 1 \\
    \end{matrix}
\right] \otimes U = 
\left[ 
    \begin{matrix}
    1 & 0 & 0 & 0 \\
    0 & 1 & 0 & 0 \\
    0 & 0 & 0 & 0 \\
    0 & 0 & 0 & 0 
    \end{matrix}
\right] + 
\left[ 
    \begin{matrix}
    0 & 0 & 0 & 0 \\
    0 & 0 & 0 & 0 \\
    0 & 0 & 0 & 1 \\
    0 & 0 & 1 & 0 
    \end{matrix}
\right]
$$

输入向量为$|11\rangle$，**CNOT**第一个bit表示控制比特，当为1时取执行NOT变换，后一个qubit取NOT（交换），从而得到$|10\rangle$

**同理：**CNOT，也可以将NOT部分修改为其他操作(必须是酉变换)，自定义对第二个qubit的操作。即：$CU$

### Toffoli gate(CCU)

$$
CCNOT = \left[ 
    \begin{matrix}
    1 & 0 & 0 & 0 & 0 & 0 & 0 & 0\\
    0 & 1 & 0 & 0 & 0 & 0 & 0 & 0\\
    0 & 0 & 1 & 0 & 0 & 0 & 0 & 0\\
    0 & 0 & 0 & 1 & 0 & 0 & 0 & 0\\
    0 & 0 & 0 & 0 & 1 & 0 & 0 & 0\\
    0 & 0 & 0 & 0 & 0 & 1 & 0 & 0\\
    0 & 0 & 0 & 0 & 0 & 0 & 0 & 1\\
    0 & 0 & 0 & 0 & 0 & 0 & 1 & 0\\
    
    \end{matrix} 
\right] \\
= |0\rangle\langle0| \otimes I \otimes I + |1\rangle\langle1| \otimes (|0\rangle\langle0| \otimes I + |1\rangle\langle1| \otimes X) \\
= |0\rangle\langle0| \otimes I \otimes I + |1\rangle\langle1| \otimes CNOT \\
= \left[ 
    \begin{matrix}
    1 & 0 & 0 & 0 & 0 & 0 & 0 & 0\\
    0 & 1 & 0 & 0 & 0 & 0 & 0 & 0\\
    0 & 0 & 1 & 0 & 0 & 0 & 0 & 0\\
    0 & 0 & 0 & 1 & 0 & 0 & 0 & 0\\
    0 & 0 & 0 & 0 & 0 & 0 & 0 & 0\\
    0 & 0 & 0 & 0 & 0 & 0 & 0 & 0\\
    0 & 0 & 0 & 0 & 0 & 0 & 0 & 0\\
    0 & 0 & 0 & 0 & 0 & 0 & 0 & 0\\
    
    \end{matrix} 
\right] + 
\left[ 
    \begin{matrix}
    0 & 0 & 0 & 0 & 0 & 0 & 0 & 0\\
    0 & 0 & 0 & 0 & 0 & 0 & 0 & 0\\
    0 & 0 & 0 & 0 & 0 & 0 & 0 & 0\\
    0 & 0 & 0 & 0 & 0 & 0 & 0 & 0\\
    0 & 0 & 0 & 0 & 1 & 0 & 0 & 0\\
    0 & 0 & 0 & 0 & 0 & 1 & 0 & 0\\
    0 & 0 & 0 & 0 & 0 & 0 & 0 & 1\\
    0 & 0 & 0 & 0 & 0 & 0 & 1 & 0\\
    
    \end{matrix} 
\right]
$$



