import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/widgets/app_category_card.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_food_card.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../../../shared/widgets/app_restaurant_card.dart';
import '../../../../shared/widgets/app_search_bar.dart';
import '../../../../shared/widgets/app_section_header.dart';
import '../../../addresses/providers/address_provider.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../cart/providers/cart_provider.dart';
import '../../../favorites/providers/favorites_provider.dart';
import '../../providers/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    AppLogger.screen('Home Screen');
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final authProvider = context.watch<AuthProvider>();
    final addressProvider = context.watch<AddressProvider>();
    final favoritesProvider = context.watch<FavoritesProvider>();
    final cartProvider = context.read<CartProvider>();

    final user = authProvider.currentUser;
    final selectedAddress = addressProvider.selectedAddress;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            AppLogger.info('HomeScreen', 'Pull-to-refresh triggered');
            await homeProvider.loadHomeData();
          },
          color: AppColors.primary,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Location + User avatar)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  AppStrings.deliverTo,
                                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textPrimary, size: 18),
                              ],
                            ),
                            Text(
                              selectedAddress.fullAddress,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.subtitle.copyWith(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          AppLogger.info('HomeScreen', 'Navigating to Profile');
                          context.push('/profile');
                        },
                        child: AppNetworkImage(
                          imageUrl: user?.avatarUrl ?? '',
                          width: 42,
                          height: 42,
                          borderRadius: BorderRadius.circular(21),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Greeting & Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${user?.name.split(' ').first ?? 'Foodie'} 👋',
                        style: AppTextStyles.heading.copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 12),
                      AppSearchBar(
                        readOnly: true,
                        onTap: () {
                          AppLogger.info('HomeScreen', 'Navigating to Search');
                          context.go('/search');
                        },
                        onFilterTap: () => context.go('/search'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Promotional Banners Carousel
                SizedBox(
                  height: 145,
                  child: PageView(
                    onPageChanged: (index) => homeProvider.setBannerIndex(index),
                    children: [
                      _buildPromoBanner(
                        title: 'Get 30% OFF',
                        subtitle: 'On your first order with code RIMRID10',
                        color: const Color(0xFFFF6B00),
                        icon: Icons.local_offer_rounded,
                      ),
                      _buildPromoBanner(
                        title: 'Free Delivery',
                        subtitle: 'On orders over \$35. Fast & hot!',
                        color: const Color(0xFF2E7D32),
                        icon: Icons.delivery_dining_rounded,
                      ),
                      _buildPromoBanner(
                        title: 'Weekend Feast',
                        subtitle: 'Special combos up to 50% discount',
                        color: const Color(0xFF6A1B9A),
                        icon: Icons.fastfood_rounded,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 6,
                      width: homeProvider.bannerIndex == index ? 16 : 6,
                      decoration: BoxDecoration(
                        color: homeProvider.bannerIndex == index ? AppColors.primary : AppColors.border,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Categories horizontal list
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: AppSectionHeader(
                    title: AppStrings.categories,
                    onActionTap: () => context.go('/search'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 95,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: AppSpacing.md),
                    itemCount: homeProvider.categories.length,
                    itemBuilder: (context, index) {
                      final category = homeProvider.categories[index];
                      final isSelected = homeProvider.selectedCategoryId == category.id;
                      return AppCategoryCard(
                        category: category,
                        isSelected: isSelected,
                        onTap: () {
                          AppLogger.info('HomeScreen', 'Selected category: ${category.name}');
                          homeProvider.selectCategory(category.id);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Handling Loading and Error states
                if (homeProvider.isLoading) ...[
                  const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: AppLoading(message: 'Fetching fresh dishes from server...'),
                  ),
                ] else if (homeProvider.errorMessage != null) ...[
                  AppErrorView(
                    message: homeProvider.errorMessage!,
                    onRetry: () => homeProvider.loadHomeData(),
                  ),
                ] else ...[
                  // Popular Restaurants section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: AppSectionHeader(
                      title: AppStrings.popularRestaurants,
                      onActionTap: () => context.go('/search'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: homeProvider.popularRestaurants.take(3).length,
                    itemBuilder: (context, index) {
                      final restaurant = homeProvider.popularRestaurants[index];
                      return AppRestaurantCard(
                        restaurant: restaurant,
                        isFavorite: favoritesProvider.isRestaurantFavorite(restaurant.id),
                        onToggleFavorite: () => favoritesProvider.toggleRestaurantFavorite(restaurant.id),
                        onTap: () => context.push('/restaurant/${restaurant.id}'),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Popular Foods horizontal grid/scroll (from API)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: AppSectionHeader(
                      title: AppStrings.popularFoods,
                      onActionTap: () => context.go('/search'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 235,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: AppSpacing.md),
                      itemCount: homeProvider.popularFoods.length,
                      itemBuilder: (context, index) {
                        final food = homeProvider.popularFoods[index];
                        return Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: AppFoodCard(
                            food: food,
                            isFavorite: favoritesProvider.isFoodFavorite(food.id),
                            onToggleFavorite: () => favoritesProvider.toggleFoodFavorite(food.id),
                            onTap: () {
                              AppLogger.info('HomeScreen', 'Tapped food item: ${food.name}');
                              context.push('/food/${food.id}');
                            },
                            onAddToCart: () {
                              cartProvider.addToCart(food);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${food.name} added to cart'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Recommended For You (from API)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: AppSectionHeader(
                      title: AppStrings.recommendedForYou,
                      onActionTap: () => context.go('/search'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: homeProvider.recommendedFoods.length,
                    itemBuilder: (context, index) {
                      final food = homeProvider.recommendedFoods[index];
                      return AppFoodCard(
                        food: food,
                        layout: FoodCardLayout.horizontal,
                        isFavorite: favoritesProvider.isFoodFavorite(food.id),
                        onToggleFavorite: () => favoritesProvider.toggleFoodFavorite(food.id),
                        onTap: () => context.push('/food/${food.id}'),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadius.borderLg,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTextStyles.heading.copyWith(
                    color: AppColors.textWhite,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textWhite.withOpacity(0.9),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.textWhite, size: 36),
          ),
        ],
      ),
    );
  }
}
