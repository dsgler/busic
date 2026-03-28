import 'dart:convert';

import 'package:busic/models/playing_list.dart';
import 'package:busic/network/fetch_fav_list.dart';
import 'package:busic/network/fetch_sea_list.dart';
import 'package:busic/providers/storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/music_list_item.dart';
import 'music_database.dart';
import 'audio_player_provider.dart';
import 'pref_provider.dart';
import 'dart:math';
import 'package:flutter_riverpod/experimental/persist.dart';

// 数据库实例 Provider
final musicDatabaseProvider = Provider<MusicDatabase>((ref) {
  final db = MusicDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// 音乐列表 AsyncNotifier（直接操作数据库）
class MusicListNotifier extends AsyncNotifier<List<MusicListItemBv>> {
  @override
  Future<List<MusicListItemBv>> build() async {
    final db = ref.watch(musicDatabaseProvider);

    final userPrefAsync = ref.watch(UserPrefProvider);
    final categoryKey = userPrefAsync.hasValue
        ? userPrefAsync.requireValue.selectedPlaylistKey
        : 'default';

    return await db.getMusicList(categoryKey: categoryKey);
  }

  Future<void> syncFavList(
    String listId, {
    void Function(int progress)? onProgress,
  }) async {
    final categoryKey = 'favList:$listId';
    final list = await fetchFavList(
      listId,
      categoryKey: categoryKey,
      onProgress: onProgress,
    );
    await clearList(categoryKey: categoryKey);
    for (var a in list) {
      await addMusic(a);
    }
  }

  Future<void> syncSeaList(
    String listId, {
    void Function(int progress)? onProgress,
  }) async {
    final categoryKey = 'seasonsArchives:$listId';
    final list = await fetchSeaList(
      listId,
      categoryKey: categoryKey,
      onProgress: onProgress,
    );
    await clearList(categoryKey: categoryKey);
    for (var a in list) {
      await addMusic(a);
    }
  }

  // 添加音乐到列表
  Future<void> addMusic(MusicListItemBv music) async {
    final db = ref.read(musicDatabaseProvider);
    await db.addMusicItem(music);
    state = AsyncValue.data([...state.value!, music]);
  }

  Future<void> removeMusic(int index) async {
    final categoryKey = ref
        .read(UserPrefProvider)
        .requireValue
        .selectedPlaylistKey;
    final currentList = state.value!;
    if (index < 0 || index >= currentList.length) return;

    final db = ref.read(musicDatabaseProvider);
    final newList = [
      ...currentList.sublist(0, index),
      ...currentList.sublist(index + 1),
    ];
    await db.saveMusicList(newList, categoryKey: categoryKey);
    state = AsyncValue.data(newList);
  }

  // 删除音乐（根据 bvid + cid）
  Future<void> removeMusicByBvCid(String bvid, int cid) async {
    final categoryKey = ref
        .read(UserPrefProvider)
        .requireValue
        .selectedPlaylistKey;
    final currentList = state.value!;

    final db = ref.read(musicDatabaseProvider);
    final newList = currentList
        .where((e) => e.bvid != bvid || e.cid != cid)
        .toList();
    await db.saveMusicList(newList, categoryKey: categoryKey);
    state = AsyncValue.data(newList);
  }

  // 清空指定 categoryKey 的列表（默认为当前选中列表）
  Future<void> clearList({String? categoryKey}) async {
    final db = ref.read(musicDatabaseProvider);
    final key =
        categoryKey ??
        ref.read(UserPrefProvider).requireValue.selectedPlaylistKey;
    await db.deleteMusicListByCategory(key);
    state = const AsyncValue.data([]);
  }
}

// 音乐列表 Provider
final musicListProvider =
    AsyncNotifierProvider<MusicListNotifier, List<MusicListItemBv>>(
      MusicListNotifier.new,
    );

// 播放列表快照 Notifier（用于保存点击播放时的列表副本）
class PlayingListSnapshotNotifier extends AsyncNotifier<PlayingList> {
  static final StoreKey = 'PlayingListSnapshot1335';

  @override
  Future<PlayingList> build() async {
    await persist(
      ref.watch(storageProvider.future),
      key: StoreKey,
      encode: (state) => jsonEncode(state.toJson()),
      decode: (encoded) {
        final ret = PlayingList.fromJson(jsonDecode(encoded));
        if (ret.curIndex != null) {
          if (ret.curIndex! <= 0 || ret.curIndex! >= ret.curList.length) {
            ret.curIndex = null;
          }
        }
        return ret;
      },
      options: const StorageOptions(
        // Instead of "unsafe_forever", you can alternatively specify a Duration.
        cacheTime: StorageCacheTime.unsafe_forever,
      ),
    ).future;

    return state.value ?? PlayingList(curIndex: null, curList: []);
  }

  void clear() {
    state = AsyncData(PlayingList(curIndex: null, curList: []));
  }

  void setIndex(int? i, {List<MusicListItemBv>? musicListSnap}) async {
    final p = ref.read(audioPlayerManagerProvider);
    if (state.value?.curIndex == i && p != null) {
      p.seek(null);
      return;
    }

    if (musicListSnap == null) {
      state = AsyncData(state.requireValue.copyWith(curIndex: i));
    } else {
      state = AsyncData(PlayingList(curIndex: i, curList: musicListSnap));
    }

    ref.read(audioPlayerManagerProvider.notifier).setPlayer(null);

    final list = state.requireValue.curList;

    if (i != null) {
      ref
          .read(audioPlayerManagerProvider.notifier)
          .setPlayer(await list[i].generatePlayer());
    }
  }

  String? getCurId() {
    final list = state.value?.curList;

    final i = state.value?.curIndex;
    if (list == null || i == null) {
      return null;
    }

    return list[i].id;
  }

  MusicListItemBv? getCurMusic() {
    final v = state.value;
    if (v == null || v.curIndex == null) return null;
    return v.curList[v.curIndex!];
  }

  // 播放下一首
  void playNext() {
    // 使用播放列表快照而不是实时列表
    final playingList = state.requireValue.curList;
    final currentIndex = state.requireValue.curIndex!;
    final playMode = ref.read(playModeNotifierProvider);

    if (playingList.isEmpty) {
      return;
    }

    final listLength = playingList.length;

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
      nextIndex = (currentIndex + 1) % listLength;
    }

    setIndex(nextIndex);
  }

  // 播放上一首
  void playPrevious() {
    // 使用播放列表快照而不是实时列表
    final playingList = state.requireValue.curList;
    final currentIndex = state.requireValue.curIndex!;
    final playMode = ref.read(playModeNotifierProvider);

    if (playingList.isEmpty) {
      return;
    }

    final listLength = playingList.length;

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
      prevIndex = (currentIndex - 1 + listLength) % listLength;
    }

    setIndex(prevIndex);
  }
}

// 播放列表快照 Provider
final playingListSnapshotProvider =
    AsyncNotifierProvider<PlayingListSnapshotNotifier, PlayingList>(
      PlayingListSnapshotNotifier.new,
    );

// 切换播放模式
void togglePlayMode(WidgetRef ref) {
  final currentMode = ref.read(playModeNotifierProvider);
  final newMode = currentMode == PlayMode.sequential
      ? PlayMode.random
      : PlayMode.sequential;
  ref.read(playModeNotifierProvider.notifier).setMode(newMode);
}
