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

### 证明：见平板笔记

### Quantum Teleportation  Qiskit实现

```python
# Required imports
# Quantum Circuit
from qiskit import QuantumCircuit, QuantumRegister, ClassicalRegister
# Aer is a high performance simulator for quantum circuits written in Qiskit
from qiskit_aer import AerSimulator
# 可视化工具
from qiskit.visualization import plot_histogram
# 统计工具
from qiskit.result import marginal_distribution
# U gate
from qiskit.circuit.library import UGate
# 生成随机数 
from numpy import pi, random
```

+ `barrier()`：一个可视化的标记，用于标记一组逻辑门操作的结束。
+ `if_test()`：接受一个tuple，(classical-bit, value)，当bit == value时执行。


```python
qubit = QuantumRegister(1, "Q")
ebit0 = QuantumRegister(1, "A")
ebit1 = QuantumRegister(1, "B")
a = ClassicalRegister(1, "a")
b = ClassicalRegister(1, "b")

protocol = QuantumCircuit(qubit, ebit0, ebit1, a, b)

# make beta+
protocol.h(ebit0)
protocol.cx(ebit0, ebit1)
protocol.barrier()

# Alice's operation
protocol.cx(qubit, ebit0)
protocol.h(qubit)
protocol.barrier()

# Alice measure
protocol.measure(ebit0, a)
protocol.measure(qubit, b)
protocol.barrier()

with protocol.if_test((a, 1)):
    protocol.x(ebit1)
with protocol.if_test((b, 1)):
    protocol.z(ebit1)

display(protocol.draw())
```


<pre style="word-wrap: normal;white-space: pre;background: #fff0;line-height: 1.1;font-family: &quot;Courier New&quot;,Courier,monospace">                ░      ┌───┐ ░    ┌─┐ ░                                     »
  Q: ───────────░───■──┤ H ├─░────┤M├─░─────────────────────────────────────»
     ┌───┐      ░ ┌─┴─┐└───┘ ░ ┌─┐└╥┘ ░                                     »
  A: ┤ H ├──■───░─┤ X ├──────░─┤M├─╫──░─────────────────────────────────────»
     └───┘┌─┴─┐ ░ └───┘      ░ └╥┘ ║  ░ ┌────── ┌───┐ ───────┐ ┌────── ┌───┐»
  B: ─────┤ X ├─░────────────░──╫──╫──░─┤ If-0  ┤ X ├  End-0 ├─┤ If-0  ┤ Z ├»
          └───┘ ░            ░  ║  ║  ░ └──╥─── └───┘ ───────┘ └──╥─── └───┘»
                                ║  ║    ┌──╨──┐                   ║         »
a: 1/═══════════════════════════╩══╬════╡ 0x1 ╞═══════════════════╬═════════»
                                0  ║    └─────┘                ┌──╨──┐      »
b: 1/══════════════════════════════╩═══════════════════════════╡ 0x1 ╞══════»
                                   0                           └─────┘      »
«               
«  Q: ──────────
«               
«  A: ──────────
«      ───────┐ 
«  B:   End-0 ├─
«      ───────┘ 
«a: 1/══════════
«               
«b: 1/══════════
«               </pre>



+ `Ugate()`：生成一个具有三维欧拉角的量子比特。(见：[Euler's angles](https://en.wikipedia.org/wiki/Euler_angles)）


```python
random_gate = UGate(
    theta = random.random() * 2 * pi,
    phi = random.random() * 2 * pi,
    lam = random.random() * 2 * pi,
)
display(random_gate.to_matrix())
```


    array([[-0.30843978+0.j        ,  0.78443411-0.53807809j],
           [ 0.92967739+0.20140718j,  0.28552611-0.11666163j]])



```python
# 创建一个验证电路，包括与protocol相同的bits
test = QuantumCircuit(qubit, ebit0, ebit1, a, b)

# 给qubit加上一个U gate，表示随机的qubit
test.append(random_gate, qubit)
test.barrier()

# 在后方组合上protocol
test = test.compose(protocol)
test.barrier()

# test添加U gate的共轭转置U dagger
test.append(random_gate.inverse(), ebit1)

# 创建一个result，用于保存结果
result = ClassicalRegister(1, "Result")
test.add_register(result)

# 测量ebit的结果到result
test.measure(ebit1, result)

display(test.draw())
```


<pre style="word-wrap: normal;white-space: pre;background: #fff0;line-height: 1.1;font-family: &quot;Courier New&quot;,Courier,monospace">          ┌──────────────────────────┐ ░            ░      ┌───┐ ░    ┌─┐ ░ »
       Q: ┤ U(3.7687,0.21335,2.5404) ├─░────────────░───■──┤ H ├─░────┤M├─░─»
          └──────────────────────────┘ ░ ┌───┐      ░ ┌─┴─┐└───┘ ░ ┌─┐└╥┘ ░ »
       A: ─────────────────────────────░─┤ H ├──■───░─┤ X ├──────░─┤M├─╫──░─»
                                       ░ └───┘┌─┴─┐ ░ └───┘      ░ └╥┘ ║  ░ »
       B: ─────────────────────────────░──────┤ X ├─░────────────░──╫──╫──░─»
                                       ░      └───┘ ░            ░  ║  ║  ░ »
     a: 1/══════════════════════════════════════════════════════════╩══╬════»
                                                                    0  ║    »
     b: 1/═════════════════════════════════════════════════════════════╩════»
                                                                       0    »
Result: 1/══════════════════════════════════════════════════════════════════»
                                                                            »
«                                                         ░ »
«       Q: ───────────────────────────────────────────────░─»
«                                                         ░ »
«       A: ───────────────────────────────────────────────░─»
«          ┌────── ┌───┐ ───────┐ ┌────── ┌───┐ ───────┐  ░ »
«       B: ┤ If-0  ┤ X ├  End-0 ├─┤ If-0  ┤ Z ├  End-0 ├──░─»
«          └──╥─── └───┘ ───────┘ └──╥─── └───┘ ───────┘  ░ »
«          ┌──╨──┐                   ║                      »
«     a: 1/╡ 0x1 ╞═══════════════════╬══════════════════════»
«          └─────┘                ┌──╨──┐                   »
«     b: 1/═══════════════════════╡ 0x1 ╞═══════════════════»
«                                 └─────┘                   »
«Result: 1/═════════════════════════════════════════════════»
«                                                           »
«                                            
«       Q: ──────────────────────────────────
«                                            
«       A: ──────────────────────────────────
«          ┌─────────────────────────────┐┌─┐
«       B: ┤ U(-3.7687,-2.5404,-0.21335) ├┤M├
«          └─────────────────────────────┘└╥┘
«     a: 1/════════════════════════════════╬═
«                                          ║ 
«     b: 1/════════════════════════════════╬═
«                                          ║ 
«Result: 1/════════════════════════════════╩═
«                                          0 </pre>



+ 运行量子电路模拟器，统计量子电路整体bit的分布结果。


```python
result = AerSimulator().run(test).result()
statistics = result.get_counts()
display(plot_histogram(statistics))
```


![output_7_0](https://raw.githubusercontent.com/chrisnake11/picgo/main/blogoutput_7_0.png)
    


+ marginal_distribution(data, index)：查看某个bit组合的边缘分布
  + 用下标数组，表示对应的第(i+1)个bit的组合


```python
filtered_statistics = marginal_distribution(statistics, [2]) # 查看第三个bit的边缘分布
display(plot_histogram(filtered_statistics))
```


![output_9_0](https://raw.githubusercontent.com/chrisnake11/picgo/main/blogoutput_9_0.png)
    



## SuperDense Encoding(超密编码)

https://en.wikipedia.org/wiki/Superdense_coding

+ 背景：Alice需要发送两个bit的信息给Bob（使用1个qubit和1个e-bit来传输2比特的信息）。
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
