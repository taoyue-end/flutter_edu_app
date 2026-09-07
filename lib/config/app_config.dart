/// 全局配置：后端地址
class AppConfig {
  /// 后端 API 基础地址（含 /api/v1）
  static const String apiBase = 'http://47.113.230.113/api/v1';

  /// 后端资源域名（拼接 /static/... 相对图片路径）
  static const String apiHost = 'http://47.113.230.113';

  /// 解析相对资源地址为完整 URL
  ///
  /// 后端返回的图片路径形如 "/static/course/xx.png"，
  /// 必须拼上域名才能加载；已是完整 http 链接或 base64 则原样返回。
  static String resolveAssetUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.startsWith('http') || url.startsWith('data:')) return url;
    if (url.startsWith('/')) return apiHost + url;
    return url;
  }
}