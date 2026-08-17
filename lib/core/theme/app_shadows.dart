import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppShadows {
  static const List<BoxShadow> subtle = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 12,
      spreadRadius: 0,
      offset: Offset(0, 4),
    ),
  ];
}
