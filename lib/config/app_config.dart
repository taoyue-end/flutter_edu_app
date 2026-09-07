/// 全局配置：通过 --dart-define 在编译期注入，实现多环境切换。
///
/// 用法示例：
///   flutter run   --dart-define=APP_ENV=staging --dart-define=API_BASE_URL=http://47.113.230.113/api/v1
///   flutter build apk --dart-define=APP_ENV=prod --dart-define=API_BASE_URL=http://47.113.230.113/api/v1
class AppConfig {
  AppConfig._();

  /// 运行环境：dev / staging / prod（通过 APP_ENV 注入）
  static const String env = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  /// 后端 API 基础地址（含 /api/v1）
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://47.113.230.113/api/v1',
  );

  /// 后端资源域名（拼接 /static/... 相对图片路径用）
  static const String assetHost = String.fromEnvironment(
    'API_HOST',
    defaultValue: 'http://47.113.230.113',
  );

  /// 代码提交哈希（CI 构建时注入，见第 8 章）
  static const String commitHash = String.fromEnvironment(
    'COMMIT_HASH',
    defaultValue: 'unknown',
  );

  /// 构建号（CI 构建时注入，见第 8 章）
  static const String buildNumber = String.fromEnvironment(
    'BUILD_NUMBER',
    defaultValue: '0',
  );

  /// 是否为生产环境
  static bool get isProd => env == 'prod';

  /// 分页默认每页条数
  static const int pageSize = 10;

  /// 请求连接超时（秒）
  static const int connectTimeout = 15;

  /// 请求响应超时（秒）
  static const int receiveTimeout = 15;

  /// 本地存取 Token 的 Key
  static const String tokenKey = 'token';

  /// 本地存取用户信息 Key
  static const String userKey = 'user_info';

  /// 解析相对资源地址为完整 URL
  ///
  /// 后端返回的图片路径形如 "/static/course/xx.png"，
  /// 必须拼上域名才能加载；已是完整 http 链接或 base64 则原样返回。
  static String resolveAssetUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.startsWith('http') || url.startsWith('data:')) return url;
    if (url.startsWith('/')) return assetHost + url;
    return url;
  }
}
