---
title: 程序的机器表示
published: 2024-05-26T16:00:00Z
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

# 程序编码

```bash
$linux> gcc -Og -o main.out mian.cpp h1.h
```
+ -g 表示可以使用gdb调试
+ -Og 告诉编译器生成符合原始C代码的整体结构的机器代码优化

## 机器代码

计算机的机器代码抽象主要有两个部分：
1. 使用指令集架构(Instruction Set Architecture ISA)，定义CPU硬件的行为。
2. 使用虚拟内存抽象多个内存存储器和操作系统。将实际内存看成一个大的内存数组。

杂项知识：

+ PC(programming counter)程序计数器，指向下一条指令的内存地址（X86-64中为`%rip`）
+ x86-64系统的内存地址一共能够记录$2^{64}$字节。一般内存的高16为设置为0，所以只有$2^{48}$字节数据。
+ 寄存器还有：整数寄存器(Integer, address, pointer)、条件码寄存器(if, while)、向量寄存器(浮点数)。。。

## 编译

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

### 汇编的数据格式

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

### x86-64下,常用的寄存器

1. `rax`：accumulate register累加寄存器，**算数运算**和**返回值**。
2. `rbx`：base register，基本地址寄存器，**基址指针，也用于保存函数调用者的返回值。**
3. `rcx`：counter register，计数寄存器，例如for循环累加。
4. `rdx`：Data Register，数据寄存器，用于算数运算和IO操作（函数的**第二个参数**）
5. `rsi`：source index，源地址寄存器，函数的**第六个参数**
6. `rdi`：dest index，目的地址寄存器，函数的**第七个参数**
7. `rsp`：stack pointer，栈地址寄存器（指向当前**栈顶**）
8. `rbp`：Base Pointer，基地址寄存器（指向当前栈帧的**基地址**）
9. `rip`：instructor Pointer，指令寄存器，存储当前指令的地址(PC)
10. `EFLAGS`：存储算数运算和逻辑运算的标志。

## 寻址模式

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

## 汇编操作

**mov**：将数据拷贝一份，S -> D

> 注：CSAPP中文第三版的内容有误，与实际GCC中的数据移动方向相反。

```assembly
mov	D, S
```

+ src：必须是一个立即数、或者存储在寄存器或者内存中。
+ dest：寄存器，或者内存。（不能是内存）

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

在内存模型中，栈是倒过来画的，因此栈是**向下增长，从高内存到低内存**的，因此在**栈上分配内存**一般使用**sub指令**。

寄存器`%rsp`指向栈顶内存

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
    leadq (%rdi,%rsi,4), %rax # x + 4*y
    leadq (%rdx,%rdx,2), %rdx # z + 2*z = 3*z
    leadq (%rax,%rdx,4), %rax # (x + 4*y) + 4*(3*z) = x + 4*y + 12*z
    leadq 7(%rax), %rdx # *(7 + %rax) + %rdx, 7 is base address offset.
    ret
```

---

### 其余一、二元操作符同理，基本都是从左到右，最终作用在右边的操作数上

+ 对于**sub S, D**命令，是从**D中减去S**，然后作用在D上。

> 反正也是作用在右边。

+ 因此，一般**右边的操作数不能为立即数**。
