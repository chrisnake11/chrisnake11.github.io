---
title: Entanglement on Action
published: 2024-04-27T10:00:00Z
description: '介绍量子纠缠以及量子纠缠的相关应用：量子通信、超密编码、CHSH'
image: ''
tags: ['Quantum Computing']
category: 'Quantum Computing'
draft: false
---

[toc]

# Entanglement on Action

规定：一般使用Alice和Bob作为两个通信对象的命名。

## Remarks on Entanglment 

对于两个相互纠缠的qubit，下面是纠缠状态的一个例子：
$$
|\phi^+\rangle = \frac{1}{\sqrt2}|00\rangle + \frac{1}{\sqrt2}|11\rangle
$$
利用两个qubit的纠缠，我们能够实现不同的目的。

一般来说，我们将$|\phi^+\rangle$视为一个纠缠的最小单元，叫做**e-bit**

**规定：**当提到Alice和Bob共享一个e-bit，说明Alice持有qubit A，Bob持有qubit B，且(A, B)构成了一个纠缠态$|\phi^+\rangle$。

## Quantum Teleportation 

+ 背景：**假设Alice有一个qubit Q，需要发送给Bob。**
  + 但是Alice无法发送量子Q给Bob，只能够发送classical bit。
  + 并且Alice和Bob共享一个e-bit

+ Q的状态，对于Alice和Bob都是未知的。
+ 在通信的过程中，量子的状态必须被保留下来。
+ **当Bob接收到Q之后，Alice不能再持有Q，因为量子是不能被克隆的。**



#### **1. Alice measure自己持有的两个qubit，$|\Psi\rangle, |\beta_{0}\rangle$，在Bell Basis中。**

将量子叠加态计算坍缩后的结果，用Pauli Matrices, Bell Basis表示：

![image-20240424135634513](https://raw.githubusercontent.com/chrisnake11/picgo/main/blogimage-20240424135634513.png)

![image-20240424140031869](https://raw.githubusercontent.com/chrisnake11/picgo/main/blogimage-20240424140031869.png)

根据公式，经过测量后，Alice会得到以下四种坍缩态中的一种
$$
|\beta_{00}\rangle |\Psi\rangle \\
|\beta_{01}\rangle X|\Psi\rangle \\
|\beta_{10}\rangle Z|\Psi\rangle \\
|\beta_{11}\rangle XZ|\Psi\rangle
$$
根据第二个量子系统($|\beta_{00}\rangle$)的坍缩态，Alice可以知道$|\Psi\rangle$​坍缩后进行的变换。

由于量子纠缠的特性，Bob那边所持有的量子系统也会发生相同的坍缩。

因此Bob持有的$|\Psi\rangle$也会坍缩成相同的状态。

#### 2. Alice 通过 classic teleportation 发送对应的变换矩阵给Bob

利用Pauli Matrices为酉变换的特性，通过逆变换得到Alice原本持有的$|\Psi\rangle$​
$$
HH = HH^\dagger = I
$$


#### 3. Bob应用变换矩阵到当前的量子态，获得$|\Psi\rangle$

## SuperDense Encoding(超密编码)

https://en.wikipedia.org/wiki/Superdense_coding

+ 背景：Alice需要发送两个bit的信息给Bob。
  + Alice可以发送一个**qubit**给Bob
  + Alice和Bob share一个**e-bit**
+ Holevo's theorem，仅使用一个qubit无法传输两个classical bit。

### Bell Basis

https://en.wikipedia.org/wiki/Bell_state

基本**2-qubit向量**通过**Pauli-matrix(X, Z)可变换**为bell basis。

Bell Basis中的向量分别由两个相互正交的**2-qubit**向量表示。
$$
|\beta_{00} \rangle = \frac{1}{\sqrt2}(|00\rangle + |11 \rangle) \\
|\beta_{01} \rangle = \frac{1}{\sqrt2}(|01\rangle + |10 \rangle) \\
|\beta_{10} \rangle = \frac{1}{\sqrt2}(|00\rangle - |11 \rangle) \\
|\beta_{11} \rangle = \frac{1}{\sqrt2}(|01\rangle - |10 \rangle)
$$
其中：$|00\rangle$和$|11\rangle$相互正交；$|01\rangle$和$|10\rangle$相互正交.



在超密编码中，Bob通过观测量子时，默认量子坍缩到Bob所观测到的量子的概率为1.

## CHSH game

CHSH(4 authors' name) 

Nonlocal game
