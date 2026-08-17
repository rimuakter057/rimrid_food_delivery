import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';

abstract class AppDialog {
  static Future<bool?> showConfirm({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
        title: Text(
          title,
          style: AppTextStyles.title.copyWith(fontSize: 18),
        ),
        content: Text(
          message,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              cancelText,
              style: AppTextStyles.button.copyWith(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDestructive ? AppColors.error : AppColors.primary,
              foregroundColor: AppColors.textWhite,
              elevation: 0,
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
            ),
            child: Text(
              confirmText,
              style: AppTextStyles.button.copyWith(color: AppColors.textWhite),
            ),
          ),
        ],
      ),
    );
  }
}
