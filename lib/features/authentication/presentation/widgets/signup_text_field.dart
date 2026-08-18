import 'package:flutter/material.dart';

class SignupTextField extends StatelessWidget {
  final String hint;
  final String? helperText;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? errorText;
  final String? successText;
  final ValueChanged<String>? onChanged;

  const SignupTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.helperText,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.errorText,
    this.successText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasError = errorText != null && errorText!.isNotEmpty;
    final bool hasSuccess =
        !hasError && successText != null && successText!.isNotEmpty;

    final Color borderColor = hasError
        ? Colors.red
        : (hasSuccess ? Colors.green : Colors.grey.shade400);

    final Color focusedBorderColor = hasError
        ? Colors.red
        : (hasSuccess ? Colors.green : const Color(0xFFC00055));

    final String? displayedHelper = hasSuccess ? successText : helperText;
    final Color helperColor = hasSuccess ? Colors.green : Colors.grey;

    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        errorText: hasError ? errorText : null,
        errorMaxLines: 2,
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        helperText: hasError ? null : displayedHelper,
        helperStyle: TextStyle(
          color: helperColor,
          fontSize: 12,
          fontWeight: hasSuccess ? FontWeight.w600 : FontWeight.normal,
        ),
        helperMaxLines: 2,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor,
            width: (hasError || hasSuccess) ? 1.5 : 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor,
            width: (hasError || hasSuccess) ? 1.5 : 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: focusedBorderColor,
            width: 1.5,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}