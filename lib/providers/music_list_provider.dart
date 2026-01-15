import 'package:busic/models/user_pref.dart';
import 'package:busic/network/fetch_fav_list.dart';
import 'package:busic/network/fetch_sea_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/music_list_item.dart';
import 'music_database.dart';
import 'audio_player_provider.dart';
import 'pref_provider.dart';
import 'dart:math';

class MusicListState {
  List<MusicListItemBv> list;
  MusicListMode mode;

  MusicListState({required this.list, this.mode = MusicListMode.defaultMode});
}

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

    // 监听 UserPrefProvider，根据 musicListMode.jsonValue 过滤 category
    final userPrefAsync = ref.watch(UserPrefProvider);
    final category = userPrefAsync.hasValue
        ? userPrefAsync.requireValue.musicListMode
        : MusicListMode.defaultMode;

    return await db.getMusicList(category: category);
  }

  Future<void> syncFavList({void Function(int progress)? onProgress}) async {
    final mid = ref.read(UserPrefProvider).requireValue.favListId;
    if (mid == '') {
      throw 'favListId 不能为空';
    }

    await clearList(category: MusicListMode.favList);

    await fetchFavList(mid, onProgress: onProgress).then((list) {
      for (var a in list) {
        addMusic(a);
      }
    });
  }

  Future<void> syncSeaList({void Function(int progress)? onProgress}) async {
    final mid = ref.read(UserPrefProvider).requireValue.seaListId;
    if (mid == '') {
      throw 'seaListId 不能为空';
    }

    await clearList(category: MusicListMode.seasonsArchives);

    await fetchSeaList(mid, onProgress: onProgress).then((list) {
      for (var a in list) {
        addMusic(a);
      }
    });
  }

  // 添加音乐到列表
  Future<void> addMusic(MusicListItemBv music) async {
    final db = ref.read(musicDatabaseProvider);
    await db.addMusicItem(music);
    // 刷新状态
    state = AsyncValue.data([...state.value!, music]);
  }

  // 删除音乐（根据索引）
  Future<void> removeMusic(int index) async {
    final currentList = state.value!;
    if (index < 0 || index >= currentList.length) return;

    final db = ref.read(musicDatabaseProvider);
    // 重新保存整个列表（简单方式）
    final newList = [
      ...currentList.sublist(0, index),
      ...currentList.sublist(index + 1),
    ];
    await db.saveMusicList(newList);
    state = AsyncValue.data(newList);
  }

  // 清空当前分类的列表
  Future<void> clearList({MusicListMode? category}) async {
    final db = ref.read(musicDatabaseProvider);
    final userPrefAsync = ref.read(UserPrefProvider);
    final currentCategory = userPrefAsync.requireValue.musicListMode;
    category ??= currentCategory;

    // 在数据库中删除当前分类的所有音乐
    await db.deleteMusicListByCategory(category);
    state = const AsyncValue.data([]);
  }

  // 设置整个列表
  Future<void> setList(List<MusicListItemBv> list) async {
    final db = ref.read(musicDatabaseProvider);
    await db.saveMusicList(list);
    state = AsyncValue.data(list);
  }

  // 根据类别获取音乐列表
  Future<List<MusicListItemBv>> getMusicListByCategory(
    MusicListMode category,
  ) async {
    final db = ref.read(musicDatabaseProvider);
    return await db.getMusicListByCategory(category);
  }

  // 获取所有类别
  Future<List<MusicListMode>> getCategories() async {
    final db = ref.read(musicDatabaseProvider);
    return await db.getCategories();
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
