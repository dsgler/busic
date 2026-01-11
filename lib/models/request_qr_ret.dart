import 'dart:convert';

class RequestQrRet {
  int code;
  String message;
  int ttl;
  Data data;

  RequestQrRet({
    required this.code,
    required this.message,
    required this.ttl,
    required this.data,
  });

  factory RequestQrRet.fromRawJson(String str) =>
      RequestQrRet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequestQrRet.fromJson(Map<String, dynamic> json) => RequestQrRet(
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
  String url;
  String qrcodeKey;

  Data({required this.url, required this.qrcodeKey});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(url: json["url"], qrcodeKey: json["qrcode_key"]);

  Map<String, dynamic> toJson() => {"url": url, "qrcode_key": qrcodeKey};
}
