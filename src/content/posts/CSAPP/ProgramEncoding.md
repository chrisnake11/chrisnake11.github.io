---
title: 程序的机器表示
published: 2024-04-23T16:00:00Z
description: '程序的的机器表示'
image: 'https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/1092830.jpg'
tags: ['计算机基础', '程序编译', '汇编']
category: '计算机基础'
draft: true
---

# 程序的机器表示

```mermaid
flowchart LR
    源代码文本.cpp --> 预编译代码.i --> 汇编代码.s --> 机器代码.o --> 链接后的机器代码.o
```

## 程序编译

```bash
$linux> gcc -Og -o main.out mian.cpp h1.h
```
+ -g 表示可以使用gdb调试
+ -Og 告诉编译器生成符合原始C代码的整体结构的机器代码优化

## 机器代码

计算机的机器代码抽象主要有两个部分：
1. 使用指令集架构(Instruction Set Architecture ISA)，定义CPU硬件的行为。
2. 使用虚拟内存抽象多个内存存储器和操作系统。将实际内存看成一个大的内存数组。