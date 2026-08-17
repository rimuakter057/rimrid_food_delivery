import 'package:dio/dio.dart';
import '../utils/app_logger.dart';

class ApiInterceptors extends Interceptor {
  final Map<RequestOptions, DateTime> _requestTimestamps = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _requestTimestamps[options] = DateTime.now();
    AppLogger.api(
      options.method,
      '${options.baseUrl}${options.path}',
      extra: options.queryParameters.isNotEmpty ? 'Query: ${options.queryParameters}' : '',
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = _requestTimestamps.remove(response.requestOptions);
    final duration = startTime != null ? DateTime.now().difference(startTime).inMilliseconds : 0;
    AppLogger.api(
      response.requestOptions.method,
      '${response.requestOptions.baseUrl}${response.requestOptions.path}',
      statusCode: response.statusCode,
      extra: '(${duration}ms)',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _requestTimestamps.remove(err.requestOptions);
    AppLogger.error(
      'DioInterceptor',
      'API call failed [${err.requestOptions.method}] ${err.requestOptions.path}: ${err.message}',
    );
    super.onError(err, handler);
  }
}
