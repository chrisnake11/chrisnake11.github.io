---
title: vscode配置c++环境
published: 2024-09-02T10:25:51Z
description: 'vscode配置c++环境：下载配置编译器，配置vscode的c++编译、debug环境，mingw导入第三方库'
image: ''
tags: ['环境配置', 'c++', 'vscode']
category: '环境配置'
draft: false
---

# 一、下载编译器

## 下载mingw

在mingw官网下载压缩包：https://www.mingw-w64.org/downloads/#mingw-builds

进入mingw官网，能够存在以下三个版本的MinGW
![20240902103427](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/20240902103427.png)

我们使用mingw-w64版本。github链接：https://github.com/niXman/mingw-builds-binaries/releases/

下载poxis-ucrt版本

UCRT (Universal )是Microsoft默认使用的较新版本。它应该工作并表现为代码是用MSVC编译的。

解压mingw，将`D:\dev\cpp\mingw\mingw64\bin`加入到环境变量路径。

# 二、配置c++编译、debug

首先在vscode上安装C/C++扩展。

进入C/C++扩展配置目录，设置include path，以便后续的第三方库导入。
`D:\dev\cpp\mingw\mingw64\include`
![20240902110537](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/20240902110537.png)

## 创建task.json编译C++文件

在vscode上创建一个demo文件，按住`CRTL + SHIFT + P`打开上方的命令窗口输入`task`，选择`Configure Default Build Task`


![20240902104756](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/20240902104756.png)

`task.json`文件。

```json
{
	"version": "2.0.0",
	"tasks": [
		{
			"type": "cppbuild",
			"label": "C/C++: g++.exe build active file", // 任务的名称
			"command": "D:\\dev\\cpp\\mingw\\mingw64\\bin\\g++.exe",
			"args": [
				"-fdiagnostics-color=always",
				"-g",
				"${file}",
				"-o",
				"${fileDirname}\\${fileBasenameNoExtension}.exe"
			], // 执行的命令和参数
			"options": {
				"cwd": "${fileDirname}"
			},
			"problemMatcher": [
				"$gcc"
			],
			"group": {
				"kind": "build",
				"isDefault": true
			},
			"detail": "compiler: D:\\dev\\cpp\\mingw\\mingw64\\bin\\g++.exe" // 编译器地址
		}
	]
}
```

## 创建launch.json，debug程序

`.vscode`文件夹中不会有`launch.json`文件，我们点击`Run -> Start Debugging`

vscode就会自动生成一个`launch.json`文件，按照以下的模板进行修改即可。

![20240902105545](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/20240902105545.png)

`launch.json`文件

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "C/C++ Runner: Debug Session",
      "type": "cppdbg",
      "request": "launch",
      "args": [],
      "stopAtEntry": false,
      "externalConsole": true, // 弹出控制台窗口
      "cwd": "${workspaceFolder}", // 相对路径，父文件夹。
      "program": "${fileDirname}\\${fileBasenameNoExtension}.exe", // debug的程序
      "MIMode": "gdb",
      "miDebuggerPath": "D:\\dev\\cpp\\mingw\\mingw64\\bin\\gdb.exe", // 设置mingw gdb路径
      "setupCommands": [
        {
          "description": "Enable pretty-printing for gdb",
          "text": "-enable-pretty-printing",
          "ignoreFailures": true
        }
      ],
      "preLaunchTask": "C/C++: g++.exe build active file" , // 预先执行的任务（编译）,和task.json中的label对应。
    }
  ]
}
```

# 三、导入第三方库，以boost库为例

假设已经编译好了boost库。

## 将lib文件导入到mingw的lib中

boost库编译完毕后，会在stage文件夹下生成一个lib文件夹，我们需要将这个lib文件夹中的所有库文件导入到mingw的lib文件夹中。

`D:\dev\cpp\boost_1_86_0\stage\lib\*` -> `D:\dev\cpp\mingw\mingw64\lib\`

## 把boost_1_86_0下的boost文件夹，拷贝到mingw的include中

`D:\dev\cpp\boost_1_86_0\boost` -> `D:\dev\cpp\mingw\mingw64\include\`
