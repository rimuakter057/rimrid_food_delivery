import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';

class AppQuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final int minQuantity;
  final int maxQuantity;

  const AppQuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.minQuantity = 1,
    this.maxQuantity = 99,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.chipBackground,
        borderRadius: AppRadius.borderCircular,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            icon: Icons.remove_rounded,
            onPressed: quantity > minQuantity
                ? () => onChanged(quantity - 1)
                : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$quantity',
              style: AppTextStyles.subtitle.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildButton(
            icon: Icons.add_rounded,
            onPressed: quantity < maxQuantity
                ? () => onChanged(quantity + 1)
                : null,
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    VoidCallback? onPressed,
    bool isPrimary = false,
  }) {
    final bool enabled = onPressed != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: enabled
                ? (isPrimary ? AppColors.primary : AppColors.surface)
                : AppColors.border,
            shape: BoxShape.circle,
            boxShadow: enabled && !isPrimary
                ? const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 4,
                    )
                  ]
                : null,
          ),
          child: Icon(
            icon,
            size: 16,
            color: enabled
                ? (isPrimary ? AppColors.textWhite : AppColors.textPrimary)
                : AppColors.textLight,
          ),
        ),
      ),
    );
  }
}
