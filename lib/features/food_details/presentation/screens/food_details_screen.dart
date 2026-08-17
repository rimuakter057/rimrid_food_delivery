import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/network/network_result.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../data/mock/mock_foods.dart';
import '../../../../data/models/food_model.dart';
import '../../../../data/repositories/food_repository.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../../../shared/widgets/app_price_text.dart';
import '../../../../shared/widgets/app_quantity_selector.dart';
import '../../../../shared/widgets/app_rating.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../cart/providers/cart_provider.dart';
import '../../../favorites/providers/favorites_provider.dart';

class FoodDetailsScreen extends StatefulWidget {
  final String foodId;

  const FoodDetailsScreen({
    super.key,
    required this.foodId,
  });

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  late FoodModel _food;
  bool _isLoading = true;
  int _quantity = 1;
  final List<AddOnModel> _selectedAddOns = [];
  final TextEditingController _instructionsController = TextEditingController();
  final FoodRepository _foodRepository = FoodRepository();

  @override
  void initState() {
    super.initState();
    AppLogger.screen('Food Details Screen [Food ID: ${widget.foodId}]');
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    // Try mock food first
    try {
      final mock = MockFoods.foods.firstWhere((f) => f.id == widget.foodId);
      setState(() {
        _food = mock;
        _isLoading = false;
      });
      return;
    } catch (_) {}

    // Otherwise fetch API meal details
    AppLogger.info('FoodDetailsScreen', 'Fetching API food details for meal ID: ${widget.foodId}');
    final result = await _foodRepository.getFoodDetails(widget.foodId);
    if (result is Success<FoodModel>) {
      setState(() {
        _food = result.data;
        _isLoading = false;
      });
    } else {
      // Fallback
      setState(() {
        _food = MockFoods.foods.first;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  double get _addOnsTotal {
    return _selectedAddOns.fold(0.0, (sum, addon) => sum + addon.price);
  }

  double get _unitPrice => _food.price + _addOnsTotal;

  double get _totalPrice => _unitPrice * _quantity;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: AppLoading(message: 'Loading food details...')),
      );
    }

    final favoritesProvider = context.watch<FavoritesProvider>();
    final cartProvider = context.read<CartProvider>();
    final isFavorite = favoritesProvider.isFoodFavorite(_food.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 260,
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
                    onPressed: () => favoritesProvider.toggleFoodFavorite(_food.id),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: AppNetworkImage(
                    imageUrl: _food.imageUrl,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_food.name, style: AppTextStyles.heading.copyWith(fontSize: 22)),
                                const SizedBox(height: 4),
                                Text(_food.restaurantName, style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary, fontSize: 14)),
                              ],
                            ),
                          ),
                          AppPriceText(price: _food.price, originalPrice: _food.originalPrice, isLarge: true),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          AppRating(rating: _food.rating, reviewCount: _food.reviewCount),
                          const SizedBox(width: 16),
                          const Icon(Icons.timer_outlined, color: AppColors.primary, size: 16),
                          const SizedBox(width: 4),
                          Text('${_food.prepTimeMinutes} mins', style: AppTextStyles.bodySmall),
                          const SizedBox(width: 16),
                          const Icon(Icons.local_fire_department_outlined, color: AppColors.warning, size: 16),
                          const SizedBox(width: 4),
                          Text('${_food.calories} kcal', style: AppTextStyles.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text('Description & Instructions', style: AppTextStyles.subtitle.copyWith(fontSize: 16)),
                      const SizedBox(height: 6),
                      Text(_food.description, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 24),

                      // Add-ons list if present
                      if (_food.addOns.isNotEmpty) ...[
                        Text('Add-ons & Extras', style: AppTextStyles.subtitle.copyWith(fontSize: 16)),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _food.addOns.length,
                          itemBuilder: (context, index) {
                            final addon = _food.addOns[index];
                            final isSelected = _selectedAddOns.any((a) => a.id == addon.id);
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: AppRadius.borderMd,
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.border,
                                ),
                              ),
                              child: CheckboxListTile(
                                value: isSelected,
                                activeColor: AppColors.primary,
                                title: Text(addon.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                                subtitle: Text('+${AppFormatters.currency(addon.price)}', style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      _selectedAddOns.add(addon);
                                    } else {
                                      _selectedAddOns.removeWhere((a) => a.id == addon.id);
                                    }
                                  });
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Special Instructions
                      AppTextField(
                        label: 'Special Instructions',
                        hint: 'e.g. Less spicy, no onions, extra napkins...',
                        controller: _instructionsController,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 100), // Bottom bar padding
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Fixed bottom bar with quantity selector & Add to Cart button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.paddingOf(context).bottom + 12,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 12,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  AppQuantitySelector(
                    quantity: _quantity,
                    onChanged: (val) {
                      setState(() {
                        _quantity = val;
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      text: 'Add to Cart • ${AppFormatters.currency(_totalPrice)}',
                      onPressed: () {
                        AppLogger.info('FoodDetailsScreen', 'Added ${_food.name} (x$_quantity) to cart');
                        cartProvider.addToCart(
                          _food,
                          quantity: _quantity,
                          selectedAddOns: _selectedAddOns,
                          specialInstructions: _instructionsController.text.trim(),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${_food.name} added to cart!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                        context.pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
