---
title: 使用Typora编辑博客，并配置Picgo图床自动上传图片
published: 2024-04-19T19:00:00Z
description: 使用Typora编辑md文件，并且基于Github图床，使用Picgo上传图片。
image: https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/2PvxbRjv.jpeg
tags: [环境配置]
category: 环境配置
draft: false
---

# Windows端配置

## 1. 搭建博客环境，配置Typora

+ 首先搭建好博客环境，详情见[fuwari博客搭建，并部署到Github Pages](https://chrisnake11.github.io/posts/guide/fuwari/)
+ 博客搭建完毕之后，下载Typora并安装
+ 使用Typora打开本地博客仓库文件夹`username.github.io/src/content/post/`
+ Typora编辑完成之后，使用git-bash推送到仓库。

## 2. 安装Picgo

+ github上创建一个图床仓库，专门用于存储图片。

+ 申请一个[github token](https://github.com/settings/tokens)（在settings -> developer settings -> Personal access Token下）
  
  + 申请token时，将repo选项打√，赋予token修改仓库的权限。
  + **！！！注意**：token申请后，只有一次机会查看，之后将永久隐藏，做好备份。
  
+ 在github上下载对应版本的[picgo](https://github.com/Molunerfinn/PicGo/releases/tag/v2.3.1)安装

+ 打开Picgo，进行如下配置

  ![image-20240418181950840](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/picgo.png)

+ 可以拖动一个图片上传进行测试。

# 3. Typora配置Picgo

+ 在文件(files) -> 偏好设置(preference setting)下进行设置
+ 按照图片中方式进行配置即可
+ ![image-20240418183103999](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/image-20240418183103999.png)
