import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/experimental/persist.dart';
import '../models/music_list_item.dart';
import 'music_list_storage.dart';
import 'package:flutter_riverpod/legacy.dart';

// 音乐列表 AsyncNotifier（支持持久化）
class MusicListNotifier extends AsyncNotifier<List<MusicListItemBv>> {
  @override
  Future<List<MusicListItemBv>> build() async {
    // 配置持久化 - 使用自定义的 MusicListStorage
    await persist(
      // 使用专门为音乐列表创建的 Storage
      ref.watch(musicListStorageProvider.future),
      // 唯一标识符
      key: 'music_list',
      // Storage 已经处理序列化，这里直接返回
      encode: (data) => data,
      decode: (data) => data,
      // 持久化选项：永久保存（适用于音乐列表）
      options: const StorageOptions(cacheTime: StorageCacheTime.unsafe_forever),
    ).future;

    // 如果有持久化的数据，返回它；否则返回空列表
    return state.value ?? [];
  }

  // 添加音乐到列表
  Future<void> addMusic(MusicListItemBv music) async {
    state = AsyncValue.data([...state.value!, music]);
  }

  // 删除音乐
  Future<void> removeMusic(int index) async {
    final currentList = state.value!;
    state = AsyncValue.data([
      ...currentList.sublist(0, index),
      ...currentList.sublist(index + 1),
    ]);
  }

  // 清空列表
  Future<void> clearList() async {
    state = const AsyncValue.data([]);
  }

  // 设置整个列表
  Future<void> setList(List<MusicListItemBv> list) async {
    state = AsyncValue.data(list);
  }
}

// 音乐列表 Provider
final musicListProvider =
    AsyncNotifierProvider<MusicListNotifier, List<MusicListItemBv>>(
      MusicListNotifier.new,
    );

// 当前播放的音乐索引 Provider
final currentPlayingIndexProvider = StateProvider<int?>((ref) => null);
