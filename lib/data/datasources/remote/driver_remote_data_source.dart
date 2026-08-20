import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';

/// randomuser.me — free, keyless API used to generate real people photos:
/// a delivery-driver identity for each placed order, and a real portrait
/// for the logged-in user's avatar (DummyJSON's demo accounts only ship a
/// generic identicon, not an actual face photo).
class DriverRemoteDataSource {
  final DioClient _dioClient;

  DriverRemoteDataSource({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient(baseUrl: DriverApiConstants.baseUrl);

  Future<Map<String, dynamic>?> fetchDriver() async {
    try {
      final response = await _dioClient.get(
        DriverApiConstants.randomUser,
        queryParameters: {'gender': 'male', 'nat': 'us,gb,ca'},
      );
      final data = response.data;
      if (data != null && data['results'] != null && (data['results'] as List).isNotEmpty) {
        return Map<String, dynamic>.from(data['results'][0]);
      }
      return null;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: 'Failed to parse driver data: $e');
    }
  }

  /// Deterministic real portrait for [seed] (e.g. a username), so the same
  /// account always gets the same face photo instead of a new random one
  /// on every login.
  Future<String?> fetchAvatarPhotoUrl(String seed, {String? gender}) async {
    try {
      final response = await _dioClient.get(
        DriverApiConstants.randomUser,
        queryParameters: {
          'seed': seed,
          if (gender == 'male' || gender == 'female') 'gender': gender,
        },
      );
      final data = response.data;
      if (data != null && data['results'] != null && (data['results'] as List).isNotEmpty) {
        final result = Map<String, dynamic>.from(data['results'][0]);
        final picture = result['picture'] as Map<String, dynamic>?;
        return picture?['large'] as String?;
      }
      return null;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: 'Failed to parse avatar data: $e');
    }
  }
}
