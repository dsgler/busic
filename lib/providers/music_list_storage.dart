import 'dart:async';
import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/music_list_item.dart';
import 'music_database.dart';

/// 使用 Drift ORM 的音乐列表存储
/// 将列表编码/解码委托给内部方法
class MusicListDriftStorage {
  final MusicDatabase _db;

  MusicListDriftStorage._(this._db);

  static Future<MusicListDriftStorage> open() async {
    final db = MusicDatabase();
    return MusicListDriftStorage._(db);
  }

  /// 编码：直接返回列表（存储层会处理）
  List<MusicListItemBv> encode(List<MusicListItemBv> data) => data;

  /// 解码：直接返回列表
  List<MusicListItemBv> decode(List<MusicListItemBv> data) => data;

  /// 读取音乐列表
  Future<List<MusicListItemBv>?> read(String key) async {
    final results = await _db.getMusicList(key);
    return results.isEmpty ? null : results;
  }

  /// 保存音乐列表
  Future<void> write(String key, List<MusicListItemBv> value) async {
    await _db.saveMusicList(key, value);
  }

  /// 删除音乐列表
  Future<void> delete(String key) async {
    await _db.deleteMusicList(key);
  }

  /// 关闭数据库连接
  Future<void> close() async {
    await _db.close();
  }
}

/// 创建一个包装的 Storage
Future<Storage<String, List<MusicListItemBv>>> createMusicListStorage() async {
  final driftStorage = await MusicListDriftStorage.open();

  // 使用 JsonSqFliteStorage 作为基础，但用自定义的读写方法
  return _DriftStorageWrapper(driftStorage);
}

/// Storage 包装器
final class _DriftStorageWrapper
    extends Storage<String, List<MusicListItemBv>> {
  final MusicListDriftStorage _driftStorage;

  _DriftStorageWrapper(this._driftStorage);

  @override
  FutureOr<PersistedData<List<MusicListItemBv>>?> read(String key) async {
    final results = await _driftStorage.read(key);
    if (results == null) return null;

    // PersistedData 是 (T, DateTime) 的 record 类型别名
    return (results, DateTime.now()) as PersistedData<List<MusicListItemBv>>;
  }

  @override
  FutureOr<void> write(
    String key,
    List<MusicListItemBv> value,
    StorageOptions options,
  ) async {
    await _driftStorage.write(key, value);
  }

  @override
  Future<void> delete(String key) async {
    await _driftStorage.delete(key);
  }

  @override
  void deleteOutOfDate() {
    // 音乐列表不需要自动清理
  }
}

/// Storage Provider for Music List
final musicListStorageProvider =
    FutureProvider<Storage<String, List<MusicListItemBv>>>((ref) async {
      return createMusicListStorage();
    });
