import 'dart:convert';

class NavRet {
  int code;
  String message;
  int ttl;
  Data data;

  NavRet({
    required this.code,
    required this.message,
    required this.ttl,
    required this.data,
  });

  factory NavRet.fromRawJson(String str) => NavRet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NavRet.fromJson(Map<String, dynamic> json) => NavRet(
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
  bool isLogin;
  WbiImg wbiImg;
  String ipRegion;

  Data({required this.isLogin, required this.wbiImg, required this.ipRegion});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    isLogin: json["isLogin"],
    wbiImg: WbiImg.fromJson(json["wbi_img"]),
    ipRegion: json["ip_region"],
  );

  Map<String, dynamic> toJson() => {
    "isLogin": isLogin,
    "wbi_img": wbiImg.toJson(),
    "ip_region": ipRegion,
  };
}

class WbiImg {
  String imgUrl;
  String subUrl;

  WbiImg({required this.imgUrl, required this.subUrl});

  factory WbiImg.fromRawJson(String str) => WbiImg.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WbiImg.fromJson(Map<String, dynamic> json) =>
      WbiImg(imgUrl: json["img_url"], subUrl: json["sub_url"]);

  Map<String, dynamic> toJson() => {"img_url": imgUrl, "sub_url": subUrl};
}
