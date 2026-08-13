import 'package:flutter/material.dart';
import 'app/routes.dart';
import 'features/profile/view/profile_screen.dart';

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
        primarySwatch: Colors.purple,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      routes: AppRoutes.routes,
      home: const ProfileScreen(),
    );
  }
}
