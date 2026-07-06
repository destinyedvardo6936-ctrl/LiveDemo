@echo off
REM 蜜桃直播 - GitHub上传脚本（Windows版本）
REM 使用方法: push_to_github.bat

setlocal enabledelayedexpansion

echo 🚀 开始上传项目到GitHub...
echo.

REM 检查git是否安装
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ 错误: 未安装git
    exit /b 1
)

REM 检查是否在项目目录
if not exist "codemagic.yaml" (
    echo ❌ 错误: 请在项目根目录运行此脚本
    exit /b 1
)

REM 获取用户输入
echo 请输入以下信息:
set /p GITHUB_USER="GitHub用户名: "
set /p REPO_NAME="仓库名 (默认: LiveDemo): "

if "%REPO_NAME%"=="" set REPO_NAME=LiveDemo

set GITHUB_URL=https://github.com/%GITHUB_USER%/%REPO_NAME%.git

echo.
echo 仓库URL: %GITHUB_URL%
echo.

REM 初始化git仓库
if not exist ".git" (
    echo 📝 初始化Git仓库...
    call git init
    call git config user.email "you@example.com"
    call git config user.name "%GITHUB_USER%"
) else (
    echo ✅ Git仓库已存在
)

REM 添加远程仓库
echo 🔗 添加远程仓库...
call git remote set-url origin "%GITHUB_URL%" 2>nul || call git remote add origin "%GITHUB_URL%"

REM 添加所有文件
echo 📦 添加所有文件...
call git add .

REM 提交
echo 💾 创建初始提交...
call git commit -m "Initial commit: Add LiveDemo iOS application with CodeMagic configuration" || true

REM 改变分支名称为main
echo 🏷️  改变分支名称为 'main'...
call git branch -M main

REM 推送到GitHub
echo 🚀 推送到GitHub...
echo 如果这是第一次，可能需要输入GitHub凭证
call git push -u origin main

echo.
echo ✅ 完成！项目已成功上传到GitHub
echo.
echo 后续步骤:
echo 1. 访问 %GITHUB_URL%
echo 2. 前往 https://codemagic.io 连接仓库
echo 3. 配置CodeMagic环境变量
echo 4. 启用自动构建
echo.
echo 有问题？查看 SETUP_GITHUB.md 文件获取详细指导
echo.
pause
