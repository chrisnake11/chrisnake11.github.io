#!/bin/bash

# 添加所有文件到暂存区
git add .

# 提交文件并添加提交注释
git commit -m "add Notes"

# 推送提交到远程仓库
git push

echo "Files committed and pushed successfully."
