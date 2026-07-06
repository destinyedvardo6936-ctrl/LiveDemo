#!/bin/bash

# 蜜桃直播 - GitHub上传脚本
# 使用方法: bash push_to_github.sh

set -e

echo "🚀 开始上传项目到GitHub..."

# 检查git是否安装
if ! command -v git &> /dev/null; then
    echo "❌ 错误: 未安装git"
    exit 1
fi

# 检查是否在项目目录
if [ ! -f "codemagic.yaml" ]; then
    echo "❌ 错误: 请在项目根目录运行此脚本"
    exit 1
fi

# 获取用户输入
echo ""
echo "请输入以下信息:"
read -p "GitHub用户名: " GITHUB_USER
read -p "仓库名 (默认: LiveDemo): " REPO_NAME
REPO_NAME=${REPO_NAME:-LiveDemo}

GITHUB_URL="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"

echo ""
echo "仓库URL: $GITHUB_URL"
echo ""

# 初始化git仓库
if [ ! -d ".git" ]; then
    echo "📝 初始化Git仓库..."
    git init
    git config user.email "you@example.com"
    git config user.name "$GITHUB_USER"
else
    echo "✅ Git仓库已存在"
fi

# 添加远程仓库
echo "🔗 添加远程仓库..."
if git remote | grep -q "origin"; then
    git remote set-url origin "$GITHUB_URL"
else
    git remote add origin "$GITHUB_URL"
fi

# 显示当前分支
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD")
echo "📌 当前分支: $CURRENT_BRANCH"

# 添加所有文件
echo "📦 添加所有文件..."
git add .

# 提交
echo "💾 创建初始提交..."
git commit -m "Initial commit: Add LiveDemo iOS application with CodeMagic configuration" || true

# 检查是否需要改变分支名称
read -p "是否改变分支名称为 'main'? (y/n, 默认: y): " CHANGE_BRANCH
CHANGE_BRANCH=${CHANGE_BRANCH:-y}

if [ "$CHANGE_BRANCH" = "y" ] || [ "$CHANGE_BRANCH" = "Y" ]; then
    echo "🏷️  改变分支名称为 'main'..."
    git branch -M main
    PUSH_BRANCH="main"
else
    PUSH_BRANCH="$CURRENT_BRANCH"
fi

# 推送到GitHub
echo "🚀 推送到GitHub..."
echo "如果这是第一次，可能需要输入GitHub凭证"
git push -u origin "$PUSH_BRANCH"

echo ""
echo "✅ 完成！项目已成功上传到GitHub"
echo ""
echo "后续步骤:"
echo "1. 访问 $GITHUB_URL"
echo "2. 前往 https://codemagic.io 连接仓库"
echo "3. 配置CodeMagic环境变量"
echo "4. 启用自动构建"
echo ""
echo "有问题？查看 SETUP_GITHUB.md 文件获取详细指导"
