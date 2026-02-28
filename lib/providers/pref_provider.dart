import 'dart:async';

import 'package:busic/models/user_pref.dart';
import 'package:busic/providers/music_list_provider.dart';
import 'package:busic/providers/storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/experimental/persist.dart';

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

  void setMusicListMode(MusicListMode m) {
    ref
        .read(playingListSnapshotProvider.notifier)
        .setIndex(null, musicListSnap: []);
    state = AsyncData(state.requireValue.copyWith(musicListMode: m));
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
