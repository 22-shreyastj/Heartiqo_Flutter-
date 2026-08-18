import 'package:flutter/material.dart';

import '../service/social_auth_service.dart';

class SocialAuthController {
  final SocialAuthService service =
      SocialAuthService();

  Future<void> initialize() async {
    await service.initializeGoogle();
  }

  Future<bool> googleLogin(
    BuildContext context,
  ) async {
    final user =
        await service.loginWithGoogle();

    if (user == null) {
      _showMessage(
        context,
        'Google login cancelled or failed',
      );

      return false;
    }

    _showMessage(
      context,
      'Google login successful',
    );

    print('Google Name: ${user.displayName}');
    print('Google Email: ${user.email}');

    return true;
  }

  Future<bool> facebookLogin(
    BuildContext context,
  ) async {
    final user =
        await service.loginWithFacebook();

    if (user == null) {
      _showMessage(
        context,
        'Facebook login cancelled or failed',
      );

      return false;
    }

    _showMessage(
      context,
      'Facebook login successful',
    );

    print('Facebook User: $user');

    return true;
  }

  void instagramLogin(
    BuildContext context,
  ) {
    _showMessage(
      context,
      'Instagram requires Meta OAuth configuration',
    );
  }

  void _showMessage(
    BuildContext context,
    String message,
  ) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
}