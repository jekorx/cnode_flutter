import 'package:dio/dio.dart';
import 'package:bot_toast/bot_toast.dart';
import './config.dart';

// 返回结果包装类
class Result<T> {
  final bool success;
  final T data;
  final Response response;
  Result(this.success, this.data, this.response);
}

class HttpUtil {
  // 单例Dio对象
  static Dio _dio;

  /// GET请求
  /// 
  /// *[url] 请求url，完整请求url为Config.BASE_URL + url
  /// 
  /// [data] 请求参数
  static Future<Result<T>> get<T>(String url, { Map<String, dynamic> data }) async {
    return await _request((dio) async {
      return await dio.get(url, queryParameters: data);
    });
  }

  /// POST请求
  /// 
  /// *[url] 请求url，完整请求url为Config.BASE_URL + url
  /// 
  /// [data] 请求参数
  static Future<Result<T>> post<T>(String url, { Map<String, dynamic> data }) async {
    return await _request((dio) async {
      return await dio.post(url, data: data);
    });
  }

  /// PUT请求
  /// 
  /// *[url] 请求url，完整请求url为Config.BASE_URL + url
  /// 
  /// [data] 请求参数
  static Future<Result<T>> put<T>(String url, { Map<String, dynamic> data }) async {
    return await _request((dio) async {
      return await dio.put(url, data: data);
    });
  }

  /// DELETE请求
  /// 
  /// *[url] 请求url，完整请求url为Config.BASE_URL + url
  static Future<Result<T>> delete<T>(String url) async {
    return await _request((dio) async {
      return await dio.delete(url);
    });
  }

  // 封装请求初始化以及响应数据处理
  static Future<Result<T>> _request<T>(Function request) async {
    // 显示loading
    CancelFunc cancelFunc = BotToast.showLoading();
    // 获取dio实例
    Dio dio = _createInstance();
    // 执行请求
    Response response = await request(dio);
    // 关闭loading
    cancelFunc();
    // 拼装结果对象
    return Result<T>(response.data['success'] as bool, response.data['data'] as T, response);
  }

  /// 设置请求头
  static void setHeaders(Map<String, dynamic> headers) {
    // 获取当前dio对象
    Dio dio = _createInstance();
    if (dio.options.headers != null) {
      // 合并当前headers
      dio.options.headers.addAll(headers);
    } else {
      dio.options.headers = headers;
    }
  }

  /// 设置默认请求参数，单个请求的同名参数会覆盖当前设置
  static void setDefaultParams(Map<String, dynamic> params) {
    // 获取当前dio对象
    Dio dio = _createInstance();
    if (dio.options.queryParameters != null) {
      // 合并当前默认请求参数
      dio.options.queryParameters.addAll(params);
    } else {
      dio.options.queryParameters = params;
    }
  }
  
  /// 删除指定设置默认请求参数
  static void removeDefaultParams(String paramKey) {
    // 获取当前dio对象
    Dio dio = _createInstance();
    if (dio.options.queryParameters != null) {
      // 删除指定请求参数
      dio.options.queryParameters.remove(paramKey);
    }
  }  

  // Dio单例模式，及初始化处理
  static Dio _createInstance() {
    if (_dio == null) {
      // 全局属性：请求前缀、连接超时时间、响应超时时间
      BaseOptions options = BaseOptions(
        baseUrl: Config.BASE_URL,
        connectTimeout: Config.CONNECT_TIMEOUT,
        receiveTimeout: Config.RECEIVE_TIMEOUT,
      );
      // 创建Dio实例
      _dio = Dio(options);
      // 拦截器
      _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options) {
          return options;
        },
        onResponse: (Response response) {
          return response;
        },
        onError: (DioError e) async {
          // 关闭所有loading
          BotToast.closeAllLoading();
          print('<<ERROR>> -> ${e.message} | ${e.request.path}');
          return e;
        },
      ));
    }
    return _dio;
  }
}