---
title: 06常量表达式和constexpr
published: 2025-01-09T16:43:11Z
description: '06常量表达式和constexpr'
image: ''
tags: ['C++']
category: 'C++'
---

# 06常量表达式和constexpr

常量表达式是指值不会改变，且无需运行程序，在编译过程就可以得到计算结果的表达式。

举例：
```C++
// size是常量表达式
const int size = 100;

// limit是常量表达式
const limit = size + 1;

// 无const修饰，不是常量表达式
int staff_size = 20;

// 不是常量表达式，需要调用sizeof()计算。
const int sz = sizeof(int);
```

使用constexpr关键字，可以声明一个常量表达式，且在编译过程中编译器会帮助判断表达式是否是常量表达式。

在头文件中使用常量表达式时，需要加上inline关键字，表示将函数在使用的地方直接展开。否则不是常量表达式。

> `constexpr`不能与`extern`搭配使用，`extern`表示在其他地方定义，而`constexpr`要求在当前位置直接定义，使用`inline`可以在当前位置直接展开定义。

## constexpr与指针

constexpr作用在指针上时，只对指针起作用，并不限制指针指向的对象。

```C++
// 
constexpr int * p = nullptr;
// 等价于
int * const p = nullptr;
```


constexpr指针只能绑定nullptr或0，或者地址恒定不变的const变量（这些变量通常存储在`.rodata`中。）