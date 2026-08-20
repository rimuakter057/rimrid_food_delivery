import 'package:flutter/foundation.dart';
import '../../../core/network/network_result.dart';
import '../../../core/utils/app_logger.dart';
import '../../../data/mock/mock_categories.dart';
import '../../../data/mock/mock_foods.dart';
import '../../../data/mock/mock_restaurants.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/food_model.dart';
import '../../../data/models/restaurant_model.dart';
import '../../../data/repositories/food_repository.dart';
import '../../../data/repositories/restaurant_repository.dart';

class HomeProvider extends ChangeNotifier {
  final FoodRepository _foodRepository;
  final RestaurantRepository _restaurantRepository;

  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategoryId = 'cat_all';
  int _bannerIndex = 0;

  List<CategoryModel> _categories = MockCategories.categories;
  List<FoodModel> _apiFoods = [];
  List<RestaurantModel> _restaurants = MockRestaurants.restaurants;

  HomeProvider({FoodRepository? foodRepository, RestaurantRepository? restaurantRepository})
      : _foodRepository = foodRepository ?? FoodRepository(),
        _restaurantRepository = restaurantRepository ?? RestaurantRepository() {
    loadHomeData();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategoryId => _selectedCategoryId;
  int get bannerIndex => _bannerIndex;

  List<CategoryModel> get categories => _categories;
  List<RestaurantModel> get popularRestaurants => _restaurants.where((r) => r.isPopular).toList();
  List<RestaurantModel> get allRestaurants => _restaurants;

  /// Real food photos pulled from the already-fetched API foods, used to drive
  /// the home screen's promo banner carousel instead of static placeholder text.
  List<FoodModel> get bannerFoods => _apiFoods.take(5).toList();

  List<FoodModel> get popularFoods {
    if (_apiFoods.isNotEmpty) {
      return _apiFoods.take(8).toList();
    }
    return MockFoods.foods.where((f) => f.isPopular).toList();
  }

  List<FoodModel> get recommendedFoods {
    if (_apiFoods.isNotEmpty) {
      return _apiFoods.skip(3).take(8).toList();
    }
    return MockFoods.foods.where((f) => f.isRecommended).toList();
  }

  List<FoodModel> get filteredFoods {
    if (_apiFoods.isNotEmpty) {
      return _apiFoods;
    }
    if (_selectedCategoryId == 'cat_all') {
      return MockFoods.foods;
    }
    return MockFoods.foods.where((f) => f.categoryId == _selectedCategoryId).toList();
  }

  Future<void> loadHomeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    AppLogger.provider('HomeProvider', 'Fetching Home screen data from API...');

    // Fetch Categories
    final categoryResult = await _foodRepository.getCategories();
    if (categoryResult is Failure<List<CategoryModel>>) {
      _errorMessage = categoryResult.error;
      _isLoading = false;
      AppLogger.error('HomeProvider', 'API Error loading Home data: ${categoryResult.error}');
      notifyListeners();
      return;
    } else if (categoryResult is Success<List<CategoryModel>>) {
      _categories = categoryResult.data;
    }

    // Fetch initial foods
    final foodResult = await _foodRepository.getFoodsByCategory('Seafood');
    if (foodResult is Success<List<FoodModel>>) {
      _apiFoods = foodResult.data;
      AppLogger.provider('HomeProvider', 'Successfully loaded ${_apiFoods.length} foods from API');
    } else if (foodResult is Failure<List<FoodModel>>) {
      _errorMessage = foodResult.error;
      _isLoading = false;
      AppLogger.error('HomeProvider', 'API Error loading food list: ${foodResult.error}');
      notifyListeners();
      return;
    }

    // Fetch restaurants (built from TheMealDB cuisine areas)
    final restaurantResult = await _restaurantRepository.getRestaurants();
    if (restaurantResult is Success<List<RestaurantModel>>) {
      _restaurants = restaurantResult.data;
      AppLogger.provider('HomeProvider', 'Successfully loaded ${_restaurants.length} restaurants from API');
    } else if (restaurantResult is Failure<List<RestaurantModel>>) {
      AppLogger.error('HomeProvider', 'API Error loading restaurants: ${restaurantResult.error}');
      // Keep the mock fallback rather than failing the whole screen for this.
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> selectCategory(String categoryId) async {
    _selectedCategoryId = categoryId;
    notifyListeners();

    final selectedCat = _categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => const CategoryModel(id: 'cat_all', name: 'Seafood', icon: '🍽️', imageUrl: ''),
    );

    if (selectedCat.name == 'All') {
      loadHomeData();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    AppLogger.provider('HomeProvider', 'Category selected: ${selectedCat.name}. Querying API...');

    final result = await _foodRepository.getFoodsByCategory(selectedCat.name);
    if (result is Success<List<FoodModel>>) {
      _apiFoods = result.data;
      _isLoading = false;
      AppLogger.provider('HomeProvider', 'Loaded ${_apiFoods.length} foods for category ${selectedCat.name}');
    } else if (result is Failure<List<FoodModel>>) {
      _errorMessage = result.error;
      _isLoading = false;
      AppLogger.error('HomeProvider', 'Category API error: ${result.error}');
    }
    notifyListeners();
  }

  void setBannerIndex(int index) {
    _bannerIndex = index;
    notifyListeners();
  }
}
