---
title: fuwari安装教程
published: 2024-04-18
description: 'fuwari官方的教程和相关指令代码'
image: ''
tags: [环境配置, Blog]
category: '环境配置'
draft: false 
---

# 🍥 Fuwari 教程

基于 [Astro](https://astro.build) 开发的静态博客模板。

[**🖥️在线预览（Vercel）**](https://fuwari.vercel.app)&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;[**🌏English README**](https://github.com/saicaca/fuwari)&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;[**📦旧 Hexo 版本**](https://github.com/saicaca/hexo-theme-vivia)

![Preview Image](https://raw.githubusercontent.com/saicaca/resource/main/fuwari/home.png)

## 🚀 使用方法

1. 先安装nodejs，推荐20 LTS版本。
2. 使用此模板[生成新仓库](https://github.com/saicaca/fuwari/generate)或 Fork 此仓库
3. 进行本地开发，Clone 新的仓库，执行 `pnpm install` 和 `pnpm add sharp` 以安装依赖  
   - 若未安装 [pnpm](https://pnpm.io)，执行 `npm install -g pnpm`
4. 执行 `pnpm new-post <filename>` 创建新文章，并在 `src/content/posts/` 目录中编辑
5. 通过配置文件 `src/config.ts` 自定义博客

## 部署到Github Pages

1. 创建一个`repository`，命名为`[用户名].github.io`
2. 进入`repositor的setting`页面，选择`action`选项，选择`allow action`赋予权限。
3. 把博客项目部署在当前仓库下，或者直接拷贝。
4. 创建`.github/workflows/deploy.yml`文件，添加官方的部署代码。（注意修改node的版本）
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
5. 每次git push时触发action，自动build && deploy文件.

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