import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  // 用于触发重新计算缓存大小
  int _refreshKey = 0;

  void _refreshCacheSize() {
    setState(() {
      _refreshKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '缓存管理',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image, color: Colors.blue),
              ),
              title: const Text('清除图片缓存'),
              subtitle: const Text('清除所有缓存的封面图片'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _clearImageCache(context),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.music_note, color: Colors.green),
              ),
              title: const Text('清除音乐缓存'),
              subtitle: const Text('清除所有缓存的音乐文件'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _clearMusicCache(context),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.delete_sweep, color: Colors.red),
              ),
              title: const Text('清除所有缓存'),
              subtitle: const Text('清除图片和音乐缓存'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _clearAllCache(context),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<Map<String, int>>(
              key: ValueKey(_refreshKey), // 使用 key 来强制重建
              future: _getCacheSize(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('获取缓存大小失败: ${snapshot.error}'),
                    ),
                  );
                }
                final sizes = snapshot.data!;
                final imageCacheSize = _formatBytes(sizes['image']!);
                final musicCacheSize = _formatBytes(sizes['music']!);
                final totalSize = _formatBytes(sizes['total']!);

                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.storage, color: Colors.deepPurple),
                            const SizedBox(width: 8),
                            const Text(
                              '缓存占用空间',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildCacheSizeRow('图片缓存', imageCacheSize, Colors.blue),
                        const SizedBox(height: 12),
                        _buildCacheSizeRow(
                          '音乐缓存',
                          musicCacheSize,
                          Colors.green,
                        ),
                        const Divider(height: 24),
                        _buildCacheSizeRow(
                          '总计',
                          totalSize,
                          Colors.deepPurple,
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCacheSizeRow(
    String label,
    String size,
    Color color, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        Text(
          size,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }

  /// 清除图片缓存
  Future<void> _clearImageCache(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('清除图片缓存'),
          content: const Text('确定要清除所有图片缓存吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      // 清除 CachedNetworkImage 的内存缓存
      imageCache.clear();
      imageCache.clearLiveImages();

      // 清除文件缓存（CachedNetworkImage 的默认缓存位置）
      final tempDir = await getTemporaryDirectory();
      final libCacheDir = Directory('${tempDir.path}/libCachedImageData');

      if (await libCacheDir.exists()) {
        await libCacheDir.delete(recursive: true);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('图片缓存已清除')));
        _refreshCacheSize();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('清除失败: $e')));
      }
    }
  }

  /// 清除音乐缓存
  Future<void> _clearMusicCache(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('清除音乐缓存'),
          content: const Text('确定要清除所有音乐缓存吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      final cacheDir = await getApplicationCacheDirectory();
      final musicCacheDir = Directory('${cacheDir.path}/music_cache');

      if (await musicCacheDir.exists()) {
        await musicCacheDir.delete(recursive: true);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('音乐缓存已清除')));
        _refreshCacheSize();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('清除失败: $e')));
      }
    }
  }

  /// 清除所有缓存
  Future<void> _clearAllCache(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('清除所有缓存'),
          content: const Text('确定要清除所有图片和音乐缓存吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      // 清除图片缓存
      imageCache.clear();
      imageCache.clearLiveImages();
      final tempDir = await getTemporaryDirectory();
      final libCacheDir = Directory('${tempDir.path}/libCachedImageData');
      if (await libCacheDir.exists()) {
        await libCacheDir.delete(recursive: true);
      }

      // 清除音乐缓存
      final cacheDir = await getApplicationCacheDirectory();
      final musicCacheDir = Directory('${cacheDir.path}/music_cache');
      if (await musicCacheDir.exists()) {
        await musicCacheDir.delete(recursive: true);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('所有缓存已清除')));
        _refreshCacheSize();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('清除失败: $e')));
      }
    }
  }

  /// 获取缓存大小
  Future<Map<String, int>> _getCacheSize() async {
    int imageSize = 0;
    int musicSize = 0;

    try {
      // 获取图片缓存大小（CachedNetworkImage 的默认缓存位置）
      final tempDir = await getTemporaryDirectory();
      final libCacheDir = Directory('${tempDir.path}/libCachedImageData');
      if (await libCacheDir.exists()) {
        imageSize = await _getDirectorySize(libCacheDir);
      }

      // 获取音乐缓存大小
      final cacheDir = await getApplicationCacheDirectory();
      final musicCacheDir = Directory('${cacheDir.path}/music_cache');
      if (await musicCacheDir.exists()) {
        musicSize = await _getDirectorySize(musicCacheDir);
      }
    } catch (e) {
      // 忽略错误
    }

    return {
      'image': imageSize,
      'music': musicSize,
      'total': imageSize + musicSize,
    };
  }

  /// 获取目录大小
  Future<int> _getDirectorySize(Directory dir) async {
    int size = 0;
    try {
      if (await dir.exists()) {
        await for (final entity in dir.list(
          recursive: true,
          followLinks: false,
        )) {
          if (entity is File) {
            size += await entity.length();
          }
        }
      }
    } catch (e) {
      // 忽略错误
    }
    return size;
  }

  /// 格式化字节大小
  String _formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }
}
