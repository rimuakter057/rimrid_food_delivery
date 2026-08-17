import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';

enum AppButtonType { primary, secondary, outline, text }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final bool isDisabled;
  final bool fullWidth;
  final Widget? icon;
  final double? width;
  final double? height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = true,
    this.icon,
    this.width,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final bool canPress = !isLoading && !isDisabled && onPressed != null;

    Widget buttonChild;
    if (isLoading) {
      buttonChild = SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == AppButtonType.primary ? AppColors.textWhite : AppColors.primary,
          ),
        ),
      );
    } else {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              text,
              style: _getTextStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    final EdgeInsets defaultPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8);

    Widget button;
    switch (type) {
      case AppButtonType.primary:
        button = ElevatedButton(
          onPressed: canPress ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textWhite,
            disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
            elevation: 0,
            padding: defaultPadding,
          ),
          child: buttonChild,
        );
        break;
      case AppButtonType.secondary:
        button = ElevatedButton(
          onPressed: canPress ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryLight,
            foregroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.chipBackground,
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
            elevation: 0,
            padding: defaultPadding,
          ),
          child: buttonChild,
        );
        break;
      case AppButtonType.outline:
        button = OutlinedButton(
          onPressed: canPress ? onPressed : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(
              color: canPress ? AppColors.primary : AppColors.border,
              width: 1.5,
            ),
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
            padding: defaultPadding,
          ),
          child: buttonChild,
        );
        break;
      case AppButtonType.text:
        button = TextButton(
          onPressed: canPress ? onPressed : null,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: defaultPadding,
          ),
          child: buttonChild,
        );
        break;
    }

    return SizedBox(
      width: fullWidth ? double.infinity : width,
      height: height,
      child: button,
    );
  }

  TextStyle _getTextStyle() {
    switch (type) {
      case AppButtonType.primary:
        return AppTextStyles.button.copyWith(color: AppColors.textWhite);
      case AppButtonType.secondary:
      case AppButtonType.outline:
      case AppButtonType.text:
        return AppTextStyles.button.copyWith(color: AppColors.primary);
    }
  }
}
