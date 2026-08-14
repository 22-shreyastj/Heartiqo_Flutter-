import 'package:flutter/material.dart';

class AppColors {
  // Recommended Brand System
  static const Color primary = Color(0xFF6C3BFF); // Electric Violet
  static const Color emotionalAccent = Color(0xFFFF5C7A); // Emotional Coral Pink
  static const Color dark = Color(0xFF111827); // Dark Slate
  static const Color background = Color(0xFFF8F7FC); // Soft White Lavender
  static const Color secondaryAccent = Color(0xFFFFB86B); // Sunburst Amber

  // Compatibility & Design Aliases
  static const Color deepPink = emotionalAccent;
  static const Color darkPurple = dark;
  static const Color magenta = primary;
  static const Color lightLavender = Color(0xFFEDE9FE);
  static const Color authBackground = background;
  static const Color cardBackground = Colors.white;

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
    colors: [Color(0xFF6C3BFF), Color(0xFFFF5C7A), Color(0xFF111827)],
    stops: [0.0, 0.55, 1.0],
  );
}
