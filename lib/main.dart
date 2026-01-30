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
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
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

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
  }

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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp>
    with TrayListener, WindowListener {
  static const _trayIconPath = 'windows/runner/resources/app_icon.ico';
  bool _trayEnabled = false;

  @override
  void initState() {
    super.initState();

    if (Platform.isWindows) {
      _trayEnabled = true;
      trayManager.addListener(this);
      windowManager.addListener(this);
      _initTray();
      _initWindowBehavior();
    }
  }

  Future<void> _initTray() async {
    await trayManager.setIcon(_trayIconPath);
    await trayManager.setToolTip('Busic');

    final menu = Menu(
      items: [
        MenuItem(key: 'show', label: '打开'),
        MenuItem.separator(),
        MenuItem(key: 'quit', label: '退出'),
      ],
    );

    await trayManager.setContextMenu(menu);
  }

  Future<void> _initWindowBehavior() async {
    await windowManager.setPreventClose(true);
  }

  @override
  void dispose() {
    if (_trayEnabled) {
      trayManager.removeListener(this);
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  @override
  void onTrayIconMouseDown() {
    windowManager.show();
    windowManager.focus();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'show') {
      windowManager.show();
      windowManager.focus();
      return;
    }
    if (menuItem.key == 'quit') {
      exit(0);
    }
  }

  @override
  void onWindowClose() async {
    await windowManager.hide();
  }

  @override
  Widget build(BuildContext context) {
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
