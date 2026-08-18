import 'package:flutter/material.dart';

import '../../controller/signup_controller.dart';
import '../../controller/social_auth_controller.dart';

import '../widgets/google_account_picker_sheet.dart';
import '../widgets/signup_header.dart';
import '../widgets/signup_progress.dart';
import '../widgets/signup_text_field.dart';
import '../widgets/signup_primary_button.dart';

import 'verify_email_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  final SignupController controller;

  const CreateAccountScreen({
    super.key,
    required this.controller,
  });

  @override
  State<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState
    extends State<CreateAccountScreen> {
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;

  bool ageAccepted = false;
  bool termsAccepted = false;

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void continueSignup() {
    if (fullNameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showMessage('Please fill all fields');
      return;
    }

    if (passwordController.text.length < 8) {
      showMessage(
        'Password must contain at least 8 characters',
      );
      return;
    }

    if (passwordController.text !=
        confirmPasswordController.text) {
      showMessage('Passwords do not match');
      return;
    }

    if (!ageAccepted) {
      showMessage(
        'You must be at least 18 years old',
      );
      return;
    }

    if (!termsAccepted) {
      showMessage(
        'Please accept Terms and Privacy Policy',
      );
      return;
    }

    widget.controller.saveAccount(
      fullName: fullNameController.text,
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    widget.controller.nextPage(
      context,
      VerifyEmailScreen(
        controller: widget.controller,
      ),
    );
  }

  Future<void> googleLogin() async {
    await SocialAuthController().initialize();
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GoogleAccountPickerSheet(
        onContinue: () async {
          await SocialAuthController().googleLogin(context);
        },
      ),
    );
  }

  void facebookLogin() {
    showMessage('Facebook login clicked');
  }

  void instagramLogin() {
    showMessage('Instagram login clicked');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFFFF9F9),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 10,
            ),

            child: Column(
              children: [
                SignupHeader(
                  onBack: () =>
                      widget.controller.back(context),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Create Your Heartiqo\nAccount 💗',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Start your journey toward meaningful connections',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 25),

                const SignupProgress(
                  step: 1,
                ),

                const SizedBox(height: 30),

                // FULL NAME
                SignupTextField(
                  hint: 'Full Name',
                  controller: fullNameController,
                ),

                const SizedBox(height: 15),

                // USERNAME
                SignupTextField(
                  hint: 'Username',
                  controller: usernameController,
                ),

                const SizedBox(height: 15),

                // EMAIL
                SignupTextField(
                  hint: 'Email Address',
                  controller: emailController,
                  keyboardType:
                      TextInputType.emailAddress,
                ),

                const SizedBox(height: 15),

                // PASSWORD
                SignupTextField(
                  hint: 'Password',
                  helperText:
                      'Use 8+ characters with uppercase, lowercase, number & symbol',
                  controller: passwordController,
                  obscureText: hidePassword,
                  suffixIcon: IconButton(
                    onPressed: () => setState(
                      () => hidePassword =
                          !hidePassword,
                    ),
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // CONFIRM PASSWORD
                SignupTextField(
                  hint: 'Confirm Password',
                  helperText:
                      'Re-enter the same password',
                  controller:
                      confirmPasswordController,
                  obscureText:
                      hideConfirmPassword,
                  suffixIcon: IconButton(
                    onPressed: () => setState(
                      () => hideConfirmPassword =
                          !hideConfirmPassword,
                    ),
                    icon: Icon(
                      hideConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                // AGE
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity:
                      ListTileControlAffinity.leading,
                  value: ageAccepted,
                  activeColor:
                      const Color(0xFFC00055),
                  title: const Text(
                    'I am at least 18 years old.',
                  ),
                  onChanged: (value) =>
                      setState(
                    () => ageAccepted =
                        value ?? false,
                  ),
                ),

                // TERMS
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity:
                      ListTileControlAffinity.leading,
                  value: termsAccepted,
                  activeColor:
                      const Color(0xFFC00055),
                  title: const Text(
                    'I agree to the Terms of Service and Privacy Policy.',
                  ),
                  onChanged: (value) =>
                      setState(
                    () => termsAccepted =
                        value ?? false,
                  ),
                ),

                const SizedBox(height: 15),

                // CONTINUE
                SignupPrimaryButton(
                  text: 'CONTINUE',
                  onPressed: continueSignup,
                ),

                const SizedBox(height: 20),

                // OR
                const Row(
                  children: [
                    Expanded(
                      child: Divider(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // GOOGLE
                socialButton(
                  icon: Icons.g_mobiledata,
                  text: 'Continue with Google', 
                  onPressed: googleLogin,
                ),

                // FACEBOOK
                socialButton(
                  icon: Icons.facebook,
                  text: 'Continue with Facebook',
                  onPressed: facebookLogin,
                ),

                // INSTAGRAM
                socialButton(
                  icon:
                      Icons.camera_alt_outlined,
                  text: 'Continue with Instagram',
                  onPressed: instagramLogin,
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      );

  Widget socialButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) =>
      Padding(
        padding: const EdgeInsets.only(
          bottom: 12,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 54,

          child: OutlinedButton.icon(
            onPressed: onPressed,

            icon: Icon(
              icon,
              color: const Color(
                0xFFC00055,
              ),
            ),

            label: Text(
              text,
              style: const TextStyle(
                color: Color(
                  0xFFC00055,
                ),
                fontWeight:
                    FontWeight.w600,
              ),
            ),

            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,

              side: BorderSide(
                color:
                    Colors.grey.shade300,
              ),

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(28),
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }
}