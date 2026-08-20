import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/network/network_result.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../data/mock/mock_foods.dart';
import '../../../../data/mock/mock_restaurants.dart';
import '../../../../data/models/food_model.dart';
import '../../../../data/models/restaurant_model.dart';
import '../../../../data/repositories/restaurant_repository.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_food_card.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../../../shared/widgets/app_rating.dart';
import '../../../cart/providers/cart_provider.dart';
import '../../../favorites/providers/favorites_provider.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailsScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  State<RestaurantDetailsScreen> createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> with SingleTickerProviderStateMixin {
  final RestaurantRepository _restaurantRepository = RestaurantRepository();
  late TabController _tabController;
  final List<String> _tabs = ['All Items', 'Popular', 'Combo Deals', 'Beverages'];

  late RestaurantModel _restaurant;
  List<FoodModel> _menuFoods = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _restaurant = MockRestaurants.restaurants.firstWhere(
      (r) => r.id == widget.restaurantId,
      orElse: () => MockRestaurants.restaurants.first,
    );
    _loadRestaurant();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadRestaurant() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    var restaurant = RestaurantRepository.getCachedRestaurant(widget.restaurantId);
    if (restaurant == null) {
      // Cache miss (e.g. deep link before Home/Search populated it) — fetch fresh.
      final result = await _restaurantRepository.getRestaurants();
      if (result is Success<List<RestaurantModel>>) {
        restaurant = RestaurantRepository.getCachedRestaurant(widget.restaurantId);
      }
    }
    restaurant ??= _restaurant; // fall back to the mock match found in initState

    final menuResult = await _restaurantRepository.getRestaurantMeals(restaurant);
    if (!mounted) return;

    setState(() {
      _restaurant = restaurant!;
      if (menuResult is Success<List<FoodModel>>) {
        _menuFoods = menuResult.data;
      } else if (menuResult is Failure<List<FoodModel>>) {
        _errorMessage = menuResult.error;
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final cartProvider = context.read<CartProvider>();
    final isFavorite = favoritesProvider.isRestaurantFavorite(_restaurant.id);

    final displayFoods = _menuFoods.isNotEmpty ? _menuFoods : MockFoods.foods.take(6).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: isFavorite ? AppColors.error : AppColors.iconGrey,
                    size: 20,
                  ),
                ),
                onPressed: () => favoritesProvider.toggleRestaurantFavorite(_restaurant.id),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: AppNetworkImage(
                imageUrl: _restaurant.coverImageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppNetworkImage(
                        imageUrl: _restaurant.logoUrl,
                        width: 60,
                        height: 60,
                        borderRadius: AppRadius.borderMd,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_restaurant.name, style: AppTextStyles.heading.copyWith(fontSize: 22)),
                            const SizedBox(height: 4),
                            Text(_restaurant.tags.join(' • '), style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(_restaurant.description, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),

                  // Info row card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.borderMd,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoItem(
                          widget: AppRating(rating: _restaurant.rating, reviewCount: _restaurant.reviewCount),
                          label: 'Rating',
                        ),
                        Container(width: 1, height: 30, color: AppColors.divider),
                        _buildInfoItem(
                          icon: Icons.access_time_filled_rounded,
                          value: _restaurant.deliveryTime,
                          label: 'Delivery Time',
                        ),
                        Container(width: 1, height: 30, color: AppColors.divider),
                        _buildInfoItem(
                          icon: Icons.delivery_dining_rounded,
                          value: AppFormatters.currency(_restaurant.deliveryFee),
                          label: 'Delivery Fee',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tab bar categories
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 3,
                    labelStyle: AppTextStyles.subtitle.copyWith(fontSize: 15),
                    tabs: _tabs.map((t) => Tab(text: t)).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Menu list
                  if (_isLoading) ...[
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: AppLoading(message: 'Fetching the menu...'),
                    ),
                  ] else if (_errorMessage != null && _menuFoods.isEmpty) ...[
                    AppErrorView(message: _errorMessage!, onRetry: _loadRestaurant),
                  ] else ...[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayFoods.length,
                      itemBuilder: (context, index) {
                        final food = displayFoods[index];
                        return AppFoodCard(
                          food: food,
                          layout: FoodCardLayout.horizontal,
                          isFavorite: favoritesProvider.isFoodFavorite(food.id),
                          onToggleFavorite: () => favoritesProvider.toggleFoodFavorite(food.id),
                          onTap: () => context.push('/food/${food.id}'),
                          onAddToCart: () {
                            cartProvider.addToCart(food);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${food.name} added to cart'), duration: const Duration(seconds: 1)),
                            );
                          },
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({Widget? widget, IconData? icon, String? value, required String label}) {
    return Column(
      children: [
        if (widget != null) widget,
        if (icon != null)
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 16),
              const SizedBox(width: 4),
              Text(value!, style: AppTextStyles.smallLabel.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
