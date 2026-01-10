import 'package:busic/providers/music_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/audio_player_provider.dart';

class PlayPage extends ConsumerWidget {
  const PlayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(audioPlayerProvider);
    final playingState = ref.watch(playingStateProvider);
    final position = ref.watch(positionProvider);
    final bufferedPosition = ref.watch(bufferedPositionProvider);
    final duration = ref.watch(durationProvider);

    final musicListAsync = ref.watch(musicListProvider);
    final currentPlayingIndex = ref.watch(currentPlayingIndexProvider);

    final musicList = musicListAsync.hasValue
        ? musicListAsync.requireValue
        : null;
    final isLoaded = currentPlayingIndex != null && musicList != null;
    final music = isLoaded ? musicList[currentPlayingIndex] : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('音乐播放器'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // 占位空间
          const SizedBox(height: 40),

          // 封面图片
          Expanded(
            child: Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: isLoaded && music!.coverUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            music.coverUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.music_note,
                                color: Colors.grey[600],
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.music_note,
                          size: 120,
                          color: Colors.grey[600],
                        ),
                ),
              ),
            ),
          ),

          // 歌曲信息
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              children: [
                Text(
                  music?.title ?? "歌曲标题",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  music?.artist ?? '艺术家',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // 进度条
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                // 进度条
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4.0,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6.0,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 14.0,
                    ),
                    // 设置次要轨道颜色（缓冲进度）为灰色
                    secondaryActiveTrackColor: Colors.grey[400],
                    inactiveTrackColor: Colors.grey[300],
                  ),
                  child: Slider(
                    value: position.value?.inMilliseconds.toDouble() ?? 0.0,
                    max: duration.value?.inMilliseconds.toDouble() ?? 1.0,
                    secondaryTrackValue: bufferedPosition.value?.inMilliseconds
                        .toDouble(),
                    onChanged: (value) {
                      player?.seek(Duration(milliseconds: value.toInt()));
                    },
                  ),
                ),
                // 时间显示
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(position.value ?? Duration.zero),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        _formatDuration(duration.value ?? Duration.zero),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 控制按钮
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 上一曲按钮
                IconButton(
                  onPressed: () {
                    // TODO: 实现上一曲逻辑
                  },
                  icon: const Icon(Icons.skip_previous),
                  iconSize: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),

                // 播放/暂停按钮
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (player != null) {
                        final isPlaying = playingState.value ?? false;
                        if (isPlaying) {
                          player.pause();
                        } else {
                          player.play();
                        }
                      }
                    },
                    icon: Icon(
                      playingState.when(
                        data: (isPlaying) =>
                            isPlaying ? Icons.pause : Icons.play_arrow,
                        loading: () => Icons.play_arrow,
                        error: (_, __) => Icons.play_arrow,
                      ),
                    ),
                    iconSize: 40,
                    color: Colors.white,
                  ),
                ),

                // 下一曲按钮
                IconButton(
                  onPressed: () {
                    // TODO: 实现下一曲逻辑
                  },
                  icon: const Icon(Icons.skip_next),
                  iconSize: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
