import '../../../core/network/api_exception.dart';
import '../../../core/network/network_result.dart';
import '../../../core/utils/app_logger.dart';
import '../datasources/remote/food_remote_data_source.dart';
import '../models/category_model.dart';
import '../models/food_model.dart';

class FoodRepository {
  final FoodRemoteDataSource _remoteDataSource;

  FoodRepository({FoodRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? FoodRemoteDataSource();

  Future<NetworkResult<List<CategoryModel>>> getCategories() async {
    try {
      AppLogger.info('FoodRepository', 'Fetching categories from Remote API...');
      final rawCategories = await _remoteDataSource.fetchCategories();

      final categories = <CategoryModel>[
        const CategoryModel(
          id: 'cat_all',
          name: 'All',
          icon: '🍽️',
          imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=200',
        ),
      ];

      for (final item in rawCategories) {
        final catName = (item['strCategory'] ?? 'Food').toString();
        final catId = 'cat_${catName.toLowerCase()}';
        final catThumb = (item['strCategoryThumb'] ?? '').toString();

        categories.add(
          CategoryModel(
            id: catId,
            name: catName,
            icon: _getCategoryIcon(catName),
            imageUrl: catThumb,
          ),
        );
      }

      AppLogger.info('FoodRepository', 'Successfully loaded ${categories.length} categories');
      return NetworkResult.success(categories);
    } on ApiException catch (e) {
      AppLogger.error('FoodRepository', 'getCategories failed: ${e.message}');
      return NetworkResult.failure(e.message);
    } catch (e) {
      AppLogger.error('FoodRepository', 'getCategories unknown error: $e');
      return NetworkResult.failure('Failed to load categories');
    }
  }

  Future<NetworkResult<List<FoodModel>>> getFoodsByCategory(String categoryName) async {
    try {
      AppLogger.info('FoodRepository', 'Fetching foods for category: $categoryName');
      final rawFoods = await _remoteDataSource.fetchFoodsByCategory(categoryName);
      final foods = _mapRawFoods(rawFoods, categoryName);
      return NetworkResult.success(foods);
    } on ApiException catch (e) {
      AppLogger.error('FoodRepository', 'getFoodsByCategory failed: ${e.message}');
      return NetworkResult.failure(e.message);
    } catch (e) {
      AppLogger.error('FoodRepository', 'getFoodsByCategory unknown error: $e');
      return NetworkResult.failure('Failed to load foods for $categoryName');
    }
  }

  Future<NetworkResult<List<FoodModel>>> searchFoods(String query) async {
    try {
      AppLogger.info('FoodRepository', 'Searching foods for query "$query"');
      final rawFoods = await _remoteDataSource.searchFoods(query);
      final foods = _mapRawFoods(rawFoods, 'Search');
      return NetworkResult.success(foods);
    } on ApiException catch (e) {
      AppLogger.error('FoodRepository', 'searchFoods failed: ${e.message}');
      return NetworkResult.failure(e.message);
    } catch (e) {
      AppLogger.error('FoodRepository', 'searchFoods unknown error: $e');
      return NetworkResult.failure('Failed to search foods');
    }
  }

  Future<NetworkResult<FoodModel>> getFoodDetails(String mealId) async {
    try {
      AppLogger.info('FoodRepository', 'Fetching details for meal ID: $mealId');
      final rawDetails = await _remoteDataSource.fetchFoodDetails(mealId);

      if (rawDetails == null) {
        return NetworkResult.failure('Food details not found');
      }

      final food = _mapSingleRawFood(rawDetails);
      return NetworkResult.success(food);
    } on ApiException catch (e) {
      AppLogger.error('FoodRepository', 'getFoodDetails failed: ${e.message}');
      return NetworkResult.failure(e.message);
    } catch (e) {
      AppLogger.error('FoodRepository', 'getFoodDetails unknown error: $e');
      return NetworkResult.failure('Failed to load food details');
    }
  }

  List<FoodModel> _mapRawFoods(List<Map<String, dynamic>> rawList, String categoryName) {
    final foods = <FoodModel>[];
    for (int i = 0; i < rawList.length; i++) {
      final item = rawList[i];
      foods.add(_mapSingleRawFood(item, defaultCategory: categoryName, index: i));
    }
    return foods;
  }

  FoodModel _mapSingleRawFood(Map<String, dynamic> item, {String defaultCategory = 'General', int index = 0}) {
    final mealId = (item['idMeal'] ?? 'food_$index').toString();
    final mealName = (item['strMeal'] ?? 'Delicious Meal').toString();
    final image = (item['strMealThumb'] ?? '').toString();
    final category = (item['strCategory'] ?? defaultCategory).toString();

    // Generate deterministic price & specs based on mealId hash code
    final hash = mealId.hashCode.abs();
    final basePrice = 8.99 + (hash % 1000) / 100.0;
    final rating = 4.3 + (hash % 7) / 10.0;
    final prepTime = 15 + (hash % 20);
    final calories = 350 + (hash % 450);
    final reviewCount = 80 + (hash % 300);

    // Extract description/instructions if present
    String instructions = (item['strInstructions'] ?? '').toString().trim();
    if (instructions.isEmpty) {
      instructions = 'Freshly prepared $mealName served with signature spices and fresh ingredients.';
    }

    return FoodModel(
      id: mealId,
      restaurantId: 'rest_${(hash % 5) + 1}',
      restaurantName: _getRestaurantName(hash),
      categoryId: 'cat_${category.toLowerCase()}',
      name: mealName,
      description: instructions,
      price: double.parse(basePrice.toStringAsFixed(2)),
      originalPrice: (hash % 2 == 0) ? double.parse((basePrice + 3.0).toStringAsFixed(2)) : null,
      rating: rating > 5.0 ? 5.0 : rating,
      reviewCount: reviewCount,
      imageUrl: image,
      prepTimeMinutes: prepTime,
      calories: calories,
      isPopular: (hash % 3 == 0),
      isRecommended: (hash % 2 == 0),
      addOns: const [
        AddOnModel(id: 'add_1', name: 'Extra Cheese', price: 1.50),
        AddOnModel(id: 'add_2', name: 'Crispy Bacon', price: 2.50),
        AddOnModel(id: 'add_3', name: 'Special Sauce Dip', price: 1.00),
      ],
    );
  }

  String _getCategoryIcon(String catName) {
    final lower = catName.toLowerCase();
    if (lower.contains('beef')) return '🥩';
    if (lower.contains('chicken')) return '🍗';
    if (lower.contains('dessert')) return '🍰';
    if (lower.contains('lamb') || lower.contains('goat')) return '🍖';
    if (lower.contains('pasta')) return '🍝';
    if (lower.contains('pork')) return '🥓';
    if (lower.contains('seafood')) return '🦐';
    if (lower.contains('side')) return '🍟';
    if (lower.contains('starter')) return '🥗';
    if (lower.contains('vegan') || lower.contains('veg')) return '🥦';
    if (lower.contains('breakfast')) return '🥞';
    return '🍽️';
  }

  String _getRestaurantName(int hash) {
    const names = [
      'Urban Bites',
      'Spice Garden',
      'Burger House',
      'Pasta Corner',
      'Green Bowl',
      'Grill Station',
      'Pizza Craft',
      'The Breakfast Club',
    ];
    return names[hash % names.length];
  }
}
