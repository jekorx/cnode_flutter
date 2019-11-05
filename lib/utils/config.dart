class Config {
  // debug标记
  static const bool IS_DEBUG = true;
  // 网络请求配置
  static const String BASE_URL = 'https://cnodejs.org/api/v1';
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 3000;
  // 默认token请求参数名
  static const String TOKEN_REQUEST_PARAM_KEY = 'accesstoken';
  // token存储key值
  static const String USER_TOKEN_KEY = 'USER_TOKEN';
  // 用户名称存储key值
  static const String USER_NAME_KEY = 'USER_NAME';
  // 用户头像存储key值
  static const String USER_AVATAR_KEY = 'USER_AVATAR';
}