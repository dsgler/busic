import 'package:busic/utils/sample_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/music_list_provider.dart';
import '../providers/audio_player_provider.dart';
import 'play_page.dart';

class MusicListPage extends ConsumerWidget {
  const MusicListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final musicList = ref.watch(musicListProvider);
    final currentPlayingIndex = ref.watch(currentPlayingIndexProvider);
    final player = ref.watch(audioPlayerProvider);
    final playingState = ref.watch(playingStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的音乐'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: 添加音乐的功能
              initSampleMusicList(ref);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 音乐列表
          Expanded(
            child: musicList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.music_note_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '暂无音乐',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: musicList.length,
                    itemBuilder: (context, index) {
                      final music = musicList[index];
                      final isCurrentPlaying = currentPlayingIndex == index;

                      return ListTile(
                        tileColor: isCurrentPlaying
                            ? Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest
                            : null,
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: music.coverUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    music.coverUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.music_note,
                                        color: Colors.grey[600],
                                      );
                                    },
                                  ),
                                )
                              : Icon(Icons.music_note, color: Colors.grey[600]),
                        ),
                        title: Text(
                          music.title,
                          style: TextStyle(
                            color: isCurrentPlaying
                                ? Theme.of(context).colorScheme.primary
                                : null,
                            fontWeight: isCurrentPlaying
                                ? FontWeight.bold
                                : null,
                          ),
                        ),
                        subtitle: Text(music.artist),
                        trailing: isCurrentPlaying
                            ? playingState.when(
                                data: (isPlaying) => Icon(
                                  isPlaying ? Icons.volume_up : Icons.pause,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                loading: () => const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                error: (_, __) => const Icon(Icons.error),
                              )
                            : null,
                        onTap: () async {
                          // 如果点击的是当前正在播放的歌曲，只切换播放/暂停状态
                          if (currentPlayingIndex == index) {
                            return;
                          }

                          // 设置当前播放的音乐索引
                          ref.read(currentPlayingIndexProvider.notifier).state =
                              index;

                          // 使用 generatePlayer 创建新的播放器并关闭旧的
                          final newPlayer = await music.generatePlayer();
                          await ref
                              .read(audioPlayerManagerProvider.notifier)
                              .setPlayer(newPlayer);

                          // 开始播放
                          await newPlayer.play();

                          // 导航到播放页面
                          // if (context.mounted) {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => const PlayPage(),
                          //     ),
                          //   );
                          // }
                        },
                      );
                    },
                  ),
          ),

          // 底部音乐控制栏
          if (currentPlayingIndex != null && musicList.isNotEmpty)
            _MusicControlBar(
              music: musicList[currentPlayingIndex],
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const PlayPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          var tween = Tween(
                            begin: begin,
                            end: end,
                          ).chain(CurveTween(curve: curve));
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// 底部音乐控制栏
class _MusicControlBar extends ConsumerWidget {
  final MusicListItemBv music;
  final VoidCallback onTap;

  const _MusicControlBar({required this.music, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(audioPlayerProvider);
    final playingState = ref.watch(playingStateProvider);
    final position = ref.watch(positionProvider);
    final duration = ref.watch(durationProvider);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 进度条
            position.when(
              data: (pos) {
                return duration.when(
                  data: (dur) {
                    final progress = dur != null && dur.inMilliseconds > 0
                        ? pos.inMilliseconds / dur.inMilliseconds
                        : 0.0;
                    return LinearProgressIndicator(
                      value: progress,
                      minHeight: 2,
                      backgroundColor: Colors.grey[300],
                    );
                  },
                  loading: () =>
                      const LinearProgressIndicator(minHeight: 2, value: 0),
                  error: (_, __) => const SizedBox(height: 2),
                );
              },
              loading: () => const LinearProgressIndicator(minHeight: 2),
              error: (_, __) => const SizedBox(height: 2),
            ),

            // 控制栏内容
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // 封面
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: music.coverUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              music.coverUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.music_note,
                                  color: Colors.grey[600],
                                );
                              },
                            ),
                          )
                        : Icon(Icons.music_note, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 12),

                  // 音乐信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          music.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          music.artist,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // 播放/暂停按钮
                  playingState.when(
                    data: (isPlaying) => IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 32,
                      ),
                      onPressed: () {
                        if (player != null) {
                          if (isPlaying) {
                            player.pause();
                          } else {
                            player.play();
                          }
                        }
                      },
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                    ),
                    error: (_, __) => IconButton(
                      icon: const Icon(Icons.error, size: 32),
                      onPressed: null,
                    ),
                  ),

                  // 下一首按钮
                  IconButton(
                    icon: const Icon(Icons.skip_next, size: 32),
                    onPressed: () {
                      // TODO: 实现下一首功能
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
