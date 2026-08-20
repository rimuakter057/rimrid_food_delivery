import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';

/// DummyJSON — a free, keyless fake-auth API. Real HTTP request/response with a
/// real token, but login only accepts DummyJSON's own fixed seed accounts.
class AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSource({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient(baseUrl: AuthApiConstants.baseUrl);

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dioClient.post(
        AuthApiConstants.login,
        data: {
          'username': username,
          'password': password,
          'expiresInMins': 60,
        },
      );
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: 'Failed to parse login response: $e');
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final nameParts = name.trim().split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : name;
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final response = await _dioClient.post(
        AuthApiConstants.addUser,
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
        },
      );
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: 'Failed to parse register response: $e');
    }
  }
}
