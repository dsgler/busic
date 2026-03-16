import 'package:busic/models/playlist_entry.dart';
import 'package:busic/models/user_pref.dart';
import 'package:busic/providers/pref_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../BuildDrawerHeader.dart';
import '../settings_page.dart';

class MusicPlaylistDrawer extends ConsumerWidget {
  final PlaylistEntry selectedPlaylist;
  final Future<void> Function() onAddFavList;
  final Future<void> Function() onAddSeaList;

  const MusicPlaylistDrawer({
    super.key,
    required this.selectedPlaylist,
    required this.onAddFavList,
    required this.onAddSeaList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefAsync = ref.watch(UserPrefProvider);

    return Drawer(
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
            selected: selectedPlaylist.type == MusicListMode.defaultMode,
            selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
            onTap: () {
              ref
                  .read(UserPrefProvider.notifier)
                  .setSelectedPlaylist(PlaylistEntry.defaultPlaylist());
              Navigator.pop(context);
            },
          ),
          Divider(
            color: Theme.of(context).colorScheme.outlineVariant,
            height: 0.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              '收藏夹',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          if (prefAsync.hasValue)
            ...prefAsync.requireValue.favLists.map((fav) {
              final entry = PlaylistEntry(
                type: MusicListMode.favList,
                listId: fav['id']!,
                name: fav['name']!,
              );
              return ListTile(
                leading: const Icon(Icons.star),
                title: Text(entry.name),
                contentPadding: const EdgeInsets.only(left: 28, right: 16),
                selected: selectedPlaylist == entry,
                selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
                onTap: () {
                  ref.read(UserPrefProvider.notifier).setSelectedPlaylist(entry);
                  Navigator.pop(context);
                },
              );
            }),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('添加收藏夹'),
            contentPadding: const EdgeInsets.only(left: 28, right: 16),
            onTap: () async {
              Navigator.pop(context);
              await onAddFavList();
            },
          ),
          Divider(
            color: Theme.of(context).colorScheme.outlineVariant,
            height: 0.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              '合辑',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          if (prefAsync.hasValue)
            ...prefAsync.requireValue.seaLists.map((sea) {
              final entry = PlaylistEntry(
                type: MusicListMode.seasonsArchives,
                listId: sea['id']!,
                name: sea['name']!,
              );
              return ListTile(
                leading: const Icon(Icons.collections_bookmark),
                title: Text(entry.name),
                contentPadding: const EdgeInsets.only(left: 28, right: 16),
                selected: selectedPlaylist == entry,
                selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
                onTap: () {
                  ref.read(UserPrefProvider.notifier).setSelectedPlaylist(entry);
                  Navigator.pop(context);
                },
              );
            }),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('添加合辑'),
            contentPadding: const EdgeInsets.only(left: 28, right: 16),
            onTap: () async {
              Navigator.pop(context);
              await onAddSeaList();
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
    );
  }
}
