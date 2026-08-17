import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AppBadge extends StatelessWidget {
  final int count;
  final String? text;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? child;

  const AppBadge({
    super.key,
    this.count = 0,
    this.text,
    this.backgroundColor,
    this.textColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (text != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primaryLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text!,
          style: AppTextStyles.caption.copyWith(
            color: textColor ?? AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (count <= 0 || child == null) return child ?? const SizedBox.shrink();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              count > 99 ? '99+' : count.toString(),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textWhite,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
