import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/music_list_item.dart';
import '../providers/music_list_provider.dart';
import '../network/video_url_ret.dart';

/// 初始化示例音乐数据
Future<void> initSampleMusicList(WidgetRef ref) async {
  final musicList = [
    MusicListItemBv(
      bvid: 'BV1xx411c7XD',
      cid: 1,
      title: '示例音乐 1',
      artist: '示例艺术家',
      audioObj: Audio(
        id: 80,
        baseUrl: 'https://www.chongfanmitu.com/chat/Sounds/test.mp3',
        backupUrl: [],
        bandwidth: 0,
        mimeType: 'audio/mp3',
        codecs: 'mp3',
        width: 0,
        height: 0,
        frameRate: '',
        sar: '',
        startWithSap: 0,
        segmentBase: SegmentBase(initialization: '', indexRange: ''),
        codecid: 0,
        audioBaseUrl: '',
        audioBackupUrl: [],
        audioMimeType: '',
        audioFrameRate: '',
        audioStartWithSap: 0,
        audioSegmentBase: SegmentBaseClass(indexRange: "", initialization: ""),
      ),
      coverUrl: null,
    ),
    MusicListItemBv(
      bvid: 'BV1xx411c7XD',
      cid: 1,
      title: '示例音乐 1',
      artist: '示例艺术家',
      audioObj: Audio(
        id: 80,
        baseUrl: 'https://www.chongfanmitu.com/chat/Sounds/test.mp3',
        backupUrl: [],
        bandwidth: 0,
        mimeType: 'audio/mp3',
        codecs: 'mp3',
        width: 0,
        height: 0,
        frameRate: '',
        sar: '',
        startWithSap: 0,
        segmentBase: SegmentBase(initialization: '', indexRange: ''),
        codecid: 0,
        audioBaseUrl: '',
        audioBackupUrl: [],
        audioMimeType: '',
        audioFrameRate: '',
        audioStartWithSap: 0,
        audioSegmentBase: SegmentBaseClass(indexRange: "", initialization: ""),
      ),
      coverUrl: null,
    ),
  ];

  await ref.read(musicListProvider.notifier).setList(musicList);
}
