---
title: vcpkg配置redis库
published: 2025-05-30T00:21:18Z
tags: ['C++']
category: 'C++'
---

# vcpkg配置redis库

在跟着恋恋风辰zack[UP的教程](https://www.bilibili.com/video/BV1BD421572A)学习C++的过程中，为了简化redis库的安装，我跟着评论区去尝试使用vcpkg来安装redis库。
期间已知报错`LINK : fatal error LNK1104: 无法打开文件“hiredis.lib”`，经过多次尝试，最终成功安装了redis库。

## 安装vcpkg

[vcpkg github](https://github.com/microsoft/vcpkg)

1. 克隆vcpkg仓库到本地
2. 运行目录下的`bootstrap-vcpkg.bat`脚本，完成vcpkg的安装。
3. 脚本会在当前目录下生成`vcpkg.exe`可执行文件。
4. 将vcpkg的安装目录添加到系统环境变量中，方便在命令行中使用。
```bash
vcpkg --version

output:
(base) PS C:\Users\xxx> vcpkg --version
vcpkg package management program version 2025-04-07-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

See LICENSE.txt for license information.
```

## 安装redis库

```bash
vcpkg install hiredis[or redis-plus-plus]
```

## 使用redis库
1. 在visual studio中库目录中添加vcpkg的安装目录，通常是`vcpkg安装目录\installed\x64-windows\debug\lib`。
2. 在包含目录中添加vcpkg的安装目录，通常是`vcpkg安装目录\installed\x64-windows\include`。
3. 在链接器中添加`hiredisd.lib`
4. 将`vcpkg安装目录\installed\x64-windows\debug\lib\hiredisd.lib`拷贝到visual studio项目的目录下。