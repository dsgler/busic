import 'package:busic/models/video_url_ret.dart';

import './request.dart';
import './wbi.dart';

Future<VideoUrlRet> getVideoUrl({required String bvid, int? cid = 0}) async {
  final data1 = WbiUtils.generateWbiSign({
    'bvid': bvid,
    'cid': cid,
    'fnval': 4048,
  }, await WbiToken.fetchWithCache());

  final ret = await dio.get(
    'https://api.bilibili.com/x/player/wbi/playurl',
    queryParameters: data1,
  );
  final data = VideoUrlRet.fromJson(ret.data);

  if (data.code != 0) {
    throw data.message;
  }

  return data;
}
