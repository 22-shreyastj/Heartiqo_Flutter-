import 'package:flutter/material.dart';
import '../features/authentication/presentation/screens/welcome_screen.dart';
import '../features/help/view/help_support_screen.dart';
import '../features/profile/controller/profile_controller.dart';
import '../features/profile/view/account_screen.dart';
import '../features/profile/view/profile_screen.dart';
import '../features/safety_center/view/safety_center_screen.dart';
import '../features/settings/view/discovery_settings_screen.dart';
import '../features/subscription/view/upgrade_subscription_screen.dart';
import 'route_names.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
        RouteNames.welcome: (context) => const WelcomeScreen(),
        RouteNames.profile: (context) => const ProfileScreen(),
        RouteNames.account: (context) => AccountScreen(controller: ProfileController()),
        RouteNames.subscription: (context) => const UpgradeSubscriptionScreen(),
        RouteNames.discoverySettings: (context) => const DiscoverySettingsScreen(),
        RouteNames.safetyCenter: (context) => const SafetyCenterScreen(),
        RouteNames.helpSupport: (context) => const HelpSupportScreen(),
      };
}
