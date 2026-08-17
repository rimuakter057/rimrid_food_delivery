import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_app_bar.dart';
import '../../../../shared/widgets/app_dialog.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../../auth/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _onLogout(BuildContext context) async {
    final confirm = await AppDialog.showConfirm(
      context: context,
      title: AppStrings.logout,
      message: AppStrings.confirmLogout,
      confirmText: AppStrings.logout,
      isDestructive: true,
    );

    if (confirm == true && context.mounted) {
      context.read<AuthProvider>().logout();
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: AppStrings.profile, showBackButton: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // User Header Card
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
                    imageUrl: user?.avatarUrl ?? '',
                    width: 64,
                    height: 64,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.name ?? 'Sarah Jenkins', style: AppTextStyles.subtitle.copyWith(fontSize: 18)),
                        const SizedBox(height: 2),
                        Text(user?.email ?? 'sarah@example.com', style: AppTextStyles.bodySmall),
                        Text(user?.phone ?? '+1 (555) 382-9910', style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 22),
                    onPressed: () => context.push('/edit-profile'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Menu Section
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.borderLg,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.person_outline_rounded,
                    title: AppStrings.editProfile,
                    onTap: () => context.push('/edit-profile'),
                  ),
                  const Divider(color: AppColors.divider),
                  _buildMenuItem(
                    icon: Icons.location_on_outlined,
                    title: AppStrings.addresses,
                    onTap: () => context.push('/addresses'),
                  ),
                  const Divider(color: AppColors.divider),
                  _buildMenuItem(
                    icon: Icons.payment_rounded,
                    title: AppStrings.paymentMethods,
                    onTap: () => context.push('/payment-methods'),
                  ),
                  const Divider(color: AppColors.divider),
                  _buildMenuItem(
                    icon: Icons.receipt_long_outlined,
                    title: AppStrings.myOrders,
                    onTap: () => context.go('/orders'),
                  ),
                  const Divider(color: AppColors.divider),
                  _buildMenuItem(
                    icon: Icons.favorite_outline_rounded,
                    title: AppStrings.navFavorites,
                    onTap: () => context.go('/favorites'),
                  ),
                  const Divider(color: AppColors.divider),
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: AppStrings.settings,
                    onTap: () => context.push('/settings'),
                  ),
                  const Divider(color: AppColors.divider),
                  _buildMenuItem(
                    icon: Icons.logout_rounded,
                    title: AppStrings.logout,
                    textColor: AppColors.error,
                    iconColor: AppColors.error,
                    showArrow: false,
                    onTap: () => _onLogout(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color textColor = AppColors.textPrimary,
    Color iconColor = AppColors.primary,
    bool showArrow = true,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor, size: 22),
      title: Text(title, style: AppTextStyles.bodyMedium.copyWith(color: textColor, fontWeight: FontWeight.w500)),
      trailing: showArrow ? const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.iconGrey, size: 14) : null,
    );
  }
}
