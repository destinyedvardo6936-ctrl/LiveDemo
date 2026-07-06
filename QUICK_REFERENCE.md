# 蜜桃直播 - GitHub & CodeMagic 快速参考卡

## 📌 一句话总结
你的iOS项目已完全准备好上传到GitHub，并已配置CodeMagic进行云端自动构建。

---

## ⚡ 三步快速启动

### 1️⃣ 上传代码（Windows）
```bash
push_to_github.bat
```
**或手动**：
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/LiveDemo.git
git branch -M main
git push -u origin main
```

### 2️⃣ CodeMagic配置（5分钟）
```
访问 https://codemagic.io
  → GitHub登录
    → 添加LiveDemo项目
      → 配置Code Signing（使用Fastlane Match）
        → 添加环境变量（APPLE_ID等）
```

### 3️⃣ 启动构建
```
推送代码到GitHub → CodeMagic自动构建 → 完成后邮件通知
```

---

## 🎯 已创建的文件清单

### 📄 配置文件（4个）
- ✅ `.gitignore` - Git忽略规则
- ✅ `codemagic.yaml` - CI/CD配置
- ✅ `ExportOptions.plist` - IPA导出选项
- ✅ `README.md` - 项目文档

### 📚 文档和指南（4个）
- ✅ `QUICKSTART.md` - ⭐ 5分钟快速指南
- ✅ `SETUP_GITHUB.md` - GitHub详细指南
- ✅ `CODEMAGIC_SETUP.md` - CodeMagic详细指南
- ✅ `CHECKLIST.md` - 完整检查清单

### 🛠️ 自动化脚本（2个）
- ✅ `push_to_github.bat` - Windows一键上传
- ✅ `push_to_github.sh` - Linux/Mac一键上传

**总计：10个新文件/更新文件**

---

## 🔑 关键信息

| 项目 | 值 |
|-----|-----|
| **应用名称** | 蜜桃直播 |
| **Bundle ID** | com.meituo.livedemo |
| **最低iOS版本** | iOS 13.0 |
| **Xcode工作区** | LiveDemo.xcworkspace |
| **主要SDK** | TXLiteAVSDK_Professional |

---

## ⚙️ 必需的环境变量（CodeMagic）

```
APPLE_ID                → 你的Apple ID账户
APPLE_PASSWORD          → Apple ID密码 (Secret)
MATCH_GIT_URL          → iOS-Code-Signing仓库URL
GIT_TOKEN              → GitHub个人访问令牌 (Secret)
TEAM_EMAIL             → your@email.com
```

---

## 🚨 最重要的一点：Code Signing

**这是最常见的错误原因。使用Fastlane Match：**

```bash
# 1. 创建私有GitHub仓库：iOS-Code-Signing

# 2. 生成证书
gem install fastlane
fastlane match init
fastlane match appstore

# 3. CodeMagic > Code signing > Fastlane
# 输入Git URL和密码
```

---

## 📞 文档索引

| 需求 | 查看文档 |
|-----|---------|
| **想快速开始？** | 👉 `QUICKSTART.md` |
| **GitHub问题？** | 👉 `SETUP_GITHUB.md` |
| **CodeMagic问题？** | 👉 `CODEMAGIC_SETUP.md` |
| **想验证配置？** | 👉 `CHECKLIST.md` |

---

## 🎯 成功标志

首次构建成功时：
- ✅ CodeMagic显示 "Build succeeded"
- ✅ 生成了 `.ipa` 文件
- ✅ 收到构建完成邮件
- ✅ 可以下载IPA到本地安装

---

## 常见问题（1分钟内解答）

**Q: 为什么我的Pods文件很大？**
A: 这是正常的。`.gitignore`已配置排除Pods，其他开发者运行`pod install`会重新下载。

**Q: 首次构建需要多长时间？**
A: 通常10-15分钟（包括下载依赖）。后续构建5-8分钟。

**Q: Code Signing失败怎么办？**
A: 按`CODEMAGIC_SETUP.md`第2C部分重新配置fastlane match。

**Q: 如何修改iOS最低版本？**
A: 编辑`Podfile`中的`platform :ios, '13.0'`。

**Q: 可以自动上传到App Store吗？**
A: 可以。需要配置App Store Connect API密钥（见`CODEMAGIC_SETUP.md`）。

---

## 🔗 重要链接

- 📖 CodeMagic文档：https://docs.codemagic.io
- 📖 GitHub文档：https://docs.github.com
- 📖 Fastlane文档：https://docs.fastlane.tools
- 🔑 Apple Developer：https://developer.apple.com
- 📱 App Store Connect：https://appstoreconnect.apple.com

---

## 💡 下一步行动清单

- [ ] 读完 `QUICKSTART.md`
- [ ] 运行 `push_to_github.bat` 上传代码
- [ ] 创建 iOS-Code-Signing 私有仓库
- [ ] 设置 Fastlane Match 证书
- [ ] 在CodeMagic配置环境变量
- [ ] 启动首次构建
- [ ] 验证构建成功
- [ ] 庆祝成功！🎉

---

## 📊 项目现状

```
项目分析         ✅ 完成
文件配置         ✅ 完成
文档编写         ✅ 完成
GitHub配置       ⏳ 等待执行
CodeMagic配置    ⏳ 等待执行
首次构建         ⏳ 等待执行
```

---

**现在你已经准备好开始了！** 🚀

首先阅读 `QUICKSTART.md`，然后运行 `push_to_github.bat` 上传代码。一切就会开始自动化了！

