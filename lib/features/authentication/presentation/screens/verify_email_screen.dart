import 'package:flutter/material.dart';

import '../../controller/signup_controller.dart';

import '../widgets/signup_header.dart';
import '../widgets/signup_primary_button.dart';

import 'profile_photo_screen.dart';

class VerifyEmailScreen extends StatelessWidget {
  final SignupController controller;

  const VerifyEmailScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFFFF9F9),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: Column(
              children: [
                SignupHeader(
                  onBack: () =>
                      controller.back(context),
                ),

                const SizedBox(height: 65),

                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFE5005A),
                  ),
                  child: const Icon(
                    Icons.email_outlined,
                    size: 50,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 35),

                const Text(
                  'Verify Your Gmail ID',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 31,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  "We've also sent a link to your registered email address.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 25),

                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      controller.signupModel.email,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    TextButton(
                      onPressed: () =>
                          controller.back(context),
                      child: const Text(
                        'Change Email',
                        style: TextStyle(
                          color: Color(0xFFC00055),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                SignupPrimaryButton(
                  text: 'VERIFY GMAIL',
                  icon: Icons.check_circle_outline,
                  onPressed: () =>
                      controller.nextPage(
                    context,
                    ProfilePhotoScreen(
                      controller: controller,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}