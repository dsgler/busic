import 'package:busic/models/user_pref.dart';
import 'package:busic/providers/pref_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/music_list_item.dart';
import '../providers/music_list_provider.dart';
import '../providers/audio_player_provider.dart';
import 'play_page.dart';
import 'settings_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './BuildDrawerHeader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class MusicListPage extends ConsumerStatefulWidget {
  const MusicListPage({super.key});

  @override
  ConsumerState<MusicListPage> createState() => _MusicListPageState();
}

class _MusicListPageState extends ConsumerState<MusicListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';
  bool _showSearch = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final musicListAsync = ref.watch(musicListProvider);
    final currentPlayingIndex = ref.watch(currentPlayingIndexProvider);
    // final playingState = ref.watch(playingStateProvider);
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
        // centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.search_off : Icons.search),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchController.clear();
                  _searchKeyword = '';
                }
              });
            },
          ),
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
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('确认要删除吗？'),
                  content: const Text('这将删除列表中所有音乐（不会删除对应缓存）'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () async {
                        ref
                            .read(musicListProvider.notifier)
                            .clearList(category: mode);
                        Navigator.pop(context);
                      },
                      child: Text('确定'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            BuildDrawerHeader(context, ref),
            Divider(
              color: Theme.of(context).colorScheme.outlineVariant,
              height: 0.0,
            ),
            ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text('默认列表'),
              selected: mode == MusicListMode.defaultMode,
              selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
              onTap: () {
                ref
                    .read(UserPrefProvider.notifier)
                    .setMusicListMode(MusicListMode.defaultMode);
                Navigator.pop(context);
              },
            ),
            Divider(
              color: Theme.of(context).colorScheme.outlineVariant,
              height: 0.0,
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('收藏夹'),
              selected: mode == MusicListMode.favList,
              selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
              onTap: () {
                ref
                    .read(UserPrefProvider.notifier)
                    .setMusicListMode(MusicListMode.favList);
                Navigator.pop(context);
              },
            ),
            Divider(
              color: Theme.of(context).colorScheme.outlineVariant,
              height: 0.0,
            ),
            ListTile(
              leading: const Icon(Icons.collections_bookmark),
              title: const Text('合辑'),
              selected: mode == MusicListMode.seasonsArchives,
              selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
              onTap: () {
                ref
                    .read(UserPrefProvider.notifier)
                    .setMusicListMode(MusicListMode.seasonsArchives);
                Navigator.pop(context);
              },
            ),
            Divider(
              color: Theme.of(context).colorScheme.outlineVariant,
              height: 0.0,
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('设置'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 搜索框
          if (_showSearch)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '搜索音乐、艺术家或BV号...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchKeyword.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchKeyword = '';
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchKeyword = value;
                  });
                },
              ),
            ),
          // 音乐列表
          Expanded(child: _buildMusicList(musicListAsync, mode)),

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

  Widget _buildMusicList(
    AsyncValue<List<MusicListItemBv>> musicListAsync,
    MusicListMode mode,
  ) {
    return FutureBuilder<List<MusicListItemBv>>(
      future: _searchKeyword.isEmpty
          ? Future.value(musicListAsync.value ?? [])
          : ref
                .read(musicDatabaseProvider)
                .searchMusicList(_searchKeyword, category: mode),
      builder: (context, snapshot) {
        if (_searchKeyword.isNotEmpty &&
            snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final musicList = snapshot.data ?? musicListAsync.value ?? [];
        final currentPlayingIndex = ref.watch(currentPlayingIndexProvider);
        final playingState = ref.watch(playingStateProvider);

        return musicListAsync.when(
          data: (_) => musicList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _searchKeyword.isEmpty
                            ? Icons.music_note_outlined
                            : Icons.search_off,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _searchKeyword.isEmpty ? '暂无音乐' : '未找到匹配的音乐',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Scrollbar(
                    interactive: true,
                    thickness: 6,
                    child: ListView.builder(
                      itemCount: musicList.length,
                      itemBuilder: (context, index) {
                        final music = musicList[index];
                        final originalIndex =
                            musicListAsync.value?.indexWhere(
                              (m) => m.bvid == music.bvid && m.cid == music.cid,
                            ) ??
                            -1;
                        final isCurrentPlaying =
                            originalIndex != -1 &&
                            currentPlayingIndex == originalIndex;
                        final isSinglePage =
                            music.subTitle == "" ||
                            music.title == music.subTitle;

                        return _buildMusicTile(
                          context,
                          music,
                          isCurrentPlaying,
                          isSinglePage,
                          playingState,
                          originalIndex,
                          mode,
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
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text('加载失败: $error'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMusicTile(
    BuildContext context,
    MusicListItemBv music,
    bool isCurrentPlaying,
    bool isSinglePage,
    AsyncValue<bool> playingState,
    int originalIndex,
    MusicListMode mode,
  ) {
    return ListTile(
      tileColor: isCurrentPlaying
          ? Theme.of(context).colorScheme.surfaceContainerHighest
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
                  errorWidget: (context, error, stackTrace) {
                    return Icon(Icons.music_note, color: Colors.grey[600]);
                  },
                ),
              )
            : Icon(Icons.music_note, color: Colors.grey[600]),
      ),
      title: Text(
        isSinglePage ? music.title : music.subTitle,
        style: TextStyle(
          color: isCurrentPlaying
              ? Theme.of(context).colorScheme.primary
              : null,
          fontWeight: isCurrentPlaying ? FontWeight.bold : null,
        ),
        maxLines: 2,
      ),
      subtitle: Text(
        isSinglePage ? music.artist : '${music.artist} - ${music.title}',
        maxLines: 2,
      ),
      trailing: isCurrentPlaying
          ? playingState.when(
              data: (isPlaying) => Icon(
                isPlaying ? Icons.volume_up : Icons.pause,
                color: Theme.of(context).colorScheme.primary,
              ),
              loading: () => const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (_, _) => const Icon(Icons.error),
            )
          : null,
      onTap: () async {
        if (originalIndex == -1) return;

        // 如果点击的是当前正在播放的歌曲，只切换播放/暂停状态
        final currentPlayingIndex = ref.read(currentPlayingIndexProvider);
        if (currentPlayingIndex == originalIndex) {
          return;
        }

        // 设置当前播放的音乐索引
        ref.read(currentPlayingIndexProvider.notifier).setIndex(originalIndex);
      },
      onLongPress: () async {
        await _showMusicMenu(context, ref, music, mode);
      },
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

/// 显示音乐菜单
Future<void> _showMusicMenu(
  BuildContext context,
  WidgetRef ref,
  MusicListItemBv music,
  MusicListMode mode,
) async {
  await showModalBottomSheet(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (mode == MusicListMode.defaultMode)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('从列表中删除'),
                  onTap: () async {
                    Navigator.pop(context);

                    ref
                        .read(musicListProvider.notifier)
                        .removeMusicByBvCid(music.bvid, music.cid);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.save_alt),
                title: const Text('将缓存保存到本地'),
                onTap: () async {
                  Navigator.pop(context);
                  await _saveCacheToLocal(context, music);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text('删除缓存'),
                onTap: () async {
                  Navigator.pop(context);
                  await _deleteCache(context, music);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// 将缓存保存到本地
Future<void> _saveCacheToLocal(
  BuildContext context,
  MusicListItemBv music,
) async {
  try {
    // 获取缓存文件
    final cacheFile = await music.getCacheFile();

    // 检查缓存文件是否存在
    if (!await cacheFile.exists()) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('缓存文件不存在，请先播放该音乐')));
      }
      return;
    }

    // 读取缓存文件的字节数据
    final bytes = await cacheFile.readAsBytes();

    // 使用 file_picker 选择保存位置
    String? outputPath = await FilePicker.platform.saveFile(
      dialogTitle: '保存音乐文件',
      fileName: '${music.title.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')}.m4s',
      type: FileType.audio,
      bytes: bytes,
    );

    if (outputPath == null) {
      // 用户取消了
      return;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已保存到 ${path.basename(outputPath)}')),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('保存失败: $e')));
    }
  }
}

/// 删除缓存
Future<void> _deleteCache(BuildContext context, MusicListItemBv music) async {
  try {
    // 获取缓存文件
    final cacheFile = await music.getCacheFile();

    // 检查缓存文件是否存在
    if (!await cacheFile.exists()) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('缓存文件不存在')));
      }
      return;
    }

    // 确认删除
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('确认删除'),
          content: const Text('确定要删除该音乐的缓存文件吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('删除'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    // 删除文件
    await cacheFile.delete();

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('缓存已删除')));
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('删除失败: $e')));
    }
  }
}
