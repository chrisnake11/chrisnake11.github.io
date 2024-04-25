---
title: 程序的机器表示
published: 2024-04-25T16:00:00Z
description: '程序的的机器表示'
image: 'https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/1092830.jpg'
tags: ['计算机基础', '程序编译', '汇编']
category: '计算机基础'
draft: true
---

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

#### 编译

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

关于汇编代码的解释如下：

1. `push rbx`: 将寄存器 rbx 的值压入栈中，以便在函数执行过程中可以使用它而不会覆盖它的值。
2. `mov rbx, rdx`: 将第三个参数（一个 long 类型的指针）的值（地址）赋给寄存器 rbx。这个寄存器 rbx 将被用来存储结果。
3. `call mult2(long, long)`: 调用函数 `mult2`，并传入两个 long 类型的参数。这个函数的目的是将这两个参数相乘，并返回结果。在调用 `mult2` 之后，**结果将被存储在寄存器 `rax` 中**。
4. `mov QWORD PTR [rbx], rax`: 将寄存器 `rax` 中的值（即相乘的结果）存储到 rbx 指向的地址中。`QWORD PTR` 表示操作的数据大小是一个 quadword（64 位），因为 long 类型在大多数系统上是 64 位的。
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

根据objdump的结果可以看出，生成的二进制文件mstore.o一共有14条指令（每个x86-64指令长1~15字节）