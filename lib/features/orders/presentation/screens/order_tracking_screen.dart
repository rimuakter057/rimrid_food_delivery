import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/order_model.dart';
import '../../../../shared/widgets/app_app_bar.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../../../shared/widgets/app_rating.dart';
import '../../providers/order_provider.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final order = orderProvider.getOrderById(orderId) ?? orderProvider.orders.first;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'Order #${order.id}'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estimated time box banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppRadius.borderLg,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.two_wheeler_rounded, color: AppColors.textWhite, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimated Delivery Time',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textWhite.withOpacity(0.8)),
                        ),
                        Text(
                          order.estimatedTime,
                          style: AppTextStyles.heading.copyWith(color: AppColors.textWhite, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Delivery timeline stepper
            Text('Delivery Status', style: AppTextStyles.subtitle.copyWith(fontSize: 18)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.borderMd,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildTimelineStep(
                    title: 'Order Confirmed',
                    time: '12:30 PM',
                    isCompleted: true,
                    isCurrent: order.status == OrderStatus.confirmed,
                  ),
                  _buildTimelineStep(
                    title: 'Preparing Food',
                    time: '12:35 PM',
                    isCompleted: order.status == OrderStatus.preparing ||
                        order.status == OrderStatus.onTheWay ||
                        order.status == OrderStatus.delivered,
                    isCurrent: order.status == OrderStatus.preparing,
                  ),
                  _buildTimelineStep(
                    title: 'Out for Delivery',
                    time: '12:48 PM',
                    isCompleted: order.status == OrderStatus.onTheWay || order.status == OrderStatus.delivered,
                    isCurrent: order.status == OrderStatus.onTheWay,
                  ),
                  _buildTimelineStep(
                    title: 'Order Delivered',
                    time: 'Estimated 01:05 PM',
                    isCompleted: order.status == OrderStatus.delivered,
                    isCurrent: order.status == OrderStatus.delivered,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Driver Card Info
            if (order.driverName != null) ...[
              Text(AppStrings.deliveryDriver, style: AppTextStyles.subtitle.copyWith(fontSize: 18)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.borderLg,
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    AppNetworkImage(
                      imageUrl: order.driverAvatar!,
                      width: 50,
                      height: 50,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order.driverName!, style: AppTextStyles.subtitle.copyWith(fontSize: 16)),
                          const SizedBox(height: 2),
                          const AppRating(rating: 4.9, reviewCount: 184),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _buildDriverActionButton(
                          icon: Icons.phone_rounded,
                          color: AppColors.success,
                          onTap: () => context.showSnackBar('Calling ${order.driverName}...'),
                        ),
                        const SizedBox(width: 10),
                        _buildDriverActionButton(
                          icon: Icons.chat_bubble_rounded,
                          color: AppColors.primary,
                          onTap: () => context.showSnackBar('Opening chat with ${order.driverName}...'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Restaurant & Address Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.borderMd,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.storefront_rounded, color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Text(order.restaurantName, style: AppTextStyles.subtitle.copyWith(fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          order.deliveryAddress,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String time,
    required bool isCompleted,
    required bool isCurrent,
    bool isLast = false,
  }) {
    final color = isCompleted
        ? AppColors.primary
        : isCurrent
            ? AppColors.primary
            : AppColors.border;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primary : AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: color,
                  width: 2.5,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check_rounded, color: AppColors.textWhite, size: 14)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                color: isCompleted ? AppColors.primary : AppColors.divider,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.subtitle.copyWith(
                  fontSize: 15,
                  fontWeight: isCurrent || isCompleted ? FontWeight.bold : FontWeight.normal,
                  color: isCompleted || isCurrent ? AppColors.textPrimary : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 2),
              Text(time, style: AppTextStyles.caption),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDriverActionButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
