import 'package:flutter/material.dart';

class AppColors {
  static const Color magenta = Color(0xFF9C27B0);
  static const Color deepPink = Color(0xFFEC407A);
  static const Color darkPurple = Color(0xFF5E2A86);
  static const Color lightLavender = Color(0xFFF3E8FF);
  static const Color authBackground = Color(0xFFFFE7F5);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFff7ab6), Color(0xFF8a2be2)],
    stops: [0.0, 1.0],
  );
}
