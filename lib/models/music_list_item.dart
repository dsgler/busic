import 'dart:io';

import 'package:busic/consts/network.dart';
import 'package:busic/network/video_info.dart';
import 'package:busic/network/video_url.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../network/video_url_ret.dart';
import 'package:just_audio/just_audio.dart';

class MusicListItemBv {
  final String bvid;
  final int cid;
  final String title;
  final String artist;
  final String? coverUrl;
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
    return o;
  }

  MusicListItemBv({
    required this.bvid,
    this.cid = 0,
    required this.title,
    this.artist = '未知艺术家',
    this.coverUrl,
    Audio? audioObj,
    this.fetchAudioTime = 0,
  }) : _audioObj = audioObj;

  static Future<List<MusicListItemBv>> fetchBv({
    required String bvid,
    int cid = 0,
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
          ),
        )
        .toList();
  }

  // 序列化：将对象转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'bvid': bvid,
      'cid': cid,
      'title': title,
      'artist': artist,
      'coverUrl': coverUrl,
      // 'audioObj': audioObj.toJson(),
    };
  }

  // 反序列化：从 JSON 创建对象
  factory MusicListItemBv.fromJson(Map<String, dynamic> json) {
    return MusicListItemBv(
      bvid: json['bvid'] as String,
      cid: json['cid'] as int,
      title: json['title'] as String,
      artist: json['artist'] as String? ?? '未知艺术家',
      coverUrl: json['coverUrl'] as String?,
      audioObj: Audio.fromJson(json['audioObj'] as Map<String, dynamic>),
    );
  }

  Future<AudioPlayer> generatePlayer() async {
    final player = AudioPlayer();
    final audioObj = await getAudioObj();
    final audioSource = LockCachingAudioSource(
      Uri.parse(audioObj.baseUrl),
      headers: {
        'User-Agent': ua,
        'referer': referer,
        // 'Cookie': cookieJar.
      },
      cacheFile: File(
        join(
          (await getApplicationCacheDirectory()).path,
          'music_cache',
          '$bvid-$cid.m4s',
        ),
      ),
    );
    await player.setAudioSource(audioSource);

    return player;
  }
}
