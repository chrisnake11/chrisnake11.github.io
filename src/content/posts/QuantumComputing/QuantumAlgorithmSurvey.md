---
title: Quantum Algorithm Survey
published: 2024-05-04T10:00:00Z
description: '初步了解，什么是量子计算机可以做到的事情、不能做到的事情。了解常见的量子算法。'
image: ''
tags: ['Quantum Computing']
category: 'Quantum Computing'
draft: false
---

# Quantum Algorithm Survey

1. 时间
2. 空间
3. 任何经典计算机无法解决的问题，量子计算机也无法解决
4. query model：Quantum algorithm framework; compute model will query data from the input

## Query Model

Query model作为一个经典的问题模型框架，可以用于表示许多问题。可以在Query model的基础上，进一步了解量子算法如何发展、实际应用中有什么特性、和进一步解决经典计算机无法的问题。
$$
f: \Sigma^n \to \Sigma^m
$$
对于一个查询模型，我们可以定义一个函数$f$来表示，对于$\Sigma^n$中的元素，会被映射为$\Sigma^m$。

即：函数$f$可以看做在$\Sigma^n$中执行多次查询，最后输出$\Sigma^m$中的结果。从而转化为一个查询问题模型。

为了简化问题，我们可以认为$\Sigma = \{0, 1\}$。

> Suppose: Unitary quantum operation allowing queries to be made in superposition

使用向input查询的次数来表示query algorithm的效率。

例如：遍历一个字符串时，时间复杂度为O(n)，因为CPU每轮遍历都需要访问一次REG or Mem中的数据。即：作出一次查询。



***注意：我们这里忽略了，Operation所需要的时间复杂度。***



## Query Gates

$$
x \to [f()] \to f(x)
$$

在经典的问题中，$f()$可以是 non-Unitary的。但是在量子计算中，量子逻辑门必须是Unitary gate

![image-20240504105435674](https://raw.githubusercontent.com/chrisnake11/picgo/main/blogimage-20240504105435674.png)

> 这是一个Unitary gate，如果把输出当做另外一个$U_f$的输入可以得到$|x\rangle$，以及 $(|y \oplus f(x)\rangle) \oplus f(x) = |y\rangle$

$U_f$是一个变换矩阵(Permutation matrix)，每一行、每一列只有一个元素为1，其他元素都是0。



***在测量Query的复杂度的过程中， 我们忽略了从物理上构造一个$U_f$的困难程度***



***在下面的算法介绍中，我们同样不会考虑到实际的Query Gate的制作成本等技术上的问题。只是从理论上探询量子计算在某些计算方面的理论可实现性。***



## Deutsch Josza's algorithm

读音：$dech, joza$。由Deutsch 和 Josza两个人提出。

问题：假设有一个黑盒子$f()$，问题承诺这个函数要么是常函数（输出恒为0、或者恒为1），要么是平衡函数（一半输出0，另一半输出1）。问题的任务是通过算法来预测函数$f()$是常函数还是平衡函数。

简化问题，假设输入为1bit，那么可能得结果对应四种函数：

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



### Quantum Circuit

Deutsch's algorithm 只需要1个qubit就可以实现。从这一点就可以看出Quantum Computing在传统计算上的优势。