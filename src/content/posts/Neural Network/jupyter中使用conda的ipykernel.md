---
title: jupyter中使用conda的ipykernel
published: 2024-07-27T11:14:38Z
description: 'jupyter中使用conda的ipykernel'
image: ''
tags: ['Neural Network']
category: 'Neural Network'
draft: false
---

# 问题：在安装了miniconda，pytorch后，在jupyter notebook中无法import torch

![20240727111547](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog20240727111547.png)


# 解决方法：给jupyter notebook添加conda所使用的ipykernel

1. 首先确保激活了conda，并且使用`pip list`命令查看安装了pytorch

2. 给Jupyter Notebook添加conda中的Python内核

```bash
python -m ipykernel install --user --name d2l --display-name "Python3(d2l)"
```
+ `--display-name`参数，是jupyter notebook中选择ipykernel列表中显示的内核名称。

在juypter notebook的对应代码中，选择我们指定好的内核就行了。

![20240727112254](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog20240727112254.png)

# ChatGPT的回答

在Jupyter Notebook中无法import torch可能有以下几种原因：

1. **jupyter中使用conda的ipykernelupyter Notebook使用的Python环境与conda环境不同步：**
   1. Jupyter Notebook可能正在使用一个与d2l环境不同的Python内核。
2. **内核未正确安装**：
   1. 可能需要在d2l环境中安装ipykernel，并将其注册为Jupyter Notebook的内核。
3. **PATH环境变量问题**：
   1. Jupyter Notebook可能没有正确识别到d2l环境中的库。

可以按照以下步骤来解决这个问题：

## 1. 确保Jupyter Notebook使用的Python环境与d2l环境一致
首先，在d2l环境中安装ipykernel：

```bash
Copy code
conda activate d2l
conda install ipykernel
```
## 2. 将d2l环境注册为Jupyter Notebook的内核
然后，将d2l环境添加到Jupyter Notebook的内核中：

```bash
Copy code
python -m ipykernel install --user --name d2l --display-name "Python (d2l)"
```
## 3. 在Jupyter Notebook中选择正确的内核
打开Jupyter Notebook，点击右上角的“Kernel”菜单，选择“Change Kernel”，然后选择“Python (d2l)”。

## 4. 确认torch已安装在d2l环境中
在激活d2l环境后，运行以下命令以确保torch已正确安装：

```bash
Copy code
pip list | grep torch
如果torch未安装，可以重新安装：
```

```bash
Copy code
pip install torch==1.12.0
```
## 5. 重新启动Jupyter Notebook
确保所有步骤完成后，重新启动Jupyter Notebook，并选择正确的内核，然后再尝试import torch。

这样应该可以解决在Jupyter Notebook中无法import torch的问题。