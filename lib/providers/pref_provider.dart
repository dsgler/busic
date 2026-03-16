import 'dart:async';

import 'package:busic/models/user_pref.dart';
import 'package:busic/providers/music_list_provider.dart';
import 'package:busic/providers/storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:busic/models/playlist_entry.dart';

class UserPrefNotifier extends AsyncNotifier<UserPref> {
  static final prefStoreKey = 'prefStoreKey039';

  @override
  Future<UserPref> build() async {
    await persist(
      ref.watch(storageProvider.future),
      key: prefStoreKey,
      encode: (state) => state.toRawJson(),
      decode: (encoded) => UserPref.fromRawJson(encoded),
    ).future;

    return state.hasValue ? state.requireValue : UserPref();
  }

  void setSelectedPlaylist(PlaylistEntry entry) {
    ref
        .read(playingListSnapshotProvider.notifier)
        .setIndex(null, musicListSnap: []);
    state = AsyncData(
      state.requireValue.copyWith(selectedPlaylistKey: entry.key),
    );
  }

  void addFavList(String id, String name) {
    final current = state.requireValue;
    final newFavLists = List<Map<String, String>>.of(current.favLists);
    if (!newFavLists.any((e) => e['id'] == id)) {
      newFavLists.add({'id': id, 'name': name});
    }
    final entry = PlaylistEntry(
      type: MusicListMode.favList,
      listId: id,
      name: name,
    );
    ref
        .read(playingListSnapshotProvider.notifier)
        .setIndex(null, musicListSnap: []);
    state = AsyncData(
      current.copyWith(
        favLists: newFavLists,
        selectedPlaylistKey: entry.key,
      ),
    );
  }

  void addSeaList(String id, String name) {
    final current = state.requireValue;
    final newSeaLists = List<Map<String, String>>.of(current.seaLists);
    if (!newSeaLists.any((e) => e['id'] == id)) {
      newSeaLists.add({'id': id, 'name': name});
    }
    final entry = PlaylistEntry(
      type: MusicListMode.seasonsArchives,
      listId: id,
      name: name,
    );
    ref
        .read(playingListSnapshotProvider.notifier)
        .setIndex(null, musicListSnap: []);
    state = AsyncData(
      current.copyWith(
        seaLists: newSeaLists,
        selectedPlaylistKey: entry.key,
      ),
    );
  }

  void setState(void Function(UserPref state) cb) {
    final newState = state.requireValue.copyWith();
    cb(newState);
    state = AsyncData(newState);
  }
}

final UserPrefProvider = AsyncNotifierProvider<UserPrefNotifier, UserPref>(
  UserPrefNotifier.new,
);
