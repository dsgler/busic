# 音乐列表存储重构说明

## 改动概览

将音乐列表的存储方式从"整个列表序列化为一个 JSON 字符串"改为"每个音乐项作为数据库表的单独一行"。

## 新增文件

### 1. `lib/models/music_list_item.dart`

- 将 `MusicListItemBv` 类从 `music_list_provider.dart` 中提取出来
- 作为独立的数据模型，避免循环依赖

### 2. `lib/providers/music_list_storage.dart`

- 自定义 `Storage<String, List<MusicListItemBv>>` 实现
- 使用 SQLite 表存储音乐列表
- 表结构：
  ```sql
  CREATE TABLE music_list (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    storage_key TEXT NOT NULL,
    bvid TEXT NOT NULL,
    cid INTEGER NOT NULL,
    title TEXT NOT NULL,
    artist TEXT NOT NULL,
    cover_url TEXT,
    audio_obj TEXT NOT NULL  -- JSON 字符串
  )
  ```

## 修改的文件

### 1. `lib/providers/music_list_provider.dart`

- 移除 `MusicListItemBv` 类定义
- 导入 `../models/music_list_item.dart`
- 使用 `musicListStorageProvider` 替代 `storageProvider`
- 移除 `encode` 和 `decode` 参数（由 Storage 实现处理）

### 2. `lib/pages/music_list_page.dart`

- 添加 `../models/music_list_item.dart` 导入

### 3. `lib/utils/sample_data.dart`

- 添加 `../models/music_list_item.dart` 导入

## 优势

1. **更规范的数据库设计**：每行对应一个音乐项，便于查询和管理
2. **更好的性能**：可以按需查询、更新单个音乐项（未来扩展）
3. **数据完整性**：SQLite 的事务机制保证数据一致性
4. **可扩展性**：易于添加索引、关联查询等数据库功能

## 使用方式

使用方式与之前完全相同，透明化的存储层改动：

```dart
// 读取音乐列表
final musicList = ref.watch(musicListProvider);

// 添加音乐
await ref.read(musicListProvider.notifier).addMusic(music);

// 删除音乐
await ref.read(musicListProvider.notifier).removeMusic(index);
```

## 数据库位置

- 数据库文件：`busic_music_list.db`
- 路径：应用数据目录下的 databases 文件夹
