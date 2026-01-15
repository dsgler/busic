import 'dart:convert';

class SeasonsArchivesListRet {
  int code;
  String message;
  int ttl;
  Data data;

  SeasonsArchivesListRet({
    required this.code,
    required this.message,
    required this.ttl,
    required this.data,
  });

  factory SeasonsArchivesListRet.fromRawJson(String str) =>
      SeasonsArchivesListRet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SeasonsArchivesListRet.fromJson(Map<String, dynamic> json) =>
      SeasonsArchivesListRet(
        code: json["code"],
        message: json["message"],
        ttl: json["ttl"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "ttl": ttl,
    "data": data.toJson(),
  };
}

class Data {
  List<int> aids;
  List<Archive> archives;
  Meta meta;
  Page page;

  Data({
    required this.aids,
    required this.archives,
    required this.meta,
    required this.page,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    aids: List<int>.from(json["aids"].map((x) => x)),
    archives: List<Archive>.from(
      json["archives"].map((x) => Archive.fromJson(x)),
    ),
    meta: Meta.fromJson(json["meta"]),
    page: Page.fromJson(json["page"]),
  );

  Map<String, dynamic> toJson() => {
    "aids": List<dynamic>.from(aids.map((x) => x)),
    "archives": List<dynamic>.from(archives.map((x) => x.toJson())),
    "meta": meta.toJson(),
    "page": page.toJson(),
  };
}

class Archive {
  int aid;
  String bvid;
  int ctime;
  int duration;
  bool enableVt;
  bool interactiveVideo;
  String pic;
  int playbackPosition;
  int pubdate;
  Stat stat;
  int state;
  String title;
  int ugcPay;
  String vtDisplay;
  int isLessonVideo;

  Archive({
    required this.aid,
    required this.bvid,
    required this.ctime,
    required this.duration,
    required this.enableVt,
    required this.interactiveVideo,
    required this.pic,
    required this.playbackPosition,
    required this.pubdate,
    required this.stat,
    required this.state,
    required this.title,
    required this.ugcPay,
    required this.vtDisplay,
    required this.isLessonVideo,
  });

  factory Archive.fromRawJson(String str) => Archive.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Archive.fromJson(Map<String, dynamic> json) => Archive(
    aid: json["aid"],
    bvid: json["bvid"],
    ctime: json["ctime"],
    duration: json["duration"],
    enableVt: json["enable_vt"],
    interactiveVideo: json["interactive_video"],
    pic: json["pic"],
    playbackPosition: json["playback_position"],
    pubdate: json["pubdate"],
    stat: Stat.fromJson(json["stat"]),
    state: json["state"],
    title: json["title"],
    ugcPay: json["ugc_pay"],
    vtDisplay: json["vt_display"],
    isLessonVideo: json["is_lesson_video"],
  );

  Map<String, dynamic> toJson() => {
    "aid": aid,
    "bvid": bvid,
    "ctime": ctime,
    "duration": duration,
    "enable_vt": enableVt,
    "interactive_video": interactiveVideo,
    "pic": pic,
    "playback_position": playbackPosition,
    "pubdate": pubdate,
    "stat": stat.toJson(),
    "state": state,
    "title": title,
    "ugc_pay": ugcPay,
    "vt_display": vtDisplay,
    "is_lesson_video": isLessonVideo,
  };
}

class Stat {
  int view;
  int vt;
  int danmaku;

  Stat({required this.view, required this.vt, required this.danmaku});

  factory Stat.fromRawJson(String str) => Stat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Stat.fromJson(Map<String, dynamic> json) =>
      Stat(view: json["view"], vt: json["vt"], danmaku: json["danmaku"]);

  Map<String, dynamic> toJson() => {"view": view, "vt": vt, "danmaku": danmaku};
}

class Meta {
  int category;
  String cover;
  String description;
  int mid;
  String name;
  int ptime;
  int seasonId;
  int total;
  String title;

  Meta({
    required this.category,
    required this.cover,
    required this.description,
    required this.mid,
    required this.name,
    required this.ptime,
    required this.seasonId,
    required this.total,
    required this.title,
  });

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    category: json["category"],
    cover: json["cover"],
    description: json["description"],
    mid: json["mid"],
    name: json["name"],
    ptime: json["ptime"],
    seasonId: json["season_id"],
    total: json["total"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "category": category,
    "cover": cover,
    "description": description,
    "mid": mid,
    "name": name,
    "ptime": ptime,
    "season_id": seasonId,
    "total": total,
    "title": title,
  };
}

class Page {
  int pageNum;
  int pageSize;
  int total;

  Page({required this.pageNum, required this.pageSize, required this.total});

  factory Page.fromRawJson(String str) => Page.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Page.fromJson(Map<String, dynamic> json) => Page(
    pageNum: json["page_num"],
    pageSize: json["page_size"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "page_num": pageNum,
    "page_size": pageSize,
    "total": total,
  };
}
