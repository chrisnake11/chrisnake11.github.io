---
title: 05引用和const
published: 2025-01-09T16:23:48Z
description: '05引用和const'
image: ''
tags: ['C++']
category: 'C++'
---

# 引用和Const

1. const引用可以绑定一个右值表达式
```C++
int m = 100;
int& r1 = m;
int & r2 = r1 * 2 // 错误，左值引用不能绑定右值表达式
const int & r3 = r1 * 2; // const引用可以绑定右值表达式
```
2. const引用可以绑定一个不同类型的值。
```C++
double dval = 3.14;

int & r1 = dval; // 错误，引用类型不匹配

const int & r2 = dval; //可以(为什么?)
```

答：编译器会默认进行两部转换
```C++
const int temp = dval;
const int & r2 = temp;
```