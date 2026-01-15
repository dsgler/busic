import 'dart:async';

import 'package:busic/models/user_pref.dart';
import 'package:busic/providers/storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/experimental/persist.dart';

final prefStoreKey = 'prefStoreKey039';

class UserPrefNotifier extends AsyncNotifier<UserPref> {
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
    state = AsyncData(state.value!.copyWith(musicListMode: m));
  }
}

final UserPrefProvider = AsyncNotifierProvider<UserPrefNotifier, UserPref>(
  UserPrefNotifier.new,
);
