import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final Color color;
  final double indent;
  final double endIndent;

  const AppDivider({
    super.key,
    this.height = 16,
    this.thickness = 1,
    this.color = AppColors.divider,
    this.indent = 0,
    this.endIndent = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness,
      color: color,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
