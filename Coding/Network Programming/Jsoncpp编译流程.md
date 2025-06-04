---
title: Jsoncpp编译流程
published: 2025-05-10T22:01:14Z
tags: ['C++']
category: 'C++'
---

# Jsoncpp编译流程

1. 下载源码
2. 创建visual sutdio文件夹，使用Cmake-gui生成vs2022代码
3. 使用vs2022代码，编译生成Debug/Release版本
4. 创建一个`jsoncpp/`文件夹用于保存include目录和lib目录。
5. 拷贝jsoncpp源码中的`include/json/`文件夹到`jsoncpp/include/`目录下。
6. 在visual studio下的`bin/Debug/jsoncpp.dll`，和`lib/Debug/jsoncpp.lib`拷贝到创建的文件夹`jsoncpp/lib/`中。
7. 在测试项目中添加包含目录和库目录
8. 在`链接-输入`选项中，添加lib文件

# Jsoncpp示例

在 JsonCpp 库中，`JSON::Value` 是核心类，用于表示和操作 JSON 数据。下面介绍它的常用函数及其功能：


### **1. 构造函数**
- **`JSON::Value()`**  
  创建空的 JSON 值（`null`）。
- **`JSON::Value(Type type)`**  
  创建指定类型的空值（如`null`、`array`、`object`等）。
- **`JSON::Value(bool value)`** / **`JSON::Value(int value)`** / **`JSON::Value(double value)`** / **`JSON::Value(const char* value)`**  
  创建对应类型的 JSON 值。


### **2. 类型检查**
- **`bool isNull() const`**  
  判断是否为`null`。
- **`bool isBool() const`** / **`isInt()`** / **`isDouble()`** / **`isString()`** / **`isArray()`** / **`isObject()`**  
  判断值的类型。
- **`ValueType type() const`**  
  返回值的类型（枚举值）。


### **3. 值的获取**
- **`bool asBool() const`** / **`int asInt()`** / **`double asDouble()`** / **`std::string asString()`**  
  将值转换为指定类型（若类型不匹配会抛出异常）。
- **`const char* asCString() const`**  
  将字符串值转换为 C 风格字符串。
- **`int size() const`**  
  对于数组或对象，返回元素个数。


### **4. 数组操作**
- **`JSON::Value& append(const JSON::Value& value)`**  
  向数组末尾添加元素。
- **`JSON::Value& operator[](ArrayIndex index)`**  
  通过索引访问数组元素（索引越界时自动扩展数组）。


### **5. 对象操作**
- **`JSON::Value& operator[](const char* key)`** / **`operator[](const std::string& key)`**  
  通过键访问或插入对象成员。
- **`bool isMember(const char* key) const`** / **`isMember(const std::string& key)`**  
  判断对象是否包含指定键。
- **`const JSON::Value& get(const char* key, const JSON::Value& defaultValue) const`**  
  获取键对应的值，若键不存在则返回默认值。
- **`std::vector<std::string> getMemberNames() const`**  
  返回对象所有键的列表。
- **`void removeMember(const char* key)`** / **`removeMember(const std::string& key)`**  
  删除对象中的键值对。


### **6. 其他操作**
- **`bool empty() const`**  
  判断值是否为空（数组/对象为空，或值为`null`）。
- **`void clear()`**  
  清空值（重置为`null`）。
- **`std::string toStyledString() const`**  
  生成格式化的 JSON 字符串（用于调试）。
- **`bool operator==(const JSON::Value& other) const`** / **`operator!=(const JSON::Value& other)`**  
  值的比较操作符。


### **示例代码**
```cpp
#include <json/json.h>
#include <iostream>

int main() {
    // 创建 JSON 对象
    JSON::Value root;
    root["name"] = "John";
    root["age"] = 30;
    root["isStudent"] = false;

    // 创建 JSON 数组
    JSON::Value hobbies;
    hobbies.append("reading");
    hobbies.append("coding");
    root["hobbies"] = hobbies;

    // 访问值
    std::cout << "Name: " << root["name"].asString() << std::endl;
    std::cout << "Age: " << root["age"].asInt() << std::endl;

    // 检查成员
    if (root.isMember("isStudent")) {
        std::cout << "Is student: " << (root["isStudent"].asBool() ? "Yes" : "No") << std::endl;
    }

    // 遍历数组
    for (int i = 0; i < root["hobbies"].size(); ++i) {
        std::cout << "Hobby " << i << ": " << root["hobbies"][i].asString() << std::endl;
    }

    // 生成格式化字符串
    std::cout << root.toStyledString() << std::endl;

    return 0;
}

```

**注意事项**

1. **类型安全**：使用`as*()`方法时需确保类型匹配，否则可能抛出异常。
2. **空值处理**：访问不存在的键或越界索引会返回`null`值，需先检查`isNull()`。
3. **性能提示**：频繁调用`getMemberNames()`可能影响性能，建议缓存结果。

## Json::Reader

markdown
以下是 **JsonCpp 中 `JSON::Reader` 类** 的常用函数及功能介绍：


### **1. 构造函数**
- **`JSON::Reader()`**  
  创建默认配置的 Reader 对象。
- **`JSON::Reader(const JSON::Features& features)`**  
  使用指定解析选项（如是否允许注释、是否严格模式）创建 Reader。


### **2. 解析函数**
- **`bool parse(const std::string& document, JSON::Value& root, bool collectComments = true)`**  
  从字符串解析 JSON 数据到 `root`，`collectComments` 控制是否收集注释。
- **`bool parse(const char* beginDoc, const char* endDoc, JSON::Value& root, bool collectComments = true)`**  
  从字符范围解析 JSON（适用于自定义内存管理）。
- **`bool parse(std::istream& is, JSON::Value& root, bool collectComments = true)`**  
  从输入流解析 JSON（如文件流、网络流）。


### **3. 错误处理**
- **`bool good() const`**  
  判断最后一次解析是否成功。
- **`std::string getFormattedErrorMessages() const`**  
  返回格式化的错误信息（包含行号、列号和错误原因）。
- **`JSON::ParseErrorCode getErrorCode() const`**  
  获取错误码（枚举值）。
- **`std::string getErrorMessage() const`**  
  返回原始错误信息。


### **4. 注释处理**
- **`bool collectComments() const`**  
  判断是否收集注释。
- **`void setCollectComments(bool collectComments)`**  
  设置是否收集注释。


### **5. 解析选项配置**
通过 **`JSON::Features`** 结构体配置解析行为：
```cpp
JSON::Features features;
features.allowComments_ = true;        // 允许注释（// 或 /* */）
features.strictRoot_ = false;          // 根节点可以是任意类型（非严格对象/数组）
features.allowDroppedNullPlaceholders_ = true;  // 允许数组中缺失值（如 [1,,3]）
features.allowNumericKeys_ = true;     // 允许数字作为对象键名
JSON::Reader reader(features);
```

示例代码：

```cpp
#include <json/json.h>
#include <fstream>
#include <iostream>

int main() {
    // 从字符串解析
    std::string jsonStr = R"({
        "name": "Alice",
        "age": 25,
        "hobbies": ["reading", "swimming"]
    })";

    JSON::Value root;
    JSON::Reader reader;
    bool parsingSuccessful = reader.parse(jsonStr, root);

    if (parsingSuccessful) {
        std::cout << "Name: " << root["name"].asString() << std::endl;
        std::cout << "Age: " << root["age"].asInt() << std::endl;
    } else {
        std::cerr << "Failed to parse JSON: " << reader.getFormattedErrorMessages() << std::endl;
    }

    // 从文件解析
    std::ifstream file("data.json");
    if (file.is_open()) {
        JSON::Value fileRoot;
        bool fileParsingSuccessful = reader.parse(file, fileRoot);
        if (fileParsingSuccessful) {
            // 处理文件中的 JSON 数据
        } else {
            std::cerr << "Failed to parse file: " << reader.getFormattedErrorMessages() << std::endl;
        }
        file.close();
    }

    return 0;
}
```