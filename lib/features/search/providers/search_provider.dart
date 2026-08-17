import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/network/network_result.dart';
import '../../../core/utils/app_logger.dart';
import '../../../data/mock/mock_foods.dart';
import '../../../data/mock/mock_restaurants.dart';
import '../../../data/models/food_model.dart';
import '../../../data/models/restaurant_model.dart';
import '../../../data/repositories/food_repository.dart';

class SearchProvider extends ChangeNotifier {
  final FoodRepository _foodRepository;
  Timer? _debounceTimer;

  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  List<FoodModel> _apiSearchResults = [];
  List<String> _recentSearches = ['Chicken', 'Pasta', 'Beef', 'Salad', 'Dessert'];
  final List<String> _popularSearches = ['Chicken', 'Beef', 'Pasta', 'Seafood', 'Dessert', 'Breakfast'];

  SearchProvider({FoodRepository? foodRepository})
      : _foodRepository = foodRepository ?? FoodRepository();

  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<String> get recentSearches => List.unmodifiable(_recentSearches);
  List<String> get popularSearches => _popularSearches;

  List<FoodModel> get searchResultsFoods {
    if (_searchQuery.trim().isEmpty) return [];
    if (_apiSearchResults.isNotEmpty) return _apiSearchResults;

    // Local fallback
    final query = _searchQuery.toLowerCase();
    return MockFoods.foods.where((food) {
      return food.name.toLowerCase().contains(query) ||
          food.description.toLowerCase().contains(query) ||
          food.restaurantName.toLowerCase().contains(query);
    }).toList();
  }

  List<RestaurantModel> get searchResultsRestaurants {
    if (_searchQuery.trim().isEmpty) return [];
    final query = _searchQuery.toLowerCase();
    return MockRestaurants.restaurants.where((rest) {
      return rest.name.toLowerCase().contains(query) ||
          rest.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();

    _debounceTimer?.cancel();
    if (query.trim().isEmpty) {
      _apiSearchResults.clear();
      _isLoading = false;
      notifyListeners();
      return;
    }

    // Debounce search requests by 400ms
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      executeSearch(query);
    });
  }

  Future<void> executeSearch(String query) async {
    if (query.trim().isEmpty) return;

    _searchQuery = query;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    AppLogger.provider('SearchProvider', 'Debounce triggered. Searching API for "$query"...');

    if (!_recentSearches.contains(query.trim())) {
      _recentSearches = [query.trim(), ..._recentSearches.take(4)];
    }

    final result = await _foodRepository.searchFoods(query);
    if (result is Success<List<FoodModel>>) {
      _apiSearchResults = result.data;
      _isLoading = false;
      AppLogger.provider('SearchProvider', 'Found ${_apiSearchResults.length} API search results');
    } else if (result is Failure<List<FoodModel>>) {
      _errorMessage = result.error;
      _isLoading = false;
      AppLogger.error('SearchProvider', 'Search failed: ${result.error}');
    }
    notifyListeners();
  }

  void clearRecentSearches() {
    _recentSearches = [];
    notifyListeners();
  }

  void removeRecentSearch(String search) {
    _recentSearches.remove(search);
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
