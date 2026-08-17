import 'package:flutter/foundation.dart';
import '../../../data/mock/mock_foods.dart';
import '../../../data/mock/mock_restaurants.dart';
import '../../../data/models/food_model.dart';
import '../../../data/models/restaurant_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteFoodIds = {'food_1', 'food_4', 'food_7', 'food_9', 'food_16'};
  final Set<String> _favoriteRestaurantIds = {'rest_1', 'rest_3', 'rest_7', 'rest_12'};

  Set<String> get favoriteFoodIds => _favoriteFoodIds;
  Set<String> get favoriteRestaurantIds => _favoriteRestaurantIds;

  List<FoodModel> get favoriteFoods =>
      MockFoods.foods.where((f) => _favoriteFoodIds.contains(f.id)).toList();

  List<RestaurantModel> get favoriteRestaurants =>
      MockRestaurants.restaurants.where((r) => _favoriteRestaurantIds.contains(r.id)).toList();

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
