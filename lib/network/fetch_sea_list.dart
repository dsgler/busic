import 'package:busic/consts/network.dart';
import 'package:busic/models/music_list_item.dart';
import 'package:busic/models/seasons_archives_list_ret.dart';
import 'package:busic/models/user_pref.dart';
import 'package:busic/network/request.dart';

Future<List<MusicListItemBv>> fetchSeaList(
  String season_id, {
  void Function(int progress)? onProgress,
}) async {
  var curp = 1;
  final List<MusicListItemBv> l = [];
  var hasMore = true;
  while (hasMore) {
    final ret = await dio.get(
      'https://api.bilibili.com/x/polymer/web-space/seasons_archives_list',
      queryParameters: {
        'season_id': season_id,
        'page_num': curp,
        'page_size': '20',
      },
    );
    final r = SeasonsArchivesListRet.fromJson(ret.data);

    if (r.code != 0) {
      throw r.message;
    }

    for (final e in r.data.archives) {
      final v = await MusicListItemBv.fetchBv(
        bvid: e.bvid,
        mode: MusicListMode.seasonsArchives,
      );
      l.addAll(v);
    }

    hasMore = r.data.page.pageNum * r.data.page.pageSize < r.data.page.total;
    curp++;
    onProgress?.call(curp);
    await Future.delayed(fetchInterval);
  }

  return l;
}
