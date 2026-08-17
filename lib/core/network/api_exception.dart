import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException({
    required this.message,
    this.statusCode,
  });

  factory ApiException.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return const ApiException(message: 'Connection timeout. Please check your internet connection and try again.');
      case DioExceptionType.sendTimeout:
        return const ApiException(message: 'Send timeout. Failed to reach the server in time.');
      case DioExceptionType.receiveTimeout:
        return const ApiException(message: 'Receive timeout. Server took too long to respond.');
      case DioExceptionType.badResponse:
        final code = dioException.response?.statusCode;
        if (code == 400) {
          return ApiException(message: 'Bad request. Please try again.', statusCode: code);
        } else if (code == 401) {
          return ApiException(message: 'Unauthorized access.', statusCode: code);
        } else if (code == 403) {
          return ApiException(message: 'Access forbidden.', statusCode: code);
        } else if (code == 404) {
          return ApiException(message: 'Requested resource not found.', statusCode: code);
        } else if (code == 429) {
          return ApiException(message: 'Too many requests. Please wait a moment.', statusCode: code);
        } else if (code != null && code >= 500) {
          return ApiException(message: 'Server error ($code). Please try again later.', statusCode: code);
        }
        return ApiException(message: 'Server responded with status $code.', statusCode: code);
      case DioExceptionType.cancel:
        return const ApiException(message: 'Request was cancelled.');
      case DioExceptionType.connectionError:
        return const ApiException(message: 'No internet connection available. Please check your network.');
      default:
        return const ApiException(message: 'An unexpected network error occurred.');
    }
  }

  @override
  String toString() => message;
}
