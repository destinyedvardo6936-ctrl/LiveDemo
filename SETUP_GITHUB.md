# GitHub 上传指南

本指南说明如何将蜜桃直播项目上传到GitHub并配置CodeMagic。

## 第一步：创建GitHub仓库

1. 访问 [GitHub](https://github.com/new)
2. 创建新仓库：
   - **仓库名**: LiveDemo（或其他名称）
   - **描述**: 蜜桃直播 - iOS直播应用
   - **可见性**: 根据需要选择 Public 或 Private
   - 不要初始化任何文件

## 第二步：本地初始化Git仓库

```bash
# 进入项目目录
cd LiveDemo

# 初始化git仓库
git init

# 添加远程仓库
git remote add origin https://github.com/YOUR_USERNAME/LiveDemo.git

# 验证远程仓库
git remote -v
```

## 第三步：上传代码到GitHub

```bash
# 添加所有文件
git add .

# 首次提交
git commit -m "Initial commit: Add LiveDemo iOS application"

# 改变分支名称为main（如需要）
git branch -M main

# 推送到GitHub
git push -u origin main
```

## 第四步：CodeMagic配置

### 4.1 连接CodeMagic账户

1. 访问 [CodeMagic](https://codemagic.io)
2. 使用GitHub账户登录
3. 授权CodeMagic访问你的GitHub仓库

### 4.2 添加项目到CodeMagic

1. 在CodeMagic仪表板中点击 "Add application"
2. 选择 "From GitHub"
3. 选择 "LiveDemo" 仓库
4. 点击 "Set up build"

### 4.3 配置构建变量

在 CodeMagic 项目设置中添加以下环境变量（通常在 Variables 部分）：

```
APPLE_ID              = 你的Apple ID账户
APPLE_PASSWORD        = 你的Apple ID密码
MATCH_PASSWORD        = Code Signing证书的密码
MATCH_GIT_URL         = iOS Code Signing仓库URL（GitHub或GitLab）
TEAM_EMAIL           = 团队邮箱（用于接收构建通知）
```

#### 创建iOS Code Signing仓库

为了安全地管理证书和配置文件，建议创建一个单独的私有仓库来存储Code Signing信息：

1. 在GitHub创建一个私有仓库，名称如：`iOS-Code-Signing`
2. 使用fastlane match管理证书：

```bash
# 安装fastlane（如果还未安装）
sudo gem install fastlane

# 初始化match
fastlane match init

# 上传现有证书
fastlane match import

# 或生成新证书
fastlane match appstore
```

### 4.4 配置Xcode项目

确保项目已配置以下内容：

1. **Team ID**: 在Xcode中设置正确的Team ID
2. **Bundle ID**: 确保 `com.meituo.livedemo` 或其他正确的Bundle ID
3. **Signing Certificate**: 配置为自动管理或使用match

### 4.5 启用自动构建

1. 在CodeMagic项目中启用webhook
2. 设置触发条件：
   - 推送到main/master分支
   - 创建Pull Request
   - 手动触发

## 第五步：验证构建

1. 推送代码到GitHub后，CodeMagic应自动触发构建
2. 查看CodeMagic仪表板中的构建日志
3. 如有错误，根据日志信息修复问题

## 常见问题

### Q: 如何更新推送到GitHub的代码？

```bash
# 修改文件后
git add .
git commit -m "Description of changes"
git push origin main
```

### Q: 如何处理Pods文件夹的大小？

Pods文件夹通常很大，建议：

1. 确保 `.gitignore` 包含 `Pods/` 和 `Podfile.lock`
2. 其他开发者克隆仓库后运行 `pod install` 恢复依赖

### Q: CodeMagic构建失败怎么办？

常见原因和解决方案：

1. **证书问题**: 确保match仓库配置正确
2. **Pod依赖问题**: 在Xcode中运行 `pod install --repo-update`
3. **Xcode版本**: 在CodeMagic中指定正确的Xcode版本
4. **权限问题**: 确保Bundle ID和Team ID正确配置

### Q: 如何保护敏感信息？

1. **永远不要提交** Apple ID密码或证书到公开仓库
2. 使用CodeMagic的环境变量存储敏感信息
3. 使用私有仓库存储Code Signing信息

## 后续步骤

1. ✅ 代码已上传到GitHub
2. ✅ CodeMagic已配置并可以自动构建
3. ⏭️ 配置App Store Connect自动上传（可选）
4. ⏭️ 设置beta测试分发（可选）

## 获取帮助

- [CodeMagic文档](https://docs.codemagic.io)
- [GitHub帮助](https://docs.github.com)
- [Fastlane文档](https://docs.fastlane.tools)

---

祝你的蜜桃直播项目开发顺利！🚀
