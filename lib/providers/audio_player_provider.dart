import 'package:busic/consts/network.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:just_audio/just_audio.dart';

// 音频播放器管理器
class AudioPlayerManager extends StateNotifier<AudioPlayer?> {
  AudioPlayerManager() : super(null) {
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
  Future<void> setPlayer(AudioPlayer newPlayer) async {
    // 停止并释放旧的播放器
    if (state != null) {
      await state!.stop();
      await state!.dispose();
    }
    // 设置新的播放器
    state = newPlayer;
  }

  // 获取当前播放器
  AudioPlayer? get player => state;

  @override
  void dispose() {
    state?.dispose();
    super.dispose();
  }
}

// AudioPlayer 管理 Provider
final audioPlayerManagerProvider =
    StateNotifierProvider<AudioPlayerManager, AudioPlayer?>((ref) {
      return AudioPlayerManager();
    });

// AudioPlayer 实例的 Provider（为了兼容性保留）
final audioPlayerProvider = Provider<AudioPlayer?>((ref) {
  return ref.watch(audioPlayerManagerProvider);
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
