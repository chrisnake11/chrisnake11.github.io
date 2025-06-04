---
title: 15周工作
published: 2024-12-10T14:36:17Z
description: '15周工作'
image: ''
tags: ['research']
category: 'research'
---

<!-- TOC -->

- [1. 量子电路基础(直接构建简单的量子电路)](#1-量子电路基础直接构建简单的量子电路)
- [2. 梯度和训练](#2-梯度和训练)
  - [2.1 自定义梯度下降方法](#21-自定义梯度下降方法)
  - [2.2 Pennylane的梯度计算方法](#22-pennylane的梯度计算方法)
  - [2.3 交给Torch训练](#23-交给torch训练)
- [3. 测量](#3-测量)
- [4.Dynamic Circuit(根据测量结果，动态调整电路)](#4dynamic-circuit根据测量结果动态调整电路)
  - [4.1 测量的实现](#41-测量的实现)
  - [4.2 延迟测量](#42-延迟测量)
  - [4.3 单次测量](#43-单次测量)
  - [4.4 树形遍历](#44-树形遍历)
  - [4.5 代码示例](#45-代码示例)
- [5. 线路模板](#5-线路模板)
  - [5.1 SimplifiedTwoDesign](#51-simplifiedtwodesign)
  - [5.2 Broadcasting function](#52-broadcasting-function)
  - [5.3 参数初始化](#53-参数初始化)
- [6. 自定义模板](#6-自定义模板)
- [7. 查看量子电路](#7-查看量子电路)
  - [7.1 查看量子电路的详细信息](#71-查看量子电路的详细信息)
  - [7.2 可视化量子电路](#72-可视化量子电路)
  - [7.3 利用mid-circuit来debug](#73-利用mid-circuit来debug)
    - [debugging](#debugging)
- [8. 编译量子电路](#8-编译量子电路)
  - [8.1 电路简化](#81-电路简化)
  - [8.2 电路分解](#82-电路分解)
  - [8.3 自定义分解逻辑门](#83-自定义分解逻辑门)
- [9. 量子编译流程](#9-量子编译流程)
  - [9.1 catalyst混合量子程序实时编译器](#91-catalyst混合量子程序实时编译器)
  - [9.2 控制流程](#92-控制流程)
- [10. 使用CUDA Quantum](#10-使用cuda-quantum)

<!-- /TOC -->

# 1. 量子电路基础(直接构建简单的量子电路)

PennyLane主要有2个部分组成: `device`，`qnode`

device：表示运行的量子设备

```python
shots_list = [5, 10, 1000]
dev = qml.device('default.qubit', wires=['aux', 'q1', 'q2'], shot=shot_list)
```

+ 第一个参数为device的类型。
+ 第二个参数为量子比特数量，也可以使用标签数组对每个比特进行标记。一个wire表示一个比特
+ 第三个参数为测量的次数列表，用频率来拟合概率。如果为空，就直接计算精确的概率辐。

qnode：表示一个量子逻辑电路，在QNode中定义了circuit function，即：量子逻辑电路。

```python
@qml.qnode(dev) # 使用decorator更方便地给QNode指定device
def my_quantum_function(x, y):
    qml.RZ(x, wires='q1')
    qml.CNOT(wires=['aux' ,'q1'])
    qml.RY(y, wires='q2')
    return qml.expval(qml.PauliZ('q2'))
```

`draw()`可以使用字符直接绘制量子电路

```
circuit = qml.QNode(my_quantum_function, dev)
print(qml.draw(circuit))
```

也可调用`matplotlib`包，使用`draw_mpl()`来绘制更清晰的电路图。

```
import matplotlib.pyplot as plt
qml.drawer.use_style("black_white")
fig, ax = qml.draw_mpl(circuit)
plt.show()
```

**参数传播机制：**

在QNode中，参数的传播是并行的，即对于单独的一个QNode中的所有参数以ndarray的形式，并行执行。（类似于在机器学习中对一批参数应用一个函数）

对于（最多）中等大小的量子线路（≲20 条量子线）和中等数量的参数（≲200 个）在经典模拟器上执行的情况下，通常可以从广播中受益。

**从其他软件导入量子电路**

Pennylane可以从其他的量子电路相关软件（如：Qiskit）导入量子电路。
> 前提：需要安装对应的软件包（如：PennyLane-Qiskit）


# 2. 梯度和训练

Pennylane通过一个自动微分的API，与其他经典的神经网络框架结合（如：Numpy、PyTorch、TensorFlow等。），让其他的神经网络框架可以像训练经典神经网络一样，训练量子电路。

在构建device时，通过参数`interface`可以指定自动微分的框架。

```python
@qml.qnode(dev, interface="torch") # 使用PyTorch作为微分框架
def my_quantum_circuit(...):
    ...
```

当使用标准的Numpy框架时，Pennylane提供了一些内置的优化器进行优化。

如果使用的是Pytorch，通过调用torch的相关API，可以将经典数据直接传递给QNode，同时torch可以直接获取QNode的梯度，使用torch中的优化器优化混合量子电路。


## 2.1 自定义梯度下降方法

要想使用CustomFunction作为自定义的梯度梯度下降方法，需要使用`apply()`方法。

```python
class CustomFunction(torch.autograd.Function):
    # CustomFunction继承自torch.autograd.Function
    @staticmethod
    def forward(ctx, x, exponent=2):
        ctx.saved_info = {'x': x, 'exponent': exponent}
        return x ** exponent

    @staticmethod
    def backward(ctx, dy):
        x = ctx.saved_info['x']
        exponent = ctx.saved_info['exponent']
        print(f"Calculating the gradient with x={x}, dy={dy}, exponent={exponent}")
        return dy * exponent * x ** (exponent-1), None
```

测试结果如下：

```shell
val = torch.tensor(2.0, requires_grad=True)
res = CustomFunction.apply(val)
res.backward()
val.grad
```
> CustomFunction函数的输入输出都是拉平后的一维数据。


## 2.2 Pennylane的梯度计算方法

Pennylane设计了两种方法计算梯度

1. 基于模拟的微分。当使用量子仿真模拟时，可以直接使用经典的反向传播算法来计算梯度。

2. 硬件兼容的微分。一般可以使用`parameter-shift`参数偏移和`finite-diff`有限差分的方法计算。
> 基于`Hardmard-Test`的梯度估计？

`device()`中的`diff_method`可以指定梯度计算的方法。默认为`diff_method=best`，Pennylane将根据device和interface自动选择最优的方法。

```python
@qml.qnode(dev, interface='torch', diff_method='parameter-shift')
def circuit(x):
    qml.RX(x, wires=0)
    return qml.probs(wires=0)
```

## 2.3 交给Torch训练

除了直接对Quantum Circuit自动微分。Pennylane还提供了更高级的API.

如果设计的QNode可以被Torch兼容，那么QNode可以使用`qml.qnn.TorchLayer()`直接转化为`torch.nn`的经典层，直接进行训练。

# 3. 测量

使用`qml.expval(op)`可以在测量前应用一个`operation`。

下面的例子在测量前使用Pauli—Z门。用于测量本征态。
```python
def my_quantum_function(x, y):
    qml.RZ(x, wires=0)
    qml.CNOT(wires=[0, 1])
    qml.RY(y, wires=1)
    return qml.expval(qml.PauliZ(1))
```

# 4.Dynamic Circuit(根据测量结果，动态调整电路)

Mid-circuit measurements：中段电路测量，根据量子态部分的测量结果，后续执行不同的量子逻辑电路。
> 在测量后，可以把对应线路归零，重新使用。

postselecting mid-circuit measurements：根据测量结果抛弃（筛选）部分样本。

conditional operators：使用测量的结果，进行条件逻辑判断。

对于部分获得量子态统计数据的api，如:`counts()`, `expval()`, `probs()`等，可以使用参数来获取满足特定测量结果的样本的统计数据。

## 4.1 测量的实现

![20241211100604](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/20241211100604.png)

1. 延迟测量(Deferred measurements)
> 延迟测量支持反向传播和有限差分的方法计算梯度，如果postselect没有被使用，则无法使用参数偏移的方法。
2. 动态单词测量(Dynamic one-shot)
3. 树型遍历(Tree-traversal)
> 后两种，对于postselect如果被选择，一定会使用参数移位的梯度计算方法。当使用了条件操作符，则只能使用有限差分的方法计算梯度。

这三种技术的优点和缺点差别很大，一般来说：

+ 动态一次性采样在多次测量、少量采样的模式下表现出色，
+ 树遍历技术可以处理具有大量样本和多次测量的大规模模拟
+ 延迟测量是一种通用解决方案，可以在（几乎）所有情况下实现电路中段测量支持，但内存成本较高。它是唯一支持数值解析的方法。

## 4.2 延迟测量

当使用延迟测量，会给每个mid-circuit measurements添加一个辅助量子比特。
随着量子比特的增加，内存和模拟时长将会指数增长。

把原始的中间测量比特作为控制位，对辅助比特使用CNOT门，再让辅助比特控制后续的电路。
最后延迟测量时，只需要根据辅助比特的结果来判断。

```python
deferred_qnode = qml.defer_measurements(my_qnode)
pars = np.array([0.643, 0.246])
deferred_qnode(*pars)

print(qml.draw(my_qnode)(*pars)) # 原始mid-circuit测量
print(qml.draw(deferred_qnode)(*pars)) # deffered measurement
```

> 注意：每一次mid-circuit measurement都会添加一个额外的辅助量子比特。
> 
> `Postselection` with deferred measurements is only supported on `DefaultQubit`.

## 4.3 单次测量

指直接一次完成量子系统的测量，测量结束后，量子态会坍缩到本征态。
测量后不可逆，无法使用本征态验证原始的量子态。

## 4.4 树形遍历

结合了单次测量内存开销低和延迟测量中采样效率的优点。

## 4.5 代码示例

```python
dev = qml.device("default.qubit", wires=3, shots=10)

def circ():
    qml.Hadamard(0)
    m_0 = qml.measure(0, postselect=1)
    return qml.sample(qml.PauliZ(0))

# 通过参数配置QNode
fill_shots = qml.QNode(circ, dev, mcm_method="one-shot", postselect_mode="fill-shots")
hw_like = qml.QNode(circ, dev, mcm_method="one-shot", postselect_mode="hw-like")
```

# 5. 线路模板

## 5.1 SimplifiedTwoDesign

由[Cincio 2021等人](https://www.nature.com/articles/s41467-021-21728-w)
提出的一种逻辑门结构，有助于缓解barren plateau现象。

首先是一层RY门，之后使用CZ门和RY门进行操作。

$$
CZ =
\begin{bmatrix} 
    1 & 0 & 0 & 0 \\
    0 & 1 & 0 & 0 \\
    0 & 0 & 1 & 0 \\
    0 & 0 & 0 & -1 \\
\end{bmatrix}
$$

![20241211101515](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/20241211101515.png)

CZ门可以将两个基向量变为最大的

## 5.2 Broadcasting function

将一个固定的M量子比特逻辑门，以特定的模式(single, double, pyramid, circle等)添加到量子线路中。

> 注意：`qml.Broadcasting`从`v0.40`开始不推荐使用。建议使用for循环。

## 5.3 参数初始化

利用模板本身的函数`shape()`可以获取权重参数的维度大小。

从而直接使用`random()`初始化参数。

```python
import pennylane as qml
from pennylane.templates import BasicEntanglerLayers
from pennylane import numpy as np

n_wires = 3
dev = qml.device('default.qubit', wires=n_wires)

@qml.qnode(dev)
def circuit(weights1,weights2):
    BasicEntanglerLayers(weights=weights1, wires=range(n_wires))
    BasicEntanglerLayers(weights=weights2, wires=range(n_wires))
    return qml.expval(qml.PauliZ(0))

# 读取编码层的形状
shape = BasicEntanglerLayers.shape(n_layers=2, n_wires=n_wires)

# 初始化BasicEntanglerLayers的参数
np.random.seed(42)  # to make the result reproducible
weights1 = np.random.random(size=shape)
weights2 = np.random.random(size=shape)

# 输入对应模块的参数
# 如果有多个模板可以添加参数
circuit(weights1, weights2)
```

# 6. 自定义模板

可以自定义一个线路电路，作为自己的模板。

模板只需要逻辑门参数列表和量子比特作为参数。

模板函数内部为一系列量子逻辑门。

```python
from pennylane import numpy as np

def MyTemplate(a, b, wires):
    c = np.sin(a) + b
    qml.RX(c, wires=wires[0])

n_wires = 3
dev = qml.device('default.qubit', wires=n_wires)

@qml.qnode(dev)
def circuit(a, b):
    MyTemplate(a, b, wires=range(n_wires))
    return qml.expval(qml.PauliZ(0))
```
# 7. 查看量子电路

## 7.1 查看量子电路的详细信息

`qml.spec()`方法，可以将QNode类作为参数，返回一个关于量子电路参数的函数`spec_func()`

这个函数的参数与QNode参数相同，返回的是基于参数构造的量子电路的详细信息。

```python
dev = qml.device('default.qubit', wires=4)

@qml.qnode(dev, diff_method='parameter-shift')
def circuit(x, y):
    qml.RX(x[0], wires=0)
    qml.Toffoli(wires=(0, 1, 2))
    qml.CRY(x[1], wires=(0, 1))
    qml.Rot(x[2], x[3], y, wires=0)
    return qml.expval(qml.Z(0)), qml.expval(qml.X(1))
```

## 7.2 可视化量子电路

`qml.draw_mpl(circuit)(args)`可以用于可视化量子电路。`circuit`为电路模板，`args`为对应的参数。

```python
dev = qml.device('default.qubit')

@qml.qnode(dev)
def circuit(x, z):
    qml.QFT(wires=(0,1,2,3))
    qml.IsingXX(1.234, wires=(0,2))
    qml.Toffoli(wires=(0,1,2))
    mcm = qml.measure(1)
    mcm_out = qml.measure(2)
    qml.CSWAP(wires=(0,2,3))
    qml.RX(x, wires=0)
    qml.cond(mcm, qml.RY)(np.pi / 4, wires=3)
    qml.CRZ(z, wires=(3,0))
    return qml.expval(qml.Z(0)), qml.probs(op=mcm_out)

fig, ax = qml.draw_mpl(circuit)(1.2345,1.2345)
fig.show()
```

## 7.3 利用mid-circuit来debug

`qml.Snapshot()`方法的使用方法类似于一个gate作用在一个circuit中，但它的作用是存储当前状态下的量子态。

对于不同的模拟设备，存储的数据结构也不同:
1. default.qubit：存储为量子态的向量
2. default.mixed：存储为密度矩阵的形式
3. default.gaussian：存储为协方差矩阵和均方差向量。

```python
dev = qml.device("default.qubit", wires=2)

@qml.qnode(dev, interface=None)
def circuit():
    qml.Snapshot(measurement=qml.expval(qml.Z(0)))
    qml.Hadamard(wires=0)
    qml.Snapshot("very_important_state")
    qml.CNOT(wires=[0, 1])
    qml.Snapshot()
    return qml.expval(qml.X(0))
```

当直接运行电路时，会忽略`Snapshot()`，只有使用`qml.snapshot()`方法运行circuit才会得到中间的量子态。

```python
qml.snapshots(circuit)()
```

> 注意区分`qml.Snapshot()`和`qml.snapshot()`

### debugging

pennylane还提供了类似于gdb的debugging程序，详细见[qml.debugging](https://docs.pennylane.ai/en/stable/code/qml_debugging.html)


# 8. 编译量子电路

量子电路的“编译”，是指将一个给定的量子电路函数、或者量子逻辑门，转化为其他的类型的量子电路。例如：将一个大型的量子逻辑门组成的量子电路，转化为由多个小型逻辑门组成的量子电路。 

## 8.1 电路简化

`qml.simplify()`方法将量子逻辑门作为参数，能够把这个逻辑门进行简化处理。

```shell
>>> qml.simplify(qml.RX(4*np.pi+0.1, 0 ))
RX(0.09999999999999964, wires=[0])
>>> qml.simplify(qml.adjoint(qml.RX(1.23, 0)))
RX(11.336370614359172, wires=[0])
>>> qml.simplify(qml.ops.Pow(qml.RX(1, 0), 3))
RX(3.0, wires=[0])
>>> qml.simplify(qml.sum(qml.Y(3), qml.Y(3)))
2.0 * Y(3)
>>> qml.simplify(qml.RX(1, 0) @ qml.RX(1, 0))
RX(2.0, wires=[0])
>>> qml.simplify(qml.prod(qml.X(0), qml.Z(0)))
-1j * Y(0)
```

除了简化逻辑门，还可以用于简化一个QNode对象。

```python
dev = qml.device("default.qubit", wires=2)

@qml.simplify
@qml.qnode(dev)
def circuit(x):
    (
        qml.RX(x[0], wires=0)
        @ qml.RY(x[1], wires=1)
        @ qml.RZ(x[2], wires=2)
        @ qml.RX(-1, wires=0)
        @ qml.RY(-2, wires=1)
        @ qml.RZ(2, wires=2)
    )
    return qml.probs([0, 1, 2])
```
输出结果：
```shell
>>> x = [1, 2, 3]
>>> print(qml.draw(circuit)(x))
0: ───────────┤ ╭Probs
1: ───────────┤ ├Probs
2: ──RZ(5.00)─┤ ╰Probs
```

## 8.2 电路分解

`decompose()`函数，可以将一个逻辑门分解为指定的一组门。

如：将Tofolli门分解为RX、RZ门。

```python
from pennylane.transforms import decompose
from functools import partial

dev = qml.device('default.qubit')
allowed_gates = {qml.Toffoli, qml.RX, qml.RZ}

@partial(decompose, gate_set=allowed_gates)
@qml.qnode(dev)
def circuit():
    qml.Hadamard(wires=[0])
    qml.Toffoli(wires=[0,1,2])
    return qml.expval(qml.Z(0))
```

输出结果：

```shell
>> print(qml.draw(circuit)())
0: ──RZ(1.57)──RX(1.57)──RZ(1.57)─╭●─┤  <Z>
1: ───────────────────────────────├●─┤
2: ───────────────────────────────╰X─┤
```

## 8.3 自定义分解逻辑门

通过自定义分解电路，可以将某一个量子逻辑电路中的某一个电路，分解为指定规则的门。

例如：将电路中的所有CNOT门，分解为H门和CZ门。

```python
# 默认电路
def circuit(weights):
    qml.BasicEntanglerLayers(weights, wires=[0, 1, 2])
    return qml.expval(qml.Z(0))

# CNOT的转化规则函数
def custom_cnot(wires, **_):
    return [
        qml.Hadamard(wires=wires[1]),
        qml.CZ(wires=[wires[0], wires[1]]),
        qml.Hadamard(wires=wires[1])
    ]

# 可以将一系列规则函数，构成一个列表
custom_decomps = {qml.CNOT: custom_cnot}

# 使用自定义的分解方法分解逻辑门。
decomp_dev = qml.device("default.qubit", wires=3, custom_decomps=custom_decomps)
decomp_qnode = qml.QNode(circuit, decomp_dev)
```

输出结果：

```shell
>>> print(qml.draw(decomp_qnode, level="device")(weights))
0: ──RX(0.40)────╭●──H───────╭Z──H─┤  <Z>
1: ──RX(0.50)──H─╰Z──H─╭●────│─────┤
2: ──RX(0.60)──H───────╰Z──H─╰●────┤
```

# 9. 量子编译流程

## 9.1 catalyst混合量子程序实时编译器

通过pip安装：
```shell
pip install pennylane-catalyst
```

使用`@qjit`装饰器编译量子程序

```python
from jax import numpy as jnp

dev = qml.device("lightning.qubit", wires=2, shots=1000)

@qml.qjit
@qml.qnode(dev)
def circuit(params): # 一个量子电路
    qml.Hadamard(0)
    qml.RX(jnp.sin(params[0]) ** 2, wires=1)
    qml.CRY(params[0], wires=[0, 1])
    qml.RX(jnp.sqrt(params[1]), wires=1)
    return qml.expval(qml.Z(1))
```

`@qjit`还可以编译混合量子程序。即：同时包括量子电路和经典处理流程的函数。

```python
@qml.qjit
def hybrid_function(params, x):
    grad = qml.grad(circuit)(params) # 量子电路
    return jnp.abs(grad - x) ** 2 # 经典数据处理
```

## 9.2 控制流程

Catalyst编译器，可以支持使用python中的条件控制来控制量子电路。需要设置参数`autograph=True`

```python
@qml.qjit(autograph=True) # 设置参数
@qml.qnode(dev)
def circuit(x: int):
    # 使用python的控制流
    if x < 5: 
        qml.Hadamard(wires=0)
    else:
        qml.T(wires=0)

    return qml.expval(qml.Z(0))
```

输出结果:

```shell
>>> circuit(3)
array(0.)
>>> circuit(5)
array(1.)
```

AutoGraph的使用存在一些限制，见相关文档[AutoGraph Guid](https://docs.pennylane.ai/projects/catalyst/en/stable/dev/autograph.html)

# 10. 使用CUDA Quantum

> **注：CUDA Quantum 不支持 Catalyst编译器的一些特性，如：AutoGraph，控制流、测量统计信息等。**

pip安装CUDA Quantum

```shell
pip install pennylane-catalyst cuda_quantum
```

在`@qml.qjit`装饰器中设置参数：`compiler=cuda_quantum`。

```python
# 设置设备类型为software.qpp
dev = qml.device("softwareq.qpp", wires=2)

# 编译器使用CUDA Quantum
@qml.qjit(compiler="cuda_quantum")
@qml.qnode(dev)
def circuit(x):
    qml.RX(x[0], wires=0)
    qml.RY(x[1], wires=1)
    qml.CNOT(wires=[0, 1])
    return qml.expval(qml.Y(0))
```

输出结果：

```
>>> circuit(jnp.array([0.5, 1.4]))
-0.47244976756708373
```

CUDA Quantum的设备类型存在限制：
1. `softwareq.qpp`: a modern C++ statevector simulator

2. `nvidia.custatevec`: The NVIDIA CuStateVec GPU simulator (with support for multi-gpu)

3. `nvidia.cutensornet`: The NVIDIA CuTensorNet GPU simulator (with support for matrix product state)

