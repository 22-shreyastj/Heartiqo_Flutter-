import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/app_colors.dart';
import '../widgets/auth_primary_button.dart';
import 'otp.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final String _countryCode = '+91';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _continuePressed() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final formattedPhone = '$_countryCode ${_phoneController.text.trim()}';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OtpScreen(phoneNumber: formattedPhone),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;

            final horizontalPadding = isTablet ? 64.0 : 24.0;

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 28,
              ),

              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 56,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [
                    // =================================================
                    // HEADER
                    // =================================================
                    Text(
                      'Welcome to Heartiqo',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: isTablet ? 40 : 32,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkPurple,
                      ),
                    ),

                    const SizedBox(height: 36),

                    Text(
                      'My mobile',
                      style: TextStyle(
                        fontSize: isTablet ? 28 : 25,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkPurple,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Please enter your valid phone number. '
                      'We will send you a 4-digit code to verify your account.',
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        color: AppColors.darkPurple.withValues(alpha: 0.72),
                        height: 1.55,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // =================================================
                    // PHONE FORM
                    // =================================================
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _phoneController,

                        // Use number keyboard.
                        keyboardType: TextInputType.number,

                        textInputAction: TextInputAction.done,

                        style: TextStyle(
                          fontSize: isTablet ? 19 : 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkPurple,
                          letterSpacing: 0.5,
                        ),

                        cursorColor: AppColors.darkPurple,

                        // Keep validation from appearing immediately.
                        autovalidateMode: AutovalidateMode.onUserInteraction,

                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,

                          hintText: 'Enter mobile number',

                          hintStyle: TextStyle(
                            color: AppColors.darkPurple.withValues(alpha: 0.35),
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.w400,
                          ),

                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '🇮🇳',
                                  style: TextStyle(fontSize: 21),
                                ),

                                const SizedBox(width: 8),

                                Text(
                                  _countryCode,
                                  style: TextStyle(
                                    color: AppColors.darkPurple,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                const SizedBox(width: 4),

                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 20,
                                  color: AppColors.darkPurple.withValues(alpha: 0.55),
                                ),

                                const SizedBox(width: 8),

                                Container(
                                  width: 1,
                                  height: 28,
                                  color: AppColors.darkPurple.withValues(alpha: 0.12),
                                ),
                              ],
                            ),
                          ),

                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.darkPurple.withValues(alpha: 0.10),
                            ),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.darkPurple.withValues(alpha: 0.10),
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.darkPurple,
                              width: 1.5,
                            ),
                          ),

                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: Colors.red.withValues(alpha: 0.65),
                            ),
                          ),

                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: Colors.red.withValues(alpha: 0.70),
                              width: 1.5,
                            ),
                          ),

                          errorStyle: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        validator: (value) {
                          final phone = value?.trim() ?? '';

                          if (phone.isEmpty) {
                            return 'Please enter your mobile number';
                          }

                          if (phone.length != 10) {
                            return 'Enter a valid 10-digit mobile number';
                          }

                          return null;
                        },

                        onChanged: (value) {
                          debugPrint('PHONE VALUE: $value');
                        },

                        onFieldSubmitted: (_) {
                          _continuePressed();
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // =================================================
                    // CONTINUE BUTTON
                    // =================================================
                    AuthPrimaryButton(
                      label: 'Continue',
                      icon: Icons.arrow_forward,
                      animateIcon: false,
                      onTap: _continuePressed,
                    ),

                    const SizedBox(height: 20),

                    // =================================================
                    // SMALL PRIVACY MESSAGE
                    // =================================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'By continuing, you agree to our Terms '
                        'and Privacy Policy.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.darkPurple.withValues(alpha: 0.48),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
