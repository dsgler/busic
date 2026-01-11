import 'package:busic/network/request.dart';
import 'package:busic/providers/storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_info.dart';
import 'package:flutter_riverpod/experimental/persist.dart';

/// 用户信息持久化 key
const String _userInfoKey = 'user_info1834';

/// 用户信息 Notifier
class UserInfoNotifier extends AsyncNotifier<UserInfo> {
  UserInfoNotifier();

  @override
  Future<UserInfo> build() async {
    await persist(
      ref.watch(storageProvider.future),
      key: _userInfoKey,
      encode: (state) {
        return state.toJsonString();
      },
      decode: (jsonString) {
        return UserInfo.fromJsonString(jsonString);
      },
      options: StorageOptions(cacheTime: StorageCacheTime.unsafe_forever),
    ).future;

    return state.hasValue ? state.requireValue : UserInfo.guest();
  }

  /// 更新用户信息
  Future<void> updateUserInfo({
    String? username,
    String? avatarUrl,
    bool? isLoggedIn,
  }) async {
    state = AsyncData(
      state.requireValue.copyWith(
        username: username,
        avatarUrl: avatarUrl,
        isLoggedIn: isLoggedIn,
      ),
    );
  }

  /// 设置用户登录状态
  Future<void> login({
    required String username,
    required String avatarUrl,
  }) async {
    state = AsyncData(
      UserInfo(username: username, avatarUrl: avatarUrl, isLoggedIn: true),
    );
  }

  /// 退出登录
  Future<void> logout() async {
    state = AsyncData(UserInfo.guest());
    cookieJar.deleteAll();
  }
}

/// SharedPreferences Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences 未初始化');
});

/// 用户信息 Provider
final userInfoProvider = AsyncNotifierProvider<UserInfoNotifier, UserInfo>(() {
  return UserInfoNotifier();
});
