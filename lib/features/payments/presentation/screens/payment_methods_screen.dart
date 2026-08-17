import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/payment_method_model.dart';
import '../../../../shared/widgets/app_app_bar.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_empty_view.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../providers/payment_provider.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  void _showAddCardModal(BuildContext context) {
    final titleController = TextEditingController(text: 'Visa Card');
    final numberController = TextEditingController();
    final expiryController = TextEditingController();

    AppBottomSheet.show(
      context: context,
      title: AppStrings.addCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'Card Nickname',
            hint: 'e.g. Visa Personal',
            controller: titleController,
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Card Number',
            hint: '4532 •••• •••• 8821',
            controller: numberController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Expiry Date',
                  hint: 'MM/YY',
                  controller: expiryController,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: AppTextField(
                  label: 'CVV',
                  hint: '•••',
                  isPassword: true,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'Save Payment Card',
            onPressed: () {
              final last4 = numberController.text.trim().length >= 4
                  ? numberController.text.trim().substring(numberController.text.trim().length - 4)
                  : '9921';
              context.read<PaymentProvider>().addPaymentMethod(
                    type: PaymentType.visa,
                    title: titleController.text.trim().isEmpty ? 'Visa Card' : titleController.text.trim(),
                    lastFour: last4,
                    expiryDate: expiryController.text.trim().isEmpty ? '12/28' : expiryController.text.trim(),
                    isDefault: false,
                  );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = context.watch<PaymentProvider>();
    final paymentMethods = paymentProvider.paymentMethods;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: AppStrings.paymentMethods),
      body: paymentMethods.isEmpty
          ? AppEmptyView(
              icon: Icons.credit_card_off_rounded,
              title: 'No Payment Methods',
              description: 'Add a card to pay seamlessly.',
              buttonText: AppStrings.addCard,
              onButtonPressed: () => _showAddCardModal(context),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: paymentMethods.length,
                    itemBuilder: (context, index) {
                      final item = paymentMethods[index];
                      final isSelected = paymentProvider.selectedPaymentMethod.id == item.id;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: AppRadius.borderLg,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: item.id,
                              groupValue: paymentProvider.selectedPaymentMethod.id,
                              activeColor: AppColors.primary,
                              onChanged: (val) {
                                if (val != null) paymentProvider.setDefaultPaymentMethod(val);
                              },
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: AppColors.chipBackground,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                item.type == PaymentType.cod ? Icons.payments_outlined : Icons.credit_card_rounded,
                                color: AppColors.primary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(item.title, style: AppTextStyles.subtitle.copyWith(fontSize: 15)),
                                      if (item.isDefault) ...[
                                        const SizedBox(width: 6),
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
                                  if (item.lastFour != null)
                                    Text('•••• •••• •••• ${item.lastFour}  (${item.expiryDate})', style: AppTextStyles.caption),
                                ],
                              ),
                            ),
                            if (item.type != PaymentType.cod)
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.iconGrey, size: 20),
                                onPressed: () {
                                  paymentProvider.deletePaymentMethod(item.id);
                                  context.showSnackBar('Payment method removed');
                                },
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    text: AppStrings.addCard,
                    type: AppButtonType.outline,
                    icon: const Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
                    onPressed: () => _showAddCardModal(context),
                  ),
                ],
              ),
            ),
    );
  }
}
