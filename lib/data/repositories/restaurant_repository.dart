import '../../core/network/api_exception.dart';
import '../../core/network/network_result.dart';
import '../../core/utils/app_logger.dart';
import '../datasources/remote/restaurant_remote_data_source.dart';
import '../models/food_model.dart';
import '../models/restaurant_model.dart';
import 'food_repository.dart';

/// Builds "restaurants" from TheMealDB's cuisine areas — real meal photos and
/// menus, no restaurant-directory API key required. Each cuisine (Italian,
/// Chinese, Mexican, ...) becomes one virtual restaurant.
class RestaurantRepository {
  final RestaurantRemoteDataSource _remoteDataSource;
  final FoodRepository _foodRepository;

  static final Map<String, RestaurantModel> _restaurantCache = {};

  static RestaurantModel? getCachedRestaurant(String id) => _restaurantCache[id];

  static const List<String> _curatedAreas = [
    'Italian',
    'Chinese',
    'Mexican',
    'Indian',
    'Japanese',
    'American',
    'French',
    'Thai',
    'Greek',
    'Turkish',
    'British',
    'Spanish',
    'Moroccan',
    'Vietnamese',
  ];

  static const List<String> _nameSuffixes = ['Kitchen', 'Bistro', 'House', 'Corner', 'Table', 'Diner'];

  RestaurantRepository({RestaurantRemoteDataSource? remoteDataSource, FoodRepository? foodRepository})
      : _remoteDataSource = remoteDataSource ?? RestaurantRemoteDataSource(),
        _foodRepository = foodRepository ?? FoodRepository();

  Future<NetworkResult<List<RestaurantModel>>> getRestaurants() async {
    try {
      AppLogger.info('RestaurantRepository', 'Fetching restaurants from TheMealDB areas...');

      int failedCount = 0;
      final mealsByArea = await Future.wait(_curatedAreas.map((area) async {
        try {
          return await _remoteDataSource.fetchMealsByArea(area);
        } catch (_) {
          failedCount++;
          return <Map<String, dynamic>>[];
        }
      }));

      if (failedCount == _curatedAreas.length) {
        return NetworkResult.failure('Failed to load restaurants');
      }

      final restaurants = <RestaurantModel>[];
      for (int i = 0; i < _curatedAreas.length; i++) {
        final area = _curatedAreas[i];
        final meals = mealsByArea[i];
        if (meals.isEmpty) continue;

        final restaurant = _mapAreaToRestaurant(area, meals);
        _restaurantCache[restaurant.id] = restaurant;
        restaurants.add(restaurant);
      }

      AppLogger.info('RestaurantRepository', 'Built ${restaurants.length} restaurants from cuisines');
      return NetworkResult.success(restaurants);
    } on ApiException catch (e) {
      AppLogger.error('RestaurantRepository', 'getRestaurants failed: ${e.message}');
      return NetworkResult.failure(e.message);
    } catch (e) {
      AppLogger.error('RestaurantRepository', 'getRestaurants unknown error: $e');
      return NetworkResult.failure('Failed to load restaurants');
    }
  }

  Future<NetworkResult<List<FoodModel>>> getRestaurantMeals(RestaurantModel restaurant) async {
    try {
      final area = restaurant.tags.isNotEmpty ? restaurant.tags.first : restaurant.name;
      AppLogger.info('RestaurantRepository', 'Fetching menu for $area (${restaurant.name})');
      final rawMeals = await _remoteDataSource.fetchMealsByArea(area);

      final foods = <FoodModel>[];
      for (int i = 0; i < rawMeals.length; i++) {
        final food = _foodRepository
            .mapRawFood(rawMeals[i], defaultCategory: area, index: i)
            .copyWith(restaurantId: restaurant.id, restaurantName: restaurant.name);
        FoodRepository.cacheFood(food);
        foods.add(food);
      }

      return NetworkResult.success(foods);
    } on ApiException catch (e) {
      AppLogger.error('RestaurantRepository', 'getRestaurantMeals failed: ${e.message}');
      return NetworkResult.failure(e.message);
    } catch (e) {
      AppLogger.error('RestaurantRepository', 'getRestaurantMeals unknown error: $e');
      return NetworkResult.failure('Failed to load restaurant menu');
    }
  }

  RestaurantModel _mapAreaToRestaurant(String area, List<Map<String, dynamic>> meals) {
    final hash = area.hashCode.abs();
    final thumbIndex = hash % meals.length;
    final coverImage = (meals[thumbIndex]['strMealThumb'] ?? meals[0]['strMealThumb'] ?? '').toString();

    final rating = 4.3 + (hash % 7) / 10.0;
    final reviewCount = 80 + (hash % 400);
    final baseTime = 15 + (hash % 25);
    final deliveryFee = double.parse((0.99 + (hash % 350) / 100.0).toStringAsFixed(2));
    final distanceKm = double.parse((0.5 + (hash % 45) / 10.0).toStringAsFixed(1));
    final suffix = _nameSuffixes[hash % _nameSuffixes.length];

    return RestaurantModel(
      id: 'area_${area.toLowerCase()}',
      name: '$area $suffix',
      logoUrl: coverImage,
      coverImageUrl: coverImage,
      rating: rating > 5.0 ? 5.0 : rating,
      reviewCount: reviewCount,
      deliveryTime: '$baseTime-${baseTime + 15} min',
      deliveryFee: deliveryFee,
      distanceKm: distanceKm,
      description: 'Authentic $area cuisine, freshly prepared and delivered hot.',
      tags: [area, 'Cuisine'],
      isPopular: hash % 3 == 0,
      address: '$area District, City Center',
    );
  }
}
