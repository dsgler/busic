import './request.dart';
import './wbi.dart';

Future<dynamic> getVideoUrl({required String bvid, int? cid = 0}) async {
  final data1 = WbiUtils.generateWbiSign({
    'bvid': bvid,
    'cid': cid,
    'fnval': 4048,
  }, await WbiToken.fetchWithCache());

  final ret = await dio.get(
    'https://api.bilibili.com/x/player/wbi/playurl',
    queryParameters: data1,
  );
  if (ret.data['code'] != 0) {
    throw ret.data['message'];
  }

  return ret.data;
}
