// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'user_pref.g.dart';

enum MusicListMode {
  @JsonValue('default')
  defaultMode('default'),
  @JsonValue('favList')
  favList('favList'),
  @JsonValue('seasonsArchives')
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

@JsonSerializable()
class UserPref {
  MusicListMode musicListMode;

  UserPref({this.musicListMode = MusicListMode.defaultMode});

  factory UserPref.fromRawJson(String str) =>
      UserPref.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserPref.fromJson(Map<String, dynamic> json) =>
      _$UserPrefFromJson(json);

  Map<String, dynamic> toJson() => _$UserPrefToJson(this);

  UserPref copyWith({MusicListMode? musicListMode}) {
    return UserPref(musicListMode: musicListMode ?? this.musicListMode);
  }
}
