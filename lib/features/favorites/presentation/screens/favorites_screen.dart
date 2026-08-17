import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_app_bar.dart';
import '../../../../shared/widgets/app_empty_view.dart';
import '../../../../shared/widgets/app_food_card.dart';
import '../../../../shared/widgets/app_restaurant_card.dart';
import '../../../cart/providers/cart_provider.dart';
import '../../providers/favorites_provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final cartProvider = context.read<CartProvider>();

    final foods = favoritesProvider.favoriteFoods;
    final restaurants = favoritesProvider.favoriteRestaurants;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: AppStrings.navFavorites, showBackButton: false),
      body: Column(
        children: [
          Container(
            color: AppColors.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelStyle: AppTextStyles.subtitle.copyWith(fontSize: 15),
              tabs: const [
                Tab(text: AppStrings.favoriteFoods),
                Tab(text: AppStrings.favoriteRestaurants),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFoodsTab(foods, favoritesProvider, cartProvider),
                _buildRestaurantsTab(restaurants, favoritesProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodsTab(List foods, FavoritesProvider favoritesProvider, CartProvider cartProvider) {
    if (foods.isEmpty) {
      return AppEmptyView(
        icon: Icons.favorite_border_rounded,
        title: AppStrings.noFavorites,
        description: AppStrings.noFavoritesDesc,
        buttonText: 'Discover Foods',
        onButtonPressed: () => context.go('/home'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
        return AppFoodCard(
          food: food,
          layout: FoodCardLayout.horizontal,
          isFavorite: true,
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
    );
  }

  Widget _buildRestaurantsTab(List restaurants, FavoritesProvider favoritesProvider) {
    if (restaurants.isEmpty) {
      return AppEmptyView(
        icon: Icons.storefront_rounded,
        title: AppStrings.noFavorites,
        description: AppStrings.noFavoritesDesc,
        buttonText: 'Discover Restaurants',
        onButtonPressed: () => context.go('/home'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final rest = restaurants[index];
        return AppRestaurantCard(
          restaurant: rest,
          isFavorite: true,
          onToggleFavorite: () => favoritesProvider.toggleRestaurantFavorite(rest.id),
          onTap: () => context.push('/restaurant/${rest.id}'),
        );
      },
    );
  }
}
