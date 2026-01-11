import 'package:busic/models/nav_ret.dart';
import 'package:busic/models/request_qr_ret.dart';
import 'package:busic/models/request_signin_ret.dart';
import 'package:busic/models/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/user_info_provider.dart';
import '../network/request.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// 用户信息页面
class UserInfoPage extends ConsumerWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoAsync = ref.watch(userInfoProvider);
    final userInfo = switch (userInfoAsync) {
      AsyncValue(:final value, hasValue: true) => value!,
      _ => UserInfo.guest(),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('用户信息'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // 用户头像
              _buildAvatar(userInfo.avatarUrl),
              const SizedBox(height: 24),
              // 用户名
              Text(
                userInfo.username,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // 登录状态
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: userInfo.isLoggedIn
                      ? Colors.green[50]
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: userInfo.isLoggedIn ? Colors.green : Colors.grey,
                    width: 1,
                  ),
                ),
                child: Text(
                  userInfo.isLoggedIn ? '已登录' : '未登录',
                  style: TextStyle(
                    fontSize: 12,
                    color: userInfo.isLoggedIn
                        ? Colors.green[700]
                        : Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              // 获取登录二维码按钮
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final info = await NavRet.fetch();
                      if (info.code != 0) {
                        throw info.message;
                      } else {
                        await ref
                            .read(userInfoProvider.notifier)
                            .updateUserInfo(
                              username: info.data.uname,
                              avatarUrl: info.data.face,
                              isLoggedIn: true,
                            );

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: const Text('✅已登录')));
                      }
                    } catch (e) {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('错误:$e')));
                    }
                  },
                  icon: const Icon(Icons.recycling),
                  label: Text('获取登录状态', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    _handleGetQRCode(context, ref);
                  },
                  icon: const Icon(Icons.qr_code_2),
                  label: Text('获取登录二维码', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 退出登录按钮（仅在已登录时显示）
              if (userInfo.isLoggedIn)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () => _handleLogout(context, ref),
                    icon: const Icon(Icons.logout),
                    label: const Text('退出登录', style: TextStyle(fontSize: 16)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              // 用户ID（如果已登录）
              if (userInfo.isLoggedIn && userInfo.username.isNotEmpty) ...[
                const Divider(),
                const SizedBox(height: 16),
                _buildInfoRow('用户ID', userInfo.username),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 构建头像组件
  Widget _buildAvatar(String avatarUrl) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[300]!, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: avatarUrl.isEmpty
            ? Container(
                color: Colors.grey[200],
                child: Icon(Icons.person, size: 60, color: Colors.grey[400]),
              )
            : CachedNetworkImage(
                imageUrl: avatarUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.person, size: 60, color: Colors.grey[400]),
                ),
              ),
      ),
    );
  }

  /// 构建信息行
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  /// 处理获取二维码操作
  Future<void> _handleGetQRCode(BuildContext context, WidgetRef ref) async {
    final r = await dio.get(
      'https://passport.bilibili.com/x/passport-login/web/qrcode/generate',
    );
    final q = RequestQrRet.fromJson(r.data);

    if (!context.mounted) return;

    // TODO: 实现获取登录二维码的逻辑
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('登录二维码'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(Icons.qr_code_2, size: 80, color: Colors.grey),
                    QrImageView(data: q.data.url, size: 150),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
          TextButton(
            onPressed: () async {
              final r = await dio.get(
                'https://passport.bilibili.com/x/passport-login/web/qrcode/poll',
                queryParameters: {'qrcode_key': q.data.qrcodeKey},
              );
              var errMessage = '';
              final result = RequestSignInRet.fromJson(r.data);
              if (result.data.code != 0) {
                errMessage = result.message;
              } else {
                final info = await NavRet.fetch();

                if (info.code != 0) {
                  errMessage = info.message;
                } else {
                  await ref
                      .read(userInfoProvider.notifier)
                      .login(
                        username: info.data.uname,
                        avatarUrl: info.data.face,
                      );
                }
              }

              if (context.mounted) {
                if (errMessage != '') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("确定"),
                        ),
                      ],
                      title: Text('出错了'),
                      content: Text(errMessage),
                    ),
                  );
                  return;
                }

                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('登录成功！')));
              }
            },
            child: const Text('确认已登录'),
          ),
        ],
      ),
    );
  }

  /// 处理退出登录操作
  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认退出'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确定', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(userInfoProvider.notifier).logout();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('已退出登录')));
      }
    }
  }
}
