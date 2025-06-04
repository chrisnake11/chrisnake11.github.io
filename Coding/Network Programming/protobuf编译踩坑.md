---
title: protobuf编译踩坑
published: 2025-05-10T14:26:36Z
tags: ['C++']
category: 'C++'
---

# 在Win11下，使用VS2022编译Protobuf

参考连接：https://blog.csdn.net/qq_45576085/article/details/140035857

问题：以相同的方式，在VS2022的DEBUG模式下进行Protobuf编译，以及在DEBUG模式下配置测试程序。但是出现LINK 1104错误，无法找到`protobufd.lib`和`protocd.lib`文件。

解决方法：生成了protobuf的Release版本的lib文件。并在项目中使用Release版本的配置进行测试。

> 可以链接release版本的lib文件，无法找到debug版本的lib文件。难道DEBUG版本生成的lib文件有问题？

# Protobuf的用法

Protobuf生成类，除了类的成员变量，还会生成对应的 **构造函数、getter、setter、以及相关的序列化函数** 。

序列化的API：[Parsing-Serialization](https://protobuf.dev/getting-started/cpptutorial/#parsing-serialization)

Example: [Write/Read](https://protobuf.dev/getting-started/cpptutorial/#writing-a-message)

在简单的示例中主要为3部分：
1. 将对象序列化字符串（Protobuf）
2. 字符串通信(服务器负责)
3. 字符串变为对象（protobuf）。