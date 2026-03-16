import 'dart:io';

import 'package:busic/consts/network.dart';
import 'package:busic/network/video_info.dart';
import 'package:busic/network/video_url.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'video_url_ret.dart';
import 'package:just_audio/just_audio.dart';

part 'music_list_item.g.dart';

class MusicListItemBv {
  final String bvid;
  final int cid;
  final String title;
  final String subTitle;
  final String artist;
  final String? coverUrl;
  /// 复合 key，如 "default", "favList:123456", "seasonsArchives:789"
  final String categoryKey;
  Audio? _audioObj;
  int fetchAudioTime;

  Future<Audio> getAudioObj() async {
    if (_audioObj != null &&
        DateTime.now().millisecondsSinceEpoch - fetchAudioTime <
            Duration(hours: 2).inMilliseconds) {
      return _audioObj!;
    }

    final o = (await getVideoUrl(bvid: bvid, cid: cid)).data.dash.audio[0];
    _audioObj = o;
    fetchAudioTime = DateTime.now().millisecondsSinceEpoch;
    return o;
  }

  MusicListItemBv({
    required this.bvid,
    this.cid = 0,
    required this.title,
    this.artist = '未知艺术家',
    this.subTitle = '',
    this.coverUrl,
    this.categoryKey = 'default',
    Audio? audioObj,
    this.fetchAudioTime = 0,
  }) : _audioObj = audioObj;

  static Future<List<MusicListItemBv>> fetchBv({
    required String bvid,
    int cid = 0,
    String categoryKey = 'default',
  }) async {
    final info = await getVideoInfo(bvid: bvid);

    return info.data.pages
        .map(
          (p) => MusicListItemBv(
            bvid: bvid,
            title: info.data.title,
            cid: p.cid,
            coverUrl: p.firstFrame,
            artist: info.data.owner.name,
            categoryKey: categoryKey,
            subTitle: p.pagePart,
          ),
        )
        .toList();
  }

  // 序列化：将对象转换为 JSON
  Map<String, dynamic> toJson() => _$MusicListItemBvToJson(this);

  // 反序列化：从 JSON 创建对象
  factory MusicListItemBv.fromJson(Map<String, dynamic> json) =>
      _$MusicListItemBvFromJson(json);

  Future<File> getCacheFile() async {
    return File(
      join(
        (await getApplicationCacheDirectory()).path,
        'music_cache',
        '$id.m4s',
      ),
    );
  }

  String get id =>
      '$bvid'
      '_'
      '$cid';

  bool get isSinglePage => subTitle == "" || title == subTitle;

  String get displayTitle => isSinglePage ? title : subTitle;
  String get displaySubTitle => isSinglePage ? artist : '$artist - $title';

  Future<AudioPlayer> generatePlayer() async {
    final player = AudioPlayer();
    final cacheFile = await getCacheFile();
    AudioSource audioSource;
    if (await cacheFile.exists()) {
      audioSource = AudioSource.uri(cacheFile.uri);
    } else {
      final audioObj = await getAudioObj();
      audioSource = LockCachingAudioSource(
        Uri.parse(audioObj.baseUrl),
        headers: {
          'User-Agent': ua,
          'referer': referer,
          // 'Cookie': cookieJar.
        },
        cacheFile: cacheFile,
      );
    }

    await player.setAudioSource(audioSource);

    return player;
  }
}
