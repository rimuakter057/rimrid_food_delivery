import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_app_bar.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_divider.dart';
import '../../../../shared/widgets/app_empty_view.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../../../shared/widgets/app_price_text.dart';
import '../../../../shared/widgets/app_quantity_selector.dart';
import '../../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppLogger.screen('Cart Screen');
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final items = cartProvider.items;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: AppStrings.myCart,
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () {
                AppLogger.info('CartScreen', 'Cleared all items in cart');
                cartProvider.clearCart();
              },
              child: Text(
                'Clear',
                style: AppTextStyles.button.copyWith(color: AppColors.error, fontSize: 14),
              ),
            ),
        ],
      ),
      body: items.isEmpty
          ? AppEmptyView(
              icon: Icons.shopping_bag_outlined,
              title: AppStrings.cartEmpty,
              description: AppStrings.cartEmptyDesc,
              buttonText: 'Browse Menu',
              onButtonPressed: () => context.go('/home'),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cart items list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: AppRadius.borderMd,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppNetworkImage(
                              imageUrl: item.food.imageUrl,
                              width: 70,
                              height: 70,
                              borderRadius: AppRadius.borderSm,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.food.name,
                                          style: AppTextStyles.subtitle.copyWith(fontSize: 15),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => cartProvider.removeFromCart(item.id),
                                        child: const Icon(Icons.close_rounded, color: AppColors.iconGrey, size: 18),
                                      ),
                                    ],
                                  ),
                                  if (item.selectedAddOns.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      'Add-ons: ${item.selectedAddOns.map((a) => a.name).join(', ')}',
                                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                  if (item.specialInstructions.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      'Note: ${item.specialInstructions}',
                                      style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppPriceText(price: item.totalPrice),
                                      AppQuantitySelector(
                                        quantity: item.quantity,
                                        onChanged: (newQty) => cartProvider.updateQuantity(item.id, newQty),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Promo Code Input Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.borderMd,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_offer_outlined, color: AppColors.primary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _promoController,
                            style: AppTextStyles.bodyMedium,
                            decoration: InputDecoration(
                              hintText: cartProvider.appliedPromoCode != null
                                  ? 'Code "${cartProvider.appliedPromoCode}" applied'
                                  : 'Promo code (Try: RIMRID10)',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                          ),
                        ),
                        if (cartProvider.appliedPromoCode != null)
                          TextButton(
                            onPressed: () {
                              cartProvider.clearPromo();
                              _promoController.clear();
                            },
                            child: Text('Remove', style: AppTextStyles.smallLabel.copyWith(color: AppColors.error)),
                          )
                        else
                          AppButton(
                            text: AppStrings.apply,
                            fullWidth: false,
                            width: 80,
                            height: 36,
                            onPressed: () {
                              final success = cartProvider.applyPromoCode(_promoController.text);
                              if (success) {
                                AppLogger.info('CartScreen', 'Promo applied: ${_promoController.text}');
                                context.showSnackBar(AppStrings.promoApplied);
                              } else {
                                context.showSnackBar(AppStrings.invalidPromo, isError: true);
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Cost Breakdown Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.borderMd,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow(AppStrings.subtotal, AppFormatters.currency(cartProvider.subtotal)),
                        const SizedBox(height: 8),
                        _buildSummaryRow(
                          AppStrings.deliveryFee,
                          cartProvider.deliveryFee == 0 ? 'FREE' : AppFormatters.currency(cartProvider.deliveryFee),
                          isSuccess: cartProvider.deliveryFee == 0,
                        ),
                        const SizedBox(height: 8),
                        _buildSummaryRow(AppStrings.tax, AppFormatters.currency(cartProvider.tax)),
                        if (cartProvider.discount > 0) ...[
                          const SizedBox(height: 8),
                          _buildSummaryRow(
                            AppStrings.discount,
                            '-${AppFormatters.currency(cartProvider.discount)}',
                            isSuccess: true,
                          ),
                        ],
                        const AppDivider(height: 24),
                        _buildSummaryRow(
                          AppStrings.total,
                          AppFormatters.currency(cartProvider.total),
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: AppStrings.proceedToCheckout,
                    onPressed: () {
                      AppLogger.info('CartScreen', 'Proceeding to Checkout');
                      context.push('/checkout');
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false, bool isSuccess = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTextStyles.subtitle.copyWith(fontSize: 18, fontWeight: FontWeight.bold)
              : AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.price.copyWith(fontSize: 20)
              : AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSuccess ? AppColors.success : AppColors.textPrimary,
                ),
        ),
      ],
    );
  }
}
