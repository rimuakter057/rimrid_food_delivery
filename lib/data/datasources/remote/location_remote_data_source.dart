import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';

/// OpenStreetMap Nominatim — free, keyless geocoding API used to power real
/// address search/autocomplete when the user adds a new delivery address.
class LocationRemoteDataSource {
  final DioClient _dioClient;

  LocationRemoteDataSource({DioClient? dioClient})
      : _dioClient = dioClient ??
            DioClient(
              baseUrl: LocationApiConstants.baseUrl,
              extraHeaders: {'User-Agent': LocationApiConstants.userAgent},
            );

  Future<List<Map<String, dynamic>>> search(String query) async {
    try {
      final response = await _dioClient.get(
        LocationApiConstants.search,
        queryParameters: {
          'q': query,
          'format': 'jsonv2',
          'addressdetails': 1,
          'limit': 8,
        },
      );
      final data = response.data;
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
      return [];
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: 'Failed to parse address search results: $e');
    }
  }
}
