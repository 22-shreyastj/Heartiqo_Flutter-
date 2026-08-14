import 'package:flutter/material.dart';

import '../../controller/signup_controller.dart';

import '../widgets/animated_profile_network.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/google_login_button.dart';

import 'phone_login_screen.dart';
import 'create_account_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFF72B5),
                Color(0xFF9C27E8),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 20,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // TITLE
                  const Text(
                    'Welcome to Heartiqo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF66338C),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // EXISTING PROFILE NETWORK
                  SizedBox(
                      height: 330,
                      child: AnimatedProfileNetwork(maxSize: 330),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'LOGIN WITH',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D103A),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // LOGIN WITH PHONE
                  AuthPrimaryButton(
                    label: 'Login with Phone',
                    icon: Icons.phone,
                    animateIcon: false,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const PhoneLoginScreen(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // GOOGLE LOGIN
                  GoogleLoginButton(
  label: 'Continue with Google',
  onTap: () {
    debugPrint('Google login clicked');
  },
),

                  const SizedBox(height: 22),

                  // SIGN UP SECTION
                  Row(

                    
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(width: 6),

                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CreateAccountScreen(
                              controller:
                                  SignupController(),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      );
}