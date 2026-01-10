import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/music_list_item.dart';

part 'music_database.g.dart';

/// 音乐列表数据表定义
class MusicItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get storageKey => text()();
  TextColumn get bvid => text()();
  IntColumn get cid => integer()();
  TextColumn get title => text()();
  TextColumn get artist => text()();
  TextColumn get coverUrl => text().nullable()();
}

/// Drift 数据库类
@DriftDatabase(tables: [MusicItems])
class MusicDatabase extends _$MusicDatabase {
  MusicDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// 读取指定 key 的所有音乐项
  Future<List<MusicListItemBv>> getMusicList(String key) async {
    final items =
        await (select(musicItems)
              ..where((tbl) => tbl.storageKey.equals(key))
              ..orderBy([(t) => OrderingTerm.asc(t.id)]))
            .get();

    return items.map((item) => _toMusicItem(item)).toList();
  }

  /// 保存音乐列表（替换该 key 的所有数据）
  Future<void> saveMusicList(
    String key,
    List<MusicListItemBv> musicList,
  ) async {
    await transaction(() async {
      // 删除旧数据
      await (delete(
        musicItems,
      )..where((tbl) => tbl.storageKey.equals(key))).go();

      // 插入新数据
      await batch((batch) {
        batch.insertAll(
          musicItems,
          musicList.map((music) => _toCompanion(key, music)),
        );
      });
    });
  }

  /// 删除指定 key 的所有音乐项
  Future<void> deleteMusicList(String key) async {
    await (delete(musicItems)..where((tbl) => tbl.storageKey.equals(key))).go();
  }

  /// 清空所有数据
  Future<void> clearAll() async {
    await delete(musicItems).go();
  }

  /// 将数据库行转换为 MusicListItemBv
  MusicListItemBv _toMusicItem(MusicItem item) {
    return MusicListItemBv(
      bvid: item.bvid,
      cid: item.cid,
      title: item.title,
      artist: item.artist,
      coverUrl: item.coverUrl,
    );
  }

  /// 将 MusicListItemBv 转换为数据库插入对象
  MusicItemsCompanion _toCompanion(String key, MusicListItemBv music) {
    return MusicItemsCompanion.insert(
      storageKey: key,
      bvid: music.bvid,
      cid: music.cid,
      title: music.title,
      artist: music.artist,
      coverUrl: Value(music.coverUrl),
    );
  }
}

/// 打开数据库连接
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'busic_music_drift.db'));
    return NativeDatabase(file);
  });
}
