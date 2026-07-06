# 证书配置说明

## 已完成的操作

✅ **Bundle ID已更新**
- 原来的包名：`com.caizhixiu.phonelive6669`
- 新的包名：`com.fd.kuailiao`（与证书匹配）
- 已修改Xcode项目配置文件

✅ **证书文件已就位**
- 位置：`根目录/comfdkuailiao111(1).mobileprovision`
- 密码：`123`
- P12文件：`0628deco.p12`（如需要）

---

## 📱 本地开发配置（Xcode）

### 方案A：使用自动签名（推荐）

1. 在Xcode中打开 `LiveDemo.xcworkspace`
2. 选择 LiveDemo 项目
3. 选择 LiveDemo Target
4. 进入 Signing & Capabilities
5. 选择Team ID（你的Apple开发者账户）
6. 确保 Automatically manage signing 已勾选
7. Bundle ID 已自动设置为 `com.fd.kuailiao`

### 方案B：手动配置（如果需要）

1. 将 `comfdkuailiao111(1).mobileprovision` 复制到：
   ```
   ~/Library/MobileDevice/Provisioning\ Profiles/
   ```

2. Xcode中设置：
   - Signing Style: Manual
   - Provisioning Profile: 选择 comfdkuailiao111

---

## 🚀 GitHub上传命令

### 完整命令序列

```bash
# 进入项目目录
cd c:\Users\Administrator\Desktop\LiveDemo

# 初始化git（如果还没有）
git init

# 查看状态
git status

# 添加所有文件（证书和修改会被包含）
git add .

# 提交
git commit -m "Update: Change Bundle ID to com.fd.kuailiao and add provisioning profile"

# 添加远程仓库（替换YOUR_USERNAME）
git remote add origin https://github.com/YOUR_USERNAME/LiveDemo.git

# 改为main分支
git branch -M main

# 推送到GitHub
git push -u origin main
```

### 如果已有远程仓库

```bash
cd c:\Users\Administrator\Desktop\LiveDemo
git add .
git commit -m "Update: Change Bundle ID to com.fd.kuailiao and add provisioning profile"
git push origin main
```

### 后续更新推送

```bash
git add .
git commit -m "Your commit message"
git push
```

---

## ⚠️ 重要提示

### 证书文件处理

- **Provisioning Profile** (`.mobileprovision`) 文件包含在Git中是安全的
- **P12证书** (`0628deco.p12`) 包含敏感信息，建议：
  - 如果是个人项目：可以提交
  - 如果是团队项目：通过CodeMagic Secret变量管理，不提交到Git

### CodeMagic配置

在CodeMagic中需要设置环境变量：

```yaml
PROVISIONING_PROFILE_PATH: "comfdkuailiao111(1).mobileprovision"
PROVISIONING_PROFILE_SELECTOR: "com.fd.kuailiao"
CERTIFICATE_PASSWORD: "123"
```

---

## 📝 修改内容总结

| 项目 | 改动 |
|-----|------|
| **Bundle ID** | com.caizhixiu.phonelive6669 → **com.fd.kuailiao** |
| **Provisioning Profile** | comfdkuailiao111(1).mobileprovision |
| **项目配置文件** | project.pbxproj（已更新2处） |

---

## ✅ 验证步骤

### 验证Bundle ID是否正确修改

```bash
# 在项目根目录运行
grep -r "PRODUCT_BUNDLE_IDENTIFIER = com.fd.kuailiao" LiveDemo/LiveDemo.xcodeproj/project.pbxproj
```

应该返回结果说明配置成功。

---

现在可以执行上面的 **GitHub上传命令** 了！

