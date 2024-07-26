---
title: Quantum Algorithm Foundation
published: 2024-07-26T10:00:00Z
description: '初步了解量子计算的基础：大整数的素数因子分解，衡量计算cost，经典问题在量子电路上的使用。'
image: ''
tags: ['Quantum Computing']
category: 'Quantum Computing'
draft: false
---

# 1. Integer Factorization 正整数因子分解


数论：任意一个正整数可以**唯一地**被分解为若干个素数的乘积。

如： 12 = 3 * 2 * 2


# 2. Greatest Common Divisor 最大公因子


数论：辗转相除法gcd


# 3. Measuring Computational Cost 衡量计算开销

Input --> Computation --> Output

## 3.1 Encoding & Input Length 

对于输入，一个有效的编码方式和尽量短的编码长度，能够帮助减少计算开销。

> 二进制编码，哈夫曼编码等等...
>

## 3.2 Elementary Operations 基础运算

这里的运算是一种广义的运算，表示对输入进行某种操作。

可以是 算术运算，query gate，Xor，矩阵变换等等...

### 3.2.1 Standard Quantum Gate Set 标准量子门集合

+ Single-qubit Unitary gate：X, Y, Z, Hardmard, S, S\dagger, T, T\dagger
+ Controled-NOT gates
+ Single-qubit standard basis measurements


### 3.2.2 Standard Boolean Gate Set 标准布尔门集合

+ AND(NOT)
+ OR(NOT)
+ NOT
+ FANOUT

其中AND和OR可以使用NOT门来实现。

### 3.2.3 Circuit Size & Depth

电路的大小，等于电路内部逻辑门的数量。
> 电路的大小，可以看做将每个逻辑门**顺序执行**需要花费的时间。

电路的深度，等于电路内部从左向右数，逻辑门的层数。
> 电路的深度，可以看做将每个逻辑门**并行执行**需要花费的时间。


### 3.2.4 Cost Of Input Length 输入长度的开销


由于每个电路的大小是固定的。对于更长的输入数据，电路所需要的逻辑门数量也会随之增加。

为了应对变化的输入数据，引入了族(Family) {C1, C2, ..., Cn}的概念。

同一个功能的电路，给任意长度n的输入，设计对应的电路Cn。

**例子：整数加法**

+ 半加器: 实现两位数，不进位的计算。

![](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog20240725113404.png)

+ 全加器：带进位的计算。

![](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog20240725113537.png)

# 4. Classical Computations on Quantum Computers 经典计算在量子计算机的应用

## 4.1 Simulating Boolean Gates

1. NOT Gates 在Boolean和量子中是相同的。

2. AND, OR 可以使用Toffli and NOT gates来实现

    Toffli Gate的第三个输入变为|0>即可。

    OR作为AND的对立面，在Toffli gate的基础上，添加一些非门即可。

    ![20240726095817](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog20240726095817.png)

3. FANOUT gate可以使用CNOT gate 来实现。

![20240726100025](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog20240726100025.png)

## 4.2 Simulating Boolean Circuits

由于与或非、FANOUT门的模拟实现，我们就可以使用量子电路来替换所有的Boolean Circuit。

![20240726100307](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog20240726100307.png)

对于一个经典的Boolean Gate，我们只需要输入和输出。但是量子电路中，除了Boolean Circuit需要的输入输出外，还有额外的输入和输出数据在|0>和g(x)【g 是 garbage的缩写】中，用于辅助实现量子电路模拟Boolean Gate。

> 有了这些garbage数据的参与，量子逻辑门就得以进行逆运算。
>

![20240726101254](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog20240726101254.png)

我们继续引入额外的qubit来记录R gate产生的输出结果。并利用R gate的逆运算特性消除掉原本的garbage数据。

这样我们就使用双倍的R电路，额外使用了|0>的输入空间，完美地模拟了Boolean Circuit。

如果去掉|0>的部分，这个量子电路明显是一个Query Gate，输入|x>输出$|f(x)>$和$|y \oplus f(x)>$

这开销太大了，这肯定有方法优化优化。




