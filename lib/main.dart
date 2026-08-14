import 'package:flutter/material.dart';
import 'app/routes.dart';
import 'features/profile/view/profile_screen.dart';

void main() {
  runApp(const HeartiqoApp());
}

class HeartiqoApp extends StatelessWidget {
  const HeartiqoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Heartiqo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: false,
      ),
      home: const WelcomeScreen(),
    );
  }
}