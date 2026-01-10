import 'dart:convert';
import 'package:busic/consts/network.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './request.dart';

class WbiToken {
  String imgKey;
  String subKey;
  int time;

  WbiToken({required this.imgKey, required this.subKey, this.time = 0});

  factory WbiToken.fromRawJson(String str) =>
      WbiToken.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WbiToken.fromJson(Map<String, dynamic> json) => WbiToken(
    imgKey: json["img_key"],
    subKey: json["sub_key"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "img_key": imgKey,
    "sub_key": subKey,
    "time": time,
  };

  static final re = RegExp(r'wbi\/([0-9a-zA-z]+)\.png');
  static final kvKey = "WbiToken027";

  static Future<WbiToken> fetchWithCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(kvKey);

    if (json != null) {
      final w = WbiToken.fromRawJson(json);
      if (DateTime.now().microsecondsSinceEpoch - w.time < expireTime) {
        return w;
      }
    }

    final ret = await dio.get('https://api.bilibili.com/x/web-interface/nav');
    final w = WbiToken(
      imgKey: re.firstMatch(ret.data['data']['wbi_img']['img_url'])![1]!,
      subKey: re.firstMatch(ret.data['data']['wbi_img']['sub_url'])![1]!,
    );
    prefs.setString(kvKey, w.toRawJson());

    return w;
  }
}

class WbiUtils {
  static const List<int> mixinKeyEncTab = [
    46,
    47,
    18,
    2,
    53,
    8,
    23,
    32,
    15,
    50,
    10,
    31,
    58,
    3,
    45,
    35,
    27,
    43,
    5,
    49,
    33,
    9,
    42,
    19,
    29,
    28,
    14,
    39,
    12,
    38,
    41,
    13,
    37,
    48,
    7,
    16,
    24,
    55,
    40,
    61,
    26,
    17,
    0,
    1,
    60,
    51,
    30,
    4,
    22,
    25,
    54,
    21,
    56,
    59,
    6,
    63,
    57,
    62,
    11,
    36,
    20,
    34,
    44,
    52,
  ];

  /// 计算字符串的MD5哈希值
  static String md5Hash(String input) {
    final bytes = utf8.encode(input);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  /// 根据混淆表生成混淆密钥
  static String getMixinKey(String imgKey, String subKey) {
    final s = imgKey + subKey;
    final key = StringBuffer();
    for (int i = 0; i < 32; i++) {
      key.write(s[mixinKeyEncTab[i]]);
    }
    return key.toString();
  }

  /// URL编码（类似JavaScript的encodeURIComponent）
  static String encodeURIComponent(Object o) {
    return Uri.encodeComponent(o.toString());
  }

  /// 生成WBI签名参数
  static Map<String, dynamic> generateWbiSign(
    Map<String, dynamic> params,
    WbiToken wbiToken,
  ) {
    final mixinKey = getMixinKey(wbiToken.imgKey, wbiToken.subKey);

    // 添加时间戳
    final paramsWithTime = Map<String, dynamic>.from(params);
    paramsWithTime['wts'] = (DateTime.now().millisecondsSinceEpoch / 1000)
        .floor();

    // 按key排序
    final sortedKeys = paramsWithTime.keys.toList()..sort();

    // 生成查询字符串
    final queryString = sortedKeys
        .map((key) => '$key=${encodeURIComponent(paramsWithTime[key])}')
        .join('&');

    // 计算签名
    final s = queryString + mixinKey;
    final wbiSign = md5Hash(s);

    paramsWithTime['w_rid'] = wbiSign;

    return paramsWithTime;

    // return '$queryString&w_rid=$wbiSign';
  }
}
