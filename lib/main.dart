import 'dart:io';

import 'package:busic/network/request.dart';
import 'package:busic/pages/music_list_page.dart';
import 'package:busic/providers/user_info_provider.dart';
import 'package:busic/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
// import './network/test.dart';

void main() async {
  // 使用全局错误处理器运行应用
  // 所有初始化必须在同一个Zone中完成
  // GlobalErrorHandler.runAppWithErrorHandler(() async {
  //   // 初始化Dio
  //   await initDio();
  //   // 可以添加其他初始化操作
  //   // await someOtherInit();

  //   // 返回要运行的应用Widget
  //   return const ProviderScope(child: MyApp());
  // });

  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    // 初始化 sqflite_common_ffi
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    JustAudioMediaKit.ensureInitialized();
  }

  // 初始化 SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  await initDio();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 将context传递给错误处理器
    final _ = ref.watch(themeConfigProvider);
    final themeNotifier = ref.read(themeConfigProvider.notifier);

    return MaterialApp(
      title: 'Busic - 音乐播放器',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeNotifier.getSeedColor(),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeNotifier.getSeedColor(),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeNotifier.getThemeMode(),
      home: const MusicListPage(),
    );
  }
}
