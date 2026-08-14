import 'package:flutter/material.dart';
import '../features/authentication/presentation/screens/welcome_screen.dart';
import '../features/profile/view/profile_screen.dart';
import 'route_names.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
        RouteNames.welcome: (context) => const WelcomeScreen(),
        RouteNames.profile: (context) => const ProfileScreen(),
      };
}
