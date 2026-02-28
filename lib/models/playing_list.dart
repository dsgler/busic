// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:busic/models/music_list_item.dart';

part 'playing_list.g.dart';

@JsonSerializable()
class PlayingList {
  int? curIndex;
  List<MusicListItemBv> curList;

  PlayingList({required this.curIndex, required this.curList});

  // 序列化：将对象转换为 JSON
  Map<String, dynamic> toJson() => _$PlayingListToJson(this);

  // 反序列化：从 JSON 创建对象
  factory PlayingList.fromJson(Map<String, dynamic> json) =>
      _$PlayingListFromJson(json);

  PlayingList copyWith({int? curIndex, List<MusicListItemBv>? curList}) {
    return PlayingList(
      curIndex: curIndex ?? this.curIndex,
      curList: curList ?? this.curList,
    );
  }
}
