import 'package:busic/network/request.dart';
import 'package:busic/pages/music_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './network/test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDio();
  // test();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
