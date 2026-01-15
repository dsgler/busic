import 'package:busic/models/fav_list_ret.dart';
import 'package:busic/models/music_list_item.dart';
import 'package:busic/models/user_pref.dart';
import 'package:busic/network/request.dart';

Future<List<MusicListItemBv>> fetchFavList(String media_id) async {
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
            category: MusicListMode.favList,
            cid: e.ugc.firstCid,
            coverUrl: e.cover,
          ),
        );
      } else {
        final v = await MusicListItemBv.fetchBv(
          bvid: e.bvid,
          mode: MusicListMode.favList,
        );
        l.addAll(v);
      }
    }

    hasMore = r.data.hasMore;
    curp++;
    await Future.delayed(Duration(milliseconds: 500));
  }

  return l;
}
