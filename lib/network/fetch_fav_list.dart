import 'package:busic/consts/network.dart';
import 'package:busic/models/fav_list_ret.dart';
import 'package:busic/models/music_list_item.dart';
import 'package:busic/network/request.dart';

Future<List<MusicListItemBv>> fetchFavList(
  String media_id, {
    String categoryKey = 'favList',
  void Function(int progress)? onProgress,
}) async {
  var curp = 1;
  final List<MusicListItemBv> l = [];
  var hasMore = true;
  while (hasMore) {
    final ret = await dio.get(
      'https://api.bilibili.com/x/v3/fav/resource/list',
      queryParameters: {'media_id': media_id, 'pn': curp, 'ps': '20'},
    );
    final r = FavListRet.fromJson(ret.data);

    if (r.code != 0) {
      throw r.message;
    }

    for (final e in r.data.medias) {
      if (e.page == 1) {
        l.add(
          MusicListItemBv(
            bvid: e.bvid,
            title: e.title,
            artist: e.upper.name,
            categoryKey: categoryKey,
            cid: e.ugc.firstCid,
            coverUrl: e.cover,
          ),
        );
      } else {
        final v = await MusicListItemBv.fetchBv(
          bvid: e.bvid,
          categoryKey: categoryKey,
        );
        l.addAll(v);
      }
    }

    hasMore = r.data.hasMore;
    curp++;
    onProgress?.call(curp);
    await Future.delayed(fetchInterval);
  }

  return l;
}
