just_audio 的 LockCachingAudioSource 目前有bug
重命名文件前不会关闭文件
请改为

```dart
}, onDone: () async {
  // ...
  for (var cacheResponse in inProgressResponses) {
    if (!cacheResponse.controller.isClosed) {
      cacheResponse.controller.close();
    }
  }

  // ✅ 先关闭 sink
  await sink.flush();
  await sink.close();

  // ✅ 然后再重命名
  (await _partialCacheFile).renameSync(cacheFile.path);

  await subscription.cancel();
  httpClient.close();
  _downloading = false;
}, ...
```
