import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/app_colors.dart';
import 'phone_login_screen.dart';
import '../widgets/animated_profile_network.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/google_login_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _notImplemented(BuildContext context, String action) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$action not implemented')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final screenHeight = constraints.maxHeight;

              final isTablet = screenWidth >= 600;

              // Larger orbit for the reference design.
              final networkMax =
                  math.min(screenWidth, screenHeight) *
                  (isTablet ? 0.72 : 0.82);

              return Column(
                children: [
                  const SizedBox(height: 20),

                  // ------------------------------------------------
                  // TITLE
                  // ------------------------------------------------
                  Text(
                    'Welcome to Heartiqo',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: isTablet ? 36 : 32,
                      color: AppColors.darkPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ------------------------------------------------
                  // ANIMATED PROFILE NETWORK
                  // ------------------------------------------------
                  Expanded(
                    child: Center(
                      child: AnimatedProfileNetwork(maxSize: networkMax),
                    ),
                  ),

                  // ------------------------------------------------
                  // LOGIN SECTION
                  // ------------------------------------------------
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 80 : 24,
                      vertical: 12,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'LOGIN WITH',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 28,
                              color: const Color.fromARGB(255, 42, 30, 51),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),

                          const SizedBox(height: 12),

                          AuthPrimaryButton(
                            label: 'Login with Phone',
                            icon: Icons.phone,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PhoneLoginScreen(),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 12),

                          GoogleLoginButton(
                            label: 'Login with Google',
                            onTap: () =>
                                _notImplemented(context, 'Google login'),
                          ),

                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Colors.white70),
                              ),
                              TextButton(
                                onPressed: () =>
                                    _notImplemented(context, 'Sign Up'),
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
