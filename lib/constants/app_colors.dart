// lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Onboarding Screen
  // Custom palette requested by user
  static const Color purple1 = Color(0xFF230989); // #230989
  static const Color purple2 = Color(0xFF250088); // #250088
  static const Color purple3 = Color(0xFF6B3AEE); // #6B3AEE
  static const Color lightPanel = Color(0xFFF6F3FF);
  static const Color buttonTextColor = Color(0xFF5A2DB6);
  static const Color panelTextColor = Color(0xFF6B5A84);

  // General App
  static const Color primary = Color(0xFF5A2DB6);
  static const Color secondary = Color(0xFF6C3EB0);
  static const Color background = Color(0xFFF6F3FF);
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);

  // Gradients
  static const Gradient purpleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [purple1, purple2, purple3],
    stops: [0.0, 0.5, 1.0],
  );
}
