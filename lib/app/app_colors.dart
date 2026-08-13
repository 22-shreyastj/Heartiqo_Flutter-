import 'package:flutter/material.dart';

class AppColors {
  static const Color magenta = Color(0xFF9C27B0);
  static const Color deepPink = Color(0xFFEC407A);
  static const Color vibrantPink = Color(0xFFC2185B);
  static const Color brandPink = Color(0xFFD81B60);
  static const Color darkPurple = Color(0xFF5E2A86);
  static const Color lightLavender = Color(0xFFF3E8FF);
  static const Color authBackground = Color(0xFFFAEFF4);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color softPinkSlot = Color(0xFFFEEBF2);
  static const Color accentGreen = Color(0xFF2E7D32);
  static const Color textDark = Color(0xFF1F1F1F);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color borderLight = Color(0xFFF3E5EC);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFff7ab6), Color(0xFF8a2be2)],
    stops: [0.0, 1.0],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFD81B60), Color(0xFF8E24AA)],
  );
}

