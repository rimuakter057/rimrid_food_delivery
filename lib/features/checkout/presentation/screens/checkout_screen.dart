import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../data/models/payment_method_model.dart';
import '../../../../shared/widgets/app_app_bar.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_divider.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../addresses/providers/address_provider.dart';
import '../../../cart/providers/cart_provider.dart';
import '../../../orders/providers/order_provider.dart';
import '../../../payments/providers/payment_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _deliveryNoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppLogger.screen('Checkout Screen');
  }

  @override
  void dispose() {
    _deliveryNoteController.dispose();
    super.dispose();
  }

  void _onPlaceOrder() {
    final cartProvider = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();
    final addressProvider = context.read<AddressProvider>();
    final paymentProvider = context.read<PaymentProvider>();

    if (cartProvider.items.isEmpty) return;

    AppLogger.info('CheckoutScreen', 'Placing order for total: ${cartProvider.total}');

    final newOrder = orderProvider.createOrder(
      items: List.from(cartProvider.items),
      subtotal: cartProvider.subtotal,
      deliveryFee: cartProvider.deliveryFee,
      tax: cartProvider.tax,
      discount: cartProvider.discount,
      total: cartProvider.total,
      deliveryAddress: '${addressProvider.selectedAddress.label} • ${addressProvider.selectedAddress.fullAddress}',
      paymentMethod: paymentProvider.selectedPaymentMethod.title,
    );

    cartProvider.clearCart();
    AppLogger.info('CheckoutScreen', 'Order created successfully [ID: ${newOrder.id}]');
    context.go('/order-success/${newOrder.id}');
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final addressProvider = context.watch<AddressProvider>();
    final paymentProvider = context.watch<PaymentProvider>();

    final selectedAddress = addressProvider.selectedAddress;
    final selectedPayment = paymentProvider.selectedPaymentMethod;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: AppStrings.checkout),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address Card
            Text(AppStrings.deliveryAddress, style: AppTextStyles.subtitle.copyWith(fontSize: 16)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.borderMd,
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(selectedAddress.label, style: AppTextStyles.subtitle.copyWith(fontSize: 14)),
                            if (selectedAddress.isDefault) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.chipBackground,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text('Default', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(selectedAddress.fullAddress, style: AppTextStyles.bodyMedium),
                        if (selectedAddress.details.isNotEmpty)
                          Text(selectedAddress.details, style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/addresses'),
                    child: Text(AppStrings.change, style: AppTextStyles.smallLabel.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Payment Method Card
            Text(AppStrings.paymentMethod, style: AppTextStyles.subtitle.copyWith(fontSize: 16)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.borderMd,
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      selectedPayment.type == PaymentType.cod ? Icons.payments_outlined : Icons.credit_card_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(selectedPayment.title, style: AppTextStyles.subtitle.copyWith(fontSize: 14)),
                        if (selectedPayment.lastFour != null)
                          Text('•••• ${selectedPayment.lastFour}', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/payment-methods'),
                    child: Text(AppStrings.change, style: AppTextStyles.smallLabel.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Delivery instructions text field
            AppTextField(
              label: 'Delivery Instructions (Optional)',
              hint: 'e.g. Ring the doorbell, leave at front door...',
              controller: _deliveryNoteController,
            ),
            const SizedBox(height: 24),

            // Order Summary Breakdown
            Text(AppStrings.orderSummary, style: AppTextStyles.subtitle.copyWith(fontSize: 16)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.borderMd,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartProvider.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = cartProvider.items[index];
                      return Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.chipBackground,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('${item.quantity}x', style: AppTextStyles.smallLabel),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item.food.name,
                              style: AppTextStyles.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(AppFormatters.currency(item.totalPrice), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                        ],
                      );
                    },
                  ),
                  const AppDivider(height: 24),
                  _buildSummaryRow(AppStrings.subtotal, AppFormatters.currency(cartProvider.subtotal)),
                  const SizedBox(height: 6),
                  _buildSummaryRow(AppStrings.deliveryFee, AppFormatters.currency(cartProvider.deliveryFee)),
                  const SizedBox(height: 6),
                  _buildSummaryRow(AppStrings.tax, AppFormatters.currency(cartProvider.tax)),
                  if (cartProvider.discount > 0) ...[
                    const SizedBox(height: 6),
                    _buildSummaryRow(AppStrings.discount, '-${AppFormatters.currency(cartProvider.discount)}', isSuccess: true),
                  ],
                  const AppDivider(height: 24),
                  _buildSummaryRow(AppStrings.total, AppFormatters.currency(cartProvider.total), isTotal: true),
                ],
              ),
            ),
            const SizedBox(height: 28),
            AppButton(
              text: '${AppStrings.placeOrder} • ${AppFormatters.currency(cartProvider.total)}',
              onPressed: _onPlaceOrder,
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
              ? AppTextStyles.subtitle.copyWith(fontSize: 16, fontWeight: FontWeight.bold)
              : AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.price.copyWith(fontSize: 18)
              : AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSuccess ? AppColors.success : AppColors.textPrimary,
                ),
        ),
      ],
    );
  }
}
