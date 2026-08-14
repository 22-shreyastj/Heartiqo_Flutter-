import 'package:flutter/material.dart';
import 'app/app_colors.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HeartIQo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.emotionalAccent,
          tertiary: AppColors.secondaryAccent,
          surface: AppColors.background,
          onSurface: AppColors.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}
