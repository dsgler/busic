import 'package:busic/models/video_info_ret.dart';

import './request.dart';

Future<VideoInfoRet> getVideoInfo({required String bvid}) async {
  final ret = await dio.get(
    'https://api.bilibili.com/x/web-interface/view',
    queryParameters: {'bvid': bvid},
  );

  final data = VideoInfoRet.fromJson(ret.data);
  if (data.code != 0) {
    throw data.message;
  }

  return data;
}
