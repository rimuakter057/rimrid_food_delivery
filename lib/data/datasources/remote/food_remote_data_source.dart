import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';

class FoodRemoteDataSource {
  final DioClient _dioClient;

  FoodRemoteDataSource({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final response = await _dioClient.get(ApiConstants.categories);
      final data = response.data;
      if (data != null && data['categories'] != null) {
        return List<Map<String, dynamic>>.from(data['categories']);
      }
      return [];
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: 'Failed to parse categories data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchFoodsByCategory(String categoryName) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.filterByCategory,
        queryParameters: {'c': categoryName},
      );
      final data = response.data;
      if (data != null && data['meals'] != null) {
        return List<Map<String, dynamic>>.from(data['meals']);
      }
      return [];
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: 'Failed to parse category foods: $e');
    }
  }

  Future<List<Map<String, dynamic>>> searchFoods(String query) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.searchByName,
        queryParameters: {'s': query},
      );
      final data = response.data;
      if (data != null && data['meals'] != null) {
        return List<Map<String, dynamic>>.from(data['meals']);
      }
      return [];
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: 'Failed to parse search results: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchFoodDetails(String mealId) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.lookupById,
        queryParameters: {'i': mealId},
      );
      final data = response.data;
      if (data != null && data['meals'] != null && (data['meals'] as List).isNotEmpty) {
        return Map<String, dynamic>.from(data['meals'][0]);
      }
      return null;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: 'Failed to parse food details: $e');
    }
  }
}
