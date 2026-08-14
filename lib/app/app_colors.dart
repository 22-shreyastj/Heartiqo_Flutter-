import 'package:flutter/material.dart';

class AppColors {
  // Recommended Brand System
  static const Color primary = Color(0xFF6C3BFF);
  static const Color emotionalAccent = Color(0xFFFF5C7A);
  static const Color dark = Color(0xFF111827);
  static const Color background = Color(0xFFF8F7FC);
  static const Color secondaryAccent = Color(0xFFFFB86B);

  // Compatibility & Design Aliases
  static const Color deepPink = emotionalAccent;
  static const Color darkPurple = dark;
  static const Color magenta = primary;
  static const Color lightLavender = Color(0xFFEDE9FE);
  static const Color authBackground = background;
  static const Color cardBackground = Colors.white;

  // Profile / existing design colors
  static const Color vibrantPink = Color(0xFFC2185B);
  static const Color brandPink = Color(0xFFD81B60);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color softPinkSlot = Color(0xFFFEEBF2);
  static const Color accentGreen = Color(0xFF2E7D32);
  static const Color textDark = Color(0xFF1F1F1F);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color borderLight = Color(0xFFF3E5EC);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6C3BFF), Color(0xFFFF5C7A)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF5C7A), Color(0xFFFFB86B)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF6C3BFF), Color(0xFF111827)],
    stops: [0.0, 1.0],
  );

  static const LinearGradient matchGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF6C3BFF),
      Color(0xFFFF5C7A),
      Color(0xFF111827),
    ],
    stops: [0.0, 0.55, 1.0],
  );
}