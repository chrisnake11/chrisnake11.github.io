---
title: vscode自定义代码片段
published: 2024-07-26T14:48:17Z
description: 'vscode自定义代码片段'
image: ''
tags: ['vscode']
category: '环境配置'
draft: false
---

# 通过vscode自定义代码片段

为了节约时间，可以在vscode的设置中，配置snippets文件来自定义代码片段。

使用效果如下图：

![20240726144803](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog20240726144803.png)

![20240726144828](https://raw.githubusercontent.com/chrisnake11/picgo/main/blog20240726144828.png)


## 1.开启snippets功能

在vscode的工作目录下，找到`.vscode/settings.json`文件，如果没有就创建一个。

添加如下的代码段，开启markdown的snippets功能。

```json
{
  "[markdown]": {
    "editor.quickSuggestions": {
      "comments": "on",
      "strings": "on",
      "other": "on"
    }
  }
}
```


## 2.创建snippets用户代码片段文件

json配置代码如下：

```json
{
	// Place your 全局 snippets here. Each snippet is defined under a snippet name and has a scope, prefix, body and 
	// description. Add comma separated ids of the languages where the snippet is applicable in the scope field. If scope 
	// is left empty or omitted, the snippet gets applied to all languages. The prefix is what is 
	// used to trigger the snippet and the body will be expanded and inserted. Possible variables are: 
	// $1, $2 for tab stops, $0 for the final cursor position, and ${1:label}, ${2:another} for placeholders. 
	// Placeholders with the same ids are connected.
	// Example:
	"Print to console": {
		"prefix": "blog",
		"body": [
			"---",
			"title: ${TM_FILENAME_BASE}",
			"published: ${CURRENT_YEAR}-${CURRENT_MONTH}-${CURRENT_DATE}T${CURRENT_HOUR}:${CURRENT_MINUTE}:${CURRENT_SECOND}Z",
			"description: '${TM_FILENAME_BASE}'",
			"image: ''",
			"tags: ['${1:}']",
			"category: '${2:}'",
			"draft: false",
			"---"
		],
		"description": "blog-basic-infomation"
	}
}


```
+ prefix：表示使用代码段，需要的前缀。输入前缀就会弹出代码片段选项。
+ body：代码片段的主内容，每个双引号内表示单行的文本。
+ ${1:}：表示占位符，用户可以通过tab按照数字的顺序切换位置逐个输入。
+ ${variables}：snippets内置了多个默认的参数，利用这些参数可以直接读取文件名、日期等信息。

更多的配置信息可以参考[vscode的文档](https://code.visualstudio.com/docs/editor/userdefinedsnippets)