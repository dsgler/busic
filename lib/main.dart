import 'package:busic/network/request.dart';
import 'package:busic/pages/music_list_page.dart';
import 'package:busic/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  await initDio();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 将context传递给错误处理器
    GlobalErrorHandler().setContext(context);

    return MaterialApp(
      title: 'Busic - 音乐播放器',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MusicListPage(),
    );
  }
}
