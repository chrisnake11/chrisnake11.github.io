---
title: 15SFINAE
published: 2025-02-18T17:52:13Z
tags: ['C++']
category: 'C++'
---

# SFINAE(Substitution Failure Is Not An Error)

工作原理：在模板实例化过程中，编译器会尝试将模板参数替换为具体的类型。
如果在替换过程中出错，编译器**不会报错**，而是将该模板是为**不可行**，
继续**尝试其他模板**或重载，直到**找到有效的匹配**。
这一特性允许开发者根据类型特性选择不同的模板实现。

## std::enable_if (C++11)

## concept (C++20)

## 

```C++
template<typename T>
class has_foo{
private:
    typedef char yes[1];
    typedef char no[2];
    template<typename U, void(U::*)()>
    SFINAE{};

    template<typename U>
    static yes& test(SFINAE<U, &U::foo>*);

    template<typename U>
    static no& test(...)
public:
    static constexpr bool value = sizeof(test<T>(0)) == sizeof(yes);
};
```

## 类型萃取 (C++17)

通过类型萃取，来判断一个数据是否为container(即：内部包含有类型的数据。如：`vector<int>`，内部包含int类型)

### class: false_type && true_type

```C++
// defualt, extend from false_type
// std::false_type has a member called "value"; default, value = false;
// has_value_type::value = false;
template<typenam T, typename = void>
class has_value_type: std::false_type{};

// extend from true_type
// std::true_type has a member called "value"; default, value = true;
template<typename T>
class has_value_type<T, std::enable_if<!std::is_void_v<typename T::value_type>>>::std::true_type{};

// general template

//     if T is not void, has_value_type<T> extends from std::true_type. 
// then, has_value_type<T> has a member called "value" which is true;
template<typename T, bool HasValueType = has_value_type<T>::value>
class TypePrinter;

// specific template
template<typename T, true>
class TypePrinter{
public:
    static void print(){
        std::cout << "T has a value_type member" << std::endl;
    }
};


// specific template
template<typename T, false>
class TypePrinter{
public:
    static void print(){
        std::cout << "T does not have a value_type member" << std::endl;
    }
};


```


