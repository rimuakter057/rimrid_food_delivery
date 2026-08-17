import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: AppColors.successLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  AppStrings.orderSuccess,
                  style: AppTextStyles.heading.copyWith(fontSize: 26),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  AppStrings.orderSuccessDesc,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Order details info card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.borderLg,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppStrings.orderId, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                          Text('#$orderId', style: AppTextStyles.subtitle.copyWith(fontSize: 15)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppStrings.estimatedDeliveryTime, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded, color: AppColors.primary, size: 16),
                              const SizedBox(width: 4),
                              Text('20 - 30 mins', style: AppTextStyles.subtitle.copyWith(fontSize: 15, color: AppColors.primary)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                AppButton(
                  text: AppStrings.trackOrder,
                  onPressed: () => context.go('/order-tracking/$orderId'),
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: AppStrings.backToHome,
                  type: AppButtonType.outline,
                  onPressed: () => context.go('/home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
