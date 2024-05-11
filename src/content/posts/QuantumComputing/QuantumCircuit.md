---
title: Quantum Circuit
published: 2024-04-26T14:00:00Z
description: '介绍通过qiskit构建QuantumCircuit的基本步骤，以及相关的qiskit API'
image: ''
tags: ['Quantum Computing']
category: 'Quantum Computing'
draft: false
---

# Quantum Circuit

量子电路由wires、logical gate组成。

+ wires中存储了qubit信息

量子电路是acyclic的，整体由左到右顺序执行。

> 量子电路中不存在反馈循环电路。

[QuantumCircuit API](https://docs.quantum.ibm.com/api/qiskit/circuit)


```python
from qiskit import QuantumCircuit
```

## 单量子比特的量子电路

使用`QuantumCircuit(int bit_number)`来创建量子电路


```python
circ = QuantumCircuit(1)
circ.draw()
```


<pre style="word-wrap: normal;white-space: pre;background: #fff0;line-height: 1.1;font-family: &quot;Courier New&quot;,Courier,monospace">   
q: 
   </pre>


QuantumCircuit，将常用了变换矩阵写成了内置的函数供用户使用。


```python
circ.h(0)
circ.s(0)
circ.x(0)
circ.draw("text")
```


<pre style="word-wrap: normal;white-space: pre;background: #fff0;line-height: 1.1;font-family: &quot;Courier New&quot;,Courier,monospace">   ┌───┐┌───┐┌───┐
q: ┤ H ├┤ S ├┤ X ├
   └───┘└───┘└───┘</pre>


相当于$ X\otimes S \otimes H \otimes |0\rangle$

## 多量子比特的量子电路

QuantumCircuit(arg)中的参数，表示创建一个关于n个量子比特的量子电路。


```python
circ = QuantumCircuit(3)
circ.draw()
```


<pre style="word-wrap: normal;white-space: pre;background: #fff0;line-height: 1.1;font-family: &quot;Courier New&quot;,Courier,monospace">     
q_0: 


q_1: 

q_2: 

对于多量子比特，可以使用Controlled Gate来对指定的两个比特进行操作。

Controlled Gate中的参数为操作的qubit的subscript


```python
circ.h(0)
circ.ch(0, 1)
circ.cs(1, 2)
circ.cx(0, 2)
circ.draw()
```


<pre style="word-wrap: normal;white-space: pre;background: #fff0;line-height: 1.1;font-family: &quot;Courier New&quot;,Courier,monospace">     ┌───┐               
q_0: ┤ H ├──■─────────■──
     └───┘┌─┴─┐       │  
q_1: ─────┤ H ├──■────┼──
          └───┘┌─┴─┐┌─┴─┐
q_2: ──────────┤ S ├┤ X ├
               └───┘└───┘</pre>


量子电路从左到右，按照层级排列，能够得到量子电路的深度depth。上面这个3bit量子电路的深度为4

### 引入Classical bit

我们可以使用双条横线表示的wires，来表示qubit和classical bit的同时传输

### 引入measurement

使用一个类似于仪表盘的标志来表示measure操作


```python

```