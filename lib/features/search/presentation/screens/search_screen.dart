import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_chip.dart';
import '../../../../shared/widgets/app_empty_view.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_food_card.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/app_restaurant_card.dart';
import '../../../../shared/widgets/app_search_bar.dart';
import '../../../../shared/widgets/app_section_header.dart';
import '../../../cart/providers/cart_provider.dart';
import '../../../favorites/providers/favorites_provider.dart';
import '../../providers/search_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    AppLogger.screen('Search Screen');
    final searchProvider = context.read<SearchProvider>();
    _searchController = TextEditingController(text: searchProvider.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterModal() {
    AppBottomSheet.show(
      context: context,
      title: 'Filter & Sort',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sort By', style: AppTextStyles.subtitle.copyWith(fontSize: 16)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: const [
              AppChip(label: 'Popularity', isSelected: true),
              AppChip(label: 'Rating: High to Low'),
              AppChip(label: 'Delivery Time'),
              AppChip(label: 'Price: Low to High'),
            ],
          ),
          const SizedBox(height: 24),
          Text('Price Range', style: AppTextStyles.subtitle.copyWith(fontSize: 16)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: const [
              AppChip(label: '\$', isSelected: false),
              AppChip(label: '\$\$', isSelected: true),
              AppChip(label: '\$\$\$', isSelected: false),
            ],
          ),
          const SizedBox(height: 28),
          AppButton(
            text: 'Apply Filters',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();
    final favoritesProvider = context.watch<FavoritesProvider>();
    final cartProvider = context.read<CartProvider>();

    final isSearching = searchProvider.searchQuery.trim().isNotEmpty;
    final foodResults = searchProvider.searchResultsFoods;
    final restaurantResults = searchProvider.searchResultsRestaurants;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: AppSearchBar(
                controller: _searchController,
                autofocus: false,
                onChanged: (val) {
                  AppLogger.info('SearchScreen', 'Search text input: "$val"');
                  searchProvider.setSearchQuery(val);
                },
                onFilterTap: _showFilterModal,
              ),
            ),
            Expanded(
              child: searchProvider.isLoading
                  ? const AppLoading(message: 'Searching API...')
                  : searchProvider.errorMessage != null
                      ? AppErrorView(
                          message: searchProvider.errorMessage!,
                          onRetry: () => searchProvider.executeSearch(searchProvider.searchQuery),
                        )
                      : isSearching
                          ? _buildSearchResults(foodResults, restaurantResults, favoritesProvider, cartProvider)
                          : _buildInitialSearchState(searchProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialSearchState(SearchProvider searchProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchProvider.recentSearches.isNotEmpty) ...[
            AppSectionHeader(
              title: 'Recent Searches',
              actionText: 'Clear All',
              onActionTap: () => searchProvider.clearRecentSearches(),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: searchProvider.recentSearches.map((search) {
                return InputChip(
                  label: Text(search, style: AppTextStyles.bodyMedium),
                  backgroundColor: AppColors.chipBackground,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  side: BorderSide.none,
                  deleteIcon: const Icon(Icons.close_rounded, size: 16, color: AppColors.iconGrey),
                  onDeleted: () => searchProvider.removeRecentSearch(search),
                  onPressed: () {
                    _searchController.text = search;
                    searchProvider.executeSearch(search);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
          ],
          Text('Popular Searches', style: AppTextStyles.subtitle.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: searchProvider.popularSearches.map((tag) {
              return AppChip(
                label: tag,
                icon: const Icon(Icons.trending_up_rounded, size: 16, color: AppColors.primary),
                onTap: () {
                  _searchController.text = tag;
                  searchProvider.executeSearch(tag);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(
    List foodResults,
    List restaurantResults,
    FavoritesProvider favoritesProvider,
    CartProvider cartProvider,
  ) {
    if (foodResults.isEmpty && restaurantResults.isEmpty) {
      return const AppEmptyView(
        icon: Icons.search_off_rounded,
        title: AppStrings.noResultsFound,
        description: AppStrings.noResultsFoundDesc,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (restaurantResults.isNotEmpty) ...[
            Text('Restaurants (${restaurantResults.length})',
                style: AppTextStyles.subtitle.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: restaurantResults.length,
              itemBuilder: (context, index) {
                final rest = restaurantResults[index];
                return AppRestaurantCard(
                  restaurant: rest,
                  isFavorite: favoritesProvider.isRestaurantFavorite(rest.id),
                  onToggleFavorite: () => favoritesProvider.toggleRestaurantFavorite(rest.id),
                  onTap: () => context.push('/restaurant/${rest.id}'),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
          if (foodResults.isNotEmpty) ...[
            Text('Dishes from API (${foodResults.length})',
                style: AppTextStyles.subtitle.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: foodResults.length,
              itemBuilder: (context, index) {
                final food = foodResults[index];
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
    );
  }
}
