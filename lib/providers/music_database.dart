import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/music_list_item.dart';
import '../models/user_pref.dart';

part 'music_database.g.dart';

/// 音乐列表数据表定义
class MusicItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get bvid => text()();
  IntColumn get cid => integer()();
  TextColumn get title => text()();
  TextColumn get artist => text()();
  TextColumn get coverUrl => text().nullable()();
  TextColumn get category => text().withDefault(const Constant('default'))();
}

/// Drift 数据库类
@DriftDatabase(tables: [MusicItems])
class MusicDatabase extends _$MusicDatabase {
  MusicDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < schemaVersion) {
          await m.drop(musicItems);
        }
      },
    );
  }

  /// 读取所有音乐项（可选按category过滤）
  Future<List<MusicListItemBv>> getMusicList({MusicListMode? category}) async {
    final query = select(musicItems)..orderBy([(t) => OrderingTerm.asc(t.id)]);

    if (category != null) {
      query.where((tbl) => tbl.category.equals(category.jsonValue));
    }

    final items = await query.get();
    return items.map((item) => _toMusicItem(item)).toList();
  }

  /// 保存音乐列表（替换所有数据）
  Future<void> saveMusicList(List<MusicListItemBv> musicList) async {
    await transaction(() async {
      // 删除旧数据
      await delete(musicItems).go();

      // 插入新数据
      await batch((batch) {
        batch.insertAll(
          musicItems,
          musicList.map((music) => _toCompanion(music)),
        );
      });
    });
  }

  /// 删除所有音乐项
  Future<void> deleteMusicList() async {
    await delete(musicItems).go();
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
      category: MusicListMode.fromString(item.category),
    );
  }

  /// 将 MusicListItemBv 转换为数据库插入对象
  MusicItemsCompanion _toCompanion(MusicListItemBv music) {
    return MusicItemsCompanion.insert(
      bvid: music.bvid,
      cid: music.cid,
      title: music.title,
      artist: music.artist,
      coverUrl: Value(music.coverUrl),
      category: Value(music.category.jsonValue),
    );
  }

  /// 添加单个音乐项
  Future<void> addMusicItem(MusicListItemBv music) async {
    await into(musicItems).insert(_toCompanion(music));
  }

  /// 删除单个音乐项（根据 ID）
  Future<void> deleteMusicItem(int id) async {
    await (delete(musicItems)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// 更新单个音乐项
  Future<void> updateMusicItem(int id, MusicListItemBv music) async {
    await (update(
      musicItems,
    )..where((tbl) => tbl.id.equals(id))).write(_toCompanion(music));
  }

  /// 根据类别获取音乐列表
  Future<List<MusicListItemBv>> getMusicListByCategory(
    MusicListMode category,
  ) async {
    final items =
        await (select(musicItems)
              ..where((tbl) => tbl.category.equals(category.jsonValue))
              ..orderBy([(t) => OrderingTerm.asc(t.id)]))
            .get();

    return items.map((item) => _toMusicItem(item)).toList();
  }

  /// 获取所有类别
  Future<List<MusicListMode>> getCategories() async {
    final query = selectOnly(musicItems, distinct: true)
      ..addColumns([musicItems.category]);

    final results = await query.get();
    return results
        .map((row) => MusicListMode.fromString(row.read(musicItems.category)!))
        .toList();
  }

  /// 删除指定分类的所有音乐项
  Future<void> deleteMusicListByCategory(MusicListMode category) async {
    await (delete(
      musicItems,
    )..where((tbl) => tbl.category.equals(category.jsonValue))).go();
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
