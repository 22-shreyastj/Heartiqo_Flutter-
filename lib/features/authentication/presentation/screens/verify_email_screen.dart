import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../controller/signup_controller.dart';

import '../widgets/signup_header.dart';
import '../widgets/signup_primary_button.dart';
import '../widgets/signup_progress.dart';

import 'profile_photo_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  final SignupController controller;

  const VerifyEmailScreen({
    super.key,
    required this.controller,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  late final List<TextEditingController> _otpControllers;
  late final List<FocusNode> _focusNodes;
  Timer? _timer;
  int _secondsRemaining = 60;
  String? _errorMessage;
  String? _successMessage;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (index) {
      final node = FocusNode();
      node.onKeyEvent =
          (focusNode, event) => _handleKeyEvent(focusNode, event, index);
      return node;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining > 1) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _secondsRemaining = 0;
        });
        timer.cancel();
      }
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_otpControllers[index].text.isEmpty && index > 0) {
        _otpControllers[index - 1].clear();
        _focusNodes[index - 1].requestFocus();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void _onDigitChanged(int index, String value) {
    setState(() {
      _errorMessage = null;
      _successMessage = null;
    });

    // Handle full paste of 6 digits
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.length >= 6) {
        for (int i = 0; i < 6; i++) {
          _otpControllers[i].text = digits[i];
        }
        _focusNodes[5].requestFocus();
        return;
      } else {
        _otpControllers[index].text = digits.isNotEmpty ? digits[0] : '';
      }
    }

    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }

  String get _enteredOtp =>
      _otpControllers.map((c) => c.text.trim()).join();

  // Temporary mock verification - easily replaceable with backend API call
  Future<bool> _verifyOtpApi(String email, String otp) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return otp == '123456';
  }

  Future<void> _handleVerify() async {
    final otp = _enteredOtp;

    if (otp.length < 6) {
      setState(() {
        _errorMessage = 'Please enter the complete 6-digit OTP';
        _successMessage = null;
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final bool isSuccess = await _verifyOtpApi(
      widget.controller.signupModel.email,
      otp,
    );

    if (!mounted) return;

    setState(() {
      _isVerifying = false;
    });

    if (isSuccess) {
      setState(() {
        _successMessage = 'Email verified successfully';
        _errorMessage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email verified successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        widget.controller.nextPage(
          context,
          ProfilePhotoScreen(
            controller: widget.controller,
          ),
        );
      });
    } else {
      setState(() {
        _errorMessage = 'Invalid OTP. Please try again.';
        _successMessage = null;
      });
    }
  }

  void _resendOtp() {
    if (_secondsRemaining > 0) return;

    setState(() {
      for (final c in _otpControllers) {
        c.clear();
      }
      _errorMessage = null;
      _successMessage = null;
    });
    _focusNodes[0].requestFocus();

    _startTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('A new OTP has been sent to your email'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.controller.signupModel.email.isNotEmpty
        ? widget.controller.signupModel.email
        : 'your email';

    return Scaffold(
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
                onBack: () => widget.controller.back(context),
              ),

              const SignupProgress(
                step: 2,
              ),

              const SizedBox(height: 25),

              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE5005A),
                ),
                child: const Icon(
                  Icons.email_outlined,
                  size: 45,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Verify Your Email Address',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'We sent a verification code to',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 4),

              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => widget.controller.back(context),
                    child: const Text(
                      'Change Email',
                      style: TextStyle(
                        color: Color(0xFFC00055),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // 6-digit OTP Inputs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 46,
                    height: 56,
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 6,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC00055),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errorMessage != null
                                ? Colors.red
                                : Colors.grey.shade300,
                            width: _errorMessage != null ? 1.5 : 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errorMessage != null
                                ? Colors.red
                                : Colors.grey.shade300,
                            width: _errorMessage != null ? 1.5 : 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errorMessage != null
                                ? Colors.red
                                : const Color(0xFFC00055),
                            width: 1.8,
                          ),
                        ),
                      ),
                      onChanged: (value) => _onDigitChanged(index, value),
                    ),
                  );
                }),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],

              if (_successMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _successMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],

              const SizedBox(height: 25),

              // Resend OTP & Timer
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  if (_secondsRemaining > 0)
                    Text(
                      'Resend OTP in ${_secondsRemaining}s',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: _resendOtp,
                      child: const Text(
                        'Resend OTP',
                        style: TextStyle(
                          color: Color(0xFFC00055),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 30),

              // VERIFY Button
              SignupPrimaryButton(
                text: 'VERIFY',
                icon: Icons.check_circle_outline,
                onPressed: _isVerifying ? () {} : _handleVerify,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}