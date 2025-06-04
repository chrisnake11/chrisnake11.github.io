---
title: make_shared和shared_ptr的区别
published: 2025-05-13T22:43:25Z
tags: ['C++']
category: 'C++'
---

# make_shared和shared_ptr的区别

在单例模式的代码中，当我使用make_shared时，出现了如下的问题：

```C++
#pragma once
#include <memory>
#include <iostream>
#include <mutex>
template <typename T>
class Singleton{
protected:
	Singleton() = default;
	Singleton(const Singleton<T>&) = delete;
	Singleton<T> operator=(const Singleton<T>&) = delete;
	
	static std::shared_ptr<T> _instance;
public:
	static std::shared_ptr<T> GetInstance() {
		static std::once_flag flag;
		std::call_once(flag, [&]() {
            /***
                在这里，不能使用make_shared
                _instance = std::shared_ptr<T>(new T);
            ***/
			_instance = std::make_shared<T>();
			});
		return _instance;
	}

	void PrintAddress() {
		std::cout << _instance.get() << std::endl;
	}

	~Singleton() {
		std::cout << "~Singleton()" << std::endl;
	}
};

template <typename T>
std::shared_ptr<T> Singleton<T>::_instance = nullptr;

// LogicSystem是继承了Singleton的单例类
LogicSystem::GetInstance()->PostMsgToQueue(std::make_shared<LogicNode>(_self_shared_ptr, _msg_recv_node))
```

报错如下：

```
1>D:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.41.34120\include\xutility(403,61): error C2248: “LogicSystem::LogicSystem”: 无法访问 private 成员(在“LogicSystem”类中声明)
1>(编译源文件“CSession.cpp”)
1>    D:\dev\cpp\NetworkProgramming\Async_Server_Logic\LogicSystem.h(25,2):
1>    参见“LogicSystem::LogicSystem”的声明
1>    D:\dev\cpp\NetworkProgramming\Async_Server_Logic\LogicSystem.h(19,7):
1>    参见“LogicSystem”的声明
```

报错表示，当需要初始化LogicSystem时，需要调用LogicSystem的构造函数。

然而这个构造函数被设置为`private`，无法被访问。

因此代码报错，表示无法访问。

## 分析

前提条件：

1. 在`LogicSystem`类中，构造函数是私有的；`Singleton<LogicSystem>`是其友元类。

2. 调用`make_shared`表示需要在这个类中，调用`LogicSystem`类的构造函数。

**但是，`make_shared<T>`是一个模板展开，在模板实例化的过程中，友元的权限不会生效。**

因此`Singleton<T>`中的静态函数无法访问`LogicSystem`类的 **私有** 构造函数。

### 为什么可以使用`shared_ptr<T>(new T)`的方式？

```C++
static std::shared_ptr<T> GetInstance() {
	static std::once_flag flag;
	std::call_once(flag, [&]() {
		_instance = std::shared_ptr<T>(new T());  // 可以访问 private 构造
	});
	return _instance;
}
```

由于`new T()`发生在作用域`Singleton<T>`类的作用域中。而`Singleton<T>`是`T`的友元类，因此可以访问`T`中的私有构造函数。

但是，对于
```C++
_instance = std::make_shared<T>();
```
本质上会被展开为两个部分
```C++
::operator new() // allocate memory
::new(ptr) T() // construct T on ptr memory
```
**关键：`std::make_shared<T>()`是在`std`命名空间中的一个模板函数，它不在`Singleton<T>`的作用域中。**

`std::make_shared<T>()`编译期在 `std` 命名空间中尝试调用 `T::T()` 无法访问。

## 总结

可以把`make_shared`看作一个**全局的模板函数**，这个模板函数通过调用类的`std::new T()`，即对应类的构造函数构造对象。它不在类的内部作用域中，因此无法访问类的私有的成员。




