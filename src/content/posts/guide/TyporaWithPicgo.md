---
title: 使用Typora编辑博客，并配置Picgo图床
published: 2024-04-18
description: 使用Typora编辑md文件，并且基于Github图床，使用Picgo上传图片。
image: ./cover.jpg
tags: [Typora, Picgo]
category: 环境配置
draft: false
---

# Windows端配置

## 1. 搭建博客环境，配置Typora

+ 安装git
+ 安装Nodejs，建议20LTS版本
+ 在Windows本地搭建博客，详情见安装教程的[使用方法部分](https://chrisnake11.github.io/posts/fuwari/)
+ 下载Typora，安装
+ 通过Typora + git-bash实现博客编辑。

## 2. 安装Picgo

+ github上创建一个图床仓库，专门用于存储图片。
+ 申请一个[github token](https://github.com/settings/tokens)（在settings -> developer settings -> Personal access Token下），赋予picgo上传图片到图床的权限。
  + **！！！注意**：token申请后，只有一次机会查看，之后将永久隐藏，做好备份。
+ 需要Nodejs，上面已经安装过了。
+ 在github上下载对应版本的[picgo](https://github.com/Molunerfinn/PicGo/releases/tag/v2.3.1)安装

+ 打开Picgo，进行如下配置

  ![image-20240418181950840](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/picgo.png)

+ 可以拖动一个图片上传进行测试。

# 3. Typora配置Picgo

+ 在文件(files) -> 偏好设置(preference setting)下进行设置
+ 按照图片中方式进行配置即可
+ ![image-20240418183103999](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/image-20240418183103999.png)

