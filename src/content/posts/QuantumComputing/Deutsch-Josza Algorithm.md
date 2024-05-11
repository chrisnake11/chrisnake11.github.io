---
title: Deutsch-Josza Algorithm
published: 2024-05-06T10:00:00Z
description: 'Deutsch-Josza算法介绍。认识量子计算机在特定情况下领先于传统计算机的特点。'
image: ''
tags: ['Quantum Computing']
category: 'Quantum Computing'
draft: false
---

## Deutsch's algorithm

读音：$dech, joza$。由Deutsch提出。

问题：假设有一个黑盒子$f()$，问题保证这个函数要么是常函数（输出恒为0、或者恒为1），要么是平衡函数（一半输出0，另一半输出1，每种输出的数量相同）。问题的任务是通过算法来预测函数$f()$是常函数还是平衡函数。

简化问题，假设输入为2bit，那么可能得结果对应四种函数：

| a    | f1(a) |
| ---- | ----- |
| 0    | 0     |
| 1    | 0     |

| a    | f2(a) |
| ---- | ----- |
| 0    | 0     |
| 1    | 1     |

| a    | f3(a) |
| ---- | ----- |
| 0    | 1     |
| 1    | 0     |

| a    | f4(a) |
| ---- | ----- |
| 0    | 1     |
| 1    | 1     |

对于每个输入执行函数$f(x)$，得到$f(0)f(1)$的输出结果序列，我们可以将Deutsch's Algorithm看成对于输出结果的每个bit进行XOR操作。

对于一串2bit的字符串，**使用传统的计算方法，需要进行两次查询**，即：对这2个bit分别进行一次$f()$函数的运算才能得到结果。

### Quantum Circuit

Deutsch's algorithm 需要2个qubit来实现。并且**只需要一次量子运算**就可以解决。

> 因为量子计算是并行的，我们一次$U_f$计算，同时对2个bit进行了运算。

通过化简，我们只可能观测到两种坍缩的量子状态，而这两种量子状态分别对应于函数$f(x)$​的两种类型（平衡函数或者常数函数）。

![image-20240511140458356](https://raw.githubusercontent.com/chrisnake11/picgo/main/blogimage-20240511140458356.png)

#### Phase kickback phenomenon(相位反馈现象)

在量子计算中，量子逻辑门的操作会导致测量结果收到非局部相位变化的影响。

> 非局部相位变化：

对于b和c的XOR，我们可以看成对b进行X operation.
$$
| b \oplus c \rangle = X^c | b \rangle
$$
同样的对于任意两个量子比特我们可以得到：
$$
U_f(|b\rangle |a\rangle) = |b\oplus f(a) | a\rangle = X^{f(|a\rangle)}|b\rangle |a\rangle
$$
因此存在：
$$
U_f(|-\rangle |a\rangle) = (X^{f(a)}|-\rangle)|a\rangle = (-1)^{f(a)}|-\rangle|a\rangle
$$

> $|- \rangle$ 是 X operation的特征向量，特征值为-1
> $$
> X|-\rangle = - |-\rangle
> $$

将上面的公式带入量子电路的推导：
$$
|\pi_2\rangle = U_f(|-\rangle|+\rangle) \\
= \frac{1}{\sqrt2}U_f(|-\rangle|0\rangle) + \frac{1}{\sqrt2}U_f(|-\rangle|1\rangle) \\
= \frac{1}{\sqrt2}|-\rangle((-1)^{f(0)}|0\rangle + (-1)^{f(1)}|1\rangle) \\
= \frac{1}{\sqrt2}|-\rangle (-1)^{f(0)}(|0\rangle + (-1)^{f(1)\oplus f(0)}|1\rangle)
$$
根据$f(1) \oplus f(0)$，我们能够得到两个不同的状态。



## Deutsch-Josza's Algorithm

Deutsch-Josza algorithm是对于Deutsch's algorithm的一种**扩展**，将作用函数$f()$变为有**n个bit输入**的函数。判断这个函数是平衡函数还是常函数。

![image-20240511143059745](https://raw.githubusercontent.com/chrisnake11/picgo/main/blogimage-20240511143059745.png)

对于这个逻辑门，如果测量结果全0，就是Constant Function，反之存在测量结果为1，就是Balanced Function。
$$
H|0\rangle = \frac{1}{\sqrt2}|0\rangle + \frac{1}{\sqrt2}|1\rangle \\
H|1\rangle = \frac{1}{\sqrt2}|0\rangle - \frac{1}{\sqrt2}|1\rangle 
$$
从而得到：
$$
\begin{align*}
	H|a\rangle &= \frac{1}{\sqrt2}|0\rangle + \frac{1}{\sqrt2}(-1)^a|1\rangle \\
	&= \frac{1}{\sqrt2}\sum_{b\in\{0,1\}} (-1)^{ab}|b\rangle
\end{align*}
$$
我们定义：$H^{\otimes n} |x_1 x_2 x_3 \dots x_n\rangle$表示n个H gate的张量积，即：对后者的每个qubit进行H运算。

根据上面的运算可以推广出n个qubits的情况：
$$
\begin{align*}
  H^{\otimes n} |x_1 x_2 x_3 \dots x_n\rangle 
  &= (\frac{1}{\sqrt2}\sum_{y_{n-1}\in \Sigma}(-1)^{x_{n-1}y_{n-1}}|y_{n-1}\rangle) \otimes \dots \otimes (\frac{1}{\sqrt2}\sum_{y_{0}\in \Sigma}(-1)^{x_{0}y_{0}|y_{0}}\rangle) \\
  &= (\frac{1}{\sqrt{2^n}}\sum_{y_{n-1}\dots y_0\in \Sigma}(-1)^{x_{n-1}y_{n-1}+\dots+x_{0}y_{0}}|y_{n-1} \dots y_0\rangle)
\end{align*}
$$

### binary dot product

对于两个字符串$x = x_{n-1}\dots x_0$，$y=y_{n-1}\dots y_0$，我们定义运算
$$
\begin{align*}
x\cdot y &= x_{n-1}y_{n-1} \oplus \dots \oplus x_0y_0 \\
&= \begin{cases} 
   1 & \text{if } x_{n-1}y_{n-1} + \dots + x_0y_0 \text{ is odd} \\
   0 & \text{if } x_{n-1}y_{n-1} + \dots + x_0y_0 \text{ is even}
  \end{cases}
\end{align*}
$$
从而上面的公式可以简化为：
$$
\begin{align*}
  H^{\otimes n} |x\rangle 
  &= (\frac{1}{\sqrt{2^n}}\sum_{y\in \Sigma}(-1)^{x\cdot y}|y\rangle)
\end{align*}
$$
对于Deutsch Josza's Algorithm的公式，可以推导为：
$$
|\pi\rang = |-\rang \otimes \frac{1}{2^n}\sum_{x\in \Sigma}\sum_{y \in \Sigma}(-1)^{f(x) + x \cdot y} | y\rangle
$$
因此，对于测量结果全0的情况，概率可以计算出
$$
P(0^n) &= |\frac{1}{2^n}\sum_{x\in\Sigma}(-1)^{f(x)}|^2 \\
&= \begin{cases} 1 \text{ if f is constant} \\ 0 \text{ if f is balanced} \end{cases}
$$

### Classical method

如果使用传统的方法，我们至少需要执行$2^{n - 1} + 1$次函数，才能够确定这个函数的类型。因为假设是平衡函数，那么最差条件下会有$2^{n-1}$得到相同的结果，当进行到$2^{n-1} + 1$次时，才能发现这是平衡函数。

### Probabilistic method

对字符串进行k次随机采样，如果k次结果相同，结果为常函数，反之为平衡函数。

1. 如果是常函数，判断正确的概率为1。
2. 如果是平衡函数，判断正确的概率为$1 - \frac{1}{2^{k + 1}}$



## Bernstein-Vazirani problem

假设在某一字符串x中，存在子串s，通过函数$f()$来找到子串

