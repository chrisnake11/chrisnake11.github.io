---
title: Qiskit工具使用
published: 2024-04-26T10:00:00Z
description: '关于IBM Qiskit工具包的使用'
image: 'https://raw.githubusercontent.com/chrisnake11/picgo/main/blogimage-20240426104721614.png'
tags: ['Quantum Computing', 'Qiskit']
category: 'Quantum Computing'
draft: false
---

## Numpy表示矩阵

+ ([row1], [row2], ... , [row_n])的形式表示matrix。
+ 可以使用`display()`函数, 分行打印matrix。


```python
from numpy import array
from numpy import sqrt
```


```python
a1 = ([sqrt(2)/2, sqrt(2)/2], [sqrt(2)/2, -sqrt(2)/2])
display(a1)
```


    ([0.7071067811865476, 0.7071067811865476],
     [0.7071067811865476, -0.7071067811865476])


## numpy中的矩阵乘法
使用`matmul(a, b)`函数实现a * b


```python
from numpy import matmul
a2 = ([1, 1], [0, 0])
v1 = ([0, 1])
display(a2)
display(v1)
display(matmul(a2, v1))
```


    ([1, 1],
    [0, 0])
    
    [0, 1]
    
    array([1, 0])


## Qiskit表示量子态
使用`Statevector()`创建一个量子态


```python
import qiskit._accelerate
from qiskit import QuantumCircuit
from qiskit.quantum_info import Statevector

u = Statevector([1 / sqrt(2), 1/sqrt(2)])
```


```python
display(u.draw("Latex"))
```


$$\frac{\sqrt{2}}{2} |0\rangle+\frac{\sqrt{2}}{2} |1\rangle$$


## 直接导入特殊向量
使用张量积


```python
zero = Statevector.from_label("0")
one = Statevector.from_label("1")
zero.tensor(one).draw("latex")
```


$$ |01\rangle$$




```python
plus = Statevector.from_label("+")
minus = Statevector.from_label("-")
psi = plus.tensor(minus)
psi.draw("latex")
```

$$
\frac{1}{2} |00\rangle- \frac{1}{2} |01\rangle+\frac{1}{2} |10\rangle- \frac{1}{2} |11\rangle
$$



### 使用Operator能自定义变换矩阵


```python
from qiskit.quantum_info import Operator
X = Operator([[0, 1], [1, 0]])
I = Operator([[1, 0], [0, 1]])
U = X.tensor(I)
U.draw("latex")
```


$$
\begin{bmatrix}
0 & 0 & 1 & 0  \\
 0 & 0 & 0 & 1  \\
 1 & 0 & 0 & 0  \\
 0 & 1 & 0 & 0  \\
 \end{bmatrix}
$$

`X tensor Y`, 即：$X \otimes Y$
$$
(X \otimes I)(|\psi\rangle)
$$


```python
psi.evolve(I ^ X).draw("latex")
```

$$
- \frac{1}{2} |00\rangle+\frac{1}{2} |01\rangle- \frac{1}{2} |10\rangle+\frac{1}{2} |11\rangle
$$



`X ^ ` 与 `X tensor Y` 等价


```python
psi.evolve(I ^ X).draw("latex")
```

$$
- \frac{1}{2} |00\rangle+\frac{1}{2} |01\rangle- \frac{1}{2} |10\rangle+\frac{1}{2} |11\rangle
$$




```python
CX = Operator([
    [1, 0, 0, 0],
    [0, 1, 0, 0],
    [0, 0, 0, 1],
    [0, 0, 1, 0]
])
CX.draw("latex")
```


$$
\begin{bmatrix}
1 & 0 & 0 & 0  \\
 0 & 1 & 0 & 0  \\
 0 & 0 & 0 & 1  \\
 0 & 0 & 1 & 0  \\
 \end{bmatrix}
$$




```python
psi.evolve(CX).draw("latex")
```


$$\frac{1}{2} |00\rangle- \frac{1}{2} |01\rangle- \frac{1}{2} |10\rangle+\frac{1}{2} |11\rangle$$



## Particial Measure
对于多个量子比特能够表示$2^n$​种信息，我们可以使用bitmap的形式来表示量子状态，即下标表示对应的基向量

下例中：从左往右下标从0~7，1表示001，2为010，以此类推


```python
W = Statevector([0, 1, 1, 0, 1, 0, 0, 0] / sqrt(3))
W.draw("latex")
```

$$
\frac{\sqrt{3}}{3} |001\rangle+\frac{\sqrt{3}}{3} |010\rangle+\frac{\sqrt{3}}{3} |100\rangle
$$



测量指定下标的部分量子状态, `measure()`中的数组元素，表示测量的qubit下标。


```python
result, new_sv = W.measure([0])
print(f"measured: {result} \n State after measurement")
new_sv.draw("latex")
```

    measured: 0 
     State after measurement

$$
\frac{\sqrt{2}}{2} |010\rangle+\frac{\sqrt{2}}{2} |100\rangle
$$
