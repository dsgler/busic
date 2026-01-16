// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicListItemBv _$MusicListItemBvFromJson(Map<String, dynamic> json) =>
    MusicListItemBv(
      bvid: json['bvid'] as String,
      cid: (json['cid'] as num?)?.toInt() ?? 0,
      title: json['title'] as String,
      artist: json['artist'] as String? ?? '未知艺术家',
      subTitle: json['subTitle'] as String? ?? '',
      coverUrl: json['coverUrl'] as String?,
      category:
          $enumDecodeNullable(_$MusicListModeEnumMap, json['category']) ??
          MusicListMode.defaultMode,
      fetchAudioTime: (json['fetchAudioTime'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MusicListItemBvToJson(MusicListItemBv instance) =>
    <String, dynamic>{
      'bvid': instance.bvid,
      'cid': instance.cid,
      'title': instance.title,
      'subTitle': instance.subTitle,
      'artist': instance.artist,
      'coverUrl': instance.coverUrl,
      'category': _$MusicListModeEnumMap[instance.category]!,
      'fetchAudioTime': instance.fetchAudioTime,
    };

const _$MusicListModeEnumMap = {
  MusicListMode.defaultMode: 'default',
  MusicListMode.favList: 'favList',
  MusicListMode.seasonsArchives: 'seasonsArchives',
};
