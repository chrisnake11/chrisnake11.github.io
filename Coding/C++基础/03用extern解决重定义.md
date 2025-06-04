---
title: 03用extern解决重定义
published: 2025-01-09T15:07:07Z
description: '03用extern解决重定义'
image: ''
tags: ['C++']
category: 'C++'
---

# 重定义问题

问题：假设存在以下三个C++文件，编译会报错。

`global.h`: 定义两个变量
```C++
#pragma once
#include <string>

int global_val = 10;

std::string global_str = "hello";
```

`global.cpp`: 直接包含头文件
```C++
#include "global.h"
```

`main.cpp`: 同样包含头文件
```C++
#include <iostream>
#include "global.h"

int main()
{
    std::cout << "global_val is " << global_val << std::endl;
    std::cout << "global_str is " << global_str << std::endl;
    std::cout << "Hello World!\n";
    return 0;
}

/*** 报错如下 ***

1>global.obj : error LNK2005: "int global_val" (?global_val@@3HA) 已经经在 externs_demo.obj 中定义

1>global.obj : error LNK2005: "class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > global_str" (?global_str@@3V?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@A) 已经在 externs_demo.obj 中定义

1>D:\dev\cpp\Cpp_Basic\externs_demo\x64\Debug\externs_demo.exe : fatal error LNK1169: 找到一个或多个多重定义的符号

*/
```

> 报错`LINK`，表示在链接`global.obj`文件时产生了错误，报错信息显示，`global_val`和`global_str`已经在`externs_demo.obj`定义了。

解释如下：

1. 后缀为cpp的源文件会分别预编译`global.h`的内容，然后各自定义`global.h`中的变量。
2. 在本示例中，`main.cpp`先编译，得到了`externs_demo.obj`文件，随后`global.cpp`编译后，与`externs_deme.obj`链接时，就发现了重复定义的错误。

# extern

extern关键字，主要用于在头文件声明一个全局变量/函数，且这个全局变量/函数会在另一个文件或者同一个文件的其他位置（多处）定义。确保在**多个源文件引用同一个头文件**时，能够正确地链接到这个全局变量/函数的定义。


解决方法：
+ 将**声明和定义分开**，在头文件中只声明变量（使用`extern`关键字）
+ 在源文件中定义变量。

> 注：当不使用`extern`关键字时，编译器不会只声明变量，而是会**直接初始化（定义）变量**。

`global.h`：添加extern关键字，去除定义变量的相关代码。
```C++
#pragma once
#include <string>

extern int global_val;

extern std::string global_str;
```

# const的特殊性

当在头文件定义了const变量时，且这个头文件被多个源文件包含。

此时编译器会在`.rodata`中定义多个不同的const变量（这些变量的地址不同）

但是，如果在头文件中使用`extern`关键字声明`const`变量，那么编译器只会在对应的源文件中，定义一个`const`变量。