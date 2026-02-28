// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playing_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayingList _$PlayingListFromJson(Map<String, dynamic> json) => PlayingList(
  curIndex: (json['curIndex'] as num?)?.toInt(),
  curList: (json['curList'] as List<dynamic>)
      .map((e) => MusicListItemBv.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PlayingListToJson(PlayingList instance) =>
    <String, dynamic>{
      'curIndex': instance.curIndex,
      'curList': instance.curList,
    };
