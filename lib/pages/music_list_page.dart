import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/music_list_item.dart';
import '../providers/music_list_provider.dart';
import '../providers/audio_player_provider.dart';
import 'play_page.dart';
import 'user_info_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './BuildDrawerHeader.dart';

class MusicListPage extends ConsumerWidget {
  const MusicListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final musicListAsync = ref.watch(musicListProvider);
    final currentPlayingIndex = ref.watch(currentPlayingIndexProvider);
    final playingState = ref.watch(playingStateProvider);

    onTapAdd() async {
      final controller = TextEditingController();

      final result = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('请输入BV'),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(hintText: '在这里输入'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, controller.text);
                },
                child: const Text('确定'),
              ),
            ],
          );
        },
      );

      if (result != null) {
        if (result[0].toLowerCase() == 'b' && result[1].toLowerCase() == 'v') {
          MusicListItemBv.fetchBv(bvid: result).then((list) {
            for (var a in list) {
              ref.read(musicListProvider.notifier).addMusic(a);
            }
          });
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的音乐'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: onTapAdd),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(musicListProvider.notifier).clearList();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            BuildDrawerHeader(context, ref),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('用户信息'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserInfoPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text('我的音乐'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('设置'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 跳转到设置页面
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('设置功能待开发')));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 音乐列表
          Expanded(
            child: musicListAsync.when(
              data: (musicList) => musicList.isEmpty
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
                                    child: CachedNetworkImage(
                                      imageUrl: music.coverUrl!,
                                      fit: BoxFit.cover,
                                      errorWidget:
                                          (context, error, stackTrace) {
                                            return Icon(
                                              Icons.music_note,
                                              color: Colors.grey[600],
                                            );
                                          },
                                    ),
                                  )
                                : Icon(
                                    Icons.music_note,
                                    color: Colors.grey[600],
                                  ),
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
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
                            ref
                                .read(currentPlayingIndexProvider.notifier)
                                .setIndex(index);
                          },
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text('加载失败: $error'),
                  ],
                ),
              ),
            ),
          ),

          // 底部音乐控制栏
          if (currentPlayingIndex != null)
            musicListAsync.when(
              data: (musicList) {
                if (musicList.isEmpty ||
                    currentPlayingIndex >= musicList.length) {
                  return const SizedBox.shrink();
                }
                return _MusicControlBar(
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
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
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
    final player = ref.watch(audioPlayerManagerProvider);
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
                            child: CachedNetworkImage(
                              imageUrl: music.coverUrl!,
                              fit: BoxFit.cover,
                              errorWidget: (context, error, stackTrace) {
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
                      ref.read(currentPlayingIndexProvider.notifier).playNext();
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

  /// 构建 Drawer Header
}
