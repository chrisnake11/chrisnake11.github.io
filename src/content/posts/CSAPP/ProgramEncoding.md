---
title: 程序的机器表示
published: 2024-04-25T16:00:00Z
description: '程序的的机器表示'
image: 'https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/1092830.jpg'
tags: ['计算机基础', '程序编译', '汇编']
category: 'CSAPP'
draft: false
---

[toc]

# 程序的机器表示

```mermaid
flowchart LR
    源代码文本.cpp --> 预编译代码.i --> 汇编代码.s --> 机器代码.o --> 链接后的机器代码.out
```

## 程序编码

```bash
$linux> gcc -Og -o main.out mian.cpp h1.h
```
+ -g 表示可以使用gdb调试
+ -Og 告诉编译器生成符合原始C代码的整体结构的机器代码优化

### 机器代码

计算机的机器代码抽象主要有两个部分：
1. 使用指令集架构(Instruction Set Architecture ISA)，定义CPU硬件的行为。
2. 使用虚拟内存抽象多个内存存储器和操作系统。将实际内存看成一个大的内存数组。

杂项知识：

+ PC(programming counter)程序计数器，指向下一条指令的内存地址（X86-64中为`%rip`）
+ x86-64系统的内存地址一共能够记录$2^{64}$字节。一般内存的高16为设置为0，所以只有$2^{48}$字节数据。
+ 寄存器还有：整数寄存器(Integer, address, pointer)、条件码寄存器(if, while)、向量寄存器(浮点数)。。。

### 编译

在[Compiler Explorer](https://godbolt.org/)下编译如下代码，得到汇编文件(.s)

```cpp
//mstore.c
long mult2(long, long);
void multstore(long x, long y, long * dest){
    long t = mult2(x, y);
    *dest = t;
}
```

```bash
# -S表示汇编
gcc -Og -S mstore.c
```

```assembly
multstore(long, long, long*):
        push    rbx
        mov     rbx, rdx
        call    mult2(long, long)
        mov     QWORD PTR [rbx], rax
        pop     rbx
        ret
```

关于**汇编代码的解释**如下：

1. `push rbx`: 将寄存器 `rbx` 的值压入栈中，以便在函数执行过程中可以使用它而不会覆盖它的值。
2. `mov rbx, rdx`: 将第三个参数`dest`（一个 long 类型的指针）的值（地址）赋给寄存器 `rbx`。这个寄存器 `rbx` 将被用来存储返回值结果。
3. `call mult2(long, long)`: 调用函数 `mult2`，并传入两个 long 类型的参数。这个函数的目的是将这两个参数相乘，并返回结果。在调用 `mult2` 之后，**结果将被存储在寄存器 `rax` 中**。
4. `mov QWORD PTR [rbx], rax`: 将寄存器 `rax` 中的值（即相乘的结果）存储到 `rbx` 指向的地址中。`QWORD PTR` 表示操作的数据大小是一个 `quadword`（long 64 位）。
5. `pop rbx`: 将之前压入栈的 `rbx` 的值弹出，恢复它的原始值。
6. `ret`: 返回函数。

```bash
# -c 编译汇编代码，生成机器码
gcc -Og -c mstore.c
```

利用objdump可以进行反汇编二进制文件，得到汇编代码。

```assembly
$ objdump -d mstore.o

mstore.o:       file format coff-x86-64

Disassembly of section .text:

0000000000000000 <multstore>:
       0: 56                            pushq   %rsi
       1: 48 83 ec 20                   subq    $0x20, %rsp
       5: 4c 89 c6                      movq    %r8, %rsi
       8: e8 00 00 00 00                callq   0xd <multstore+0xd>
       d: 89 06                         movl    %eax, (%rsi)
       f: 48 83 c4 20                   addq    $0x20, %rsp
      13: 5e                            popq    %rsi
      14: c3                            retq
```

根据objdump的结果可以看出，生成的二进制文件`mstore.o`一共有14条指令（每个x86-64指令长1~15字节）

#### 汇编的数据格式

| C声明      | Intel数据类型 | 汇编指令后缀 | 大小 |
| ---------- | ------------- | ------------ | ---- |
| char       | Bytes         | b            | 1B   |
| short      | Word          | w            | 2B   |
| int        | Double Words  | l            | 4B   |
| long/char* | Quad Words    | q            | 8B   |
| float      | 单精度        | s            | 4B   |
| double     | 双精度        | l            | 8B   |

因此：在上面的汇编代码中`pushq, moveq, addq, popq, retq`都表示操作一个`Quad Words`大小的数据

### 访问信息

在汇编代码中，操作数（operand）分为三种

1. 立即数，一般用$开头
2. 寄存器`%rax,%rbx,%rsp`等
3. 内存引用，根据内存引用，访问指定内存地址的值。

#### x86-64下,常用的寄存器

1. `rax`：accumulate register累加寄存器，**算数运算**和**返回值**。
2. `rbx`：base register，基本地址寄存器，**基址指针**。
3. `rcx`：counter register，计数寄存器，例如for循环累加。
4. `rdx`：Data Register，数据寄存器，用于算数运算和IO操作（函数的**第二个参数**）
5. `rsi`：source index，源地址寄存器，函数的**第六个参数**
6. `rdi`：dest index，目的地址寄存器，函数的**第七个参数**
7. `rsp`：stack pointer，栈地址寄存器（指向当前**栈顶**）
8. `rbp`：Base Pointer，基地址寄存器（指向当前栈帧的**基地址**）
9. `rip`：instructor Pointer，指令寄存器，存储当前指令的地址(PC)
10. `EFLAGS`：存储算数运算和逻辑运算的标志。

### 寻址模式

寻址模式分为很多种，和寻址相关的参数有以下几种：

1. $Imm$，内存偏移立即数。可以用于直接表示数据，或者内存地址，或者整体内存的偏移。
2. $r_b$，基址寄存器，作为内存地址的起始位置（没有$Imm$的情况）
3. $r_i$，变址寄存器，在基址寄存器的基础上，进一步偏移
4. $s$​，比例因子，乘以变址寄存器，按照倍率进行寻址地址。

内存地址的计算公式
$$
Address = (Imm) + R[r_a] + R[r_i] (* s)
$$
$R[x]$表示读取寄存器中的值，$()$中的内容可选，表示不同的寻址模式。

1. 使用$M[Imm]$​，表示在寄存器表示的相对地址上，加一个整体的offset。
2. 使用$R[r_i]$，表示变址寻址
3. 使用$R[r_i]*s$​​，表示比例变址寻址。

| 类型                   | 例子            |
| ---------------------- | --------------- |
| 直接寻址               | %rax            |
| 间接寻址               | (%rax)          |
| 变址寻址（有立即数）   | 4(%rax)         |
| 变址寻址（无立即数）   | 9(%rax, %rdx)   |
| 比例变址寻址(有立即数) | 0xFC(, %rax, 4) |
| 比例变址寻址(无立即数) | (%rax, %rdx, 4) |

### 汇编操作

**mov**：将数据拷贝一份，S -> D

```assembly
mov	S, D
```

+ src：必须是一个立即数、或者存储在寄存器或者内存中。
+ dest：寄存器，或者内存。（不可能是立即数）

> 在x86-64指令集下，当两个操作数都是内存地址时，必须要拆分成两条指令，使用一个寄存器来过渡。

**movz[bl]**：将操作数**零扩展**到目的地址

- b：src的数据类型
- l：dest的数据类型

**movs[bl]**：将操作数**符号扩展**到目的地址

- b：src的数据类型
- l：dest的数据类型

**cltq：**将%eax符号扩展到%rax

```c++
long exchange(long *xp, long y){
    long x = *xp;
    *xp = y;
    return x;
}
```

```assembly
#long exchange(long* xp, long y) 
#xp in %rdi , y in %rsi 
# %rax专门存储返回值，%rdi, %rsi表示函数的参数
exchange: 
    movq 	(%rdi), %rax # Get x at xp . Set as return value . 
    movq 	%rsi, (%rdi) # Store y at xp 
    ret 				 # return
```

---

**push/Pop**：将操作数入栈/出栈

在内存模型中，栈是倒过来画的，因此栈是**向下增长，从高内存到低内存**的。

寄存器`%rsp`始终指向栈顶内存。

**pushq S**：更新`%rsp`，指向新的栈顶内存地址，然后将src入栈。

等价于：

```assembly
subq $8, %rsp #%rsp - 8，因为内存向下增长，所以用减法
movq %rbp, (%rsp) # 将%rbq的数据，拷贝到%rsp指向的内存
```

---



**Pop D**：将栈顶数据拷贝到D，然后更新`%rsp`

等价于：

```assembly
movq (%rsp) %rbp
addq $8, %rsp # 栈向上缩小，用加法
```

---

**算数操作指令**

![image-20240430114908399](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/image-20240430114908399.png)



**leadq S, D**：将S内存中的数据读取到寄存器D

leadq并没有使用()来引用寄存器的内存，

leadq能执行加法和有限形式的乘法

```c
long scale(long x, long y, long z){
    long t = x + 4 * y + 12 * z;
    return t
}
```

```assembly
# long scale(long x, long y, long z) 
# x in %rdi , y in %rsi , z in %rdx 
scale: 
    leaq (%rdi,%rsi,4), %rax # x + 4*y
    leaq (%rdx,%rdx,2), %rdx # z + 2*z = 3*z
    leaq (%rax,%rdx,4), %rax # (x + 4*y) + 4*(3*z) = x + 4*y + 12*z
    ret
```

---

##### 其余一、二元操作符同理，基本都是从左到右，最终作用在右边的操作数上

+ 对于**sub S, D**命令，是从**D中减去S**，然后作用在D上。

> 反正也是作用在右边。

+ 因此，一般**右边的操作数不能为立即数**。

### 条件码(condition code)

if-else, switch等条件判断语句，需要用到条件码寄存器来执行条件分支的指令.

条件寄存器的条件码：

1. **CF(carry flag)**：检测最高位产生进位，检测无符号数溢出
2. **ZF(zero flag)**：最近的操作结果为0
3. **OF(overflow flag)**：最近的操作导致补码溢出。
4. **SF(sign flag)**：最近操作结果为负数

设置条件码的指令：

1. INC和DEC
2. CMP
3. TEST

**CMP S1, S2**：计算S1 - S2

**TEST S1, S2**：计算S1 & S2

> CMP和TEST指令，不会改变寄存器的值

#### 访问条件码

![image-20240427172656119](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/image-20240427172656119.png)

指令格式：[setxxx] D，将xxx寄存器的值，赋予D

sete/setz：相等时，赋予ZF给D

sets：结果为负数

> setnx，表示结果取反

setg：有符号大于

setl：有符号小于

seta：无符号大于

setb：无符号小于

> setxe，表示xx等于

#### 条件分支的汇编代码

![image-20240427172825313](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/image-20240427172825313.png)



### 跳转指令

![image-20240427172732476](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/image-20240427172732476.png)

+ 如：jg(jump greater)：根据CMP(做减法)来进行比较，跳转的条件为`~(SF ^ OF) & ~ZF`
+ CMP，表示前操作数 - 后操作数。jg满足一下两个条件
1. 结果不为0，
  
2. 结果为负数 xor 溢出

| SF   | OF   | ~(SF xor OF) | 说明                                     |
| ---- | ---- | ------------ | ---------------------------------------- |
| 0    | 0    | 0            | 结果为正数，没溢出（结果没溢出，为正数） |
| 0    | 1    | 1            | 结果为正数，有溢出（下溢出）             |
| 1    | 0    | 1            | 结果为负数，没有溢出                     |
| 1    | 1    | 0            | 结果为负数，有溢出(结果为负数，往上溢出) |

#### 反汇编代码的阅读

在执行PC的相对寻址时，**PC的值指的是跳转指令后面那条指令的地址，而不是当前指令的地址**。在加上当前指令中的偏移量，就可以得到跳转后的地址。

![image-20240526113033121](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/image-20240526113033121.png)



#### 利用条件控制来实现条件分支

核心：通过一个判断来控制条件转移，两个不同条件的代码，**只会执行其中一个分支**。

如下代码：展示了如何将一个复合的条件分支转化为汇编代码。

其中：布尔短路，就表现在在第一个条件控制代码中，(当p == null时，直接jp到 .L1)

![image-20240526135711951](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/image-20240526135711951.png)

#### 利用条件传送来实现条件分支

核心：计算一个条件操作下的，两种结果代码，然后根据条件，来直接选择结果。（**两个分支的代码都会执行**，得到结果，然后再进行选择。）

![image-20240526141844385](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/image-20240526141844385.png)

#### 基于条件数据传送的代码会比基于条件控制转移的代码性能比较

二者的区别，主要取决于现代处理器的流水线指令模式。CPU再执行运算前，需要执行以下5个阶段的操作。只有当CPU取指后，能够按照顺序不中断地执行下去，这样才能最好地发挥CPU的性能。

##### 指令流水线的基本阶段

典型的指令流水线包括以下几个阶段：

1. **取指（Fetch）**：从内存中取出指令。
2. **译码（Decode）**：解析指令，确定操作类型和操作数。
3. **执行（Execute）**：执行指令操作，例如算术运算或逻辑运算。
4. **访存（Memory Access）**：访问内存操作数（如果需要）。
5. **写回（Write Back）**：将结果写回寄存器或内存。

为了保证这一性能的高效性，现代CPU通常会采用某种方法来预测下一个跳转条件分支，从而实现指令执行的连续性。当预测错误之后，再重新取指，从头开始执行。（重新取指会导致CPU空闲，浪费性能）

+ 对于基于条件控制的代码来说，当预测失败的时候，就需要进行重新取指，这就会导致CPU**指令吞吐量**低下。

+ 对于基于条件数据传送的代码来说，会直接执行两个条件分支中的所有指令，然后再使用**条件移动指令(如：cmov)**来进行赋值。这不会中断流水线，因为它不会改变程序的控制流，不需要进行分支预测，清除和重新加载指令**（条件移动指令的特性）**。

