# 📋 项目准备清单

## ✅ 已完成的配置

你的蜜桃直播项目已完全准备好上传到GitHub并配置CodeMagic。以下是已创建/更新的文件：

### 核心配置文件

| 文件 | 描述 | 状态 |
|-----|------|------|
| **`.gitignore`** | Git忽略规则（排除Pods、build、.DS_Store等） | ✅ |
| **`codemagic.yaml`** | CodeMagic CI/CD配置（3个工作流程） | ✅ |
| **`ExportOptions.plist`** | IPA导出选项 | ✅ |
| **`README.md`** | 更新的项目文档 | ✅ |

### 文档和指南

| 文件 | 用途 |
|-----|------|
| **`QUICKSTART.md`** | ⚡ 5分钟快速开始指南（强烈推荐先读这个） |
| **`SETUP_GITHUB.md`** | 📚 GitHub上传详细指南 |
| **`CODEMAGIC_SETUP.md`** | 📚 CodeMagic配置详细指南 |
| **`CHECKLIST.md`** | ✅ 这个文件 |

### 自动化脚本

| 文件 | 平台 | 用途 |
|-----|------|------|
| **`push_to_github.bat`** | Windows | 一键上传GitHub脚本 |
| **`push_to_github.sh`** | Linux/Mac | 一键上传GitHub脚本 |

---

## 🚀 立即开始（3步）

### 步骤1：上传到GitHub

**Windows用户**：双击运行 `push_to_github.bat`
或手动执行：
```bash
cd LiveDemo
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/LiveDemo.git
git branch -M main
git push -u origin main
```

### 步骤2：配置CodeMagic

1. 访问 https://codemagic.io
2. 使用GitHub登录
3. 添加 LiveDemo 项目
4. **最重要**：配置Code Signing（见下方）
5. 添加环境变量

### 步骤3：启动构建

推送到GitHub后，CodeMagic会自动开始构建！

---

## ⚙️ CodeMagic关键配置

### 1. Code Signing（必需）

**推荐方案**：使用Fastlane Match

```bash
# 第1步：创建私有仓库 iOS-Code-Signing 在GitHub

# 第2步：生成证书
gem install fastlane
fastlane match init
fastlane match appstore
fastlane match development

# 第3步：在CodeMagic中配置
# - 项目 > Code signing
# - 选择 Fastlane authentication
# - Git URL: iOS-Code-Signing仓库地址
# - Match password: 你设置的密码
```

### 2. 环境变量

在CodeMagic项目 > Variables中设置：

```
APPLE_ID = 你的Apple ID (String)
APPLE_PASSWORD = 密码 (Secret ⚠️)
MATCH_GIT_URL = iOS-Code-Signing仓库URL (String)
GIT_USER = GitHub用户名 (String)
GIT_TOKEN = GitHub PAT令牌 (Secret)
TEAM_EMAIL = your@email.com (String)
```

### 3. 工作流程

项目包含3个工作流程，可在CodeMagic中选择：

| 工作流 | 用途 |
|------|------|
| **ios-build-ad-hoc** | 构建TestFlight/Beta版本 |
| **ios-build-appstore** | 构建App Store版本 |
| **ios-test** | 运行单元测试 |

---

## 📁 项目结构验证

确保项目目录如下所示：

```
LiveDemo/
├── .gitignore                  ✅ 已创建
├── codemagic.yaml              ✅ 已创建
├── ExportOptions.plist         ✅ 已创建
├── README.md                   ✅ 已更新
├── QUICKSTART.md               ✅ 已创建
├── SETUP_GITHUB.md             ✅ 已创建
├── CODEMAGIC_SETUP.md          ✅ 已创建
├── CHECKLIST.md                ✅ 这个文件
├── push_to_github.bat          ✅ 已创建
├── push_to_github.sh           ✅ 已创建
│
├── LiveDemo/                   （主应用目录）
│   ├── AppDelegate.h/m
│   ├── Info.plist
│   ├── Assets.xcassets/
│   ├── Moudles/
│   ├── Common/
│   └── ...
│
├── Podfile                     （CocoaPods配置）
├── LiveDemo.xcworkspace/       （Xcode工作区）
├── LiveDemo.xcodeproj/         （Xcode项目）
├── Pods/                       （Pod依赖 - 不要上传）
└── ...
```

---

## ⚠️ 重要提醒

### 不要做的事情 ❌

- ❌ 提交 `Pods/` 文件夹
- ❌ 硬编码密码到代码中
- ❌ 提交 `.DS_Store` 或其他macOS系统文件
- ❌ 提交 `xcuserdata/` 个人配置
- ❌ 与他人分享Apple ID凭证

### 必须做的事情 ✅

- ✅ 使用Secret变量存储敏感信息
- ✅ 将Code Signing存储在私有仓库
- ✅ 使用Fastlane Match管理证书
- ✅ 定期更新依赖
- ✅ 进行代码审查

---

## 🔧 常见配置修改

### 修改最低iOS版本
在 `Podfile` 中：
```ruby
platform :ios, '14.0'  # 改成你需要的版本
```

### 修改导出方式
在 `ExportOptions.plist` 中修改 `method` 值：
```
app-store   → App Store提交
ad-hoc      → TestFlight/企业分发
development → 开发版本
enterprise  → 企业分发
```

### 添加新的构建工作流
编辑 `codemagic.yaml`，复制并修改现有工作流程

### 修改通知邮箱
在 `codemagic.yaml` 的 `publishing` > `email` > `recipients` 中修改

---

## 📊 构建过程详解

### 首次构建流程（通常10-15分钟）

```
1. 环境初始化 (1 min)
   └─ 下载Xcode、CocoaPods等
   
2. 依赖安装 (3-5 min)
   └─ pod install --repo-update
   └─ 下载所有Pod库
   
3. Code Signing (2 min)
   └─ fastlane match 获取证书
   
4. 编译项目 (3-5 min)
   └─ xcodebuild compile
   └─ 链接所有库
   
5. 归档 (1 min)
   └─ xcodebuild archive
   
6. 导出IPA (1 min)
   └─ xcodebuild -exportArchive
   
7. 发布 (<1 min)
   └─ 上传到服务器
   └─ 发送邮件通知
```

后续构建由于缓存会更快（通常5-8分钟）

### 触发构建的方式

1. **自动触发**：推送到GitHub
   ```bash
   git push origin main
   ```

2. **手动触发**：CodeMagic仪表板
   - 点击项目 > "Start new build"

3. **定时触发**（高级）：在codemagic.yaml配置cron表达式

---

## 🎯 验证构建成功的指标

✅ CodeMagic仪表板显示 "Build succeeded" (绿色)
✅ Artifacts中存在 `.ipa` 文件
✅ 收到了构建完成的邮件通知
✅ 可以下载IPA文件到本地测试

---

## 🐛 遇到问题怎么办？

### 问题排查步骤

1. **查看构建日志**
   - CodeMagic项目 > 点击构建 > 查看日志
   - 大多数问题都会有明确的错误信息

2. **查阅文档**
   - `QUICKSTART.md` - 快速解答常见问题
   - `CODEMAGIC_SETUP.md` - 详细配置问题
   - `SETUP_GITHUB.md` - GitHub相关问题

3. **常见错误及解决**
   - Code Signing错误 → 按CODEMAGIC_SETUP.md第2步重新配置
   - Pod错误 → 运行 `pod install --repo-update`
   - 内存不足 → 在CodeMagic中选择更大的实例类型

4. **寻求帮助**
   - CodeMagic官方文档：https://docs.codemagic.io
   - GitHub文档：https://docs.github.com
   - 提交Issue到仓库

---

## 📈 后续优化建议

### 第1阶段（现在）✅
- 代码上传到GitHub
- CodeMagic自动构建运行
- 生成IPA文件

### 第2阶段（可选）
- 配置自动上传到App Store
- 设置TestFlight beta分发
- 添加自动化单元测试

### 第3阶段（高级）
- 集成Slack通知
- 自动版本号管理
- 自动化截图和应用审核说明生成
- 集成性能监控

---

## 📞 快速参考

### 重要URL
- 代码仓库：`https://github.com/YOUR_USERNAME/LiveDemo`
- Code Signing：`https://github.com/YOUR_USERNAME/iOS-Code-Signing`
- CodeMagic：`https://codemagic.io`
- Apple Developer：`https://developer.apple.com`
- App Store Connect：`https://appstoreconnect.apple.com`

### 重要命令
```bash
# 本地推送
git push origin main

# 安装依赖
pod install --repo-update

# 生成证书
fastlane match appstore

# Xcode构建
xcodebuild archive -workspace ... -scheme ...
```

### 重要文件
- 项目配置：`codemagic.yaml`
- Pod依赖：`Podfile`
- 应用信息：`LiveDemo/Info.plist`
- 签名选项：`ExportOptions.plist`

---

## 🎉 下一步

现在你已经准备好了！

1. **立即开始**: 
   - 阅读 `QUICKSTART.md`（5分钟）
   - 运行 `push_to_github.bat` 上传代码
   - 配置CodeMagic

2. **需要帮助**：
   - `SETUP_GITHUB.md` - GitHub操作指南
   - `CODEMAGIC_SETUP.md` - CodeMagic详细配置
   - 这个 `CHECKLIST.md` - 验证项目状态

3. **监控构建**：
   - 访问 CodeMagic 仪表板
   - 查看构建日志和错误
   - 下载构建成果

---

## 📝 项目信息

**应用名称**: 蜜桃直播
**Bundle ID**: com.meituo.livedemo
**最低iOS版本**: 13.0
**配置日期**: 2024年
**CodeMagic状态**: ✅ 已配置
**GitHub状态**: ⏳ 等待上传

---

**记住**: 首次配置可能需要一些调整，但一旦完成，后续的每次推送都会自动构建！祝你使用愉快！ 🚀

