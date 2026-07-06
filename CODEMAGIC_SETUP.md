# CodeMagic CI/CD 配置指南

## 概述

CodeMagic是一个面向iOS/Android开发者的持续集成和交付(CI/CD)平台。本指南帮助你配置CodeMagic以自动构建和发布蜜桃直播。

## 前置条件

- ✅ GitHub账户（已有）
- ✅ CodeMagic账户（免费账户即可开始）
- ✅ Apple ID和密码
- ✅ Apple Developer账户（需要发布到App Store）

## 安装和配置步骤

### 第1步：设置Code Signing

Code Signing是iOS应用开发最关键的部分。CodeMagic支持多种方式管理证书。

#### 方案A：使用Fastlane Match（推荐）

最安全和便捷的方式是使用fastlane match。

##### 1. 创建Code Signing仓库

```bash
# 在GitHub创建新仓库：iOS-Code-Signing（设为私有）
# 使用HTTPS或SSH克隆

# 初始化match（首次使用）
cd ~/path/to/ios-code-signing-repo
fastlane match init

# 按照提示选择：
# - Storage: git
# - Git URL: 你的iOS-Code-Signing仓库URL
# - Type of certificates: development, adhoc, appstore（都选）
```

##### 2. 生成或导入证书

```bash
# 方式1：让match生成新证书
fastlane match development --readonly  # 生成development证书
fastlane match appstore --readonly     # 生成app store证书

# 方式2：导入现有证书
fastlane match import
# 按提示导入.p12证书文件和provisioning profiles
```

##### 3. 在CodeMagic中配置

在CodeMagic项目设置 > Code signing中：

1. 选择 iOS signing
2. 选择 Fastlane authentication
3. 输入以下信息：
   - **Git URL**: 你的iOS-Code-Signing仓库URL
   - **Match Password**: match setup时创建的密码
   - **Bundle identifier**: com.meituo.livedemo

#### 方案B：手动配置（不推荐生产环境）

如果你更喜欢手动管理：

1. 在CodeMagic中上传证书文件（.p12）
2. 上传Provisioning Profile文件
3. 配置相关密码

### 第2步：配置环境变量

在CodeMagic项目 > Variables 中设置以下变量：

| 变量名 | 值 | 类型 | 说明 |
|------|----|----|------|
| `APPLE_ID` | your@email.com | String | Apple ID账户 |
| `APPLE_PASSWORD` | ***** | Secret | Apple ID密码（使用Secret类型） |
| `MATCH_PASSWORD` | ***** | Secret | match证书密码 |
| `MATCH_GIT_URL` | git仓库URL | String | iOS-Code-Signing仓库URL |
| `TEAM_EMAIL` | team@example.com | String | 接收构建通知的邮箱 |
| `FASTLANE_USER` | $APPLE_ID | String | Fastlane用户名 |
| `FASTLANE_PASSWORD` | $APPLE_PASSWORD | String | Fastlane密码 |

### 第3步：配置App Store Connect

如果要自动上传到App Store：

1. 在CodeMagic中生成App-Specific Password
2. 在CodeMagic Variables中添加：
   - `APPSTORE_CONNECT_ISSUER_ID`
   - `APPSTORE_CONNECT_KEY_IDENTIFIER`
   - `APPSTORE_CONNECT_PRIVATE_KEY`

### 第4步：配置Webhook

启用GitHub webhook自动触发构建：

1. 在CodeMagic项目 > Webhook中
2. 复制webhook URL
3. 在GitHub仓库设置中添加webhook
4. 选择触发事件：Push, Pull Request等

## 工作流程说明

### 构建流程（ios-build）

```
1. Install dependencies → pod install
2. Build → xcodebuild build
3. Archive → xcodebuild archive
4. Export → xcodebuild -exportArchive
5. Publish → 邮件通知
```

### 测试流程（ios-test）

```
1. Install dependencies → pod install
2. Run tests → xcodebuild test
```

## 常见配置修改

### 修改签名方式

编辑 `ExportOptions.plist`：

```xml
<!-- app-store: 用于App Store提交 -->
<key>method</key>
<string>app-store</string>

<!-- ad-hoc: 用于测试分发 -->
<string>ad-hoc</string>

<!-- enterprise: 用于企业分发 -->
<string>enterprise</string>

<!-- development: 用于开发 -->
<string>development</string>
```

### 修改部署目标

在 `codemagic.yaml` 中：

```yaml
environment:
  vars:
    IPHONEOS_DEPLOYMENT_TARGET: "13.0"  # 修改为你的目标版本
```

### 添加post-build脚本

在 `codemagic.yaml` 中artifacts之后添加：

```yaml
publishing:
  email:
    recipients:
      - $TEAM_EMAIL
  app_store_connect:
    auth: api_key
    # 配置自动上传到App Store
```

## 故障排除

### 构建失败：证书错误

```
❌ Error: "No matching provisioning profile found"
```

**解决方案**：
1. 确保match仓库中有正确的证书
2. 验证Bundle ID与证书匹配
3. 重新运行 `fastlane match development --force`

### 构建失败：Pod错误

```
❌ Error: "[!] Unable to find a specification for 'PodName'"
```

**解决方案**：
1. 在 `codemagic.yaml` 中添加 `--repo-update` 选项
2. 检查 `Podfile` 中的pod源配置
3. 清理pod缓存：`pod cache clean --all`

### 构建失败：内存不足

**解决方案**：
1. 在CodeMagic中选择更大的实例类型
2. 在 `codemagic.yaml` 中增加 `max_build_duration`

### 推送到App Store失败

**解决方案**：
1. 验证App Store Connect API密钥配置
2. 确保应用版本号正确
3. 检查TestFlight是否已接受此版本

## 最佳实践

### 安全性

✅ **必须做**：
- 使用Secret变量存储敏感信息
- 将Code Signing存储在私有仓库
- 启用double-check for signing
- 定期轮换密码

❌ **不要做**：
- 在代码或配置文件中硬编码密码
- 提交私钥到公开仓库
- 在日志中输出密码
- 与他人共享Apple ID

### 性能优化

1. **启用缓存**：
   ```yaml
   caches:
     cocoapods_cache:
       - ~/.cocoapods
   ```

2. **并行构建**：
   ```yaml
   max_build_duration: 120  # 增加超时时间
   ```

3. **选择合适的Xcode版本**：
   ```yaml
   xcode: latest  # 或指定具体版本
   ```

## 监控和报告

### 查看构建日志

1. CodeMagic仪表板 > 项目
2. 点击最近的构建
3. 查看详细日志

### 设置通知

1. 项目设置 > Publishing
2. 配置邮件、Slack或其他通知方式

### 分析构建时间

1. 查看构建历史
2. 识别瓶颈（通常是Pod下载）
3. 优化 `codemagic.yaml`

## 高级配置

### 多环境构建

在 `codemagic.yaml` 中定义多个工作流：

```yaml
workflows:
  development-build:
    environment:
      vars:
        BUILD_ENV: "development"
    # ...
  
  production-build:
    environment:
      vars:
        BUILD_ENV: "production"
    # ...
```

### 条件执行

```yaml
scripts:
  - name: Build for specific branch
    script: |
      if [[ "$CI_BRANCH" == "main" ]]; then
        # 只在main分支执行
        echo "Building for production"
      fi
```

## 获取帮助

- 📖 [CodeMagic官方文档](https://docs.codemagic.io)
- 💬 [CodeMagic社区](https://codemagic.io/community)
- 🔧 [iOS签名问题排查](https://docs.codemagic.io/yaml/building-a-native-ios-app/)
- 📧 CodeMagic支持: support@codemagic.io

---

**提示**: 首次配置时，建议先在Development环境中测试，成功后再切换到App Store配置。

