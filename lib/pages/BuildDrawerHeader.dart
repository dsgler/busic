import 'package:busic/models/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_info_provider.dart';
import 'user_info_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget BuildDrawerHeader(BuildContext context, WidgetRef ref) {
  final userInfoAsync = ref.watch(userInfoProvider);
  final userInfo = switch (userInfoAsync) {
    AsyncValue(:final value, hasValue: true) => value!,
    _ => UserInfo.guest(),
  };

  return UserAccountsDrawerHeader(
    margin: EdgeInsets.all(0),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primaryContainer,
    ),
    currentAccountPicture: CircleAvatar(
      child: userInfo.avatarUrl.isEmpty
          ? Icon(
              Icons.person,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            )
          : ClipOval(
              child: CachedNetworkImage(
                imageUrl: userInfo.avatarUrl,
                fit: BoxFit.cover,
                width: 72,
                height: 72,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
    ),
    accountName: Text(
      userInfo.username,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
    accountEmail: Text(
      userInfo.isLoggedIn ? '已登录' : '点击登录',
      style: TextStyle(
        color: Theme.of(
          context,
        ).colorScheme.onPrimaryContainer.withOpacity(0.8),
        fontSize: 14,
      ),
    ),
    onDetailsPressed: () {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserInfoPage()),
      );
    },
  );
}
