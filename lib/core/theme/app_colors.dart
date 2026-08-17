import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary & Accent Colors
  static const Color primary = Color(0xFFFF6B00); // Warm Orange
  static const Color primaryLight = Color(0xFFFFF0E6);
  static const Color primaryDark = Color(0xFFD95A00);
  
  // Backgrounds & Surfaces
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1D26);
  static const Color textSecondary = Color(0xFF6C727F);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status & State Colors
  static const Color success = Color(0xFF28C76F);
  static const Color successLight = Color(0xFFE8FADF);
  static const Color error = Color(0xFFEA5455);
  static const Color errorLight = Color(0xFFFCEAEA);
  static const Color warning = Color(0xFFFF9F43);
  static const Color warningLight = Color(0xFFFFF4E5);
  static const Color rating = Color(0xFFFFB800);

  // Borders & Dividers
  static const Color border = Color(0xFFEEEEEE);
  static const Color borderFocused = Color(0xFFFF6B00);
  static const Color divider = Color(0xFFF0F0F0);

  // Grey Scale & UI Elements
  static const Color inputBackground = Color(0xFFF8F9FA);
  static const Color chipBackground = Color(0xFFF3F4F6);
  static const Color iconGrey = Color(0xFF8E8E93);
  static const Color shadow = Color(0x0C000000);
  static const Color overlay = Color(0x40000000);
}
