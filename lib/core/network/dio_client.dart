import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'api_interceptors.dart';

class DioClient {
  late final Dio _dio;

  DioClient({String? baseUrl, Map<String, dynamic>? extraHeaders}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?extraHeaders,
        },
      ),
    );
    _dio.interceptors.add(ApiInterceptors());
  }

  Dio get instance => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
