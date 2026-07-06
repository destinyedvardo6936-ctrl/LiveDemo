# 蜜桃直播 - iOS

## 项目简介

蜜桃直播是一个功能完整的iOS直播应用，提供视频直播、短视频、用户账户管理等功能。

## 系统要求

- Xcode 14.0 或更新版本
- iOS 13.0 或更新版本
- CocoaPods 1.11 或更新版本

## 项目结构

```
LiveDemo/
├── Assets.xcassets/          # 应用资源
├── Base/                     # 基础类
├── Base.lproj/              # 基础本地化文件
├── Category/                # 分类扩展
├── Common/                  # 通用工具和常量
├── en.lproj/               # 英文本地化
├── Marcos/                 # 宏定义
├── Moudles/                # 功能模块
├── ms.lproj/               # 毛里求斯语本地化
├── NetWork/                # 网络请求模块
├── zh-Hans.lproj/          # 简体中文本地化
├── zh-Hant.lproj/          # 繁体中文本地化
└── ...
```

## 安装依赖

### 使用CocoaPods安装依赖

```bash
cd LiveDemo
pod install
```

## 构建和运行

### 使用Xcode构建

1. 打开 `LiveDemo.xcworkspace`
2. 选择 `LiveDemo` 目标
3. 选择目标设备或模拟器
4. 按 Cmd + R 运行

### 使用命令行构建

```bash
cd LiveDemo
xcodebuild build \
  -workspace LiveDemo.xcworkspace \
  -scheme LiveDemo \
  -configuration Release
```

## 编档和打包

### 归档应用

```bash
cd LiveDemo
xcodebuild archive \
  -workspace LiveDemo.xcworkspace \
  -scheme LiveDemo \
  -archivePath build/LiveDemo.xcarchive
```

### 导出IPA

创建 `ExportOptions.plist` 文件（用于导出IPA）：

```bash
xcodebuild -exportArchive \
  -archivePath build/LiveDemo.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath build
```

## CodeMagic 云打包

本项目已配置 CodeMagic CI/CD，支持自动构建和测试。

### CodeMagic 配置

- 配置文件：`codemagic.yaml`
- 支持工作流：
  - `ios-build`: 构建、归档和导出IPA
  - `ios-test`: 运行单元测试

### 环境变量配置

在 CodeMagic 中设置以下环境变量：

- `APPLE_ID`: Apple账户ID
- `APPLE_PASSWORD`: Apple账户密码
- `MATCH_PASSWORD`: Code Signing证书密码
- `MATCH_GIT_URL`: Code Signing仓库URL
- `TEAM_EMAIL`: 团队邮箱

## 主要功能模块

- 🔴 **直播模块**: 实时视频直播
- 📱 **短视频**: 短视频浏览和分享
- 👤 **用户管理**: 账户注册、登录、个人资料
- 🎬 **视频库**: 视频列表和详情
- 💬 **社交功能**: 分享和互动

## 依赖库

主要使用的第三方库包括：

- **AFNetworking**: 网络请求
- **Masonry**: 自动布局
- **SDWebImage**: 图片加载和缓存
- **TXLiteAVSDK_Professional**: 腾讯云直播SDK
- **Socket.IO-Client-Swift**: WebSocket通讯
- **MJRefresh**: 下拉刷新
- **JXPagingView**: 分页视图

## 贡献指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 许可证

MIT License - 详见 LICENSE 文件

## 支持

如有问题或建议，请通过以下方式联系我们：

- 创建 Issue
- 提交 Pull Request

---

**开发者**: 
**更新日期**: 2024年
