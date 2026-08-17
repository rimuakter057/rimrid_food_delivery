import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_app_bar.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_empty_view.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../providers/address_provider.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  void _showAddAddressModal(BuildContext context) {
    final labelController = TextEditingController();
    final addressController = TextEditingController();
    final detailsController = TextEditingController();
    bool isDefault = false;

    AppBottomSheet.show(
      context: context,
      title: AppStrings.addAddress,
      child: StatefulBuilder(
        builder: (context, setStateModal) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: 'Label (e.g. Home, Work)',
                hint: 'Home',
                controller: labelController,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Full Address',
                hint: '124 Grand Avenue, Apt 4B',
                controller: addressController,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Details / Landmark',
                hint: 'Central District, NY 10001',
                controller: detailsController,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Checkbox(
                    value: isDefault,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setStateModal(() {
                        isDefault = val ?? false;
                      });
                    },
                  ),
                  Text('Set as default delivery address', style: AppTextStyles.bodyMedium),
                ],
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Save Address',
                onPressed: () {
                  if (addressController.text.trim().isEmpty) return;
                  context.read<AddressProvider>().addAddress(
                        label: labelController.text.trim().isEmpty ? 'Address' : labelController.text.trim(),
                        fullAddress: addressController.text.trim(),
                        details: detailsController.text.trim(),
                        isDefault: isDefault,
                      );
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.watch<AddressProvider>();
    final addresses = addressProvider.addresses;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: AppStrings.addresses),
      body: addresses.isEmpty
          ? AppEmptyView(
              icon: Icons.location_off_rounded,
              title: 'No Saved Addresses',
              description: 'Add a delivery address to order food quickly.',
              buttonText: AppStrings.addAddress,
              onButtonPressed: () => _showAddAddressModal(context),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      final addr = addresses[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: AppRadius.borderLg,
                          border: Border.all(
                            color: addr.isDefault ? AppColors.primary : AppColors.border,
                            width: addr.isDefault ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Radio<String>(
                              value: addr.id,
                              groupValue: addressProvider.selectedAddress.id,
                              activeColor: AppColors.primary,
                              onChanged: (val) {
                                if (val != null) addressProvider.setDefaultAddress(val);
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(addr.label, style: AppTextStyles.subtitle.copyWith(fontSize: 16)),
                                      if (addr.isDefault) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryLight,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text('DEFAULT', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(addr.fullAddress, style: AppTextStyles.bodyMedium),
                                  if (addr.details.isNotEmpty)
                                    Text(addr.details, style: AppTextStyles.bodySmall),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.iconGrey, size: 20),
                              onPressed: () {
                                addressProvider.deleteAddress(addr.id);
                                context.showSnackBar('Address removed');
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    text: AppStrings.addAddress,
                    type: AppButtonType.outline,
                    icon: const Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
                    onPressed: () => _showAddAddressModal(context),
                  ),
                ],
              ),
            ),
    );
  }
}
