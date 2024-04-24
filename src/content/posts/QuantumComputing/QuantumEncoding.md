---
title: Quantum Encoding
published: 2024-04-24T10:00:00Z
description: 'Quantum Encoding，量子编码：超密编码、'
image: ''
tags: ['Quantum Computing']
category: 'Quantum Computing'
draft: false
---

[toc]

# Quantum Encoding(量子编码)

## SuperDense Encoding(超密编码)

https://en.wikipedia.org/wiki/Superdense_coding

假设存在Alice和Bob，二者共享两个2-qubit量子系统。

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

### 量子通信

假设存在Alice和Bob两个成员，他们之间要共享两个量子系统，分别是$|\Psi\rangle, |\beta_{00}\rangle$。
$$
|\Psi\rangle \otimes |\beta_{00}\rangle
$$
$|\Psi\rangle$为Alice所持有的qubit。

$|\beta_{00}$​表示一对**纠缠的qubit**，Alice持有第一个qubit，Bob持有第二个qubit。

### **1. Alice measure自己持有的两个qubit，$|\Psi\rangle, |\beta_{0}\rangle$，在Bell Basis中。**

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

### 2. Alice 通过 classic teleportation 发送对应的变换矩阵给Bob

利用Pauli Matrices为酉变换的特性，通过逆变换得到Alice原本持有的$|\Psi\rangle$​
$$
HH = HH^\dagger = I
$$


### 3. Bob应用变换矩阵到当前的量子态，获得$|\Psi\rangle$
