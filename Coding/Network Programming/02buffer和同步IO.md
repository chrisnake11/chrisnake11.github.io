---
title: 02buffer和同步IO
published: 2025-02-25T20:21:25Z
tags: ['C++']
category: 'C++'
---

# buffer对象

在`boost::asio`的I/O操作中，通过`asio::buffer(data)`创建一个缓冲区进行数据的I/O操作。
> buffer函数不创建内存空间，在现有对象的内存上进行封装。

buffer(),生成一个`asio::const/mutable_buffers_1`对象，该类型提供了符合Const/MutableBufferSequence类型的接口，可以进行I/O操作。

在底层，`buffer()`返回一个存储了`const/mutable_buffer`类型的vectgor，`const/mutable_buffer`指向了原始数据的地址。

# 同步IO

在socket进行通信时，无论是write还是read都分别存在4种方法，分别为：
1. `socket.write_some()/read_some():`：每次I/O固定的字节数，如果TCP缓冲区满，就处理一部分，返回已经处理的字节数
   1. 参数：`buffer`
2. `socket.send()/receive()`：每次I/O固定的字节数，如果缓冲区满，直接阻塞等待发送。
   1. 参数：`buffer`
   2. `return`：返回值为负数，出现异常。返回值为0，对方关闭连接。返回值为正数，正常。
3. `asio::write()/read()`：上面socket.send()函数的全局版本，作用相同。
   1. 参数:`socket, buffer`
   2. `return`：返回值和上面的一样
4. `asio::write_until()/read_until()`: 全局的I/O函数，I/O到指定的字符结束，参数分别为`socket, buffer, char`