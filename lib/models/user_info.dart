import 'dart:convert';

/// 用户信息模型
class UserInfo {
  final String username;
  final String avatarUrl;
  final bool isLoggedIn;

  const UserInfo({
    required this.username,
    required this.avatarUrl,
    this.isLoggedIn = false,
  });

  /// 默认用户（未登录状态）
  factory UserInfo.guest() {
    return const UserInfo(username: '游客', avatarUrl: '', isLoggedIn: false);
  }

  /// 从 JSON 解析
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      username: json['username'] as String? ?? '游客',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      isLoggedIn: json['isLoggedIn'] as bool? ?? false,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'avatarUrl': avatarUrl,
      'isLoggedIn': isLoggedIn,
    };
  }

  /// 转换为 JSON 字符串
  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// 从 JSON 字符串解析
  factory UserInfo.fromJsonString(String jsonString) {
    return UserInfo.fromJson(jsonDecode(jsonString));
  }

  /// 复制并修改部分字段
  UserInfo copyWith({String? username, String? avatarUrl, bool? isLoggedIn}) {
    return UserInfo(
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}
