import 'dart:convert';
import '../network/request.dart';

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

  static Future<NavRet> fetch() async {
    final r = await dio.get('https://api.bilibili.com/x/web-interface/nav');
    return NavRet.fromJson(r.data);
  }

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
  String face;
  int mid;
  String uname;
  WbiImg wbiImg;

  Data({
    required this.isLogin,
    required this.face,
    required this.mid,
    required this.uname,
    required this.wbiImg,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    isLogin: json["isLogin"],
    face: json["face"],
    mid: json["mid"],
    uname: json["uname"],
    wbiImg: WbiImg.fromJson(json["wbi_img"]),
  );

  Map<String, dynamic> toJson() => {
    "isLogin": isLogin,
    "face": face,
    "mid": mid,
    "uname": uname,
    "wbi_img": wbiImg.toJson(),
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
