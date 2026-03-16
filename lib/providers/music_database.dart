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
  TextColumn get bvid => text()();
  IntColumn get cid => integer()();
  TextColumn get title => text()();
  TextColumn get subTitle => text()();
  TextColumn get artist => text()();
  TextColumn get coverUrl => text().nullable()();
  /// 复合 key，如 "default", "favList:123456", "seasonsArchives:789"
  TextColumn get category => text().withDefault(const Constant('default'))();
}

/// Drift 数据库类
@DriftDatabase(tables: [MusicItems])
class MusicDatabase extends _$MusicDatabase {
  MusicDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < schemaVersion) {
          await m.drop(musicItems);
          await m.createTable(musicItems);
        }
      },
    );
  }

  /// 读取所有音乐项（可选按 categoryKey 过滤）
  Future<List<MusicListItemBv>> getMusicList({String? categoryKey}) async {
    final query = select(musicItems)..orderBy([(t) => OrderingTerm.asc(t.id)]);

    if (categoryKey != null) {
      query.where((tbl) => tbl.category.equals(categoryKey));
    }

    final items = await query.get();
    return items.map((item) => _toMusicItem(item)).toList();
  }

  /// 保存音乐列表（替换指定 categoryKey 的所有数据）
  Future<void> saveMusicList(
    List<MusicListItemBv> musicList, {
    String? categoryKey,
  }) async {
    await transaction(() async {
      await deleteMusicList(categoryKey: categoryKey);

      await batch((batch) {
        batch.insertAll(
          musicItems,
          musicList.map((music) => _toCompanion(music)),
        );
      });
    });
  }

  /// 删除音乐项（可选按 categoryKey 过滤）
  Future<void> deleteMusicList({String? categoryKey}) async {
    if (categoryKey != null) {
      await (delete(musicItems)
            ..where((it) => it.category.equals(categoryKey)))
          .go();
    } else {
      await delete(musicItems).go();
    }
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
      subTitle: item.subTitle,
      artist: item.artist,
      coverUrl: item.coverUrl,
      categoryKey: item.category,
    );
  }

  /// 将 MusicListItemBv 转换为数据库插入对象
  MusicItemsCompanion _toCompanion(MusicListItemBv music) {
    return MusicItemsCompanion.insert(
      bvid: music.bvid,
      cid: music.cid,
      title: music.title,
      subTitle: music.subTitle,
      artist: music.artist,
      coverUrl: Value(music.coverUrl),
      category: Value(music.categoryKey),
    );
  }

  /// 添加单个音乐项
  Future<void> addMusicItem(MusicListItemBv music) async {
    await into(musicItems).insert(_toCompanion(music));
  }

  /// 删除单个音乐项（根据数据库 ID）
  Future<void> deleteMusicItem(int id) async {
    await (delete(musicItems)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// 根据 categoryKey 获取音乐列表
  Future<List<MusicListItemBv>> getMusicListByCategory(
    String categoryKey,
  ) async {
    final items =
        await (select(musicItems)
              ..where((tbl) => tbl.category.equals(categoryKey))
              ..orderBy([(t) => OrderingTerm.asc(t.id)]))
            .get();

    return items.map((item) => _toMusicItem(item)).toList();
  }

  /// 获取所有 categoryKey 列表
  Future<List<String>> getCategoryKeys() async {
    final query = selectOnly(musicItems, distinct: true)
      ..addColumns([musicItems.category]);

    final results = await query.get();
    return results
        .map((row) => row.read(musicItems.category)!)
        .toList();
  }

  /// 删除指定 categoryKey 的所有音乐项
  Future<void> deleteMusicListByCategory(String categoryKey) async {
    await (delete(musicItems)
          ..where((tbl) => tbl.category.equals(categoryKey)))
        .go();
  }

  /// 模糊搜索音乐项（搜索 title, subtitle, artist, bvid）
  Future<List<MusicListItemBv>> searchMusicList(
    String keyword, {
    String? categoryKey,
  }) async {
    if (keyword.isEmpty) {
      return getMusicList(categoryKey: categoryKey);
    }

    final query = select(musicItems)..orderBy([(t) => OrderingTerm.asc(t.id)]);

    if (categoryKey != null) {
      query.where((tbl) => tbl.category.equals(categoryKey));
    }

    final searchPattern = '%$keyword%';
    query.where(
      (tbl) =>
          tbl.title.like(searchPattern) |
          tbl.subTitle.like(searchPattern) |
          tbl.artist.like(searchPattern) |
          tbl.bvid.like(searchPattern),
    );

    final items = await query.get();
    return items.map((item) => _toMusicItem(item)).toList();
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
