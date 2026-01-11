# 用户信息功能使用说明

## 功能概述

已实现用户信息页面，包含用户头像、用户名、登录状态和登录二维码功能，并集成到了应用的侧边栏(Drawer)中。

## 实现的文件

### 1. 模型层

- **lib/models/user_info.dart** - 用户信息数据模型
  - 包含用户名、头像、ID、登录状态
  - 提供 JSON 序列化/反序列化
  - 支持 copyWith 更新

### 2. Provider 层

- **lib/providers/user_info_provider.dart** - 用户状态管理
  - 使用 SharedPreferences 持久化用户信息
  - 提供登录、退出、更新用户信息等方法
  - 自动加载和保存用户数据

### 3. 页面层

- **lib/pages/user_info_page.dart** - 用户信息展示页
  - 显示用户头像、用户名、登录状态
  - "获取登录二维码"按钮（包含模拟登录功能）
  - 退出登录功能
  - 使用 Riverpod 自动响应状态变化

### 4. 集成更新

- **lib/main.dart** - 初始化 SharedPreferences
- **lib/pages/music_list_page.dart** - 更新 Drawer
  - 添加用户头像和用户名的 Header
  - 添加"用户信息"导航项
  - 点击 Header 可快速跳转到用户信息页

## 使用方式

### 1. 访问用户信息页

- 在主页面左上角点击菜单按钮
- 在 Drawer 中点击"用户信息"或点击顶部的用户 Header

### 2. 登录功能

- 在用户信息页点击"获取登录二维码"
- 目前提供"模拟登录"功能用于测试
- 实际的二维码登录逻辑需要后续实现

### 3. 退出登录

- 已登录状态下，点击"退出登录"按钮
- 确认后清除所有用户信息

### 4. 数据持久化

- 用户信息自动保存到本地（SharedPreferences）
- 应用重启后自动恢复用户状态

## 代码示例

### 读取用户信息

```dart
final userInfo = ref.watch(userInfoProvider);
print(userInfo.username); // 用户名
print(userInfo.isLoggedIn); // 是否登录
```

### 更新用户信息

```dart
await ref.read(userInfoProvider.notifier).updateUserInfo(
  username: '新用户名',
  avatarUrl: 'https://example.com/avatar.jpg',
);
```

### 用户登录

```dart
await ref.read(userInfoProvider.notifier).login(
  username: '用户名',
  avatarUrl: 'https://example.com/avatar.jpg',
  userId: '12345',
);
```

### 退出登录

```dart
await ref.read(userInfoProvider.notifier).logout();
```

## 待实现功能

1. **真实的二维码登录**

   - 需要对接后端 API 获取二维码
   - 轮询检查登录状态
   - 扫码成功后保存用户信息

2. **更多用户信息**

   - 用户等级
   - 会员状态
   - 收藏数、粉丝数等

3. **设置页面**
   - Drawer 中的"设置"功能待开发

## 技术特点

- ✅ 使用 Riverpod 进行状态管理
- ✅ SharedPreferences 实现数据持久化
- ✅ 自动加载和保存用户状态
- ✅ 响应式 UI 更新
- ✅ 支持网络头像加载和缓存
- ✅ 优雅的错误处理和占位图显示
