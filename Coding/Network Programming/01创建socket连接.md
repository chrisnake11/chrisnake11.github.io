---
title: 网络编程基础
published: 2024-06-24T14:00:00Z
description: '复习网络编程基础知识：socket, IO事件处理Proactor, Reactor等。'
image: ''
tags: ['c++', '网络编程']
category: 'c++'
draft: false
---


# 1. 网络编程基本步骤

在客户端与服务器建立TCP连接地过程中，需要使用socket进行通信。其中client和server分别要经过一些状态。

客户端:
1. 创建socket --- 创建socket对象
2. connect服务器 --- 连接服务器
3. write&read --- 与服务器通信

服务端：
1. 创建socket
2. bind --- 绑定本机ip和port
3. listen --- 让socket监听事件
4. accept --- 接受事件，单独创建一个socket和客户端通信
5. read&write --- 与客户端通信

> 在使用boost库建立TCP连接的过程中，通常需要创建两个常见对象`tcp::endpoint`和`ip::iocontext`
> 1. endpoint表示一个网络通信端(标记)，客户端绑定server的IP地址和端口，服务端则绑定自己的IP地址和端口
> 2. iocontext对象，赋予socket进行`I/O`通信的能力，提供**事件驱动机制**，确保 `socket` 能够正确执行 `connect()`、`accept()`、`read()`、`write()` 等操作。

## 1.1 客户端创建socket
1. 创建endpoint
2. 创建iocontext和socket
   1. 如果IP地址为DNS域名，那么还需要resolver::query和resolver对象解析DNS地址。
   2. 生成resolver::iterator对象后，再创建socket
3. socket执行connect

## 1.2 服务端创建socket

1. 设置连接缓冲区大小
2. 创建endpoint
3. 创建iocontext
4. 创建aceptor绑定endpoint，接收事件
5. acceptor监听事件
6. 使用iocontext创建一个socket对象与客户端通信
7. acceptor接受socket


# 2. IO事件处理

网络编程模式，一遍可以分为同步模式 `Reactor` 和 异步模式 `Proactor`。

+ Reactor模式：让主线程负责监听文件描述符是否有事件发生，有事件立即通知工作线程进行读、写和处理数据。工作线程会从内核中拷贝数据。
  + Reactor模式中，主线程的行为与具体的I/O多路复用方式有关。
+ Proactor模式：让主线程负责监听文件描述符上的事件，并且读、写数据到主线程的用户缓冲区中。工作线程并发地处理主线程缓冲区中的数据。

> 二者的主要区别，就是I/O部分由主线程，还是工作线程完成。


# 3. 