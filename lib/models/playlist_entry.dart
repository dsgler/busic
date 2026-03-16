import 'package:busic/models/user_pref.dart';

/// 代表一个播放列表条目
/// defaultMode: key = "default", listId = ""
/// favList:     key = "favList:123456", listId = "123456"
/// seasonsArchives: key = "seasonsArchives:789", listId = "789"
class PlaylistEntry {
  final MusicListMode type;
  final String listId;
  final String name;

  const PlaylistEntry({
    required this.type,
    required this.listId,
    required this.name,
  });

  /// 复合 key，用于标识唯一的播放列表
  String get key {
    if (type == MusicListMode.defaultMode) return 'default';
    return '${type.jsonValue}:$listId';
  }

  /// 从复合 key 还原 PlaylistEntry（name 需从外部提供，默认与 listId 相同）
  factory PlaylistEntry.fromKey(String key, {String? name}) {
    if (key == 'default') {
      return PlaylistEntry(
        type: MusicListMode.defaultMode,
        listId: '',
        name: name ?? '我的音乐',
      );
    }
    final colonIdx = key.indexOf(':');
    if (colonIdx < 0) {
      return PlaylistEntry.defaultPlaylist();
    }
    final typeStr = key.substring(0, colonIdx);
    final id = key.substring(colonIdx + 1);
    final mode = MusicListMode.fromString(typeStr);
    return PlaylistEntry(type: mode, listId: id, name: name ?? id);
  }

  factory PlaylistEntry.defaultPlaylist() {
    return const PlaylistEntry(
      type: MusicListMode.defaultMode,
      listId: '',
      name: '我的音乐',
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PlaylistEntry && other.key == key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() => 'PlaylistEntry($key, "$name")';
}
