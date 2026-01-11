import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_info.dart';

/// 用户信息持久化 key
const String _userInfoKey = 'user_info';

/// 用户信息 Notifier
class UserInfoNotifier extends Notifier<UserInfo> {
  UserInfoNotifier();

  @override
  UserInfo build() {
    _loadUserInfo();
    return UserInfo.guest();
  }

  /// 从本地加载用户信息
  Future<void> _loadUserInfo() async {
    final prefs = ref.read(sharedPreferencesProvider);

    try {
      final jsonString = prefs.getString(_userInfoKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        state = UserInfo.fromJsonString(jsonString);
      }
    } catch (e) {
      print('加载用户信息失败: $e');
      state = UserInfo.guest();
    }
  }

  /// 保存用户信息到本地
  Future<void> _saveUserInfo() async {
    final prefs = ref.read(sharedPreferencesProvider);

    try {
      await prefs.setString(_userInfoKey, state.toJsonString());
    } catch (e) {
      print('保存用户信息失败: $e');
    }
  }

  /// 更新用户信息
  Future<void> updateUserInfo({
    String? username,
    String? avatarUrl,
    bool? isLoggedIn,
  }) async {
    state = state.copyWith(
      username: username,
      avatarUrl: avatarUrl,
      isLoggedIn: isLoggedIn,
    );
    await _saveUserInfo();
  }

  /// 设置用户登录状态
  Future<void> login({
    required String username,
    required String avatarUrl,
  }) async {
    state = UserInfo(
      username: username,
      avatarUrl: avatarUrl,
      isLoggedIn: true,
    );
    await _saveUserInfo();
  }

  /// 退出登录
  Future<void> logout() async {
    final prefs = ref.read(sharedPreferencesProvider);

    state = UserInfo.guest();
    await prefs.remove(_userInfoKey);
  }

  /// 重新加载用户信息
  Future<void> reload() async {
    await _loadUserInfo();
  }
}

/// SharedPreferences Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences 未初始化');
});

/// 用户信息 Provider
final userInfoProvider = NotifierProvider<UserInfoNotifier, UserInfo>(() {
  return UserInfoNotifier();
});
