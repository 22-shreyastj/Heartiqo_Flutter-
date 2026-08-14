import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/app_colors.dart';
import '../../../../home_page.dart';
import '../widgets/otp_code_input.dart';
import '../widgets/otp_numeric_keypad.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<String> _digits = [];
  late Timer _timer;
  Duration _timeLeft = const Duration(seconds: 42);

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds == 0) {
        timer.cancel();
        return;
      }

      setState(() {
        _timeLeft = _timeLeft - const Duration(seconds: 1);
      });
    });
  }

  void _addDigit(String digit) {
    if (_digits.length >= 4) return;

    setState(() {
      _digits.add(digit);
    });

    if (_digits.length == 4) {
      _navigateToProfile();
    }
  }

  void _removeDigit() {
    if (_digits.isEmpty) return;

    setState(() {
      _digits.removeLast();
    });
  }

  void _sendAgain() {
    if (_timer.isActive) {
      _timer.cancel();
    }

    setState(() {
      _digits.clear();
      _timeLeft = const Duration(seconds: 42);
    });

    _startCountdown();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('A new code has been requested')),
    );
  }

  void _navigateToProfile() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _editNumber() {
    Navigator.of(context).pop();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;
            final horizontalPadding = isTablet ? 48.0 : 24.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      'Enter the 4-digit code',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: isTablet ? 34 : 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkPurple,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            'Sent to ${widget.phoneNumber}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.darkPurple.withOpacity(0.75),
                              fontSize: isTablet ? 16 : 14,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _editNumber,
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              color: AppColors.deepPink,
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      _formatDuration(_timeLeft),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isTablet ? 56 : 48,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkPurple,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Type the verification code we’ve sent you',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.darkPurple.withOpacity(0.75),
                        fontSize: isTablet ? 18 : 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    OtpCodeInput(digits: _digits),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: OtpNumericKeypad(
                        onKeyTap: _addDigit,
                        onDelete: _removeDigit,
                        disabled: false,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: _sendAgain,
                      child: const Text('Send again'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.darkPurple,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
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
