import 'dart:convert';

class FavListRet {
  int code;
  String message;
  int ttl;
  Data data;

  FavListRet({
    required this.code,
    required this.message,
    required this.ttl,
    required this.data,
  });

  factory FavListRet.fromRawJson(String str) =>
      FavListRet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FavListRet.fromJson(Map<String, dynamic> json) => FavListRet(
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
  Info info;
  List<Media> medias;
  bool hasMore;
  int ttl;

  Data({
    required this.info,
    required this.medias,
    required this.hasMore,
    required this.ttl,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    info: Info.fromJson(json["info"]),
    medias: List<Media>.from(json["medias"].map((x) => Media.fromJson(x))),
    hasMore: json["has_more"],
    ttl: json["ttl"],
  );

  Map<String, dynamic> toJson() => {
    "info": info.toJson(),
    "medias": List<dynamic>.from(medias.map((x) => x.toJson())),
    "has_more": hasMore,
    "ttl": ttl,
  };
}

class Info {
  int id;
  int fid;
  int mid;
  int attr;
  String title;
  String cover;
  InfoUpper upper;
  int coverType;
  InfoCntInfo cntInfo;
  int type;
  String intro;
  int ctime;
  int mtime;
  int state;
  int favState;
  int likeState;
  int mediaCount;
  bool isTop;

  Info({
    required this.id,
    required this.fid,
    required this.mid,
    required this.attr,
    required this.title,
    required this.cover,
    required this.upper,
    required this.coverType,
    required this.cntInfo,
    required this.type,
    required this.intro,
    required this.ctime,
    required this.mtime,
    required this.state,
    required this.favState,
    required this.likeState,
    required this.mediaCount,
    required this.isTop,
  });

  factory Info.fromRawJson(String str) => Info.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    id: json["id"],
    fid: json["fid"],
    mid: json["mid"],
    attr: json["attr"],
    title: json["title"],
    cover: json["cover"],
    upper: InfoUpper.fromJson(json["upper"]),
    coverType: json["cover_type"],
    cntInfo: InfoCntInfo.fromJson(json["cnt_info"]),
    type: json["type"],
    intro: json["intro"],
    ctime: json["ctime"],
    mtime: json["mtime"],
    state: json["state"],
    favState: json["fav_state"],
    likeState: json["like_state"],
    mediaCount: json["media_count"],
    isTop: json["is_top"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fid": fid,
    "mid": mid,
    "attr": attr,
    "title": title,
    "cover": cover,
    "upper": upper.toJson(),
    "cover_type": coverType,
    "cnt_info": cntInfo.toJson(),
    "type": type,
    "intro": intro,
    "ctime": ctime,
    "mtime": mtime,
    "state": state,
    "fav_state": favState,
    "like_state": likeState,
    "media_count": mediaCount,
    "is_top": isTop,
  };
}

class InfoCntInfo {
  int collect;
  int play;
  int thumbUp;
  int share;

  InfoCntInfo({
    required this.collect,
    required this.play,
    required this.thumbUp,
    required this.share,
  });

  factory InfoCntInfo.fromRawJson(String str) =>
      InfoCntInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InfoCntInfo.fromJson(Map<String, dynamic> json) => InfoCntInfo(
    collect: json["collect"],
    play: json["play"],
    thumbUp: json["thumb_up"],
    share: json["share"],
  );

  Map<String, dynamic> toJson() => {
    "collect": collect,
    "play": play,
    "thumb_up": thumbUp,
    "share": share,
  };
}

class InfoUpper {
  int mid;
  String name;
  String face;
  bool followed;
  int vipType;
  int vipStatue;

  InfoUpper({
    required this.mid,
    required this.name,
    required this.face,
    required this.followed,
    required this.vipType,
    required this.vipStatue,
  });

  factory InfoUpper.fromRawJson(String str) =>
      InfoUpper.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InfoUpper.fromJson(Map<String, dynamic> json) => InfoUpper(
    mid: json["mid"],
    name: json["name"],
    face: json["face"],
    followed: json["followed"],
    vipType: json["vip_type"],
    vipStatue: json["vip_statue"],
  );

  Map<String, dynamic> toJson() => {
    "mid": mid,
    "name": name,
    "face": face,
    "followed": followed,
    "vip_type": vipType,
    "vip_statue": vipStatue,
  };
}

class Media {
  int id;
  int type;
  String title;
  String cover;
  String intro;
  int page;
  int duration;
  MediaUpper upper;
  int attr;
  MediaCntInfo cntInfo;
  String link;
  int ctime;
  int pubtime;
  int favTime;
  String bvId;
  String bvid;
  dynamic season;
  dynamic ogv;
  Ugc ugc;
  String mediaListLink;

  Media({
    required this.id,
    required this.type,
    required this.title,
    required this.cover,
    required this.intro,
    required this.page,
    required this.duration,
    required this.upper,
    required this.attr,
    required this.cntInfo,
    required this.link,
    required this.ctime,
    required this.pubtime,
    required this.favTime,
    required this.bvId,
    required this.bvid,
    required this.season,
    required this.ogv,
    required this.ugc,
    required this.mediaListLink,
  });

  factory Media.fromRawJson(String str) => Media.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: json["id"],
    type: json["type"],
    title: json["title"],
    cover: json["cover"],
    intro: json["intro"],
    page: json["page"],
    duration: json["duration"],
    upper: MediaUpper.fromJson(json["upper"]),
    attr: json["attr"],
    cntInfo: MediaCntInfo.fromJson(json["cnt_info"]),
    link: json["link"],
    ctime: json["ctime"],
    pubtime: json["pubtime"],
    favTime: json["fav_time"],
    bvId: json["bv_id"],
    bvid: json["bvid"],
    season: json["season"],
    ogv: json["ogv"],
    ugc: Ugc.fromJson(json["ugc"]),
    mediaListLink: json["media_list_link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "title": title,
    "cover": cover,
    "intro": intro,
    "page": page,
    "duration": duration,
    "upper": upper.toJson(),
    "attr": attr,
    "cnt_info": cntInfo.toJson(),
    "link": link,
    "ctime": ctime,
    "pubtime": pubtime,
    "fav_time": favTime,
    "bv_id": bvId,
    "bvid": bvid,
    "season": season,
    "ogv": ogv,
    "ugc": ugc.toJson(),
    "media_list_link": mediaListLink,
  };
}

class MediaCntInfo {
  int collect;
  int play;
  int danmaku;
  int vt;
  int playSwitch;
  int reply;
  String viewText1;

  MediaCntInfo({
    required this.collect,
    required this.play,
    required this.danmaku,
    required this.vt,
    required this.playSwitch,
    required this.reply,
    required this.viewText1,
  });

  factory MediaCntInfo.fromRawJson(String str) =>
      MediaCntInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MediaCntInfo.fromJson(Map<String, dynamic> json) => MediaCntInfo(
    collect: json["collect"],
    play: json["play"],
    danmaku: json["danmaku"],
    vt: json["vt"],
    playSwitch: json["play_switch"],
    reply: json["reply"],
    viewText1: json["view_text_1"],
  );

  Map<String, dynamic> toJson() => {
    "collect": collect,
    "play": play,
    "danmaku": danmaku,
    "vt": vt,
    "play_switch": playSwitch,
    "reply": reply,
    "view_text_1": viewText1,
  };
}

class Ugc {
  int firstCid;

  Ugc({required this.firstCid});

  factory Ugc.fromRawJson(String str) => Ugc.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ugc.fromJson(Map<String, dynamic> json) =>
      Ugc(firstCid: json["first_cid"]);

  Map<String, dynamic> toJson() => {"first_cid": firstCid};
}

class MediaUpper {
  int mid;
  String name;
  String face;
  String jumpLink;

  MediaUpper({
    required this.mid,
    required this.name,
    required this.face,
    required this.jumpLink,
  });

  factory MediaUpper.fromRawJson(String str) =>
      MediaUpper.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MediaUpper.fromJson(Map<String, dynamic> json) => MediaUpper(
    mid: json["mid"],
    name: json["name"],
    face: json["face"],
    jumpLink: json["jump_link"],
  );

  Map<String, dynamic> toJson() => {
    "mid": mid,
    "name": name,
    "face": face,
    "jump_link": jumpLink,
  };
}
