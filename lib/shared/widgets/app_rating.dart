import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AppRating extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double iconSize;
  final bool showText;

  const AppRating({
    super.key,
    required this.rating,
    this.reviewCount,
    this.iconSize = 16,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          color: AppColors.rating,
          size: iconSize,
        ),
        if (showText) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: AppTextStyles.smallLabel.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (reviewCount != null) ...[
            const SizedBox(width: 2),
            Text(
              ' ($reviewCount)',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ],
      ],
    );
  }
}
