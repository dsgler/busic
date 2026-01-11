import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/experimental/persist.dart';
import '../models/music_list_item.dart';
import 'music_list_storage.dart';
import 'audio_player_provider.dart';
import 'dart:math';

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

class CurrentPlayingIndexNotifier extends Notifier<int?> {
  @override
  int? build() {
    return null;
  }

  void setIndex(int? i) async {
    if (stateOrNull == i) {
      ref.read(audioPlayerManagerProvider)?.seek(null);
      return;
    }

    state = i;
    ref.read(audioPlayerManagerProvider.notifier).setPlayer(null);

    final musicListAsync = ref.read(musicListProvider);
    musicListAsync.whenData((musicList) async {
      ref
          .read(audioPlayerManagerProvider.notifier)
          .setPlayer(await musicList[i!].generatePlayer());
    });
  }

  // 播放下一首
  void playNext() {
    final musicListAsync = ref.read(musicListProvider);
    final currentIndex = state;
    final playMode = ref.read(playModeNotifierProvider);

    if (!musicListAsync.hasValue || musicListAsync.value!.isEmpty) {
      return;
    }

    final musicList = musicListAsync.value!;
    final listLength = musicList.length;

    int? nextIndex;

    if (playMode == PlayMode.random) {
      // 随机播放模式
      final random = Random();
      // 生成一个与当前索引不同的随机索引
      do {
        nextIndex = random.nextInt(listLength);
      } while (nextIndex == currentIndex && listLength > 1);
    } else {
      // 顺序播放模式
      if (currentIndex == null) {
        nextIndex = 0;
      } else {
        nextIndex = (currentIndex + 1) % listLength;
      }
    }

    setIndex(nextIndex);
  }

  // 播放上一首
  void playPrevious() {
    final musicListAsync = ref.read(musicListProvider);
    final currentIndex = state;
    final playMode = ref.read(playModeNotifierProvider);

    if (!musicListAsync.hasValue || musicListAsync.value!.isEmpty) {
      return;
    }

    final musicList = musicListAsync.value!;
    final listLength = musicList.length;

    int? prevIndex;

    if (playMode == PlayMode.random) {
      // 随机播放模式
      final random = Random();
      // 生成一个与当前索引不同的随机索引
      do {
        prevIndex = random.nextInt(listLength);
      } while (prevIndex == currentIndex && listLength > 1);
    } else {
      // 顺序播放模式
      if (currentIndex == null) {
        prevIndex = 0;
      } else {
        prevIndex = (currentIndex - 1 + listLength) % listLength;
      }
    }

    setIndex(prevIndex);
  }
}

final currentPlayingIndexProvider =
    NotifierProvider<CurrentPlayingIndexNotifier, int?>(
      CurrentPlayingIndexNotifier.new,
    );

// 切换播放模式
void togglePlayMode(WidgetRef ref) {
  final currentMode = ref.read(playModeNotifierProvider);
  final newMode = currentMode == PlayMode.sequential
      ? PlayMode.random
      : PlayMode.sequential;
  ref.read(playModeNotifierProvider.notifier).setMode(newMode);
}
