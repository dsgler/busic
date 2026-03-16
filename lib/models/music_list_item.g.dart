// GENERATED CODE - DO NOT MODIFY BY HAND
// (Manually maintained — json_serializable not used for MusicListItemBv)

part of 'music_list_item.dart';

MusicListItemBv _$MusicListItemBvFromJson(Map<String, dynamic> json) {
  // 向前兼容：旧格式存储的是纯枚举值（如 "favList"），需要转为复合 key
  String resolveCategoryKey(String? raw) {
    if (raw == null || raw == 'default') return 'default';
    // 如果已经是复合 key 格式（包含 ':'），直接返回
    if (raw.contains(':')) return raw;
    // 旧格式：直接是枚举名，无法得知 id，降级为 default
    return 'default';
  }

  return MusicListItemBv(
    bvid: json['bvid'] as String,
    cid: (json['cid'] as num?)?.toInt() ?? 0,
    title: json['title'] as String,
    artist: json['artist'] as String? ?? '未知艺术家',
    subTitle: json['subTitle'] as String? ?? '',
    coverUrl: json['coverUrl'] as String?,
    categoryKey: resolveCategoryKey(json['categoryKey'] as String? ?? json['category'] as String?),
    fetchAudioTime: (json['fetchAudioTime'] as num?)?.toInt() ?? 0,
  );
}

Map<String, dynamic> _$MusicListItemBvToJson(MusicListItemBv instance) =>
    <String, dynamic>{
      'bvid': instance.bvid,
      'cid': instance.cid,
      'title': instance.title,
      'subTitle': instance.subTitle,
      'artist': instance.artist,
      'coverUrl': instance.coverUrl,
      'categoryKey': instance.categoryKey,
      'fetchAudioTime': instance.fetchAudioTime,
    };
