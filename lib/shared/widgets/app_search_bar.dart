import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';

class AppSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool autofocus;

  const AppSearchBar({
    super.key,
    this.hintText = 'Search food, restaurants...',
    this.controller,
    this.onChanged,
    this.onFilterTap,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.search_rounded, color: AppColors.iconGrey, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              onChanged: onChanged,
              autofocus: autofocus,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          if (controller != null && controller!.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                controller!.clear();
                if (onChanged != null) onChanged!('');
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.close_rounded, color: AppColors.iconGrey, size: 18),
              ),
            ),
          if (onFilterTap != null) ...[
            Container(
              height: 24,
              width: 1,
              color: AppColors.divider,
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            InkWell(
              onTap: onFilterTap,
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
              ),
            ),
            const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}
