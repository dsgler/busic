# 音频播放器使用说明

## 更新内容

已将播放器管理重构为使用 `StateNotifier`，现在每次播放新音乐时会：

1. 使用 `MusicListItemBv.generatePlayer()` 创建新的播放器
2. 自动关闭和释放之前的播放器
3. 正确处理播放器的生命周期

## 播放器架构

### AudioPlayerManager

- 管理播放器实例的生命周期
- 自动处理旧播放器的关闭和释放
- 通过 `setPlayer()` 方法设置新播放器

### Provider 结构

```dart
// 播放器管理器 Provider
audioPlayerManagerProvider: StateNotifierProvider<AudioPlayerManager, AudioPlayer?>

// 当前播放器 Provider
audioPlayerProvider: Provider<AudioPlayer?>

// 其他状态 Providers
playingStateProvider: StreamProvider<bool>
positionProvider: StreamProvider<Duration>
bufferedPositionProvider: StreamProvider<Duration>
durationProvider: StreamProvider<Duration?>
```

## 使用示例

### 播放新音乐

```dart
// 在 ConsumerWidget 中
onTap: () async {
  // 1. 设置当前播放的音乐索引
  ref.read(currentPlayingIndexProvider.notifier).state = index;

  // 2. 使用 generatePlayer 创建新播放器（会自动关闭旧播放器）
  final newPlayer = await music.generatePlayer();
  await ref.read(audioPlayerManagerProvider.notifier).setPlayer(newPlayer);

  // 3. 开始播放
  await newPlayer.play();
}
```

### 控制播放

```dart
final player = ref.watch(audioPlayerProvider);

// 播放
if (player != null) {
  player.play();
}

// 暂停
if (player != null) {
  player.pause();
}

// 跳转
if (player != null) {
  player.seek(Duration(seconds: 30));
}
```

## 特性

✅ 自动清理旧播放器
✅ 防止内存泄漏
✅ 使用 generatePlayer() 方法创建播放器
✅ 正确处理 null 检查
✅ 支持多个音乐源切换

## 注意事项

1. 所有使用 `player` 的地方都需要进行 null 检查
2. 切换音乐时会自动停止并释放旧播放器
3. 播放器的 headers 配置在 `generatePlayer()` 方法中统一管理
