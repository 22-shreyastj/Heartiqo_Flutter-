import 'package:flutter/material.dart';

import '../../controller/signup_controller.dart';
import '../widgets/signup_primary_button.dart';

class SignupSuccessScreen extends StatelessWidget {
  final SignupController controller;

  const SignupSuccessScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFFFF9F9),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 25,
            ),

            child: Column(
              children: [
                const SizedBox(height: 30),

                // Success Icon
                Container(
                  width: 95,
                  height: 95,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFE5005A),
                        Color(0xFFB420C9),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.check,
                        color: Color(0xFFE5005A),
                        size: 38,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "You're All Set! 🎉",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 27,
                    color: Color(0xFFC00055),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Your Heartiqo account is ready.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 30),

                // Status Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE8EF),
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: const Column(
                    children: [
                      SuccessRow(
                        icon: Icons.person_add_alt,
                        text: 'Account Created',
                      ),

                      Divider(height: 28),

                      SuccessRow(
                        icon: Icons.account_box_outlined,
                        text: 'Profile Created',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Start Exploring
                SignupPrimaryButton(
                  text: 'START EXPLORING',
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    debugPrint('Start Exploring');
                  },
                ),

                const SizedBox(height: 14),

                // Edit Profile
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () =>
                        Navigator.pop(context),

                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          const Color(0xFFC00055),

                      side: const BorderSide(
                        color: Color(0xFFC00055),
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),

                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
}

class SuccessRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const SuccessRow({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFC00055),
            size: 22,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 21,
          ),
        ],
      );
}