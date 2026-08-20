import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';

/// Talks to TheMealDB's Areas (cuisine) endpoints, which we repurpose to build
/// "restaurants" — there is no free public restaurant-directory API, but every
/// cuisine area comes with real meals/photos we can build a virtual restaurant from.
class RestaurantRemoteDataSource {
  final DioClient _dioClient;

  RestaurantRemoteDataSource({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();

  Future<List<String>> fetchAreas() async {
    try {
      final response = await _dioClient.get(ApiConstants.listAreas, queryParameters: {'a': 'list'});
      final data = response.data;
      if (data != null && data['meals'] != null) {
        return List<Map<String, dynamic>>.from(data['meals'])
            .map((m) => (m['strArea'] ?? '').toString())
            .where((a) => a.isNotEmpty)
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: 'Failed to parse areas data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchMealsByArea(String area) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.filterByCategory,
        queryParameters: {'a': area},
      );
      final data = response.data;
      if (data != null && data['meals'] != null) {
        return List<Map<String, dynamic>>.from(data['meals']);
      }
      return [];
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: 'Failed to parse area meals: $e');
    }
  }
}
