import 'package:busic/models/user_pref.dart';
import 'package:busic/providers/pref_provider.dart';
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
    final modeAsync = ref.watch(UserPrefProvider);
    final mode = modeAsync.hasValue
        ? modeAsync.requireValue.musicListMode
        : MusicListMode.defaultMode;

    void onProgress(int progress) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('已加载第 $progress 页')));
    }

    void onTapAdd() async {
      final controller = TextEditingController();

      final result = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(switch (mode) {
              MusicListMode.defaultMode => '请输入BV',
              MusicListMode.favList => '请输入fid或收藏夹链接',
              MusicListMode.seasonsArchives => '请输入fid或合辑链接',
            }),
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
        switch (mode) {
          case MusicListMode.defaultMode:
            {
              if (result[0].toLowerCase() == 'b' &&
                  result[1].toLowerCase() == 'v') {
                MusicListItemBv.fetchBv(bvid: result).then((list) {
                  for (var a in list) {
                    ref.read(musicListProvider.notifier).addMusic(a);
                  }
                });
              }
            }
          case MusicListMode.favList:
            {
              var re = RegExp(r'fid=(\d+)');
              var m = re.firstMatch(result);
              String mid;
              if (m != null) {
                mid = m[1]!;
              } else {
                re = RegExp(r'^\d+$');
                m = re.firstMatch(result);
                if (m == null) throw '无法识别fid';

                mid = result;
              }

              ref.read(UserPrefProvider.notifier).setState((state) {
                state.favListId = mid;
              });

              await ref
                  .read(musicListProvider.notifier)
                  .syncFavList(onProgress: onProgress);
            }
          case MusicListMode.seasonsArchives:
            {
              final re = RegExp(r'^\d+$');
              final m = re.firstMatch(result);
              if (m == null) throw '无法识别season_id,请输入纯数字';
              ref.read(UserPrefProvider.notifier).setState((state) {
                state.seaListId = result;
              });

              await ref
                  .read(musicListProvider.notifier)
                  .syncSeaList(onProgress: onProgress);
            }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(switch (mode) {
          MusicListMode.defaultMode => '我的音乐',
          MusicListMode.favList => '收藏夹',
          MusicListMode.seasonsArchives => '视频合辑',
        }),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (mode == MusicListMode.defaultMode ||
              (musicListAsync.hasValue && musicListAsync.requireValue.isEmpty))
            IconButton(icon: const Icon(Icons.add), onPressed: onTapAdd)
          else
            IconButton(
              icon: const Icon(Icons.sync),
              onPressed: () {
                switch (mode) {
                  case MusicListMode.favList:
                    {
                      ref
                          .read(musicListProvider.notifier)
                          .syncFavList(onProgress: onProgress);
                    }
                  case MusicListMode.seasonsArchives:
                    {
                      ref
                          .read(musicListProvider.notifier)
                          .syncSeaList(onProgress: onProgress);
                    }
                  case _:
                    {}
                }
              },
            ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(musicListProvider.notifier).clearList(category: mode);
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
              title: const Text('默认列表'),
              onTap: () {
                ref
                    .read(UserPrefProvider.notifier)
                    .setMusicListMode(MusicListMode.defaultMode);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text('收藏夹'),
              onTap: () {
                ref
                    .read(UserPrefProvider.notifier)
                    .setMusicListMode(MusicListMode.favList);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text('合辑'),
              onTap: () {
                ref
                    .read(UserPrefProvider.notifier)
                    .setMusicListMode(MusicListMode.seasonsArchives);
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
                  : Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Scrollbar(
                        interactive: true,

                        child: ListView.builder(
                          itemCount: musicList.length,

                          itemBuilder: (context, index) {
                            final music = musicList[index];
                            final isCurrentPlaying =
                                currentPlayingIndex == index;

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
                                        isPlaying
                                            ? Icons.volume_up
                                            : Icons.pause,
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
                                      error: (_, _) => const Icon(Icons.error),
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
                      ),
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
              error: (_, _) => const SizedBox.shrink(),
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
              color: Colors.black.withValues(alpha: 0.1),
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
                  error: (_, _) => const SizedBox(height: 2),
                );
              },
              loading: () => const LinearProgressIndicator(minHeight: 2),
              error: (_, _) => const SizedBox(height: 2),
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
                    error: (_, _) => IconButton(
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
