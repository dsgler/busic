import 'package:busic/consts/network.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

// 创建 cookie jar 实例，用于管理 cookies（持久化存储）
late final PersistCookieJar cookieJar;

final dio = Dio(
  BaseOptions(
    headers: {
      'User-Agent': ua,
      'Referer': referer,
      // 注意：使用 CookieJar 后，不再需要手动设置 Cookie header
      // CookieManager 会自动管理 cookies
    },
  ),
);

Future<void> initDio() async {
  // 初始化 PersistCookieJar，使用应用文档目录存储 cookies
  final appDocDir = await getApplicationDocumentsDirectory();
  final cookiePath = '${appDocDir.path}/.cookies/';
  cookieJar = PersistCookieJar(
    storage: FileStorage(cookiePath),
    ignoreExpires: false,
  );

  // 添加 CookieManager 拦截器，必须在其他拦截器之前添加
  if (dio.interceptors.whereType<CookieManager>().isEmpty) {
    // cookieJar.saveFromResponse(uri, [Cookie('name', 'value')]);
    dio.interceptors.add(CookieManager(cookieJar));
  }

  if (isDebugNetwork && dio.interceptors.whereType<LogInterceptor>().isEmpty) {
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        // Keep default logPrint to stdout; replace with logger if needed.
      ),
    );
  }
}
