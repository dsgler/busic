import 'package:busic/consts/network.dart';
import 'package:busic/providers/music_list_provider.dart';
import 'package:busic/providers/pref_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

// 音频播放器管理器
class AudioPlayerManager extends Notifier<AudioPlayer?> {
  @override
  AudioPlayer? build() {
    ref.listen(UserPrefProvider.select((s) => s.value?.musicListMode), (
      prev,
      next,
    ) {
      if (prev != next) {
        dispose();
        ref.read(currentPlayingIndexProvider.notifier).setIndex(null);
      }
    });

    return null;
  }

  AudioPlayerManager() {
    if (isUseSampleAudio) {
      _initSamplePlayer();
    }
  }

  void _initSamplePlayer() async {
    final player = AudioPlayer();
    await player.setUrl('https://www.chongfanmitu.com/chat/Sounds/test.mp3');
    state = player;
  }

  // 设置新的播放器并关闭旧的
  Future<void> setPlayer(AudioPlayer? newPlayer) async {
    // 停止并释放旧的播放器
    if (state != null) {
      await state!.stop();
      await state!.dispose();
    }
    // 设置新的播放器
    state = newPlayer;
    newPlayer?.play();
    newPlayer?.playerStateStream.listen((e) {
      if (e.processingState == ProcessingState.completed) {
        ref.read(currentPlayingIndexProvider.notifier).playNext();
      }
    });
  }

  // 获取当前播放器

  void dispose() {
    state?.dispose();
  }
}

// AudioPlayer 管理 Provider
final audioPlayerManagerProvider =
    NotifierProvider<AudioPlayerManager, AudioPlayer?>(() {
      return AudioPlayerManager();
    });

// 播放状态 Provider
final playingStateProvider = StreamProvider<bool>((ref) {
  final player = ref.watch(audioPlayerManagerProvider);
  if (player == null) {
    return Stream.value(false);
  }

  return player.playingStream;
});

// 播放进度 Provider
final positionProvider = StreamProvider<Duration>((ref) {
  final player = ref.watch(audioPlayerManagerProvider);
  if (player == null) {
    return Stream.value(Duration.zero);
  }
  return player.positionStream;
});

// 缓冲进度 Provider
final bufferedPositionProvider = StreamProvider<Duration>((ref) {
  final player = ref.watch(audioPlayerManagerProvider);
  if (player == null) {
    return Stream.value(Duration.zero);
  }
  return player.bufferedPositionStream;
});

// 总时长 Provider
final durationProvider = StreamProvider<Duration?>((ref) {
  final player = ref.watch(audioPlayerManagerProvider);
  if (player == null) {
    return Stream.value(null);
  }
  return player.durationStream;
});

// 播放器状态 Provider
final playerStateProvider = StreamProvider<PlayerState>((ref) {
  final player = ref.watch(audioPlayerManagerProvider);
  if (player == null) {
    return Stream.value(PlayerState(false, ProcessingState.idle));
  }
  return player.playerStateStream;
});

// 播放模式枚举
enum PlayMode {
  sequential, // 顺序播放
  random, // 随机播放
}

class PlayModeNotifier extends Notifier<PlayMode> {
  @override
  PlayMode build() {
    return PlayMode.sequential;
  }

  void setMode(PlayMode mode) {
    state = mode;
  }
}

// 播放模式 Provider
final playModeNotifierProvider = NotifierProvider<PlayModeNotifier, PlayMode>(
  PlayModeNotifier.new,
);
