import 'package:flutter/material.dart';

import 'features/authentication/presentation/screens/welcome_screen.dart';

void main() {
  runApp(const HeartiqoApp());
}

class HeartiqoApp extends StatelessWidget {
  const HeartiqoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}