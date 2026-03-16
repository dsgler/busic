// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:busic/models/playlist_entry.dart';

part 'user_pref.g.dart';

enum MusicListMode {
  defaultMode('default'),
  favList('favList'),
  seasonsArchives('seasonsArchives');

  final String jsonValue;

  const MusicListMode(this.jsonValue);

  /// 将字符串转换为 MusicListMode 枚举
  static MusicListMode fromString(String value) {
    return MusicListMode.values.firstWhere(
      (e) => e.jsonValue == value,
      orElse: () => MusicListMode.defaultMode,
    );
  }
}

class UserPref {
  /// 当前选中的播放列表 key（如 "default", "favList:123456", "seasonsArchives:789"）
  String selectedPlaylistKey;

  /// 所有已添加的收藏夹列表，每条记录 {"id": "...", "name": "..."}
  List<Map<String, String>> favLists;

  /// 所有已添加的合辑列表，每条记录 {"id": "...", "name": "..."}
  List<Map<String, String>> seaLists;

  UserPref({
    this.selectedPlaylistKey = 'default',
    List<Map<String, String>>? favLists,
    List<Map<String, String>>? seaLists,
  })  : favLists = favLists ?? [],
        seaLists = seaLists ?? [];

  /// 当前选中的 PlaylistEntry（根据 key 还原）
  PlaylistEntry get selectedPlaylist {
    final key = selectedPlaylistKey;
    if (key == 'default') return PlaylistEntry.defaultPlaylist();
    final colonIdx = key.indexOf(':');
    if (colonIdx < 0) return PlaylistEntry.defaultPlaylist();
    final typeStr = key.substring(0, colonIdx);
    final id = key.substring(colonIdx + 1);
    final mode = MusicListMode.fromString(typeStr);
    String name = id;
    if (mode == MusicListMode.favList) {
      name = favLists.firstWhere(
        (e) => e['id'] == id,
        orElse: () => {'name': id},
      )['name']!;
    } else if (mode == MusicListMode.seasonsArchives) {
      name = seaLists.firstWhere(
        (e) => e['id'] == id,
        orElse: () => {'name': id},
      )['name']!;
    }
    return PlaylistEntry(type: mode, listId: id, name: name);
  }

  factory UserPref.fromRawJson(String str) =>
      UserPref.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserPref.fromJson(Map<String, dynamic> json) =>
      _$UserPrefFromJson(json);

  Map<String, dynamic> toJson() => _$UserPrefToJson(this);

  UserPref copyWith({
    String? selectedPlaylistKey,
    List<Map<String, String>>? favLists,
    List<Map<String, String>>? seaLists,
  }) {
    return UserPref(
      selectedPlaylistKey: selectedPlaylistKey ?? this.selectedPlaylistKey,
      favLists: favLists ?? List.of(this.favLists),
      seaLists: seaLists ?? List.of(this.seaLists),
    );
  }
}
