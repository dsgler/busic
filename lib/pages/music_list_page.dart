import 'package:busic/models/music_list_item.dart';
import 'package:busic/models/playlist_entry.dart';
import 'package:busic/models/user_pref.dart';
import 'package:busic/pages/widgets/music_control_bar.dart';
import 'package:busic/pages/widgets/music_list_section.dart';
import 'package:busic/pages/widgets/music_playlist_drawer.dart';
import 'package:busic/providers/music_list_provider.dart';
import 'package:busic/providers/pref_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'play_page.dart';

class MusicListPage extends ConsumerStatefulWidget {
  const MusicListPage({super.key});

  @override
  ConsumerState<MusicListPage> createState() => _MusicListPageState();
}

class _MusicListPageState extends ConsumerState<MusicListPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  String _searchKeyword = '';
  bool _showSearch = false;

  @override
  void dispose() {
    _searchController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  void _onProgress(BuildContext context, int progress) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('已加载第 $progress 页')));
  }

  Future<void> _onTapAddBv() async {
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
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );

    if (result == null || result.length < 2) return;
    if (result[0].toLowerCase() == 'b' && result[1].toLowerCase() == 'v') {
      final list = await MusicListItemBv.fetchBv(bvid: result);
      for (final item in list) {
        await ref.read(musicListProvider.notifier).addMusic(item);
      }
    }
  }

  Future<void> _onAddFavList() async {
    final fidController = TextEditingController();
    final fid = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('请输入fid或收藏夹链接'),
        content: TextField(
          controller: fidController,
          autofocus: true,
          decoration: const InputDecoration(hintText: '在这里输入'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, fidController.text.trim()),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    if (fid == null || fid.isEmpty) return;

    String id;
    var re = RegExp(r'fid=(\d+)');
    var m = re.firstMatch(fid);
    if (m != null) {
      id = m[1]!;
    } else {
      re = RegExp(r'^\d+$');
      if (!re.hasMatch(fid)) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('无法识别fid')));
        }
        return;
      }
      id = fid;
    }

    if (!mounted) return;
    final nameController = TextEditingController(text: id);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('请输入收藏夹名称'),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(hintText: '默认使用ID作为名称'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, nameController.text.trim()),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    if (name == null) return;

    ref.read(UserPrefProvider.notifier).addFavList(id, name.isEmpty ? id : name);
    await ref.read(musicListProvider.notifier).syncFavList(
      id,
      onProgress: (p) => _onProgress(context, p),
    );
  }

  Future<void> _onAddSeaList() async {
    final idController = TextEditingController();
    final rawId = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('请输入season_id或合辑链接（纯数字）'),
        content: TextField(
          controller: idController,
          autofocus: true,
          decoration: const InputDecoration(hintText: '在这里输入'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, idController.text.trim()),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    if (rawId == null || rawId.isEmpty) return;

    String id;
    final linkRe = RegExp(r'season_id[=:](\d+)');
    final linkMatch = linkRe.firstMatch(rawId);
    if (linkMatch != null) {
      id = linkMatch[1]!;
    } else {
      final re = RegExp(r'^\d+$');
      if (!re.hasMatch(rawId)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('无法识别season_id，请输入纯数字')),
          );
        }
        return;
      }
      id = rawId;
    }

    if (!mounted) return;
    final nameController = TextEditingController(text: id);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('请输入合辑名称'),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(hintText: '默认使用ID作为名称'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, nameController.text.trim()),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    if (name == null) return;

    ref.read(UserPrefProvider.notifier).addSeaList(id, name.isEmpty ? id : name);
    await ref.read(musicListProvider.notifier).syncSeaList(
      id,
      onProgress: (p) => _onProgress(context, p),
    );
  }

  @override
  Widget build(BuildContext context) {
    final musicListAsync = ref.watch(musicListProvider);
    final prefAsync = ref.watch(UserPrefProvider);
    final playlist = prefAsync.hasValue
        ? prefAsync.requireValue.selectedPlaylist
        : PlaylistEntry.defaultPlaylist();

    return Scaffold(
      appBar: AppBar(
        title: Text(playlist.name),
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
          if (playlist.type == MusicListMode.defaultMode)
            IconButton(icon: const Icon(Icons.add), onPressed: _onTapAddBv),
          if (playlist.type != MusicListMode.defaultMode)
            IconButton(
              icon: const Icon(Icons.sync),
              onPressed: () {
                if (playlist.type == MusicListMode.favList) {
                  ref.read(musicListProvider.notifier).syncFavList(
                        playlist.listId,
                        onProgress: (p) => _onProgress(context, p),
                      );
                } else if (playlist.type == MusicListMode.seasonsArchives) {
                  ref.read(musicListProvider.notifier).syncSeaList(
                        playlist.listId,
                        onProgress: (p) => _onProgress(context, p),
                      );
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
                        await ref
                            .read(musicListProvider.notifier)
                            .clearList(categoryKey: playlist.key);
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                      child: const Text('确定'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      drawer: MusicPlaylistDrawer(
        selectedPlaylist: playlist,
        onAddFavList: _onAddFavList,
        onAddSeaList: _onAddSeaList,
      ),
      body: Column(
        children: [
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
          Expanded(
            child: MusicListSection(
              searchKeyword: _searchKeyword,
              scrollController: _listScrollController,
              categoryKey: playlist.key,
            ),
          ),
          musicListAsync.when(
            data: (_) {
              return MusicControlBar(
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
                            final tween = Tween(
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
            error: (error, stack) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
