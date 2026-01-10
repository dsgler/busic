import 'dart:convert';

class VideoUrlRet {
  int code;
  String message;
  int ttl;
  Data data;

  VideoUrlRet({
    required this.code,
    required this.message,
    required this.ttl,
    required this.data,
  });

  factory VideoUrlRet.fromRawJson(String str) =>
      VideoUrlRet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VideoUrlRet.fromJson(Map<String, dynamic> json) => VideoUrlRet(
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
  String from;
  String result;
  String message;
  int quality;
  String format;
  int timelength;
  String acceptFormat;
  List<String> acceptDescription;
  List<int> acceptQuality;
  int videoCodecid;
  String seekParam;
  String seekType;
  Dash dash;
  List<SupportFormat> supportFormats;
  dynamic highFormat;
  int lastPlayTime;
  int lastPlayCid;
  dynamic viewInfo;
  PlayConf playConf;
  String curLanguage;
  int curProductionType;
  AutoQnResp autoQnResp;

  Data({
    required this.from,
    required this.result,
    required this.message,
    required this.quality,
    required this.format,
    required this.timelength,
    required this.acceptFormat,
    required this.acceptDescription,
    required this.acceptQuality,
    required this.videoCodecid,
    required this.seekParam,
    required this.seekType,
    required this.dash,
    required this.supportFormats,
    required this.highFormat,
    required this.lastPlayTime,
    required this.lastPlayCid,
    required this.viewInfo,
    required this.playConf,
    required this.curLanguage,
    required this.curProductionType,
    required this.autoQnResp,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    from: json["from"],
    result: json["result"],
    message: json["message"],
    quality: json["quality"],
    format: json["format"],
    timelength: json["timelength"],
    acceptFormat: json["accept_format"],
    acceptDescription: List<String>.from(
      json["accept_description"].map((x) => x),
    ),
    acceptQuality: List<int>.from(json["accept_quality"].map((x) => x)),
    videoCodecid: json["video_codecid"],
    seekParam: json["seek_param"],
    seekType: json["seek_type"],
    dash: Dash.fromJson(json["dash"]),
    supportFormats: List<SupportFormat>.from(
      json["support_formats"].map((x) => SupportFormat.fromJson(x)),
    ),
    highFormat: json["high_format"],
    lastPlayTime: json["last_play_time"],
    lastPlayCid: json["last_play_cid"],
    viewInfo: json["view_info"],
    playConf: PlayConf.fromJson(json["play_conf"]),
    curLanguage: json["cur_language"],
    curProductionType: json["cur_production_type"],
    autoQnResp: AutoQnResp.fromJson(json["auto_qn_resp"]),
  );

  Map<String, dynamic> toJson() => {
    "from": from,
    "result": result,
    "message": message,
    "quality": quality,
    "format": format,
    "timelength": timelength,
    "accept_format": acceptFormat,
    "accept_description": List<dynamic>.from(acceptDescription.map((x) => x)),
    "accept_quality": List<dynamic>.from(acceptQuality.map((x) => x)),
    "video_codecid": videoCodecid,
    "seek_param": seekParam,
    "seek_type": seekType,
    "dash": dash.toJson(),
    "support_formats": List<dynamic>.from(
      supportFormats.map((x) => x.toJson()),
    ),
    "high_format": highFormat,
    "last_play_time": lastPlayTime,
    "last_play_cid": lastPlayCid,
    "view_info": viewInfo,
    "play_conf": playConf.toJson(),
    "cur_language": curLanguage,
    "cur_production_type": curProductionType,
    "auto_qn_resp": autoQnResp.toJson(),
  };
}

class AutoQnResp {
  String dyeid;

  AutoQnResp({required this.dyeid});

  factory AutoQnResp.fromRawJson(String str) =>
      AutoQnResp.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AutoQnResp.fromJson(Map<String, dynamic> json) =>
      AutoQnResp(dyeid: json["dyeid"]);

  Map<String, dynamic> toJson() => {"dyeid": dyeid};
}

class Dash {
  int duration;
  double minBufferTime;
  double dashMinBufferTime;
  List<Audio> video;
  List<Audio> audio;
  Dolby dolby;
  dynamic flac;

  Dash({
    required this.duration,
    required this.minBufferTime,
    required this.dashMinBufferTime,
    required this.video,
    required this.audio,
    required this.dolby,
    required this.flac,
  });

  factory Dash.fromRawJson(String str) => Dash.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Dash.fromJson(Map<String, dynamic> json) => Dash(
    duration: json["duration"],
    minBufferTime: json["minBufferTime"]?.toDouble(),
    dashMinBufferTime: json["min_buffer_time"]?.toDouble(),
    video: List<Audio>.from(json["video"].map((x) => Audio.fromJson(x))),
    audio: List<Audio>.from(json["audio"].map((x) => Audio.fromJson(x))),
    dolby: Dolby.fromJson(json["dolby"]),
    flac: json["flac"],
  );

  Map<String, dynamic> toJson() => {
    "duration": duration,
    "minBufferTime": minBufferTime,
    "min_buffer_time": dashMinBufferTime,
    "video": List<dynamic>.from(video.map((x) => x.toJson())),
    "audio": List<dynamic>.from(audio.map((x) => x.toJson())),
    "dolby": dolby.toJson(),
    "flac": flac,
  };
}

class Audio {
  int id;
  String baseUrl;
  String audioBaseUrl;
  List<String> backupUrl;
  List<String> audioBackupUrl;
  int bandwidth;
  String mimeType;
  String audioMimeType;
  String codecs;
  int width;
  int height;
  String frameRate;
  String audioFrameRate;
  String sar;
  int startWithSap;
  int audioStartWithSap;
  SegmentBase segmentBase;
  SegmentBaseClass audioSegmentBase;
  int codecid;

  Audio({
    required this.id,
    required this.baseUrl,
    required this.audioBaseUrl,
    required this.backupUrl,
    required this.audioBackupUrl,
    required this.bandwidth,
    required this.mimeType,
    required this.audioMimeType,
    required this.codecs,
    required this.width,
    required this.height,
    required this.frameRate,
    required this.audioFrameRate,
    required this.sar,
    required this.startWithSap,
    required this.audioStartWithSap,
    required this.segmentBase,
    required this.audioSegmentBase,
    required this.codecid,
  });

  factory Audio.fromRawJson(String str) => Audio.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
    id: json["id"],
    baseUrl: json["baseUrl"],
    audioBaseUrl: json["base_url"],
    backupUrl: List<String>.from(json["backupUrl"].map((x) => x)),
    audioBackupUrl: List<String>.from(json["backup_url"].map((x) => x)),
    bandwidth: json["bandwidth"],
    mimeType: json["mimeType"],
    audioMimeType: json["mime_type"],
    codecs: json["codecs"],
    width: json["width"],
    height: json["height"],
    frameRate: json["frameRate"],
    audioFrameRate: json["frame_rate"],
    sar: json["sar"],
    startWithSap: json["startWithSap"],
    audioStartWithSap: json["start_with_sap"],
    segmentBase: SegmentBase.fromJson(json["SegmentBase"]),
    audioSegmentBase: SegmentBaseClass.fromJson(json["segment_base"]),
    codecid: json["codecid"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "baseUrl": baseUrl,
    "base_url": audioBaseUrl,
    "backupUrl": List<dynamic>.from(backupUrl.map((x) => x)),
    "backup_url": List<dynamic>.from(audioBackupUrl.map((x) => x)),
    "bandwidth": bandwidth,
    "mimeType": mimeType,
    "mime_type": audioMimeType,
    "codecs": codecs,
    "width": width,
    "height": height,
    "frameRate": frameRate,
    "frame_rate": audioFrameRate,
    "sar": sar,
    "startWithSap": startWithSap,
    "start_with_sap": audioStartWithSap,
    "SegmentBase": segmentBase.toJson(),
    "segment_base": audioSegmentBase.toJson(),
    "codecid": codecid,
  };
}

class SegmentBaseClass {
  String initialization;
  String indexRange;

  SegmentBaseClass({required this.initialization, required this.indexRange});

  factory SegmentBaseClass.fromRawJson(String str) =>
      SegmentBaseClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SegmentBaseClass.fromJson(Map<String, dynamic> json) =>
      SegmentBaseClass(
        initialization: json["initialization"],
        indexRange: json["index_range"],
      );

  Map<String, dynamic> toJson() => {
    "initialization": initialization,
    "index_range": indexRange,
  };
}

class SegmentBase {
  String initialization;
  String indexRange;

  SegmentBase({required this.initialization, required this.indexRange});

  factory SegmentBase.fromRawJson(String str) =>
      SegmentBase.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SegmentBase.fromJson(Map<String, dynamic> json) => SegmentBase(
    initialization: json["Initialization"],
    indexRange: json["indexRange"],
  );

  Map<String, dynamic> toJson() => {
    "Initialization": initialization,
    "indexRange": indexRange,
  };
}

class Dolby {
  int type;
  dynamic audio;

  Dolby({required this.type, required this.audio});

  factory Dolby.fromRawJson(String str) => Dolby.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Dolby.fromJson(Map<String, dynamic> json) =>
      Dolby(type: json["type"], audio: json["audio"]);

  Map<String, dynamic> toJson() => {"type": type, "audio": audio};
}

class PlayConf {
  bool isNewDescription;

  PlayConf({required this.isNewDescription});

  factory PlayConf.fromRawJson(String str) =>
      PlayConf.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlayConf.fromJson(Map<String, dynamic> json) =>
      PlayConf(isNewDescription: json["is_new_description"]);

  Map<String, dynamic> toJson() => {"is_new_description": isNewDescription};
}

class SupportFormat {
  int quality;
  String format;
  String newDescription;
  String displayDesc;
  String superscript;
  List<String> codecs;
  int canWatchQnReason;
  int limitWatchReason;
  Report report;

  SupportFormat({
    required this.quality,
    required this.format,
    required this.newDescription,
    required this.displayDesc,
    required this.superscript,
    required this.codecs,
    required this.canWatchQnReason,
    required this.limitWatchReason,
    required this.report,
  });

  factory SupportFormat.fromRawJson(String str) =>
      SupportFormat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SupportFormat.fromJson(Map<String, dynamic> json) => SupportFormat(
    quality: json["quality"],
    format: json["format"],
    newDescription: json["new_description"],
    displayDesc: json["display_desc"],
    superscript: json["superscript"],
    codecs: List<String>.from(json["codecs"].map((x) => x)),
    canWatchQnReason: json["can_watch_qn_reason"],
    limitWatchReason: json["limit_watch_reason"],
    report: Report.fromJson(json["report"]),
  );

  Map<String, dynamic> toJson() => {
    "quality": quality,
    "format": format,
    "new_description": newDescription,
    "display_desc": displayDesc,
    "superscript": superscript,
    "codecs": List<dynamic>.from(codecs.map((x) => x)),
    "can_watch_qn_reason": canWatchQnReason,
    "limit_watch_reason": limitWatchReason,
    "report": report.toJson(),
  };
}

class Report {
  Report();

  factory Report.fromRawJson(String str) => Report.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Report.fromJson(Map<String, dynamic> json) => Report();

  Map<String, dynamic> toJson() => {};
}
