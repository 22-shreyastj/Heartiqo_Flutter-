import 'package:flutter/material.dart';

import '../../controller/signup_controller.dart';

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

  bool hasSubmitted = false;

  String? fullNameError;
  String? usernameError;
  String? emailError;
  String? passwordError;
  String? passwordSuccess;
  String? confirmPasswordError;
  String? confirmPasswordSuccess;

  bool _isStrongPassword(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    if (!password.contains(RegExp(r'[^a-zA-Z0-9]'))) return false;
    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email.trim());
  }

  void _validatePasswordLive() {
    final text = passwordController.text;
    if (text.isEmpty) {
      if (hasSubmitted) {
        passwordError =
            'Use 8+ characters with uppercase, lowercase, number & special character';
      } else {
        passwordError = null;
      }
      passwordSuccess = null;
    } else if (_isStrongPassword(text)) {
      passwordError = null;
      passwordSuccess = 'Strong password';
    } else {
      passwordError =
          'Use 8+ characters with uppercase, lowercase, number & special character';
      passwordSuccess = null;
    }

    if (confirmPasswordController.text.isNotEmpty ||
        (hasSubmitted && confirmPasswordController.text.isEmpty)) {
      _validateConfirmPasswordLive();
    }
  }

  void _validateConfirmPasswordLive() {
    final text = confirmPasswordController.text;
    if (text.isEmpty) {
      if (hasSubmitted) {
        confirmPasswordError = 'Please confirm your password';
      } else {
        confirmPasswordError = null;
      }
      confirmPasswordSuccess = null;
    } else if (text == passwordController.text) {
      confirmPasswordError = null;
      confirmPasswordSuccess = 'Passwords match';
    } else {
      confirmPasswordError = 'Passwords do not match';
      confirmPasswordSuccess = null;
    }
  }

  void _validateAllFields() {
    // Full Name
    if (fullNameController.text.trim().isEmpty) {
      fullNameError = 'Full name is required';
    } else {
      fullNameError = null;
    }

    // Username
    if (usernameController.text.trim().isEmpty) {
      usernameError = 'Username is required';
    } else {
      usernameError = null;
    }

    // Email
    if (emailController.text.trim().isEmpty) {
      emailError = 'Email address is required';
    } else if (!_isValidEmail(emailController.text)) {
      emailError = 'Enter a valid email address';
    } else {
      emailError = null;
    }

    // Password
    _validatePasswordLive();

    // Confirm Password
    _validateConfirmPasswordLive();
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void continueSignup() {
    setState(() {
      hasSubmitted = true;
      _validateAllFields();
    });

    if (fullNameError != null ||
        usernameError != null ||
        emailError != null ||
        passwordError != null ||
        passwordSuccess == null ||
        confirmPasswordError != null ||
        confirmPasswordSuccess == null) {
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
      fullName: fullNameController.text.trim(),
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    widget.controller.nextPage(
      context,
      VerifyEmailScreen(
        controller: widget.controller,
      ),
    );
  }

  void googleLogin() {
    showMessage('Google login clicked');
  }

  void facebookLogin() {
    showMessage('Facebook login clicked');
  }

  void instagramLogin() {
    showMessage('Instagram login clicked');
  }

  Widget _buildPasswordSuffixIcon() {
    final bool isStrong = _isStrongPassword(passwordController.text);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isStrong)
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            ),
          ),
        IconButton(
          onPressed: () => setState(
            () => hidePassword = !hidePassword,
          ),
          icon: Icon(
            hidePassword
                ? Icons.visibility_off
                : Icons.visibility,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordSuffixIcon() {
    final bool isMatch = confirmPasswordController.text.isNotEmpty &&
        confirmPasswordController.text == passwordController.text;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isMatch)
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            ),
          ),
        IconButton(
          onPressed: () => setState(
            () => hideConfirmPassword = !hideConfirmPassword,
          ),
          icon: Icon(
            hideConfirmPassword
                ? Icons.visibility_off
                : Icons.visibility,
          ),
        ),
      ],
    );
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
                  errorText: fullNameError,
                  onChanged: (value) {
                    if (hasSubmitted || fullNameError != null) {
                      setState(() {
                        fullNameError = value.trim().isEmpty
                            ? 'Full name is required'
                            : null;
                      });
                    }
                  },
                ),

                const SizedBox(height: 15),

                // USERNAME
                SignupTextField(
                  hint: 'Username',
                  controller: usernameController,
                  errorText: usernameError,
                  onChanged: (value) {
                    if (hasSubmitted || usernameError != null) {
                      setState(() {
                        usernameError = value.trim().isEmpty
                            ? 'Username is required'
                            : null;
                      });
                    }
                  },
                ),

                const SizedBox(height: 15),

                // EMAIL
                SignupTextField(
                  hint: 'Email Address',
                  controller: emailController,
                  keyboardType:
                      TextInputType.emailAddress,
                  errorText: emailError,
                  onChanged: (value) {
                    if (hasSubmitted || emailError != null) {
                      setState(() {
                        if (value.trim().isEmpty) {
                          emailError = 'Email address is required';
                        } else if (!_isValidEmail(value)) {
                          emailError = 'Enter a valid email address';
                        } else {
                          emailError = null;
                        }
                      });
                    }
                  },
                ),

                const SizedBox(height: 15),

                // PASSWORD
                SignupTextField(
                  hint: 'Password',
                  helperText:
                      'Use 8+ characters with uppercase, lowercase, number & special character',
                  controller: passwordController,
                  obscureText: hidePassword,
                  errorText: passwordError,
                  successText: passwordSuccess,
                  onChanged: (value) {
                    setState(() {
                      _validatePasswordLive();
                    });
                  },
                  suffixIcon: _buildPasswordSuffixIcon(),
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
                  errorText: confirmPasswordError,
                  successText: confirmPasswordSuccess,
                  onChanged: (value) {
                    setState(() {
                      _validateConfirmPasswordLive();
                    });
                  },
                  suffixIcon: _buildConfirmPasswordSuffixIcon(),
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