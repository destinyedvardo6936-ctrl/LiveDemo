# 🚀 快速开始指南

## 总体流程

```
本地准备 → GitHub上传 → CodeMagic配置 → 自动构建 → App Store发布
```

## 5分钟快速开始

### 1️⃣ 上传到GitHub（Windows用户）

```cmd
# 在项目目录中运行
push_to_github.bat
```

**或手动执行**：
```bash
cd LiveDemo
git init
git add .
git commit -m "Initial commit: Add LiveDemo iOS application with CodeMagic configuration"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/LiveDemo.git
git push -u origin main
```

### 2️⃣ CodeMagic快速配置

#### A. 创建账户和连接GitHub
- 访问 https://codemagic.io
- 使用GitHub账户登录
- 授权CodeMagic访问仓库

#### B. 添加项目
1. 点击 "Add application"
2. 选择 "From GitHub"  
3. 选择 "LiveDemo" 仓库
4. CodeMagic自动检测到 `codemagic.yaml`

#### C. 配置Code Signing（最重要）

##### 推荐方案：使用Fastlane Match

```bash
# 1. 创建私有仓库 iOS-Code-Signing

# 2. 在本地安装fastlane
sudo gem install fastlane

# 3. 初始化match
fastlane match init
# 输入：
# - Git URL: https://github.com/YOUR_USERNAME/iOS-Code-Signing.git
# - Password: 创建一个强密码

# 4. 生成证书（只需运行一次）
fastlane match appstore
fastlane match development

# 5. 在CodeMagic中配置：
# - 项目 > Code signing > iOS
# - 选择 Fastlane
# - Git URL: iOS-Code-Signing仓库URL
# - Match password: 你创建的密码
```

#### D. 设置环境变量

在CodeMagic项目 > Variables中添加：

| 变量 | 值 | 类型 |
|-----|----|----|
| `APPLE_ID` | 你的Apple ID | String |
| `APPLE_PASSWORD` | 密码 | Secret ⚠️ |
| `TEAM_EMAIL` | your@email.com | String |

#### E. 启用Webhook（可选但推荐）

在CodeMagic中复制webhook URL，添加到GitHub仓库：
- GitHub仓库 > Settings > Webhooks
- 粘贴webhook URL
- 选择"Push events"和"Pull requests"

### 3️⃣ 启动首次构建

```bash
# 推送任何更改到main分支
git push origin main

# 或在CodeMagic中手动点击 "Start new build"
```

### 4️⃣ 验证构建

1. CodeMagic仪表板查看构建日志
2. 等待构建完成（通常5-15分钟）
3. 查看输出的IPA文件

## 文件说明

项目中已创建的配置文件：

| 文件 | 用途 | 编辑 |
|-----|------|------|
| `.gitignore` | Git忽略规则 | 通常不需要 |
| `codemagic.yaml` | CodeMagic CI/CD配置 | 根据需要定制 |
| `ExportOptions.plist` | IPA导出选项 | 修改签名方式 |
| `README.md` | 项目文档 | 更新项目信息 |
| `SETUP_GITHUB.md` | 详细上传指南 | 参考文档 |
| `CODEMAGIC_SETUP.md` | 详细CodeMagic指南 | 参考文档 |
| `push_to_github.sh` | Linux/Mac上传脚本 | 可选 |
| `push_to_github.bat` | Windows上传脚本 | Windows推荐 |

## 关键注意事项 ⚠️

### Code Signing
- **最常见的错误**: Code Signing配置不正确
- **解决**: 使用fastlane match，不要手动管理证书

### 密码安全
- **永远不要**在代码中硬编码密码
- **使用CodeMagic的Secret变量**
- **Code Signing证书存储在私有仓库**

### Pod依赖
- 确保 `.gitignore` 包含 `Pods/`
- 使用 `pod install --repo-update` 更新依赖
- 不提交 `Pods/` 文件夹到Git

## 常见问题快速解答

**Q: 构建失败，提示"No matching provisioning profile"**
A: 这是Code Signing问题。按照步骤2C配置fastlane match。

**Q: 需要多少时间才能第一次构建成功？**
A: 第一次构建通常需要10-15分钟（下载依赖和编译）。后续构建更快。

**Q: 如何修改构建配置（如最低iOS版本）？**
A: 编辑 `codemagic.yaml` 或 `ExportOptions.plist`，然后推送到GitHub。

**Q: 能否自动发布到App Store？**
A: 可以。需要额外配置App Store Connect API密钥。详见 `CODEMAGIC_SETUP.md`。

## 下一步

✅ 代码已上传到GitHub
✅ CodeMagic已配置并自动构建
⏭️ 可选：配置自动上传到App Store
⏭️ 可选：设置TestFlight beta分发

## 遇到问题？

1. 查看 `SETUP_GITHUB.md` - GitHub上传详细指南
2. 查看 `CODEMAGIC_SETUP.md` - CodeMagic详细配置
3. 检查CodeMagic构建日志 - 大多数错误都会详细记录
4. 访问 https://docs.codemagic.io - 官方文档

## 成功指标 🎯

首次构建成功时你将看到：

✅ CodeMagic仪表板显示 "Build succeeded"
✅ 生成了 `.ipa` 文件（可在Artifacts中下载）
✅ 收到了构建完成的邮件通知
✅ 可以将IPA文件安装到设备上进行测试

---

祝你使用CodeMagic自动化iOS构建和发布！🎉

