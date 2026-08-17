import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Color? backgroundColor;

  const AppAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: showBackButton && Navigator.canPop(context)
          ? IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.chipBackground,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: AppTextStyles.title,
                )
              : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
