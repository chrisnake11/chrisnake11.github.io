---
title: fuwari博客搭建，并部署到Github Pages
published: 2024-04-19T19:00:00Z
description: 'fuwari博客搭建，并部署到Github Pages'
image: 'https://raw.githubusercontent.com/chrisnake11/picgo/main/blog/2PvxbRjv.jpeg'
tags: [环境配置, Blog]
category: '环境配置'
draft: false 
---

# 🍥 Fuwari 教程(部署到Github Pages)

基于 [Astro](https://astro.build) 开发的静态博客模板。

[**🖥️在线预览（Vercel）**](https://fuwari.vercel.app)&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;[**🌏English README**](https://github.com/saicaca/fuwari)&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;[**📦旧 Hexo 版本**](https://github.com/saicaca/hexo-theme-vivia)

![Preview Image](https://raw.githubusercontent.com/saicaca/resource/main/fuwari/home.png)

## 🚀 使用方法(部署到Github Pages)

### 创建Github.io仓库

1. 登录自己的github。创建一个`repository`，命名为`[用户名].github.io`
2. 使用`git clone 用户名.github.io`，克隆到本地。

```bash
git clone https::/github.com/username/username.github.io

cd username.github.io

git config --global user.name "username"
git config --goabal user.email "youremail@xxx.com"

# 远端github仓库的分支一般为main
# 本地新建仓库的分支一般为master
git branch -M main # 切换为main分支

# 创建到github的推送链接
git remote add origin https::/github.com/username/username.github.io

# 创建一个README.md文件

git add README.md
git commit -m "first commit"
git push -u origin main # 设置默认推送到main分支，之后的git push会默认推送到main分支
```



### 在仓库文件夹下搭建博客环境

1. 克隆fuwari博客项目到本地

   ````bash
   git clone https://github.com/saicaca/fuwari.git
   ````

2. 将fuwari博客项目下的文件，拷贝到自己的`用户名 github.io`项目文件夹中。

   ```bash
   cp -r ./fuwari/* ./username.github.io/
   ```

3. 开始本地博客环境搭建，`cd ./username.github.io`切换到本地仓库中。

   1. 先安装nodejs，推荐20 LTS版本。
   2. 安装博客依赖

   ```bash
   npm install -g pnpm # 安装pnpm
   pnpm install
   pnpm add sharp # 安装博客依赖
   
   pnpm build # 构建博客
   pnpm preview # 本地预览博客
   ```

### 部署到Github Pages

1. 博客本地搭建成功后，在github网站下进入仓库，在`username.github.io -> setting`页面，选择`action`选项，选择`allow action`赋予Github Action权限。
2. 创建`.github/workflows/deploy.yml`（github Action自动部署文件），添加官方的部署代码。（注意修改node的版本）

```yaml
name: Deploy to GitHub Pages

on:
  # Trigger the workflow every time you push to the `main` branch
  # Using a different branch name? Replace `main` with your branch’s name
  push:
    branches: [main]
  # Allows you to run this workflow manually from the Actions tab on GitHub.
  workflow_dispatch:

# Allow this job to clone the repo and create a page deployment
permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout your repository using git
        uses: actions/checkout@v4
      - name: Install, build, and upload your site output
        uses: withastro/action@v2
        with:
            path: . # The root location of your Astro project inside the repository. (optional)
            node-version: 20 # The specific version of Node that should be used to build your site. Defaults to 18. (optional)
            # node-version 不能使用21
            package-manager: pnpm@latest # The Node package manager that should be used to install dependencies and build your site. Automatically detected based on your lockfile. (optional)

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```
3. 在`username.github.io/src/content/post`下创建一个`test.md`文档测试

```markdown
---
title: My First Blog Post
published: 2023-09-09
description: This is the first post of my new Astro blog.
image: /images/cover.jpg
tags: [Foo, Bar]
category: Front-end
draft: false
---

# H1
## H2H2
Blog Test
```

4. git push推送到仓库。push时会自动触发Action，部署静态博客页面.

```bash
# Git脚本
# 用法：./filename.sh "commit message"

#!/bin/bash
# 检查是否提供了提交注释
if [ $# -eq 0 ]; then
    echo "Usage: $0 <commit message>"
    exit 1
fi

# 添加所有文件到暂存区
git add .

# 提交文件并添加提交注释
git commit -m "$1"

# 推送提交到远程仓库
git push

echo "Files committed and pushed successfully."
```



## ⚙️ 文章 Frontmatter

```yaml
---
title: My First Blog Post
published: 2023-09-09
description: This is the first post of my new Astro blog.
image: /images/cover.jpg
tags: [Foo, Bar]
category: Front-end
draft: false
---
```

## 🧞 指令

下列指令均需要在项目根目录执行：

| Command                           | Action                            |
|:----------------------------------|:----------------------------------|
| `pnpm install` 并 `pnpm add sharp` | 安装依赖                              |
| `pnpm dev`                        | 在 `localhost:4321` 启动本地开发服务器      |
| `pnpm build`                      | 构建网站至 `./dist/`                   |
| `pnpm preview`                    | 本地预览已构建的网站                        |
| `pnpm new-post <filename>`        | 创建新文章                             |
| `pnpm astro ...`                  | 执行 `astro add`, `astro check` 等指令 |
| `pnpm astro --help`               | 显示 Astro CLI 帮助                   |