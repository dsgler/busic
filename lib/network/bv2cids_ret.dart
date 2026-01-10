import 'dart:convert';

class Bv2CidsRet {
  int code;
  String message;
  int ttl;
  List<Datum> data;

  Bv2CidsRet({
    required this.code,
    required this.message,
    required this.ttl,
    required this.data,
  });

  factory Bv2CidsRet.fromRawJson(String str) =>
      Bv2CidsRet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Bv2CidsRet.fromJson(Map<String, dynamic> json) => Bv2CidsRet(
    code: json["code"],
    message: json["message"],
    ttl: json["ttl"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "ttl": ttl,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int cid;
  int page;
  String from;
  String datumPart;
  int duration;
  String vid;
  String weblink;
  Dimension dimension;
  String firstFrame;
  int ctime;

  Datum({
    required this.cid,
    required this.page,
    required this.from,
    required this.datumPart,
    required this.duration,
    required this.vid,
    required this.weblink,
    required this.dimension,
    required this.firstFrame,
    required this.ctime,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    cid: json["cid"],
    page: json["page"],
    from: json["from"],
    datumPart: json["part"],
    duration: json["duration"],
    vid: json["vid"],
    weblink: json["weblink"],
    dimension: Dimension.fromJson(json["dimension"]),
    firstFrame: json["first_frame"],
    ctime: json["ctime"],
  );

  Map<String, dynamic> toJson() => {
    "cid": cid,
    "page": page,
    "from": from,
    "part": datumPart,
    "duration": duration,
    "vid": vid,
    "weblink": weblink,
    "dimension": dimension.toJson(),
    "first_frame": firstFrame,
    "ctime": ctime,
  };
}

class Dimension {
  int width;
  int height;
  int rotate;

  Dimension({required this.width, required this.height, required this.rotate});

  factory Dimension.fromRawJson(String str) =>
      Dimension.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Dimension.fromJson(Map<String, dynamic> json) => Dimension(
    width: json["width"],
    height: json["height"],
    rotate: json["rotate"],
  );

  Map<String, dynamic> toJson() => {
    "width": width,
    "height": height,
    "rotate": rotate,
  };
}
