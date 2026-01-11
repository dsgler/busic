import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:riverpod_sqflite/riverpod_sqflite.dart';
import 'package:sqflite/sqflite.dart';

final musicListStorageProvider = FutureProvider<Storage<String, String>>((
  ref,
) async {
  // 初始化 SQFlite 数据库，共享 Storage 实例
  return JsonSqFliteStorage.open(
    join(await getDatabasesPath(), 'busic_music.db'),
  );
});

/// Storage Provider - 用于持久化数据的数据库实例
/// 所有需要持久化的 Provider 都应该使用这个 Storage
final storageProvider = FutureProvider<Storage<String, String>>((ref) async {
  // 初始化 SQFlite 数据库，共享 Storage 实例
  return JsonSqFliteStorage.open(join(await getDatabasesPath(), 'riverpod.db'));
});
