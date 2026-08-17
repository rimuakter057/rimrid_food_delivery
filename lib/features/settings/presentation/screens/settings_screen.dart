import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_app_bar.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/app_chip.dart';
import '../../../../shared/widgets/app_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _promoOffers = true;
  String _selectedLanguage = 'English (US)';

  void _showLanguageSelector() {
    AppBottomSheet.show(
      context: context,
      title: 'Select Language',
      child: Column(
        children: ['English (US)', 'Spanish', 'French', 'German', 'Bengali'].map((lang) {
          final isSel = _selectedLanguage == lang;
          return ListTile(
            title: Text(lang, style: AppTextStyles.bodyMedium.copyWith(fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
            trailing: isSel ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
            onTap: () {
              setState(() {
                _selectedLanguage = lang;
              });
              Navigator.pop(context);
              context.showSnackBar('Language set to $lang');
            },
          );
        }).toList(),
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'RimRid Food Delivery',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: AppColors.primaryLight,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.delivery_dining_rounded, color: AppColors.primary, size: 36),
      ),
      children: [
        const SizedBox(height: 12),
        Text(
          'RimRid Food Delivery is a production-quality food delivery platform UI built with Flutter and standard Provider state management.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: AppStrings.settings),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Preferences', style: AppTextStyles.subtitle.copyWith(fontSize: 16)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.borderLg,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: _pushNotifications,
                    activeColor: AppColors.primary,
                    title: Text('Push Notifications', style: AppTextStyles.bodyMedium),
                    subtitle: Text('Receive order updates & tracking', style: AppTextStyles.caption),
                    onChanged: (val) {
                      setState(() {
                        _pushNotifications = val;
                      });
                    },
                  ),
                  const Divider(color: AppColors.divider),
                  SwitchListTile(
                    value: _promoOffers,
                    activeColor: AppColors.primary,
                    title: Text('Promotions & Discounts', style: AppTextStyles.bodyMedium),
                    subtitle: Text('Special deals and coupon alerts', style: AppTextStyles.caption),
                    onChanged: (val) {
                      setState(() {
                        _promoOffers = val;
                      });
                    },
                  ),
                  const Divider(color: AppColors.divider),
                  ListTile(
                    title: Text('Language', style: AppTextStyles.bodyMedium),
                    subtitle: Text(_selectedLanguage, style: AppTextStyles.caption),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.iconGrey, size: 14),
                    onTap: _showLanguageSelector,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text('App Information & Support', style: AppTextStyles.subtitle.copyWith(fontSize: 16)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.borderLg,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text('Theme Information', style: AppTextStyles.bodyMedium),
                    subtitle: Text('Light Mode (Design Standard)', style: AppTextStyles.caption),
                    trailing: const AppChip(label: 'Light Only', isSelected: true),
                  ),
                  const Divider(color: AppColors.divider),
                  ListTile(
                    title: Text('Privacy Policy', style: AppTextStyles.bodyMedium),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.iconGrey, size: 14),
                    onTap: () => AppDialog.showConfirm(
                      context: context,
                      title: 'Privacy Policy',
                      message: 'RimRid respects your privacy. All your data is stored locally and used exclusively for your delivery experience.',
                      confirmText: 'Got It',
                      cancelText: 'Close',
                    ),
                  ),
                  const Divider(color: AppColors.divider),
                  ListTile(
                    title: Text('Terms of Service', style: AppTextStyles.bodyMedium),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.iconGrey, size: 14),
                    onTap: () => AppDialog.showConfirm(
                      context: context,
                      title: 'Terms of Service',
                      message: 'By using RimRid Food Delivery, you agree to our standard terms of food ordering and delivery services.',
                      confirmText: 'Accept',
                      cancelText: 'Close',
                    ),
                  ),
                  const Divider(color: AppColors.divider),
                  ListTile(
                    title: Text('About RimRid Food', style: AppTextStyles.bodyMedium),
                    trailing: const Icon(Icons.info_outline_rounded, color: AppColors.iconGrey, size: 18),
                    onTap: _showAboutDialog,
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
}
