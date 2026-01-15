// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_pref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPref _$UserPrefFromJson(Map<String, dynamic> json) => UserPref(
  musicListMode:
      $enumDecodeNullable(_$MusicListModeEnumMap, json['musicListMode']) ??
      MusicListMode.defaultMode,
  favListId: json['favListId'] as String? ?? "",
  seaListId: json['seaListId'] as String? ?? "",
);

Map<String, dynamic> _$UserPrefToJson(UserPref instance) => <String, dynamic>{
  'musicListMode': _$MusicListModeEnumMap[instance.musicListMode]!,
  'favListId': instance.favListId,
  'seaListId': instance.seaListId,
};

const _$MusicListModeEnumMap = {
  MusicListMode.defaultMode: 'default',
  MusicListMode.favList: 'favList',
  MusicListMode.seasonsArchives: 'seasonsArchives',
};
