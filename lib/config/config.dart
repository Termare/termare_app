class Config {
  Config._();
  static String baseURL =
      inProduction ? 'http://nightmare.fun:9000' : 'http://nightmare.fun:9000';
  static String apiKey = 'Y29tLm5pZ2h0bWFyZQ==';

  // ignore: lines_longer_than_80_chars
  static String basicAuth =
      'Basic Y29tLm5pZ2h0bWFyZS50ZXJtYXJlOmNvbS5uaWdodG1hcmU=';
  static String dataBasePath = '$dataPath/databases';
  static String dbPath = '$dataPath/databases/user.db';
  static String binPath = '$usrPath/bin';
  static String filesPath = '$dataPath/files';
  static String initFilePath = '$filesPath/init';
  static String usrPath = '$filesPath/usr';
  static String homePath = '$filesPath/home';
  static String bootstrap = '';

  /// 缓存目录
  static String tmpPath = '$usrPath/tmp';
  static String busyboxPath = '$binPath/busybox';
  static String bashPath = '$binPath/bash';
  static const String appName = 'YanTool';
  static String dataPath = '/data/data/$packageName';

  /// 开关，上线需要关闭
  /// App运行在Release环境时，inProduction为true；当App运行在Debug和Profile环境时，inProduction为false
  static const bool inProduction = bool.fromEnvironment('dart.vm.product');
  static const bool isTest = false;
  static const int versionCode = 75; //防止工具箱被反编译更改版本
  static const String version = '2.1.5-7d2b9be8'; //防止工具箱被反编译更改版本
  static String packageName = 'com.nightmare.termare';
  // flutter package名，因为这个会影响assets的路径
  static String flutterPackage = '';
}
