---
title: 09RVO和移动构造
published: 2025-02-12T21:20:36Z
tags: ['C++']
category: 'C++'
---

# 移动构造和编译器的RVO优化

RVO (Return Value Optimization，返回值优化)

```C++
class Test{
public:
    int * data = 0;
};

Test func(){
    Test t1;
    return t1;
}

int main(){
    Test t2 = test();
    std::cout << "t.data = " << *t.num << std::endl;
    return 0;
}
```

在func()中，直接返回局部对象t1给main()时，编译器会进行RVO优化。

> 即：直接在func()中的t所在的内存空间上直接构建main()函数中的t2对象。跳过了内存拷贝和创建临时对象带来的开销。

如果使用移动构造，需要先开辟一块内存空间用于存储t2对象，然后再把t1的数据移动到t2中。

+ RVO的特点：在原始内存上构建对象，跳过了构造和析构的步骤，效率更高，内存开销更少。
+ 移动构造的特点：开辟一块内存存放新的对象，通过指针转移数据所有权，减少了数据拷贝的开销。