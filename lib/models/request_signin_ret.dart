import 'dart:convert';

class RequestSignInRet {
  int code;
  String message;
  int ttl;
  Data data;

  RequestSignInRet({
    required this.code,
    required this.message,
    required this.ttl,
    required this.data,
  });

  factory RequestSignInRet.fromRawJson(String str) =>
      RequestSignInRet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequestSignInRet.fromJson(Map<String, dynamic> json) =>
      RequestSignInRet(
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
  String refreshToken;
  int timestamp;
  int code;
  String message;

  Data({
    required this.url,
    required this.refreshToken,
    required this.timestamp,
    required this.code,
    required this.message,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    url: json["url"],
    refreshToken: json["refresh_token"],
    timestamp: json["timestamp"],
    code: json["code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "refresh_token": refreshToken,
    "timestamp": timestamp,
    "code": code,
    "message": message,
  };
}
