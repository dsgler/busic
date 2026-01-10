# 使用 Drift ORM 重构音乐列表存储

## 概述

使用 **Drift**（原 Moor）ORM 重构了音乐列表存储层，提供类型安全的数据库操作和自动代码生成。

## Drift 简介

Drift 是 Flutter/Dart 最流行的 ORM 库，具有以下特点：

- ✅ 类型安全的查询构建器
- ✅ 自动代码生成
- ✅ 事务支持
- ✅ Stream 支持（实时更新）
- ✅ 迁移管理
- ✅ 现代化的 API 设计

## 为什么选择 Drift 而非 sqfentity

1. **依赖兼容性**: sqfentity 的 analyzer 版本与项目中的 custom_lint 和 riverpod_lint 冲突
2. **社区活跃度**: Drift 更活跃，文档更完善
3. **现代化**: Drift 支持最新的 Dart 特性和 null safety

## 项目结构

### 新增依赖

```yaml
dependencies:
  drift: ^2.23.0
  sqlite3_flutter_libs: ^0.5.24

dev_dependencies:
  build_runner: ^2.4.15
  drift_dev: ^2.23.0
```

### 核心文件

1. **music_database.dart** - 数据库定义

   ```dart
   // 表定义
   class MusicItems extends Table {
     IntColumn get id => integer().autoIncrement()();
     TextColumn get storageKey => text()();
     TextColumn get bvid => text()();
     IntColumn get cid => integer()();
     TextColumn get title => text()();
     TextColumn get artist => text()();
     TextColumn get coverUrl => text().nullable()();
     TextColumn get audioObjJson => text()();
   }

   // 数据库类
   @DriftDatabase(tables: [MusicItems])
   class MusicDatabase extends _$MusicDatabase {
     // CRUD 方法
   }
   ```

2. **music_database.g.dart** - 自动生成的代码

   - 由 `build_runner` 自动生成
   - 包含所有数据库操作的实现代码
   - ⚠️ 不要手动编辑此文件

3. **music_list_storage.dart** - Storage 实现
   - 封装 Drift 数据库操作
   - 实现 `Storage<String, List<MusicListItemBv>>` 接口
   - 与 Riverpod persist 集成

## 数据库表结构

```sql
CREATE TABLE music_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  storage_key TEXT NOT NULL,
  bvid TEXT NOT NULL,
  cid INTEGER NOT NULL,
  title TEXT NOT NULL,
  artist TEXT NOT NULL,
  cover_url TEXT,
  audio_obj_json TEXT NOT NULL
);
```

## 使用方法

### 运行代码生成

每次修改 `music_database.dart` 后需要运行：

```bash
dart run build_runner build --delete-conflicting-outputs
```

或者使用 watch 模式自动生成：

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### 在应用中使用

使用方式与之前完全相同，透明化的 ORM 集成：

```dart
// 读取音乐列表
final musicList = ref.watch(musicListProvider);

// 添加音乐
await ref.read(musicListProvider.notifier).addMusic(music);

// 删除音乐
await ref.read(musicListProvider.notifier).removeMusic(index);
```

## Drift 的优势

### 1. 类型安全

```dart
// ✅ 编译时检查
final items = await (select(musicItems)
  ..where((tbl) => tbl.storageKey.equals(key)))
  .get();

// ❌ 如果字段不存在，编译时就会报错
```

### 2. 自动生成

- 生成所有 CRUD 代码
- 减少样板代码
- 避免手写 SQL 错误

### 3. Stream 支持

```dart
// 实时监听数据变化
Stream<List<MusicItem>> watchMusicList(String key) {
  return (select(musicItems)
    ..where((tbl) => tbl.storageKey.equals(key)))
    .watch();
}
```

### 4. 事务支持

```dart
await transaction(() async {
  await delete(musicItems).go();
  await batch((batch) {
    batch.insertAll(musicItems, items);
  });
});
```

## 数据库位置

- 数据库文件：`busic_music_drift.db`
- 路径：`应用文档目录/busic_music_drift.db`

## 迁移说明

如果需要修改表结构：

1. 修改 `MusicItems` 类
2. 增加 `schemaVersion`
3. 实现 `MigrationStrategy`
4. 运行 `build_runner`

示例：

```dart
@override
int get schemaVersion => 2;

@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from == 1) {
        await migrator.addColumn(musicItems, musicItems.newField);
      }
    },
  );
}
```

## 性能对比

| 操作     | 手写 SQL  | Drift ORM |
| -------- | --------- | --------- |
| 查询     | ⚡ 快     | ⚡ 快     |
| 插入     | ⚡ 快     | ⚡ 快     |
| 类型安全 | ❌ 运行时 | ✅ 编译时 |
| 代码量   | 📝 多     | 📝 少     |
| 维护性   | 😰 困难   | 😊 容易   |

## 参考资源

- [Drift 官方文档](https://drift.simonbinder.eu/)
- [Drift GitHub](https://github.com/simolus3/drift)
- [迁移指南](https://drift.simonbinder.eu/docs/advanced-features/migrations/)
