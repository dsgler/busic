// GENERATED CODE - DO NOT MODIFY BY HAND
// (Manually maintained — json_serializable not used for UserPref)

part of 'user_pref.dart';

UserPref _$UserPrefFromJson(Map<String, dynamic> json) {
  // 向前兼容旧格式（musicListMode + favListId + seaListId）
  if (json.containsKey('musicListMode')) {
    final oldMode = json['musicListMode'] as String? ?? 'default';
    final favListId = json['favListId'] as String? ?? '';
    final seaListId = json['seaListId'] as String? ?? '';

    String selectedKey = 'default';
    final favLists = <Map<String, String>>[];
    final seaLists = <Map<String, String>>[];

    if (oldMode == 'favList' && favListId.isNotEmpty) {
      selectedKey = 'favList:$favListId';
      favLists.add({'id': favListId, 'name': favListId});
    } else if (oldMode == 'seasonsArchives' && seaListId.isNotEmpty) {
      selectedKey = 'seasonsArchives:$seaListId';
      seaLists.add({'id': seaListId, 'name': seaListId});
    }
    if (favListId.isNotEmpty &&
        !favLists.any((e) => e['id'] == favListId)) {
      favLists.add({'id': favListId, 'name': favListId});
    }
    if (seaListId.isNotEmpty &&
        !seaLists.any((e) => e['id'] == seaListId)) {
      seaLists.add({'id': seaListId, 'name': seaListId});
    }
    return UserPref(
      selectedPlaylistKey: selectedKey,
      favLists: favLists,
      seaLists: seaLists,
    );
  }

  return UserPref(
    selectedPlaylistKey:
        json['selectedPlaylistKey'] as String? ?? 'default',
    favLists: (json['favLists'] as List<dynamic>? ?? [])
        .map(
          (e) => Map<String, String>.from(e as Map),
        )
        .toList(),
    seaLists: (json['seaLists'] as List<dynamic>? ?? [])
        .map(
          (e) => Map<String, String>.from(e as Map),
        )
        .toList(),
  );
}

Map<String, dynamic> _$UserPrefToJson(UserPref instance) => <String, dynamic>{
      'selectedPlaylistKey': instance.selectedPlaylistKey,
      'favLists': instance.favLists,
      'seaLists': instance.seaLists,
    };
