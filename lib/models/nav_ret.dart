import 'dart:convert';
import '../network/request.dart';

class NavRet {
  int code;
  String message;
  int ttl;
  Data data;

  static Future<NavRet> fetch() async {
    final r = await dio.get('https://api.bilibili.com/x/web-interface/nav');
    return NavRet.fromJson(r.data);
  }

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
  int emailVerified;
  String face;
  int faceNft;
  int faceNftType;
  LevelInfo levelInfo;
  int mid;
  int mobileVerified;
  double money;
  int moral;
  Official official;
  OfficialVerify officialVerify;
  Pendant pendant;
  int scores;
  String uname;
  int vipDueDate;
  int vipStatus;
  int vipType;
  int vipPayType;
  int vipThemeType;
  Label vipLabel;
  int vipAvatarSubscript;
  String vipNicknameColor;
  Vip vip;
  Wallet wallet;
  bool hasShop;
  String shopUrl;
  int answerStatus;
  int isSeniorMember;
  WbiImg wbiImg;
  bool isJury;
  dynamic nameRender;
  String legalRegion;
  String ipRegion;

  Data({
    required this.isLogin,
    required this.emailVerified,
    required this.face,
    required this.faceNft,
    required this.faceNftType,
    required this.levelInfo,
    required this.mid,
    required this.mobileVerified,
    required this.money,
    required this.moral,
    required this.official,
    required this.officialVerify,
    required this.pendant,
    required this.scores,
    required this.uname,
    required this.vipDueDate,
    required this.vipStatus,
    required this.vipType,
    required this.vipPayType,
    required this.vipThemeType,
    required this.vipLabel,
    required this.vipAvatarSubscript,
    required this.vipNicknameColor,
    required this.vip,
    required this.wallet,
    required this.hasShop,
    required this.shopUrl,
    required this.answerStatus,
    required this.isSeniorMember,
    required this.wbiImg,
    required this.isJury,
    required this.nameRender,
    required this.legalRegion,
    required this.ipRegion,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    isLogin: json["isLogin"],
    emailVerified: json["email_verified"],
    face: json["face"],
    faceNft: json["face_nft"],
    faceNftType: json["face_nft_type"],
    levelInfo: LevelInfo.fromJson(json["level_info"]),
    mid: json["mid"],
    mobileVerified: json["mobile_verified"],
    money: json["money"]?.toDouble(),
    moral: json["moral"],
    official: Official.fromJson(json["official"]),
    officialVerify: OfficialVerify.fromJson(json["officialVerify"]),
    pendant: Pendant.fromJson(json["pendant"]),
    scores: json["scores"],
    uname: json["uname"],
    vipDueDate: json["vipDueDate"],
    vipStatus: json["vipStatus"],
    vipType: json["vipType"],
    vipPayType: json["vip_pay_type"],
    vipThemeType: json["vip_theme_type"],
    vipLabel: Label.fromJson(json["vip_label"]),
    vipAvatarSubscript: json["vip_avatar_subscript"],
    vipNicknameColor: json["vip_nickname_color"],
    vip: Vip.fromJson(json["vip"]),
    wallet: Wallet.fromJson(json["wallet"]),
    hasShop: json["has_shop"],
    shopUrl: json["shop_url"],
    answerStatus: json["answer_status"],
    isSeniorMember: json["is_senior_member"],
    wbiImg: WbiImg.fromJson(json["wbi_img"]),
    isJury: json["is_jury"],
    nameRender: json["name_render"],
    legalRegion: json["legal_region"],
    ipRegion: json["ip_region"],
  );

  Map<String, dynamic> toJson() => {
    "isLogin": isLogin,
    "email_verified": emailVerified,
    "face": face,
    "face_nft": faceNft,
    "face_nft_type": faceNftType,
    "level_info": levelInfo.toJson(),
    "mid": mid,
    "mobile_verified": mobileVerified,
    "money": money,
    "moral": moral,
    "official": official.toJson(),
    "officialVerify": officialVerify.toJson(),
    "pendant": pendant.toJson(),
    "scores": scores,
    "uname": uname,
    "vipDueDate": vipDueDate,
    "vipStatus": vipStatus,
    "vipType": vipType,
    "vip_pay_type": vipPayType,
    "vip_theme_type": vipThemeType,
    "vip_label": vipLabel.toJson(),
    "vip_avatar_subscript": vipAvatarSubscript,
    "vip_nickname_color": vipNicknameColor,
    "vip": vip.toJson(),
    "wallet": wallet.toJson(),
    "has_shop": hasShop,
    "shop_url": shopUrl,
    "answer_status": answerStatus,
    "is_senior_member": isSeniorMember,
    "wbi_img": wbiImg.toJson(),
    "is_jury": isJury,
    "name_render": nameRender,
    "legal_region": legalRegion,
    "ip_region": ipRegion,
  };
}

class LevelInfo {
  int currentLevel;
  int currentMin;
  int currentExp;
  String nextExp;

  LevelInfo({
    required this.currentLevel,
    required this.currentMin,
    required this.currentExp,
    required this.nextExp,
  });

  factory LevelInfo.fromRawJson(String str) =>
      LevelInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LevelInfo.fromJson(Map<String, dynamic> json) => LevelInfo(
    currentLevel: json["current_level"],
    currentMin: json["current_min"],
    currentExp: json["current_exp"],
    nextExp: json["next_exp"],
  );

  Map<String, dynamic> toJson() => {
    "current_level": currentLevel,
    "current_min": currentMin,
    "current_exp": currentExp,
    "next_exp": nextExp,
  };
}

class Official {
  int role;
  String title;
  String desc;
  int type;

  Official({
    required this.role,
    required this.title,
    required this.desc,
    required this.type,
  });

  factory Official.fromRawJson(String str) =>
      Official.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Official.fromJson(Map<String, dynamic> json) => Official(
    role: json["role"],
    title: json["title"],
    desc: json["desc"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "role": role,
    "title": title,
    "desc": desc,
    "type": type,
  };
}

class OfficialVerify {
  int type;
  String desc;

  OfficialVerify({required this.type, required this.desc});

  factory OfficialVerify.fromRawJson(String str) =>
      OfficialVerify.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OfficialVerify.fromJson(Map<String, dynamic> json) =>
      OfficialVerify(type: json["type"], desc: json["desc"]);

  Map<String, dynamic> toJson() => {"type": type, "desc": desc};
}

class Pendant {
  int pid;
  String name;
  String image;
  int expire;
  String imageEnhance;
  String imageEnhanceFrame;
  int nPid;

  Pendant({
    required this.pid,
    required this.name,
    required this.image,
    required this.expire,
    required this.imageEnhance,
    required this.imageEnhanceFrame,
    required this.nPid,
  });

  factory Pendant.fromRawJson(String str) => Pendant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pendant.fromJson(Map<String, dynamic> json) => Pendant(
    pid: json["pid"],
    name: json["name"],
    image: json["image"],
    expire: json["expire"],
    imageEnhance: json["image_enhance"],
    imageEnhanceFrame: json["image_enhance_frame"],
    nPid: json["n_pid"],
  );

  Map<String, dynamic> toJson() => {
    "pid": pid,
    "name": name,
    "image": image,
    "expire": expire,
    "image_enhance": imageEnhance,
    "image_enhance_frame": imageEnhanceFrame,
    "n_pid": nPid,
  };
}

class Vip {
  int type;
  int status;
  int dueDate;
  int vipPayType;
  int themeType;
  Label label;
  int avatarSubscript;
  String nicknameColor;
  int role;
  String avatarSubscriptUrl;
  int tvVipStatus;
  int tvVipPayType;
  int tvDueDate;
  AvatarIcon avatarIcon;
  OttInfo ottInfo;
  SuperVip superVip;

  Vip({
    required this.type,
    required this.status,
    required this.dueDate,
    required this.vipPayType,
    required this.themeType,
    required this.label,
    required this.avatarSubscript,
    required this.nicknameColor,
    required this.role,
    required this.avatarSubscriptUrl,
    required this.tvVipStatus,
    required this.tvVipPayType,
    required this.tvDueDate,
    required this.avatarIcon,
    required this.ottInfo,
    required this.superVip,
  });

  factory Vip.fromRawJson(String str) => Vip.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Vip.fromJson(Map<String, dynamic> json) => Vip(
    type: json["type"],
    status: json["status"],
    dueDate: json["due_date"],
    vipPayType: json["vip_pay_type"],
    themeType: json["theme_type"],
    label: Label.fromJson(json["label"]),
    avatarSubscript: json["avatar_subscript"],
    nicknameColor: json["nickname_color"],
    role: json["role"],
    avatarSubscriptUrl: json["avatar_subscript_url"],
    tvVipStatus: json["tv_vip_status"],
    tvVipPayType: json["tv_vip_pay_type"],
    tvDueDate: json["tv_due_date"],
    avatarIcon: AvatarIcon.fromJson(json["avatar_icon"]),
    ottInfo: OttInfo.fromJson(json["ott_info"]),
    superVip: SuperVip.fromJson(json["super_vip"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "status": status,
    "due_date": dueDate,
    "vip_pay_type": vipPayType,
    "theme_type": themeType,
    "label": label.toJson(),
    "avatar_subscript": avatarSubscript,
    "nickname_color": nicknameColor,
    "role": role,
    "avatar_subscript_url": avatarSubscriptUrl,
    "tv_vip_status": tvVipStatus,
    "tv_vip_pay_type": tvVipPayType,
    "tv_due_date": tvDueDate,
    "avatar_icon": avatarIcon.toJson(),
    "ott_info": ottInfo.toJson(),
    "super_vip": superVip.toJson(),
  };
}

class AvatarIcon {
  IconResource iconResource;

  AvatarIcon({required this.iconResource});

  factory AvatarIcon.fromRawJson(String str) =>
      AvatarIcon.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AvatarIcon.fromJson(Map<String, dynamic> json) =>
      AvatarIcon(iconResource: IconResource.fromJson(json["icon_resource"]));

  Map<String, dynamic> toJson() => {"icon_resource": iconResource.toJson()};
}

class IconResource {
  IconResource();

  factory IconResource.fromRawJson(String str) =>
      IconResource.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IconResource.fromJson(Map<String, dynamic> json) => IconResource();

  Map<String, dynamic> toJson() => {};
}

class Label {
  String path;
  String text;
  String labelTheme;
  String textColor;
  int bgStyle;
  String bgColor;
  String borderColor;
  bool useImgLabel;
  String imgLabelUriHans;
  String imgLabelUriHant;
  String imgLabelUriHansStatic;
  String imgLabelUriHantStatic;
  int labelId;
  dynamic labelGoto;

  Label({
    required this.path,
    required this.text,
    required this.labelTheme,
    required this.textColor,
    required this.bgStyle,
    required this.bgColor,
    required this.borderColor,
    required this.useImgLabel,
    required this.imgLabelUriHans,
    required this.imgLabelUriHant,
    required this.imgLabelUriHansStatic,
    required this.imgLabelUriHantStatic,
    required this.labelId,
    required this.labelGoto,
  });

  factory Label.fromRawJson(String str) => Label.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Label.fromJson(Map<String, dynamic> json) => Label(
    path: json["path"],
    text: json["text"],
    labelTheme: json["label_theme"],
    textColor: json["text_color"],
    bgStyle: json["bg_style"],
    bgColor: json["bg_color"],
    borderColor: json["border_color"],
    useImgLabel: json["use_img_label"],
    imgLabelUriHans: json["img_label_uri_hans"],
    imgLabelUriHant: json["img_label_uri_hant"],
    imgLabelUriHansStatic: json["img_label_uri_hans_static"],
    imgLabelUriHantStatic: json["img_label_uri_hant_static"],
    labelId: json["label_id"],
    labelGoto: json["label_goto"],
  );

  Map<String, dynamic> toJson() => {
    "path": path,
    "text": text,
    "label_theme": labelTheme,
    "text_color": textColor,
    "bg_style": bgStyle,
    "bg_color": bgColor,
    "border_color": borderColor,
    "use_img_label": useImgLabel,
    "img_label_uri_hans": imgLabelUriHans,
    "img_label_uri_hant": imgLabelUriHant,
    "img_label_uri_hans_static": imgLabelUriHansStatic,
    "img_label_uri_hant_static": imgLabelUriHantStatic,
    "label_id": labelId,
    "label_goto": labelGoto,
  };
}

class OttInfo {
  int vipType;
  int payType;
  String payChannelId;
  int status;
  int overdueTime;

  OttInfo({
    required this.vipType,
    required this.payType,
    required this.payChannelId,
    required this.status,
    required this.overdueTime,
  });

  factory OttInfo.fromRawJson(String str) => OttInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OttInfo.fromJson(Map<String, dynamic> json) => OttInfo(
    vipType: json["vip_type"],
    payType: json["pay_type"],
    payChannelId: json["pay_channel_id"],
    status: json["status"],
    overdueTime: json["overdue_time"],
  );

  Map<String, dynamic> toJson() => {
    "vip_type": vipType,
    "pay_type": payType,
    "pay_channel_id": payChannelId,
    "status": status,
    "overdue_time": overdueTime,
  };
}

class SuperVip {
  bool isSuperVip;

  SuperVip({required this.isSuperVip});

  factory SuperVip.fromRawJson(String str) =>
      SuperVip.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SuperVip.fromJson(Map<String, dynamic> json) =>
      SuperVip(isSuperVip: json["is_super_vip"]);

  Map<String, dynamic> toJson() => {"is_super_vip": isSuperVip};
}

class Wallet {
  int mid;
  int bcoinBalance;
  int couponBalance;
  int couponDueTime;

  Wallet({
    required this.mid,
    required this.bcoinBalance,
    required this.couponBalance,
    required this.couponDueTime,
  });

  factory Wallet.fromRawJson(String str) => Wallet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
    mid: json["mid"],
    bcoinBalance: json["bcoin_balance"],
    couponBalance: json["coupon_balance"],
    couponDueTime: json["coupon_due_time"],
  );

  Map<String, dynamic> toJson() => {
    "mid": mid,
    "bcoin_balance": bcoinBalance,
    "coupon_balance": couponBalance,
    "coupon_due_time": couponDueTime,
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
