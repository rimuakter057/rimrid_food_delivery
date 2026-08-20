import 'package:flutter/foundation.dart';
import '../../../data/mock/mock_foods.dart';
import '../../../data/mock/mock_restaurants.dart';
import '../../../data/models/food_model.dart';
import '../../../data/models/restaurant_model.dart';
import '../../../data/repositories/food_repository.dart';
import '../../../data/repositories/restaurant_repository.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteFoodIds = {'food_1', 'food_4', 'food_7', 'food_9', 'food_16'};
  final Set<String> _favoriteRestaurantIds = {'rest_1', 'rest_3', 'rest_7', 'rest_12'};

  Set<String> get favoriteFoodIds => _favoriteFoodIds;
  Set<String> get favoriteRestaurantIds => _favoriteRestaurantIds;

  // Favorited items may have come from the API (TheMealDB foods, cuisine-area
  // restaurants) rather than the static mock lists, so resolve against the
  // repositories' session caches first and only fall back to mock data.
  List<FoodModel> get favoriteFoods => _favoriteFoodIds
      .map((id) => FoodRepository.getCachedFood(id) ?? _findMockFood(id))
      .whereType<FoodModel>()
      .toList();

  List<RestaurantModel> get favoriteRestaurants => _favoriteRestaurantIds
      .map((id) => RestaurantRepository.getCachedRestaurant(id) ?? _findMockRestaurant(id))
      .whereType<RestaurantModel>()
      .toList();

  FoodModel? _findMockFood(String id) {
    try {
      return MockFoods.foods.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  RestaurantModel? _findMockRestaurant(String id) {
    try {
      return MockRestaurants.restaurants.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  bool isFoodFavorite(String foodId) => _favoriteFoodIds.contains(foodId);
  bool isRestaurantFavorite(String restaurantId) => _favoriteRestaurantIds.contains(restaurantId);

  void toggleFoodFavorite(String foodId) {
    if (_favoriteFoodIds.contains(foodId)) {
      _favoriteFoodIds.remove(foodId);
    } else {
      _favoriteFoodIds.add(foodId);
    }
    notifyListeners();
  }

  void toggleRestaurantFavorite(String restaurantId) {
    if (_favoriteRestaurantIds.contains(restaurantId)) {
      _favoriteRestaurantIds.remove(restaurantId);
    } else {
      _favoriteRestaurantIds.add(restaurantId);
    }
    notifyListeners();
  }
}
