import 'package:busic/models/music_list_item.dart';
import 'package:busic/providers/audio_player_provider.dart';
import 'package:busic/providers/music_list_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

class MusicListSection extends ConsumerWidget {
  final String searchKeyword;
  final ScrollController scrollController;
  final String categoryKey;

  const MusicListSection({
    super.key,
    required this.searchKeyword,
    required this.scrollController,
    required this.categoryKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final musicListAsync = ref.watch(musicListProvider);

    return FutureBuilder<List<MusicListItemBv>>(
      future: searchKeyword.isEmpty
          ? Future.value(musicListAsync.value ?? [])
          : ref
                .read(musicDatabaseProvider)
                .searchMusicList(searchKeyword, categoryKey: categoryKey),
      builder: (context, snapshot) {
        if (searchKeyword.isNotEmpty &&
            snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final curMusicList = snapshot.data ?? musicListAsync.value ?? [];

        return musicListAsync.when(
          data: (_) => curMusicList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        searchKeyword.isEmpty
                            ? Icons.music_note_outlined
                            : Icons.search_off,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        searchKeyword.isEmpty ? '暂无音乐' : '未找到匹配的音乐',
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
                    controller: scrollController,
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: curMusicList.length,
                      itemBuilder: (context, index) {
                        final music = curMusicList[index];
                        return MusicTile(
                          music: music,
                          originalIndex: index,
                          curList: curMusicList,
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
}

class MusicTile extends ConsumerWidget {
  final MusicListItemBv music;
  final int originalIndex;
  final List<MusicListItemBv> curList;

  const MusicTile({
    super.key,
    required this.music,
    required this.originalIndex,
    required this.curList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(playingListSnapshotProvider);
    final isCurrentPlaying =
        ref.watch(playingListSnapshotProvider.notifier).getCurId() == music.id;
    final playingState = ref.watch(playingStateProvider);

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
        music.displayTitle,
        style: TextStyle(
          color: isCurrentPlaying
              ? Theme.of(context).colorScheme.primary
              : null,
          fontWeight: isCurrentPlaying ? FontWeight.bold : null,
        ),
        maxLines: 2,
      ),
      subtitle: Text(music.displaySubTitle, maxLines: 2),
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
              error: (error, stack) => const Icon(Icons.error),
            )
          : null,
      onTap: () {
        if (isCurrentPlaying) return;
        ref
            .read(playingListSnapshotProvider.notifier)
            .setIndex(originalIndex, musicListSnap: curList);
      },
      onLongPress: () async {
        await _showMusicMenu(context, ref, music, music.categoryKey);
      },
    );
  }
}

Future<void> _showMusicMenu(
  BuildContext context,
  WidgetRef ref,
  MusicListItemBv music,
  String categoryKey,
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
              if (categoryKey == 'default')
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

Future<void> _saveCacheToLocal(BuildContext context, MusicListItemBv music) async {
  try {
    final cacheFile = await music.getCacheFile();
    if (!await cacheFile.exists()) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('缓存文件不存在，请先播放该音乐')));
      }
      return;
    }

    final bytes = await cacheFile.readAsBytes();
    final outputPath = await FilePicker.platform.saveFile(
      dialogTitle: '保存音乐文件',
      fileName: '${music.title.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')}.m4s',
      type: FileType.audio,
      bytes: bytes,
    );

    if (outputPath == null) return;
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('已保存到 ${path.basename(outputPath)}')));
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('保存失败: $e')));
    }
  }
}

Future<void> _deleteCache(BuildContext context, MusicListItemBv music) async {
  try {
    final cacheFile = await music.getCacheFile();
    if (!await cacheFile.exists()) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('缓存文件不存在')));
      }
      return;
    }

    final confirmed = context.mounted
        ? await showDialog<bool>(
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
          )
        : false;

    if (confirmed != true) return;
    await cacheFile.delete();

    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('缓存已删除')));
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('删除失败: $e')));
    }
  }
}
