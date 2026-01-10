# 音乐列表存储 - Drift ORM 实现

## ✨ 最新更新

已成功集成 **Drift ORM** 实现音乐列表的数据库存储！

### 为什么是 Drift？

- ✅ **类型安全**: 编译时检查，避免 SQL 错误
- ✅ **自动生成**: 大幅减少样板代码
- ✅ **现代化**: 支持最新 Dart 特性和 null safety
- ✅ **兼容性好**: 与项目中的其他工具完全兼容
- ✅ **性能优秀**: 与手写 SQL 性能相当
- ✅ **Stream 支持**: 原生支持响应式编程

## 🏗️ 架构概览

```
┌─────────────────────────────────────────┐
│   UI Layer (music_list_page.dart)      │
│   ↓ ref.watch(musicListProvider)       │
├─────────────────────────────────────────┤
│   Provider Layer                        │
│   ├── music_list_provider.dart         │ ← Riverpod AsyncNotifier
│   ├── music_list_storage.dart          │ ← Storage wrapper
│   └── music_database.dart               │ ← Drift database
│           ↓                              │
├─────────────────────────────────────────┤
│   ORM Layer (Drift)                     │
│   ├── music_database.g.dart            │ ← 自动生成
│   └── SQL queries (type-safe)          │
│           ↓                              │
├─────────────────────────────────────────┤
│   SQLite Database                       │
│   └── busic_music_drift.db             │
└─────────────────────────────────────────┘
```

## 📁 文件结构

### 核心文件

1. **lib/models/music_list_item.dart**

   - 数据模型类 `MusicListItemBv`
   - JSON 序列化/反序列化

2. **lib/providers/music_database.dart**

   - Drift 数据库定义
   - 表结构定义（MusicItems）
   - CRUD 操作方法

3. **lib/providers/music_database.g.dart**

   - 由 build_runner 自动生成
   - ⚠️ 不要手动编辑

4. **lib/providers/music_list_storage.dart**

   - Storage 接口实现
   - 封装 Drift 操作
   - 与 Riverpod persist 集成

5. **lib/providers/music_list_provider.dart**
   - Riverpod AsyncNotifier
   - 业务逻辑层

## 📊 数据库表结构

```sql
CREATE TABLE music_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  storage_key TEXT NOT NULL,      -- 存储键（支持多个列表）
  bvid TEXT NOT NULL,              -- B站视频ID
  cid INTEGER NOT NULL,            -- 分P ID
  title TEXT NOT NULL,             -- 标题
  artist TEXT NOT NULL,            -- 艺术家
  cover_url TEXT,                  -- 封面URL（可选）
  audio_obj_json TEXT NOT NULL     -- 音频对象JSON
);
```

## 🚀 快速开始

### 1. 依赖安装

依赖已添加到 `pubspec.yaml`：

```yaml
dependencies:
  drift: ^2.23.0
  sqlite3_flutter_libs: ^0.5.24

dev_dependencies:
  build_runner: ^2.4.15
  drift_dev: ^2.23.0
```

运行：

```bash
flutter pub get
```

### 2. 代码生成

修改 `music_database.dart` 后需要运行：

```bash
# 一次性生成
dart run build_runner build --delete-conflicting-outputs

# 或者监听模式（自动生成）
dart run build_runner watch --delete-conflicting-outputs
```

### 3. 基本使用

```dart
// 读取音乐列表
final musicListAsync = ref.watch(musicListProvider);

// 添加音乐
await ref.read(musicListProvider.notifier).addMusic(
  MusicListItemBv(
    bvid: 'BV1234567890',
    cid: 1,
    title: '示例音乐',
    artist: '示例艺术家',
    audioObj: Audio(/* ... */),
  ),
);

// 删除音乐
await ref.read(musicListProvider.notifier).removeMusic(index);

// 清空列表
await ref.read(musicListProvider.notifier).clearList();
```

## 🔧 高级功能

### 自定义查询

在 `music_database.dart` 中添加方法：

```dart
/// 按标题搜索
Future<List<MusicListItemBv>> searchByTitle(String key, String keyword) async {
  final items = await (select(musicItems)
        ..where((tbl) => tbl.storageKey.equals(key))
        ..where((tbl) => tbl.title.like('%$keyword%')))
      .get();

  return items.map((item) => _toMusicItem(item)).toList();
}

/// 按艺术家筛选
Future<List<MusicListItemBv>> filterByArtist(String key, String artist) async {
  final items = await (select(musicItems)
        ..where((tbl) => tbl.storageKey.equals(key))
        ..where((tbl) => tbl.artist.equals(artist)))
      .get();

  return items.map((item) => _toMusicItem(item)).toList();
}
```

### Stream 实时更新

```dart
/// 实时监听音乐列表变化
Stream<List<MusicListItemBv>> watchMusicList(String key) {
  return (select(musicItems)
        ..where((tbl) => tbl.storageKey.equals(key))
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .watch()
      .map((items) => items.map((item) => _toMusicItem(item)).toList());
}
```

## 📝 数据库迁移

当需要修改表结构时：

1. 修改 `MusicItems` 类
2. 增加 `schemaVersion`
3. 实现迁移策略

```dart
@override
int get schemaVersion => 2;

@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from == 1) {
        // 添加新列
        await migrator.addColumn(musicItems, musicItems.newField);
      }
    },
  );
}
```

## 📈 性能对比

| 特性     | 手写 SQL  | Drift ORM |
| -------- | --------- | --------- |
| 查询性能 | ⚡ 快     | ⚡ 快     |
| 插入性能 | ⚡ 快     | ⚡ 快     |
| 类型安全 | ❌ 运行时 | ✅ 编译时 |
| 代码量   | 📝 多     | 📝 少     |
| 维护性   | 😰 困难   | 😊 容易   |
| 学习曲线 | 📚 低     | 📚 中等   |
| 重构友好 | ❌ 否     | ✅ 是     |

## 🗂️ 数据存储位置

- **数据库文件**: `busic_music_drift.db`
- **路径**: `应用文档目录/busic_music_drift.db`
  - Android: `/data/data/<package>/app_flutter/`
  - iOS: `<Application Documents>/`

## 📚 参考资源

- [Drift 官方文档](https://drift.simonbinder.eu/)
- [Drift GitHub](https://github.com/simolus3/drift)
- [使用示例](./drift_usage_examples.dart)
- [详细说明](./drift_orm_usage.md)

## ⚠️ 注意事项

1. **不要手动编辑** `music_database.g.dart`
2. 修改表结构后**必须运行** build_runner
3. 数据库迁移需要**增加版本号**并实现迁移逻辑
4. 使用 watch 模式开发时会自动重新生成代码

## 🎯 TODO

- [ ] 添加全文搜索支持
- [ ] 实现分页查询
- [ ] 添加收藏夹功能（多表关联）
- [ ] 优化大数据量性能
- [ ] 添加数据导入/导出功能

---

**最后更新**: 2026 年 1 月 10 日
**ORM 版本**: Drift 2.23.0
