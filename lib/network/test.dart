import 'dart:convert';

import 'package:flutter/material.dart';

import 'video_url.dart';

void test() async {
  var ret = await getVideoUrl(bvid: 'BV1nkimBdEaj', cid: 35249717992);
  debugPrint(const JsonEncoder.withIndent('  ').convert(ret));
}
