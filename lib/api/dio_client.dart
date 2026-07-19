import 'package:dio/dio.dart';

/// Singleton Dio client for Free Dictionary API
class DictionaryDio {
  late final Dio _dio;

  DictionaryDio._() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://api.dictionaryapi.dev/api/v2',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
    _dio.interceptors.add(ErrorNormalizer());
  }

  static final instance = DictionaryDio._();

  Dio get dio => _dio;
}

/// Normalize API errors into user-friendly Chinese messages
class ErrorNormalizer extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final data = err.response?.data;

    if (err.response?.statusCode == 404 && data is Map) {
      handler.reject(DioException(
        requestOptions: err.requestOptions,
        type: DioExceptionType.badResponse,
        message: data['message']?.toString(),
        response: err.response,
      ));
      return;
    }

    final msg = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout =>
        '网络连接超时，请检查网络后重试',
      DioExceptionType.connectionError => '网络不可用，请检查网络连接',
      _ => err.message ?? '网络错误',
    };
    handler.reject(DioException(
      requestOptions: err.requestOptions,
      message: msg,
      type: err.type,
    ));
  }
}
