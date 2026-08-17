import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';

class AppPriceText extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final TextStyle? priceStyle;
  final bool isLarge;

  const AppPriceText({
    super.key,
    required this.price,
    this.originalPrice,
    this.priceStyle,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle mainStyle = priceStyle ??
        (isLarge
            ? AppTextStyles.price.copyWith(fontSize: 22)
            : AppTextStyles.price.copyWith(fontSize: 16));

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          AppFormatters.currency(price),
          style: mainStyle,
        ),
        if (originalPrice != null && originalPrice! > price) ...[
          const SizedBox(width: 6),
          Text(
            AppFormatters.currency(originalPrice!),
            style: AppTextStyles.bodySmall.copyWith(
              decoration: TextDecoration.lineThrough,
              color: AppColors.textLight,
              fontSize: isLarge ? 14 : 12,
            ),
          ),
        ],
      ],
    );
  }
}
