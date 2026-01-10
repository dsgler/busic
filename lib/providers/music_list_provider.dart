import 'package:busic/consts/network.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../network/video_url_ret.dart';
import 'package:just_audio/just_audio.dart';

class MusicListItemBv {
  final String bvid;
  final int cid;
  final String title;
  final String artist;
  final String? coverUrl;
  Audio audioObj;

  MusicListItemBv({
    required this.bvid,
    this.cid = 0,
    required this.audioObj,
    required this.title,
    this.artist = '未知艺术家',
    this.coverUrl,
  });

  Future<AudioPlayer> generatePlayer() async {
    final player = AudioPlayer();
    await player.setUrl(
      audioObj.baseUrl,
      headers: {
        'User-Agent': ua,
        'referer': referer,
        // 'Cookie': cookieJar.
      },
    );

    return player;
  }
}

// 音乐列表 StateNotifier
class MusicListNotifier extends StateNotifier<List<MusicListItemBv>> {
  MusicListNotifier() : super([]);

  // 添加音乐到列表
  void addMusic(MusicListItemBv music) {
    state = [...state, music];
  }

  // 删除音乐
  void removeMusic(int index) {
    state = [...state.sublist(0, index), ...state.sublist(index + 1)];
  }

  // 清空列表
  void clearList() {
    state = [];
  }

  // 设置整个列表
  void setList(List<MusicListItemBv> list) {
    state = list;
  }
}

// 音乐列表 Provider
final musicListProvider =
    StateNotifierProvider<MusicListNotifier, List<MusicListItemBv>>((ref) {
      return MusicListNotifier();
    });

// 当前播放的音乐索引 Provider
final currentPlayingIndexProvider = StateProvider<int?>((ref) => null);
